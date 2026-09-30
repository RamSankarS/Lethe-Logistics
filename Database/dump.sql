--
-- PostgreSQL database dump
--

\restrict pGtoyANkhY4BcPUY8FBOeD98vabA1KBdMmadyws2hCW2KwLz5VBt67jWCaEJ9oP

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: financial_analytics; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA financial_analytics;


ALTER SCHEMA financial_analytics OWNER TO postgres;

--
-- Name: forward_fulfillment; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA forward_fulfillment;


ALTER SCHEMA forward_fulfillment OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: identity_mod; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA identity_mod;


ALTER SCHEMA identity_mod OWNER TO postgres;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: product_and_batch_intelligence; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA product_and_batch_intelligence;


ALTER SCHEMA product_and_batch_intelligence OWNER TO postgres;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: reverse_logistics; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA reverse_logistics;


ALTER SCHEMA reverse_logistics OWNER TO postgres;

--
-- Name: smart_warehousing; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA smart_warehousing;


ALTER SCHEMA smart_warehousing OWNER TO postgres;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: account_state; Type: TYPE; Schema: identity_mod; Owner: postgres
--

CREATE TYPE identity_mod.account_state AS ENUM (
    'ACTIVE',
    'LOCKED',
    'SUSPENDED'
);


ALTER TYPE identity_mod.account_state OWNER TO postgres;

--
-- Name: event_category; Type: TYPE; Schema: identity_mod; Owner: postgres
--

CREATE TYPE identity_mod.event_category AS ENUM (
    'AUTH_SUCCESS',
    'AUTH_FAIL',
    'RESOURCE_ACCESS',
    'GOVERNANCE_PUSH'
);


ALTER TYPE identity_mod.event_category OWNER TO postgres;

--
-- Name: org_category; Type: TYPE; Schema: identity_mod; Owner: postgres
--

CREATE TYPE identity_mod.org_category AS ENUM (
    'MANUFACTURER',
    'DISTRIBUTER',
    'RETAILER',
    'AUDITOR'
);


ALTER TYPE identity_mod.org_category OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_realtime_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_realtime_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_realtime_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_realtime_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_realtime_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: fn_auto_generate_invoice(); Type: FUNCTION; Schema: financial_analytics; Owner: postgres
--

CREATE FUNCTION financial_analytics.fn_auto_generate_invoice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_base_amount NUMERIC(12,2);
    v_payer_org UUID;
BEGIN
    -- Only generate an invoice if it was received (Good or Partial)
    IF NEW.received_condition IN ('Good', 'Partial') THEN
        
        -- Calculate total order value from order_items
        -- UPGRADE: COALESCE turns a NULL (empty order) into a safe 0
        SELECT COALESCE(SUM(quantity * unit_price), 0) INTO v_base_amount
        FROM forward_fulfillment.order_items WHERE order_id = NEW.order_id;

        -- UPGRADE: Only generate an invoice if there is actually money to collect!
        IF v_base_amount > 0 THEN
            -- Get the buying organization
            SELECT buyer_org_id INTO v_payer_org
            FROM forward_fulfillment.sales_orders WHERE order_id = NEW.order_id;

            -- Insert the ledger record
            INSERT INTO financial_analytics.payment_ledger 
            (order_id, payer_org_id, payee_org_id, base_amount, tax_percentage, payment_status)
            VALUES 
            (NEW.order_id, v_payer_org, '96a73ed7-bc75-48de-abb6-b1eab134fb26', v_base_amount, 5.00, 'Completed');
        END IF;
        
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION financial_analytics.fn_auto_generate_invoice() OWNER TO postgres;

--
-- Name: fn_log_disposal_loss(); Type: FUNCTION; Schema: financial_analytics; Owner: postgres
--

CREATE FUNCTION financial_analytics.fn_log_disposal_loss() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    v_batch_id BIGINT;
    v_qty_lost INTEGER;
    v_recall_id BIGINT;
    v_org_id UUID;
BEGIN
    -- Get the details from the original return request
    SELECT rr.batch_id, rr.quantity_returned, rr.recall_id, rr.returner_org_id 
    INTO v_batch_id, v_qty_lost, v_recall_id, v_org_id
    FROM reverse_logistics.return_stock_assessments rsa
    JOIN reverse_logistics.return_requests rr ON rsa.return_id = rr.return_id
    WHERE rsa.assessment_id = NEW.assessment_id;

    -- Log the loss (Assuming $50 unit cost for the dummy math)
    -- Note: DB calculates total_financial_loss automatically!
    INSERT INTO financial_analytics.loss_analytics_data 
    (org_id, batch_id, recall_id, quantity_lost, unit_cost_at_loss, loss_category)
    VALUES 
    (v_org_id, v_batch_id, v_recall_id, v_qty_lost, 50.00, 'Disposal');

    RETURN NEW;
END;
$_$;


ALTER FUNCTION financial_analytics.fn_log_disposal_loss() OWNER TO postgres;

--
-- Name: sp_generate_monthly_report(uuid, date, uuid); Type: FUNCTION; Schema: financial_analytics; Owner: postgres
--

