-- ============================================================================
-- Lethe Logistics: Row Level Security (RLS)
-- ----------------------------------------------------------------------------
-- Makes the DATABASE decide what each signed-in user may read and change, so
-- the five portals stay separated even if someone calls the Data API directly
-- with the publishable key (which is public by design).
--
-- HOW TO APPLY   Supabase Dashboard -> SQL Editor -> paste this whole file -> Run.
--                It runs in one transaction (all or nothing) and is safe to run
--                again. The last result lists every table and its policy count.
-- HOW TO UNDO    Run supabase/rls_rollback.sql (back to the open state).
-- ORDER          Works before or after supabase/fixes.sql.
--
-- WHO SEES WHAT  ("portal" = how the app routes a user; see lethe_rls.my_portal)
--   Everyone signed in (active user, active organisation) reads the shared
--   reference data: organisations, roles, the user directory (never password
--   hashes), medicines and their specs, the batch registry, warehouses, storage
--   zones, sensor readings, vehicles and recalls.
--
--   Manufacturer  writes the catalog; registers, QCs and recalls ITS OWN batches;
--                 assesses, refunds, restocks and disposes returns of its batches;
--                 reads orders, stock, movements and losses that involve its batches.
--   Distributor   runs warehousing (zones, sensor readings, stock movements,
--                 quarantine), approves and dispatches orders (never marks them
--                 Delivered), moves returns in transit, manages the fleet.
--   Retailer      places, cancels and receives ITS OWN orders, files returns for
--                 stock it received (or that is under recall), acknowledges recall
--                 notices sent to it, reads its own invoices and refunds.
--   Compliance    reads everything, changes nothing.
--   SysAdmin      reads everything; manages organisations, users, roles and
--                 permissions only (no supply-chain writes).
--   Nobody        edits inventory directly (only via stock movements), changes
--                 the audit ledger, writes payments or losses (triggers do), or
--                 reads anything at all without signing in.
--
-- Deactivated users and suspended organisations lose access here too (they can
-- still read their own profile, so the app can tell them why).
--
-- Every table has at most one policy per action. Each policy is a CASE on the
-- caller's portal, so it reads like a permission table.
--
-- Database triggers run with their owner's rights (SECURITY DEFINER), so the
-- automation (audit trail, invoices, quarantine, stock sync) keeps working for
-- every role. If you edit a trigger function later, re-run this file.
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- 1. Helper functions (private schema, not reachable through the Data API)
-- ----------------------------------------------------------------------------
-- They run as their owner so policies can look things up without tripping over
-- RLS themselves (which would otherwise recurse).

CREATE SCHEMA IF NOT EXISTS lethe_rls;
COMMENT ON SCHEMA lethe_rls IS 'Lethe row-level-security helpers. Do not add this schema to the exposed API schemas.';

-- Which portal the signed-in user belongs to. Mirrors resolvePortal() in the app:
--   'admin'                                      role Admin (even if their org is inactive)
--   'manufacturer' | 'distributor' | 'retailer'  from the organisation type
--   'compliance'                                 organisation type Regulatory_Body
--   'member'                                     active, but no portal (e.g. a Transporter)
--   NULL                                         signed out, deactivated or suspended
CREATE OR REPLACE FUNCTION lethe_rls.my_portal()
RETURNS text
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT CASE
           WHEN r.role_name = 'Admin' THEN 'admin'
           WHEN o.org_id IS NULL OR o.is_active IS NOT TRUE THEN NULL
           WHEN o.org_type = 'Manufacturer' THEN 'manufacturer'
           WHEN o.org_type = 'Distributor' THEN 'distributor'
           WHEN o.org_type = 'Retailer' THEN 'retailer'
           WHEN o.org_type = 'Regulatory_Body' THEN 'compliance'
           ELSE 'member'
         END
  FROM identity_mod.users u
  LEFT JOIN identity_mod.roles r ON r.role_id = u.role_id
  LEFT JOIN identity_mod.organisations o ON o.org_id = u.org_id
  WHERE u.user_id = auth.uid()
    AND u.is_active IS TRUE
$$;

-- The signed-in user's organisation, only while they are allowed in.
CREATE OR REPLACE FUNCTION lethe_rls.my_org()
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT u.org_id
  FROM identity_mod.users u
  WHERE u.user_id = auth.uid()
    AND lethe_rls.my_portal() IS NOT NULL
