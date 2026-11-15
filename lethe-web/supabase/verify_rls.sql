-- ============================================================================
-- Lethe Logistics: see RLS at work (read-only)
-- ----------------------------------------------------------------------------
-- Run in Supabase Dashboard -> SQL Editor AFTER rls.sql. It impersonates each
-- demo login the same way the Data API does (role "authenticated" + the user's
-- JWT claims) and counts the rows of every table that login can see.
-- It only runs SELECT count(*), so nothing is changed.
--
-- "total" is the real row count; "refused" means the database denies access.
-- Change the e-mails below if your demo accounts differ.
-- ============================================================================

CREATE OR REPLACE FUNCTION pg_temp.lethe_visible_rows(p_people jsonb)
RETURNS TABLE (relation text, persona text, visible text)
LANGUAGE plpgsql
AS $$
DECLARE
  rels text[];
  who text;
  uid text;
  rel text;
  n bigint;
BEGIN
  SELECT array_agg(format('%I.%I', ns.nspname, c.relname) ORDER BY ns.nspname, c.relname)
  INTO rels
  FROM pg_class c
  JOIN pg_namespace ns ON ns.oid = c.relnamespace
  WHERE c.relkind IN ('r', 'v')
    AND ns.nspname IN ('identity_mod', 'product_and_batch_intelligence', 'smart_warehousing',
                       'forward_fulfillment', 'reverse_logistics', 'financial_analytics');

  FOR who, uid IN SELECT key, value FROM jsonb_each_text(p_people) LOOP
    IF who = 'signed_out' THEN
      PERFORM set_config('request.jwt.claims', '{"role":"anon"}', true);
      SET LOCAL ROLE anon;
    ELSIF who = 'total' THEN
      -- stay the table owner (RLS does not apply); the SysAdmin's claims only let
      -- vw_location_load, which answers signed-in users only, report its rows
      PERFORM set_config('request.jwt.claims', coalesce(json_build_object('sub', uid)::text, ''), true);
    ELSE
      PERFORM set_config('request.jwt.claims', json_build_object('sub', uid, 'role', 'authenticated')::text, true);
      SET LOCAL ROLE authenticated;
    END IF;

    FOREACH rel IN ARRAY rels LOOP
      relation := rel;
      persona := who;
      IF uid IS NULL AND who NOT IN ('total', 'signed_out') THEN
        visible := 'no such login';
      ELSE
        BEGIN
          EXECUTE format('SELECT count(*) FROM %s', rel) INTO n;
          visible := n::text;
        EXCEPTION WHEN insufficient_privilege THEN
          visible := 'refused';
        END;
      END IF;
      RETURN NEXT;
    END LOOP;

    RESET ROLE;
  END LOOP;
  PERFORM set_config('request.jwt.claims', '', true);
END;
$$;

SELECT relation AS "table",
       max(visible) FILTER (WHERE persona = 'total')        AS total,
       max(visible) FILTER (WHERE persona = 'manufacturer') AS manufacturer,
       max(visible) FILTER (WHERE persona = 'distributor')  AS distributor,
       max(visible) FILTER (WHERE persona = 'retailer')     AS retailer,
       max(visible) FILTER (WHERE persona = 'compliance')   AS compliance,
       max(visible) FILTER (WHERE persona = 'sysadmin')     AS sysadmin,
       max(visible) FILTER (WHERE persona = 'signed_out')   AS signed_out
FROM pg_temp.lethe_visible_rows(jsonb_build_object(
       'total',        (SELECT id::text FROM auth.users WHERE email = 'sysadmin@lethe.com'),
       'manufacturer', (SELECT id::text FROM auth.users WHERE email = 'adminsys@gmail.com'),
       'distributor',  (SELECT id::text FROM auth.users WHERE email = 'distributor@lethe.com'),
       'retailer',     (SELECT id::text FROM auth.users WHERE email = 'retailer@lethe.com'),
       'compliance',   (SELECT id::text FROM auth.users WHERE email = 'compliance@lethe.com'),
       'sysadmin',     (SELECT id::text FROM auth.users WHERE email = 'sysadmin@lethe.com'),
       'signed_out',   'n/a'))
GROUP BY relation
ORDER BY relation;