CREATE FUNCTION financial_analytics.sp_generate_monthly_report(p_org_id uuid, p_report_date date, p_user_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_total_orders INTEGER;
    v_gross_revenue NUMERIC(14,2);
    v_tax_liability NUMERIC(14,2);
BEGIN
    -- 1. Calculate the totals from the payment_ledger for the given month
    SELECT 
        COUNT(DISTINCT order_id),
        COALESCE(SUM(base_amount), 0),
        -- Tax is the total amount minus the base amount
        COALESCE(SUM(total_transaction_amount - base_amount), 0)
    INTO 
        v_total_orders, v_gross_revenue, v_tax_liability
    FROM financial_analytics.payment_ledger
    WHERE payee_org_id = p_org_id
      -- This ensures we only grab records matching the month and year of the report date
      AND DATE_TRUNC('month', created_at_utc) = DATE_TRUNC('month', p_report_date::timestamp)
      AND payment_status = 'Completed';

    -- 2. Insert the calculated data into the aggregate table
    -- (Remember, the Net Revenue is generated automatically by the table!)
    INSERT INTO financial_analytics.financial_aggregate 
    (org_id, report_date, total_orders, total_gross_revenue, total_tax_liability, generated_by_user_id)
    VALUES 
    (p_org_id, p_report_date, v_total_orders, v_gross_revenue, v_tax_liability, p_user_id);
    
END;
$$;


ALTER FUNCTION financial_analytics.sp_generate_monthly_report(p_org_id uuid, p_report_date date, p_user_id uuid) OWNER TO postgres;

--
-- Name: fn_auto_status_delivered(); Type: FUNCTION; Schema: forward_fulfillment; Owner: postgres
--

CREATE FUNCTION forward_fulfillment.fn_auto_status_delivered() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- When the buyer signs for the delivery, automatically flip the order status to Delivered
    UPDATE forward_fulfillment.sales_orders
    SET order_status = 'Delivered',
        updated_at_utc = NOW()
    WHERE order_id = NEW.order_id;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION forward_fulfillment.fn_auto_status_delivered() OWNER TO postgres;

--
-- Name: fn_auto_status_shipped(); Type: FUNCTION; Schema: forward_fulfillment; Owner: postgres
--

CREATE FUNCTION forward_fulfillment.fn_auto_status_shipped() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- When a truck leaves, automatically flip the order status to Shipped
    UPDATE forward_fulfillment.sales_orders
    SET order_status = 'Shipped',
        updated_at_utc = NOW()
    WHERE order_id = NEW.order_id;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION forward_fulfillment.fn_auto_status_shipped() OWNER TO postgres;

--
-- Name: fn_gatekeep_order_items(); Type: FUNCTION; Schema: forward_fulfillment; Owner: postgres
--

CREATE FUNCTION forward_fulfillment.fn_gatekeep_order_items() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_batch_status VARCHAR;
    v_total_stock INTEGER;
BEGIN
    -- 1. Check the Quality Lock: Is this batch safe to sell?
    SELECT status INTO v_batch_status
    FROM product_and_batch_intelligence.batch_master
    WHERE batch_id = NEW.batch_id;

    IF v_batch_status != 'Released' THEN
        RAISE EXCEPTION 'SAFETY LOCK: Cannot sell Batch %. Current status is %.', NEW.batch_id, v_batch_status;
    END IF;

    -- 2. Check Inventory Levels: Do we actually have enough boxes across all our shelves?
    SELECT COALESCE(SUM(available_quantity), 0) INTO v_total_stock
    FROM smart_warehousing.inventory
    WHERE batch_id = NEW.batch_id;

    IF v_total_stock < NEW.quantity THEN
        RAISE EXCEPTION 'INVENTORY ERROR: Cannot fulfill % boxes of Batch %. Only % boxes are currently available.', NEW.quantity, NEW.batch_id, v_total_stock;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION forward_fulfillment.fn_gatekeep_order_items() OWNER TO postgres;

--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: check_user_permission(uuid, text); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.check_user_permission(p_user_id uuid, p_action_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    has_permission BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM identity_mod.users u
        JOIN identity_mod.role_permission rp ON u.role_id = rp.role_id -- Composite Key Join
        JOIN identity_mod.permissions p ON rp.permission_id = p.permission_id
        WHERE u.user_id = p_user_id
          AND p.action_name = p_action_name
          AND u.is_active = TRUE
    ) INTO has_permission;

    RETURN has_permission;
END;
$$;


ALTER FUNCTION identity_mod.check_user_permission(p_user_id uuid, p_action_name text) OWNER TO postgres;

--
-- Name: fn_log_session_activity(); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.fn_log_session_activity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs (
        log_id,
        user_id,
        action_type,
        ip_address,
        log_time_stamp_utc
    )
    VALUES (
        gen_random_uuid(),
        NEW.user_id,
        'LOGIN_EVENT', -- Based on DFD Process 1.1/1.2 logic
        NEW.ip_address,
        NOW() AT TIME ZONE 'UTC'
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION identity_mod.fn_log_session_activity() OWNER TO postgres;

--
-- Name: fn_log_session_start(); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.fn_log_session_start() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs (user_id, action_type, source_module, ip_address)
    VALUES (NEW.user_id, 'USER_LOGIN_SUCCESS', 'IDENTITY', NEW.ip_address);
    RETURN NEW;
END;
$$;


ALTER FUNCTION identity_mod.fn_log_session_start() OWNER TO postgres;

--
-- Name: fn_log_user_creation(); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.fn_log_user_creation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs (
        log_id,
        user_id,
        action_type,
        source_module,
        log_time_stamp_utc,
        ip_address
    )
    VALUES (
        gen_random_uuid(),
        NEW.user_id,
        -- Using COALESCE prevents the result from being NULL if role_id is missing
        'USER_REGISTRATION: Role ID ' || COALESCE(NEW.role_id::text, 'NOT_ASSIGNED'),
        'IDENTITY',
        NOW() AT TIME ZONE 'UTC',
        '0.0.0.0'
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION identity_mod.fn_log_user_creation() OWNER TO postgres;

--
-- Name: fn_log_user_registration(); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.fn_log_user_registration() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs (user_id, action_type, source_module, ip_address)
    VALUES (NEW.user_id, 'USER_IDENTITY_CREATED', 'IDENTITY', '0.0.0.0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION identity_mod.fn_log_user_registration() OWNER TO postgres;

--
-- Name: fn_make_logs_immutable(); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.fn_make_logs_immutable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION 'Lethe Governance Protocol: Audit logs are immutable and cannot be modified or deleted.';
END;
$$;


ALTER FUNCTION identity_mod.fn_make_logs_immutable() OWNER TO postgres;

--
-- Name: push_governance_event(uuid, text, text); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.push_governance_event(p_user_id uuid, p_action_type text, p_ip_address text DEFAULT '0.0.0.0'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs (
        log_id,
        user_id,
        action_type,
        ip_address,
        log_time_stamp_utc
    )
    VALUES (
        gen_random_uuid(),
        p_user_id,
        p_action_type,
        p_ip_address,
        NOW() AT TIME ZONE 'UTC'
    );
END;
$$;


ALTER FUNCTION identity_mod.push_governance_event(p_user_id uuid, p_action_type text, p_ip_address text) OWNER TO postgres;

--
-- Name: push_governance_event(uuid, text, character varying, jsonb, text); Type: FUNCTION; Schema: identity_mod; Owner: postgres
--

CREATE FUNCTION identity_mod.push_governance_event(p_user_id uuid, p_action_type text, p_source_module character varying, p_payload jsonb DEFAULT NULL::jsonb, p_ip_address text DEFAULT '0.0.0.0'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs (
        user_id, 
        action_type, 
        source_module, 
        event_payload, 
        ip_address
    )
    VALUES (p_user_id, p_action_type, p_source_module, p_payload, p_ip_address);
END;
$$;


ALTER FUNCTION identity_mod.push_governance_event(p_user_id uuid, p_action_type text, p_source_module character varying, p_payload jsonb, p_ip_address text) OWNER TO postgres;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: fn_audit_batch_activity(); Type: FUNCTION; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE FUNCTION product_and_batch_intelligence.fn_audit_batch_activity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Handle new batches being created
    IF TG_OP = 'INSERT' THEN
        INSERT INTO identity_mod.auth_audit_logs (
            action_type, source_module, event_payload, user_id
        ) VALUES (
            'BATCH_CREATED', 
            'PRODUCT_INTELLIGENCE', 
            jsonb_build_object('batch_number', NEW.batch_number, 'status', NEW.status),
            NEW.registered_by_user_id
        );
        
    -- Handle batch status changes (like our Quarantine trigger)
    ELSIF TG_OP = 'UPDATE' AND OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO identity_mod.auth_audit_logs (
            action_type, source_module, event_payload, user_id
        ) VALUES (
            'BATCH_STATUS_CHANGE', 
            'PRODUCT_INTELLIGENCE', 
            jsonb_build_object(
                'batch_number', NEW.batch_number,
                'old_status', OLD.status,
                'new_status', NEW.status,
                'severity', CASE 
                    WHEN NEW.status IN ('Rejected', 'Recalled') THEN 'HIGH' 
                    WHEN NEW.status = 'Released' THEN 'MEDIUM' 
                    ELSE 'LOW' 
                END,
                'description', 'Batch ' || NEW.batch_number || ' status updated from ' || OLD.status || ' to ' || NEW.status
            ),
            NEW.registered_by_user_id
        );
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION product_and_batch_intelligence.fn_audit_batch_activity() OWNER TO postgres;

--
-- Name: fn_audit_batch_status_change(); Type: FUNCTION; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE FUNCTION product_and_batch_intelligence.fn_audit_batch_status_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (OLD.status IS DISTINCT FROM NEW.status) THEN
        PERFORM identity_mod.push_governance_event(
            NEW.registered_by_user_id,
            'BATCH_STATUS_UPDATE: ' || OLD.status || ' -> ' || NEW.status,
            'PRODUCT_INTELLIGENCE',
            jsonb_build_object(
                'batch_id', NEW.batch_id,
                'batch_number', NEW.batch_number,
                'old_status', OLD.status,
                'new_status', NEW.status
            ),
            '0.0.0.0' -- IP can be captured from the app layer
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION product_and_batch_intelligence.fn_audit_batch_status_change() OWNER TO postgres;

--
-- Name: fn_audit_spec_tampering(); Type: FUNCTION; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE FUNCTION product_and_batch_intelligence.fn_audit_spec_tampering() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Only trigger if someone actually lowers the purity or changes the pH
    IF OLD.purity_threshold IS DISTINCT FROM NEW.purity_threshold OR 
       OLD.ph_balance_req IS DISTINCT FROM NEW.ph_balance_req THEN
        
        -- Push the alert to your Governance Logs
        -- (Assuming identity_mod has a table named auth_audit_logs)
        INSERT INTO identity_mod.auth_audit_logs 
        (event_type, module_source, description, severity)
        VALUES (
            'CRITICAL_SPEC_TAMPERING', 
            'PRODUCT_INTELLIGENCE', 
            'Lab specs altered for Medicine ID: ' || NEW.medicine_id || 
            '. Purity changed from ' || OLD.purity_threshold || ' to ' || NEW.purity_threshold,
            'HIGH'
        );
        
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION product_and_batch_intelligence.fn_audit_spec_tampering() OWNER TO postgres;

--
-- Name: fn_enforce_batch_workflow(); Type: FUNCTION; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE FUNCTION product_and_batch_intelligence.fn_enforce_batch_workflow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 1. Prevent skipping the Quality Check
    IF OLD.status = 'Pending' AND NEW.status = 'Released' THEN
        RAISE EXCEPTION 'Governance Violation: Batches must undergo a Quality-Check before being Released.';
    END IF;

    -- 2. Prevent reviving a Dead Batch
    IF OLD.status IN ('Rejected', 'Recalled') AND NEW.status NOT IN ('Rejected', 'Recalled') THEN
        RAISE EXCEPTION 'Governance Violation: A Rejected or Recalled batch cannot be reintroduced to the supply chain.';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION product_and_batch_intelligence.fn_enforce_batch_workflow() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_realtime_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_realtime_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
/*
Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
*/
declare
    op_symbol text = (
        case
            when op = 'eq' then '='
            when op = 'neq' then '!='
            when op = 'lt' then '<'
            when op = 'lte' then '<='
            when op = 'gt' then '>'
            when op = 'gte' then '>='
            when op = 'in' then '= any'
            else 'UNKNOWN OP'
        end
    );
    res boolean;
begin
    execute format(
        'select %L::'|| type_::text || ' ' || op_symbol
        || ' ( %L::'
        || (
            case
                when op = 'in' then type_::text || '[]'
                else type_::text end
        )
        || ')', val_1, val_2) into res;
    return res;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) OWNER TO supabase_realtime_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_realtime_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_realtime_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    new.selected_columns = (
        select array_agg(c order by c)
        from unnest(new.selected_columns) c
    );

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_realtime_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_realtime_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_realtime_admin;

--
-- Name: fn_audit_disposal(); Type: FUNCTION; Schema: reverse_logistics; Owner: postgres
--

CREATE FUNCTION reverse_logistics.fn_audit_disposal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO identity_mod.auth_audit_logs 
    (user_id, action_type, source_module, event_payload, ip_address, log_time_stamp_utc)
    VALUES (
        NEW.witness_user_id, -- We can pull the actual user directly from the table here!
        'DRUGS_DESTROYED', 
        'REVERSE_LOGISTICS', 
        jsonb_build_object(
            'severity', 'HIGH',
            'assessment_id', NEW.assessment_id,
            'disposal_method', NEW.disposal_method
        ),
        '10.0.0.5', -- Warehouse terminal IP
        NOW()
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION reverse_logistics.fn_audit_disposal() OWNER TO postgres;

--
-- Name: fn_audit_global_recall(); Type: FUNCTION; Schema: reverse_logistics; Owner: postgres
--

CREATE FUNCTION reverse_logistics.fn_audit_global_recall() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    admin_user_uuid UUID;
BEGIN
    -- Grab an admin user ID for the log (or use a system default)
    SELECT user_id INTO admin_user_uuid FROM identity_mod.users LIMIT 1;

    INSERT INTO identity_mod.auth_audit_logs 
    (user_id, action_type, source_module, event_payload, ip_address, log_time_stamp_utc)
    VALUES (
        admin_user_uuid,
        'GLOBAL_RECALL_INITIATED', 
        'REVERSE_LOGISTICS', 
        jsonb_build_object(
            'severity', 'CRITICAL',
            'recall_id', NEW.recall_id,
            'batch_id', NEW.batch_id,
            'reason', NEW.recall_reason
        ),
        '10.0.0.1', -- System internal IP
        NOW()
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION reverse_logistics.fn_audit_global_recall() OWNER TO postgres;

--
-- Name: fn_monitor_temperature_breach(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_monitor_temperature_breach() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    loc_min_temp NUMERIC;
    loc_max_temp NUMERIC;
    mgr_user_id UUID;
    inv_record RECORD;
BEGIN
    -- Get the target temperatures and the warehouse manager's ID for this shelf
    SELECT sl.target_min_temp, sl.target_max_temp, w.manager_user_id 
    INTO loc_min_temp, loc_max_temp, mgr_user_id
    FROM smart_warehousing.storage_location sl
    JOIN smart_warehousing.warehouse w ON sl.warehouse_id = w.warehouse_id
    WHERE sl.location_id = NEW.location_id;

    -- Check if the new reading breaches the limits
    IF NEW.temperature_celsius < loc_min_temp OR NEW.temperature_celsius > loc_max_temp THEN
        
        -- Loop through every batch sitting on this shelf that has stock
        FOR inv_record IN 
            SELECT batch_id FROM smart_warehousing.inventory 
            WHERE location_id = NEW.location_id AND available_quantity > 0
        LOOP
            -- 1. Lock it down in quarantine logs [cite: 147]
            INSERT INTO smart_warehousing.quarantine_area_logs (
                batch_id, location_id, quarantine_reason, breaching_log_id, action_taken_by, status
            ) VALUES (
                inv_record.batch_id, NEW.location_id, 'Temp Breach', NEW.log_id, mgr_user_id, 'Active'
            );

            -- 2. Flag the batch status system-wide [cite: 123]
            UPDATE product_and_batch_intelligence.batch_master
            SET status = 'Quality-Check'
            WHERE batch_id = inv_record.batch_id;
        END LOOP;
        
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_monitor_temperature_breach() OWNER TO postgres;

--
-- Name: fn_prevent_active_location_shutdown(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_prevent_active_location_shutdown() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_remaining_stock INTEGER;
BEGIN
    -- We only care if someone is trying to shut down the location (TRUE to FALSE)
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        
        -- Check if there is any stock left in this specific location
        SELECT COALESCE(SUM(available_quantity), 0) INTO v_remaining_stock
        FROM smart_warehousing.inventory
        WHERE location_id = NEW.location_id;

        -- If there are boxes left, block the shutdown!
        IF v_remaining_stock > 0 THEN
            RAISE EXCEPTION 'SAFETY LOCK: Cannot deactivate storage location %. There are still % units of inventory sitting there. Move the stock first.', NEW.location_id, v_remaining_stock;
        END IF;
        
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_prevent_active_location_shutdown() OWNER TO postgres;

--
-- Name: fn_prevent_active_warehouse_shutdown(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_prevent_active_warehouse_shutdown() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_active_zones INTEGER;
BEGIN
    -- We only care if someone is trying to flip it from TRUE to FALSE
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        
        -- Count how many active storage locations are still inside this warehouse
        SELECT COUNT(*) INTO v_active_zones
        FROM smart_warehousing.storage_location
        WHERE warehouse_id = NEW.warehouse_id AND is_active = TRUE;

        -- If there are still active zones, block the shutdown!
        IF v_active_zones > 0 THEN
            RAISE EXCEPTION 'SAFETY LOCK: Cannot deactivate warehouse. It still has % active storage zones inside.', v_active_zones;
        END IF;
        
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_prevent_active_warehouse_shutdown() OWNER TO postgres;

--
-- Name: fn_prevent_env_mismatch(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_prevent_env_mismatch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_shelf_min NUMERIC(5,2);
    v_shelf_max NUMERIC(5,2);
    v_shelf_humidity NUMERIC(5,2);
    v_med_min NUMERIC(5,2);
    v_med_max NUMERIC(5,2);
    v_med_humidity NUMERIC(5,2);
BEGIN
    -- Step 1: Get the environment capabilities of the specific shelf
    SELECT target_min_temp, target_max_temp, target_humidity_limit
    INTO v_shelf_min, v_shelf_max, v_shelf_humidity
    FROM smart_warehousing.storage_location
    WHERE location_id = NEW.location_id;

    -- Step 2: Get the required packaging standards for the medicine batch
    SELECT ps.min_temp_celsius, ps.max_temp_celsius, ps.humidity_limit
    INTO v_med_min, v_med_max, v_med_humidity
    FROM product_and_batch_intelligence.batch_master bm
    JOIN product_and_batch_intelligence.packaging_standards ps 
      ON bm.medicine_id = ps.medicine_id
    WHERE bm.batch_id = NEW.batch_id;

    -- Step 3: Check Temperature Compatibility
    IF v_shelf_min < v_med_min OR v_shelf_max > v_med_max THEN
        RAISE EXCEPTION 'SAFETY LOCK: Temperature Mismatch! Shelf % provides %°C to %°C, but Batch % requires %°C to %°C.', 
        NEW.location_id, v_shelf_min, v_shelf_max, NEW.batch_id, v_med_min, v_med_max;
    END IF;

    -- Step 4: Check Humidity Compatibility
    -- The shelf's ambient humidity cannot exceed the medicine's maximum allowed humidity
    IF v_shelf_humidity > v_med_humidity THEN
        RAISE EXCEPTION 'SAFETY LOCK: Humidity Mismatch! Shelf % has a baseline humidity of %%%, but the medicine in Batch % degrades if humidity exceeds %%%.', 
        NEW.location_id, v_shelf_humidity, NEW.batch_id, v_med_humidity;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_prevent_env_mismatch() OWNER TO postgres;

--
-- Name: fn_prevent_stock_on_dead_shelf(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_prevent_stock_on_dead_shelf() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_location_active BOOLEAN;
BEGIN
    -- Look up the status of the destination shelf
    SELECT is_active INTO v_location_active
    FROM smart_warehousing.storage_location
    WHERE location_id = NEW.location_id;

    -- If the shelf is deactivated, block the inventory addition!
    IF v_location_active = FALSE THEN
        RAISE EXCEPTION 'SAFETY LOCK: Cannot place inventory on location_id %. This storage location is currently inactive and cannot accept stock.', NEW.location_id;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_prevent_stock_on_dead_shelf() OWNER TO postgres;

--
-- Name: fn_prevent_storage_in_dead_warehouse(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_prevent_storage_in_dead_warehouse() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_warehouse_active BOOLEAN;
BEGIN
    -- Look up the status of the parent warehouse
    SELECT is_active INTO v_warehouse_active 
    FROM smart_warehousing.warehouse 
    WHERE warehouse_id = NEW.warehouse_id;

    -- If the warehouse is inactive, block the insert/update!
    IF v_warehouse_active = FALSE THEN
        RAISE EXCEPTION 'SAFETY LOCK: Cannot add a storage location to an inactive warehouse.';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_prevent_storage_in_dead_warehouse() OWNER TO postgres;

--
-- Name: fn_prevent_temp_mismatch(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_prevent_temp_mismatch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_shelf_min NUMERIC(5,2);
    v_shelf_max NUMERIC(5,2);
    v_med_min NUMERIC(5,2);
    v_med_max NUMERIC(5,2);
BEGIN
    -- Step 1: Get the temperature range of the specific storage shelf
    SELECT target_min_temp, target_max_temp
    INTO v_shelf_min, v_shelf_max
    FROM smart_warehousing.storage_location
    WHERE location_id = NEW.location_id;

    -- Step 2: Get the required packaging standards for the specific medicine batch
    SELECT ps.min_temp_celsius, ps.max_temp_celsius
    INTO v_med_min, v_med_max
    FROM product_and_batch_intelligence.batch_master bm
    JOIN product_and_batch_intelligence.packaging_standards ps 
      ON bm.medicine_id = ps.medicine_id
    WHERE bm.batch_id = NEW.batch_id;

    -- Step 3: Check for scientific compatibility
    -- The shelf's minimum cannot be colder than the medicine allows, 
    -- and the shelf's maximum cannot be hotter than the medicine allows.
    IF v_shelf_min < v_med_min OR v_shelf_max > v_med_max THEN
        RAISE EXCEPTION 'SAFETY LOCK: Temperature Mismatch! Shelf % provides %°C to %°C, but the medicine in Batch % requires %°C to %°C. Move to a different zone.', 
        NEW.location_id, v_shelf_min, v_shelf_max, NEW.batch_id, v_med_min, v_med_max;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_prevent_temp_mismatch() OWNER TO postgres;

--
-- Name: fn_sync_inventory_on_movement(); Type: FUNCTION; Schema: smart_warehousing; Owner: postgres
--

CREATE FUNCTION smart_warehousing.fn_sync_inventory_on_movement() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 1. Handle Outbound & Internal (Subtract from Source)
    IF NEW.movement_type IN ('Outbound', 'Internal') AND NEW.source_location_id IS NOT NULL THEN
        UPDATE smart_warehousing.inventory
        SET available_quantity = available_quantity - NEW.quantity_moved,
            last_verified_by = NEW.user_id,
            last_update = NOW()
        WHERE location_id = NEW.source_location_id AND batch_id = NEW.batch_id;
    END IF;

    -- 2. Handle Inbound & Internal (Add to Destination)
    IF NEW.movement_type IN ('Inbound', 'Internal') AND NEW.destination_location_id IS NOT NULL THEN
        INSERT INTO smart_warehousing.inventory (
            location_id, batch_id, available_quantity, last_verified_by, last_update
        ) VALUES (
            NEW.destination_location_id, NEW.batch_id, NEW.quantity_moved, NEW.user_id, NOW()
        )
        ON CONFLICT (location_id, batch_id) 
        DO UPDATE SET 
            available_quantity = smart_warehousing.inventory.available_quantity + NEW.quantity_moved,
            last_verified_by = NEW.user_id,
            last_update = NOW();
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION smart_warehousing.fn_sync_inventory_on_movement() OWNER TO postgres;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: financial_aggregate; Type: TABLE; Schema: financial_analytics; Owner: postgres
--

CREATE TABLE financial_analytics.financial_aggregate (
    report_id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    report_date date NOT NULL,
    total_orders integer DEFAULT 0,
    total_gross_revenue numeric(14,2) DEFAULT 0,
    total_tax_liability numeric(14,2) DEFAULT 0,
    net_revenue numeric(14,2) GENERATED ALWAYS AS ((total_gross_revenue - total_tax_liability)) STORED,
    generated_by_user_id uuid NOT NULL,
    created_at_utc timestamp with time zone DEFAULT now()
);


ALTER TABLE financial_analytics.financial_aggregate OWNER TO postgres;

--
-- Name: loss_analytics_data; Type: TABLE; Schema: financial_analytics; Owner: postgres
--

CREATE TABLE financial_analytics.loss_analytics_data (
    loss_record_id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    batch_id bigint NOT NULL,
    recall_id bigint,
    quantity_lost integer NOT NULL,
    unit_cost_at_loss numeric(12,2) NOT NULL,
    total_financial_loss numeric(14,2) GENERATED ALWAYS AS (((quantity_lost)::numeric * unit_cost_at_loss)) STORED,
    loss_category character varying(50) NOT NULL,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT loss_analytics_data_loss_category_check CHECK (((loss_category)::text = ANY ((ARRAY['Spoilage'::character varying, 'Damage'::character varying, 'Recall'::character varying, 'Theft'::character varying, 'Disposal'::character varying])::text[]))),
    CONSTRAINT loss_analytics_data_quantity_lost_check CHECK ((quantity_lost >= 0))
);


ALTER TABLE financial_analytics.loss_analytics_data OWNER TO postgres;

--
-- Name: payment_ledger; Type: TABLE; Schema: financial_analytics; Owner: postgres
--

CREATE TABLE financial_analytics.payment_ledger (
    payment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id bigint NOT NULL,
    payer_org_id uuid NOT NULL,
    payee_org_id uuid NOT NULL,
    base_amount numeric(12,2) NOT NULL,
    tax_percentage numeric(5,2) DEFAULT 0,
    total_transaction_amount numeric(14,2) GENERATED ALWAYS AS ((base_amount + (base_amount * (tax_percentage / (100)::numeric)))) STORED,
    payment_status character varying(50) NOT NULL,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT payment_ledger_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['Pending'::character varying, 'Completed'::character varying, 'Failed'::character varying, 'Refunded'::character varying])::text[])))
);


ALTER TABLE financial_analytics.payment_ledger OWNER TO postgres;

--
-- Name: auth_audit_logs; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.auth_audit_logs (
    log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    action_type text NOT NULL,
    source_module character varying(50) NOT NULL,
    event_payload jsonb,
    ip_address text DEFAULT '0.0.0.0'::text,
    log_time_stamp_utc timestamp with time zone DEFAULT now()
);


ALTER TABLE identity_mod.auth_audit_logs OWNER TO postgres;

--
-- Name: vw_cold_chain_violations; Type: VIEW; Schema: financial_analytics; Owner: postgres
--

CREATE VIEW financial_analytics.vw_cold_chain_violations AS
 SELECT date(log_time_stamp_utc) AS violation_date,
    action_type,
    (event_payload ->> 'disposal_method'::text) AS resulting_action,
    count(*) AS incident_count
   FROM identity_mod.auth_audit_logs
  WHERE (action_type = ANY (ARRAY['DRUGS_DESTROYED'::text, 'TEMPERATURE_BREACH'::text]))
  GROUP BY (date(log_time_stamp_utc)), action_type, (event_payload ->> 'disposal_method'::text);


ALTER VIEW financial_analytics.vw_cold_chain_violations OWNER TO postgres;

--
-- Name: vw_compliance_risk_heatmap; Type: VIEW; Schema: financial_analytics; Owner: postgres
--

CREATE VIEW financial_analytics.vw_compliance_risk_heatmap AS
 SELECT source_module AS department,
    count(*) AS total_events,
    count(*) FILTER (WHERE ((event_payload ->> 'severity'::text) = 'CRITICAL'::text)) AS critical_violations,
    count(*) FILTER (WHERE ((event_payload ->> 'severity'::text) = 'HIGH'::text)) AS high_risk_warnings,
    max(log_time_stamp_utc) AS last_violation_time
   FROM identity_mod.auth_audit_logs
  GROUP BY source_module;


ALTER VIEW financial_analytics.vw_compliance_risk_heatmap OWNER TO postgres;

--
-- Name: global_recall_ledger; Type: TABLE; Schema: reverse_logistics; Owner: postgres
--

CREATE TABLE reverse_logistics.global_recall_ledger (
    recall_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    initiated_by_org_id uuid NOT NULL,
    recall_reason text NOT NULL,
    quarantine_status character varying(50) DEFAULT 'Active'::character varying,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_quarantine_status CHECK (((quarantine_status)::text = ANY ((ARRAY['Active'::character varying, 'Resolved'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE reverse_logistics.global_recall_ledger OWNER TO postgres;

--
-- Name: refund_vouchers; Type: TABLE; Schema: reverse_logistics; Owner: postgres
--

CREATE TABLE reverse_logistics.refund_vouchers (
    voucher_id bigint NOT NULL,
    return_id bigint NOT NULL,
    refund_amount numeric(12,2) NOT NULL,
    refund_status character varying(50) DEFAULT 'Pending_Payout'::character varying,
    issued_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_refund_amount CHECK ((refund_amount >= (0)::numeric)),
    CONSTRAINT chk_refund_status CHECK (((refund_status)::text = ANY ((ARRAY['Pending_Payout'::character varying, 'Processed'::character varying, 'Failed'::character varying])::text[])))
);


ALTER TABLE reverse_logistics.refund_vouchers OWNER TO postgres;

--
-- Name: return_requests; Type: TABLE; Schema: reverse_logistics; Owner: postgres
--

CREATE TABLE reverse_logistics.return_requests (
    return_id bigint NOT NULL,
    returner_org_id uuid NOT NULL,
    batch_id bigint NOT NULL,
    recall_id bigint,
    quantity_returned integer NOT NULL,
    return_reason character varying(100) NOT NULL,
    status character varying(50) DEFAULT 'Initiated'::character varying,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_return_qty CHECK ((quantity_returned > 0)),
    CONSTRAINT chk_return_status CHECK (((status)::text = ANY ((ARRAY['Initiated'::character varying, 'In_Transit'::character varying, 'Received'::character varying, 'Assessed'::character varying, 'Closed'::character varying])::text[])))
);


ALTER TABLE reverse_logistics.return_requests OWNER TO postgres;

--
-- Name: vw_cost_of_non_compliance; Type: VIEW; Schema: financial_analytics; Owner: postgres
--

CREATE VIEW financial_analytics.vw_cost_of_non_compliance AS
 SELECT gl.recall_id,
    gl.recall_reason,
    count(rv.voucher_id) AS total_refunds_issued,
    sum(rv.refund_amount) AS total_financial_loss,
    gl.created_at_utc AS recall_date
   FROM ((reverse_logistics.global_recall_ledger gl
     JOIN reverse_logistics.return_requests req ON ((gl.recall_id = req.recall_id)))
     JOIN reverse_logistics.refund_vouchers rv ON ((req.return_id = rv.return_id)))
  GROUP BY gl.recall_id, gl.recall_reason, gl.created_at_utc;


ALTER VIEW financial_analytics.vw_cost_of_non_compliance OWNER TO postgres;

--
-- Name: delivery_proof_receipt; Type: TABLE; Schema: forward_fulfillment; Owner: postgres
--

CREATE TABLE forward_fulfillment.delivery_proof_receipt (
    receipt_id bigint NOT NULL,
    order_id bigint NOT NULL,
    received_by_user_id uuid NOT NULL,
    delivery_time timestamp with time zone NOT NULL,
    received_condition character varying(50) NOT NULL,
    digital_signature character varying(255) NOT NULL,
    remarks text,
    CONSTRAINT delivery_proof_receipt_received_condition_check CHECK (((received_condition)::text = ANY ((ARRAY['Good'::character varying, 'Damaged'::character varying, 'Partial'::character varying])::text[])))
);


ALTER TABLE forward_fulfillment.delivery_proof_receipt OWNER TO postgres;

--
-- Name: delivery_proof_receipt_receipt_id_seq; Type: SEQUENCE; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE forward_fulfillment.delivery_proof_receipt ALTER COLUMN receipt_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME forward_fulfillment.delivery_proof_receipt_receipt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: order_items; Type: TABLE; Schema: forward_fulfillment; Owner: postgres
--

CREATE TABLE forward_fulfillment.order_items (
    order_item_id bigint NOT NULL,
    order_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE forward_fulfillment.order_items OWNER TO postgres;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE forward_fulfillment.order_items ALTER COLUMN order_item_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME forward_fulfillment.order_items_order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sales_orders; Type: TABLE; Schema: forward_fulfillment; Owner: postgres
--

CREATE TABLE forward_fulfillment.sales_orders (
    order_id bigint NOT NULL,
    buyer_org_id uuid NOT NULL,
    order_date date NOT NULL,
    order_status character varying(50) NOT NULL,
    expected_del_date date,
    created_at_utc timestamp with time zone DEFAULT now(),
    updated_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT sales_orders_check CHECK ((expected_del_date > order_date)),
    CONSTRAINT sales_orders_order_status_check CHECK (((order_status)::text = ANY ((ARRAY['Pending'::character varying, 'Approved'::character varying, 'Shipped'::character varying, 'Delivered'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE forward_fulfillment.sales_orders OWNER TO postgres;

--
-- Name: sales_orders_order_id_seq; Type: SEQUENCE; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE forward_fulfillment.sales_orders ALTER COLUMN order_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME forward_fulfillment.sales_orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: shipping_manifest; Type: TABLE; Schema: forward_fulfillment; Owner: postgres
--

CREATE TABLE forward_fulfillment.shipping_manifest (
    manifest_id bigint NOT NULL,
    order_id bigint NOT NULL,
    vehicle_id bigint NOT NULL,
    driver_user_id uuid NOT NULL,
    dispatch_time_utc timestamp with time zone NOT NULL,
    estimated_arrival_time timestamp with time zone,
    manifest_status character varying(50) NOT NULL,
    CONSTRAINT shipping_manifest_check CHECK ((estimated_arrival_time > dispatch_time_utc)),
    CONSTRAINT shipping_manifest_manifest_status_check CHECK (((manifest_status)::text = ANY ((ARRAY['In-Transit'::character varying, 'Delivered'::character varying, 'Delayed'::character varying])::text[])))
);


ALTER TABLE forward_fulfillment.shipping_manifest OWNER TO postgres;

--
-- Name: shipping_manifest_manifest_id_seq; Type: SEQUENCE; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE forward_fulfillment.shipping_manifest ALTER COLUMN manifest_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME forward_fulfillment.shipping_manifest_manifest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vehicle_fleet_registry; Type: TABLE; Schema: forward_fulfillment; Owner: postgres
--

CREATE TABLE forward_fulfillment.vehicle_fleet_registry (
    vehicle_id bigint NOT NULL,
    vehicle_no character varying(50) NOT NULL,
    vehicle_type character varying(50) NOT NULL,
    transporter_org_id uuid NOT NULL,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT vehicle_fleet_registry_vehicle_type_check CHECK (((vehicle_type)::text = ANY ((ARRAY['Truck'::character varying, 'Van'::character varying, 'Reefer'::character varying])::text[])))
);


ALTER TABLE forward_fulfillment.vehicle_fleet_registry OWNER TO postgres;

--
-- Name: vehicle_fleet_registry_vehicle_id_seq; Type: SEQUENCE; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE forward_fulfillment.vehicle_fleet_registry ALTER COLUMN vehicle_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME forward_fulfillment.vehicle_fleet_registry_vehicle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: organisations; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.organisations (
    org_id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_name character varying(255) NOT NULL,
    org_type character varying(50) NOT NULL,
    reg_no character varying(100) NOT NULL,
    contact_email character varying(255) NOT NULL,
    is_active boolean DEFAULT true,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_org_type CHECK (((org_type)::text = ANY ((ARRAY['Manufacturer'::character varying, 'Distributor'::character varying, 'Transporter'::character varying, 'Retailer'::character varying, 'Regulatory_Body'::character varying])::text[])))
);


ALTER TABLE identity_mod.organisations OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.permissions (
    permission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    module_category character varying(100) NOT NULL,
    action_name character varying(100) NOT NULL,
    CONSTRAINT chk_module_category CHECK (((module_category)::text = ANY ((ARRAY['IDENTITY'::character varying, 'PRODUCT'::character varying, 'WAREHOUSE'::character varying, 'FULFILLMENT'::character varying, 'FINANCE'::character varying, 'RECALL'::character varying])::text[])))
);


ALTER TABLE identity_mod.permissions OWNER TO postgres;

--
-- Name: role_permissions; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE identity_mod.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.roles (
    role_id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_name character varying(50) NOT NULL,
    description text
);


ALTER TABLE identity_mod.roles OWNER TO postgres;

--
-- Name: user_sessions; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.user_sessions (
    session_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    ip_address text,
    login_time_utc timestamp with time zone DEFAULT now(),
    log_out_time_utc timestamp with time zone
);


ALTER TABLE identity_mod.user_sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: identity_mod; Owner: postgres
--

CREATE TABLE identity_mod.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid,
    role_id uuid,
    password_hash text NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at_utc timestamp with time zone DEFAULT now()
);


ALTER TABLE identity_mod.users OWNER TO postgres;

--
-- Name: batch_master; Type: TABLE; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TABLE product_and_batch_intelligence.batch_master (
    batch_id bigint NOT NULL,
    medicine_id bigint,
    manufacturer_id uuid NOT NULL,
    registered_by_user_id uuid NOT NULL,
    batch_number character varying(100) NOT NULL,
    mfg_date date NOT NULL,
    expiry_date date NOT NULL,
    quantity_produced bigint NOT NULL,
    status character varying(50) DEFAULT 'Pending'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_batch_dates CHECK ((expiry_date > mfg_date)),
    CONSTRAINT chk_batch_status CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Released'::character varying, 'Quality-Check'::character varying, 'Rejected'::character varying, 'Recalled'::character varying])::text[]))),
    CONSTRAINT chk_quantity CHECK ((quantity_produced > 0))
);


ALTER TABLE product_and_batch_intelligence.batch_master OWNER TO postgres;

--
-- Name: batch_master_batch_id_seq; Type: SEQUENCE; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE product_and_batch_intelligence.batch_master ALTER COLUMN batch_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product_and_batch_intelligence.batch_master_batch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: chemical_compositions; Type: TABLE; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TABLE product_and_batch_intelligence.chemical_compositions (
    composition_id bigint NOT NULL,
    medicine_id bigint NOT NULL,
    active_ingredient character varying(255) NOT NULL,
    strength character varying(50) NOT NULL,
    dosage_form character varying(100) NOT NULL
);


ALTER TABLE product_and_batch_intelligence.chemical_compositions OWNER TO postgres;

--
-- Name: chemical_compositions_composition_id_seq; Type: SEQUENCE; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE product_and_batch_intelligence.chemical_compositions ALTER COLUMN composition_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product_and_batch_intelligence.chemical_compositions_composition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: medicines; Type: TABLE; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TABLE product_and_batch_intelligence.medicines (
    medicine_id bigint NOT NULL,
    brand_name character varying(255) NOT NULL,
    generic_name character varying(255) NOT NULL,
    category character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_category_standard CHECK (((category)::text = ANY ((ARRAY['Antibiotic'::character varying, 'Analgesic'::character varying, 'Vaccine'::character varying, 'Anti-Diabetic'::character varying, 'Statin'::character varying, 'Antacid'::character varying, 'Antihypertensive'::character varying, 'Hormone'::character varying, 'Antihistamine'::character varying, 'NSAID'::character varying, 'Immunomodulatory'::character varying])::text[])))
);


ALTER TABLE product_and_batch_intelligence.medicines OWNER TO postgres;

--
-- Name: medicines_medicine_id_seq; Type: SEQUENCE; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE product_and_batch_intelligence.medicines ALTER COLUMN medicine_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product_and_batch_intelligence.medicines_medicine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: packaging_standards; Type: TABLE; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TABLE product_and_batch_intelligence.packaging_standards (
    packaging_id bigint NOT NULL,
    medicine_id bigint NOT NULL,
    min_temp_celsius numeric(5,2) NOT NULL,
    max_temp_celsius numeric(5,2) NOT NULL,
    humidity_limit numeric(5,2) NOT NULL,
    fragility_index integer NOT NULL,
    CONSTRAINT chk_fragility CHECK (((fragility_index >= 1) AND (fragility_index <= 10))),
    CONSTRAINT chk_humidity CHECK (((humidity_limit >= (0)::numeric) AND (humidity_limit <= (100)::numeric))),
    CONSTRAINT chk_temp_logic CHECK ((min_temp_celsius < max_temp_celsius))
);


ALTER TABLE product_and_batch_intelligence.packaging_standards OWNER TO postgres;

--
-- Name: packaging_standards_packaging_id_seq; Type: SEQUENCE; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE product_and_batch_intelligence.packaging_standards ALTER COLUMN packaging_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product_and_batch_intelligence.packaging_standards_packaging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: quality_check_specs; Type: TABLE; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TABLE product_and_batch_intelligence.quality_check_specs (
    spec_id bigint NOT NULL,
    medicine_id bigint NOT NULL,
    purity_threshold numeric(5,2) NOT NULL,
    dissolution_rate text NOT NULL,
    ph_balance_req numeric(4,2) NOT NULL,
    required_certs text NOT NULL,
    CONSTRAINT chk_ph_range CHECK (((ph_balance_req >= (0)::numeric) AND (ph_balance_req <= (14)::numeric))),
    CONSTRAINT chk_purity_range CHECK (((purity_threshold >= (0)::numeric) AND (purity_threshold <= (100)::numeric)))
);


ALTER TABLE product_and_batch_intelligence.quality_check_specs OWNER TO postgres;

--
-- Name: quality_check_specs_spec_id_seq; Type: SEQUENCE; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE product_and_batch_intelligence.quality_check_specs ALTER COLUMN spec_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product_and_batch_intelligence.quality_check_specs_spec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: financial_aggregate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.financial_aggregate (
    report_id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    report_date date NOT NULL,
    total_orders integer DEFAULT 0 NOT NULL,
    total_gross_revenue numeric(14,2) DEFAULT 0 NOT NULL,
    total_tax_liability numeric(14,2) DEFAULT 0 NOT NULL,
    net_revenue numeric(14,2) GENERATED ALWAYS AS ((total_gross_revenue - total_tax_liability)) STORED,
    generated_by_user_id uuid,
    created_at_utc timestamp with time zone DEFAULT now()
);


ALTER TABLE public.financial_aggregate OWNER TO postgres;

--
-- Name: payment_ledger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_ledger (
    payment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    payer_org_id uuid NOT NULL,
    payee_org_id uuid NOT NULL,
    base_amount numeric(12,2) NOT NULL,
    tax_percentage numeric(5,2) DEFAULT 0,
    total_transaction_amount numeric(14,2) GENERATED ALWAYS AS ((base_amount + ((base_amount * tax_percentage) / (100)::numeric))) STORED,
    payment_status text NOT NULL,
    created_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT payment_ledger_payment_status_check CHECK ((payment_status = ANY (ARRAY['pending'::text, 'completed'::text, 'failed'::text, 'cancelled'::text])))
);


ALTER TABLE public.payment_ledger OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_realtime_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: disposal_certificates; Type: TABLE; Schema: reverse_logistics; Owner: postgres
--

CREATE TABLE reverse_logistics.disposal_certificates (
    certificate_id bigint NOT NULL,
    assessment_id bigint NOT NULL,
    witness_user_id uuid NOT NULL,
    disposal_method character varying(100) NOT NULL,
    evidence_hash character varying(255) NOT NULL,
    disposed_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_disposal_method CHECK (((disposal_method)::text = ANY ((ARRAY['Incineration'::character varying, 'Chemical_Neutralization'::character varying, 'Bio-Hazard_Landfill'::character varying])::text[])))
);


ALTER TABLE reverse_logistics.disposal_certificates OWNER TO postgres;

--
-- Name: disposal_certificates_certificate_id_seq; Type: SEQUENCE; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE reverse_logistics.disposal_certificates ALTER COLUMN certificate_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reverse_logistics.disposal_certificates_certificate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: global_recall_ledger_recall_id_seq; Type: SEQUENCE; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE reverse_logistics.global_recall_ledger ALTER COLUMN recall_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reverse_logistics.global_recall_ledger_recall_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recall_communication_logs; Type: TABLE; Schema: reverse_logistics; Owner: postgres
--

CREATE TABLE reverse_logistics.recall_communication_logs (
    log_id bigint NOT NULL,
    recall_id bigint NOT NULL,
    notified_org_id uuid NOT NULL,
    channel character varying(50) NOT NULL,
    delivery_status character varying(50) DEFAULT 'Pending'::character varying,
    sent_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_channel CHECK (((channel)::text = ANY ((ARRAY['Email'::character varying, 'SMS'::character varying, 'System_Alert'::character varying, 'Registered_Post'::character varying])::text[]))),
    CONSTRAINT chk_delivery_status CHECK (((delivery_status)::text = ANY ((ARRAY['Pending'::character varying, 'Delivered'::character varying, 'Failed'::character varying, 'Read'::character varying])::text[])))
);


ALTER TABLE reverse_logistics.recall_communication_logs OWNER TO postgres;

--
-- Name: recall_communication_logs_log_id_seq; Type: SEQUENCE; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE reverse_logistics.recall_communication_logs ALTER COLUMN log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reverse_logistics.recall_communication_logs_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: refund_vouchers_voucher_id_seq; Type: SEQUENCE; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE reverse_logistics.refund_vouchers ALTER COLUMN voucher_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reverse_logistics.refund_vouchers_voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: return_requests_return_id_seq; Type: SEQUENCE; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE reverse_logistics.return_requests ALTER COLUMN return_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reverse_logistics.return_requests_return_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: return_stock_assessments; Type: TABLE; Schema: reverse_logistics; Owner: postgres
--

CREATE TABLE reverse_logistics.return_stock_assessments (
    assessment_id bigint NOT NULL,
    return_id bigint NOT NULL,
    inspector_user_id uuid NOT NULL,
    inspection_result text NOT NULL,
    disposition_action character varying(50) NOT NULL,
    assessed_at_utc timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_disposition CHECK (((disposition_action)::text = ANY ((ARRAY['Approve_Refund_and_Destroy'::character varying, 'Approve_Refund_and_Restock'::character varying, 'Reject_Claim'::character varying])::text[])))
);


ALTER TABLE reverse_logistics.return_stock_assessments OWNER TO postgres;

--
-- Name: return_stock_assessments_assessment_id_seq; Type: SEQUENCE; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE reverse_logistics.return_stock_assessments ALTER COLUMN assessment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME reverse_logistics.return_stock_assessments_assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: environmental_sensor_logs; Type: TABLE; Schema: smart_warehousing; Owner: postgres
--

CREATE TABLE smart_warehousing.environmental_sensor_logs (
    log_id bigint NOT NULL,
    location_id bigint NOT NULL,
    temperature_celsius double precision NOT NULL,
    humidity_percentage double precision NOT NULL,
    recorded_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_humidity_range CHECK (((humidity_percentage >= (0)::double precision) AND (humidity_percentage <= (100)::double precision)))
);


ALTER TABLE smart_warehousing.environmental_sensor_logs OWNER TO postgres;

--
-- Name: environmental_sensor_logs_log_id_seq; Type: SEQUENCE; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE smart_warehousing.environmental_sensor_logs ALTER COLUMN log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME smart_warehousing.environmental_sensor_logs_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventory; Type: TABLE; Schema: smart_warehousing; Owner: postgres
--

CREATE TABLE smart_warehousing.inventory (
    inventory_id bigint NOT NULL,
    location_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    available_quantity integer NOT NULL,
    last_verified_by uuid NOT NULL,
    last_update timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_available_qty CHECK ((available_quantity >= 0))
);


ALTER TABLE smart_warehousing.inventory OWNER TO postgres;

--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE smart_warehousing.inventory ALTER COLUMN inventory_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME smart_warehousing.inventory_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: quarantine_area_logs; Type: TABLE; Schema: smart_warehousing; Owner: postgres
--

CREATE TABLE smart_warehousing.quarantine_area_logs (
    quarantine_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    location_id bigint NOT NULL,
    quarantine_reason character varying(100) NOT NULL,
    breaching_log_id bigint,
    action_taken_by uuid NOT NULL,
    status character varying(50) NOT NULL,
    CONSTRAINT chk_quarantine_reason CHECK (((quarantine_reason)::text = ANY ((ARRAY['Temp Breach'::character varying, 'Expired'::character varying])::text[]))),
    CONSTRAINT chk_quarantine_status CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Cleared'::character varying, 'Destroyed'::character varying])::text[])))
);


ALTER TABLE smart_warehousing.quarantine_area_logs OWNER TO postgres;

--
-- Name: quarantine_area_logs_quarantine_id_seq; Type: SEQUENCE; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE smart_warehousing.quarantine_area_logs ALTER COLUMN quarantine_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME smart_warehousing.quarantine_area_logs_quarantine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stock_movement_history; Type: TABLE; Schema: smart_warehousing; Owner: postgres
--

CREATE TABLE smart_warehousing.stock_movement_history (
    movement_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    source_location_id bigint,
    destination_location_id bigint,
    user_id uuid NOT NULL,
    quantity_moved integer NOT NULL,
    movement_type character varying(50) NOT NULL,
    moved_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_movement_logic CHECK (((source_location_id IS NOT NULL) OR (destination_location_id IS NOT NULL))),
    CONSTRAINT chk_movement_type CHECK (((movement_type)::text = ANY ((ARRAY['Inbound'::character varying, 'Internal'::character varying, 'Outbound'::character varying])::text[]))),
    CONSTRAINT chk_qty_moved CHECK ((quantity_moved > 0))
);


ALTER TABLE smart_warehousing.stock_movement_history OWNER TO postgres;

--
-- Name: stock_movement_history_movement_id_seq; Type: SEQUENCE; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE smart_warehousing.stock_movement_history ALTER COLUMN movement_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME smart_warehousing.stock_movement_history_movement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: storage_location; Type: TABLE; Schema: smart_warehousing; Owner: postgres
--

CREATE TABLE smart_warehousing.storage_location (
    location_id bigint NOT NULL,
    warehouse_id bigint NOT NULL,
    zone_type character varying(50) NOT NULL,
    target_min_temp numeric(5,2) NOT NULL,
    target_max_temp numeric(5,2) NOT NULL,
    max_capacity integer NOT NULL,
    is_active boolean DEFAULT true,
    target_humidity_limit numeric(5,2) DEFAULT 60.00,
    CONSTRAINT chk_capacity CHECK ((max_capacity > 0)),
    CONSTRAINT chk_location_humidity CHECK (((target_humidity_limit >= (0)::numeric) AND (target_humidity_limit <= (100)::numeric))),
    CONSTRAINT chk_temp_logic CHECK ((target_min_temp < target_max_temp)),
    CONSTRAINT chk_zone_type CHECK (((zone_type)::text = ANY ((ARRAY['Cold Storage'::character varying, 'General'::character varying])::text[])))
);


ALTER TABLE smart_warehousing.storage_location OWNER TO postgres;

--
-- Name: storage_location_location_id_seq; Type: SEQUENCE; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE smart_warehousing.storage_location ALTER COLUMN location_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME smart_warehousing.storage_location_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: warehouse; Type: TABLE; Schema: smart_warehousing; Owner: postgres
--

CREATE TABLE smart_warehousing.warehouse (
    warehouse_id bigint NOT NULL,
    warehouse_name character varying(255) NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    manager_user_id uuid NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE smart_warehousing.warehouse OWNER TO postgres;

--
-- Name: warehouse_warehouse_id_seq; Type: SEQUENCE; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE smart_warehousing.warehouse ALTER COLUMN warehouse_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME smart_warehousing.warehouse_warehouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at, custom_claims_allowlist) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
20260625000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: financial_aggregate; Type: TABLE DATA; Schema: financial_analytics; Owner: postgres
--

COPY financial_analytics.financial_aggregate (report_id, org_id, report_date, total_orders, total_gross_revenue, total_tax_liability, generated_by_user_id, created_at_utc) FROM stdin;
dae65c29-5406-4e94-b203-bfeda32342da	96a73ed7-bc75-48de-abb6-b1eab134fb26	2026-03-31	45	150000.00	7500.00	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	2026-04-14 17:18:34.41604+00
1b38f83f-d9e8-4237-ac9c-8f46d12f16a2	96a73ed7-bc75-48de-abb6-b1eab134fb26	2026-04-14	22	85000.00	4250.00	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	2026-04-14 17:18:34.41604+00
f4d8ab62-cd50-4809-bb2e-81bd5eec6b4a	96a73ed7-bc75-48de-abb6-b1eab134fb26	2026-05-31	60	210000.00	10500.00	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	2026-04-14 17:25:52.100588+00
5037a283-bd95-4d67-95a3-e7689eaea0ca	96a73ed7-bc75-48de-abb6-b1eab134fb26	2026-04-14	2	87500.00	4375.00	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	2026-04-14 17:56:40.084029+00
\.


--
-- Data for Name: loss_analytics_data; Type: TABLE DATA; Schema: financial_analytics; Owner: postgres
--

COPY financial_analytics.loss_analytics_data (loss_record_id, org_id, batch_id, recall_id, quantity_lost, unit_cost_at_loss, loss_category, created_at_utc) FROM stdin;
d97f6e28-22f0-4492-a644-5368936d3a55	f8e303d0-608f-48ef-832f-02c848a68232	7	\N	10	120.00	Damage	2026-04-14 17:18:34.41604+00
412c4da8-3baa-45c5-bdfb-6aba47c7a973	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	9	\N	5	85.00	Spoilage	2026-04-14 17:18:34.41604+00
429688ef-6673-4ac4-ada6-887f0e2dafc6	f8e303d0-608f-48ef-832f-02c848a68232	13	\N	75	50.00	Disposal	2026-04-14 17:18:34.41604+00
04250685-e20d-4cc1-bfec-7585d8a16457	96a73ed7-bc75-48de-abb6-b1eab134fb26	2	1	5000	150.00	Recall	2026-04-14 17:25:52.100588+00
5a00a2c9-a545-474a-a0e3-a69d987e1eed	f8e303d0-608f-48ef-832f-02c848a68232	2	1	50	150.00	Recall	2026-04-14 17:25:52.100588+00
d77c4907-8bba-4fe3-8d96-f6d21ae876e0	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	4	\N	20	300.00	Theft	2026-04-14 17:25:52.100588+00
\.


--
-- Data for Name: payment_ledger; Type: TABLE DATA; Schema: financial_analytics; Owner: postgres
--

COPY financial_analytics.payment_ledger (payment_id, order_id, payer_org_id, payee_org_id, base_amount, tax_percentage, payment_status, created_at_utc) FROM stdin;
612810e8-2b43-4fb6-b00a-9b18129b7820	4	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	96a73ed7-bc75-48de-abb6-b1eab134fb26	60000.00	5.00	Refunded	2026-04-14 17:25:52.100588+00
8097160d-b0df-4b32-95f4-55b07798d508	5	f8e303d0-608f-48ef-832f-02c848a68232	96a73ed7-bc75-48de-abb6-b1eab134fb26	37500.00	5.00	Completed	2026-04-14 17:25:52.100588+00
05353a92-028a-4622-8d09-1a292cd1cba2	6	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	96a73ed7-bc75-48de-abb6-b1eab134fb26	15000.00	5.00	Failed	2026-04-14 17:25:52.100588+00
661f2b98-6cc6-490f-b5b3-422017ff4d95	1	f8e303d0-608f-48ef-832f-02c848a68232	96a73ed7-bc75-48de-abb6-b1eab134fb26	50000.00	5.00	Completed	2026-04-14 17:38:31.46523+00
eb00548d-36b2-4746-90b4-0b78f0a9090f	10	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	96a73ed7-bc75-48de-abb6-b1eab134fb26	6000.00	5.00	Completed	2026-04-17 04:12:31.953943+00
\.


--
-- Data for Name: delivery_proof_receipt; Type: TABLE DATA; Schema: forward_fulfillment; Owner: postgres
--

COPY forward_fulfillment.delivery_proof_receipt (receipt_id, order_id, received_by_user_id, delivery_time, received_condition, digital_signature, remarks) FROM stdin;
1	1	0b56a543-c19d-43ef-b948-bab7ee9b84ef	2026-04-14 16:17:37.637092+00	Good	hash_sig_789XYZ	\N
2	5	0b56a543-c19d-43ef-b948-bab7ee9b84ef	2026-04-14 14:30:36.23011+00	Damaged	hash_sig_ERROR_99	Water damage on 15 boxes
3	4	0b56a543-c19d-43ef-b948-bab7ee9b84ef	2026-04-14 16:35:24.528598+00	Damaged	hash_sig_LATE_DMG	Delayed delivery caused packaging issues, 20 boxes damaged on arrival
4	8	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 16:35:24.528598+00	Good	hash_sig_FLAT_FIXED	Arrived late but cargo is perfectly intact
5	2	0b56a543-c19d-43ef-b948-bab7ee9b84ef	2026-04-14 16:35:24.528598+00	Partial	hash_sig_SHORTAGE_2	Missing 5 boxes from the manifest count. Discrepancy logged.
7	1	0b56a543-c19d-43ef-b948-bab7ee9b84ef	2026-04-14 17:38:31.46523+00	Good	hash_trigger_test_SUCCESS	Delivering an order that actually has stock
8	10	0b56a543-c19d-43ef-b948-bab7ee9b84ef	2026-04-17 04:12:31.953943+00	Good	hash_PRESENTATION_SUCCESS	Presentation Demo: Testing Financial Trigger
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: forward_fulfillment; Owner: postgres
--

COPY forward_fulfillment.order_items (order_item_id, order_id, batch_id, quantity, unit_price, created_at_utc) FROM stdin;
3	1	6	200	250.00	2026-04-14 13:53:07.117598+00
4	2	7	100	150.00	2026-04-14 14:30:20.805838+00
5	3	9	50	85.50	2026-04-14 14:30:20.805838+00
6	4	11	200	300.00	2026-04-14 14:30:20.805838+00
7	5	13	75	500.00	2026-04-14 14:30:20.805838+00
8	8	7	300	210.50	2026-04-14 16:31:17.643429+00
9	9	9	800	95.00	2026-04-14 16:31:17.643429+00
10	10	11	50	120.00	2026-04-14 16:31:17.643429+00
\.


--
-- Data for Name: sales_orders; Type: TABLE DATA; Schema: forward_fulfillment; Owner: postgres
--

COPY forward_fulfillment.sales_orders (order_id, buyer_org_id, order_date, order_status, expected_del_date, created_at_utc, updated_at_utc) FROM stdin;
3	f8e303d0-608f-48ef-832f-02c848a68232	2026-04-14	Cancelled	2026-04-16	2026-04-14 14:30:20.805838+00	2026-04-14 14:30:36.23011+00
5	f8e303d0-608f-48ef-832f-02c848a68232	2026-04-14	Delivered	2026-04-17	2026-04-14 14:30:20.805838+00	2026-04-14 14:30:36.23011+00
6	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	2026-04-14	Pending	2026-04-21	2026-04-14 16:28:00.493387+00	2026-04-14 16:28:00.493387+00
7	f8e303d0-608f-48ef-832f-02c848a68232	2026-04-12	Pending	2026-04-15	2026-04-14 16:28:00.493387+00	2026-04-14 16:28:00.493387+00
9	f8e303d0-608f-48ef-832f-02c848a68232	2026-04-11	Pending	2026-04-14	2026-04-14 16:28:00.493387+00	2026-04-14 16:28:00.493387+00
4	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	2026-04-14	Delivered	2026-04-18	2026-04-14 14:30:20.805838+00	2026-04-14 16:35:24.528598+00
8	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	2026-04-13	Delivered	2026-04-16	2026-04-14 16:28:00.493387+00	2026-04-14 16:35:24.528598+00
2	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	2026-04-14	Delivered	2026-04-19	2026-04-14 14:30:20.805838+00	2026-04-14 16:35:24.528598+00
1	f8e303d0-608f-48ef-832f-02c848a68232	2026-04-14	Delivered	2026-04-17	2026-04-14 13:22:16.836207+00	2026-04-14 17:38:31.46523+00
10	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	2026-04-14	Delivered	2026-04-19	2026-04-14 16:28:00.493387+00	2026-04-17 04:12:31.953943+00
\.


--
-- Data for Name: shipping_manifest; Type: TABLE DATA; Schema: forward_fulfillment; Owner: postgres
--

COPY forward_fulfillment.shipping_manifest (manifest_id, order_id, vehicle_id, driver_user_id, dispatch_time_utc, estimated_arrival_time, manifest_status) FROM stdin;
1	1	1	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	2026-04-14 14:15:06.208246+00	\N	In-Transit
2	4	2	c6c449e4-ec43-4c95-811f-f87da31d1321	2026-04-13 14:30:36.23011+00	2026-04-16 14:30:36.23011+00	Delayed
3	5	3	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	2026-04-14 09:30:36.23011+00	2026-04-14 13:30:36.23011+00	Delivered
4	2	2	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	2026-04-14 12:35:24.528598+00	2026-04-14 16:20:24.528598+00	Delivered
\.


--
-- Data for Name: vehicle_fleet_registry; Type: TABLE DATA; Schema: forward_fulfillment; Owner: postgres
--

COPY forward_fulfillment.vehicle_fleet_registry (vehicle_id, vehicle_no, vehicle_type, transporter_org_id, created_at_utc) FROM stdin;
1	MP-04-TR-9921	Reefer	423437e5-bbea-4f4a-a49f-3a1ae478f89c	2026-04-14 13:22:16.836207+00
2	MP-04-TK-5566	Truck	7082bff8-9fdd-4ae3-a017-6a131fa714ae	2026-04-14 14:30:20.805838+00
3	MP-04-VN-8899	Van	423437e5-bbea-4f4a-a49f-3a1ae478f89c	2026-04-14 14:30:20.805838+00
4	MP-04-RF-1122	Reefer	423437e5-bbea-4f4a-a49f-3a1ae478f89c	2026-04-14 14:30:20.805838+00
5	MP-09-TK-1001	Truck	7082bff8-9fdd-4ae3-a017-6a131fa714ae	2026-04-14 16:28:00.493387+00
6	MP-09-RF-2002	Reefer	7082bff8-9fdd-4ae3-a017-6a131fa714ae	2026-04-14 16:28:00.493387+00
\.


--
-- Data for Name: auth_audit_logs; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.auth_audit_logs (log_id, user_id, action_type, source_module, event_payload, ip_address, log_time_stamp_utc) FROM stdin;
3d764b47-88a9-4a67-bc23-c4ffee5b8c99	2b609790-c885-4a9a-9978-442b92e9534d	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:31:39.848442+00
1073ba81-3f9e-4b75-a49b-ed35861afdd8	3fe7d24b-328d-4b6b-95fc-8e3bac01f07b	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:31:39.848442+00
e7a9091c-ec1f-445b-8fea-bc6b01949628	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:31:39.848442+00
15c01d3b-ed95-4679-ba71-993a1a696e53	c6c449e4-ec43-4c95-811f-f87da31d1321	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:31:39.848442+00
4fb7dc8e-32f1-42b0-bc02-7b3609708424	59337730-2f86-449c-bc21-41f9b6a3e404	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:31:39.848442+00
6ee8b1c1-996e-4aa3-92a9-255f18525700	4a31302e-f3f4-449a-9f49-9ddee5a9e4c3	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:31:39.848442+00
8617d060-8991-4ab8-9394-58d68dbe7b38	e59ea77c-bf5a-4729-b64f-f1d52d44b23d	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-14 06:35:47.089794+00
a362082d-6a67-419c-9c2f-5a74522ecfa2	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "LOW", "new_status": "Quality-Check", "old_status": "Released", "description": "Batch B-AMX-2026-01 status updated from Released to Quality-Check", "batch_number": "B-AMX-2026-01"}	0.0.0.0	2026-04-14 12:18:04.03926+00
8e1631b0-163d-4286-bbde-49224f8a892a	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "LOW", "new_status": "Quality-Check", "old_status": "Pending", "description": "Batch B-HYP-2026-01 status updated from Pending to Quality-Check", "batch_number": "B-HYP-2026-01"}	0.0.0.0	2026-04-14 12:35:14.016427+00
59f83ec8-c37c-4665-9869-5c94dba60d04	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "LOW", "new_status": "Quality-Check", "old_status": "Released", "description": "Batch B-ZIT-2026-01 status updated from Released to Quality-Check", "batch_number": "B-ZIT-2026-01"}	0.0.0.0	2026-04-14 12:41:50.923981+00
ec1b53ab-78d2-4f44-a1a3-9bef0193e5d8	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "LOW", "new_status": "Quality-Check", "old_status": "Released", "description": "Batch B-LIP-2026-01 status updated from Released to Quality-Check", "batch_number": "B-LIP-2026-01"}	0.0.0.0	2026-04-14 12:41:50.923981+00
b8c72f6c-a348-4387-a3d1-2088a543967b	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "LOW", "new_status": "Quality-Check", "old_status": "Released", "description": "Batch B-ALR-2026-01 status updated from Released to Quality-Check", "batch_number": "B-ALR-2026-01"}	0.0.0.0	2026-04-14 12:41:50.923981+00
069bad04-2fa0-449b-8593-73dfef2d02de	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "LOW", "new_status": "Quality-Check", "old_status": "Released", "description": "Batch B-GAS-2026-01 status updated from Released to Quality-Check", "batch_number": "B-GAS-2026-01"}	0.0.0.0	2026-04-14 12:41:50.923981+00
0bae4bb9-d4eb-4e08-806d-959b53e59c36	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "MEDIUM", "new_status": "Released", "old_status": "Quality-Check", "description": "Batch B-MET-2026-01 status updated from Quality-Check to Released", "batch_number": "B-MET-2026-01"}	0.0.0.0	2026-04-14 14:30:20.805838+00
f58a7c3a-4153-40bd-bd0d-9e27645dfcc5	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "MEDIUM", "new_status": "Released", "old_status": "Quality-Check", "description": "Batch B-GAS-2026-01 status updated from Quality-Check to Released", "batch_number": "B-GAS-2026-01"}	0.0.0.0	2026-04-14 14:30:20.805838+00
2da65597-bde8-44dd-ba9d-929e9ee29b89	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "MEDIUM", "new_status": "Released", "old_status": "Quality-Check", "description": "Batch B-ZIT-2026-01 status updated from Quality-Check to Released", "batch_number": "B-ZIT-2026-01"}	0.0.0.0	2026-04-14 14:30:20.805838+00
bacd2ff1-672d-4596-8396-abcfb7067347	03bf32d6-485e-497b-8888-ceacee875b65	BATCH_STATUS_CHANGE	PRODUCT_INTELLIGENCE	{"severity": "MEDIUM", "new_status": "Released", "old_status": "Quality-Check", "description": "Batch B-INS-2026-02 status updated from Quality-Check to Released", "batch_number": "B-INS-2026-02"}	0.0.0.0	2026-04-14 14:30:20.805838+00
c21e01d6-893d-4382-8c24-157572303880	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	142.132.1.10	2026-03-26 08:11:56.256295+00
fcc663dd-3bb0-4a70-8476-12129dd872c0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	52.224.1.10	2026-03-25 15:52:50.296108+00
5a6224e0-9255-448f-aa7a-3c7db154873f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	9.52.1.10	2026-03-19 07:06:05.812426+00
fa155773-e0b6-43b9-832b-37ac09eccdd4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	105.181.1.10	2026-03-25 18:17:21.017234+00
e14ef3a7-a9c7-47c1-9b1c-e6fba390b1fa	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	86.43.1.10	2026-04-06 07:53:49.346102+00
335d4b89-065c-4a63-8dc6-6399ebb13aa7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	58.5.1.10	2026-04-02 00:32:17.661674+00
58b8a86e-c4a4-426e-ab3d-c07c53e64630	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	233.231.1.10	2026-03-22 00:16:05.120104+00
110776fd-92fa-4e27-9d80-c22bbeaf09ca	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	83.188.1.10	2026-03-16 07:29:56.675238+00
ab507999-6cd4-4a1c-abd5-b3aa9c9f2745	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	96.164.1.10	2026-04-07 05:23:39.911776+00
ed067a61-359e-42c7-8a75-1a7fec5658f1	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	201.105.1.10	2026-04-05 21:26:40.304811+00
40802b71-9a9b-4061-b646-84db20e0d61f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	215.183.1.10	2026-04-01 15:46:46.671996+00
7f538592-990c-4f72-9b79-d5c3f7269802	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	38.251.1.10	2026-04-01 09:49:45.830106+00
e4087863-0517-4aa0-b16e-b4987d70e095	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	222.227.1.10	2026-03-18 22:15:56.03333+00
3531ff29-3675-437f-a639-72a515b857d3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	243.105.1.10	2026-03-23 11:34:11.150177+00
b5b83b9c-6ec4-496e-ba60-e2a2b32ea68d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	30.108.1.10	2026-03-18 11:55:17.148904+00
5d142d69-2177-4084-9342-8eef0e1919eb	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	191.56.1.10	2026-04-01 23:18:16.848079+00
35271e21-7bb7-4f2c-b8c6-76d2b75f802e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	149.182.1.10	2026-03-15 20:14:46.975427+00
204e65ab-b611-47cf-ab0b-ccc704a5f8b1	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	36.96.1.10	2026-04-13 00:58:17.960599+00
bdceed03-ca21-47a5-84a2-a29681217994	e51028f5-1028-4444-8888-f51028f51028	USER_IDENTITY_CREATED	IDENTITY	\N	0.0.0.0	2026-04-17 04:11:05.908666+00
7d5c4f33-2dda-4baf-a76e-4ccb4184d45f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	167.219.1.10	2026-03-25 07:17:22.379147+00
d8839353-2e95-4f1c-a776-d12c757577fa	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	242.31.1.10	2026-04-13 00:24:23.627837+00
12a46954-517d-43de-856e-640ab9e5d011	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	33.189.1.10	2026-04-06 04:14:20.578502+00
12a8b8b5-2fa5-4425-a758-a46b5bcd3e6a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	96.47.1.10	2026-03-23 08:02:51.195266+00
2ac4d7b2-f788-4ace-8775-689948fdf90c	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	68.112.1.10	2026-04-04 17:51:54.032466+00
0f15e14d-a48c-4eff-9409-41b52855df8c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	144.53.1.10	2026-03-18 18:15:23.677584+00
3051dc1e-238b-4f80-8dac-f9acef12708c	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	251.191.1.10	2026-03-30 12:12:00.637397+00
6f3c0730-7ed2-405e-807b-ccf58dfb0afb	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	128.211.1.10	2026-03-23 22:53:14.719614+00
69113f3f-cced-48b4-b416-2b62fddb05d0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	19.54.1.10	2026-03-24 07:20:20.945723+00
099c778a-5547-4bc1-93f3-363f7c3baaf2	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	198.161.1.10	2026-04-12 05:59:41.918468+00
e90f553e-cdbd-49ca-b7e4-7faa0effe027	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	217.7.1.10	2026-03-16 01:18:35.792289+00
f29bc774-ff31-41a8-9482-cc623ee013ff	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	61.66.1.10	2026-03-26 11:03:19.002608+00
c729a572-dc22-49dd-af1b-408307ff3f53	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	69.85.1.10	2026-04-11 01:11:00.672+00
b2a7faaf-4e1a-45fb-976b-fb4c8ae7fa6b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	202.131.1.10	2026-03-31 03:03:01.640284+00
6942a784-fbe4-4eb2-ac84-789e72e23b82	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	67.148.1.10	2026-04-13 19:50:04.264076+00
2600ac45-99aa-42ad-b84f-a5a69c314874	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	174.56.1.10	2026-03-25 17:27:29.795649+00
cc4ff9b7-d428-495e-a226-5bead4a004c7	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	69.231.1.10	2026-04-10 01:39:40.535982+00
b718b3d6-c801-41fb-afa3-bd37e55a0d74	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	181.242.1.10	2026-04-07 18:21:37.924762+00
e8e0f422-4b01-465a-be8c-aa0a208363d4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	188.172.1.10	2026-04-04 23:50:47.779001+00
44a025ec-17ca-4069-9fea-4107536f4c2a	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	9.167.1.10	2026-04-12 19:04:26.031963+00
08759d66-b2ee-4b46-a65b-76d58e3c17fd	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	27.182.1.10	2026-03-15 17:49:21.145298+00
dc25ef9a-371d-405a-80f9-6008de31d740	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	58.139.1.10	2026-03-29 23:53:56.857004+00
288d926a-b49e-43f2-b553-4a91445b3f8c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 40}	212.143.1.10	2026-04-12 11:22:42.902704+00
ceec4b5b-fdbe-45e0-9348-f9052036a3ee	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	192.238.1.10	2026-03-24 14:14:06.490441+00
2e814e4b-0307-4e39-8222-778a25987b5d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	154.6.1.10	2026-04-02 14:46:00.642439+00
d7ec4892-590b-4fb1-a847-7712d7eadc52	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	66.27.1.10	2026-03-22 18:35:40.345997+00
c520bb02-76fe-4765-8c74-0a3646da53b8	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	129.210.1.10	2026-03-28 12:09:29.794614+00
55d5a5c3-e319-4e90-861d-567a980e62fe	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	150.95.1.10	2026-04-02 20:49:07.545939+00
11cf558a-0c1b-4443-92b6-671cf07cf3f4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	5.39.1.10	2026-03-28 10:26:55.796862+00
b27f94c3-2bf6-46d3-b0e0-38807f697fe4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	246.191.1.10	2026-03-22 15:57:16.834237+00
ea873b2c-8270-4c73-a298-fd9cdafcfcae	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	174.62.1.10	2026-04-06 05:16:46.648157+00
44cfcfdb-0e4c-41e8-a604-0c588c5e5afd	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	57.164.1.10	2026-04-02 15:07:52.447046+00
03513883-f585-4301-8cfa-96c7baa38452	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	201.72.1.10	2026-03-18 14:17:28.347745+00
59bbee6e-f777-402c-821e-827d0f41ba53	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	184.189.1.10	2026-03-20 19:32:26.094731+00
854708f6-9935-4bd0-943e-427e4cb23118	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	90.17.1.10	2026-04-09 11:22:58.649936+00
35573b31-c345-47d1-b36d-fe481102eec0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	55.136.1.10	2026-04-13 12:16:46.957479+00
af8325d8-4961-4b7f-ab1b-c55421e2f002	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	231.25.1.10	2026-04-08 02:25:40.033555+00
014e2c89-0d04-46b9-b248-2e90fb5bd872	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	94.222.1.10	2026-03-29 09:12:27.227452+00
bdfa7b4c-e8b2-4977-9cfd-791146749592	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	215.116.1.10	2026-04-12 02:36:47.570387+00
e5c0972b-4c39-4151-9295-160b60c24393	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	95.110.1.10	2026-04-05 15:23:58.036087+00
ae8c0dcf-aca1-41b8-b882-b6bfb92df0ba	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	218.196.1.10	2026-03-21 06:27:09.024132+00
ed64b581-0c0d-4388-8edd-1cc81c0a5f21	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	152.53.1.10	2026-03-21 09:38:38.069009+00
59785f31-f3d0-4f38-b514-92a102d39bbf	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	178.200.1.10	2026-04-06 14:01:09.728482+00
ace91601-2dec-485c-85ae-8ecb9d4aa9f6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	200.31.1.10	2026-03-23 02:17:04.285168+00
bf5369ce-5e2a-4b5c-aa64-3bf3455faa39	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	243.233.1.10	2026-04-14 14:27:15.614773+00
b746011d-3269-4517-8368-95115fcaad60	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	5.35.1.10	2026-03-18 21:25:31.965934+00
6b9a8ff3-f770-4796-aaec-a77ce867d686	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	169.35.1.10	2026-04-01 03:37:24.216327+00
eee9cf39-8774-4f49-b5ec-58e6974b61ef	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	30.37.1.10	2026-03-21 06:51:50.315415+00
934aae01-bd36-457c-b1ce-4c01d2a1f894	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	122.117.1.10	2026-03-18 19:55:46.815528+00
efb0e20c-c21d-4d24-b01d-798c3998a2eb	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	206.227.1.10	2026-03-20 23:06:13.122691+00
d03e794d-4f95-4153-b9da-d697684833dd	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	39.22.1.10	2026-04-14 08:30:25.599458+00
5f78c6e3-51ba-4cb9-b1c7-ca851735bc90	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	202.97.1.10	2026-03-17 08:38:54.745726+00
60f1de5e-b0ce-454c-8a9a-0c081ff35bd7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	1.65.1.10	2026-04-08 14:21:51.940298+00
fda2ae5f-a4cf-4acb-98bf-84fe0003a150	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	196.126.1.10	2026-04-06 14:29:13.565145+00
967516d6-870f-466e-9196-8e81303dac65	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	136.132.1.10	2026-04-09 21:16:39.142319+00
9bf2feb1-bc94-452a-b293-c750f32cef94	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	148.22.1.10	2026-03-17 06:52:48.785212+00
b49ea0b9-72da-4d1a-97f2-35f7a20ac591	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 68}	238.81.1.10	2026-03-27 15:19:31.208957+00
ccf78384-9ed2-452e-af17-5e79ea251727	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	164.244.1.10	2026-04-02 20:05:05.957435+00
198e86b6-145d-46cd-bb69-a24420db7dba	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	41.115.1.10	2026-03-20 07:12:52.894479+00
da971362-e344-4106-ae4a-9ed0cfd6b07f	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	17.108.1.10	2026-03-20 21:46:52.62614+00
bffce9fd-5103-4db8-a165-5216ca69e5ce	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	207.96.1.10	2026-03-25 03:49:15.255424+00
a4ca2064-f37f-4668-92c6-e548dca38a4d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	205.152.1.10	2026-03-28 18:43:17.398448+00
2832000b-ebff-4b5e-83de-2b4a767b9bc4	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	231.80.1.10	2026-04-09 18:23:16.992651+00
a013fe3e-44d7-4ed3-9d94-b9bc8baba52c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	141.99.1.10	2026-04-07 02:22:13.54433+00
11f813ea-9534-4590-aacd-3e505759dbf0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	19.189.1.10	2026-03-20 12:50:30.677309+00
d2512164-b7fb-4551-8f52-298769d75641	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	156.191.1.10	2026-04-01 12:30:46.504538+00
e25c470c-f154-42cd-b568-4e3bb2fb8242	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	133.204.1.10	2026-03-31 09:46:51.359004+00
83b718d3-dedb-44b4-9964-f87c461cc3fa	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	22.149.1.10	2026-04-06 13:00:37.017465+00
d11dbf2f-e6d5-4952-8a10-b5278e9366e8	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	180.216.1.10	2026-04-01 20:19:00.300353+00
7c578d3e-01c4-47ed-925e-bd1d41244859	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	151.55.1.10	2026-04-04 12:40:59.558755+00
5c42fedb-5394-4204-8cb5-7414d7aa83e6	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	25.203.1.10	2026-04-04 12:23:18.040858+00
643f3e79-2519-4a06-8643-f3a88cba59a5	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	16.203.1.10	2026-03-22 08:23:45.486848+00
0be0d32c-cf71-4512-b11d-31cea19e3f7f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	194.68.1.10	2026-04-10 07:44:31.393656+00
5a9e73d6-df97-4b9b-a72b-9491f5d4752d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 22}	57.11.1.10	2026-03-27 15:16:01.265229+00
b9ff0ab0-9099-45ea-b555-759b8d14bc82	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	116.142.1.10	2026-03-17 12:59:16.30245+00
6d674afb-56fa-49f1-80f7-5a4186e73833	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	214.91.1.10	2026-04-13 20:14:46.543131+00
f05c30f5-288b-4605-9fa9-20b2c140fd8f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	147.133.1.10	2026-03-19 20:35:42.266915+00
3dede494-2fa0-4e6b-bb4c-ec8b03eead26	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	211.80.1.10	2026-04-09 10:43:36.480481+00
755c0aef-dcc1-472f-a657-09d3e18f139a	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	71.32.1.10	2026-04-02 04:47:07.403943+00
03f194a3-5736-4bfe-b1b7-2eb7dd243bfd	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	46.88.1.10	2026-04-07 00:11:12.197562+00
e4ccfe4c-3528-4313-84ac-b12d906c2aac	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	150.166.1.10	2026-04-08 05:07:02.888229+00
268801b8-9e2e-46b7-989b-3cdf3cdf0d24	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	63.86.1.10	2026-03-27 08:06:53.79219+00
88cc263b-9c70-4ad3-b6e6-0d0e52e5fcee	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	234.116.1.10	2026-04-02 18:24:31.73531+00
85575835-2868-40ed-bbde-3379f1a8bed2	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	138.0.1.10	2026-03-30 10:23:19.609823+00
fc71b1f9-a801-467d-a3c2-2f67f920b673	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	207.72.1.10	2026-03-23 16:55:03.185297+00
d34c4715-eb3b-4db2-ba07-3e081a138c6e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	89.74.1.10	2026-04-02 11:04:29.855106+00
960b8a56-c435-4a3d-a1e2-8b67eaae984d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	242.175.1.10	2026-03-23 02:40:17.354829+00
6074426d-b8a4-4928-83f4-194d9e2ca6d0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	152.222.1.10	2026-04-11 11:42:22.895925+00
99f9ddea-f787-4e4a-83c4-368e471fe984	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	81.203.1.10	2026-03-30 23:30:59.50001+00
8cd6974e-4c9d-49ce-9fbb-f322c997f7aa	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	247.180.1.10	2026-03-19 21:01:03.667937+00
7d6e5ad0-00b1-4258-b4d5-67cf1e02e83b	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	180.241.1.10	2026-03-16 00:45:32.815701+00
fc63421d-0e3c-4905-9ff8-debf53a8cd9d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	168.23.1.10	2026-03-31 03:57:17.698383+00
a00535fc-bd06-4394-882e-a880f683b348	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	53.54.1.10	2026-03-19 09:20:45.248147+00
b9263950-fa75-4537-8b7e-3e4e4b5ad448	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	7.221.1.10	2026-03-21 00:21:46.848453+00
30cd1820-0978-4d51-80d5-8a5254c42a20	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	251.108.1.10	2026-04-14 01:19:56.399111+00
e24413e0-90b0-4c45-932a-d53a57b628ca	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	13.9.1.10	2026-04-04 11:38:20.12414+00
71ff0b8d-6af1-4b2d-8f69-92a662083640	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	6.185.1.10	2026-03-26 12:39:54.79634+00
af5d34a2-69f1-448e-abe8-d30105d9159f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	149.9.1.10	2026-04-01 19:31:04.123404+00
3134c7b6-3d02-48b3-8e6d-09b34fe3ef54	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	138.102.1.10	2026-04-14 09:01:49.630976+00
85988fb1-fb8a-47d7-b622-86fd82f676cf	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	72.112.1.10	2026-03-17 08:54:46.428315+00
a1b91105-8c8e-449f-83ce-91ae6ba5256c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	240.73.1.10	2026-04-12 22:18:41.626962+00
30cce1b6-7076-473c-84cd-b9b57296e1f6	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	70.125.1.10	2026-04-05 22:26:37.770907+00
9ce6ff3a-f7b5-4ba7-be75-9b38df32c18e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	42.56.1.10	2026-04-05 15:05:15.439581+00
848a5104-cb8b-4557-95b4-5dc3b9dd127b	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	220.47.1.10	2026-04-05 05:46:31.194873+00
930f248f-a76d-43e9-acae-a621af33f4af	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	151.130.1.10	2026-04-01 18:39:43.254569+00
fa30de58-20a4-4516-89e4-f5378a11fb91	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	90.242.1.10	2026-03-16 03:06:47.836174+00
d665e8a1-e104-46d3-b726-2bce902d56af	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	147.209.1.10	2026-04-14 13:30:57.685546+00
7c4a90d4-bb09-4b02-adf9-ee2b110220f9	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 17}	63.179.1.10	2026-04-04 14:28:58.123332+00
067a8c8b-2393-47e1-b074-f67b57ad27cf	e51028f5-1028-4444-8888-f51028f51028	USER_LOGIN_SUCCESS	IDENTITY	\N	192.168.1.45	2026-04-17 04:11:05.908666+00
8463b46e-565c-453a-871c-a2056577572d	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	110.106.1.10	2026-03-23 02:53:26.660156+00
f8b30cfb-6d14-473c-b262-e819ff545534	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	36.210.1.10	2026-04-11 00:47:21.041567+00
5afaab09-fa5e-45c1-afb2-edf5fec90a45	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	207.9.1.10	2026-04-06 18:59:02.47408+00
6e629093-e23f-4240-93b8-f542a2c745ed	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	90.42.1.10	2026-04-10 00:41:58.046614+00
65f461af-e28f-4790-9d3f-5a9c2ca1f3db	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	12.27.1.10	2026-03-31 06:35:48.982919+00
c0f30dba-6ebc-4c6f-8004-909c2231d00d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	24.130.1.10	2026-03-21 03:23:29.775962+00
5f7a7847-ede8-4b97-8cae-78dfb0cdd20b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	36.99.1.10	2026-03-20 10:05:52.936129+00
4e2b5cbf-524f-4ac7-9462-ba22614d5c80	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	29.149.1.10	2026-03-31 03:27:47.040131+00
d60ec722-7a54-4a95-8dab-2b1a1a971661	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	40.143.1.10	2026-04-03 17:39:03.992422+00
c3f4f74f-c7f2-4e41-978a-800d14d8e0c8	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	231.36.1.10	2026-03-22 21:41:56.312097+00
feaa4518-7680-4603-a379-6d281e6842e5	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	14.51.1.10	2026-03-16 10:49:58.005352+00
c1245066-6f14-4fbf-8466-05b39c37c5ed	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	87.145.1.10	2026-03-28 12:54:49.955849+00
4617eed5-da0e-453a-a68d-d2fdcb811a5f	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 18}	156.146.1.10	2026-04-04 16:39:50.045161+00
631841fc-3acf-44b7-94b6-9718b84e0074	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	72.216.1.10	2026-03-21 22:38:51.626996+00
e6f8f9be-e17a-4fae-bf2e-7e7caa224caf	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	110.130.1.10	2026-03-21 09:33:35.816811+00
6ea8bb3f-18ba-4523-b595-4a18de45db87	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	224.127.1.10	2026-04-12 00:28:42.139392+00
b0d40d32-ddbf-473e-a0d1-aef862eaf5c2	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	4.79.1.10	2026-03-26 13:30:55.60628+00
73423137-1d33-44b2-8acd-1db5681e0915	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	72.36.1.10	2026-03-23 08:28:04.361092+00
d4fc13c7-f785-4a18-a10e-41b3dfca8245	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	164.73.1.10	2026-03-29 06:18:30.30143+00
b4d64735-5e36-4228-a3e8-e9d7c78b49c1	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	24.246.1.10	2026-04-13 09:06:57.036028+00
5d466f74-3410-4919-9039-f15b20e93556	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	191.191.1.10	2026-03-17 01:44:57.854725+00
14d758d2-626c-417b-8ab5-4fc7d45a1c03	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	173.200.1.10	2026-03-19 18:01:49.00805+00
d9cf6359-4377-4b17-bca1-ed748f1c8402	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	4.1.1.10	2026-03-18 08:05:23.598525+00
7e57fccf-c5eb-42ed-8eda-3da860375f82	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	143.47.1.10	2026-04-10 00:52:48.111915+00
328d8d23-22b4-4d79-8aad-27ef56d13d39	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	232.173.1.10	2026-03-17 07:50:12.552976+00
2d1a8e38-354a-4145-bb3e-435c2e17316c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	71.224.1.10	2026-03-28 21:11:17.110291+00
e9fd29ba-1364-4362-91ea-f95517400596	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	224.77.1.10	2026-04-10 15:19:58.708479+00
79459531-9623-4b00-b61a-0fa3eea49cf6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	236.65.1.10	2026-03-25 03:49:52.226478+00
d765de3a-3633-4394-8e3d-1a5dc0167316	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	207.20.1.10	2026-04-04 10:02:55.460746+00
dfdac46b-dba6-44fc-86f0-92638faf5ced	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 99}	185.18.1.10	2026-04-07 02:32:55.601527+00
e809fbb3-0f26-4c16-aa92-76125dc766d4	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	202.123.1.10	2026-04-01 21:12:10.781821+00
3b5bfdae-d714-4530-9fdf-ec158715b7d8	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	8.43.1.10	2026-04-02 17:45:20.911499+00
6f3ce9cc-9fb5-498f-a7ce-320ff163f258	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	150.249.1.10	2026-04-10 09:33:51.833274+00
21868587-1fec-4c91-ba50-37e0d8661a6c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	124.179.1.10	2026-04-01 13:10:52.520354+00
c1924bde-5e2a-45ae-9adf-aadd72679e05	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	206.70.1.10	2026-03-22 05:48:46.725832+00
3c35162d-1751-4111-8392-bfc1201f4c64	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	95.159.1.10	2026-04-11 07:32:47.177902+00
e6ea981b-616b-4dad-bb7a-95a307a08099	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	237.75.1.10	2026-04-09 20:08:10.158251+00
a06187f6-9c8e-4736-bb7f-79c4777f8c0c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	146.239.1.10	2026-04-06 09:18:26.496803+00
65c54b17-5578-4c96-8d7d-75b881cd08ef	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	27.92.1.10	2026-04-04 03:43:05.998437+00
c9de1732-4e98-4d48-8cf9-00ac5fe261ea	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	130.217.1.10	2026-03-19 12:23:29.750662+00
af26c03c-2bdd-48f3-bb39-c850647b0071	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	64.85.1.10	2026-03-22 11:38:57.297444+00
fa667e88-b7aa-4568-a781-01d1e42b70e4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	154.13.1.10	2026-03-30 04:47:35.664701+00
b38589ac-375b-483c-a232-f3f51d50c110	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	92.165.1.10	2026-03-31 06:10:23.531453+00
7e6d34e5-8363-4969-8e74-f015d2c79216	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	46.165.1.10	2026-03-31 00:09:30.933808+00
c8167c50-c9ae-4c9e-be71-a305eb430ea1	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	47.234.1.10	2026-03-16 01:19:21.948918+00
6a8f319e-a69d-4d05-bef7-8d5acad513df	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	225.27.1.10	2026-03-24 07:06:40.291242+00
8855e49e-3703-4eb9-afe7-bd8f93280208	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	244.116.1.10	2026-03-21 01:49:16.588671+00
be85efb4-86da-40e4-a373-6fe1de626614	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	116.235.1.10	2026-03-19 23:43:19.411901+00
17bdfaa3-06be-44cb-954e-e16ccdeecbff	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	244.83.1.10	2026-03-17 21:08:48.562941+00
0c27d891-5f64-4e0b-bfdf-fddf7a91ff87	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	81.63.1.10	2026-03-20 18:47:22.870334+00
4e667b38-3b60-489d-a060-8bed43982072	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	178.204.1.10	2026-03-25 02:28:52.587106+00
bfa14c0f-eb1a-476a-a5f7-a53759d5bc6a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	203.60.1.10	2026-04-08 13:15:22.59366+00
19832adb-7162-4b67-bfbc-721d3d2fa44f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	185.163.1.10	2026-03-31 19:22:15.183594+00
fad86637-62f8-4abc-bdb4-e3b753cb59b1	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	153.219.1.10	2026-03-16 01:24:19.817717+00
fe564da9-31c9-4b2a-b13d-98ac8100759e	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	107.111.1.10	2026-03-31 16:00:39.986303+00
ef9f34a8-6d7b-40f0-aa3a-f910461addfe	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	61.96.1.10	2026-04-14 06:22:26.502512+00
a561b267-7b94-4745-8201-272b5fbf3874	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	221.114.1.10	2026-04-13 21:12:00.982068+00
bfb3ff8e-37f4-470e-ac3f-f7805202a9b6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	53.45.1.10	2026-03-31 05:16:06.98608+00
0ed7eccb-0824-475e-b23e-74358e0e3112	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	206.5.1.10	2026-04-04 02:40:44.556221+00
11afa7c7-dee4-45db-9800-a41354cc45cd	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	52.202.1.10	2026-03-27 21:00:43.410803+00
679b507f-44a5-42bb-9518-058352e3d3b3	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	169.154.1.10	2026-03-22 16:34:16.736393+00
31cd1df3-a845-4fe8-b5cb-83b74f99fd89	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	190.47.1.10	2026-03-31 19:20:05.746458+00
0c2e8d04-50bc-4f8c-947a-e210030707f0	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	6.71.1.10	2026-03-16 15:45:30.36969+00
8ca2e627-c30f-4f0e-b6bc-d74037ff6ddb	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	149.26.1.10	2026-04-03 22:09:45.993892+00
7ae1f333-59e7-4d7d-bd14-9596b14ba42e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	253.160.1.10	2026-03-31 07:13:43.213735+00
296d0b92-f76c-4c48-8c20-d6011ecb8391	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	174.94.1.10	2026-03-30 10:15:07.960532+00
e3c0cc32-463e-4074-a4db-f0c61d206ba5	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	20.77.1.10	2026-04-06 03:34:32.858882+00
97cfe0dc-7913-4ee6-a4b5-ee26720dd53b	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	151.186.1.10	2026-04-09 05:04:32.330325+00
b8c554f2-45b0-4baf-bc90-d29469252c71	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 53}	207.19.1.10	2026-04-06 10:33:42.552843+00
2b106ee3-2f31-481e-8198-3c5f9e8304e7	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 17}	32.5.1.10	2026-03-21 11:33:24.321225+00
c5e6539e-706f-4723-aea7-1b79097847c9	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	44.41.1.10	2026-03-29 09:30:10.003475+00
19be4b96-73f3-4faa-8f58-81935811a23d	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	54.223.1.10	2026-03-16 15:36:49.933787+00
f6c5dc8e-d205-4f8f-a2b1-8ce65bf3cf98	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	USER_LOGIN_SUCCESS	IDENTITY	\N	10.0.4.12	2026-04-17 04:11:05.908666+00
8dd18da1-1e33-483a-85ab-88ff9d153de9	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	185.120.1.10	2026-03-17 17:00:01.445925+00
68cb65c7-cb20-40cd-85e2-da3d0e44c28f	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	252.132.1.10	2026-03-20 17:29:34.502705+00
e26b8b2e-4bef-4885-ac41-b19ede12f4c0	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	20.72.1.10	2026-03-20 16:51:38.285671+00
8ae1db73-2f38-4afb-be0c-5ec8c01c948b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	219.248.1.10	2026-04-05 02:16:00.592476+00
16e84bcd-2394-4149-898f-4917ea5088f5	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	58.105.1.10	2026-04-09 08:01:33.363781+00
1d6abfad-2fcd-404b-b287-643f4d3ae0a3	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	2.45.1.10	2026-03-25 17:01:43.638445+00
fbfab516-281f-4b17-8c92-eb643202bccb	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	244.149.1.10	2026-03-17 01:50:44.28392+00
220e3df8-a2bc-4d2b-941c-67152fbaf93c	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	89.128.1.10	2026-04-05 01:33:56.145358+00
55eac469-5166-4699-b07c-b0aab3c634b8	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	158.148.1.10	2026-03-19 07:38:32.508603+00
123c7420-8bf3-44b9-be43-b2071712449d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	213.43.1.10	2026-04-01 11:59:42.764105+00
249640fa-eb7f-4e0b-9d6b-19074a3dfafe	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	8.110.1.10	2026-04-10 01:32:23.803967+00
f55c8d6f-0606-44f6-a112-992508701916	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	204.216.1.10	2026-03-24 21:28:17.104502+00
7df3d129-a640-4f74-bcd3-cbbe6d815047	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	145.192.1.10	2026-03-23 17:05:04.04147+00
5823932d-9683-4374-9f2d-2a463565b6b5	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	104.244.1.10	2026-03-29 04:43:01.082478+00
a088a460-d6c1-43f9-991a-15a7adf4e974	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	228.195.1.10	2026-03-21 13:03:59.18049+00
0d837bb1-744a-4be6-a599-a5269e4e9396	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	115.95.1.10	2026-04-11 13:44:10.577033+00
04f7f06d-d9fa-4511-ab8a-51718e71c039	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	105.43.1.10	2026-04-08 16:30:35.088751+00
55e701f7-33f7-4726-9598-6b183aa75cbf	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	128.254.1.10	2026-03-23 12:12:05.896115+00
aeec0a7c-6287-41a4-b109-d7ff1a68669a	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	6.127.1.10	2026-03-23 16:30:44.635678+00
91e03a48-2014-4113-9159-b74677007158	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	76.52.1.10	2026-04-10 21:50:49.100921+00
c506f812-7f84-4bc0-b13d-ce125afb13c5	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	228.190.1.10	2026-04-12 16:44:50.470948+00
391a3e1c-3c98-46fa-a6c9-9530f49ecde1	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	31.172.1.10	2026-03-31 11:45:17.869228+00
e69c93a0-288c-43b0-9501-bb3199cbcd62	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	7.176.1.10	2026-04-05 16:35:03.058396+00
6b50eec5-55ad-444f-b89e-08c02416b614	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	138.2.1.10	2026-04-11 16:14:30.994776+00
d9f9a198-a116-4091-82e6-aad88263e708	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	145.196.1.10	2026-04-08 22:12:59.886451+00
69ab045b-ca18-44a5-ae59-21673841a504	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	133.254.1.10	2026-03-26 23:51:02.966993+00
7a7a21dc-26d9-412b-9ecd-27b82800b8a1	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	177.206.1.10	2026-04-07 21:06:27.564343+00
ab282614-b716-4e4d-9794-3435d9c6fe6a	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	36.240.1.10	2026-03-23 20:05:34.726148+00
182064ae-4e5a-467c-8840-e0bae13e6865	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	216.44.1.10	2026-03-26 06:23:45.464384+00
f6c16afc-7a63-4759-982d-86f5ff337a6f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	205.144.1.10	2026-04-03 13:56:36.039786+00
07b3fa01-0252-4b82-891c-8bba7824cdf4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	239.0.1.10	2026-03-21 11:09:50.021961+00
8cddd58f-cf48-4fd3-80eb-01f8b1f5310c	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	76.19.1.10	2026-03-19 15:41:07.045234+00
cff4716e-91ba-48f8-ad96-2ce1b1bc0ef7	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	114.77.1.10	2026-04-12 19:30:01.993043+00
5fab81ab-9f0e-4eb7-aa1b-3b11634113d4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	25.206.1.10	2026-04-06 23:03:33.775345+00
d59faa55-2f6d-4e51-b13f-f3a006dd5459	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	3.89.1.10	2026-04-01 05:12:05.503594+00
ab8b48ff-2ad1-468f-a174-ca4a2ce97c54	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	91.155.1.10	2026-04-01 10:53:42.470368+00
7c4ed180-8dc8-4855-aadc-da0cf102ce7d	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	USER_LOGIN_SUCCESS	IDENTITY	\N	172.16.0.8	2026-04-17 04:11:05.908666+00
202d7661-adac-4e4c-9c0c-5086460170d0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	193.8.1.10	2026-04-14 05:17:00.854549+00
1078f690-b22e-4a7e-919d-9cac09ad3bfa	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	101.0.1.10	2026-04-07 10:46:40.140029+00
d911548f-b0a6-4bcb-97db-bb1c3a4c3711	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	173.148.1.10	2026-03-18 06:10:08.840904+00
debc077a-3b11-4e6f-8b4b-60de6a7f0bb0	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	73.156.1.10	2026-04-04 18:18:54.23271+00
867a603e-0586-4b5e-a936-6c8ca4168ced	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	176.5.1.10	2026-03-25 19:20:25.475527+00
47d803b9-ecd8-46b7-ac9a-6a61c64e0076	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	45.53.1.10	2026-04-10 10:11:18.107276+00
a52817ce-9bd4-447d-b309-19ddcc474cfa	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	115.176.1.10	2026-04-02 13:17:22.560338+00
0b88d8bd-ddc9-453e-9401-a7982ce88e71	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	190.27.1.10	2026-04-13 14:22:49.745094+00
77d69e91-b42c-4019-b89b-a51b84405de7	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	103.90.1.10	2026-04-09 16:18:37.139344+00
3b1b57a7-1a90-47ba-9d34-f3ba5fb7fe5c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	87.218.1.10	2026-03-30 02:45:13.176427+00
474b153f-e975-4996-99ca-4d8825373ed7	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	248.40.1.10	2026-03-29 03:17:52.436089+00
95c10f8c-6200-4b9e-b6d7-6184163429d8	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	171.113.1.10	2026-03-29 16:02:15.838662+00
6d9a8228-00f7-432e-8bf3-600215d374a3	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	240.10.1.10	2026-03-19 02:25:50.873805+00
71184164-b093-4361-8411-0ce5beaf956e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	207.32.1.10	2026-04-08 19:28:48.262084+00
3fd3020f-6dba-4430-93e1-b98896adf823	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	49.234.1.10	2026-04-13 10:13:50.08592+00
bb2a1bcb-863d-4fe2-a3ec-8d98dcf91e46	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	129.253.1.10	2026-03-16 11:51:29.91009+00
1b4ab171-70bf-45d5-9b23-62abced473c8	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	13.6.1.10	2026-03-28 07:02:20.536192+00
3afae76a-fc10-41c9-8aad-971e61901f57	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	89.83.1.10	2026-03-18 01:04:05.002939+00
82943536-ef82-449f-bfde-43c3df1fc176	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	227.102.1.10	2026-04-12 18:21:01.716735+00
2667197a-a6a2-4d9e-aeb8-4cee24bd327a	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	20.63.1.10	2026-03-16 18:31:16.668281+00
c8e7d8ab-872a-4d2c-8a43-c67a23de5959	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 99}	167.239.1.10	2026-04-01 20:00:29.246013+00
350d8d3c-3c2b-4b35-9355-020321957526	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	113.207.1.10	2026-03-18 00:48:34.873158+00
718a1f1c-ce56-40b4-9b5e-c96ee9277a25	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	142.42.1.10	2026-03-29 05:44:43.064513+00
766074f1-f04e-483b-ae27-ca160dc461cb	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	208.10.1.10	2026-03-30 02:59:25.035709+00
1f241c18-49a5-4241-bd28-f95a5dc2c377	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	241.175.1.10	2026-03-17 13:41:18.471914+00
93820557-036b-4652-8966-a5639346e6f8	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	173.123.1.10	2026-03-31 15:44:45.771796+00
22718145-b164-4e01-9ae6-44e6f92eb66b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	85.110.1.10	2026-03-15 19:27:36.731007+00
13bbebc1-df12-446d-ae88-f2e90afeec7d	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	142.66.1.10	2026-03-31 16:42:02.181571+00
198612e5-1c60-42bf-a114-5483d83c2a74	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	10.213.1.10	2026-03-27 17:07:18.388802+00
648b7573-acfe-466b-9892-0b673e4c57cc	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	29.24.1.10	2026-03-24 17:32:30.576384+00
c5303227-3766-4360-89a8-f7fff46d227b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 68}	30.28.1.10	2026-04-12 11:26:19.63348+00
db3f230b-53c6-4be7-a786-1aa96b34d8e4	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	35.106.1.10	2026-04-14 12:40:29.661556+00
f6e15cf1-f56e-4914-9609-12fd3806b76a	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 97}	43.47.1.10	2026-04-06 23:52:50.966422+00
5e434c38-ce3a-4912-9021-eb9a734da098	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	84.175.1.10	2026-04-11 18:47:37.904202+00
0420802b-2fe3-4707-8561-ebcd6ef21637	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	238.58.1.10	2026-03-21 07:03:39.790807+00
aed1031b-49a0-4504-9568-dfbccfe6ab28	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 32}	108.141.1.10	2026-03-27 14:06:17.439855+00
2bbe74f9-8659-4fe2-a15b-4dbea1bafd67	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	17.188.1.10	2026-04-10 03:09:17.261566+00
febb9197-002f-42c3-86f2-2c546b8b0045	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	126.235.1.10	2026-04-12 22:27:23.615852+00
f573f95f-efd0-4c66-a2f2-b299895fb121	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	165.185.1.10	2026-03-16 07:09:28.395616+00
7f1b56db-d8b4-4685-b60a-2a48830d4d86	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	29.90.1.10	2026-03-21 04:54:53.33919+00
725df0b5-92d4-4f53-8f2c-25324c395931	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 40}	92.81.1.10	2026-04-03 23:53:33.046853+00
f007f939-dc66-43c3-a2ce-26f2627f2806	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	122.24.1.10	2026-04-11 06:38:50.517286+00
de01c75d-8f82-4ecc-9891-9055eff7489b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	130.4.1.10	2026-04-11 19:02:02.773379+00
b1bf18ea-fc06-4f8c-ba67-96ff1a6387f0	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	70.73.1.10	2026-03-22 11:31:43.853074+00
8845af32-3a2d-4d1a-ab69-ab13094d67fd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	96.57.1.10	2026-04-10 16:01:33.528234+00
96373a91-8592-49b2-96ae-210bc77e825e	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	186.202.1.10	2026-03-30 21:54:02.097784+00
ecd38519-4374-4916-94b2-5ea5d7963ac3	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	139.97.1.10	2026-03-16 02:36:13.315881+00
925daaff-931e-4c28-ad1a-878dec9bd47d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	213.27.1.10	2026-04-07 16:54:41.963685+00
09eceb42-82cb-468e-96a2-40993f2c7f51	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	59.223.1.10	2026-04-10 10:51:09.334582+00
c351a71b-0886-4796-86e2-b4f05d8cf87b	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	42.99.1.10	2026-04-09 12:29:06.696452+00
4f2f25b7-fa78-42fc-ad94-98b2a9e9e69f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	218.105.1.10	2026-04-13 08:13:58.158099+00
6ae4ded7-e1da-461c-955c-bd4e4ddc861c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	131.238.1.10	2026-03-31 11:54:34.945118+00
a4a4d03e-5950-4afe-8816-52487a600a4d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	241.100.1.10	2026-03-28 22:36:49.629135+00
b79a1f05-4095-4588-8ba4-6ef8252d9d66	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	91.226.1.10	2026-03-26 14:13:47.278212+00
51e9293b-6990-4f98-9f73-58e98bedb845	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	42.112.1.10	2026-04-12 12:21:24.376774+00
b246c2ec-cf0c-4729-8b22-8cb283a3a5be	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	46.142.1.10	2026-03-31 05:07:15.148457+00
4eaec250-82be-4c01-ad3e-7dd9db4c2c04	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	49.197.1.10	2026-03-19 20:42:06.201411+00
061c6f86-82b1-45af-8c43-85e500567aa9	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	191.178.1.10	2026-03-19 11:25:11.310657+00
dedfd271-ed64-4237-a35a-71861bcc4ea7	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	142.47.1.10	2026-03-24 01:11:04.386086+00
b540cf68-54d0-4e90-9c0a-12b162a22e98	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	122.186.1.10	2026-03-24 11:04:03.83984+00
512b7516-cdbe-4e59-b801-b66f2ea3014d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	182.160.1.10	2026-03-22 10:06:59.254343+00
4b5124cb-5a07-46c1-bdc3-c8101cde343e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	234.129.1.10	2026-03-18 05:59:11.695391+00
ed3eb9d0-6413-4cdc-ae66-2e736e8715d3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	89.203.1.10	2026-03-22 04:11:45.155777+00
9094d121-1c33-49a1-9978-3c41aa3b83c0	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	198.169.1.10	2026-03-24 09:34:24.99947+00
9ec21306-c5a3-410b-b336-d26f47e26b86	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	231.149.1.10	2026-04-03 11:18:49.954729+00
b7a1bb1b-4261-4938-83a9-dcce994e3068	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 97}	224.25.1.10	2026-04-05 02:45:21.484096+00
3d214718-b07c-40e7-8333-eaaba70eb5ae	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	204.1.1.10	2026-03-30 11:17:38.657015+00
23024db2-1b26-4995-8c4f-aaaae65b8661	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 32}	102.196.1.10	2026-04-01 07:52:04.870374+00
49bd9440-c208-42ee-bedd-eac3ceedefa1	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	31.223.1.10	2026-03-24 20:05:03.100438+00
40cfbd41-12b9-4690-9f55-5d4a2d7132c6	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	139.173.1.10	2026-04-09 19:25:56.08886+00
c3db6bf1-05c6-48db-b9b1-079124ac042c	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	244.180.1.10	2026-03-29 06:09:16.139506+00
5ae03d11-644c-42b7-81c3-234c67171f81	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	88.23.1.10	2026-04-07 22:20:55.171238+00
d914033d-b04c-4e7e-a239-f1048c4dfa10	03bf32d6-485e-497b-8888-ceacee875b65	USER_LOGIN_SUCCESS	IDENTITY	\N	192.168.10.100	2026-04-17 04:11:05.908666+00
f519a07d-ddda-4ddb-becb-c669bc4f73b0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	134.170.1.10	2026-04-02 08:38:00.368593+00
326c45fd-9857-4f82-887c-54b92ff42495	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	51.176.1.10	2026-03-29 18:00:38.713022+00
bc7b9327-d778-4d1f-a550-c81915abc1ee	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	187.124.1.10	2026-03-19 18:57:37.879737+00
8375ed84-4dee-4eca-834b-b07883e0407e	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 22}	202.122.1.10	2026-04-02 20:39:21.355161+00
3ad83fd9-74c6-4029-8c68-5d7a6b442a19	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	138.147.1.10	2026-03-30 09:36:55.704394+00
507e55f9-fa84-4831-b821-893f3fbb7f8d	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	220.35.1.10	2026-03-26 13:26:27.981032+00
f4ba2d5d-603e-4485-bec5-a2138d15b420	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	10.115.1.10	2026-03-23 21:32:42.668326+00
8adf12da-56a5-4d7b-b0d7-ef0347fcf373	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	92.93.1.10	2026-03-24 05:09:06.477781+00
707275f0-7e61-418e-9615-dd57cc6d93ad	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	105.57.1.10	2026-03-20 08:48:44.656929+00
5d6a5d38-af16-4fcb-98f5-c442b9e69afa	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	4.209.1.10	2026-03-25 12:56:19.38329+00
d836b515-334e-4931-8638-05cc3c11a5dc	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	115.159.1.10	2026-03-27 10:26:48.364078+00
9ff6c7d5-1020-4123-a1a6-48f7b71135e2	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	99.55.1.10	2026-04-11 11:42:17.55311+00
de9a68d6-508c-4f13-808e-b81a4dfee61c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	129.218.1.10	2026-04-11 18:28:33.142758+00
b247ffb1-0f03-4041-9b40-484718263f0b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	223.227.1.10	2026-03-30 05:10:43.584662+00
6fcea6e9-eab1-4b92-bc05-43eb7f687f17	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	65.83.1.10	2026-03-28 09:50:39.019273+00
c26f2b7a-6e85-4a71-92d6-523ee5ed20ba	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	25.27.1.10	2026-03-28 18:35:29.554673+00
237cd66d-351b-446b-b169-6bacbeb168d3	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	206.85.1.10	2026-03-21 19:12:50.449621+00
76f02869-16ce-4cfd-8b41-68bf9c4d0c8f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	253.227.1.10	2026-03-18 08:19:15.853214+00
89a83c68-e1f2-45f9-9267-518b359512f9	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	231.172.1.10	2026-03-27 14:23:48.066977+00
476c397c-f433-465c-b3a9-5fb4c55d51fd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	6.140.1.10	2026-03-19 12:35:42.046968+00
b89cb202-c1cc-4118-ab62-7db081de141e	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	188.71.1.10	2026-03-22 07:54:09.043039+00
4a291ce5-254a-4311-b9ed-f3859db3d4af	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	63.153.1.10	2026-03-28 02:09:33.483777+00
5f532ffe-4a62-43c6-aaf0-6f61bf09d1b5	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	152.54.1.10	2026-03-20 13:14:11.647585+00
d1765065-89b4-47bf-9395-65f21b38c468	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	225.25.1.10	2026-04-02 00:33:31.660558+00
2cd2d060-79fa-4c18-bbf7-f36e2d8e428f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	107.238.1.10	2026-03-25 10:45:59.214405+00
a7e0c710-6f14-4ec9-b5d1-163db1c986b5	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 17}	66.71.1.10	2026-04-12 01:14:16.234633+00
98e1bd4a-2e85-459a-ad59-89a180433997	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	221.24.1.10	2026-03-27 08:27:51.433124+00
fa38962b-d323-4c17-8aeb-e72fbd24d046	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	203.148.1.10	2026-03-29 04:41:11.976943+00
405fef3e-5556-4714-9f4c-0890dd5ff1fb	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	3.158.1.10	2026-03-27 22:32:50.667115+00
f7eaa8e8-08c3-41ed-b292-7076d0d24c83	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	32.254.1.10	2026-04-04 00:35:22.743074+00
ce3b4714-0440-4b54-bd2a-0aae1468aa6f	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	183.215.1.10	2026-03-20 20:56:06.85058+00
222eb708-3a72-45e8-bdc5-3dd8403b5db3	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	202.145.1.10	2026-04-09 18:34:37.289779+00
6e8c0596-7d76-48e2-a061-0d0c0046120e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	87.145.1.10	2026-03-23 17:52:31.233303+00
06e44b34-4af0-430c-8cc4-4906c74ee61e	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	8.178.1.10	2026-03-18 23:27:52.878374+00
7dcdd79d-798d-4bad-a539-a7e2ca01c874	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	126.60.1.10	2026-03-26 13:36:36.356796+00
c21a5459-7e08-4dd5-85e8-62840ccdad8c	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	103.230.1.10	2026-04-08 10:47:42.783302+00
0df79ad8-5894-48da-b764-494aef727cf9	c6c449e4-ec43-4c95-811f-f87da31d1321	USER_LOGIN_SUCCESS	IDENTITY	\N	10.0.4.15	2026-04-17 04:11:05.908666+00
ecea526f-e93b-40ce-9220-b06e154faf6d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	238.5.1.10	2026-03-27 04:24:08.088075+00
ab636190-1512-4ed8-ab92-3b6c697df022	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	194.71.1.10	2026-03-30 05:09:49.419557+00
ad7a1f52-a844-4120-bfd7-a276f343d65f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	211.191.1.10	2026-04-14 09:54:34.949508+00
8d2fad54-5746-43c0-b0f2-0c00e667e543	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	120.26.1.10	2026-03-16 22:16:48.769771+00
ae960f21-862f-494f-87ca-6a13587a6159	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	72.106.1.10	2026-03-18 15:43:20.821704+00
a8cd08bb-986c-4673-9414-685b36dc4305	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	125.182.1.10	2026-03-23 11:01:29.043627+00
0ba20084-0a21-4b1b-853a-43f60c419969	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	205.140.1.10	2026-04-11 00:34:43.231097+00
50b5fbe4-505f-4bb7-a597-133baa7a3c2d	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	209.110.1.10	2026-03-30 12:52:40.919256+00
9298e9f5-198c-476c-b16a-35863da28706	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	54.151.1.10	2026-04-10 18:19:46.572724+00
726bae53-afcc-4693-ba80-05eaa41eed9e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	133.244.1.10	2026-03-26 05:28:49.923968+00
92eaa36c-34c5-4190-92af-3c316c56ba15	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	81.49.1.10	2026-04-03 10:54:46.765927+00
1434d28f-9914-4dca-82e3-2a7955601d07	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	253.52.1.10	2026-04-12 13:14:39.025798+00
a636866d-012a-454f-ad29-989fdad97c9d	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	15.19.1.10	2026-04-10 13:47:46.068687+00
332215b9-3e96-46f3-9125-e3fc9c43eb47	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	209.211.1.10	2026-03-24 01:02:49.190776+00
88e761e2-8c2f-4db6-b4ae-fde4ef2a1bef	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	129.25.1.10	2026-03-16 11:07:27.94284+00
921fbd78-281b-4e89-86ed-ea90d1fbc59c	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	190.58.1.10	2026-04-08 00:07:58.066162+00
fb12d81e-171e-40fb-bcea-e2af1fd29121	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	128.242.1.10	2026-04-10 22:28:07.479715+00
e004b510-3389-4f6a-8983-49b829eb3b8f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	110.17.1.10	2026-03-30 05:32:21.0405+00
20ad941f-43c0-42ec-9a59-8cc91706e7c2	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	206.48.1.10	2026-04-12 15:44:38.56814+00
c08ea524-f26d-41be-9049-dc4615d588be	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	126.9.1.10	2026-04-08 20:43:37.846178+00
65a4212a-80f5-426a-aa82-c9392ee772bf	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	152.4.1.10	2026-04-14 11:57:46.419746+00
fd7f4a24-8300-4465-83a8-8871a7c49a4c	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 18}	115.109.1.10	2026-03-25 19:30:38.071607+00
e139bb59-513e-4bdc-b166-a37e535a803d	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	160.164.1.10	2026-04-02 06:45:56.34916+00
ff622361-019d-4efa-8613-f8c1c401f500	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	121.219.1.10	2026-03-28 08:35:10.629033+00
5e9bd25c-bd40-489b-bab4-0b7ed8ccb53f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	138.90.1.10	2026-03-27 22:37:13.081101+00
68e1fec1-fbfb-4b7e-ab2d-f14e29910508	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	123.67.1.10	2026-03-31 12:27:24.015905+00
73125f95-644f-463c-9ee9-e580330d8e3e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	3.125.1.10	2026-03-29 09:16:58.425523+00
ae7a9700-4e8f-4c68-9791-475a2c7d58ca	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	61.206.1.10	2026-04-02 18:34:26.617831+00
b493d64b-561e-41c0-8478-59e73be98827	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	207.190.1.10	2026-03-30 00:31:11.714191+00
0c6a2b70-cb17-4f59-8c16-7b79ead56fbf	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	38.83.1.10	2026-03-21 14:55:31.027007+00
9282db85-c9cf-4490-9689-2901c1bfa735	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	171.13.1.10	2026-03-30 12:02:43.88905+00
8e145207-8976-4dc7-abd1-83f4259de54d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	124.30.1.10	2026-04-01 14:46:56.650427+00
d085e232-d257-43a0-8e86-f20bfbfecab4	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	248.208.1.10	2026-03-23 14:51:34.04803+00
de7f9447-1abc-41e5-8097-6cf33ec4eeb6	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	177.67.1.10	2026-03-21 00:21:45.705298+00
13ee421e-a574-4746-8b28-d1de172f99a0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	64.126.1.10	2026-03-27 08:26:50.820633+00
c5060a3a-9bb5-4f40-bf73-10cfe7c67232	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	210.72.1.10	2026-03-17 06:45:56.101233+00
498aeed3-0c20-43b0-97e2-193a99f50f5e	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 53}	152.251.1.10	2026-03-17 03:48:40.499888+00
d37b7a69-48f6-4df5-9f97-2d93320974e1	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	45.9.1.10	2026-03-16 20:39:10.755379+00
4ce7eeea-7a17-483d-bc5c-b1dec4bccb88	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	195.54.1.10	2026-04-12 04:37:41.629731+00
564936e0-e9e2-4608-8df9-9654dd873497	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	91.114.1.10	2026-04-12 13:34:13.670234+00
7be9cf47-623e-4ff2-9db8-a2fb7bbde66a	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	176.99.1.10	2026-03-26 19:35:25.59085+00
4c839164-48d1-4ee5-85e0-57342c412745	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	27.20.1.10	2026-03-24 05:39:58.259612+00
98a0b24e-31d5-489c-9abb-6b3d746b5675	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	190.252.1.10	2026-03-31 07:25:50.886816+00
cd1eec69-a4c1-4f02-bbe5-fdd501198538	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	248.206.1.10	2026-03-31 21:54:42.247436+00
94f4be2e-c627-42d0-85c5-abafdfee83f5	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	153.16.1.10	2026-04-06 12:25:15.525928+00
6a4f614a-a51b-4b95-aae9-8570bfdf3cdc	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	35.182.1.10	2026-03-19 08:12:53.415429+00
19beee7d-ff09-4933-b8ce-1b1a30e3f2cd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 97}	90.92.1.10	2026-03-25 00:47:59.429512+00
e1dc65f9-87f7-4551-b832-6a83491ab543	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	147.20.1.10	2026-03-16 16:34:34.153545+00
9208f6f3-9ab8-4017-a577-7675a0e38dfe	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	27.154.1.10	2026-03-21 03:53:02.070689+00
07bd5d71-80d7-4d9f-ba3b-941cc874a4cc	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	235.131.1.10	2026-03-23 09:31:29.8787+00
8bf9deaf-a844-4f23-9c35-a17e50d4c3d5	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	102.242.1.10	2026-04-11 21:35:07.336811+00
edd9f875-e33d-4403-af20-ea408071760e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	139.131.1.10	2026-03-19 09:37:59.917414+00
7877ae8c-e2cb-4d8e-a5aa-75512907473b	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	120.133.1.10	2026-04-11 03:30:35.847709+00
1887c146-6436-4322-b77a-a0a877ec524d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	222.127.1.10	2026-04-09 08:46:36.785248+00
24d711be-c288-4307-83fe-fbf4fe5dab42	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	227.157.1.10	2026-03-26 13:58:32.656984+00
ed4410be-a814-432b-bafc-3782fad75858	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	150.68.1.10	2026-04-05 20:51:31.907305+00
36738359-69af-45f0-b09b-4897d44d7608	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	84.166.1.10	2026-03-24 12:58:42.158326+00
d50cdaa3-008c-4513-b0c4-673883d3ef67	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	113.224.1.10	2026-04-14 08:09:30.487274+00
f9101807-bf2c-48ea-8df4-88bb87923501	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	22.119.1.10	2026-03-25 23:37:35.627195+00
e928fa7b-058b-4bcb-aeda-e628eb58906e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	196.193.1.10	2026-03-18 10:54:42.628983+00
cf1176bc-cb86-4a5b-a040-812752f54e77	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	61.220.1.10	2026-03-22 08:07:30.688828+00
af649a71-1528-4f4c-8fe9-2a56e1a8d698	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	39.111.1.10	2026-04-08 12:26:16.123634+00
7eacc6b9-dc7d-4488-8e88-fb247d874eb0	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	190.41.1.10	2026-04-05 08:17:10.582648+00
b0f43fd7-9687-4334-87c0-ff192aa4d8f4	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	116.36.1.10	2026-04-13 03:21:06.467031+00
ad2d6b4d-c224-451a-abde-ce39a5f94976	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	22.145.1.10	2026-03-17 22:40:46.653361+00
a4fb4716-734f-4f91-8c39-46bf69978651	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	245.114.1.10	2026-03-19 16:00:27.005433+00
9f4f6579-4b85-4865-aab3-e775d7f95bb7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	38.68.1.10	2026-03-23 10:10:51.656244+00
2115f0e9-0697-425f-b904-271cd90fcfc7	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	60.107.1.10	2026-04-02 15:39:57.794833+00
55e143c8-a85a-4bb3-b339-d19b801dd58a	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	50.26.1.10	2026-04-13 21:38:25.256974+00
49f648da-7ce2-461d-b750-33aa8cf745ac	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	248.22.1.10	2026-03-22 11:51:20.332022+00
93e7678c-f6f0-4bdc-b18d-6ea6174c0481	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	26.208.1.10	2026-04-14 08:06:46.131796+00
d2ecd758-fc0d-4ed1-b36b-3b05aa263526	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	55.173.1.10	2026-04-11 16:57:07.906835+00
cb12155d-6bb0-4581-aa9a-e6293ef64252	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	122.111.1.10	2026-04-02 15:57:46.228274+00
7d7f595e-a3b9-4656-aeb4-ea25db2e1d55	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	197.72.1.10	2026-03-18 07:23:28.477121+00
6b0821a0-1864-4155-a9f8-26c9086dbf6c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 17}	205.102.1.10	2026-03-17 12:39:17.008165+00
4603985f-63d4-4af4-90c7-c4d98a4c17f9	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	46.160.1.10	2026-04-12 12:33:12.140043+00
b3fd749b-cda4-4854-88d0-133c75c3ff2c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	171.138.1.10	2026-04-05 13:33:38.987656+00
43465728-2965-4397-80cb-ab936412551f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	146.4.1.10	2026-03-27 17:28:11.956674+00
5187ab67-f5bd-4db3-9cb4-a54c18181aca	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	251.238.1.10	2026-04-12 09:25:02.443601+00
f915e62b-1d76-4bce-ba7d-3964ee2ec500	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	1.142.1.10	2026-04-07 10:53:27.079647+00
a3e11f35-38df-4fa9-9f91-33aa9a14a7a0	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	110.93.1.10	2026-03-28 22:17:26.707834+00
d5239855-dfdb-4f14-bfe7-d276aa7aac51	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	112.153.1.10	2026-03-22 11:02:16.558323+00
142e8a48-2be4-4008-8636-1958de160c00	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	175.135.1.10	2026-03-22 05:28:16.559777+00
fabe159a-a14c-4384-b867-e80f966ae5f3	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	14.44.1.10	2026-03-18 11:00:57.336339+00
75596889-8709-4ad3-8be4-8a83268adff3	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	75.246.1.10	2026-03-25 16:39:35.082615+00
09880cf4-c36e-4f14-bd73-aeb393cc35a9	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	129.211.1.10	2026-03-29 17:50:51.934745+00
020e41c8-1efc-41b8-9d18-1b876819826f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	159.7.1.10	2026-04-01 04:40:41.479263+00
07c3408c-211a-467a-8f3a-6914549b9b83	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	61.43.1.10	2026-03-21 07:11:14.374519+00
2889b6d0-bf8a-4469-8052-75505d65a6b4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	99.242.1.10	2026-04-12 14:51:14.134928+00
39456e70-9020-4614-8908-b554cfc04bfe	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	32.157.1.10	2026-04-13 02:34:39.621689+00
bd046d92-d179-474d-b5ab-007e967ed525	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	121.153.1.10	2026-04-10 18:02:49.390092+00
03dc0194-f958-474d-b1bc-7615ed2345c0	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	31.203.1.10	2026-03-24 04:07:13.386682+00
c5823333-e387-4cde-8052-19fcc5177e2a	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	73.101.1.10	2026-03-21 19:00:40.79507+00
5f6f4e35-5533-4a98-922f-523fafbf8c59	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 17}	29.24.1.10	2026-03-30 15:03:29.594247+00
c025e957-b1c3-4ce3-a6bc-b365ab46f51f	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	20.88.1.10	2026-04-05 11:29:13.206951+00
1d22e1a0-5c16-4e1f-8059-88e5d70345cb	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	51.194.1.10	2026-03-28 12:34:08.795939+00
05327b0a-142a-465b-8d77-04a594767eda	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	220.136.1.10	2026-04-11 16:57:26.983189+00
dc965d11-f08b-4080-adea-9e52fbf6fdd3	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	237.32.1.10	2026-03-16 03:42:26.724424+00
1d1b81d1-5653-4d1a-8417-d385ffc85ef6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	86.122.1.10	2026-04-04 19:02:56.957233+00
8e1f6f78-29d2-4b21-aa5d-d5cbfdfccb9e	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	5.245.1.10	2026-04-08 02:13:11.50939+00
f7e0b344-0c19-43c2-a33f-0fe034e972bc	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	36.192.1.10	2026-03-25 18:48:53.451577+00
7b74c82b-3a8e-43e5-a4fa-6abbe3fb4055	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	123.19.1.10	2026-04-13 05:59:13.775117+00
e9fbddd8-b799-4b4c-890b-412cc95ecfce	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	8.173.1.10	2026-04-06 20:14:59.844166+00
a2a1f349-f0cf-4b74-aa54-f5e67f881a74	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	248.2.1.10	2026-04-01 18:39:13.940214+00
5f6f56e1-69fd-442a-90af-bd15d2b0e05f	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	20.213.1.10	2026-04-09 09:49:11.669973+00
9cfca8b2-9961-4d5a-8abf-c785704c9da1	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	225.77.1.10	2026-03-20 18:33:22.530847+00
8b39636d-867d-45f5-8cff-561cd3b7a1c0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	54.227.1.10	2026-03-25 23:45:00.61144+00
48a5a5af-1833-4360-8756-68d1add2d701	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	146.164.1.10	2026-04-10 06:32:37.677917+00
183b153a-739d-43b0-aa35-1d989da11d66	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 18}	185.194.1.10	2026-03-17 12:10:59.290889+00
e80784b7-9b7c-4c3d-b5ba-f2dfc2d29add	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	19.194.1.10	2026-03-27 21:48:21.162557+00
42541d5d-49e5-4396-aeca-9c5d0db3397d	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	31.232.1.10	2026-04-05 20:15:54.259547+00
d7d46934-453c-4fd5-bd98-20cfc6902f0b	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	188.181.1.10	2026-04-04 10:45:46.327355+00
d3e3e773-ff7b-4ef5-a4a2-5f9e17c88369	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	239.96.1.10	2026-03-25 04:20:55.634523+00
003ff1e3-78e3-4c38-b7b9-f8ea326fc124	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	4.104.1.10	2026-03-28 08:35:06.873871+00
01b26de2-bd1b-4321-87bd-d8cda5902df6	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	218.247.1.10	2026-04-06 11:43:37.696167+00
321f380c-78af-4d68-be41-01947908c9d9	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	239.145.1.10	2026-03-31 16:30:01.253789+00
fe72ec9f-aa27-4231-9319-3a65d352c539	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	23.196.1.10	2026-03-29 05:34:23.876636+00
93a2b2c1-4a4d-40f8-bca4-7099921b3e58	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	83.23.1.10	2026-04-14 01:52:18.949758+00
e61d83e6-4b42-4878-805b-a20e2908321a	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	205.233.1.10	2026-04-10 11:07:13.976641+00
877e4f0c-42a9-462c-9256-d288ecbcd5e0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	120.184.1.10	2026-03-20 09:25:46.50673+00
75617051-4341-42b7-b313-8c2d9b2c1c76	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	223.10.1.10	2026-03-25 09:19:06.026793+00
ba799a1b-85bc-460c-ad65-c94fdc5dfcd2	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	178.156.1.10	2026-04-11 17:27:31.786756+00
89b5a3c8-f069-49b0-a86f-a55978aa3a14	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	198.125.1.10	2026-04-07 16:38:41.32713+00
fbc38afa-96f6-4668-ac53-ad927573cf82	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	209.218.1.10	2026-04-03 21:16:09.61694+00
6e82add5-83ee-43cf-b9da-f778da83e266	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	205.33.1.10	2026-04-09 03:43:30.918938+00
50f2dbbe-0470-48dc-bab1-23642698f033	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	89.207.1.10	2026-03-25 07:46:53.050901+00
157e22e2-55c3-45a0-ad73-ad5e7f98b72c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	182.34.1.10	2026-03-16 05:18:19.356356+00
f55aeff2-9942-444d-85fa-ae47afbc6aa9	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	22.78.1.10	2026-03-21 08:02:09.871543+00
6fcc74e3-9ee7-4f54-bae9-69363adbabf9	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	252.210.1.10	2026-03-20 12:29:05.954154+00
722c4d9b-90bb-48fc-a900-1b6163026974	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	176.30.1.10	2026-04-01 02:57:31.447291+00
a571e39c-0d4f-480e-b880-86844c8082ef	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	123.146.1.10	2026-03-25 03:56:43.901053+00
f3645a2a-d244-4254-b49f-90919ef62e73	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	218.139.1.10	2026-04-13 22:51:34.833053+00
6dfd6e70-1ba8-4915-a6f3-4a513195a48f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	165.113.1.10	2026-03-31 18:38:02.533408+00
903a0639-2801-40b1-960b-bd089eb0f62a	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 44}	189.42.1.10	2026-03-17 07:41:29.987194+00
2f3abd8e-c1c4-43f5-9e5c-6fae16374130	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	33.191.1.10	2026-03-25 15:12:57.310618+00
ef90ea3d-9bce-4939-9055-ae4d1b1833db	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	7.249.1.10	2026-04-12 14:35:46.600079+00
eeaca7d6-4f1f-41b5-937a-8449db120d28	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	7.182.1.10	2026-03-16 10:40:16.175258+00
0236029c-6cc7-49ac-9ca0-30734a0fbb3c	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	66.218.1.10	2026-03-28 20:01:08.874736+00
e2ff44d2-f239-43ab-912f-a77dded4e4af	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	250.74.1.10	2026-03-26 04:58:09.06682+00
6fc5d1f4-72ee-4b55-9056-c566bd3ab975	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	237.131.1.10	2026-04-01 06:32:18.316833+00
9ba2d6b5-765b-475e-b603-733601619bab	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	205.82.1.10	2026-03-27 21:08:32.16193+00
c34180a5-5095-4e64-85e9-3b93a7aff11d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	190.81.1.10	2026-04-10 00:51:56.9986+00
4aa74d00-b493-47fd-832c-2e354f8c0597	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	74.6.1.10	2026-03-18 01:05:39.529425+00
c76de2bb-71da-426c-82a7-0835a6e91cd2	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	166.20.1.10	2026-04-03 10:22:31.815622+00
10d9fdf5-c054-4a7c-99f9-a3823ce67e6b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	26.211.1.10	2026-04-03 15:47:08.268221+00
8f3e60d7-ee0d-4fb1-9c49-592024f38d05	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	75.172.1.10	2026-04-03 10:07:26.795334+00
496223ad-ea1a-47d8-8768-5289bc4fa323	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	71.117.1.10	2026-04-10 03:15:21.49261+00
def679d0-ffc6-4b99-92bb-5b35526fdff0	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	220.23.1.10	2026-04-04 18:57:21.015819+00
6a2b9e11-77f7-4ec0-8a66-cf41d2dd9fc3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	50.175.1.10	2026-03-30 08:13:23.265042+00
88c898d5-67e4-4e80-bb6a-a5b5e6333ab6	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	88.127.1.10	2026-03-30 03:05:18.424967+00
eccafe35-fcf8-44a2-a00e-eaec018e9f0a	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	218.162.1.10	2026-04-01 04:40:20.377437+00
280fb51f-e995-47fc-8c1d-352b02b38f84	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	208.1.1.10	2026-04-06 00:04:34.376895+00
03600a00-e92f-4953-80d7-82839d7e2f43	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	149.153.1.10	2026-03-15 19:39:08.339878+00
283ebbb6-1d4f-4a6a-a576-e1fb9985de28	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	246.62.1.10	2026-03-27 17:03:55.405077+00
3a1bd3fc-ed10-4000-8970-5da9c7e7b08a	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 22}	161.84.1.10	2026-04-10 13:24:25.260704+00
581da8a6-4585-4d2e-a449-2d73fe57a25e	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	222.132.1.10	2026-04-03 11:25:56.562611+00
a3a42830-1d86-40bc-8756-ab828436900f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	253.97.1.10	2026-04-06 17:13:58.36503+00
a8f8c926-2596-4c9e-85ae-32bf82a04f9c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	209.50.1.10	2026-04-02 09:47:13.454146+00
b6cc0b45-6917-4c7b-b479-90408ffedcea	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	99.237.1.10	2026-03-29 19:11:07.896693+00
500fa305-9ddf-43d4-a178-34c65eaedb02	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	188.236.1.10	2026-04-09 19:36:47.111823+00
0b17e08a-2ab3-4fdf-a57e-1cc6daf280de	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	156.52.1.10	2026-03-31 22:49:41.956747+00
71f906a0-7e3e-4565-bbc4-c26b2eff1254	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	205.56.1.10	2026-03-21 07:23:59.551967+00
88460165-bc1b-4a9d-a1a3-b5e06e352649	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	45.89.1.10	2026-04-06 22:03:27.323845+00
96706949-aaef-4daf-a765-639d02d0b9eb	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	56.39.1.10	2026-04-11 16:22:19.936702+00
ca0e8473-a9fc-40c0-a4fd-1174b0f6fa90	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	247.46.1.10	2026-03-25 05:38:59.513503+00
775e377c-f27c-4774-9791-1c05a67bdd3f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	184.227.1.10	2026-03-20 21:22:12.780521+00
5678f2f8-f042-4788-a83c-d69d59a1c97b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	186.244.1.10	2026-03-28 02:12:17.859485+00
5642e80a-f7d7-4533-846a-6a9f33250e70	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	157.165.1.10	2026-03-19 00:45:52.051066+00
cdc76d27-0dc3-4984-b01c-970fee109079	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	95.105.1.10	2026-03-22 05:29:25.414594+00
a98b313b-7acd-4185-ac46-a4ae5fb442da	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	172.197.1.10	2026-03-17 19:22:57.534132+00
5294fedd-9e39-49c9-8440-b9db701ab36e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 44}	131.24.1.10	2026-04-12 06:11:11.844528+00
cbad81d3-cebf-4cbf-beae-c71ba0cf8ce2	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	82.51.1.10	2026-03-28 10:20:30.852444+00
c2d20e5a-8fe3-4424-9217-22cd765d8871	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	79.175.1.10	2026-04-12 14:20:09.036923+00
ae6cf4b2-a5f0-4602-956c-7514665ec708	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	129.69.1.10	2026-04-09 15:07:39.40661+00
4bc5096e-b72a-4796-8cc7-19827f24df90	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	170.112.1.10	2026-04-10 02:59:18.716913+00
a0dfede0-1316-4f70-9c53-c98d75015b4a	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	84.70.1.10	2026-03-27 06:32:03.195773+00
dcc70cb6-549c-4dce-a244-c2f8fff08407	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	94.241.1.10	2026-03-28 00:41:55.894271+00
ac7ccb1c-a456-4f7c-a174-bb18c03c878a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	14.81.1.10	2026-03-27 10:32:03.924696+00
4072b7c8-9d3f-454b-98cc-06ded2d71a57	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	54.13.1.10	2026-03-19 13:46:51.9656+00
8f226f23-6b7f-461b-a3e7-256de387042a	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 18}	29.44.1.10	2026-04-14 12:47:59.804505+00
ddac766a-ff4c-464b-8e80-a600231adb1f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	188.9.1.10	2026-03-19 11:41:38.852747+00
45d5a20b-7cbe-472f-b91b-86c4fe7c23ab	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	43.5.1.10	2026-04-04 23:32:33.55667+00
39864d3e-1466-4e1d-94c4-e58ce89dd1b1	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	144.50.1.10	2026-03-26 11:42:55.798521+00
55bc09de-16e3-4083-91ac-aa8c8e3c2d9a	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	75.169.1.10	2026-04-08 19:44:56.298291+00
e09d72f4-1ac4-4a76-89d6-eeff73467ad7	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	205.240.1.10	2026-03-19 04:08:28.026774+00
1cc10d34-6fe5-47c5-9192-ef5a4482b576	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	144.204.1.10	2026-04-10 01:50:14.691943+00
24185359-761b-4d38-81ac-3640a29148c4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	170.191.1.10	2026-04-08 17:27:19.07777+00
4768d1bb-d9a5-43a5-9215-6b1cebdec2ab	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	2.8.1.10	2026-03-26 23:06:06.472397+00
0f024b42-41aa-4e0f-bb80-5f5d8bfb28e3	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	34.220.1.10	2026-03-24 11:53:26.126406+00
32507d46-dc17-45d3-8c70-39e0559fe46f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	204.30.1.10	2026-03-27 11:46:43.002912+00
5e611cb6-2c8b-4987-82c0-1936c286eecc	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	224.95.1.10	2026-04-09 13:53:58.17479+00
9da23660-b863-4acd-9e84-72b2aa619c1a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	89.188.1.10	2026-03-19 23:36:52.783647+00
6335faea-5ff2-4c4d-8469-5c96c937f009	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	228.83.1.10	2026-03-28 01:15:34.073133+00
484989cc-e98f-47df-b64c-bae200383d12	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	59.91.1.10	2026-04-11 23:18:01.110522+00
be59f708-e315-4bf5-b801-da7edfd3baf0	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	134.96.1.10	2026-04-06 04:12:37.927748+00
6e6e0739-e3b9-4c96-9c81-e45bdc754a6c	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	175.210.1.10	2026-03-23 13:29:36.195161+00
82776618-d8dd-4620-bc9a-23b414deeacc	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	109.108.1.10	2026-04-11 12:19:15.548351+00
b4fd2d52-37ea-4b11-80d7-76940700ee94	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	198.42.1.10	2026-03-22 21:56:00.144847+00
b88f83a0-d4c4-4199-aeef-241ce959da73	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	60.196.1.10	2026-04-01 10:57:07.577905+00
1de69582-34e1-4be8-af70-0a038624ba0c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	145.123.1.10	2026-03-26 23:43:42.849546+00
adf8949e-2e88-4361-a28f-a1f2c679ac8f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	0.231.1.10	2026-04-03 10:44:27.684976+00
bc0b4f45-d3ee-4641-8383-9811cd5e0e69	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	60.160.1.10	2026-03-29 16:01:40.103971+00
8b6d834e-f329-4787-ac61-0ea8cd849162	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	166.222.1.10	2026-04-12 15:55:54.000216+00
3a6b202c-8e5a-4baa-b124-5fb43750145e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	17.235.1.10	2026-04-07 17:52:04.15852+00
781fa84b-eb8e-45e1-8196-65d289961905	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	240.233.1.10	2026-04-02 23:09:24.111631+00
d8fd223c-27f7-4c5e-9c07-67fc49dbddf3	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	220.20.1.10	2026-04-01 07:27:29.721531+00
debbd3cf-63b5-4fec-9e2e-5f9d894d8663	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	171.74.1.10	2026-04-14 00:40:55.785477+00
3cb7fbba-7b6c-4456-b4d1-892591569bfc	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	81.57.1.10	2026-04-12 01:31:49.006543+00
7ca73052-a5f0-4c2e-9a2a-93526731bf07	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	117.114.1.10	2026-03-30 05:14:34.306029+00
a82b9a8a-bafe-4f5a-96ef-dffdaa06cac7	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	118.39.1.10	2026-03-30 18:47:14.589239+00
14fd69d8-5c49-44d3-99ce-612c5004da68	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	186.96.1.10	2026-03-20 13:26:22.01275+00
f328f45f-5348-4836-9afd-458cf1a63c46	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	244.244.1.10	2026-03-31 11:43:03.092177+00
8f9b9fc5-42f7-400a-8a1d-cb8dfc2f202e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	122.213.1.10	2026-03-23 11:01:32.237052+00
dfff9fe6-b5d7-4a72-b54f-6a90d4ed59e7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	133.172.1.10	2026-04-01 07:49:28.833614+00
32c6e5b0-ae1e-4cce-9de6-509dd1832620	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	238.71.1.10	2026-04-02 04:37:01.219121+00
06fe00a0-bbe8-4240-81b6-b623221046fa	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	59.152.1.10	2026-04-02 02:38:38.147319+00
327c94f2-0754-477a-82b7-4be4cf41810e	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	63.82.1.10	2026-03-17 17:51:56.569183+00
bc79c944-7287-401d-8fcf-62946a65006a	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	60.20.1.10	2026-03-22 00:38:36.808202+00
a5654829-fbed-4679-9660-3da23e075229	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	155.18.1.10	2026-03-18 04:31:49.562877+00
149aff51-a7c7-417e-9025-9cd7a4bde936	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	199.121.1.10	2026-03-30 11:16:07.714863+00
bf60e322-838b-4bac-98ac-30b725e7ae55	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	189.151.1.10	2026-04-01 17:41:06.350279+00
da6719e2-551e-44ac-9dac-3355998cbbf1	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	93.160.1.10	2026-03-21 06:59:45.774743+00
0cfa589e-269a-4e39-8348-30cd119e3716	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	87.20.1.10	2026-04-10 19:10:01.143498+00
4474f904-e68d-44d8-b8e8-139d764f31b6	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	50.212.1.10	2026-03-28 20:34:42.996248+00
53727bb1-6281-4af0-a309-1ece2cd4ff26	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	142.43.1.10	2026-04-01 17:20:59.12013+00
c15fa3bf-8191-4f1e-8714-ee4762665eeb	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	238.233.1.10	2026-03-18 04:14:52.754371+00
9c84ff0e-c806-4a86-b7c0-d73802c8e87e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	24.82.1.10	2026-04-07 20:08:17.073562+00
af83ed85-981f-4f10-93df-298d5d804e2d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	228.100.1.10	2026-04-13 09:56:34.598883+00
0ec3e73f-dc0c-4298-8001-a86fa7d81fd7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	157.104.1.10	2026-03-19 13:17:22.05949+00
84c58d7c-ab40-49b7-8bdb-86f74a18901c	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	73.77.1.10	2026-03-30 10:33:48.748523+00
eca39f9d-ea9b-48aa-ae3f-ed0d1e99734e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	213.158.1.10	2026-03-21 00:01:44.599141+00
41f7cb19-94cd-48a7-857a-50a55cb568cb	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	79.248.1.10	2026-04-14 10:30:21.896407+00
40ce8112-b350-4ce4-ac47-5450a5e0a5ef	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	9.231.1.10	2026-03-30 22:29:14.08144+00
87d43145-15fa-44b8-b607-8dd3accc9800	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	13.89.1.10	2026-03-20 21:21:10.639499+00
6074eb5d-4e77-41d0-bfec-80be0288794c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	45.194.1.10	2026-03-24 04:49:56.696873+00
68e7fd8f-0082-42de-9f67-c70d97a1bab3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	253.80.1.10	2026-03-21 19:24:37.513223+00
50a64652-aa77-4e95-a6cd-81705d860daa	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 53}	224.247.1.10	2026-03-18 23:52:52.772048+00
85a611a2-f29b-43a7-a80d-aaabafc2eea3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	59.240.1.10	2026-03-26 21:47:19.359039+00
c68bce01-c64a-4012-bd64-00bed8a5db8d	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	228.68.1.10	2026-04-03 04:20:21.873621+00
b2fa537e-c7f2-4768-aab4-14891cb597af	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	167.63.1.10	2026-04-11 08:56:48.088845+00
a9d49070-3fd0-41d6-ac07-a7a43ee544fa	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	82.132.1.10	2026-03-28 08:45:42.344898+00
da7e9189-2cfb-40c8-9745-e763bab40309	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	87.226.1.10	2026-03-26 08:05:31.704862+00
b9ce0498-15a9-4bee-9c14-597aef2e2fa9	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	172.157.1.10	2026-03-16 06:38:17.614863+00
53fdcf8d-deb6-4859-8652-14823f1e81b3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	53.80.1.10	2026-03-31 22:28:40.059635+00
d0272b1d-115d-4567-ab3c-b5c7c02ee480	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	243.222.1.10	2026-03-28 17:02:10.047601+00
4092a4a2-b72d-495f-870d-804e0012b14c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 56}	101.215.1.10	2026-04-12 06:27:48.482329+00
392c4558-ac34-40e2-899c-e0e63efc3eeb	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	118.171.1.10	2026-03-21 18:44:23.276588+00
b863fb1f-9bed-4295-9e0d-2bf0e351c4d1	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	241.146.1.10	2026-04-06 01:07:55.727051+00
00dc0ba9-5249-4b67-8687-4cfaa4df8cd8	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	30.243.1.10	2026-04-13 08:22:16.319164+00
42195f6a-685f-4c48-998b-5e92f414b14b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	227.97.1.10	2026-04-12 14:54:06.40766+00
6257c75a-7d68-4319-9c23-ce476e00ae3b	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	102.100.1.10	2026-04-13 15:33:35.531965+00
bba9b3b0-0878-4146-9e3f-f1f693cf90df	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	127.247.1.10	2026-03-24 06:57:17.089737+00
26bf4641-4771-4538-b59d-411f1dcc85dc	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	48.121.1.10	2026-03-16 04:48:05.658709+00
22c815ca-c13a-4c17-b599-3d87b0f24309	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	38.131.1.10	2026-03-23 16:13:01.713096+00
17c600fc-0419-42b0-b830-9d815fc3b3ea	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	90.164.1.10	2026-04-05 23:17:19.76231+00
9323a6ac-b37a-4657-ac02-f87649331764	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	177.94.1.10	2026-04-12 02:53:10.923351+00
199352e1-0c46-42dc-a440-093ac4ad420f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	69.198.1.10	2026-03-25 06:10:39.939887+00
791b8f74-86df-401b-9cbf-f542a60dc77d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	235.29.1.10	2026-04-06 18:36:55.386258+00
018a046f-d27f-4eb6-a567-a3f3d1e64434	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	117.152.1.10	2026-03-16 22:35:23.513576+00
0813e398-9cdb-4578-afab-f6edd46801b3	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	91.114.1.10	2026-03-27 06:11:10.766457+00
072d4cb6-bf7d-4054-917e-074dcdd1866b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 44}	70.217.1.10	2026-04-12 20:11:03.28712+00
8b51f52f-7032-4c11-b5c5-0a5353ee76c2	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	182.200.1.10	2026-03-30 18:36:03.615881+00
52c20d75-d1b9-45f2-8684-69ef1fb96ed8	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	189.161.1.10	2026-04-12 01:05:46.066453+00
4a2fc7f9-c22c-4285-84be-6ad21dff0605	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	198.136.1.10	2026-03-15 16:35:30.700253+00
1f91166b-5d39-4319-a51e-c7f2797f6745	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 32}	195.126.1.10	2026-03-29 22:48:11.130493+00
97672ca0-d816-46f2-aff0-fc6f0a241aac	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	70.16.1.10	2026-03-17 15:10:23.596514+00
35022a3d-8a33-4304-bbaf-c779048e09ae	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	116.231.1.10	2026-04-13 04:51:54.959683+00
d365fd48-420d-4664-a7c8-8348c3d3a388	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	203.252.1.10	2026-03-19 13:04:07.780828+00
71b81976-ff63-4bb5-b231-96e3160881ae	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	166.92.1.10	2026-03-29 16:16:37.591801+00
ad376b42-0220-43f3-9b1c-0abd8a5c16c4	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	161.253.1.10	2026-03-28 04:12:38.273275+00
5c2b056f-4834-42b4-9257-59a69d889d5f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	241.164.1.10	2026-03-26 23:42:49.283661+00
189e67f9-ceb9-4e3a-a559-f045f92c6ac2	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	5.226.1.10	2026-04-06 02:14:07.044696+00
d9d39f51-11a9-4a84-b1dc-4936b7599930	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	5.186.1.10	2026-03-31 10:42:53.795351+00
6523ffd6-30f3-4561-8296-4b18395b7765	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	211.78.1.10	2026-04-07 03:18:23.406456+00
270c2041-0968-4454-8b16-9f18a291cc7b	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	202.153.1.10	2026-04-06 11:57:10.859429+00
fefbcea6-0450-47f5-8458-3583eeb96efb	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	25.69.1.10	2026-04-06 23:54:00.813869+00
cd6cddab-ef4d-449a-884b-883cef2ad872	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	178.78.1.10	2026-04-05 13:40:02.375468+00
a14aa3e6-6509-4175-a507-31d8842acb50	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	9.48.1.10	2026-03-21 06:31:55.534946+00
46f8c95d-88c9-4e65-827e-d86257170a73	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	228.171.1.10	2026-04-10 18:14:44.495845+00
1fbd1ed6-f0b3-40dc-b78f-c7524b8cebf8	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	32.78.1.10	2026-04-03 19:26:48.457258+00
345640d8-a0db-48ff-a209-005280321cc4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	178.55.1.10	2026-03-27 07:36:45.32571+00
e7573b10-8399-4735-8289-5b3a8e2d9505	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 44}	152.42.1.10	2026-03-28 13:37:57.569859+00
08f3f41b-9a60-4e84-95fd-e9ee3a6f382b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	105.57.1.10	2026-03-16 06:14:07.547061+00
66937365-9e76-4c13-99c1-702b5ba5bc7c	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	48.68.1.10	2026-04-09 23:11:17.505005+00
1580c808-c143-4dea-bb0a-d24baf3d4b01	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	122.82.1.10	2026-04-08 17:59:50.083491+00
b77aee5a-f95d-4cce-8b20-41da78059100	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	31.7.1.10	2026-03-24 11:45:49.706041+00
b2116a20-a955-45e9-b733-4366400333c4	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	85.90.1.10	2026-04-03 09:25:27.627385+00
4ba4708e-6de7-4e5f-b67e-5bbed8204a75	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	216.131.1.10	2026-03-26 06:19:31.289837+00
906b7a1c-77fd-4c41-892a-fddd1c60fb7d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	128.31.1.10	2026-04-10 07:17:39.624943+00
948f33fb-1201-458d-97b7-3180f9a4742b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	215.147.1.10	2026-04-06 12:11:08.584194+00
0bf519ee-2bbf-430c-b189-9c6c4729be75	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	79.52.1.10	2026-04-14 14:07:25.374858+00
90a9fe2b-a1a2-49dc-a914-cf51c16e52f4	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	188.137.1.10	2026-03-31 09:30:08.972332+00
f3185490-c52a-4e5e-9383-125c7965f152	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	179.131.1.10	2026-03-23 13:07:26.100152+00
ceef9618-86e6-41da-a71b-a9e5ac11c6d7	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	153.20.1.10	2026-03-24 17:20:56.893963+00
5a3bbcf6-7592-47d9-befd-7fefb58bc60d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	227.179.1.10	2026-03-20 00:25:58.275473+00
54c81cc5-8a8d-4a56-82a2-efe5b25940a5	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	6.124.1.10	2026-03-21 19:47:12.718485+00
2d6f2a00-302a-41ce-930a-341ea6b6eff1	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	20.227.1.10	2026-03-25 05:40:50.418007+00
259b868a-a420-42b2-9481-09b2782cfc17	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	195.242.1.10	2026-03-28 05:28:14.695511+00
233d5693-3d96-4963-b76a-5b43de0c092e	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	107.228.1.10	2026-04-06 04:50:57.166382+00
45506a65-b0f1-491d-93fe-9e77246fa5ae	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	162.33.1.10	2026-04-12 14:01:05.582463+00
53e2938c-5a0b-4257-931a-5ece707ef289	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	170.190.1.10	2026-03-26 04:24:23.149903+00
e9bb9449-ec6c-4046-9065-76e643357597	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	208.100.1.10	2026-03-18 05:36:39.518916+00
d99ab5f1-244b-48f9-aa2d-df497b944b52	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	218.189.1.10	2026-03-26 00:28:55.258704+00
4a8c857e-2034-4a67-8b54-80fc0437362b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	227.62.1.10	2026-03-15 19:42:56.234185+00
ea774fe1-cf49-4617-8cfc-cdd9165400d0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	87.11.1.10	2026-04-11 09:40:20.16673+00
848f0539-c9bf-498f-8f8b-0ec74834946e	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	51.228.1.10	2026-03-17 06:20:30.228263+00
fe13d318-9b69-4f80-92c1-163f3755a713	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	173.168.1.10	2026-03-21 20:01:40.191971+00
5220f598-ba16-4b15-a4cc-f37be226cda4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	55.55.1.10	2026-04-04 16:07:48.68062+00
38165aa1-12d4-4a83-a327-25599a1b77f2	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 22}	50.100.1.10	2026-03-28 00:22:38.166382+00
2cc9d498-46ae-404c-aa2d-1e151fe3a9cd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	247.191.1.10	2026-04-10 12:15:24.122319+00
850c1053-09b1-459e-9d64-ea83c99c3989	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	231.7.1.10	2026-03-24 13:59:49.264693+00
470783d3-349e-4285-8cdc-e67a34a71643	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 30}	128.159.1.10	2026-03-18 23:07:43.121124+00
c2ff3891-cad3-4332-bcd6-2d0c09b184b3	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	75.235.1.10	2026-03-17 07:24:18.110646+00
642944b9-e01f-4737-82d1-0c1442b17d2a	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	170.73.1.10	2026-03-20 04:48:36.399369+00
7b51509d-74c7-483b-be39-c13faa048a0f	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	104.75.1.10	2026-04-14 01:09:08.879127+00
858e171b-0f80-4eb8-975d-dfe0b78f335d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	145.58.1.10	2026-03-23 20:58:11.451304+00
5958f133-b31a-479e-838e-7581736be4dc	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	139.5.1.10	2026-03-18 14:05:53.394134+00
d6319f66-b8f0-4652-8a28-cb6a62cccae1	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	40.225.1.10	2026-03-18 06:08:28.664459+00
dab879b7-fbf2-405d-9482-9c46090cce6f	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	163.130.1.10	2026-03-19 04:00:14.676855+00
2cc8db11-2711-4b60-ae4c-6b5a12d254e9	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	252.111.1.10	2026-04-01 06:06:01.699984+00
e8775450-3e4a-4ddc-a2ac-e8851591c60c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	39.101.1.10	2026-03-28 18:50:10.739405+00
93571875-12a0-46ac-be8b-fc55fad77519	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	224.14.1.10	2026-03-29 06:23:36.598432+00
189b5a10-3adb-4c20-b275-b68f47afe453	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 45}	9.120.1.10	2026-03-27 09:29:27.680302+00
8cb01419-4f19-4109-a5f7-9e3aa7b34885	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 97}	37.193.1.10	2026-04-09 01:55:18.527103+00
354298c9-26a5-474e-adea-a06f4c3faa45	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	76.242.1.10	2026-03-23 05:43:33.723731+00
39a40554-dfa5-420c-a7db-43561535fdb6	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	220.232.1.10	2026-04-02 19:20:05.599187+00
deb4b3d4-ea72-4e05-9d90-c32ff371f579	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	74.206.1.10	2026-03-22 23:13:35.713598+00
2ed4e621-9f20-48b1-913e-886c5062b9cf	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	103.227.1.10	2026-03-19 20:44:54.620581+00
c8bb4613-048b-4f2e-b40b-4e4c025d2fd3	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 40}	242.224.1.10	2026-04-13 14:33:28.614233+00
c19c79dd-832d-46e7-a199-1fedda05ce3e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	158.108.1.10	2026-03-26 21:05:56.462199+00
4e4c8a27-6fc0-4bd5-aa85-b46423242b44	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	56.62.1.10	2026-04-02 04:30:07.7663+00
26dbfda1-e27d-448a-8458-19e8fab22a46	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	234.205.1.10	2026-03-31 23:21:02.822854+00
011a4bf0-300a-4eb0-af4d-8193b2a82731	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	161.15.1.10	2026-04-05 12:44:43.919275+00
3a4f6bda-ccea-4aba-a8a3-0b29d0f27ac4	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	215.4.1.10	2026-03-23 05:32:11.170438+00
a7295bc3-3df2-404e-94ce-078e37a10b45	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	194.90.1.10	2026-04-13 14:47:55.652112+00
a3d0b9ac-2b0d-48de-bc27-8017aa2d4de1	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	132.56.1.10	2026-03-28 13:05:50.297487+00
03f87b5b-bc76-476d-bc34-deb5ebc488ef	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	93.75.1.10	2026-03-27 09:41:04.262125+00
0f11dd70-b5a7-46d3-aa69-9d0d3eb5e5e8	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	171.196.1.10	2026-03-27 03:34:50.853984+00
560f1a4f-1032-491b-a860-c91ec4e1101b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	230.73.1.10	2026-03-19 05:07:28.548332+00
81616bb6-056b-45cb-bd38-56aa9efffca7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	158.250.1.10	2026-04-07 02:02:46.683986+00
5de2cf6c-3c65-4f68-83e7-abf45fd643b8	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	169.229.1.10	2026-03-16 15:37:35.602336+00
aa3497cb-c44a-4c0f-a9bd-cb3f71b7b7db	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	165.236.1.10	2026-04-09 14:49:21.232171+00
f0063a47-73b6-46b9-b7a1-2c54a75e52ff	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	134.197.1.10	2026-03-27 08:48:14.072224+00
e1a795cc-3192-4b93-9c60-2756786e34b3	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	60.114.1.10	2026-04-13 21:14:37.829252+00
04694d15-c310-4023-a854-69ad8974610f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	200.40.1.10	2026-04-14 01:21:39.701618+00
d9793388-6843-418d-b792-a28d8cd22b66	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	237.57.1.10	2026-03-26 11:51:50.436522+00
9b51b8f3-0cbe-4b23-9286-65bd89004337	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	44.194.1.10	2026-03-18 07:33:39.62633+00
89817d49-83e6-4478-8141-e47690b6c275	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	211.253.1.10	2026-03-27 01:09:42.543118+00
8616444f-260a-4da8-b347-307676ccc26d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	70.236.1.10	2026-04-04 19:35:22.732277+00
e83b3e38-7d8e-40a1-906a-2c472e502e3e	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	6.99.1.10	2026-03-22 15:32:02.181409+00
0cab3a8f-f946-4f21-9fea-44a937326124	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	60.64.1.10	2026-03-29 17:41:01.294148+00
b7dcdb62-f8ac-4f64-9f85-49aeac731ccc	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	209.181.1.10	2026-03-28 10:33:01.917463+00
1b888653-6c1e-47bb-b2b4-9be40a7b3cfb	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	84.245.1.10	2026-04-10 12:09:14.458153+00
392dbbbb-857b-42ad-b6e4-b565550beef2	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	145.203.1.10	2026-03-20 04:30:42.374944+00
b3dc07bd-d374-4495-9b20-bcc46c03a545	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 18}	126.155.1.10	2026-04-02 11:45:36.520263+00
3558eaa4-35ea-4d4a-94e4-df7153b4168a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	119.173.1.10	2026-03-27 11:01:09.999231+00
5124f3c2-6749-44ab-b80c-3555cc639941	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	13.149.1.10	2026-04-14 08:24:16.273223+00
aed8e820-4c60-4b6a-a7c5-94e78d9fc968	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	74.79.1.10	2026-04-07 23:17:23.675417+00
98cae7bd-2bbf-44fe-8035-753a84b9fd8c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	208.45.1.10	2026-03-24 15:16:37.312023+00
da57cde1-9fb8-40f7-852e-370c46e05269	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	144.98.1.10	2026-03-20 13:28:28.43059+00
f9572850-df59-4abb-ac84-af7e0005626c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	122.14.1.10	2026-03-16 17:20:03.229471+00
6db8ac58-395e-4025-9a89-d30be3534a93	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 16}	210.73.1.10	2026-03-28 20:45:56.618773+00
decec21c-294b-4da7-9c75-c6dd0b9bc923	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	114.86.1.10	2026-04-10 05:57:23.460076+00
4b374d40-b330-4f12-bb3b-37850a6b99eb	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	16.135.1.10	2026-04-03 14:58:24.353403+00
8c1ec6c3-dd66-4ed0-b4b2-df71b63fca25	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	127.68.1.10	2026-03-23 20:25:22.15305+00
ad373177-202b-4ca0-8836-6bb3a21d49e0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	142.235.1.10	2026-04-03 08:05:12.860343+00
c968aaa0-6c5c-42eb-9198-2619f5d14c6a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	77.133.1.10	2026-03-26 21:53:36.19237+00
00391951-e38b-426f-af27-abb5c971d9c9	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 22}	218.176.1.10	2026-03-18 01:50:19.087696+00
b6c96a25-b281-40ab-b828-aad6ffa5a983	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 27}	92.209.1.10	2026-04-07 06:11:14.947644+00
756edddb-2590-4bd3-a6c1-08415dd44293	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	208.217.1.10	2026-04-07 06:53:58.730186+00
6c39b0f3-dabf-4fe5-b541-69ae21df9811	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	220.129.1.10	2026-03-18 19:23:30.430478+00
c0b610c8-0b40-430b-880d-9d816e251811	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	101.97.1.10	2026-03-31 07:09:35.206826+00
d812bc8a-d093-4154-9169-1da8295be499	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	201.199.1.10	2026-03-16 22:36:43.246099+00
7c41cc4b-e4e1-44ce-a6bc-126843b40477	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	157.92.1.10	2026-04-14 07:33:31.696898+00
1cdb7000-be25-4e75-882c-77a82e7032d8	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	34.128.1.10	2026-04-13 04:15:44.355415+00
8c59637b-f463-470a-8f38-a671621aa7f2	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	64.243.1.10	2026-04-11 19:25:19.071854+00
1296fa2b-b5bf-4e6f-b1be-f589745a225a	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	119.45.1.10	2026-03-20 23:51:50.946294+00
e25ee820-a61c-4a7a-ab45-80d3240e6fcd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	244.252.1.10	2026-04-12 07:11:35.869125+00
96a07e94-165d-4bf5-b45e-cd5bdd2c9839	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	92.237.1.10	2026-04-04 13:49:31.239595+00
ecb305bc-c9aa-40a4-b398-08b1879fa652	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	138.198.1.10	2026-03-19 03:57:21.613516+00
027fbde1-5f74-4cc0-8750-0b4b7b590a64	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	25.25.1.10	2026-04-12 18:23:23.244961+00
e8fbe428-e293-4a75-80b4-60d76904bcf4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	38.208.1.10	2026-03-15 23:04:05.55424+00
04f0d1a9-a128-441e-9b8b-6b3c4ce51ae5	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	213.254.1.10	2026-03-23 18:19:47.265127+00
1fa3fe15-21a6-4f84-acdc-154be9f6afbc	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	124.222.1.10	2026-04-09 08:11:53.408851+00
cf871090-f2e4-4807-8e04-ef1e6d3d4d59	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	172.177.1.10	2026-03-29 16:31:21.772931+00
15cce8e6-19a7-433d-8ae5-a9d2769dd418	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	82.64.1.10	2026-04-06 21:59:30.801954+00
3b302fd1-740b-43c6-a637-4ae98cf26473	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	99.131.1.10	2026-04-14 05:04:40.211154+00
771ea9c2-208f-4d51-bedc-d8c28dcd1d4e	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 68}	126.59.1.10	2026-04-05 20:10:49.34966+00
cf84e6cd-c93e-4dc2-94f1-505be7f6328b	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	251.107.1.10	2026-03-28 15:37:05.600363+00
dbecfc35-ef44-4a24-a43e-f93a58e2c3d5	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	249.182.1.10	2026-03-27 11:55:41.786744+00
b2fc71b0-6ee6-4154-9405-4799ca83073a	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	166.21.1.10	2026-04-08 15:56:37.63827+00
65956d73-4448-4c97-8ad9-8989293a92e7	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	153.76.1.10	2026-04-02 04:43:34.437733+00
bda51414-af30-4293-8a7a-3e83a002317a	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 23}	226.66.1.10	2026-03-20 01:26:37.434916+00
c748c0c1-f97c-4f47-8dae-794fc63a40e2	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	119.60.1.10	2026-04-08 23:35:01.291914+00
162f5a9d-d782-4866-8233-014aab206724	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	5.43.1.10	2026-04-07 05:06:26.30095+00
d20f5c1c-ccf5-4af0-acd3-3064dee09fe9	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 32}	7.240.1.10	2026-03-24 03:34:14.265513+00
7e6c1e7e-0fa1-4528-988a-3043849eebab	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	62.82.1.10	2026-04-12 11:38:46.810035+00
5264041b-4a79-4eff-b53c-443e224aeb9b	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	172.17.1.10	2026-04-09 17:20:23.105795+00
e589cbce-fc97-46f8-90d4-aa1f39449767	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	235.162.1.10	2026-03-20 02:08:20.186858+00
fde4cdd1-4d4d-4785-80b7-724b6cfb5c32	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	148.240.1.10	2026-03-19 05:02:46.505536+00
6d6951bf-0f2a-42cd-8b7e-aebd5b80c388	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	0.40.1.10	2026-03-21 13:21:10.819685+00
d8c699e6-a786-46f3-abb4-ac79f1a3c225	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	31.178.1.10	2026-04-04 12:58:07.867951+00
405dd644-9b3a-4aa7-946a-0b9743707711	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 25}	177.133.1.10	2026-03-26 11:35:53.822083+00
f50fbe47-dbbc-4e5c-8860-45c1703a4970	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	36.217.1.10	2026-04-09 03:37:31.643317+00
094291d2-b34e-4a47-b0ce-7b3a1f655b12	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	70.69.1.10	2026-04-11 09:05:42.680206+00
bd6c486f-85a2-41d0-9ed3-444778acd644	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	228.196.1.10	2026-03-15 20:35:17.80312+00
34d23b40-e4e6-421e-83ba-aef021121108	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	173.213.1.10	2026-04-02 04:09:34.58349+00
6c9f6d4a-1476-4cf5-90ed-450a93ae755f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	210.7.1.10	2026-03-26 17:35:43.732801+00
8edb1f5a-aefa-43a9-87c7-a9920dafdc25	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	165.105.1.10	2026-03-23 08:02:03.018356+00
b78d9ce3-c0ad-4b0d-aedc-3314309b6fdc	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	154.18.1.10	2026-03-28 10:01:15.742995+00
9af0ef58-f27c-422a-86dd-9b34c2e480df	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	22.5.1.10	2026-04-11 11:53:21.491358+00
bc90fa61-9973-4a44-9edc-b1daa7de9f85	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	136.136.1.10	2026-04-02 21:04:30.484246+00
9030d7e2-34b1-4d74-ac67-949b6dec86bb	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	82.75.1.10	2026-04-03 12:06:46.876717+00
c34a365f-cbd1-458a-911f-8d02ec9deaf0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	130.157.1.10	2026-03-16 15:59:50.506232+00
dd941495-5e7f-4209-8dc8-dc7b80d15de2	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	222.110.1.10	2026-03-24 07:29:51.829907+00
1983ea24-8b07-42f5-b531-be7e5e89bca0	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	19.46.1.10	2026-04-01 22:48:02.799987+00
9a6e9b17-f61f-4b23-9e67-2e8c79e0fe8e	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	73.2.1.10	2026-04-11 17:38:29.560988+00
0aef735b-9d91-44fe-8fcd-a8e41a28a49e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	57.165.1.10	2026-03-17 23:57:31.329054+00
988430f3-b9cf-45e1-83fb-ded80ec38f1a	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	106.135.1.10	2026-03-30 12:37:30.518996+00
078381cb-6856-4e2c-9ed1-5cc6e040482b	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	219.224.1.10	2026-04-01 03:56:07.61717+00
a26b68a5-871f-47e3-9046-c755ba27b055	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	35.216.1.10	2026-04-14 02:46:35.176768+00
3d7b4031-5878-4d01-95e3-e3e3e01c68e1	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	23.218.1.10	2026-03-30 08:13:36.21027+00
7f8fe63b-32f5-4b10-ba76-a8c4628fa838	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	241.137.1.10	2026-03-28 20:01:46.204472+00
4b956f27-99f8-4b12-a59e-1a61f7917b43	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	172.230.1.10	2026-03-23 21:54:43.091854+00
4de46148-36b8-433f-b82a-6e7f22e04ece	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	209.214.1.10	2026-03-16 00:39:52.319903+00
6c3e5f01-343d-456c-bba4-359d66b0ecda	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	179.206.1.10	2026-04-13 18:54:30.363222+00
46ae6f43-9b03-4d06-9cf9-0ab076cadfa6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	170.149.1.10	2026-04-03 22:30:07.598687+00
a51b4931-433b-41d7-b7bf-66b432c50061	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 68}	107.147.1.10	2026-03-25 14:19:39.571868+00
03f56902-4788-4869-86ad-ecc53395d94a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	201.48.1.10	2026-04-04 03:23:45.301525+00
f824178a-ce69-40ea-a719-61efdef32232	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	85.210.1.10	2026-03-25 15:56:12.999725+00
10ae64e7-7577-4316-96ad-9be22e033069	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	156.238.1.10	2026-03-27 15:23:18.871311+00
a58bb497-0bc6-4849-8d3a-ef069357bea7	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	230.185.1.10	2026-04-07 03:00:24.702989+00
87b28bf3-0980-4a63-aed9-aa013d7712d6	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	167.143.1.10	2026-04-07 05:58:35.762206+00
1d3ff0bd-970c-4cf9-b55f-2abdaaac985d	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	4.209.1.10	2026-03-19 19:16:54.670567+00
d4c41c83-a324-470c-8632-819f736cc21b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	206.55.1.10	2026-03-17 01:05:03.717618+00
055b83fe-01b3-4068-b9f7-5c7d5c9e28e6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	59.229.1.10	2026-03-31 12:43:01.441429+00
85a37e18-fd5f-4384-93b8-83f57293b4e7	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	184.62.1.10	2026-03-26 04:34:42.121844+00
911e25b4-dd31-478e-bbbe-3859039792b2	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	224.169.1.10	2026-03-26 11:43:57.882069+00
53272160-4fe2-49b3-a252-6badf70bad7b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 68}	143.25.1.10	2026-04-12 19:07:40.992895+00
73c91180-b4d7-4494-86d1-c31c6dbd4de4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	73.242.1.10	2026-03-27 22:26:32.799825+00
c741b576-168e-4213-94d5-2b17a1ba8e0c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	56.133.1.10	2026-04-12 15:12:47.795642+00
16d6a2c2-19ff-4198-86fb-3363668c4f24	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	252.171.1.10	2026-03-21 10:38:04.273226+00
dadd215a-3434-468d-80d8-39292f8535a5	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	213.112.1.10	2026-03-20 23:29:10.216398+00
544d5536-2381-424a-b5c8-788b8e98a519	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	140.129.1.10	2026-03-21 00:50:53.829679+00
3c68a9ef-7bc4-46a1-bb53-fd261c160e19	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	142.79.1.10	2026-03-16 03:02:09.020749+00
abafe5bf-8558-4aa5-b58f-5ce6a7a0e1cd	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	201.109.1.10	2026-04-03 20:04:24.815865+00
7abd4cc8-3c62-487b-96b5-1e9a52bb4f4d	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 43}	159.17.1.10	2026-03-17 21:38:27.290811+00
55f1048a-3e20-4671-867c-bbddb5cc6007	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	222.96.1.10	2026-03-31 09:26:30.30797+00
f6174a41-1beb-4b99-95d8-a211b8061a4d	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	31.250.1.10	2026-03-23 04:45:52.988479+00
c14be4b1-ea59-4384-902c-5c083641d337	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	40.209.1.10	2026-03-31 15:14:58.988323+00
96930056-b4f2-4861-9cd2-88d84d017783	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	81.146.1.10	2026-03-17 07:31:09.285196+00
83421cb4-08b1-44e3-8d2d-62fa55d27bc4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	218.117.1.10	2026-03-21 22:32:57.537847+00
e06e04e9-4e47-42ed-be5e-c5f921e106a1	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 53}	226.101.1.10	2026-04-08 23:08:37.079415+00
a619796b-5f6e-468a-be89-c702b325834f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	161.6.1.10	2026-03-17 08:25:06.031067+00
29679b71-e7d7-40aa-a847-adc80affaae0	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	231.50.1.10	2026-03-25 05:36:40.610278+00
c866ad8a-ed8a-4aff-9d3f-a692a8a0d688	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	199.176.1.10	2026-04-03 01:13:13.503416+00
8488c4bb-caea-4f7f-a686-0c8240ac334b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	211.140.1.10	2026-03-30 19:47:42.688162+00
3ad5f462-1fc6-41cb-be49-8f0bdb30a496	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	27.111.1.10	2026-04-12 01:46:01.218401+00
6d8ea75d-f7d9-40b9-a64e-611fb44810d4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	100.171.1.10	2026-04-10 21:23:08.092366+00
0041fa7c-44d9-44e3-bf4a-2bd183fa465b	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 35}	86.7.1.10	2026-03-28 02:42:16.351245+00
b004043e-647a-4074-8226-6b8c4b25734d	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	11.241.1.10	2026-04-03 08:27:32.628714+00
ff012480-b4c9-4d1e-86a8-0316dfb375fc	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 98}	79.107.1.10	2026-03-29 00:01:25.635253+00
7562193e-8271-4328-ac22-02e6b3c35f17	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 89}	239.185.1.10	2026-03-26 16:07:17.614381+00
6555c4ae-d08f-4e71-a413-798fa6bcf18c	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 56}	157.29.1.10	2026-03-29 11:53:11.495473+00
fb2b24ac-3f68-42be-992d-8fcae8a182ab	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	167.207.1.10	2026-03-18 16:38:57.200408+00
d11c8843-d72f-4709-aaf7-9d02c7a97b20	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	7.84.1.10	2026-03-21 19:23:58.243502+00
615b6cdf-0514-465a-b65d-64d82ecb19d3	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 40}	42.239.1.10	2026-04-09 08:10:55.942393+00
1681e2f6-bce9-4be9-a971-8f4b79da1e87	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	132.79.1.10	2026-04-01 12:41:37.459588+00
73d08fed-9163-4af2-8fa4-5a01518923a0	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	111.188.1.10	2026-03-30 01:26:27.842656+00
92996b06-829e-49cd-a927-b81d515db076	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	85.38.1.10	2026-03-20 16:44:35.765417+00
0d5dfcfc-d301-49c5-877e-7b924e6e2082	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	47.69.1.10	2026-03-27 02:34:11.083382+00
941773cc-929f-4eb6-bdcc-e030b553f229	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 36}	155.231.1.10	2026-03-24 14:33:24.364131+00
67d76e16-2175-4f5a-b031-2834ee8140cc	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	171.117.1.10	2026-03-28 07:14:16.241975+00
c802f3d0-1bc6-4ceb-8ab6-d2947f1194eb	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	165.72.1.10	2026-04-12 22:46:20.731158+00
5b1fb7eb-cf65-457f-a2f9-69f6918f6973	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	190.181.1.10	2026-04-14 13:56:50.710084+00
aa951e35-b605-4fad-a2a3-b599b97de6e2	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	70.12.1.10	2026-04-14 07:20:18.097963+00
2cdc7311-7772-4e07-bcc4-8a2a32e35717	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	198.61.1.10	2026-04-04 20:43:31.646348+00
1c5e0067-64ed-4912-94a2-bb1e4c8ba1e4	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 81}	226.65.1.10	2026-03-21 17:09:17.78733+00
39225ad2-778b-4ff9-aa95-7652884ddf7b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	139.248.1.10	2026-03-20 17:52:41.440212+00
1a451381-8fbb-4462-b02c-0883fcbc01db	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	102.214.1.10	2026-03-26 16:12:30.516158+00
57510553-5dfa-43fb-87f0-dbdbd72fbb0d	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	44.206.1.10	2026-03-19 15:13:18.736124+00
8caca897-d593-497d-bd22-8b9d2f6beaf1	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 29}	58.88.1.10	2026-03-28 13:05:04.36958+00
4c037e81-9b09-4acb-b047-41065fa39c92	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	101.66.1.10	2026-04-07 12:56:09.512114+00
287818f8-f5bc-4c3a-b793-76233bcaa89a	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 31}	135.1.1.10	2026-03-28 10:47:17.095033+00
bc664ba3-b50f-46e3-a651-bf552815dd9f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 64}	168.98.1.10	2026-04-08 02:30:04.428438+00
e12d17fe-ea43-4518-b67b-bbc46cb2b128	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	76.2.1.10	2026-04-02 06:05:48.101613+00
df4510d3-2995-4460-a766-45cf09c32bac	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	125.10.1.10	2026-04-06 23:45:40.513662+00
0f54330a-a44a-4223-ab8d-667254fa409b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 96}	50.191.1.10	2026-04-11 11:15:12.764021+00
a693a3f5-2616-4525-b379-1e6fe3a3d780	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	105.204.1.10	2026-03-16 17:28:40.570342+00
13fcd8d1-6bb4-4a0b-b34d-de5331437bbe	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	2.188.1.10	2026-04-12 00:39:06.844299+00
9b67910c-c4ab-44b9-ac0c-a6b626a99c71	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 10}	61.115.1.10	2026-03-29 16:10:03.295205+00
815f1565-98d1-4d0c-9d9d-8a2c59bc498f	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 17}	137.233.1.10	2026-04-12 23:24:06.895638+00
84a2d52e-6e2a-44c4-9e17-587f56060fff	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 54}	72.246.1.10	2026-04-12 20:45:12.465935+00
14d5c608-bbe7-4a65-9fa9-fae155a20105	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	214.114.1.10	2026-04-04 03:12:21.755136+00
b67d50d0-0d7c-451e-9114-d337b2a0d24e	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	208.84.1.10	2026-03-30 00:39:10.212741+00
20ee1b6d-2991-47d4-aa0a-e4e704958777	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	131.62.1.10	2026-04-03 15:03:02.300711+00
1d4d84d3-d957-4100-bb54-ef472d9b9582	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	136.18.1.10	2026-04-05 14:52:59.919036+00
59725538-1b11-4040-9910-39677c4f1a0b	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	137.155.1.10	2026-04-09 21:28:28.917272+00
140a518e-2668-4efe-a0aa-a93288a3964b	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	103.24.1.10	2026-03-31 04:44:20.641557+00
839bef62-1eb4-45c1-85ae-8f3603649e73	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	76.6.1.10	2026-03-16 10:03:42.487072+00
ea30c4db-50be-41ad-8bc1-ca06c60362c1	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	202.57.1.10	2026-03-18 01:33:30.069848+00
260e0536-c1b0-4787-9612-4e543913e390	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	219.205.1.10	2026-03-19 14:47:16.554121+00
7850d352-78ea-489a-a14e-cecbb1d55fbe	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	167.49.1.10	2026-03-24 21:03:34.472737+00
27ed7f4e-a6ee-4ee1-ae3f-7a9604fe33a8	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 49}	202.146.1.10	2026-03-23 08:29:46.898905+00
167f1574-7c50-4a02-93a7-92d7260dd7bb	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	244.234.1.10	2026-03-25 14:02:38.634815+00
40b72418-c649-42ad-882a-c3fc5f0f0d68	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	168.9.1.10	2026-03-22 01:45:48.984734+00
1eab3703-a478-498d-831d-ae9b33906245	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	81.197.1.10	2026-03-28 18:53:48.344243+00
9d01cbb5-a2d6-4e02-9693-756a866873b6	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	175.181.1.10	2026-03-26 17:32:54.56164+00
7e223aa1-a859-4397-b46b-a0701e463e0d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	53.58.1.10	2026-04-10 12:51:32.798201+00
58abcd94-e746-49f2-b51f-73d927cd3725	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	41.141.1.10	2026-03-16 20:33:11.916961+00
3ad05637-727a-4650-b912-9d4697b59e1b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	11.165.1.10	2026-04-08 22:26:23.810575+00
b8a4439a-ff07-4f0a-a7ba-51846d9a9910	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	232.141.1.10	2026-04-06 12:29:12.660856+00
bf227b57-7aa2-42e9-b5b7-d97706a65a0f	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	106.16.1.10	2026-03-27 13:59:00.640948+00
b2948b12-53ef-4865-a343-2970f88a4893	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	239.171.1.10	2026-04-10 15:40:06.931948+00
a653154f-508b-435f-99b2-d84f0626e340	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	8.234.1.10	2026-03-29 16:47:54.09407+00
5580f260-8db9-42aa-bff3-3628fc9ae263	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	76.204.1.10	2026-04-07 08:43:48.479052+00
748da0cd-b7ad-498a-93ee-05646be86247	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	2.216.1.10	2026-03-20 11:15:08.201379+00
cca666f2-5604-4b83-bf0a-7e542e706b78	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	23.0.1.10	2026-04-06 20:54:53.593626+00
99f6e703-7f33-448d-ba72-07186c0018a4	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	191.14.1.10	2026-03-28 16:40:59.919355+00
71f91123-d176-4f66-bdcb-9fa6f090b2a3	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	27.8.1.10	2026-03-22 11:22:09.497917+00
0c803e33-8c38-446d-960f-a6b3ee9817a4	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	212.47.1.10	2026-03-21 23:20:46.127585+00
f70496b0-4dab-4477-a706-1b469ed10ef3	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	84.171.1.10	2026-03-23 15:20:07.861984+00
f4618852-dbc3-4df5-9a28-eb79a573dbdc	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	134.2.1.10	2026-04-10 01:37:43.478569+00
85af014c-50fc-4a7a-97dd-39fa8ea71445	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	196.149.1.10	2026-03-28 23:06:33.783231+00
ab530f01-95c7-4d16-b1bd-02f4eb7806a3	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 34}	35.185.1.10	2026-03-22 04:05:46.012992+00
837fe50a-30b7-49dd-90c7-4d3133b0e83e	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	71.238.1.10	2026-04-12 15:12:37.111537+00
fd36a118-1509-4340-8c34-38d5e45716b6	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	176.156.1.10	2026-04-14 06:22:27.211732+00
bd5d7438-6926-4a52-b04f-e48017f4eb06	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	109.240.1.10	2026-03-19 08:41:03.7307+00
dcc1b85d-44c4-499e-8fe6-e424ca78b058	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 97}	22.74.1.10	2026-04-02 11:29:49.753601+00
fc86d520-311e-4479-a51a-721c4e438e26	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 75}	101.39.1.10	2026-03-25 22:36:58.063916+00
3e6e769c-9b45-4005-ba1d-2bd91b833d09	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 6}	109.236.1.10	2026-03-25 05:26:20.627651+00
dba48c05-a9a6-4177-b314-33f4ad574032	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	126.241.1.10	2026-04-12 10:49:37.892375+00
8f18e5b2-c6c3-44fd-9dba-350b852ee377	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 11}	136.138.1.10	2026-03-29 13:33:19.246682+00
431debd5-856d-4c18-ad6a-258c9de1fd6d	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	110.43.1.10	2026-04-01 02:27:09.480067+00
770603a0-bf92-4d68-8de9-0fc57f8ff14a	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	14.143.1.10	2026-04-01 14:06:44.845126+00
e7aceb3f-e069-42fe-aa8d-f3e0e13de19b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	41.206.1.10	2026-04-14 07:07:21.261644+00
855e73b5-f43f-4da4-a1b5-1891ca7ccc84	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 3}	50.111.1.10	2026-04-12 17:17:29.427689+00
13f24b2a-9579-4607-8c0c-9f4cc6f5cb08	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	236.50.1.10	2026-03-30 21:30:06.90281+00
d9735b03-49a8-479f-a214-0636bdd56288	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	11.209.1.10	2026-03-21 04:46:28.260218+00
cd338faf-ca4d-4fe0-9f08-af06853b30d5	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	8.39.1.10	2026-03-29 16:43:20.297221+00
e2ff48dd-6597-4879-98a4-96fa05185a16	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	117.1.1.10	2026-04-11 23:59:52.193763+00
afad1063-42f6-445e-8ea7-0215ee6185c8	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	10.181.1.10	2026-04-10 22:19:02.956425+00
6d55b674-448b-4aa1-9f31-9ecb21bd9125	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	59.144.1.10	2026-04-13 08:37:16.053603+00
9d3850cb-1440-4bd6-95d9-c9d22322be12	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 52}	148.11.1.10	2026-04-08 13:36:05.975023+00
ab30d174-fd03-4722-bb81-7487aa820fa9	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	253.231.1.10	2026-03-18 09:38:41.032687+00
e32939e9-024d-4f70-a15d-b1f8d46703d0	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	207.177.1.10	2026-03-22 04:52:17.846836+00
2223ced5-948d-47b3-b096-102f3197e30e	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	218.18.1.10	2026-04-09 18:39:43.523906+00
ad5852dc-b7e6-4649-b72f-96061df8c5df	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 4}	50.212.1.10	2026-04-04 19:39:25.6174+00
02359272-d9a8-4b9d-a2bb-573ced2599c0	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 73}	207.124.1.10	2026-03-31 13:25:54.158875+00
c8e3b146-4709-44c3-b4b3-06026a380981	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 68}	165.26.1.10	2026-03-26 02:31:37.336279+00
1eed208c-babd-4727-bffa-4b3b73cd4cd1	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	197.78.1.10	2026-03-28 14:47:45.642411+00
3e9877bc-b074-408a-a56a-d58d32071c1e	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	42.217.1.10	2026-03-21 16:01:25.198731+00
4f5159b7-461f-423e-a64c-58867326e096	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	84.175.1.10	2026-03-16 12:57:10.087985+00
8b3675f0-e4c9-4107-9e41-5ccede769fc2	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	236.213.1.10	2026-03-21 13:01:07.433053+00
fa1e7868-c43d-4bf7-9331-7efc833a0691	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	0.131.1.10	2026-04-14 11:26:40.310197+00
891cb742-02a7-467d-ac63-0a34bef19a41	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 22}	105.170.1.10	2026-04-02 21:55:03.714657+00
ca060085-dd23-4462-8cfa-d2187330fd41	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	141.236.1.10	2026-03-26 08:57:52.748381+00
3b968cf5-a820-4bf0-b85c-c2c269175a5b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 50}	237.174.1.10	2026-03-21 15:16:12.599315+00
58a52c62-dff4-435a-b0c9-0d2bf1bfed5f	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	90.170.1.10	2026-04-11 16:46:52.201472+00
15b82d24-1989-439d-a7ca-d64ea8c5c321	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 53}	227.75.1.10	2026-04-07 04:03:48.7446+00
5a298325-bc52-405b-b81c-5e7dfd1ff7e0	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	65.242.1.10	2026-03-16 15:48:19.457333+00
c01f16b5-5820-41b8-a491-5c7d088a8cd4	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	177.124.1.10	2026-03-26 15:15:48.80995+00
0314971f-96f9-40d0-9288-b1f2202347e4	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	240.86.1.10	2026-03-23 04:03:35.750939+00
94eb4226-5b80-4f88-be55-32aac53e145f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	86.90.1.10	2026-03-30 07:22:58.064441+00
7d2d441f-fcb6-468f-9389-37b99a7a7d7c	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	63.209.1.10	2026-03-21 01:40:06.063677+00
73c6b5fe-eaa9-4eeb-ad42-1585d1782629	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 76}	201.145.1.10	2026-04-01 05:47:32.890292+00
12fda796-ec76-4dd8-84f4-c9d6c5196150	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	38.62.1.10	2026-04-03 18:45:15.378041+00
d3bd98d8-cb69-4f0b-8e43-706f0d7ab84f	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	49.50.1.10	2026-04-12 10:51:13.25842+00
bfe870ed-0501-4487-a005-0de4d56a8400	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 92}	121.50.1.10	2026-03-29 05:20:18.460381+00
9bbd803e-acc6-46b5-93cf-63a9b8e94fa2	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 46}	57.63.1.10	2026-03-19 03:59:37.101818+00
932867d6-472f-4dfe-a69f-e3adcc4c663c	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	111.186.1.10	2026-04-01 21:35:52.011668+00
c85f74fc-be7b-4c62-99a0-396994dd6d81	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 62}	99.182.1.10	2026-03-29 12:57:44.569465+00
3f747d21-e36d-4282-80f1-01aeb33d1942	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 91}	228.9.1.10	2026-04-07 02:07:16.972864+00
968e69b0-09fd-41fd-9707-9658e1803069	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 77}	47.232.1.10	2026-04-11 05:11:20.711318+00
4ebfb5d3-7026-4e4a-bbd8-56a41b8ccb91	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	16.115.1.10	2026-04-04 23:11:34.601425+00
444ff6b9-d36e-4bef-a385-6d581a230f14	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	70.67.1.10	2026-03-16 09:41:10.605658+00
9fb89ce0-3019-4df7-b979-f0465069ed6b	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	141.216.1.10	2026-04-14 15:02:08.688201+00
9bdc3a7b-7784-4222-b2e6-9b8386ca7885	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 99}	176.130.1.10	2026-04-01 09:32:52.501655+00
5f2d0fcc-7cf3-40d5-82a1-46d8bad992eb	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	94.151.1.10	2026-03-16 22:26:53.782515+00
7100eca8-d67d-4912-b53b-3f1a954cf4a4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 33}	91.124.1.10	2026-03-23 07:04:10.37435+00
c588acdf-973f-46fa-b2de-134bcc973b72	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	67.148.1.10	2026-04-01 01:20:58.973722+00
67e30f2d-1462-4458-8fc4-0992645b4a0c	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 38}	171.204.1.10	2026-03-22 03:04:30.191802+00
cc109e4f-0be2-4d5e-949d-a38cf6a0c25d	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 13}	175.194.1.10	2026-03-23 06:22:10.837079+00
ed665234-f9d4-4bb6-bb6d-1419e6875e7b	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 95}	224.80.1.10	2026-04-09 10:22:15.344431+00
afc18627-dc19-4f81-a971-1aa8b3bcdb6b	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	40.169.1.10	2026-04-01 00:52:26.065708+00
184500ae-ca5c-473d-882f-a628ace6ac97	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 82}	102.252.1.10	2026-03-25 15:27:39.211845+00
0cb989f6-d3ad-4d5b-8d20-82c70c1d0fbf	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 80}	136.64.1.10	2026-04-13 23:41:53.592564+00
328458c3-0d09-4d95-bc7a-4ae9dfba3884	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	138.207.1.10	2026-03-16 17:31:02.506659+00
c8a5a15f-755d-491c-9355-6c83b1e53cdc	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 12}	41.170.1.10	2026-04-11 18:56:22.150569+00
0722e660-149e-4a63-8700-22b465522e81	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 84}	59.146.1.10	2026-04-08 12:43:21.390283+00
8ffaba76-468f-4181-b18f-f40dcd090697	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 67}	215.73.1.10	2026-04-07 13:23:19.712365+00
dd5ee06a-2f19-4100-b58a-a19f8f9fb1a5	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	78.252.1.10	2026-03-21 01:08:56.287338+00
b3a38043-ff52-4536-a67c-d831e77bcd9f	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 63}	200.9.1.10	2026-03-24 09:32:59.858946+00
c242ebf5-9ee3-4839-9fed-b3c31c549701	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 90}	88.61.1.10	2026-04-11 19:38:21.150968+00
81d8065b-708c-46d7-ad3e-9a8e45fc2cf9	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 99}	246.82.1.10	2026-04-10 03:03:04.360768+00
8ede3477-310b-41bf-b661-f71f4c4e625d	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	107.94.1.10	2026-03-19 17:26:47.140084+00
fa7e1994-8f88-4328-8bba-68b7d88ae84d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	97.94.1.10	2026-04-03 06:32:54.126685+00
d64af8de-55df-4e30-acd6-b92eece50634	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	88.2.1.10	2026-03-21 04:21:52.797562+00
bdae8090-86f0-4e37-b431-594f795462bc	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 19}	83.147.1.10	2026-03-16 05:01:12.864815+00
5a11ec0e-59dc-444f-acea-136127bb8a4a	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 56}	122.2.1.10	2026-04-04 15:12:42.679349+00
29b7f9c9-3ca6-4ffe-9e1d-86506bea4b2d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 1}	40.26.1.10	2026-03-19 19:01:26.870381+00
813462d4-6c48-46db-8f77-c7dbf674d238	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 74}	67.28.1.10	2026-04-08 07:35:39.128632+00
9ad2ecd3-c17c-4d7c-9946-9e9a89e07433	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 0}	89.135.1.10	2026-04-14 01:17:44.024741+00
a16f6bf7-7cd5-4e8d-b43e-342f14e9ed38	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 26}	34.115.1.10	2026-03-29 13:59:53.61795+00
572fee2e-851f-47c0-95d5-5122c05e60bd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	246.12.1.10	2026-04-13 05:35:48.864602+00
5e3ac818-5bc5-45bd-98c7-0bfbe1ebdd37	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 8}	175.200.1.10	2026-03-29 12:15:49.867133+00
5adff66f-e99e-4687-8164-fb802d7a5212	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 42}	37.203.1.10	2026-04-09 07:47:41.546682+00
335f7752-409a-4dae-8326-386085c27ce1	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	222.198.1.10	2026-03-24 12:06:40.772196+00
ff1c2e4c-0d4a-46b8-9b2a-e4f7f7290ad4	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 79}	126.221.1.10	2026-03-30 01:40:12.550837+00
05f73f30-86b5-48c6-a052-6522c468f00f	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 37}	170.110.1.10	2026-04-05 17:08:03.808801+00
8ea11d7b-f18c-4fc8-a80f-dd7bec77b87d	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	29.44.1.10	2026-03-30 02:06:50.29624+00
ee033f3c-dcc1-482d-830c-7c3ab7635fd8	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 69}	73.215.1.10	2026-04-07 15:50:51.988532+00
cc9d1962-6af2-470b-bdd3-d0ef42a8c570	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 24}	93.30.1.10	2026-04-07 22:46:33.733093+00
548e9f40-02de-49b7-abf8-308826a7c1a9	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	142.147.1.10	2026-03-27 14:41:55.231518+00
3f728154-4a2c-4252-8f46-ff0c92aac70a	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	154.249.1.10	2026-03-18 09:55:07.370265+00
e6fdae36-2886-4ab7-9246-6db5df536256	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 59}	78.249.1.10	2026-03-21 02:33:11.686891+00
fd864a20-4e60-4c91-aa7d-8e4c14b96323	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 87}	114.82.1.10	2026-03-30 22:30:37.167327+00
d433c8cc-3f2b-4fdc-bf05-4e58156f9df3	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 88}	66.193.1.10	2026-03-22 04:07:26.669359+00
e3a30b6a-5d43-4cbb-a463-3afe90774bbe	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	247.153.1.10	2026-03-29 07:56:31.455832+00
4834efbb-5ab5-48d1-86ab-94225e58ac80	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 55}	155.176.1.10	2026-03-24 18:05:55.572365+00
b892abc6-f7e0-4a21-abdf-4b23126f9c3d	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 47}	30.126.1.10	2026-03-22 20:31:35.439441+00
b305a912-c3b1-4a64-a370-9b1488f80cbd	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 94}	227.57.1.10	2026-03-21 18:44:29.286174+00
3ffd6fe7-9c76-4c24-bc5b-a17bca312950	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 51}	112.181.1.10	2026-03-29 21:56:35.501248+00
3a5eb09f-1aff-49e7-9c0d-8ea979fe966c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 70}	126.62.1.10	2026-04-13 19:52:25.627935+00
dd3dbd39-74b6-418d-9b7d-1b00514ec4b8	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 28}	35.31.1.10	2026-04-03 14:35:05.207987+00
9925fa04-2c0c-4b37-9fd4-5233fdb37778	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	58.239.1.10	2026-03-29 20:11:19.895899+00
e52de6df-df7b-479e-b03b-ea6920afa507	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	228.100.1.10	2026-03-25 12:22:21.642472+00
6c117299-219a-4d5f-8086-ff46a3381e56	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 71}	44.107.1.10	2026-03-26 03:25:59.995877+00
749f6be0-dcb0-475d-9227-6edbfd868fe5	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	189.34.1.10	2026-03-21 01:21:49.90818+00
c0875071-9d45-4191-98fd-18672bf9fbe9	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 2}	3.39.1.10	2026-04-04 20:20:05.342452+00
17dd31ae-1627-4d0c-9538-22fd0e20905c	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 44}	86.34.1.10	2026-04-05 20:08:16.965678+00
edc4d4ca-58f1-433e-a189-fc93e0c94b77	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 14}	206.150.1.10	2026-04-07 06:39:23.227423+00
a4e50a0e-a527-4477-97a7-635a2e001e78	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 72}	219.169.1.10	2026-04-07 23:13:47.440164+00
8370ad7e-d564-488a-8c74-182906044b32	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	25.17.1.10	2026-04-02 00:46:08.589663+00
e42720ca-4728-41d4-b044-a3d3c49ff69b	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 41}	150.104.1.10	2026-03-22 23:37:34.361511+00
7b421e1c-1f84-4447-865c-a51ae05b2fdd	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	81.88.1.10	2026-03-22 13:15:04.080653+00
2db35f08-f9b8-40fe-8f84-12b1801d8344	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	220.64.1.10	2026-03-24 03:18:16.306437+00
03c6daa7-c3fc-4537-9b64-00b607ba634e	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 86}	143.31.1.10	2026-03-25 04:46:03.114855+00
d8c76f2e-3731-4cee-9f61-ee2bc67dca23	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 61}	120.137.1.10	2026-04-07 14:35:46.274291+00
cb87ef25-7861-45ff-b556-63a6e0b98296	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	25.48.1.10	2026-04-05 03:27:14.752318+00
9e508cde-85ca-4790-b0d1-d137c0b2bff4	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 7}	248.232.1.10	2026-03-31 22:10:02.363013+00
4f2661f8-ecb2-4a6d-aa6b-c42f88f94408	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 48}	7.42.1.10	2026-04-02 20:15:47.058321+00
0f1b1186-33dc-445b-b44f-65d90e434da1	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 78}	50.249.1.10	2026-04-13 07:50:50.564631+00
3c4315ac-c158-4b12-8aa1-d7bb718c4dd1	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 21}	127.79.1.10	2026-04-10 15:59:51.443041+00
96cae2fa-0024-456f-9675-e5eef59f42ba	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 65}	83.253.1.10	2026-04-10 11:00:19.211991+00
2b042c13-43a0-4ed7-9fef-a18e3717862f	2b609790-c885-4a9a-9978-442b92e9534d	API_KEY_ROTATED	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 20}	180.46.1.10	2026-03-27 14:54:29.987661+00
fa7fc9fc-965b-4b61-8fa5-18ec06b54e19	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 66}	76.58.1.10	2026-03-19 17:21:33.125164+00
7ac992e9-d93f-4414-96f9-ffebd29cf058	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 15}	27.173.1.10	2026-04-09 06:38:57.885514+00
6c40f857-afa2-4019-acb1-867594cf0889	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 9}	180.36.1.10	2026-04-14 02:31:12.991441+00
7763d50f-61c1-49cb-ba8f-f77780df4052	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 5}	41.10.1.10	2026-04-06 17:28:24.350998+00
ed3da62f-d434-45b0-8e78-d00ea2c2a5e2	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 60}	42.123.1.10	2026-04-10 21:30:34.259253+00
5a5b8df8-3c19-41d1-8234-3ab53ca3e13b	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 85}	9.209.1.10	2026-03-26 06:57:31.946737+00
c881492d-cc9b-43fb-8fc8-2e29ccf867b8	2b609790-c885-4a9a-9978-442b92e9534d	VIEWED_DASHBOARD	PRODUCT_INTELLIGENCE	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 83}	27.170.1.10	2026-04-03 18:55:47.505647+00
914037fa-2660-4c19-bca9-96e062320466	2b609790-c885-4a9a-9978-442b92e9534d	SESSION_EXPIRED	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 93}	216.163.1.10	2026-04-03 23:32:27.428947+00
8205964b-f2d2-4859-ab71-400436a25bda	2b609790-c885-4a9a-9978-442b92e9534d	USER_LOGIN_SUCCESS	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 44}	127.193.1.10	2026-04-02 08:26:59.273158+00
0c790857-2826-41e6-8398-e4fb6fb4e461	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	IDENTITY	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 57}	235.196.1.10	2026-03-18 06:45:02.606835+00
577d3016-05e4-45c4-84db-4860b4c68a94	2b609790-c885-4a9a-9978-442b92e9534d	SEARCHED_INVENTORY	WAREHOUSE_OPS	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 58}	186.22.1.10	2026-04-14 08:17:46.622096+00
eed75776-cdc8-4a55-b91a-8444021b0b82	2b609790-c885-4a9a-9978-442b92e9534d	DOWNLOADED_REPORT	FORWARD_FULFILLMENT	{"detail": "Routine background activity.", "severity": "LOW", "simulated_latency_ms": 39}	246.120.1.10	2026-04-01 17:31:49.440386+00
33df1ef9-25d0-4ad7-ab8b-f184314df4d0	1a09efe6-50a8-4d80-bb67-1280baa33e15	GLOBAL_RECALL_INITIATED	REVERSE_LOGISTICS	{"reason": "Class II: Sub-standard dissolution rate detected in post-market surveillance.", "batch_id": 15, "severity": "CRITICAL", "recall_id": 1}	10.0.0.1	2026-04-14 13:31:09.983508+00
69e1ecf2-e764-4e69-b531-9622862262aa	1a09efe6-50a8-4d80-bb67-1280baa33e15	DRUGS_DESTROYED	REVERSE_LOGISTICS	{"severity": "HIGH", "assessment_id": 1, "disposal_method": "Incineration"}	10.0.0.5	2026-04-14 14:31:09.983508+00
b7c20858-05a6-4cff-9429-0d1495390abe	1a09efe6-50a8-4d80-bb67-1280baa33e15	DRUGS_DESTROYED	REVERSE_LOGISTICS	{"severity": "HIGH", "assessment_id": 2, "disposal_method": "Chemical_Neutralization"}	10.0.0.5	2026-04-14 17:18:34.41604+00
\.


