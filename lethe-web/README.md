# Lethe Logistics: React frontend

A role-based React rebuild of the **Lethe Logistics / Pharmachain** closed-loop pharmaceutical supply-chain platform (MCA DBMS project, MANIT Bhopal). It replaces the earlier Streamlit app and talks directly to the existing **Supabase (PostgreSQL)** backend. No backend changes are required.

Every login lands in **its own portal** with its own tabs, colour and permissions:

| Portal | Demo account | Organisation | What it can do |
|---|---|---|---|
| 🏢 **Manufacturer** | `adminsys@gmail.com` | Avant-Garde LifeSciences | Register batches, run QC (Pending → Quality-Check → Released / Rejected) with a spec checklist, manage the medicine catalog, **initiate network-wide recalls**, inspect returns, issue refunds and **disposal certificates**, batch pedigree, revenue & **batch-level profitability**, generate monthly reports (stored procedure) |
| 🚚 **Distributor** | `distributor@lethe.com` | MP Central Drug Depot | Warehouse/zone/bin inventory, receive / transfer / remove stock, **live cold-chain monitor** (log a sensor reading → automatic quarantine), quarantine register, approve & **dispatch orders** (Reefer enforced for cold-chain lines, pick list from inventory), fleet, inbound returns, facilities |
| 🏬 **Retailer** | `retailer@lethe.com` | Bhopal City Care Pharmacy | Place purchase orders by medicine with **FEFO batch allocation**, sign for deliveries (SHA-256 digital signature), report damage, file returns, track refunds, acknowledge recall notices |
| ⚖️ **Compliance** | `compliance@lethe.com` | Federal Compliance Office | **Read-only**: risk heatmap, immutable audit-ledger explorer (filters, JSON payloads, CSV export, **live tamper test**), cold-chain violations, recall effectiveness, disposal certificates, financial exposure, batch trace |
| 🛡️ **SysAdmin** | `sysadmin@lethe.com` | Lethe Master Hub | System health (API latency, row counts across all schemas, trigger catalogue), onboard/suspend organisations, provision users, change roles, **RBAC permission matrix**, sessions & identity events |

Passwords are the team's demo passwords (they are deliberately not stored in this repo).

**Routing rule:** role `Admin` → SysAdmin portal; otherwise the organisation type decides (Manufacturer / Distributor / Retailer / Regulatory_Body). Opening another portal's URL shows an *access denied* screen. Deactivated users and suspended organisations are blocked at sign-in.