$$;

-- The signed-in user's organisation whatever its status. Only used so a blocked
-- user can still load their own profile and see why they were blocked.
CREATE OR REPLACE FUNCTION lethe_rls.my_home_org()
RETURNS uuid
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT u.org_id FROM identity_mod.users u WHERE u.user_id = auth.uid()
$$;

-- Users who belong to the signed-in user's organisation.
CREATE OR REPLACE FUNCTION lethe_rls.my_org_users()
RETURNS SETOF uuid
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT u.user_id
  FROM identity_mod.users u
  WHERE u.org_id = lethe_rls.my_org()
$$;

-- Batches manufactured by the signed-in user's organisation.
CREATE OR REPLACE FUNCTION lethe_rls.my_batches()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT b.batch_id
  FROM product_and_batch_intelligence.batch_master b
  WHERE b.manufacturer_id = lethe_rls.my_org()
$$;

-- Batches a pharmacy may buy: Released and not past expiry.
CREATE OR REPLACE FUNCTION lethe_rls.sellable_batches()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT b.batch_id
  FROM product_and_batch_intelligence.batch_master b
  WHERE b.status = 'Released'
    AND b.expiry_date >= current_date
$$;

-- Orders placed by the signed-in user's organisation (optionally in one status).
CREATE OR REPLACE FUNCTION lethe_rls.my_orders(p_status text DEFAULT NULL)
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT o.order_id
  FROM forward_fulfillment.sales_orders o
  WHERE o.buyer_org_id = lethe_rls.my_org()
    AND (p_status IS NULL OR o.order_status = p_status)
$$;

-- Orders that contain at least one batch made by the signed-in user's organisation.
CREATE OR REPLACE FUNCTION lethe_rls.orders_with_my_batches()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT DISTINCT oi.order_id
  FROM forward_fulfillment.order_items oi
  WHERE oi.batch_id IN (SELECT lethe_rls.my_batches())
$$;

-- Batches the signed-in organisation may send back: everything delivered to it,
-- plus any batch under an active recall.
CREATE OR REPLACE FUNCTION lethe_rls.returnable_batches()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT DISTINCT x.batch_id
  FROM (
    SELECT oi.batch_id
    FROM forward_fulfillment.order_items oi
    JOIN forward_fulfillment.sales_orders o ON o.order_id = oi.order_id
    WHERE o.buyer_org_id = lethe_rls.my_org()
      AND o.order_status = 'Delivered'
    UNION
    SELECT r.batch_id
    FROM reverse_logistics.global_recall_ledger r
    WHERE r.quarantine_status = 'Active'
  ) x
$$;

-- Recalls the signed-in organisation is responsible for: the ones it started,
-- plus any recall of a batch it made.
CREATE OR REPLACE FUNCTION lethe_rls.my_recalls()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT r.recall_id
  FROM reverse_logistics.global_recall_ledger r
  WHERE r.initiated_by_org_id = lethe_rls.my_org()
     OR r.batch_id IN (SELECT lethe_rls.my_batches())
$$;

-- Returns filed by the signed-in user's organisation.
CREATE OR REPLACE FUNCTION lethe_rls.my_returns()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT r.return_id
  FROM reverse_logistics.return_requests r
  WHERE r.returner_org_id = lethe_rls.my_org()
$$;

-- Returns of batches made by the signed-in user's organisation.
CREATE OR REPLACE FUNCTION lethe_rls.returns_of_my_batches()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT r.return_id
  FROM reverse_logistics.return_requests r
  WHERE r.batch_id IN (SELECT lethe_rls.my_batches())
$$;

-- Inspections of returns of batches made by the signed-in user's organisation.
CREATE OR REPLACE FUNCTION lethe_rls.assessments_of_my_batches()
RETURNS SETOF bigint
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT a.assessment_id
  FROM reverse_logistics.return_stock_assessments a
  WHERE a.return_id IN (SELECT lethe_rls.returns_of_my_batches())
$$;

-- Units stored per storage zone, with no batch detail. A manufacturer restocking
-- a return needs free capacity even though it only sees its own stock rows.
CREATE OR REPLACE FUNCTION lethe_rls.location_load()
RETURNS TABLE (location_id bigint, units_stored bigint)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT i.location_id, sum(i.available_quantity)::bigint
  FROM smart_warehousing.inventory i
  WHERE lethe_rls.my_portal() IS NOT NULL
  GROUP BY i.location_id