--
-- Data for Name: organisations; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.organisations (org_id, org_name, org_type, reg_no, contact_email, is_active, created_at_utc) FROM stdin;
96a73ed7-bc75-48de-abb6-b1eab134fb26	Avant-Garde LifeSciences	Manufacturer	MFG/MP/2026/9981	compliance@avantlifesci.com	t	2026-04-13 13:53:50.707766+00
0b9979ed-8caa-4d22-82be-b997e2509252	Madhya Pradesh Central Drug Depot	Distributor	DIST/BPL/2026/102	ops@mpdrugdepot.gov.in	t	2026-04-13 13:53:50.707766+00
423437e5-bbea-4f4a-a49f-3a1ae478f89c	Swift-Trace Logistics Pvt Ltd	Transporter	TRANS/IND/7721	tracking@swifttrace.co.in	t	2026-04-13 13:53:50.707766+00
f8e303d0-608f-48ef-832f-02c848a68232	Bhopal City Care Pharmacy	Retailer	RET/BPL/882	manager@citycarebpl.com	t	2026-04-13 13:53:50.707766+00
a761feff-9ccb-4d9f-9265-cc3e925a80ca	Apex Generic Labs	Manufacturer	MFG/MP/2022/1044	admin@apexgenerics.in	f	2026-04-14 06:35:47.089794+00
bc0c8e9a-c0d7-4376-a920-85edd59bb545	Vindhya Regional Distributors	Distributor	DIST/BPL/2021/088	ops@vindhyadist.com	f	2026-04-14 06:35:47.089794+00
7082bff8-9fdd-4ae3-a017-6a131fa714ae	Cargo-Net Movers	Transporter	TRANS/IND/4402	dispatch@cargonet.in	f	2026-04-14 06:35:47.089794+00
fe445ae8-ed1f-43b2-b52f-8a1e678f5590	Sanjeevani Medico Store	Retailer	RET/BPL/305	info@sanjeevanimedico.com	f	2026-04-14 06:35:47.089794+00
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.permissions (permission_id, module_category, action_name) FROM stdin;
c71c915b-2c2c-458f-a429-cc397fd476dd	IDENTITY	system:admin
343ed7ba-495a-425a-a158-7d89a7a58bef	PRODUCT	batch:authorize
e7cd1fa5-6c74-4bfb-b59b-545a25d3efad	WAREHOUSE	inventory:audit
fbfb52af-b70b-4cc8-bb01-a62a0ccf6739	FULFILLMENT	shipment:verify
fde76807-9f33-4ba7-973d-05b18d53a1ef	FINANCE	ledger:reconcile
9d306efd-322f-4ed3-8c17-0426ca2b2a0f	RECALL	recall:broadcast
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.role_permissions (role_id, permission_id) FROM stdin;
ebfbf1db-ca44-4f61-8b48-886e3f768278	c71c915b-2c2c-458f-a429-cc397fd476dd
0cf74603-ff8b-41f1-9458-a47b6ed15a08	343ed7ba-495a-425a-a158-7d89a7a58bef
d454b48e-c74f-4ac1-b87b-e52bdeeddee7	fbfb52af-b70b-4cc8-bb01-a62a0ccf6739
024cd197-2e09-497d-8b1d-53221abe2961	fde76807-9f33-4ba7-973d-05b18d53a1ef
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.roles (role_id, role_name, description) FROM stdin;
ebfbf1db-ca44-4f61-8b48-886e3f768278	Chief_Informatics_Officer	System-wide governance and identity management.
0cf74603-ff8b-41f1-9458-a47b6ed15a08	Production_Superintendent	Oversees medicine catalogs and batch manufacturing.
f88bd8b8-4cae-4c43-adb2-763c4fbcbb04	Inventory_Controller	Manages warehouse storage and internal stock movement.
d454b48e-c74f-4ac1-b87b-e52bdeeddee7	Logistics_Director	Responsible for fleet registry and order fulfillment.
024cd197-2e09-497d-8b1d-53221abe2961	Revenue_Audit_Officer	Handles financial reconciliation and compliance analytics.
2d60c8a1-62df-4c8c-a1ff-ef50757de9a0	Recall_Coordinator	Triggers global recalls and manages return stock assessments.
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.user_sessions (session_id, user_id, ip_address, login_time_utc, log_out_time_utc) FROM stdin;
0e31fb61-3648-4949-9e80-373319384a62	e51028f5-1028-4444-8888-f51028f51028	192.168.1.45	2026-04-17 03:26:05.908666+00	\N
a602cbe3-1018-49f1-85e8-049c486b4e97	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	10.0.4.12	2026-04-17 02:11:05.908666+00	\N
c92424e9-375e-4bb5-9c53-22ea6c69c45e	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	172.16.0.8	2026-04-17 03:56:05.908666+00	\N
2ead1d91-7192-4edf-b7be-25ff7304cf81	03bf32d6-485e-497b-8888-ceacee875b65	192.168.10.100	2026-04-17 03:11:05.908666+00	\N
8134f83b-7db2-4d1e-8558-85c56e2a21fb	c6c449e4-ec43-4c95-811f-f87da31d1321	10.0.4.15	2026-04-16 23:11:05.908666+00	2026-04-17 02:11:05.908666+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: identity_mod; Owner: postgres
--

