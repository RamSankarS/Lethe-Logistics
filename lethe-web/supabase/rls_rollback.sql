-- ============================================================================
-- Lethe Logistics: undo supabase/rls.sql
-- ----------------------------------------------------------------------------
-- Emergency switch back to the OPEN state the database was in before RLS:
-- every table readable and writable by anyone holding the publishable key.
-- Use it only if something breaks right before a demo, then fix and re-run
-- rls.sql. Runs in one transaction; safe to run more than once.
-- ============================================================================

BEGIN;

-- Policies off, RLS off.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT schemaname, tablename, policyname
    FROM pg_policies
    WHERE schemaname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                         'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
  LOOP
    EXECUTE format('DROP POLICY %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
  END LOOP;

  FOR r IN
    SELECT n.nspname, c.relname
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relkind IN ('r', 'p')
      AND (n.nspname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                         'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
           OR (n.nspname = 'public' AND c.relname IN ('financial_aggregate', 'payment_ledger')))
  LOOP
    EXECUTE format('ALTER TABLE %I.%I DISABLE ROW LEVEL SECURITY', r.nspname, r.relname);
  END LOOP;
END $$;

-- Views back to their original behaviour; the capacity view goes away
-- (the app falls back to adding up inventory rows itself).
ALTER VIEW financial_analytics.vw_cold_chain_violations SET (security_invoker = false);
ALTER VIEW financial_analytics.vw_compliance_risk_heatmap SET (security_invoker = false);
ALTER VIEW financial_analytics.vw_cost_of_non_compliance SET (security_invoker = false);
DROP VIEW IF EXISTS smart_warehousing.vw_location_load;

-- Trigger functions back to running as the caller.
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
    EXECUTE format('ALTER FUNCTION %s SECURITY INVOKER RESET search_path', f);
  END LOOP;
END $$;

-- The original open grants.
DO $$
DECLARE s text;
BEGIN
  FOREACH s IN ARRAY ARRAY['identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                           'forward_fulfillment', 'reverse_logistics', 'financial_analytics'] LOOP
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO anon, authenticated, service_role', s);
    EXECUTE format('GRANT ALL ON ALL TABLES IN SCHEMA %I TO anon, authenticated, service_role', s);
    EXECUTE format('GRANT ALL ON ALL SEQUENCES IN SCHEMA %I TO anon, authenticated, service_role', s);
    EXECUTE format('GRANT ALL ON ALL ROUTINES IN SCHEMA %I TO anon, authenticated, service_role', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I GRANT ALL ON TABLES TO anon, authenticated, service_role', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I GRANT ALL ON SEQUENCES TO anon, authenticated, service_role', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I GRANT ALL ON FUNCTIONS TO anon, authenticated, service_role', s);
  END LOOP;
END $$;
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['financial_aggregate', 'payment_ledger'] LOOP
    IF to_regclass(format('public.%I', t)) IS NOT NULL THEN
      EXECUTE format('GRANT ALL ON public.%I TO anon, authenticated, service_role', t);
    END IF;
  END LOOP;
END $$;

DROP SCHEMA IF EXISTS lethe_rls CASCADE;

COMMIT;

SELECT n.nspname AS schema, c.relname AS table_name, c.relrowsecurity AS rls_enabled
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r', 'p')
  AND n.nspname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                    'forward_fulfillment', 'reverse_logistics', 'financial_analytics')
ORDER BY 1, 2;