$$;

REVOKE ALL ON SCHEMA lethe_rls FROM PUBLIC;
GRANT USAGE ON SCHEMA lethe_rls TO authenticated, service_role;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA lethe_rls FROM PUBLIC;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA lethe_rls TO authenticated, service_role;


-- ----------------------------------------------------------------------------
-- 2. Trigger functions run with owner rights
-- ----------------------------------------------------------------------------
-- Triggers such as fn_sync_inventory_on_movement, fn_auto_generate_invoice or
-- fn_monitor_temperature_breach write to tables the acting user may not touch
-- (inventory, payments, quarantine, audit log). Trigger functions cannot be
-- called through the API, so this grants nothing extra to anyone.
DO $$
DECLARE f regprocedure;
BEGIN
  FOR f IN
    SELECT p.oid::regprocedure
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                        'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
      AND p.prorettype = 'trigger'::regtype
  LOOP
    EXECUTE format('ALTER FUNCTION %s SECURITY DEFINER SET search_path = pg_catalog, public, extensions, pg_temp', f);
  END LOOP;
END $$;


-- ----------------------------------------------------------------------------
-- 3. Views
-- ----------------------------------------------------------------------------
-- The analytics views now apply the caller's RLS (a manufacturer's cost of
-- non-compliance only covers its own recalls; compliance still sees all).
ALTER VIEW financial_analytics.vw_cold_chain_violations SET (security_invoker = true);
ALTER VIEW financial_analytics.vw_compliance_risk_heatmap SET (security_invoker = true);
ALTER VIEW financial_analytics.vw_cost_of_non_compliance SET (security_invoker = true);

-- Capacity per storage zone for the app (totals only, see lethe_rls.location_load).
CREATE OR REPLACE VIEW smart_warehousing.vw_location_load
WITH (security_invoker = true) AS
  SELECT l.location_id, l.units_stored FROM lethe_rls.location_load() l;
COMMENT ON VIEW smart_warehousing.vw_location_load IS 'Total units stored per storage location (no batch detail), for capacity checks.';


-- ----------------------------------------------------------------------------
-- 4. Privileges
-- ----------------------------------------------------------------------------
-- anon (not signed in) gets nothing. authenticated gets plain read/write on
-- tables, and RLS below decides which rows. service_role keeps full access.
DO $$
DECLARE
  s text;
  t record;
BEGIN
  FOREACH s IN ARRAY ARRAY['identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                           'forward_fulfillment', 'reverse_logistics', 'financial_analytics'] LOOP
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO authenticated, service_role', s);
    EXECUTE format('REVOKE ALL ON SCHEMA %I FROM anon, PUBLIC', s);
    EXECUTE format('REVOKE ALL ON ALL TABLES IN SCHEMA %I FROM anon, PUBLIC', s);
    EXECUTE format('REVOKE ALL ON ALL SEQUENCES IN SCHEMA %I FROM anon, PUBLIC', s);
    EXECUTE format('REVOKE ALL ON ALL ROUTINES IN SCHEMA %I FROM anon', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I REVOKE ALL ON TABLES FROM anon', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I REVOKE ALL ON SEQUENCES FROM anon', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I REVOKE ALL ON FUNCTIONS FROM anon', s);
    EXECUTE format('GRANT ALL ON ALL TABLES IN SCHEMA %I TO service_role', s);
    EXECUTE format('GRANT ALL ON ALL SEQUENCES IN SCHEMA %I TO service_role', s);
    EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I TO authenticated', s);
    FOR t IN
      SELECT c.relname, c.relkind
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = s AND c.relkind IN ('r', 'p', 'v')
    LOOP
      EXECUTE format('REVOKE ALL ON %I.%I FROM authenticated', s, t.relname);
      IF t.relkind = 'v' THEN
        EXECUTE format('GRANT SELECT ON %I.%I TO authenticated', s, t.relname);
      ELSE
        EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON %I.%I TO authenticated', s, t.relname);
      END IF;
    END LOOP;
  END LOOP;
END $$;

-- Password hashes are never readable through the API (every other column is).
REVOKE SELECT ON identity_mod.users FROM authenticated;
DO $$
DECLARE cols text;
BEGIN
  SELECT string_agg(quote_ident(column_name), ', ' ORDER BY ordinal_position) INTO cols
  FROM information_schema.columns
  WHERE table_schema = 'identity_mod' AND table_name = 'users' AND column_name <> 'password_hash';
  EXECUTE format('GRANT SELECT (%s) ON identity_mod.users TO authenticated', cols);
END $$;


-- ----------------------------------------------------------------------------
-- 5. Switch RLS on everywhere and clear any older policies
-- ----------------------------------------------------------------------------
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT n.nspname, c.relname
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                        'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
      AND c.relkind IN ('r', 'p')
  LOOP
    EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', r.nspname, r.relname);
  END LOOP;

  FOR r IN
    SELECT schemaname, tablename, policyname
    FROM pg_policies
    WHERE schemaname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                         'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
  LOOP
    EXECUTE format('DROP POLICY %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
  END LOOP;
END $$;


-- ----------------------------------------------------------------------------
-- 6. Policies: identity_mod
-- ----------------------------------------------------------------------------

-- organisations: a shared directory; only admins onboard or suspend.
CREATE POLICY "organisations: read" ON identity_mod.organisations
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL
         OR org_id = (SELECT lethe_rls.my_home_org()));        -- a blocked user sees why
CREATE POLICY "organisations: insert" ON identity_mod.organisations
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');
CREATE POLICY "organisations: update" ON identity_mod.organisations
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'admin')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');

-- roles: readable by any signed-in user (the app embeds the role in the profile).
CREATE POLICY "roles: read" ON identity_mod.roles
  FOR SELECT TO authenticated
  USING (true);
CREATE POLICY "roles: insert" ON identity_mod.roles
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');
CREATE POLICY "roles: update" ON identity_mod.roles
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'admin')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');

