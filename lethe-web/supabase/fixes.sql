-- ============================================================================
-- Lethe Logistics: OPTIONAL database fixes
-- ----------------------------------------------------------------------------
-- The React app works without these. They fix bugs found while reading
-- dump.sql and testing against a copy of the live data. Run them in Supabase
-- Dashboard -> SQL Editor if you want them. Each statement is CREATE OR
-- REPLACE, so it is safe to run more than once, before or after rls.sql
-- (trigger functions are declared SECURITY DEFINER, exactly as rls.sql sets
-- them, so running this file never undoes the RLS setup).
-- ============================================================================


-- 1) Spec-tampering trigger writes to columns that do not exist --------------
-- fn_audit_spec_tampering inserts into (event_type, module_source, description,
-- severity), but identity_mod.auth_audit_logs has (action_type, source_module,
-- event_payload). Today ANY update to a medicine's purity or pH fails with
-- "column event_type does not exist". This version logs it correctly, and
-- records who made the change (auth.uid() is the signed-in user, or NULL
-- when the change comes from the SQL Editor).
CREATE OR REPLACE FUNCTION product_and_batch_intelligence.fn_audit_spec_tampering()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, extensions, pg_temp
AS $$
BEGIN
    IF OLD.purity_threshold IS DISTINCT FROM NEW.purity_threshold
       OR OLD.ph_balance_req IS DISTINCT FROM NEW.ph_balance_req THEN
        INSERT INTO identity_mod.auth_audit_logs (user_id, action_type, source_module, event_payload)
        VALUES (
            auth.uid(),
            'CRITICAL_SPEC_TAMPERING',
            'PRODUCT_INTELLIGENCE',
            jsonb_build_object(
                'severity', 'CRITICAL',
                'medicine_id', NEW.medicine_id,
                'old_purity', OLD.purity_threshold,
                'new_purity', NEW.purity_threshold,
                'old_ph', OLD.ph_balance_req,
                'new_ph', NEW.ph_balance_req,
                'description', 'Lab specs altered for medicine ' || NEW.medicine_id
            )
        );
    END IF;
    RETURN NEW;
END;
$$;


-- 2) check_user_permission joins a table that does not exist -----------------
-- It references identity_mod.role_permission (singular); the table is
-- identity_mod.role_permissions. Calling it currently raises an error.
-- (It runs with the caller's rights, so once rls.sql is applied only admins
-- and compliance, who can read the RBAC tables, get a meaningful answer.)
CREATE OR REPLACE FUNCTION identity_mod.check_user_permission(p_user_id uuid, p_action_name text)
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM identity_mod.users u
        JOIN identity_mod.role_permissions rp ON u.role_id = rp.role_id
        JOIN identity_mod.permissions p ON rp.permission_id = p.permission_id
        WHERE u.user_id = p_user_id
          AND p.action_name = p_action_name
          AND u.is_active = TRUE
    );
$$;


-- 3) Temperature breach on a shelf holding recalled stock fails --------------
-- fn_monitor_temperature_breach sets every batch on the shelf to 'Quality-Check'.
-- If one of them is Recalled or Rejected, tr_enforce_batch_workflow (correctly)
-- refuses, which aborts the whole sensor insert, so the breach is never recorded.
-- This version still quarantines everything but only re-flags live batches.
CREATE OR REPLACE FUNCTION smart_warehousing.fn_monitor_temperature_breach()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, extensions, pg_temp
AS $$
DECLARE
    loc_min_temp NUMERIC;
    loc_max_temp NUMERIC;
    mgr_user_id UUID;
    inv_record RECORD;
