import { useState } from 'react'
import { PackageCheck, Truck, Undo2 } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Segmented } from '@/components/ui/Segmented'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { RETURN_FLOW, RETURN_STATUS } from '@/lib/domain'
import { date, num, relative } from '@/lib/format'
import type { ReturnRequest, ReturnStatus } from '@/lib/types'

type Filter = 'todo' | ReturnStatus | 'all'

export function InboundReturns() {
  const profile = useProfile()
  const L = useLookups()
  const t = useTables(['returns'] as const)
  const { run, busy } = useRunner()
  const [filter, setFilter] = useState<Filter>('todo')

  const advance = (r: ReturnRequest, status: ReturnStatus) =>
    run(
      `ret-${r.return_id}`,
      async () => {
        await mustChange(db('reverse').from('return_requests').update({ status }).eq('return_id', r.return_id).select('return_id'))
        await logEvent(profile.user_id, status === 'In_Transit' ? 'RETURN_PICKED_UP' : 'RETURN_RECEIVED_AT_DEPOT', 'REVERSE_LOGISTICS', { return_id: r.return_id, batch_id: r.batch_id, batch_number: L.batchNo(r.batch_id), quantity: r.quantity_returned, severity: 'LOW' })
      },
      { success: status === 'In_Transit' ? `Return #${r.return_id} picked up` : `Return #${r.return_id} received at depot`, description: status === 'Received' ? 'The manufacturer can now inspect it.' : undefined },
    )

  const match = (r: ReturnRequest, f: Filter) => (f === 'all' ? true : f === 'todo' ? r.status === 'Initiated' || r.status === 'In_Transit' : r.status === f)
  const rows = t.data.returns.filter((r) => match(r, filter))
  const count = (f: Filter) => t.data.returns.filter((r) => match(r, f)).length

  const cols: Column<ReturnRequest>[] = [
    { key: 'id', header: 'Return', sort: (r) => r.return_id, cell: (r) => <span className="dist-bold">#{r.return_id}</span> },
    { key: 'batch', header: 'Batch', sort: (r) => L.batchNo(r.batch_id), cell: (r) => <div><Code>{L.batchNo(r.batch_id)}</Code><p className="dist-med-name">{L.medName(r.batch_id)}</p></div> },
    { key: 'from', header: 'Collect from', sort: (r) => L.orgName(r.returner_org_id), cell: (r) => <span className="dist-cell-text">{L.orgName(r.returner_org_id)}</span> },
    { key: 'qty', header: 'Units', align: 'right', sort: (r) => r.quantity_returned, cell: (r) => num(r.quantity_returned) },
    { key: 'reason', header: 'Reason', cell: (r) => <div className="dist-reason-cell"><p className="dist-reason-text" title={r.return_reason}>{r.return_reason}</p>{r.recall_id && <Badge tone="critical">Recall #{r.recall_id}</Badge>}</div>, hideBelow: 'lg' },
    { key: 'filed', header: 'Filed', sort: (r) => r.created_at_utc, cell: (r) => <span className="dist-cell-grey" title={date(r.created_at_utc)}>{relative(r.created_at_utc)}</span>, hideBelow: 'md' },
    { key: 'status', header: 'Stage', sort: (r) => RETURN_FLOW.indexOf(r.status), cell: (r) => <StatusBadge value={r.status} meta={RETURN_STATUS} /> },
    {
      key: 'act',
      header: 'Action',
      cell: (r) =>
        r.status === 'Initiated' ? (
          <Button size="xs" icon={Truck} loading={busy === `ret-${r.return_id}`} onClick={() => void advance(r, 'In_Transit')}>
            Pick up
          </Button>
        ) : r.status === 'In_Transit' ? (
          <Button size="xs" variant="primary" icon={PackageCheck} loading={busy === `ret-${r.return_id}`} onClick={() => void advance(r, 'Received')}>
            Receive
          </Button>
        ) : (
          <span className="dist-muted-small">{r.status === 'Received' ? 'With manufacturer' : '—'}</span>
        ),
    },
  ]

  return (
    <>
      <PageHeader />
      <StatGrid cols={4}>
        <Stat label="To collect" value={num(count('Initiated'))} sub="returns filed, awaiting pickup" icon={Undo2} tone="warn" onClick={() => setFilter('Initiated')} />
        <Stat label="In transit" value={num(count('In_Transit'))} sub="on the way to the depot" icon={Truck} tone="info" onClick={() => setFilter('In_Transit')} />
        <Stat label="At depot" value={num(count('Received'))} sub="awaiting manufacturer inspection" icon={PackageCheck} tone="accent" onClick={() => setFilter('Received')} />
        <Stat label="Units inbound" value={num(t.data.returns.filter((r) => r.status === 'Initiated' || r.status === 'In_Transit').reduce((s, r) => s + r.quantity_returned, 0))} sub="still to reach the depot" icon={Undo2} />
      </StatGrid>
      <div className="dist-filter-bar">
        <Segmented<Filter>
          value={filter}
          onChange={setFilter}
          options={[{ value: 'todo', label: 'Your queue', count: count('todo') }, ...RETURN_FLOW.map((s) => ({ value: s as Filter, label: RETURN_STATUS[s].label, count: count(s) })), { value: 'all', label: 'All', count: count('all') }]}
        />
      </div>
      <DataTable rows={rows} columns={cols} rowKey={(r) => r.return_id} loading={t.isLoading} searchText={(r) => `${r.return_id} ${L.batchNo(r.batch_id)} ${L.orgName(r.returner_org_id)}`} initialSort={{ key: 'id', dir: 'desc' }} emptyTitle="Queue is empty" />
      <Callout tone="neutral" className="dist-bottom-note">
        The distributor owns the physical leg of reverse logistics: collect from the returning organisation, then receive at the depot. Inspection, refunds and destruction happen in the Manufacturer portal.
      </Callout>
    </>
  )
}