-- permissions and role_permissions: the RBAC matrix.
CREATE POLICY "permissions: read" ON identity_mod.permissions
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IN ('admin', 'compliance'));
CREATE POLICY "permissions: insert" ON identity_mod.permissions
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');
CREATE POLICY "permissions: update" ON identity_mod.permissions
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'admin')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');

CREATE POLICY "role grants: read" ON identity_mod.role_permissions
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IN ('admin', 'compliance'));
CREATE POLICY "role grants: insert" ON identity_mod.role_permissions
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');
CREATE POLICY "role grants: delete" ON identity_mod.role_permissions
  FOR DELETE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'admin');

-- users: a shared directory (password_hash is also column-protected, section 4).
CREATE POLICY "users: read" ON identity_mod.users
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL
         OR user_id = (SELECT auth.uid()));                    -- a blocked user sees why
CREATE POLICY "users: insert" ON identity_mod.users
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');
CREATE POLICY "users: update" ON identity_mod.users
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'admin')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'admin');

-- user_sessions: sign-in opens one, sign-out closes it.
CREATE POLICY "sessions: read" ON identity_mod.user_sessions
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid())
         OR (SELECT lethe_rls.my_portal()) IN ('admin', 'compliance'));
CREATE POLICY "sessions: insert" ON identity_mod.user_sessions
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid())
              AND (SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "sessions: update" ON identity_mod.user_sessions
  FOR UPDATE TO authenticated                                  -- closing is always allowed
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

-- auth_audit_logs: append-only (the immutability trigger stays in place).
CREATE POLICY "audit log: read" ON identity_mod.auth_audit_logs
  FOR SELECT TO authenticated
  USING (CASE
           WHEN (SELECT lethe_rls.my_portal()) IN ('admin', 'compliance') THEN true
           WHEN (SELECT lethe_rls.my_portal()) IS NULL THEN false
           -- everyone else: entries by their own organisation, plus batch and
           -- recall events, which the whole chain shares for traceability
           ELSE user_id IN (SELECT lethe_rls.my_org_users())
                OR action_type IN ('BATCH_CREATED', 'BATCH_STATUS_CHANGE', 'GLOBAL_RECALL_INITIATED')
         END);
CREATE POLICY "audit log: insert" ON identity_mod.auth_audit_logs
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) IS NOT NULL
              AND user_id = (SELECT auth.uid()));              -- only in your own name