COPY identity_mod.users (user_id, org_id, role_id, password_hash, first_name, last_name, is_active, created_at_utc) FROM stdin;
2b609790-c885-4a9a-9978-442b92e9534d	96a73ed7-bc75-48de-abb6-b1eab134fb26	ebfbf1db-ca44-4f61-8b48-886e3f768278	argon2_hashed_secret	Amit	Kumar	f	2026-04-14 06:31:39.848442+00
3fe7d24b-328d-4b6b-95fc-8e3bac01f07b	96a73ed7-bc75-48de-abb6-b1eab134fb26	0cf74603-ff8b-41f1-9458-a47b6ed15a08	argon2_hashed_secret	Priya	Deshmukh	f	2026-04-14 06:31:39.848442+00
0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	0b9979ed-8caa-4d22-82be-b997e2509252	f88bd8b8-4cae-4c43-adb2-763c4fbcbb04	argon2_hashed_secret	Rahul	Reddy	f	2026-04-14 06:31:39.848442+00
c6c449e4-ec43-4c95-811f-f87da31d1321	423437e5-bbea-4f4a-a49f-3a1ae478f89c	d454b48e-c74f-4ac1-b87b-e52bdeeddee7	argon2_hashed_secret	Sneha	Kapoor	f	2026-04-14 06:31:39.848442+00
59337730-2f86-449c-bc21-41f9b6a3e404	96a73ed7-bc75-48de-abb6-b1eab134fb26	024cd197-2e09-497d-8b1d-53221abe2961	argon2_hashed_secret	Vikram	Rao	f	2026-04-14 06:31:39.848442+00
4a31302e-f3f4-449a-9f49-9ddee5a9e4c3	96a73ed7-bc75-48de-abb6-b1eab134fb26	2d60c8a1-62df-4c8c-a1ff-ef50757de9a0	argon2_hashed_secret	Ananya	Iyer	f	2026-04-14 06:31:39.848442+00
682d6af0-d81f-4f1a-882f-f2d4fdbd9243	96a73ed7-bc75-48de-abb6-b1eab134fb26	ebfbf1db-ca44-4f61-8b48-886e3f768278	argon2_hashed_secret	Arjun	Desai	t	2026-04-13 13:53:50.707766+00
03bf32d6-485e-497b-8888-ceacee875b65	96a73ed7-bc75-48de-abb6-b1eab134fb26	0cf74603-ff8b-41f1-9458-a47b6ed15a08	argon2_hashed_batch_lead	Kavya	Menon	t	2026-04-13 13:53:50.707766+00
0b56a543-c19d-43ef-b948-bab7ee9b84ef	f8e303d0-608f-48ef-832f-02c848a68232	f88bd8b8-4cae-4c43-adb2-763c4fbcbb04	argon2_hashed_stock_lead	Rohan	Chatterjee	t	2026-04-13 13:56:48.338931+00
a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	423437e5-bbea-4f4a-a49f-3a1ae478f89c	d454b48e-c74f-4ac1-b87b-e52bdeeddee7	argon2_hashed_delivery_lead	Aditya	Sen	t	2026-04-13 13:53:50.707766+00
1a09efe6-50a8-4d80-bb67-1280baa33e15	96a73ed7-bc75-48de-abb6-b1eab134fb26	024cd197-2e09-497d-8b1d-53221abe2961	argon2_hashed_finance_lead	Karthik	Iyer	t	2026-04-13 13:53:50.707766+00
5605622a-6b0f-41d9-84e6-16658720569d	96a73ed7-bc75-48de-abb6-b1eab134fb26	2d60c8a1-62df-4c8c-a1ff-ef50757de9a0	argon2_hashed_recall_lead	Neha	Pillai	t	2026-04-13 13:53:50.707766+00
e59ea77c-bf5a-4729-b64f-f1d52d44b23d	96a73ed7-bc75-48de-abb6-b1eab134fb26	2d60c8a1-62df-4c8c-a1ff-ef50757de9a0	argon2_hashed_secret	Ananya	Iyer	f	2026-04-14 06:35:47.089794+00
e51028f5-1028-4444-8888-f51028f51028	0b9979ed-8caa-4d22-82be-b997e2509252	0cf74603-ff8b-41f1-9458-a47b6ed15a08	hashed_pwd	Ram	Charan	t	2026-04-17 04:11:05.908666+00
\.


