import { useState } from 'react'
import { ChevronLeft, ChevronRight, Download, FilterX, Fingerprint, Lock, Search, ShieldCheck, ShieldX } from 'lucide-react'
import { EMPTY_AUDIT_FILTERS, useAuditActionTypes, useAuditPage, type AuditFilters } from '@/data/audit'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { describeError } from '@/lib/errors'
import { downloadCsv } from '@/lib/csv'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState, ErrorState } from '@/components/ui/Feedback'
import { Field, Input, Select } from '@/components/ui/Form'
import { Drawer } from '@/components/ui/Modal'
import { SEVERITIES, SEVERITY_TONE, moduleLabel, severityOf, type Severity } from '@/lib/domain'
import { dateTime, humanize, num, shortId } from '@/lib/format'
import type { AuditLog } from '@/lib/types'

const MODULES = ['IDENTITY', 'PRODUCT_INTELLIGENCE', 'WAREHOUSE_OPS', 'FORWARD_FULFILLMENT', 'REVERSE_LOGISTICS', 'FINANCIAL_ANALYTICS']
const PAGE_SIZE = 25

function TamperTest() {
  const [state, setState] = useState<'idle' | 'running' | 'blocked' | 'open'>('idle')
  const [message, setMessage] = useState('')
  const [target, setTarget] = useState<AuditLog | null>(null)

  const runTest = async () => {
    setState('running')
    const { data } = await db('identity').from('auth_audit_logs').select('log_id,action_type,source_module,log_time_stamp_utc').order('log_time_stamp_utc', { ascending: false }).limit(1).maybeSingle()
    const row = data as AuditLog | null
    if (!row) {
      setState('idle')
      return
    }
    setTarget(row)
    // Re-write the row with its *own* value: harmless even if the lock were missing, but the
    // BEFORE UPDATE trigger fires on any update and must reject it.
    const { data: changed, error } = await db('identity').from('auth_audit_logs').update({ action_type: row.action_type }).eq('log_id', row.log_id).select('log_id')
    if (error) {
      setMessage(describeError(error).raw ?? error.message)
      setState('blocked')
    } else if (!changed?.length) {
      setMessage('Row-level security refused the update: no ledger row is writable.')
      setState('blocked')
    } else {
      setMessage('The update was accepted. The immutability trigger is not active on this database.')
      setState('open')
    }
  }

  return (
    <Card>
      <CardHeader title="Ledger integrity" subtitle="Write-once, read-many (WORM) protection" icon={Fingerprint} />
      <CardBody className="space-y-3">
        <p className="text-[13px] leading-5 text-ink-2">
          This test tries to modify the newest ledger row (re-writing it with its own value, so nothing can change). The database should refuse.
        </p>
        <Button variant="primary" icon={Lock} loading={state === 'running'} onClick={() => void runTest()}>
          Run tamper test
        </Button>
        {state === 'blocked' && (
          <Callout tone="good" icon={ShieldCheck} title="Tamper attempt blocked">
            <span className="block">
              Target: <Code>{shortId(target?.log_id)}</Code> {humanize(target?.action_type)}
            </span>
            <span className="mt-1 block font-mono text-xs text-ink">“{message}”</span>
          </Callout>
        )}
        {state === 'open' && (
          <Callout tone="critical" icon={ShieldX} title="Ledger is not protected">
            {message}
          </Callout>
        )}
      </CardBody>
    </Card>
  )
}

