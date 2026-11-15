import { useMemo } from 'react'
import { BellRing, Flame, Siren, Undo2 } from 'lucide-react'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { SegmentedBar } from '@/components/ui/Progress'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { RECALL_STATUS, RETURN_FLOW, RETURN_STATUS } from '@/lib/domain'
import { date, dateTime, humanize, money, num, pct } from '@/lib/format'
import type { DisposalCertificate } from '@/lib/types'

export function RecallOversight() {
  const L = useLookups()
  const t = useTables(['recalls', 'recallComms', 'returns', 'refunds', 'assessments', 'disposals'] as const)

  const m = useMemo(() => {
    const d = t.data
    const recalls = d.recalls.map((r) => {
      const comms = d.recallComms.filter((c) => c.recall_id === r.recall_id)
      const orgs = new Set(comms.map((c) => c.notified_org_id))
      const acked = new Set(comms.filter((c) => c.delivery_status === 'Read').map((c) => c.notified_org_id))
      const returns = d.returns.filter((x) => x.recall_id === r.recall_id)
      const returnIds = new Set(returns.map((x) => x.return_id))
      const refunds = d.refunds.filter((v) => returnIds.has(v.return_id)).reduce((s, v) => s + Number(v.refund_amount), 0)
      const count = (s: string) => comms.filter((c) => c.delivery_status === s).length
      return { r, comms, orgs: orgs.size, acked: acked.size, returns, units: returns.reduce((s, x) => s + x.quantity_returned, 0), refunds, count }
    })
    const returnById = new Map(d.returns.map((r) => [r.return_id, r]))
    const assessById = new Map(d.assessments.map((a) => [a.assessment_id, a]))
    return { recalls, returnById, assessById }
  }, [t.data])

  type Row = (typeof m.recalls)[number]
  const cols: Column<Row>[] = [
    { key: 'id', header: 'Recall', sort: (x) => x.r.recall_id, cell: (x) => <span className="font-semibold tabular">#{x.r.recall_id}</span> },
    { key: 'batch', header: 'Batch', sort: (x) => L.batchNo(x.r.batch_id), cell: (x) => <div><Code>{L.batchNo(x.r.batch_id)}</Code><p className="mt-0.5 text-xs text-ink-2">{L.medName(x.r.batch_id)}</p></div> },
    { key: 'by', header: 'Initiated by', cell: (x) => <span className="text-[13px]">{L.orgName(x.r.initiated_by_org_id)}</span>, hideBelow: 'lg' },
    { key: 'date', header: 'Date', sort: (x) => x.r.created_at_utc, cell: (x) => <span className="text-[13px] text-ink-2 tabular">{date(x.r.created_at_utc)}</span>, hideBelow: 'md' },
    { key: 'status', header: 'Status', sort: (x) => x.r.quarantine_status, cell: (x) => <StatusBadge value={x.r.quarantine_status} meta={RECALL_STATUS} /> },
    { key: 'ack', header: 'Acknowledged', align: 'right', sort: (x) => (x.orgs ? x.acked / x.orgs : 0), cell: (x) => <span className="tabular">{x.acked}/{x.orgs} <span className="text-xs text-ink-2">({pct(x.orgs ? x.acked / x.orgs : 0)})</span></span> },
    { key: 'failed', header: 'Failed notices', align: 'right', sort: (x) => x.count('Failed'), cell: (x) => (x.count('Failed') ? <Badge tone="critical">{x.count('Failed')}</Badge> : <span className="text-muted">0</span>), hideBelow: 'md' },
    { key: 'units', header: 'Units returned', align: 'right', sort: (x) => x.units, cell: (x) => num(x.units) },
    { key: 'refunds', header: 'Refunds', align: 'right', sort: (x) => x.refunds, cell: (x) => money(x.refunds), hideBelow: 'lg' },
  ]

  const certCols: Column<DisposalCertificate>[] = [
    { key: 'id', header: 'Certificate', sort: (c) => c.certificate_id, cell: (c) => <span className="font-semibold tabular">#{c.certificate_id}</span> },
    {
      key: 'batch',
      header: 'Batch destroyed',
      cell: (c) => {
        const a = m.assessById.get(c.assessment_id)
        const r = a ? m.returnById.get(a.return_id) : undefined
        return r ? <div><Code>{L.batchNo(r.batch_id)}</Code><p className="mt-0.5 text-xs text-ink-2">{num(r.quantity_returned)} units · return #{r.return_id}</p></div> : '—'
      },
    },
    { key: 'method', header: 'Method', sort: (c) => c.disposal_method, cell: (c) => <Badge tone="serious" icon={Flame}>{humanize(c.disposal_method)}</Badge> },
    { key: 'witness', header: 'Witness', cell: (c) => <span className="text-[13px]">{L.userName(c.witness_user_id)}</span>, hideBelow: 'md' },
    { key: 'hash', header: 'Evidence hash', cell: (c) => <Code className="text-[11px]">{c.evidence_hash.slice(0, 28)}…</Code>, hideBelow: 'lg' },
    { key: 'when', header: 'Disposed', sort: (c) => c.disposed_at_utc, cell: (c) => <span className="text-[13px] text-ink-2 tabular">{dateTime(c.disposed_at_utc)}</span> },
  ]

  const allComms = t.data.recallComms
  const commCount = (s: string) => allComms.filter((c) => c.delivery_status === s).length
  const returnCount = (s: string) => t.data.returns.filter((r) => r.status === s).length

  return (
    <>
      <PageHeader />
      <StatGrid cols={4}>
        <Stat label="Recalls" value={num(t.data.recalls.length)} sub={`${t.data.recalls.filter((r) => r.quarantine_status === 'Active').length} active`} icon={Siren} tone="critical" />
        <Stat label="Notices sent" value={num(allComms.length)} sub={`${pct(allComms.length ? commCount('Read') / allComms.length : 0)} acknowledged`} icon={BellRing} tone="info" />
        <Stat label="Returns in the network" value={num(t.data.returns.length)} sub={`${t.data.returns.filter((r) => r.status !== 'Closed').length} still open`} icon={Undo2} tone="warn" />
        <Stat label="Disposal certificates" value={num(t.data.disposals.length)} sub="witnessed destructions" icon={Flame} tone="serious" />
      </StatGrid>

      <div className="mt-5 grid gap-5 xl:grid-cols-2">
        <Card>
          <CardHeader title="Recall notification effectiveness" subtitle="All notices across every recall" />
          <CardBody>
            <SegmentedBar
              parts={[
                { key: 'Read', label: 'Acknowledged', value: commCount('Read'), color: 'var(--good)' },
                { key: 'Delivered', label: 'Delivered', value: commCount('Delivered'), color: 'var(--info)' },
                { key: 'Pending', label: 'Pending', value: commCount('Pending'), color: 'var(--warn)', darkText: true },
                { key: 'Failed', label: 'Failed', value: commCount('Failed'), color: 'var(--critical)' },
              ]}
            />
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="Reverse logistics pipeline" subtitle="Where every return in the network sits" />
          <CardBody>
            <SegmentedBar
              parts={RETURN_FLOW.map((s, i) => ({ key: s, label: RETURN_STATUS[s].label, value: returnCount(s), color: ['var(--series-4)', 'var(--series-1)', 'var(--series-7)', 'var(--series-2)', 'var(--series-3)'][i], darkText: i === 0 }))}
            />
          </CardBody>
        </Card>
      </div>

      <Card className="mt-5">
        <CardHeader title="Recall ledger" subtitle="reverse_logistics.global_recall_ledger with communication and return outcomes" />
        <DataTable bare rows={m.recalls} columns={cols} rowKey={(x) => x.r.recall_id} loading={t.isLoading} initialSort={{ key: 'id', dir: 'desc' }} emptyTitle="No recalls" />
      </Card>

      <Card className="mt-5">
        <CardHeader title="Disposal certificates" subtitle="Proof that recalled or damaged stock was destroyed and can never re-enter the market" icon={Flame} />
        <DataTable bare rows={t.data.disposals} columns={certCols} rowKey={(c) => c.certificate_id} loading={t.isLoading} emptyTitle="No certificates" />
      </Card>
    </>
  )
}