--
-- Data for Name: batch_master; Type: TABLE DATA; Schema: product_and_batch_intelligence; Owner: postgres
--

COPY product_and_batch_intelligence.batch_master (batch_id, medicine_id, manufacturer_id, registered_by_user_id, batch_number, mfg_date, expiry_date, quantity_produced, status, created_at) FROM stdin;
2	1	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-AMX-2026-02	2026-04-04	2028-04-14	20000	Released	2026-04-14 06:41:54.680006+00
3	2	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-PAR-2026-01	2026-04-09	2028-04-14	10000	Released	2026-04-14 06:41:54.680006+00
5	3	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-VAX-2026-01	2026-04-09	2028-04-14	10000	Released	2026-04-14 06:41:54.680006+00
12	9	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-INS-2026-01	2026-04-09	2028-04-14	10000	Released	2026-04-14 06:41:54.680006+00
16	6	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-GAS-EXPIRED-99	2023-01-01	2024-01-01	500	Released	2026-04-14 06:41:54.680006+00
17	3	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-VAX-FAILED-00	2026-04-09	2027-04-14	1000	Rejected	2026-04-14 06:41:54.680006+00
18	9	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-INS-LOW-STOCK	2026-04-13	2027-04-14	5	Released	2026-04-14 06:41:54.680006+00
4	2	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-PAR-2026-02	2026-04-04	2028-04-14	20000	Pending	2026-04-14 06:41:54.680006+00
15	10	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-ALR-2026-02	2026-04-04	2028-04-14	20000	Recalled	2026-04-14 06:41:54.680006+00
1	1	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-AMX-2026-01	2026-04-09	2028-04-14	10000	Quality-Check	2026-04-14 06:41:54.680006+00
8	5	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-LIP-2026-01	2026-04-09	2028-04-14	10000	Quality-Check	2026-04-14 06:41:54.680006+00
14	10	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-ALR-2026-01	2026-04-09	2028-04-14	10000	Quality-Check	2026-04-14 06:41:54.680006+00
6	3	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-VAX-2026-02	2026-04-04	2028-04-14	20000	Released	2026-04-14 06:41:54.680006+00
10	7	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-HYP-2026-01	2026-04-09	2028-04-14	10000	Quality-Check	2026-04-14 06:41:54.680006+00
7	4	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-MET-2026-01	2026-04-09	2028-04-14	10000	Released	2026-04-14 06:41:54.680006+00
9	6	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-GAS-2026-01	2026-04-09	2028-04-14	10000	Released	2026-04-14 06:41:54.680006+00
11	8	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-ZIT-2026-01	2026-04-09	2028-04-14	10000	Released	2026-04-14 06:41:54.680006+00
13	9	96a73ed7-bc75-48de-abb6-b1eab134fb26	03bf32d6-485e-497b-8888-ceacee875b65	B-INS-2026-02	2026-04-04	2028-04-14	20000	Released	2026-04-14 06:41:54.680006+00
\.