export function AuditLedger() {
  const L = useLookups()
  const { data } = useTables(['users'] as const)
  const actions = useAuditActionTypes()
  const [draft, setDraft] = useState<AuditFilters>(EMPTY_AUDIT_FILTERS)
  const [filters, setFilters] = useState<AuditFilters>(EMPTY_AUDIT_FILTERS)
  const [page, setPage] = useState(0)
  const [open, setOpen] = useState<AuditLog | null>(null)
  const [exporting, setExporting] = useState(false)
  const q = useAuditPage(filters, page, PAGE_SIZE)

  const apply = (next: AuditFilters) => {
    setFilters(next)
    setPage(0)
  }
  const set = (k: keyof AuditFilters) => (e: { target: { value: string } }) => {
    const next = { ...draft, [k]: e.target.value }
    setDraft(next)
    if (k !== 'search') apply(next)
  }

  const total = q.data?.total ?? 0
  const pages = Math.max(1, Math.ceil(total / PAGE_SIZE))
  const active = Object.values(filters).some(Boolean)

  const exportAll = async () => {
    setExporting(true)
    try {
      const rows: AuditLog[] = []
      // Walk the ledger in 1000-row pages (server filters + client-side severity/search), max 5 pages
      for (let p = 0; p < 5; p++) {
        const { matched, raw } = await fetchPage(filters, p)
        rows.push(...matched)
        if (raw < 1000) break
      }
      downloadCsv(
        'lethe-audit-ledger',
        rows.map((r) => ({ log_id: r.log_id, time_utc: r.log_time_stamp_utc, module: r.source_module, action: r.action_type, severity: severityOf(r), user: L.userName(r.user_id), ip: r.ip_address, payload: r.event_payload })),
      )
    } finally {
      setExporting(false)
    }
  }

  return (
    <>
      <PageHeader actions={<Button icon={Download} loading={exporting} disabled={!total} onClick={() => void exportAll()}>Export CSV</Button>} />
      <div className="grid gap-5 2xl:grid-cols-[1fr_340px]">
        <div className="min-w-0 space-y-4">
          <Card className="p-4">
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6">
              <Field label="Search" className="xl:col-span-2">
                <form
                  onSubmit={(e) => {
                    e.preventDefault()
                    apply(draft)
                  }}
                  className="relative"
                >
                  <Search className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted" />
                  <Input value={draft.search} onChange={set('search')} onBlur={() => apply(draft)} placeholder="Action, batch, reason, IP… (Enter)" className="pl-9" />
                </form>
              </Field>
              <Field label="Module">
                <Select value={draft.module} onChange={set('module')}>
                  <option value="">All modules</option>
                  {MODULES.map((m) => (
                    <option key={m} value={m}>
                      {moduleLabel(m)}
                    </option>
                  ))}
                </Select>
              </Field>
              <Field label="Severity">
                <Select value={draft.severity} onChange={set('severity')}>
                  <option value="">Any severity</option>
                  {SEVERITIES.map((s) => (
                    <option key={s} value={s}>
                      {humanize(s)}
                    </option>
                  ))}
                </Select>
              </Field>
              <Field label="Action">
                <Select value={draft.action} onChange={set('action')}>
                  <option value="">All actions</option>
                  {(actions.data ?? []).map((a) => (
                    <option key={a} value={a}>
                      {humanize(a)}
                    </option>
                  ))}
                </Select>
              </Field>
              <Field label="User">
                <Select value={draft.userId} onChange={set('userId')}>
                  <option value="">Anyone</option>
                  {data.users.map((u) => (
                    <option key={u.user_id} value={u.user_id}>
                      {u.first_name} {u.last_name}
                    </option>
                  ))}
                </Select>
              </Field>
              <Field label="From">
                <Input type="date" value={draft.from} onChange={set('from')} />
              </Field>
              <Field label="To">
                <Input type="date" value={draft.to} onChange={set('to')} />
              </Field>
              <div className="flex items-end">
                <Button
                  variant="ghost"
                  icon={FilterX}
                  disabled={!active}
                  onClick={() => {
                    setDraft(EMPTY_AUDIT_FILTERS)
                    apply(EMPTY_AUDIT_FILTERS)
                  }}
                >
                  Clear
                </Button>
              </div>
            </div>
          </Card>

          <Card className="overflow-hidden">
            <div className="flex items-center justify-between border-b border-line px-4 py-3 text-[13px] text-ink-2">
              <span>
                <b className="text-ink tabular">{num(total)}</b> events{active ? ' match your filters' : ' in the ledger'}
              </span>
              <span className="inline-flex items-center gap-1.5">
                <Lock className="size-3.5" /> Append-only
              </span>
            </div>
            {q.error ? (
              <ErrorState error={q.error} onRetry={() => void q.refetch()} />
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full min-w-[760px] text-left text-[13px]">
                  <thead>
                    <tr className="border-b border-line bg-surface-2 text-[11.5px] tracking-wide text-muted uppercase">
                      <th className="px-4 py-2.5 font-semibold">Time (UTC)</th>
                      <th className="px-4 py-2.5 font-semibold">Module</th>
                      <th className="px-4 py-2.5 font-semibold">Action</th>
                      <th className="px-4 py-2.5 font-semibold">Severity</th>
                      <th className="px-4 py-2.5 font-semibold">Actor</th>
                      <th className="hidden px-4 py-2.5 font-semibold lg:table-cell">Detail</th>
                    </tr>
                  </thead>
                  <tbody className={q.isFetching ? 'opacity-60 transition-opacity' : ''}>
                    {(q.data?.rows ?? []).map((r) => {
                      const sev = severityOf(r)
                      const p = (r.event_payload ?? {}) as Record<string, unknown>
                      const detail = p.description ?? p.reason ?? (p.batch_number ? `Batch ${p.batch_number}` : null) ?? (p.disposal_method ? `Method ${p.disposal_method}` : null)
                      return (
                        <tr key={r.log_id} onClick={() => setOpen(r)} className="cursor-pointer border-b border-line last:border-0 hover:bg-surface-2">
                          <td className="px-4 py-2.5 whitespace-nowrap text-ink-2 tabular">{dateTime(r.log_time_stamp_utc)}</td>
                          <td className="px-4 py-2.5 whitespace-nowrap text-ink-2">{moduleLabel(r.source_module)}</td>
                          <td className="px-4 py-2.5 font-medium whitespace-nowrap text-ink">{humanize(r.action_type)}</td>
                          <td className="px-4 py-2.5">
                            <Badge tone={SEVERITY_TONE[sev]} dot>
                              {sev.toLowerCase()}
                            </Badge>
                          </td>
                          <td className="px-4 py-2.5 whitespace-nowrap text-ink-2">{r.user_id ? L.userName(r.user_id) : 'System'}</td>
                          <td className="hidden max-w-[320px] truncate px-4 py-2.5 text-ink-2 lg:table-cell">{detail ? String(detail) : r.ip_address ?? '—'}</td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
                {!q.isLoading && (q.data?.rows.length ?? 0) === 0 && <EmptyState title="No events match" />}
                {q.isLoading && <div className="p-10 text-center text-sm text-ink-2">Loading ledger…</div>}
              </div>
            )}
            <div className="flex items-center justify-between border-t border-line px-4 py-2.5 text-[13px] text-ink-2">
              <span className="tabular">
                Page {page + 1} of {pages}
              </span>
              <div className="flex gap-1">
                <Button size="sm" variant="ghost" icon={ChevronLeft} disabled={page === 0} onClick={() => setPage((p) => p - 1)} aria-label="Previous page" />
                <Button size="sm" variant="ghost" icon={ChevronRight} disabled={page >= pages - 1} onClick={() => setPage((p) => p + 1)} aria-label="Next page" />
              </div>
            </div>
          </Card>
        </div>

        <div className="space-y-4">
          <TamperTest />
          <Card>
            <CardHeader title="Severity legend" />
            <CardBody className="space-y-2 text-[12.5px]">
              {(SEVERITIES as Severity[]).map((s) => (
                <div key={s} className="flex items-center justify-between gap-2">
                  <Badge tone={SEVERITY_TONE[s]} dot>
                    {s.toLowerCase()}
                  </Badge>
                  <span className="text-right text-ink-2">
                    {s === 'CRITICAL' ? 'Recalls, spec tampering' : s === 'HIGH' ? 'Destruction, breaches, RBAC changes' : s === 'MEDIUM' ? 'Key rotation, QC passes' : s === 'LOW' ? 'Routine state changes' : 'Logins, views, reports'}
                  </span>
                </div>
              ))}
            </CardBody>
          </Card>
        </div>
      </div>

      <Drawer open={!!open} onClose={() => setOpen(null)} title={open ? humanize(open.action_type) : ''} subtitle={open ? `${moduleLabel(open.source_module)} · ${dateTime(open.log_time_stamp_utc)}` : ''}>
        {open && (
          <div className="space-y-4">
            <Card>
              <CardBody className="grid grid-cols-2 gap-4 pt-5 text-[13px]">
                <div>
                  <p className="text-[11.5px] tracking-wide text-muted uppercase">Log ID</p>
                  <p className="font-mono text-xs break-all text-ink">{open.log_id}</p>
                </div>
                <div>
                  <p className="text-[11.5px] tracking-wide text-muted uppercase">Severity</p>
                  <Badge tone={SEVERITY_TONE[severityOf(open)]} dot>
                    {severityOf(open).toLowerCase()}
                  </Badge>
                </div>
                <div>
                  <p className="text-[11.5px] tracking-wide text-muted uppercase">Actor</p>
                  <p className="text-ink">{open.user_id ? L.userName(open.user_id) : 'System'}</p>
                  {open.user_id && <p className="text-xs text-ink-2">{L.orgName(L.user.get(open.user_id)?.org_id)}</p>}
                </div>
                <div>
                  <p className="text-[11.5px] tracking-wide text-muted uppercase">Source IP</p>
                  <p className="font-mono text-ink">{open.ip_address ?? '—'}</p>
                </div>
              </CardBody>
            </Card>
            <Card>
              <CardHeader title="Event payload" subtitle="Stored as JSONB, exactly as written" />
              <CardBody>
                <pre className="max-h-[420px] overflow-auto rounded-xl bg-surface-2 p-4 font-mono text-[12px] leading-5 text-ink">{JSON.stringify(open.event_payload ?? {}, null, 2)}</pre>
              </CardBody>
            </Card>
            <Callout tone="neutral" icon={Lock}>
              This record cannot be edited or deleted by anyone, including the SysAdmin.
            </Callout>
          </div>
        )}
      </Drawer>
    </>
  )
}

/** Plain fetch of one 1000-row page with the same filters (used for CSV export). */
async function fetchPage(filters: AuditFilters, page: number): Promise<{ matched: AuditLog[]; raw: number }> {
  let q = db('identity').from('auth_audit_logs').select('log_id,user_id,action_type,source_module,event_payload,ip_address,log_time_stamp_utc').order('log_time_stamp_utc', { ascending: false })
  if (filters.module) q = q.eq('source_module', filters.module)
  if (filters.action) q = q.eq('action_type', filters.action)
  if (filters.userId) q = q.eq('user_id', filters.userId)
  if (filters.from) q = q.gte('log_time_stamp_utc', `${filters.from}T00:00:00`)
  if (filters.to) q = q.lte('log_time_stamp_utc', `${filters.to}T23:59:59.999`)
  const { data, error } = await q.range(page * 1000, page * 1000 + 999)
  if (error) throw error
  const raw = (data ?? []) as AuditLog[]
  let rows = raw
  if (filters.severity) rows = rows.filter((r) => severityOf(r) === filters.severity)
  const term = filters.search.trim().toLowerCase()
  if (term) rows = rows.filter((r) => `${r.action_type} ${r.source_module} ${r.ip_address} ${JSON.stringify(r.event_payload)}`.toLowerCase().includes(term))
  return { matched: rows, raw: raw.length }
}