-- No row may ever change. This lets an UPDATE reach tr_protect_audit_logs (so the
-- app's tamper test gets its clear error), and WITH CHECK (false) still blocks it
-- if that trigger were ever dropped. There is deliberately no DELETE policy.
CREATE POLICY "audit log: update (always refused)" ON identity_mod.auth_audit_logs
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (false);


-- ----------------------------------------------------------------------------
-- 7. Policies: product_and_batch_intelligence
-- ----------------------------------------------------------------------------
-- The catalog has no owner column, so any manufacturer curates it.

CREATE POLICY "medicines: read" ON product_and_batch_intelligence.medicines
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "medicines: insert" ON product_and_batch_intelligence.medicines
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');
CREATE POLICY "medicines: update" ON product_and_batch_intelligence.medicines
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');
-- (rolls back a half-added medicine; the batch foreign key still refuses to
-- delete any medicine that has batches)
CREATE POLICY "medicines: delete" ON product_and_batch_intelligence.medicines
  FOR DELETE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer');

CREATE POLICY "compositions: read" ON product_and_batch_intelligence.chemical_compositions
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "compositions: insert" ON product_and_batch_intelligence.chemical_compositions
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');
CREATE POLICY "compositions: update" ON product_and_batch_intelligence.chemical_compositions
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');

CREATE POLICY "packaging standards: read" ON product_and_batch_intelligence.packaging_standards
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "packaging standards: insert" ON product_and_batch_intelligence.packaging_standards
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');
CREATE POLICY "packaging standards: update" ON product_and_batch_intelligence.packaging_standards
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');

CREATE POLICY "quality specs: read" ON product_and_batch_intelligence.quality_check_specs
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "quality specs: insert" ON product_and_batch_intelligence.quality_check_specs
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');
CREATE POLICY "quality specs: update" ON product_and_batch_intelligence.quality_check_specs
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer');

-- batch_master: the registry is shared; only the maker writes its own batches.
CREATE POLICY "batches: read" ON product_and_batch_intelligence.batch_master
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "batches: insert" ON product_and_batch_intelligence.batch_master
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND manufacturer_id = (SELECT lethe_rls.my_org())
              AND registered_by_user_id = (SELECT auth.uid())
              AND status = 'Pending');                         -- every batch starts Pending
CREATE POLICY "batches: update" ON product_and_batch_intelligence.batch_master
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer'
         AND manufacturer_id = (SELECT lethe_rls.my_org()))
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND manufacturer_id = (SELECT lethe_rls.my_org()));


-- ----------------------------------------------------------------------------
-- 8. Policies: smart_warehousing
-- ----------------------------------------------------------------------------
-- Warehouses have no owning organisation (only a manager user), so the
-- distributor portal runs all of them.

CREATE POLICY "warehouses: read" ON smart_warehousing.warehouse
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "warehouses: insert" ON smart_warehousing.warehouse
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');
CREATE POLICY "warehouses: update" ON smart_warehousing.warehouse
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'distributor')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');

CREATE POLICY "storage zones: read" ON smart_warehousing.storage_location
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "storage zones: insert" ON smart_warehousing.storage_location
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');
CREATE POLICY "storage zones: update" ON smart_warehousing.storage_location
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'distributor')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');

CREATE POLICY "sensor readings: read" ON smart_warehousing.environmental_sensor_logs
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "sensor readings: insert" ON smart_warehousing.environmental_sensor_logs
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');

-- inventory: nobody writes it directly; stock only changes through a recorded
-- stock movement (the tr_sync_inventory_on_movement trigger).
CREATE POLICY "inventory: read" ON smart_warehousing.inventory
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
           WHEN 'retailer'     THEN batch_id IN (SELECT lethe_rls.sellable_batches())
           ELSE false
         END);

-- stock_movement_history: append-only.
CREATE POLICY "stock movements: read" ON smart_warehousing.stock_movement_history
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
           ELSE false
         END);
CREATE POLICY "stock movements: insert" ON smart_warehousing.stock_movement_history
  FOR INSERT TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid())                    -- always in your own name
              AND CASE (SELECT lethe_rls.my_portal())
                    WHEN 'distributor'  THEN true
                    -- restocking a returned batch of its own
                    WHEN 'manufacturer' THEN movement_type = 'Inbound'
                                             AND source_location_id IS NULL
                                             AND batch_id IN (SELECT lethe_rls.my_batches())
                    ELSE false
                  END);

-- quarantine_area_logs: only the temperature-breach trigger opens a quarantine.
CREATE POLICY "quarantine: read" ON smart_warehousing.quarantine_area_logs
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
           ELSE false
         END);