**Database-enforced:** Postgres Row Level Security ([`supabase/rls.sql`](supabase/rls.sql), live since 15 Nov 2026) enforces the same separation, so it holds even for someone calling the API directly (see [Row Level Security](#row-level-security)).

---

## Run it

Requirements: **Node.js 20+** (tested on Node 24).

```bash
cd lethe-web
npm install
npm run dev
```

Open http://localhost:5173 and sign in with one of the accounts above.

The Supabase URL and **publishable** key live in `.env.local` (already filled in). For a fresh clone, copy `.env.example` to `.env.local` and fill it in.

| Script | What it does |
|---|---|
| `npm run dev` | Dev server with hot reload |
| `npm run build` | Type-check + production build into `dist/` |
| `npm run preview` | Serve the production build locally |
| `npm run typecheck` | TypeScript only |

### Deploying
`npm run build` produces a static site in `dist/`. On Vercel or Netlify, set `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` as environment variables. SPA routing is already configured (`vercel.json`, `public/_redirects`).

---

## How it works

```
Browser (React 19 + Vite + TypeScript + Tailwind 4)
   │  supabase-js
   ├── Supabase Auth ── email/password sign-in
   └── Data API (PostgREST) ── supabase.schema('<schema>').from('<table>')
          identity_mod · product_and_batch_intelligence · smart_warehousing
          forward_fulfillment · reverse_logistics · financial_analytics
```

* **Auth**: Supabase Auth signs the user in; the app then loads `identity_mod.users` (+ `roles`, `organisations`) for that auth id and resolves the portal. Each sign-in inserts a row into `identity_mod.user_sessions`, which makes the database trigger write `USER_LOGIN_SUCCESS` to the audit ledger; sign-out stamps `log_out_time_utc`.
* **Business rules stay in the database.** The UI pre-validates (e.g. only offers storage zones whose temperature band fits the medicine), but the ~20 triggers remain the source of truth. When a trigger refuses something (`SAFETY LOCK…`, `Governance Violation…`) the app shows it as a *"blocked by a database rule"* toast with the trigger's own message. Row Level Security refusals show as *"Blocked by row-level security"*, and an update that changed nothing (RLS filtered it, or the record had moved on) reports *"Nothing was changed"* instead of a false success.
* **Audit trail**: triggers already log batches, recalls, disposals, sessions and users. For actions without a trigger (orders, dispatches, stock moves, RBAC changes, quarantine decisions…) the app appends an event to `identity_mod.auth_audit_logs` with a severity, so the Compliance portal sees everything.
* **Data layer**: TanStack Query caches each table (`src/data/tables.ts` is the registry), refreshes every 60 s and after every write. Cross-schema joins are done client-side because PostgREST cannot embed across schemas.
* **Charts** follow one validated colour system (Recharts), with light and dark themes.

```
src/
  auth/            AuthProvider (Supabase session → identity profile → portal)
  components/
    ui/            Button, Card, DataTable, Modal/Drawer, Form, Badge, Stepper, Timeline…
    charts/        Column, bar list, trend, band (temperature), heatmap, sparkline
    domain/        BatchPedigree (chain of custody), TraceWorkbench, cells
    layout/        AppShell (sidebar + top bar), PageHeader, ErrorBoundary
  data/            tables registry, query hooks, audit queries, actions (writes + audit), pricing
  lib/             supabase client, types (all 34 tables), domain rules, formatting, errors
  pages/           Login, access-denied / no-portal / not-found
  portals/
    manufacturer/  overview, batches, catalog, recalls, returns, trace, revenue
    distributor/   overview, inventory, cold chain, fulfillment, fleet, returns, facilities
    retailer/      overview, orders, receiving, returns, recall notices
    compliance/    risk overview, audit ledger, cold chain, recalls, financial
    admin/         system health, organisations, users, access control, sessions
```

### Developer preview (optional, dev only)
Create `lethe-web/.env.development.local` with `VITE_DEV_PREVIEW=true` and restart `npm run dev`. The sign-in page then shows a picker to render any portal as a seeded identity **without signing in**. All writes are disabled in this mode and it never exists in `npm run build`. Delete the file to turn it off. It reads as a signed-out visitor, so it only works on a database **without** RLS. RLS is on in the live project, so there the picker stays empty; sign in for real.

---

## Database notes (please read)

1. **Leaked service key: revoked.** `Scripts/provision_users.py` and `Scripts/test_service_key.py` contained the Supabase **service_role** key. On 15 Nov 2026 the legacy JWT-based keys were switched off and the legacy JWT secret revoked, so that key no longer works. Anything still using the legacy `anon` or `service_role` keys (those scripts, the old Streamlit app) no longer connects; give scripts a new secret key from a local `.env`, never from git.
2. **Row Level Security** is on in the live project (applied 15 Nov 2026 with [`supabase/rls.sql`](supabase/rls.sql), see [below](#row-level-security)). Signed-out requests are refused, and each portal reads and changes only its own slice.
3. **Trigger fixes** in [`supabase/fixes.sql`](supabase/fixes.sql), applied to the live project on 15 Nov 2026 (safe to re-run, before or after `rls.sql`). They fix these bugs in the original triggers:
   * `fn_audit_spec_tampering` inserts into columns that don't exist, so editing a medicine's purity/pH fails (the app keeps specs read-only for this reason).
   * `check_user_permission` joins `role_permission` (singular) and errors when called.
   * `fn_monitor_temperature_breach` aborts the whole sensor insert if the shelf holds a recalled/rejected batch.
   * **Dispatch was blocked for most stock.** `fn_prevent_env_mismatch` also ran when stock *left* a shelf, and 14 of the 16 inventory rows sit on shelves whose temperature or humidity band doesn't match the medicine, so dispatching or moving them failed with *SAFETY LOCK: … Mismatch* (for example batch 6, the 5,000 vaccines). The fix always allows taking stock off a shelf and keeps every check for stock being added.
4. **Humidity data.** Every storage zone has a 60 % humidity limit, while several medicines (insulin 45 %, others 40–55 %) need less, so no zone can *receive* new stock of them. Add a zone with a lower humidity limit (Distributor → Facilities) before demoing an inbound delivery of those.
5. **Legacy data.** Orders #11–#38 were created by the old Streamlit app without order lines, and several were set to *Shipped* directly. The new UI shows them honestly (*No lines*, *Overdue*). New orders always get lines and go through the database's sale gate. Recalls #2 and #3 were started by the SysAdmin's organisation on Avant-Garde batches; with RLS the batch's maker can still manage them.
6. **Prices.** The schema has no price-list table. Unit prices come from historical order lines; medicines never sold use the category list prices in `src/data/pricing.ts`.

---

## Row Level Security

[`supabase/rls.sql`](supabase/rls.sql) makes Postgres itself decide which rows each signed-in user can read and change.

**Status:** applied to the live project on 15 Nov 2026. `verify_rls.sql` there gives the same counts as the local tests, cell for cell.
**Apply (again, or on another project):** Supabase Dashboard → SQL Editor → paste `rls.sql` → Run. It is one transaction (all or nothing), safe to run again, and ends by listing every table with its policy count.
**Check:** run [`supabase/verify_rls.sql`](supabase/verify_rls.sql): a read-only table of how many rows each demo login (and a signed-out visitor) can see per table.
**Undo:** [`supabase/rls_rollback.sql`](supabase/rls_rollback.sql) puts the database back in its open state.

| Portal | Reads | Can change |
|---|---|---|
| Everyone signed in | Shared reference data: organisations, roles, user directory (never password hashes), medicines and specs, the batch registry, warehouses, zones, sensor readings, vehicles, recalls | Their own session and audit entries in their own name |
| Manufacturer | Plus orders, order lines, shipments, stock, movements, quarantines, returns, refunds, losses **for its own batches**; its own payments and reports | Catalog; its own batches (new ones start *Pending*); recalls and notices for its batches; inspections, refunds, disposals and restocks of returns of its batches; its own monthly report |
| Distributor | Plus all warehousing, orders, shipments, returns and inspections | Zones, sensor readings, stock movements, quarantine decisions, vehicles; approves/cancels open orders, dispatches, flags delays (never marks an order *Delivered*); moves returns in transit |
| Retailer | Plus its own orders, lines, shipments, receipts, invoices, returns, refunds, recall notices; stock of sellable batches | Places, cancels and signs for **its own** orders (only *Shipped* ones); files returns for stock it received or that is under recall; acknowledges its notices |
| Compliance | Everything | Nothing |
| SysAdmin | Everything | Organisations, users, roles and permissions only |

Also enforced: nobody signed out can read anything; deactivated users and suspended organisations lose access (they can still read their own profile, so the app explains why); inventory changes only through stock movements; payments and losses are written only by triggers; the audit ledger accepts appends in your own name and no changes, even if its trigger were dropped.

How it works: helper functions in a private `lethe_rls` schema (not exposed through the API) work out the caller's portal and organisation from `auth.uid()`. Each table has one policy per action, written as a `CASE` on the portal. Trigger functions run as their owner (`SECURITY DEFINER`), so automation such as invoices, quarantine and stock sync keeps working for every role. **If you edit a trigger function later, re-run `rls.sql`.**

Limits of the data model: orders and warehouses have no seller/owner column, so all distributors share them; medicines have no owner, so any manufacturer curates the catalog. Add an owner column and tighten the policy if you add more distributors. The old Streamlit app (publishable key, no sign-in) can no longer read the data now that RLS is on.

**How it was tested:** on a throwaway local PostgreSQL 18 loaded with your schema and a read-only copy of the live data (nothing was written to the live project): a read matrix for every role, 140 write checks shaped like the API's requests (every allowed flow end to end, plus the forbidden ones), the `fixes.sql` interplay in both orders, re-running, and the rollback. Then both scripts were applied to the live project, where `verify_rls.sql` matched and signed-out API calls are refused.
