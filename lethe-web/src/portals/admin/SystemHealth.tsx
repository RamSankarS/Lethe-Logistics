import { useMemo } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Activity, Building2, Cpu, Database, KeyRound, ScrollText, ShieldCheck, Timer, Users, Zap } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { useAuditAll } from '@/data/audit'
import { useTables } from '@/data/hooks'
import { TABLES, type TableKey } from '@/data/tables'
import { db, supabase, SCHEMAS, type SchemaKey } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { TrendChart, SERIES } from '@/components/charts/Charts'
import { Badge, Code } from '@/components/ui/Badge'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Meter } from '@/components/ui/Progress'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { num, shortDate } from '@/lib/format'

const TRIGGERS: { name: string; table: string; when: string; does: string }[] = [
  { name: 'tr_after_user_created', table: 'identity_mod.users', when: 'AFTER INSERT', does: 'Logs USER_IDENTITY_CREATED to the ledger' },
  { name: 'tr_after_session_started', table: 'identity_mod.user_sessions', when: 'AFTER INSERT', does: 'Logs USER_LOGIN_SUCCESS on every sign-in' },
  { name: 'tr_protect_audit_logs', table: 'identity_mod.auth_audit_logs', when: 'BEFORE UPDATE/DELETE', does: 'Rejects any change: write-once ledger' },
  { name: 'tr_audit_batch_activity', table: 'product.batch_master', when: 'AFTER INSERT/UPDATE', does: 'Logs batch creation and status changes with severity' },
  { name: 'tr_enforce_batch_workflow', table: 'product.batch_master', when: 'BEFORE UPDATE (status)', does: 'Blocks skipping QC and reviving rejected/recalled batches' },
  { name: 'tr_audit_spec_tampering', table: 'product.quality_check_specs', when: 'AFTER UPDATE', does: 'Flags purity / pH changes as spec tampering' },
  { name: 'tr_monitor_temperature_breach', table: 'warehouse.environmental_sensor_logs', when: 'AFTER INSERT', does: 'Quarantines shelf stock and sends it back to QC' },
  { name: 'tr_prevent_env_mismatch', table: 'warehouse.inventory', when: 'BEFORE INSERT/UPDATE', does: 'Shelf temperature and humidity must suit the medicine' },
  { name: 'tr_prevent_stock_on_dead_shelf', table: 'warehouse.inventory', when: 'BEFORE INSERT/UPDATE', does: 'No stock on inactive locations' },
  { name: 'tr_prevent_storage_in_dead_warehouse', table: 'warehouse.storage_location', when: 'BEFORE INSERT/UPDATE', does: 'No locations inside inactive warehouses' },
  { name: 'tr_prevent_active_location_shutdown', table: 'warehouse.storage_location', when: 'BEFORE UPDATE', does: 'Cannot deactivate a location holding stock' },
  { name: 'tr_prevent_active_warehouse_shutdown', table: 'warehouse.warehouse', when: 'BEFORE UPDATE', does: 'Cannot shut a warehouse with active locations' },
  { name: 'tr_sync_inventory_on_movement', table: 'warehouse.stock_movement_history', when: 'AFTER INSERT', does: 'Keeps inventory in sync with every movement' },
  { name: 'tr_gatekeep_order_items', table: 'fulfillment.order_items', when: 'BEFORE INSERT', does: 'Only released batches with enough stock can be sold' },
  { name: 'tr_auto_status_shipped', table: 'fulfillment.shipping_manifest', when: 'AFTER INSERT', does: 'Flips the order to Shipped' },
  { name: 'tr_auto_status_delivered', table: 'fulfillment.delivery_proof_receipt', when: 'AFTER INSERT', does: 'Flips the order to Delivered' },
  { name: 'tr_auto_generate_invoice', table: 'fulfillment.delivery_proof_receipt', when: 'AFTER INSERT', does: 'Writes the invoice (base + 5% GST) to the payment ledger' },
  { name: 'tr_audit_global_recall', table: 'reverse.global_recall_ledger', when: 'AFTER INSERT', does: 'Logs GLOBAL_RECALL_INITIATED (critical)' },
  { name: 'tr_audit_disposal', table: 'reverse.disposal_certificates', when: 'AFTER INSERT', does: 'Logs DRUGS_DESTROYED (high)' },
  { name: 'tr_log_disposal_loss', table: 'reverse.disposal_certificates', when: 'AFTER INSERT', does: 'Books the destroyed stock as a financial loss' },
]