CREATE POLICY "quarantine: update" ON smart_warehousing.quarantine_area_logs
  FOR UPDATE TO authenticated                                  -- clear or destroy
  USING ((SELECT lethe_rls.my_portal()) = 'distributor' AND status = 'Active')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor' AND status IN ('Cleared', 'Destroyed'));


-- ----------------------------------------------------------------------------
-- 9. Policies: forward_fulfillment
-- ----------------------------------------------------------------------------
-- Orders have a buyer but no seller column, so the distributor portal fulfils
-- every order. Shipped and Delivered are only ever set by triggers (manifest
-- created / receipt signed).

CREATE POLICY "fleet: read" ON forward_fulfillment.vehicle_fleet_registry
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "fleet: insert" ON forward_fulfillment.vehicle_fleet_registry
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');
CREATE POLICY "fleet: update" ON forward_fulfillment.vehicle_fleet_registry
  FOR UPDATE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'distributor')
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor');

-- sales_orders
CREATE POLICY "orders: read" ON forward_fulfillment.sales_orders
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'retailer'     THEN buyer_org_id = (SELECT lethe_rls.my_org())
           WHEN 'manufacturer' THEN order_id IN (SELECT lethe_rls.orders_with_my_batches())
           ELSE false
         END);
CREATE POLICY "orders: insert" ON forward_fulfillment.sales_orders
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'retailer'
              AND buyer_org_id = (SELECT lethe_rls.my_org())
              AND order_status = 'Pending');
CREATE POLICY "orders: update" ON forward_fulfillment.sales_orders
  FOR UPDATE TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'retailer'    THEN buyer_org_id = (SELECT lethe_rls.my_org())
                                   AND order_status = 'Pending'
           WHEN 'distributor' THEN order_status IN ('Pending', 'Approved')
           ELSE false
         END)
  WITH CHECK (CASE (SELECT lethe_rls.my_portal())
                WHEN 'retailer'    THEN buyer_org_id = (SELECT lethe_rls.my_org())
                                        AND order_status IN ('Pending', 'Cancelled')   -- cancel
                WHEN 'distributor' THEN order_status IN ('Pending', 'Approved', 'Cancelled')
                ELSE false
              END);
-- (rolls back an order whose lines were refused)
CREATE POLICY "orders: delete" ON forward_fulfillment.sales_orders
  FOR DELETE TO authenticated
  USING ((SELECT lethe_rls.my_portal()) = 'retailer'
         AND buyer_org_id = (SELECT lethe_rls.my_org())
         AND order_status = 'Pending');

-- order_items
CREATE POLICY "order lines: read" ON forward_fulfillment.order_items
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'retailer'     THEN order_id IN (SELECT lethe_rls.my_orders())
           WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
           ELSE false
         END);
CREATE POLICY "order lines: insert" ON forward_fulfillment.order_items
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'retailer'
              AND order_id IN (SELECT lethe_rls.my_orders('Pending')));

-- shipping_manifest
CREATE POLICY "shipments: read" ON forward_fulfillment.shipping_manifest
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'retailer'     THEN order_id IN (SELECT lethe_rls.my_orders())
           WHEN 'manufacturer' THEN order_id IN (SELECT lethe_rls.orders_with_my_batches())
           ELSE false
         END);
CREATE POLICY "shipments: insert" ON forward_fulfillment.shipping_manifest
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'distributor'
              AND manifest_status = 'In-Transit');
CREATE POLICY "shipments: update" ON forward_fulfillment.shipping_manifest
  FOR UPDATE TO authenticated
  USING (manifest_status IN ('In-Transit', 'Delayed')
         AND CASE (SELECT lethe_rls.my_portal())
               WHEN 'distributor' THEN true
               WHEN 'retailer'    THEN order_id IN (SELECT lethe_rls.my_orders())
               ELSE false
             END)
  WITH CHECK (CASE (SELECT lethe_rls.my_portal())
                -- the distributor flags delays but never confirms delivery
                WHEN 'distributor' THEN manifest_status IN ('In-Transit', 'Delayed')
                -- only the buyer confirms delivery
                WHEN 'retailer'    THEN order_id IN (SELECT lethe_rls.my_orders())
                                        AND manifest_status = 'Delivered'
                ELSE false
              END);