--
-- Data for Name: chemical_compositions; Type: TABLE DATA; Schema: product_and_batch_intelligence; Owner: postgres
--

COPY product_and_batch_intelligence.chemical_compositions (composition_id, medicine_id, active_ingredient, strength, dosage_form) FROM stdin;
1	1	Amoxicillin Trihydrate	500mg	Capsule
2	2	Acetaminophen	650mg	Tablet
3	3	Metformin Hydrochloride	500mg	Sustained-Release Tablet
4	4	Atorvastatin Calcium	20mg	Tablet
5	5	Amlodipine Besylate	5mg	Tablet
6	6	Azithromycin Dihydrate	250mg	Tablet
7	7	Omeprazole Magnesium	20mg	Delayed-Release Capsule
8	8	Cetirizine Dihydrochloride	10mg	Tablet
9	9	Inactivated Influenza Virus	0.5ml	Injection
10	10	Insulin Aspart (rDNA origin)	100 IU/ml	Injection/Pen
11	11	Rofecoxib	25mg	Tablet
12	12	Thalidomide	50mg	Capsule
\.


--
-- Data for Name: medicines; Type: TABLE DATA; Schema: product_and_batch_intelligence; Owner: postgres
--

COPY product_and_batch_intelligence.medicines (medicine_id, brand_name, generic_name, category, is_active, created_at) FROM stdin;
1	Amox-Guard 500	Amoxicillin	Antibiotic	t	2026-04-14 06:54:37.523343+00
2	Paracit-DS	Paracetamol	Analgesic	t	2026-04-14 06:54:37.523343+00
3	Metform-SR	Metformin Hydrochloride	Anti-Diabetic	t	2026-04-14 06:54:37.523343+00
4	Lipid-Down 20	Atorvastatin	Statin	t	2026-04-14 06:54:37.523343+00
5	Hyper-Stop 5	Amlodipine	Antihypertensive	t	2026-04-14 06:54:37.523343+00
6	Zithro-Max 250	Azithromycin	Antibiotic	t	2026-04-14 06:54:37.523343+00
7	Gastro-Safe	Omeprazole	Antacid	t	2026-04-14 06:54:37.523343+00
8	Aller-Quit	Cetirizine	Antihistamine	t	2026-04-14 06:54:37.523343+00
9	Vax-Flow 26	Influenza Vaccine	Vaccine	t	2026-04-14 06:54:37.523343+00
10	Insulo-Rapid	Insulin Aspart	Hormone	t	2026-04-14 06:54:37.523343+00
11	Rofec-Banned	Rofecoxib	NSAID	f	2026-04-14 06:54:37.523343+00
12	Thali-Legacy	Thalidomide	Immunomodulatory	f	2026-04-14 06:54:37.523343+00
\.