const SCHEMA_LABEL: Record<SchemaKey, string> = {
  identity: 'Identity & access',
  product: 'Product & batch intelligence',
  warehouse: 'Smart warehousing',
  fulfillment: 'Forward fulfillment',
  reverse: 'Reverse logistics',
  finance: 'Financial analytics',
}

function useLatency() {
  return useQuery({
    queryKey: ['health', 'latency'],
    refetchInterval: 15_000,
    queryFn: async () => {
      const samples: number[] = []
      for (let i = 0; i < 3; i++) {
        const t0 = performance.now()
        const { error } = await db('identity').from('roles').select('role_id', { count: 'exact', head: true })
        if (error) throw error
        samples.push(performance.now() - t0)
      }
      const { data } = await supabase.auth.getSession()
      return { ms: Math.round(samples.reduce((a, b) => a + b, 0) / samples.length), best: Math.round(Math.min(...samples)), auth: Boolean(data.session) }
    },
  })
}

function useRowCounts() {
  return useQuery({
    queryKey: ['health', 'row-counts'],
    staleTime: 60_000,
    queryFn: async () => {
      const keys = Object.keys(TABLES) as TableKey[]
      // Count via a named column: with RLS on, users.password_hash is not readable,
      // so `select *` on that table is refused.
      const targets: { key: string; schema: SchemaKey; table: string; column: string }[] = [
        ...keys.map((k) => {
          const def: { schema: string; table: string; select?: string } = TABLES[k]
          return { key: k, schema: def.schema as SchemaKey, table: def.table, column: def.select?.split(',')[0] ?? '*' }
        }),
        { key: 'audit', schema: 'identity', table: 'auth_audit_logs', column: 'log_id' },
      ]
      return Promise.all(
        targets.map(async (x) => {
          const { count, error } = await db(x.schema).from(x.table).select(x.column, { count: 'exact', head: true })
          // A HEAD request for a missing view (vw_location_load before rls.sql) comes back
          // without an error but also without a count, so no count means "unknown".
          return { ...x, count: error || count == null ? null : count }
        }),
      )
    },
  })
}