BEGIN
    SELECT sl.target_min_temp, sl.target_max_temp, w.manager_user_id
    INTO loc_min_temp, loc_max_temp, mgr_user_id
    FROM smart_warehousing.storage_location sl
    JOIN smart_warehousing.warehouse w ON sl.warehouse_id = w.warehouse_id
    WHERE sl.location_id = NEW.location_id;

    IF NEW.temperature_celsius < loc_min_temp OR NEW.temperature_celsius > loc_max_temp THEN
        FOR inv_record IN
            SELECT batch_id FROM smart_warehousing.inventory
            WHERE location_id = NEW.location_id AND available_quantity > 0
        LOOP
            INSERT INTO smart_warehousing.quarantine_area_logs (
                batch_id, location_id, quarantine_reason, breaching_log_id, action_taken_by, status
            ) VALUES (
                inv_record.batch_id, NEW.location_id, 'Temp Breach', NEW.log_id, mgr_user_id, 'Active'
            );

            UPDATE product_and_batch_intelligence.batch_master
            SET status = 'Quality-Check'
            WHERE batch_id = inv_record.batch_id
              AND status NOT IN ('Rejected', 'Recalled', 'Quality-Check');
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$;


-- 4) Stock cannot leave a shelf that does not suit it ------------------------
-- fn_prevent_env_mismatch and fn_prevent_stock_on_dead_shelf run on EVERY
-- inventory update, including stock being taken away. 14 of the 16 inventory
-- rows in the live data sit on a shelf whose temperature or humidity band does
-- not match the medicine (and one sits on an inactive shelf), so dispatching or
-- moving them fails with "SAFETY LOCK: ... Mismatch". Removing stock is how a
-- mismatch gets fixed, so these versions always allow it and keep every check
-- for stock being added. (Also fixes the "%60.00" humidity message.)
CREATE OR REPLACE FUNCTION smart_warehousing.fn_prevent_env_mismatch()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, extensions, pg_temp
AS $$
DECLARE
    v_shelf_min NUMERIC(5,2);
    v_shelf_max NUMERIC(5,2);
    v_shelf_humidity NUMERIC(5,2);
    v_med_min NUMERIC(5,2);
    v_med_max NUMERIC(5,2);
    v_med_humidity NUMERIC(5,2);
BEGIN
    -- Taking stock off a shelf is always allowed.
    IF TG_OP = 'UPDATE'
       AND NEW.location_id = OLD.location_id
       AND NEW.batch_id = OLD.batch_id
       AND NEW.available_quantity <= OLD.available_quantity THEN
        RETURN NEW;
    END IF;

    SELECT target_min_temp, target_max_temp, target_humidity_limit
    INTO v_shelf_min, v_shelf_max, v_shelf_humidity
    FROM smart_warehousing.storage_location
    WHERE location_id = NEW.location_id;

    SELECT ps.min_temp_celsius, ps.max_temp_celsius, ps.humidity_limit
    INTO v_med_min, v_med_max, v_med_humidity
    FROM product_and_batch_intelligence.batch_master bm
    JOIN product_and_batch_intelligence.packaging_standards ps ON bm.medicine_id = ps.medicine_id
    WHERE bm.batch_id = NEW.batch_id;

    IF v_shelf_min < v_med_min OR v_shelf_max > v_med_max THEN
        RAISE EXCEPTION 'SAFETY LOCK: Temperature Mismatch! Shelf % provides %°C to %°C, but Batch % requires %°C to %°C.',
            NEW.location_id, v_shelf_min, v_shelf_max, NEW.batch_id, v_med_min, v_med_max;
    END IF;

    IF v_shelf_humidity > v_med_humidity THEN
        RAISE EXCEPTION 'SAFETY LOCK: Humidity Mismatch! Shelf % has a baseline humidity of % %%, but the medicine in Batch % degrades above % %%.',
            NEW.location_id, v_shelf_humidity, NEW.batch_id, v_med_humidity;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION smart_warehousing.fn_prevent_stock_on_dead_shelf()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, extensions, pg_temp
AS $$
DECLARE
    v_location_active BOOLEAN;
BEGIN
    -- Taking stock off a shelf is always allowed.
    IF TG_OP = 'UPDATE'
       AND NEW.location_id = OLD.location_id
       AND NEW.available_quantity <= OLD.available_quantity THEN
        RETURN NEW;
    END IF;

    SELECT is_active INTO v_location_active
    FROM smart_warehousing.storage_location
    WHERE location_id = NEW.location_id;

    IF v_location_active = FALSE THEN
        RAISE EXCEPTION 'SAFETY LOCK: Cannot place inventory on location_id %. This storage location is currently inactive and cannot accept stock.', NEW.location_id;
    END IF;

    RETURN NEW;
END;
$$;