--
-- Data for Name: packaging_standards; Type: TABLE DATA; Schema: product_and_batch_intelligence; Owner: postgres
--

COPY product_and_batch_intelligence.packaging_standards (packaging_id, medicine_id, min_temp_celsius, max_temp_celsius, humidity_limit, fragility_index) FROM stdin;
1	1	15.00	25.00	60.00	2
2	2	15.00	30.00	65.00	1
3	3	20.00	25.00	50.00	2
4	4	15.00	25.00	55.00	1
5	5	15.00	30.00	60.00	1
6	6	15.00	30.00	60.00	2
7	7	15.00	25.00	40.00	3
8	8	15.00	25.00	55.00	1
9	9	2.00	8.00	45.00	5
10	10	2.00	8.00	40.00	6
11	11	20.00	25.00	50.00	2
12	12	15.00	25.00	45.00	4
\.


--
-- Data for Name: quality_check_specs; Type: TABLE DATA; Schema: product_and_batch_intelligence; Owner: postgres
--

COPY product_and_batch_intelligence.quality_check_specs (spec_id, medicine_id, purity_threshold, dissolution_rate, ph_balance_req, required_certs) FROM stdin;
1	1	98.50	30 mins	6.50	ISO-9001, GMP
2	2	99.00	15 mins	7.00	GMP-Certified
3	3	98.00	12 hours	6.80	ISO-13485
4	4	99.20	45 mins	7.40	GMP, FDA-Approved
5	5	99.00	30 mins	7.00	GMP-Certified
6	6	98.80	30 mins	6.90	ISO-9001
7	7	97.50	60 mins	8.10	ISO-9001
8	8	99.00	20 mins	7.00	GMP-Certified
9	9	99.90	Immediate	7.20	WHO-Prequalified
10	10	99.95	Immediate	7.35	Bio-Safety Level 2
11	11	95.00	30 mins	6.00	BANNED-REF-09
12	12	99.90	45 mins	7.00	Strict-Auth-Only
\.


--
-- Data for Name: financial_aggregate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.financial_aggregate (report_id, org_id, report_date, total_orders, total_gross_revenue, total_tax_liability, generated_by_user_id, created_at_utc) FROM stdin;
6f73e999-5bcd-40f8-8188-6026b8b9e5e9	6413f8ee-2238-41a2-a84a-da82c4e4e3a7	2026-04-01	25	5000.00	500.00	3a48e07b-b3c6-4437-99a5-6ac3d3f26d14	2026-04-09 04:19:38.195481+00
539db3be-670f-4339-a9dd-2ae02585b123	17a880ea-cc2a-4fd3-b6af-84d198b2fb87	2026-04-02	30	7200.00	720.00	a15b2bc5-b5b8-432f-9ab2-20b30a8e1fa3	2026-04-09 04:19:38.195481+00
37478b43-456e-43c1-afc6-8b2168efd201	2fad1a58-ec6d-410e-a04b-8c22c6903275	2026-04-03	18	3100.00	310.00	35dc12fd-b8af-4283-85cc-f2789c871b22	2026-04-09 04:19:38.195481+00
\.


--
-- Data for Name: payment_ledger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_ledger (payment_id, order_id, payer_org_id, payee_org_id, base_amount, tax_percentage, payment_status, created_at_utc) FROM stdin;
e747bd4b-6dcc-4eef-996f-6e2801ecb678	f23471b2-ad4d-4185-a9a6-07774a2f3a88	61999287-2e0d-438d-b269-f1e154b3c5ca	dafea461-85c0-4da5-aca0-83b0dbafa1a3	200.00	5.00	completed	2026-04-09 04:10:51.73224+00
cd12ecea-378a-42c7-a603-2f113793a8f2	70010062-e4cc-4508-a970-0601139754aa	f327d983-b2a4-49aa-a326-3c5fd827241a	5734be6d-8ba3-49e7-ba56-f0f78ad9cb71	150.50	8.00	pending	2026-04-09 04:10:51.73224+00
62849663-7fe8-4a26-87aa-c77a00680dc7	d3e2f48e-1c8a-4e53-a850-ac53b3139a2d	1683f93a-4fc8-45e1-aa54-fd18b1525cd6	ad391517-add0-4154-903f-958d859e25f6	320.75	12.00	failed	2026-04-09 04:10:51.73224+00
5a0c3f15-2110-49a0-bbde-7d2bd3df7c78	ecc1b4ac-6cbe-4518-8065-e4d0a76d6d19	de1f3912-c1ab-47dc-87de-f78ace91eb59	e4f74dd8-319a-4ef5-b306-26c418bfad95	89.99	18.00	completed	2026-04-09 04:10:51.73224+00
e4719bf2-c40b-4fcc-98d6-750b66208e38	f9281eb4-e338-47b3-9654-70b48f89eeab	10469b66-e94d-4085-b8a3-09e2a59572e5	67550e23-69df-4366-aea4-9ec3a2057d0b	500.00	10.00	cancelled	2026-04-09 04:10:51.73224+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-04-07 06:02:43
20211116045059	2026-04-07 06:02:44
20211116050929	2026-04-07 06:02:45
20211116051442	2026-04-07 06:02:45
20211116212300	2026-04-07 06:02:46
20211116213355	2026-04-07 06:02:47
20211116213934	2026-04-07 06:02:47
20211116214523	2026-04-07 06:02:48
20211122062447	2026-04-07 06:02:49
20211124070109	2026-04-07 06:02:49
20211202204204	2026-04-07 06:02:50
20211202204605	2026-04-07 06:02:51
20211210212804	2026-04-07 06:02:53
20211228014915	2026-04-07 06:02:53
20220107221237	2026-04-07 06:02:54
20220228202821	2026-04-07 06:02:55
20220312004840	2026-04-07 06:02:55
20220603231003	2026-04-07 06:02:56
20220603232444	2026-04-07 06:02:57
20220615214548	2026-04-07 06:02:58
20220712093339	2026-04-07 06:02:58
20220908172859	2026-04-07 06:02:59
20220916233421	2026-04-07 06:03:00
20230119133233	2026-04-07 06:03:00
20230128025114	2026-04-07 06:03:01
20230128025212	2026-04-07 06:03:02
20230227211149	2026-04-07 06:03:03
20230228184745	2026-04-07 06:03:03
20230308225145	2026-04-07 06:03:04
20230328144023	2026-04-07 06:03:04
20231018144023	2026-04-07 06:03:05
20231204144023	2026-04-07 06:03:06
20231204144024	2026-04-07 06:03:07
20231204144025	2026-04-07 06:03:07
20240108234812	2026-04-07 06:03:08
20240109165339	2026-04-07 06:03:09
20240227174441	2026-04-07 06:03:10
20240311171622	2026-04-07 06:03:11
20240321100241	2026-04-07 06:03:12
20240401105812	2026-04-07 06:03:14
20240418121054	2026-04-07 06:03:15
20240523004032	2026-04-07 06:03:17
20240618124746	2026-04-07 06:03:18
20240801235015	2026-04-07 06:03:19
20240805133720	2026-04-07 06:03:19
20240827160934	2026-04-07 06:03:20
20240919163303	2026-04-07 06:03:21
20240919163305	2026-04-07 06:03:21
20241019105805	2026-04-07 06:03:22
20241030150047	2026-04-07 06:03:24
20241108114728	2026-04-07 06:03:25
20241121104152	2026-04-07 06:03:26
20241130184212	2026-04-07 06:03:27
20241220035512	2026-04-07 06:03:27
20241220123912	2026-04-07 06:03:28
20241224161212	2026-04-07 06:03:29
20250107150512	2026-04-07 06:03:29
20250110162412	2026-04-07 06:03:30
20250123174212	2026-04-07 06:03:31
20250128220012	2026-04-07 06:03:31
20250506224012	2026-04-07 06:03:32
20250523164012	2026-04-07 06:03:32
20250714121412	2026-04-07 06:03:33
20250905041441	2026-04-07 06:03:34
20251103001201	2026-04-07 06:03:34
20251120212548	2026-04-07 06:03:35
20251120215549	2026-04-07 06:03:36
20260218120000	2026-04-07 06:03:36
20260326120000	2026-04-10 05:56:07
20260514120000	2026-08-01 09:55:13
20260527120000	2026-08-01 09:55:15
20260528120000	2026-08-01 09:55:16
20260603120000	2026-08-01 09:55:16
20260605120000	2026-08-01 09:55:17
20260606110000	2026-08-01 09:55:18
20260616120000	2026-08-01 09:55:20
20260624120000	2026-08-01 09:55:22
20260626120000	2026-08-01 09:55:24
20260706120000	2026-08-01 09:55:25
20260707120000	2026-08-01 09:55:29
20260709120000	2026-08-01 09:55:30
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- Data for Name: disposal_certificates; Type: TABLE DATA; Schema: reverse_logistics; Owner: postgres
--

COPY reverse_logistics.disposal_certificates (certificate_id, assessment_id, witness_user_id, disposal_method, evidence_hash, disposed_at_utc) FROM stdin;
1	2	1a09efe6-50a8-4d80-bb67-1280baa33e15	Chemical_Neutralization	sha256:abcd1234efgh5678ijkl9012mnop	2026-04-14 17:18:34.41604+00
\.


--
-- Data for Name: global_recall_ledger; Type: TABLE DATA; Schema: reverse_logistics; Owner: postgres
--

COPY reverse_logistics.global_recall_ledger (recall_id, batch_id, initiated_by_org_id, recall_reason, quarantine_status, created_at_utc) FROM stdin;
1	15	96a73ed7-bc75-48de-abb6-b1eab134fb26	Class II: Sub-standard dissolution rate detected in post-market surveillance.	Active	2026-04-14 15:22:22.430575+00
\.


--
-- Data for Name: recall_communication_logs; Type: TABLE DATA; Schema: reverse_logistics; Owner: postgres
--

COPY reverse_logistics.recall_communication_logs (log_id, recall_id, notified_org_id, channel, delivery_status, sent_at_utc) FROM stdin;
1	1	f8e303d0-608f-48ef-832f-02c848a68232	System_Alert	Read	2026-04-14 15:22:22.430575+00
2	1	f8e303d0-608f-48ef-832f-02c848a68232	Email	Delivered	2026-04-14 17:23:25.486222+00
3	1	f8e303d0-608f-48ef-832f-02c848a68232	Registered_Post	Pending	2026-04-14 17:23:25.486222+00
4	1	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	System_Alert	Read	2026-04-14 17:23:25.486222+00
5	1	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	SMS	Failed	2026-04-14 17:23:25.486222+00
6	1	fe445ae8-ed1f-43b2-b52f-8a1e678f5590	Email	Delivered	2026-04-14 17:23:25.486222+00
7	1	423437e5-bbea-4f4a-a49f-3a1ae478f89c	System_Alert	Read	2026-04-14 17:23:25.486222+00
8	1	7082bff8-9fdd-4ae3-a017-6a131fa714ae	Email	Pending	2026-04-14 17:23:25.486222+00
9	1	0b9979ed-8caa-4d22-82be-b997e2509252	System_Alert	Read	2026-04-12 03:07:19.494417+00
10	1	423437e5-bbea-4f4a-a49f-3a1ae478f89c	System_Alert	Read	2026-04-12 03:07:19.494417+00
11	1	7082bff8-9fdd-4ae3-a017-6a131fa714ae	System_Alert	Delivered	2026-04-12 03:07:19.494417+00
12	1	a761feff-9ccb-4d9f-9265-cc3e925a80ca	System_Alert	Read	2026-04-12 03:07:19.494417+00
13	1	0b9979ed-8caa-4d22-82be-b997e2509252	Email	Read	2026-04-12 04:07:19.494417+00
14	1	423437e5-bbea-4f4a-a49f-3a1ae478f89c	SMS	Delivered	2026-04-12 04:07:19.494417+00
15	1	7082bff8-9fdd-4ae3-a017-6a131fa714ae	Email	Failed	2026-04-12 04:07:19.494417+00
16	1	7082bff8-9fdd-4ae3-a017-6a131fa714ae	SMS	Delivered	2026-04-12 05:07:19.494417+00
17	1	0b9979ed-8caa-4d22-82be-b997e2509252	Registered_Post	Delivered	2026-04-14 03:07:19.494417+00
18	1	423437e5-bbea-4f4a-a49f-3a1ae478f89c	Registered_Post	Pending	2026-04-14 03:07:19.494417+00
19	1	7082bff8-9fdd-4ae3-a017-6a131fa714ae	Registered_Post	Delivered	2026-04-14 03:07:19.494417+00
\.


--
-- Data for Name: refund_vouchers; Type: TABLE DATA; Schema: reverse_logistics; Owner: postgres
--

COPY reverse_logistics.refund_vouchers (voucher_id, return_id, refund_amount, refund_status, issued_at_utc) FROM stdin;
1	1	25000.00	Processed	2026-04-14 15:22:22.430575+00
2	2	37500.00	Processed	2026-04-14 15:22:22.430575+00
3	3	4000.00	Pending_Payout	2026-04-14 15:22:22.430575+00
\.


--
-- Data for Name: return_requests; Type: TABLE DATA; Schema: reverse_logistics; Owner: postgres
--

COPY reverse_logistics.return_requests (return_id, returner_org_id, batch_id, recall_id, quantity_returned, return_reason, status, created_at_utc) FROM stdin;
1	f8e303d0-608f-48ef-832f-02c848a68232	15	1	500	Recalled	Closed	2026-04-14 15:22:22.430575+00
2	f8e303d0-608f-48ef-832f-02c848a68232	13	\N	75	Damaged in Transit	Closed	2026-04-14 15:22:22.430575+00
3	f8e303d0-608f-48ef-832f-02c848a68232	4	\N	200	Overstock / Order Error	Assessed	2026-04-14 15:22:22.430575+00
14	0b9979ed-8caa-4d22-82be-b997e2509252	15	1	1500	Mandatory Recall - Governance Ledger Initiated	In_Transit	2026-04-15 02:57:32.567506+00
15	423437e5-bbea-4f4a-a49f-3a1ae478f89c	15	1	450	Mandatory Recall - Governance Ledger Initiated	Initiated	2026-04-17 02:57:32.567506+00
16	7082bff8-9fdd-4ae3-a017-6a131fa714ae	15	1	12000	Mandatory Recall - Governance Ledger Initiated	Assessed	2026-04-12 02:57:32.567506+00
17	a761feff-9ccb-4d9f-9265-cc3e925a80ca	15	1	300	Mandatory Recall - Governance Ledger Initiated	Closed	2026-04-07 02:57:32.567506+00
18	0b9979ed-8caa-4d22-82be-b997e2509252	1	\N	50	Expired Shelf Life	Closed	2026-03-17 02:57:32.567506+00
19	423437e5-bbea-4f4a-a49f-3a1ae478f89c	2	\N	120	Expired Shelf Life	Received	2026-04-14 02:57:32.567506+00
20	bc0c8e9a-c0d7-4376-a920-85edd59bb545	3	\N	15	Temperature Excursion During Transit	Assessed	2026-04-16 02:57:32.567506+00
21	f8e303d0-608f-48ef-832f-02c848a68232	4	\N	300	Damaged Packaging / Broken Seals	In_Transit	2026-04-16 22:57:32.567506+00
\.


--
-- Data for Name: return_stock_assessments; Type: TABLE DATA; Schema: reverse_logistics; Owner: postgres
--

COPY reverse_logistics.return_stock_assessments (assessment_id, return_id, inspector_user_id, inspection_result, disposition_action, assessed_at_utc) FROM stdin;
1	1	1a09efe6-50a8-4d80-bb67-1280baa33e15	Confirmed match with recall directive.	Approve_Refund_and_Destroy	2026-04-14 15:22:22.430575+00
2	2	1a09efe6-50a8-4d80-bb67-1280baa33e15	Severe water damage to outer and inner packaging. Unsafe for patient use.	Approve_Refund_and_Destroy	2026-04-14 15:22:22.430575+00
3	3	1a09efe6-50a8-4d80-bb67-1280baa33e15	Seals unbroken, temperature log verified. Safe for redistribution.	Approve_Refund_and_Restock	2026-04-14 15:22:22.430575+00
\.


--
-- Data for Name: environmental_sensor_logs; Type: TABLE DATA; Schema: smart_warehousing; Owner: postgres
--

COPY smart_warehousing.environmental_sensor_logs (log_id, location_id, temperature_celsius, humidity_percentage, recorded_at) FROM stdin;
2	5	4.5	45	2026-04-14 12:18:04.03926+00
3	5	6	50	2026-04-14 12:22:47.874237+00
4	6	6	50	2026-04-14 12:23:50.469121+00
5	7	22.5	45	2026-04-14 12:35:14.016427+00
6	8	4	50	2026-04-14 12:35:14.016427+00
7	9	-20	30	2026-04-14 12:35:14.016427+00
8	10	21	42	2026-04-14 12:35:14.016427+00
9	12	23.5	40	2026-04-14 12:35:14.016427+00
10	13	5.5	48	2026-04-14 12:35:14.016427+00
11	14	24	44	2026-04-14 12:35:14.016427+00
12	15	3.5	50	2026-04-14 12:35:14.016427+00
13	11	4.5	50	2026-04-14 12:35:14.016427+00
14	11	6	52	2026-04-14 12:35:14.016427+00
15	11	12.5	55	2026-04-14 12:35:14.016427+00
16	12	28.5	45	2026-04-14 12:41:50.923981+00
17	9	-10	35	2026-04-14 12:41:50.923981+00
18	15	-2.5	50	2026-04-14 12:41:50.923981+00
19	10	9.5	60	2026-04-14 12:41:50.923981+00
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: smart_warehousing; Owner: postgres
--

COPY smart_warehousing.inventory (inventory_id, location_id, batch_id, available_quantity, last_verified_by, last_update) FROM stdin;
2	6	3	200	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 11:54:32.636476+00
1	5	1	400	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:01:21.9397+00
3	6	1	100	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:01:21.9397+00
6	8	7	2000	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
7	9	8	500	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
9	11	10	1000	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
11	13	12	800	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
13	15	14	400	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
5	7	6	4850	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
14	8	6	150	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:35:02.086712+00
8	10	9	2900	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:41:39.950911+00
15	11	9	100	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:41:39.950911+00
10	12	11	2450	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:41:39.950911+00
16	13	11	50	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:41:39.950911+00
12	14	13	1300	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:41:39.950911+00
17	15	13	200	03bf32d6-485e-497b-8888-ceacee875b65	2026-04-14 12:41:39.950911+00
\.


--
-- Data for Name: quarantine_area_logs; Type: TABLE DATA; Schema: smart_warehousing; Owner: postgres
--

COPY smart_warehousing.quarantine_area_logs (quarantine_id, batch_id, location_id, quarantine_reason, breaching_log_id, action_taken_by, status) FROM stdin;
2	1	5	Temp Breach	2	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	Active
3	1	5	Temp Breach	3	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	Active
4	10	11	Temp Breach	15	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	Active
5	11	12	Temp Breach	16	1a09efe6-50a8-4d80-bb67-1280baa33e15	Active
7	14	15	Temp Breach	18	2b609790-c885-4a9a-9978-442b92e9534d	Active
8	13	15	Temp Breach	18	2b609790-c885-4a9a-9978-442b92e9534d	Active
9	9	10	Temp Breach	19	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	Cleared
6	8	9	Temp Breach	17	0b56a543-c19d-43ef-b948-bab7ee9b84ef	Destroyed
\.


--
-- Data for Name: stock_movement_history; Type: TABLE DATA; Schema: smart_warehousing; Owner: postgres
--

COPY smart_warehousing.stock_movement_history (movement_id, batch_id, source_location_id, destination_location_id, user_id, quantity_moved, movement_type, moved_at) FROM stdin;
2	1	\N	5	03bf32d6-485e-497b-8888-ceacee875b65	500	Inbound	2026-04-14 11:54:32.636476+00
3	3	\N	6	03bf32d6-485e-497b-8888-ceacee875b65	200	Inbound	2026-04-14 11:54:32.636476+00
4	1	5	6	03bf32d6-485e-497b-8888-ceacee875b65	50	Internal	2026-04-14 11:58:54.475651+00
5	1	5	6	03bf32d6-485e-497b-8888-ceacee875b65	50	Internal	2026-04-14 12:01:21.9397+00
6	6	\N	7	03bf32d6-485e-497b-8888-ceacee875b65	5000	Inbound	2026-04-14 12:35:02.086712+00
7	7	\N	8	03bf32d6-485e-497b-8888-ceacee875b65	2000	Inbound	2026-04-14 12:35:02.086712+00
8	8	\N	9	03bf32d6-485e-497b-8888-ceacee875b65	500	Inbound	2026-04-14 12:35:02.086712+00
9	9	\N	10	03bf32d6-485e-497b-8888-ceacee875b65	3000	Inbound	2026-04-14 12:35:02.086712+00
10	10	\N	11	03bf32d6-485e-497b-8888-ceacee875b65	1000	Inbound	2026-04-14 12:35:02.086712+00
11	11	\N	12	03bf32d6-485e-497b-8888-ceacee875b65	2500	Inbound	2026-04-14 12:35:02.086712+00
12	12	\N	13	03bf32d6-485e-497b-8888-ceacee875b65	800	Inbound	2026-04-14 12:35:02.086712+00
13	13	\N	14	03bf32d6-485e-497b-8888-ceacee875b65	1500	Inbound	2026-04-14 12:35:02.086712+00
14	14	\N	15	03bf32d6-485e-497b-8888-ceacee875b65	400	Inbound	2026-04-14 12:35:02.086712+00
15	6	7	8	03bf32d6-485e-497b-8888-ceacee875b65	150	Internal	2026-04-14 12:35:02.086712+00
16	9	10	11	03bf32d6-485e-497b-8888-ceacee875b65	100	Internal	2026-04-14 12:41:39.950911+00
17	11	12	13	03bf32d6-485e-497b-8888-ceacee875b65	50	Internal	2026-04-14 12:41:39.950911+00
18	13	14	15	03bf32d6-485e-497b-8888-ceacee875b65	200	Internal	2026-04-14 12:41:39.950911+00
\.