export function SystemHealth() {
  const profile = useProfile()
  const latency = useLatency()
  const counts = useRowCounts()
  const audit = useAuditAll()
  const t = useTables(['users', 'organisations', 'sessions'] as const)

  const logins = useMemo(() => {
    const byDay = new Map<string, number>()
    for (const l of audit.data ?? []) {
      if (l.action_type !== 'USER_LOGIN_SUCCESS') continue
      const d = l.log_time_stamp_utc.slice(0, 10)
      byDay.set(d, (byDay.get(d) ?? 0) + 1)
    }
    return [...byDay.entries()].sort(([a], [b]) => a.localeCompare(b)).map(([day, n]) => ({ day, logins: n }))
  }, [audit.data])

  const grouped = useMemo(() => {
    const out = new Map<SchemaKey, { table: string; count: number | null }[]>()
    for (const r of counts.data ?? []) out.set(r.schema, [...(out.get(r.schema) ?? []), { table: r.table, count: r.count }])
    return out
  }, [counts.data])
  const maxCount = Math.max(1, ...(counts.data ?? []).map((r) => r.count ?? 0))
  const totalRows = (counts.data ?? []).reduce((s, r) => s + (r.count ?? 0), 0)
  const activeSessions = t.data.sessions.filter((s) => !s.log_out_time_utc).length
  const ms = latency.data?.ms

  return (
    <>
      <PageHeader title={`Platform health · ${profile.org?.org_name}`} description="Live checks against the Supabase Data API and Auth service" />
      <StatGrid>
        <Stat label="API latency" value={ms != null ? `${ms} ms` : '…'} sub={latency.data ? `best ${latency.data.best} ms · refreshes every 15s` : 'measuring'} icon={Timer} tone={ms == null ? 'neutral' : ms < 400 ? 'good' : ms < 1000 ? 'warn' : 'critical'} loading={latency.isLoading} />
        <Stat label="Auth service" value={latency.data ? (latency.data.auth ? 'Online' : 'No session') : '…'} sub="Supabase GoTrue session check" icon={KeyRound} tone={latency.data?.auth ? 'good' : 'warn'} loading={latency.isLoading} />
        <Stat label="Identities" value={num(t.data.users.length)} sub={`${t.data.users.filter((u) => u.is_active).length} active`} icon={Users} loading={t.isLoading} />
        <Stat label="Organisations" value={num(t.data.organisations.length)} sub={`${t.data.organisations.filter((o) => o.is_active).length} active`} icon={Building2} loading={t.isLoading} />
        <Stat label="Open sessions" value={num(activeSessions)} sub={`${t.data.sessions.length} sessions recorded`} icon={Activity} tone="info" loading={t.isLoading} />
        <Stat label="Ledger events" value={num(audit.data?.length ?? 0)} sub="immutable audit rows" icon={ScrollText} tone="accent" loading={audit.isLoading} />
      </StatGrid>

      <div className="admin-health-grid grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Data volume by schema" subtitle={`${num(totalRows)} rows across ${counts.data?.length ?? 0} tables and views`} icon={Database} />
          <CardBody className="grid gap-5 md:grid-cols-2">
            {(Object.keys(SCHEMAS) as SchemaKey[]).map((s) => (
              <div key={s}>
                <p className="admin-schema-title">
                  {SCHEMA_LABEL[s]} <span className="admin-schema-name">· {SCHEMAS[s]}</span>
                </p>
                <div className="admin-count-list">
                  {(grouped.get(s) ?? []).map((r) => (
                    <div key={r.table} className="admin-count-row">
                      <span className="admin-table-name">{r.table}</span>
                      <span className="admin-count-num">{r.count == null ? 'n/a' : num(r.count)}</span>
                      <Meter className="admin-count-meter" value={r.count ?? 0} max={maxCount} tone="info" />
                    </div>
                  ))}
                  {counts.isLoading && <p className="admin-small-grey">Counting…</p>}
                </div>
              </div>
            ))}
          </CardBody>
        </Card>
        <div className="admin-side-col xl:col-span-2">
          <Card>
            <CardHeader title="Sign-ins per day" subtitle="USER_LOGIN_SUCCESS events from the ledger" />
            <CardBody>
              <TrendChart data={logins} x="day" xFormat={(v) => shortDate(v)} series={[{ key: 'logins', label: 'Sign-ins', color: SERIES[0] }]} height={200} />
            </CardBody>
          </Card>
          <Card>
            <CardHeader title="Stack" icon={Cpu} />
            <CardBody className="admin-stack-body">
              {[
                ['Frontend', 'React 19 · Vite · TypeScript · Tailwind CSS'],
                ['Data access', 'supabase-js → PostgREST (6 exposed schemas)'],
                ['Database', 'PostgreSQL 17 on Supabase'],
                ['Auth', 'Supabase Auth, mapped to identity_mod.users'],
                ['Governance', '20 triggers, 3 analytic views, 1 stored procedure'],
              ].map(([k, v]) => (
                <div key={k} className="admin-stack-row">
                  <span className="admin-stack-key">{k}</span>
                  <span className="admin-stack-val">{v}</span>
                </div>
              ))}
            </CardBody>
          </Card>
        </div>
      </div>

      <Card className="admin-trigger-box">
        <CardHeader title="Database automation" subtitle="Business rules enforced inside PostgreSQL, so no client can bypass them" icon={Zap} actions={<Badge tone="good" icon={ShieldCheck}>{TRIGGERS.length} triggers</Badge>} />
        <div className="admin-table-holder">
          <table className="my-table admin-trigger-table">
            <thead>
              <tr>
                <th>Trigger</th>
                <th>Table</th>
                <th>Fires</th>
                <th>Effect</th>
              </tr>
            </thead>
            <tbody>
              {TRIGGERS.map((tr) => (
                <tr key={tr.name}>
                  <td>
                    <Code>{tr.name}</Code>
                  </td>
                  <td className="admin-mono-cell">{tr.table}</td>
                  <td className="admin-nowrap-cell">{tr.when}</td>
                  <td>{tr.does}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </>
  )
}