-- delivery_proof_receipt: signing it marks the order Delivered and raises the invoice.
CREATE POLICY "receipts: read" ON forward_fulfillment.delivery_proof_receipt
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'retailer'     THEN order_id IN (SELECT lethe_rls.my_orders())
           WHEN 'manufacturer' THEN order_id IN (SELECT lethe_rls.orders_with_my_batches())
           ELSE false
         END);
CREATE POLICY "receipts: insert" ON forward_fulfillment.delivery_proof_receipt
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'retailer'
              AND order_id IN (SELECT lethe_rls.my_orders('Shipped'))
              AND received_by_user_id = (SELECT auth.uid()));


-- ----------------------------------------------------------------------------
-- 10. Policies: reverse_logistics
-- ----------------------------------------------------------------------------

-- global_recall_ledger: recalls are public safety notices.
CREATE POLICY "recalls: read" ON reverse_logistics.global_recall_ledger
  FOR SELECT TO authenticated
  USING ((SELECT lethe_rls.my_portal()) IS NOT NULL);
CREATE POLICY "recalls: insert" ON reverse_logistics.global_recall_ledger
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND initiated_by_org_id = (SELECT lethe_rls.my_org())
              AND batch_id IN (SELECT lethe_rls.my_batches()));
CREATE POLICY "recalls: update" ON reverse_logistics.global_recall_ledger
  FOR UPDATE TO authenticated                                  -- resolve or cancel
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer'
         AND (initiated_by_org_id = (SELECT lethe_rls.my_org())
              OR batch_id IN (SELECT lethe_rls.my_batches())))
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND (initiated_by_org_id = (SELECT lethe_rls.my_org())
                   OR batch_id IN (SELECT lethe_rls.my_batches())));

-- recall_communication_logs
CREATE POLICY "recall notices: read" ON reverse_logistics.recall_communication_logs
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN recall_id IN (SELECT lethe_rls.my_recalls())
                                    OR notified_org_id = (SELECT lethe_rls.my_org())
           ELSE notified_org_id = (SELECT lethe_rls.my_org())  -- notices sent to you
         END);
CREATE POLICY "recall notices: insert" ON reverse_logistics.recall_communication_logs
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND recall_id IN (SELECT lethe_rls.my_recalls()));
CREATE POLICY "recall notices: update" ON reverse_logistics.recall_communication_logs
  FOR UPDATE TO authenticated                                  -- the recipient acknowledges
  USING (notified_org_id = (SELECT lethe_rls.my_org()))
  WITH CHECK (notified_org_id = (SELECT lethe_rls.my_org())
              AND delivery_status = 'Read');

-- return_requests (no distributor column, so the distributor portal moves
-- every return in transit)
CREATE POLICY "returns: read" ON reverse_logistics.return_requests
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
                                    OR returner_org_id = (SELECT lethe_rls.my_org())
           ELSE returner_org_id = (SELECT lethe_rls.my_org())  -- returns you filed
         END);
CREATE POLICY "returns: insert" ON reverse_logistics.return_requests
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'retailer'
              AND returner_org_id = (SELECT lethe_rls.my_org())
              AND status = 'Initiated'
              AND batch_id IN (SELECT lethe_rls.returnable_batches()));
CREATE POLICY "returns: update" ON reverse_logistics.return_requests
  FOR UPDATE TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN status IN ('Initiated', 'In_Transit')
           WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
           ELSE false
         END)
  WITH CHECK (CASE (SELECT lethe_rls.my_portal())
                WHEN 'distributor'  THEN status IN ('In_Transit', 'Received')
                WHEN 'manufacturer' THEN batch_id IN (SELECT lethe_rls.my_batches())
                                         AND status IN ('Assessed', 'Closed')
                ELSE false
              END);

-- return_stock_assessments
CREATE POLICY "inspections: read" ON reverse_logistics.return_stock_assessments
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN return_id IN (SELECT lethe_rls.returns_of_my_batches())
                                    OR return_id IN (SELECT lethe_rls.my_returns())
           ELSE return_id IN (SELECT lethe_rls.my_returns())
         END);
CREATE POLICY "inspections: insert" ON reverse_logistics.return_stock_assessments
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND return_id IN (SELECT lethe_rls.returns_of_my_batches())
              AND inspector_user_id = (SELECT auth.uid()));