--
-- Data for Name: storage_location; Type: TABLE DATA; Schema: smart_warehousing; Owner: postgres
--

COPY smart_warehousing.storage_location (location_id, warehouse_id, zone_type, target_min_temp, target_max_temp, max_capacity, is_active, target_humidity_limit) FROM stdin;
5	3	General	15.00	25.00	5000	t	60.00
6	3	Cold Storage	2.00	8.00	1000	t	60.00
7	4	General	15.00	25.00	15000	t	60.00
8	4	Cold Storage	2.00	8.00	5000	t	60.00
10	5	General	15.00	25.00	8000	t	60.00
11	5	Cold Storage	2.00	8.00	2000	t	60.00
12	6	General	15.00	25.00	6000	t	60.00
13	6	Cold Storage	2.00	8.00	1500	t	60.00
14	7	General	15.00	25.00	4000	t	60.00
15	7	Cold Storage	2.00	8.00	800	t	60.00
9	4	Cold Storage	-25.00	-15.00	1000	f	60.00
\.


--
-- Data for Name: warehouse; Type: TABLE DATA; Schema: smart_warehousing; Owner: postgres
--

COPY smart_warehousing.warehouse (warehouse_id, warehouse_name, city, state, manager_user_id, is_active) FROM stdin;
3	MP Central Hub	Bhopal	MP	0576c6a8-7b63-4ab9-8199-41c4ca8d6dfe	t
4	Indore Distribution Center	Indore	MP	0b56a543-c19d-43ef-b948-bab7ee9b84ef	t
5	Jabalpur Transit Facility	Jabalpur	MP	a5e2e6af-eaa3-473c-8ea0-b9e851b3ca46	t
6	Ujjain Medical Depot	Ujjain	MP	1a09efe6-50a8-4d80-bb67-1280baa33e15	t
7	Rewa Regional Hub	Rewa	MP	2b609790-c885-4a9a-9978-442b92e9534d	t
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-04-07 03:53:14.080188
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-04-07 03:53:14.114983
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-04-07 03:53:14.118502
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-04-07 03:53:14.146221
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-04-07 03:53:14.157697
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-04-07 03:53:14.161562
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-04-07 03:53:14.166179
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-04-07 03:53:14.170802
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-04-07 03:53:14.174776
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-04-07 03:53:14.178893
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-04-07 03:53:14.183107
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-04-07 03:53:14.187536
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-04-07 03:53:14.191767
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-04-07 03:53:14.195719
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-04-07 03:53:14.199757
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-04-07 03:53:14.225106
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-04-07 03:53:14.229185
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-04-07 03:53:14.233141
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-04-07 03:53:14.236942
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-04-07 03:53:14.242226
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-04-07 03:53:14.246212
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-04-07 03:53:14.252489
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-04-07 03:53:14.266351
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-04-07 03:53:14.275128
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-04-07 03:53:14.279514
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-04-07 03:53:14.289873
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-04-07 03:53:14.29474
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-04-07 03:53:14.299338
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-04-07 03:53:14.302638
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-04-07 03:53:14.306522
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-04-07 03:53:14.310338
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-04-07 03:53:14.31389
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-04-07 03:53:14.317342
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-04-07 03:53:14.320894
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-04-07 03:53:14.324484
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-04-07 03:53:14.328514
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-04-07 03:53:14.332104
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-04-07 03:53:14.335589
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-04-07 03:53:14.340108
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-04-07 03:53:14.351825
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-04-07 03:53:14.355276
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-04-07 03:53:14.358719
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-04-07 03:53:14.362256
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-04-07 03:53:14.366035
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-04-07 03:53:14.369794
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-04-07 03:53:14.376092
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-04-07 03:53:14.393667
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-04-07 03:53:14.398208
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-04-07 03:53:14.401991
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-04-07 03:53:14.417722
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-04-07 03:53:14.421962
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-04-07 03:53:14.992195
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-04-07 03:53:14.994156
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-04-07 03:53:15.00464
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-04-07 03:53:15.007316
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-04-07 03:53:15.009097
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-07 03:53:15.01946
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-07 03:53:15.023393
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-04-07 03:53:15.014002
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-08-01 09:55:04.54028
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-08-01 09:55:04.550834
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: delivery_proof_receipt_receipt_id_seq; Type: SEQUENCE SET; Schema: forward_fulfillment; Owner: postgres
--

SELECT pg_catalog.setval('forward_fulfillment.delivery_proof_receipt_receipt_id_seq', 8, true);


--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: forward_fulfillment; Owner: postgres
--

SELECT pg_catalog.setval('forward_fulfillment.order_items_order_item_id_seq', 10, true);


--
-- Name: sales_orders_order_id_seq; Type: SEQUENCE SET; Schema: forward_fulfillment; Owner: postgres
--

SELECT pg_catalog.setval('forward_fulfillment.sales_orders_order_id_seq', 10, true);


--
-- Name: shipping_manifest_manifest_id_seq; Type: SEQUENCE SET; Schema: forward_fulfillment; Owner: postgres
--

SELECT pg_catalog.setval('forward_fulfillment.shipping_manifest_manifest_id_seq', 4, true);


--
-- Name: vehicle_fleet_registry_vehicle_id_seq; Type: SEQUENCE SET; Schema: forward_fulfillment; Owner: postgres
--

SELECT pg_catalog.setval('forward_fulfillment.vehicle_fleet_registry_vehicle_id_seq', 8, true);


--
-- Name: batch_master_batch_id_seq; Type: SEQUENCE SET; Schema: product_and_batch_intelligence; Owner: postgres
--

SELECT pg_catalog.setval('product_and_batch_intelligence.batch_master_batch_id_seq', 18, true);


--
-- Name: chemical_compositions_composition_id_seq; Type: SEQUENCE SET; Schema: product_and_batch_intelligence; Owner: postgres
--

SELECT pg_catalog.setval('product_and_batch_intelligence.chemical_compositions_composition_id_seq', 12, true);


--
-- Name: medicines_medicine_id_seq; Type: SEQUENCE SET; Schema: product_and_batch_intelligence; Owner: postgres
--

SELECT pg_catalog.setval('product_and_batch_intelligence.medicines_medicine_id_seq', 12, true);


--
-- Name: packaging_standards_packaging_id_seq; Type: SEQUENCE SET; Schema: product_and_batch_intelligence; Owner: postgres
--

SELECT pg_catalog.setval('product_and_batch_intelligence.packaging_standards_packaging_id_seq', 12, true);


--
-- Name: quality_check_specs_spec_id_seq; Type: SEQUENCE SET; Schema: product_and_batch_intelligence; Owner: postgres
--

SELECT pg_catalog.setval('product_and_batch_intelligence.quality_check_specs_spec_id_seq', 12, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_realtime_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: disposal_certificates_certificate_id_seq; Type: SEQUENCE SET; Schema: reverse_logistics; Owner: postgres
--

SELECT pg_catalog.setval('reverse_logistics.disposal_certificates_certificate_id_seq', 5, true);


--
-- Name: global_recall_ledger_recall_id_seq; Type: SEQUENCE SET; Schema: reverse_logistics; Owner: postgres
--

SELECT pg_catalog.setval('reverse_logistics.global_recall_ledger_recall_id_seq', 1, true);


--
-- Name: recall_communication_logs_log_id_seq; Type: SEQUENCE SET; Schema: reverse_logistics; Owner: postgres
--

SELECT pg_catalog.setval('reverse_logistics.recall_communication_logs_log_id_seq', 19, true);


--
-- Name: refund_vouchers_voucher_id_seq; Type: SEQUENCE SET; Schema: reverse_logistics; Owner: postgres
--

SELECT pg_catalog.setval('reverse_logistics.refund_vouchers_voucher_id_seq', 3, true);


--
-- Name: return_requests_return_id_seq; Type: SEQUENCE SET; Schema: reverse_logistics; Owner: postgres
--

SELECT pg_catalog.setval('reverse_logistics.return_requests_return_id_seq', 21, true);


--
-- Name: return_stock_assessments_assessment_id_seq; Type: SEQUENCE SET; Schema: reverse_logistics; Owner: postgres
--

SELECT pg_catalog.setval('reverse_logistics.return_stock_assessments_assessment_id_seq', 3, true);


--
-- Name: environmental_sensor_logs_log_id_seq; Type: SEQUENCE SET; Schema: smart_warehousing; Owner: postgres
--

SELECT pg_catalog.setval('smart_warehousing.environmental_sensor_logs_log_id_seq', 19, true);


--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: smart_warehousing; Owner: postgres
--

SELECT pg_catalog.setval('smart_warehousing.inventory_inventory_id_seq', 17, true);


--
-- Name: quarantine_area_logs_quarantine_id_seq; Type: SEQUENCE SET; Schema: smart_warehousing; Owner: postgres
--

SELECT pg_catalog.setval('smart_warehousing.quarantine_area_logs_quarantine_id_seq', 9, true);


--
-- Name: stock_movement_history_movement_id_seq; Type: SEQUENCE SET; Schema: smart_warehousing; Owner: postgres
--

SELECT pg_catalog.setval('smart_warehousing.stock_movement_history_movement_id_seq', 18, true);


--
-- Name: storage_location_location_id_seq; Type: SEQUENCE SET; Schema: smart_warehousing; Owner: postgres
--

SELECT pg_catalog.setval('smart_warehousing.storage_location_location_id_seq', 15, true);


--
-- Name: warehouse_warehouse_id_seq; Type: SEQUENCE SET; Schema: smart_warehousing; Owner: postgres
--

SELECT pg_catalog.setval('smart_warehousing.warehouse_warehouse_id_seq', 7, true);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: financial_aggregate financial_aggregate_pkey; Type: CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.financial_aggregate
    ADD CONSTRAINT financial_aggregate_pkey PRIMARY KEY (report_id);


--
-- Name: loss_analytics_data loss_analytics_data_pkey; Type: CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.loss_analytics_data
    ADD CONSTRAINT loss_analytics_data_pkey PRIMARY KEY (loss_record_id);


--
-- Name: payment_ledger payment_ledger_pkey; Type: CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.payment_ledger
    ADD CONSTRAINT payment_ledger_pkey PRIMARY KEY (payment_id);


--
-- Name: delivery_proof_receipt delivery_proof_receipt_pkey; Type: CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.delivery_proof_receipt
    ADD CONSTRAINT delivery_proof_receipt_pkey PRIMARY KEY (receipt_id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- Name: sales_orders sales_orders_pkey; Type: CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.sales_orders
    ADD CONSTRAINT sales_orders_pkey PRIMARY KEY (order_id);


--
-- Name: shipping_manifest shipping_manifest_pkey; Type: CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.shipping_manifest
    ADD CONSTRAINT shipping_manifest_pkey PRIMARY KEY (manifest_id);


--
-- Name: vehicle_fleet_registry vehicle_fleet_registry_pkey; Type: CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.vehicle_fleet_registry
    ADD CONSTRAINT vehicle_fleet_registry_pkey PRIMARY KEY (vehicle_id);


--
-- Name: vehicle_fleet_registry vehicle_fleet_registry_vehicle_no_key; Type: CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.vehicle_fleet_registry
    ADD CONSTRAINT vehicle_fleet_registry_vehicle_no_key UNIQUE (vehicle_no);


--
-- Name: auth_audit_logs auth_audit_logs_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.auth_audit_logs
    ADD CONSTRAINT auth_audit_logs_pkey PRIMARY KEY (log_id);


--
-- Name: organisations organisations_contact_email_key; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.organisations
    ADD CONSTRAINT organisations_contact_email_key UNIQUE (contact_email);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (org_id);


--
-- Name: organisations organisations_reg_no_key; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.organisations
    ADD CONSTRAINT organisations_reg_no_key UNIQUE (reg_no);


--
-- Name: permissions permissions_action_name_key; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.permissions
    ADD CONSTRAINT permissions_action_name_key UNIQUE (action_name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: batch_master batch_master_batch_number_key; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.batch_master
    ADD CONSTRAINT batch_master_batch_number_key UNIQUE (batch_number);


--
-- Name: batch_master batch_master_pkey; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.batch_master
    ADD CONSTRAINT batch_master_pkey PRIMARY KEY (batch_id);


--
-- Name: chemical_compositions chemical_compositions_pkey; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.chemical_compositions
    ADD CONSTRAINT chemical_compositions_pkey PRIMARY KEY (composition_id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (medicine_id);


--
-- Name: packaging_standards packaging_standards_pkey; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.packaging_standards
    ADD CONSTRAINT packaging_standards_pkey PRIMARY KEY (packaging_id);


--
-- Name: quality_check_specs quality_check_specs_pkey; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.quality_check_specs
    ADD CONSTRAINT quality_check_specs_pkey PRIMARY KEY (spec_id);


--
-- Name: medicines uq_brand_name; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.medicines
    ADD CONSTRAINT uq_brand_name UNIQUE (brand_name);


--
-- Name: chemical_compositions uq_medicine_composition; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.chemical_compositions
    ADD CONSTRAINT uq_medicine_composition UNIQUE (medicine_id);


--
-- Name: packaging_standards uq_medicine_packaging; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.packaging_standards
    ADD CONSTRAINT uq_medicine_packaging UNIQUE (medicine_id);


--
-- Name: quality_check_specs uq_medicine_spec; Type: CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.quality_check_specs
    ADD CONSTRAINT uq_medicine_spec UNIQUE (medicine_id);


--
-- Name: financial_aggregate financial_aggregate_org_id_report_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_aggregate
    ADD CONSTRAINT financial_aggregate_org_id_report_date_key UNIQUE (org_id, report_date);


--
-- Name: financial_aggregate financial_aggregate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_aggregate
    ADD CONSTRAINT financial_aggregate_pkey PRIMARY KEY (report_id);


--
-- Name: payment_ledger payment_ledger_order_id_payer_org_id_payee_org_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_ledger
    ADD CONSTRAINT payment_ledger_order_id_payer_org_id_payee_org_id_key UNIQUE (order_id, payer_org_id, payee_org_id);


--
-- Name: payment_ledger payment_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_ledger
    ADD CONSTRAINT payment_ledger_pkey PRIMARY KEY (payment_id);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: disposal_certificates disposal_certificates_assessment_id_key; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.disposal_certificates
    ADD CONSTRAINT disposal_certificates_assessment_id_key UNIQUE (assessment_id);


--
-- Name: disposal_certificates disposal_certificates_pkey; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.disposal_certificates
    ADD CONSTRAINT disposal_certificates_pkey PRIMARY KEY (certificate_id);


--
-- Name: global_recall_ledger global_recall_ledger_pkey; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.global_recall_ledger
    ADD CONSTRAINT global_recall_ledger_pkey PRIMARY KEY (recall_id);


--
-- Name: recall_communication_logs recall_communication_logs_pkey; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.recall_communication_logs
    ADD CONSTRAINT recall_communication_logs_pkey PRIMARY KEY (log_id);


--
-- Name: refund_vouchers refund_vouchers_pkey; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.refund_vouchers
    ADD CONSTRAINT refund_vouchers_pkey PRIMARY KEY (voucher_id);


--
-- Name: return_requests return_requests_pkey; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_requests
    ADD CONSTRAINT return_requests_pkey PRIMARY KEY (return_id);


--
-- Name: return_stock_assessments return_stock_assessments_pkey; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_stock_assessments
    ADD CONSTRAINT return_stock_assessments_pkey PRIMARY KEY (assessment_id);


--
-- Name: return_stock_assessments return_stock_assessments_return_id_key; Type: CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_stock_assessments
    ADD CONSTRAINT return_stock_assessments_return_id_key UNIQUE (return_id);


--
-- Name: environmental_sensor_logs env_logs_pkey; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.environmental_sensor_logs
    ADD CONSTRAINT env_logs_pkey PRIMARY KEY (log_id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: quarantine_area_logs quarantine_pkey; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.quarantine_area_logs
    ADD CONSTRAINT quarantine_pkey PRIMARY KEY (quarantine_id);


--
-- Name: stock_movement_history stock_movement_history_pkey; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.stock_movement_history
    ADD CONSTRAINT stock_movement_history_pkey PRIMARY KEY (movement_id);


--
-- Name: storage_location storage_location_pkey; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.storage_location
    ADD CONSTRAINT storage_location_pkey PRIMARY KEY (location_id);


--
-- Name: inventory uq_inventory_location_batch; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.inventory
    ADD CONSTRAINT uq_inventory_location_batch UNIQUE (location_id, batch_id);


--
-- Name: warehouse warehouse_pkey; Type: CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (warehouse_id);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: delivery_proof_receipt tr_auto_generate_invoice; Type: TRIGGER; Schema: forward_fulfillment; Owner: postgres
--

CREATE TRIGGER tr_auto_generate_invoice AFTER INSERT ON forward_fulfillment.delivery_proof_receipt FOR EACH ROW EXECUTE FUNCTION financial_analytics.fn_auto_generate_invoice();


--
-- Name: delivery_proof_receipt tr_auto_status_delivered; Type: TRIGGER; Schema: forward_fulfillment; Owner: postgres
--

CREATE TRIGGER tr_auto_status_delivered AFTER INSERT ON forward_fulfillment.delivery_proof_receipt FOR EACH ROW EXECUTE FUNCTION forward_fulfillment.fn_auto_status_delivered();


--
-- Name: shipping_manifest tr_auto_status_shipped; Type: TRIGGER; Schema: forward_fulfillment; Owner: postgres
--

CREATE TRIGGER tr_auto_status_shipped AFTER INSERT ON forward_fulfillment.shipping_manifest FOR EACH ROW EXECUTE FUNCTION forward_fulfillment.fn_auto_status_shipped();


--
-- Name: order_items tr_gatekeep_order_items; Type: TRIGGER; Schema: forward_fulfillment; Owner: postgres
--

CREATE TRIGGER tr_gatekeep_order_items BEFORE INSERT ON forward_fulfillment.order_items FOR EACH ROW EXECUTE FUNCTION forward_fulfillment.fn_gatekeep_order_items();


--
-- Name: user_sessions tr_after_session_started; Type: TRIGGER; Schema: identity_mod; Owner: postgres
--

CREATE TRIGGER tr_after_session_started AFTER INSERT ON identity_mod.user_sessions FOR EACH ROW EXECUTE FUNCTION identity_mod.fn_log_session_start();


--
-- Name: users tr_after_user_created; Type: TRIGGER; Schema: identity_mod; Owner: postgres
--

CREATE TRIGGER tr_after_user_created AFTER INSERT ON identity_mod.users FOR EACH ROW EXECUTE FUNCTION identity_mod.fn_log_user_registration();


--
-- Name: auth_audit_logs tr_protect_audit_logs; Type: TRIGGER; Schema: identity_mod; Owner: postgres
--

CREATE TRIGGER tr_protect_audit_logs BEFORE DELETE OR UPDATE ON identity_mod.auth_audit_logs FOR EACH ROW EXECUTE FUNCTION identity_mod.fn_make_logs_immutable();


--
-- Name: batch_master tr_audit_batch_activity; Type: TRIGGER; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TRIGGER tr_audit_batch_activity AFTER INSERT OR UPDATE ON product_and_batch_intelligence.batch_master FOR EACH ROW EXECUTE FUNCTION product_and_batch_intelligence.fn_audit_batch_activity();


--
-- Name: quality_check_specs tr_audit_spec_tampering; Type: TRIGGER; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TRIGGER tr_audit_spec_tampering AFTER UPDATE ON product_and_batch_intelligence.quality_check_specs FOR EACH ROW EXECUTE FUNCTION product_and_batch_intelligence.fn_audit_spec_tampering();


--
-- Name: batch_master tr_enforce_batch_workflow; Type: TRIGGER; Schema: product_and_batch_intelligence; Owner: postgres
--

CREATE TRIGGER tr_enforce_batch_workflow BEFORE UPDATE OF status ON product_and_batch_intelligence.batch_master FOR EACH ROW EXECUTE FUNCTION product_and_batch_intelligence.fn_enforce_batch_workflow();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: disposal_certificates tr_audit_disposal; Type: TRIGGER; Schema: reverse_logistics; Owner: postgres
--

CREATE TRIGGER tr_audit_disposal AFTER INSERT ON reverse_logistics.disposal_certificates FOR EACH ROW EXECUTE FUNCTION reverse_logistics.fn_audit_disposal();


--
-- Name: global_recall_ledger tr_audit_global_recall; Type: TRIGGER; Schema: reverse_logistics; Owner: postgres
--

CREATE TRIGGER tr_audit_global_recall AFTER INSERT ON reverse_logistics.global_recall_ledger FOR EACH ROW EXECUTE FUNCTION reverse_logistics.fn_audit_global_recall();


--
-- Name: disposal_certificates tr_log_disposal_loss; Type: TRIGGER; Schema: reverse_logistics; Owner: postgres
--

CREATE TRIGGER tr_log_disposal_loss AFTER INSERT ON reverse_logistics.disposal_certificates FOR EACH ROW EXECUTE FUNCTION financial_analytics.fn_log_disposal_loss();


--
-- Name: environmental_sensor_logs tr_monitor_temperature_breach; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_monitor_temperature_breach AFTER INSERT ON smart_warehousing.environmental_sensor_logs FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_monitor_temperature_breach();


--
-- Name: storage_location tr_prevent_active_location_shutdown; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_prevent_active_location_shutdown BEFORE UPDATE ON smart_warehousing.storage_location FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_prevent_active_location_shutdown();


--
-- Name: warehouse tr_prevent_active_warehouse_shutdown; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_prevent_active_warehouse_shutdown BEFORE UPDATE ON smart_warehousing.warehouse FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_prevent_active_warehouse_shutdown();


--
-- Name: inventory tr_prevent_env_mismatch; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_prevent_env_mismatch BEFORE INSERT OR UPDATE ON smart_warehousing.inventory FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_prevent_env_mismatch();


--
-- Name: inventory tr_prevent_stock_on_dead_shelf; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_prevent_stock_on_dead_shelf BEFORE INSERT OR UPDATE ON smart_warehousing.inventory FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_prevent_stock_on_dead_shelf();


--
-- Name: storage_location tr_prevent_storage_in_dead_warehouse; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_prevent_storage_in_dead_warehouse BEFORE INSERT OR UPDATE ON smart_warehousing.storage_location FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_prevent_storage_in_dead_warehouse();


--
-- Name: stock_movement_history tr_sync_inventory_on_movement; Type: TRIGGER; Schema: smart_warehousing; Owner: postgres
--

CREATE TRIGGER tr_sync_inventory_on_movement AFTER INSERT ON smart_warehousing.stock_movement_history FOR EACH ROW EXECUTE FUNCTION smart_warehousing.fn_sync_inventory_on_movement();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: financial_aggregate financial_aggregate_generated_by_user_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.financial_aggregate
    ADD CONSTRAINT financial_aggregate_generated_by_user_id_fkey FOREIGN KEY (generated_by_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: financial_aggregate financial_aggregate_org_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.financial_aggregate
    ADD CONSTRAINT financial_aggregate_org_id_fkey FOREIGN KEY (org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: loss_analytics_data loss_analytics_data_batch_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.loss_analytics_data
    ADD CONSTRAINT loss_analytics_data_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id);


--
-- Name: loss_analytics_data loss_analytics_data_org_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.loss_analytics_data
    ADD CONSTRAINT loss_analytics_data_org_id_fkey FOREIGN KEY (org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: loss_analytics_data loss_analytics_data_recall_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.loss_analytics_data
    ADD CONSTRAINT loss_analytics_data_recall_id_fkey FOREIGN KEY (recall_id) REFERENCES reverse_logistics.global_recall_ledger(recall_id);


--
-- Name: payment_ledger payment_ledger_order_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.payment_ledger
    ADD CONSTRAINT payment_ledger_order_id_fkey FOREIGN KEY (order_id) REFERENCES forward_fulfillment.sales_orders(order_id);


--
-- Name: payment_ledger payment_ledger_payee_org_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.payment_ledger
    ADD CONSTRAINT payment_ledger_payee_org_id_fkey FOREIGN KEY (payee_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: payment_ledger payment_ledger_payer_org_id_fkey; Type: FK CONSTRAINT; Schema: financial_analytics; Owner: postgres
--

ALTER TABLE ONLY financial_analytics.payment_ledger
    ADD CONSTRAINT payment_ledger_payer_org_id_fkey FOREIGN KEY (payer_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: delivery_proof_receipt delivery_proof_receipt_order_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.delivery_proof_receipt
    ADD CONSTRAINT delivery_proof_receipt_order_id_fkey FOREIGN KEY (order_id) REFERENCES forward_fulfillment.sales_orders(order_id);


--
-- Name: delivery_proof_receipt delivery_proof_receipt_received_by_user_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.delivery_proof_receipt
    ADD CONSTRAINT delivery_proof_receipt_received_by_user_id_fkey FOREIGN KEY (received_by_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: order_items order_items_batch_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.order_items
    ADD CONSTRAINT order_items_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES forward_fulfillment.sales_orders(order_id) ON DELETE CASCADE;


--
-- Name: sales_orders sales_orders_buyer_org_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.sales_orders
    ADD CONSTRAINT sales_orders_buyer_org_id_fkey FOREIGN KEY (buyer_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: shipping_manifest shipping_manifest_driver_user_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.shipping_manifest
    ADD CONSTRAINT shipping_manifest_driver_user_id_fkey FOREIGN KEY (driver_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: shipping_manifest shipping_manifest_order_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.shipping_manifest
    ADD CONSTRAINT shipping_manifest_order_id_fkey FOREIGN KEY (order_id) REFERENCES forward_fulfillment.sales_orders(order_id);


--
-- Name: shipping_manifest shipping_manifest_vehicle_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.shipping_manifest
    ADD CONSTRAINT shipping_manifest_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES forward_fulfillment.vehicle_fleet_registry(vehicle_id);


--
-- Name: vehicle_fleet_registry vehicle_fleet_registry_transporter_org_id_fkey; Type: FK CONSTRAINT; Schema: forward_fulfillment; Owner: postgres
--

ALTER TABLE ONLY forward_fulfillment.vehicle_fleet_registry
    ADD CONSTRAINT vehicle_fleet_registry_transporter_org_id_fkey FOREIGN KEY (transporter_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: auth_audit_logs auth_audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.auth_audit_logs
    ADD CONSTRAINT auth_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES identity_mod.permissions(permission_id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES identity_mod.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES identity_mod.users(user_id) ON DELETE CASCADE;


--
-- Name: users users_org_id_fkey; Type: FK CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.users
    ADD CONSTRAINT users_org_id_fkey FOREIGN KEY (org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: identity_mod; Owner: postgres
--

ALTER TABLE ONLY identity_mod.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES identity_mod.roles(role_id);


--
-- Name: batch_master batch_master_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.batch_master
    ADD CONSTRAINT batch_master_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: batch_master batch_master_medicine_id_fkey; Type: FK CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.batch_master
    ADD CONSTRAINT batch_master_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES product_and_batch_intelligence.medicines(medicine_id) ON DELETE RESTRICT;


--
-- Name: batch_master batch_master_registered_by_user_id_fkey; Type: FK CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.batch_master
    ADD CONSTRAINT batch_master_registered_by_user_id_fkey FOREIGN KEY (registered_by_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: chemical_compositions chemical_compositions_medicine_id_fkey; Type: FK CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.chemical_compositions
    ADD CONSTRAINT chemical_compositions_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES product_and_batch_intelligence.medicines(medicine_id) ON DELETE CASCADE;


--
-- Name: packaging_standards packaging_standards_medicine_id_fkey; Type: FK CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.packaging_standards
    ADD CONSTRAINT packaging_standards_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES product_and_batch_intelligence.medicines(medicine_id) ON DELETE CASCADE;


--
-- Name: quality_check_specs quality_check_specs_medicine_id_fkey; Type: FK CONSTRAINT; Schema: product_and_batch_intelligence; Owner: postgres
--

ALTER TABLE ONLY product_and_batch_intelligence.quality_check_specs
    ADD CONSTRAINT quality_check_specs_medicine_id_fkey FOREIGN KEY (medicine_id) REFERENCES product_and_batch_intelligence.medicines(medicine_id) ON DELETE CASCADE;


--
-- Name: disposal_certificates disposal_certificates_assessment_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.disposal_certificates
    ADD CONSTRAINT disposal_certificates_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES reverse_logistics.return_stock_assessments(assessment_id);


--
-- Name: disposal_certificates disposal_certificates_witness_user_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.disposal_certificates
    ADD CONSTRAINT disposal_certificates_witness_user_id_fkey FOREIGN KEY (witness_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: global_recall_ledger global_recall_ledger_batch_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.global_recall_ledger
    ADD CONSTRAINT global_recall_ledger_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id) ON DELETE RESTRICT;


--
-- Name: global_recall_ledger global_recall_ledger_initiated_by_org_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.global_recall_ledger
    ADD CONSTRAINT global_recall_ledger_initiated_by_org_id_fkey FOREIGN KEY (initiated_by_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: recall_communication_logs recall_communication_logs_notified_org_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.recall_communication_logs
    ADD CONSTRAINT recall_communication_logs_notified_org_id_fkey FOREIGN KEY (notified_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: recall_communication_logs recall_communication_logs_recall_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.recall_communication_logs
    ADD CONSTRAINT recall_communication_logs_recall_id_fkey FOREIGN KEY (recall_id) REFERENCES reverse_logistics.global_recall_ledger(recall_id) ON DELETE CASCADE;


--
-- Name: refund_vouchers refund_vouchers_return_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.refund_vouchers
    ADD CONSTRAINT refund_vouchers_return_id_fkey FOREIGN KEY (return_id) REFERENCES reverse_logistics.return_requests(return_id);


--
-- Name: return_requests return_requests_batch_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_requests
    ADD CONSTRAINT return_requests_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id);


--
-- Name: return_requests return_requests_recall_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_requests
    ADD CONSTRAINT return_requests_recall_id_fkey FOREIGN KEY (recall_id) REFERENCES reverse_logistics.global_recall_ledger(recall_id);


--
-- Name: return_requests return_requests_returner_org_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_requests
    ADD CONSTRAINT return_requests_returner_org_id_fkey FOREIGN KEY (returner_org_id) REFERENCES identity_mod.organisations(org_id);


--
-- Name: return_stock_assessments return_stock_assessments_inspector_user_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_stock_assessments
    ADD CONSTRAINT return_stock_assessments_inspector_user_id_fkey FOREIGN KEY (inspector_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: return_stock_assessments return_stock_assessments_return_id_fkey; Type: FK CONSTRAINT; Schema: reverse_logistics; Owner: postgres
--

ALTER TABLE ONLY reverse_logistics.return_stock_assessments
    ADD CONSTRAINT return_stock_assessments_return_id_fkey FOREIGN KEY (return_id) REFERENCES reverse_logistics.return_requests(return_id);


--
-- Name: environmental_sensor_logs env_logs_location_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.environmental_sensor_logs
    ADD CONSTRAINT env_logs_location_fkey FOREIGN KEY (location_id) REFERENCES smart_warehousing.storage_location(location_id);


--
-- Name: inventory inventory_batch_id_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.inventory
    ADD CONSTRAINT inventory_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id);


--
-- Name: inventory inventory_location_id_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.inventory
    ADD CONSTRAINT inventory_location_id_fkey FOREIGN KEY (location_id) REFERENCES smart_warehousing.storage_location(location_id);


--
-- Name: inventory inventory_user_id_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.inventory
    ADD CONSTRAINT inventory_user_id_fkey FOREIGN KEY (last_verified_by) REFERENCES identity_mod.users(user_id);


--
-- Name: quarantine_area_logs quarantine_batch_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.quarantine_area_logs
    ADD CONSTRAINT quarantine_batch_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id);


--
-- Name: quarantine_area_logs quarantine_breach_log_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.quarantine_area_logs
    ADD CONSTRAINT quarantine_breach_log_fkey FOREIGN KEY (breaching_log_id) REFERENCES smart_warehousing.environmental_sensor_logs(log_id);


--
-- Name: quarantine_area_logs quarantine_location_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.quarantine_area_logs
    ADD CONSTRAINT quarantine_location_fkey FOREIGN KEY (location_id) REFERENCES smart_warehousing.storage_location(location_id);


--
-- Name: quarantine_area_logs quarantine_user_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.quarantine_area_logs
    ADD CONSTRAINT quarantine_user_fkey FOREIGN KEY (action_taken_by) REFERENCES identity_mod.users(user_id);


--
-- Name: stock_movement_history smh_batch_id_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.stock_movement_history
    ADD CONSTRAINT smh_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES product_and_batch_intelligence.batch_master(batch_id);


--
-- Name: stock_movement_history smh_destination_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.stock_movement_history
    ADD CONSTRAINT smh_destination_fkey FOREIGN KEY (destination_location_id) REFERENCES smart_warehousing.storage_location(location_id);


--
-- Name: stock_movement_history smh_source_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.stock_movement_history
    ADD CONSTRAINT smh_source_fkey FOREIGN KEY (source_location_id) REFERENCES smart_warehousing.storage_location(location_id);


--
-- Name: stock_movement_history smh_user_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.stock_movement_history
    ADD CONSTRAINT smh_user_fkey FOREIGN KEY (user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: storage_location storage_location_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.storage_location
    ADD CONSTRAINT storage_location_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES smart_warehousing.warehouse(warehouse_id) ON DELETE CASCADE;


--
-- Name: warehouse warehouse_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: smart_warehousing; Owner: postgres
--

ALTER TABLE ONLY smart_warehousing.warehouse
    ADD CONSTRAINT warehouse_manager_user_id_fkey FOREIGN KEY (manager_user_id) REFERENCES identity_mod.users(user_id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO service_role;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE financial_aggregate; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.financial_aggregate TO anon;
GRANT ALL ON TABLE public.financial_aggregate TO authenticated;
GRANT ALL ON TABLE public.financial_aggregate TO service_role;


--
-- Name: TABLE payment_ledger; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payment_ledger TO anon;
GRANT ALL ON TABLE public.payment_ledger TO authenticated;
GRANT ALL ON TABLE public.payment_ledger TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict pGtoyANkhY4BcPUY8FBOeD98vabA1KBdMmadyws2hCW2KwLz5VBt67jWCaEJ9oP