-- refund_vouchers
CREATE POLICY "refunds: read" ON reverse_logistics.refund_vouchers
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN return_id IN (SELECT lethe_rls.returns_of_my_batches())
                                    OR return_id IN (SELECT lethe_rls.my_returns())
           ELSE return_id IN (SELECT lethe_rls.my_returns())
         END);
CREATE POLICY "refunds: insert" ON reverse_logistics.refund_vouchers
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND return_id IN (SELECT lethe_rls.returns_of_my_batches())
              AND refund_status = 'Pending_Payout');
CREATE POLICY "refunds: update" ON reverse_logistics.refund_vouchers
  FOR UPDATE TO authenticated                                  -- pay out
  USING ((SELECT lethe_rls.my_portal()) = 'manufacturer'
         AND return_id IN (SELECT lethe_rls.returns_of_my_batches()))
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND return_id IN (SELECT lethe_rls.returns_of_my_batches()));

-- disposal_certificates
CREATE POLICY "disposals: read" ON reverse_logistics.disposal_certificates
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'distributor'  THEN true
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN assessment_id IN (SELECT lethe_rls.assessments_of_my_batches())
           ELSE false
         END);
CREATE POLICY "disposals: insert" ON reverse_logistics.disposal_certificates
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT lethe_rls.my_portal()) = 'manufacturer'
              AND assessment_id IN (SELECT lethe_rls.assessments_of_my_batches())
              AND witness_user_id = (SELECT auth.uid()));


-- ----------------------------------------------------------------------------
-- 11. Policies: financial_analytics
-- ----------------------------------------------------------------------------
-- Payments come only from the delivery-receipt trigger and losses only from the
-- disposal trigger, so nobody can write those tables.

CREATE POLICY "payments: read" ON financial_analytics.payment_ledger
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'compliance' THEN true
           WHEN 'admin'      THEN true
           ELSE payer_org_id = (SELECT lethe_rls.my_org())     -- payments you made
                OR payee_org_id = (SELECT lethe_rls.my_org())  -- or received
         END);

CREATE POLICY "reports: read" ON financial_analytics.financial_aggregate
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'compliance' THEN true
           WHEN 'admin'      THEN true
           ELSE org_id = (SELECT lethe_rls.my_org())
         END);
-- (sp_generate_monthly_report runs with the caller's rights, so this applies to it)
CREATE POLICY "reports: insert" ON financial_analytics.financial_aggregate
  FOR INSERT TO authenticated
  WITH CHECK (org_id = (SELECT lethe_rls.my_org())
              AND generated_by_user_id = (SELECT auth.uid()));

CREATE POLICY "losses: read" ON financial_analytics.loss_analytics_data
  FOR SELECT TO authenticated
  USING (CASE (SELECT lethe_rls.my_portal())
           WHEN 'compliance'   THEN true
           WHEN 'admin'        THEN true
           WHEN 'manufacturer' THEN org_id = (SELECT lethe_rls.my_org())
                                    OR batch_id IN (SELECT lethe_rls.my_batches())
           ELSE org_id = (SELECT lethe_rls.my_org())
         END);


-- ----------------------------------------------------------------------------
-- 12. Legacy tables in the public schema
-- ----------------------------------------------------------------------------
-- public.financial_aggregate and public.payment_ledger are leftovers from the
-- Streamlit version. The React app does not use them, but the public schema is
-- exposed by default, so anyone could read or edit them. Lock them (no
-- policies = no API access) rather than deleting data.
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['financial_aggregate', 'payment_ledger'] LOOP
    IF to_regclass(format('public.%I', t)) IS NOT NULL THEN
      EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
      EXECUTE format('REVOKE ALL ON public.%I FROM anon, authenticated', t);
    END IF;
  END LOOP;
END $$;

COMMIT;


-- ----------------------------------------------------------------------------
-- Result: every Lethe table, whether RLS is on, and how many policies it has.
-- ----------------------------------------------------------------------------
SELECT n.nspname AS schema,
       c.relname AS table_name,
       c.relrowsecurity AS rls_enabled,
       (SELECT count(*) FROM pg_policies p WHERE p.schemaname = n.nspname AND p.tablename = c.relname) AS policies
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r', 'p')
  AND (n.nspname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                     'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
       OR (n.nspname = 'public' AND c.relname IN ('financial_aggregate', 'payment_ledger')))
ORDER BY 1, 2;
