import { useState } from 'react'
import { IndianRupee, Undo2, Wallet } from 'lucide-react'
import { useLookups } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Drawer } from '@/components/ui/Modal'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { Stepper } from '@/components/ui/Stepper'
import { DISPOSITION, REFUND_STATUS, RETURN_FLOW, RETURN_STATUS } from '@/lib/domain'
import { date, dateTime, money, num } from '@/lib/format'
import type { ReturnStatus } from '@/lib/types'
import { FileReturnModal, useRetailerModel } from './shared'

type Row = ReturnType<typeof useRetailerModel>['returns'][number]

const STEP_LABELS: Record<ReturnStatus, string> = { Initiated: 'Filed', In_Transit: 'In transit', Received: 'At depot', Assessed: 'Assessed', Closed: 'Closed' }

export function Returns() {
  const L = useLookups()
  const m = useRetailerModel()
  const [filing, setFiling] = useState(false)
  const [openId, setOpenId] = useState<number | null>(null)
  const open = m.returns.find((x) => x.r.return_id === openId)

  const refunded = m.returns.filter((x) => x.v?.refund_status === 'Processed').reduce((s, x) => s + Number(x.v!.refund_amount), 0)
  const pending = m.returns.filter((x) => x.v?.refund_status === 'Pending_Payout').reduce((s, x) => s + Number(x.v!.refund_amount), 0)

  const cols: Column<Row>[] = [
    { key: 'id', header: 'Return', sort: (x) => x.r.return_id, cell: (x) => <span className="font-semibold tabular">#{x.r.return_id}</span> },
    { key: 'batch', header: 'Batch', sort: (x) => L.batchNo(x.r.batch_id), cell: (x) => <div><Code>{L.batchNo(x.r.batch_id)}</Code><p className="mt-0.5 text-xs text-ink-2">{L.medName(x.r.batch_id)}</p></div> },
    { key: 'qty', header: 'Units', align: 'right', sort: (x) => x.r.quantity_returned, cell: (x) => num(x.r.quantity_returned) },
    { key: 'reason', header: 'Reason', cell: (x) => <div className="max-w-[260px]"><p className="truncate text-[13px] text-ink-2" title={x.r.return_reason}>{x.r.return_reason}</p>{x.r.recall_id && <Badge tone="critical">Recall #{x.r.recall_id}</Badge>}</div>, hideBelow: 'md' },
    { key: 'status', header: 'Stage', sort: (x) => RETURN_FLOW.indexOf(x.r.status), cell: (x) => <StatusBadge value={x.r.status} meta={RETURN_STATUS} /> },
    { key: 'outcome', header: 'Outcome', cell: (x) => (x.a ? <StatusBadge value={x.a.disposition_action} meta={DISPOSITION} /> : <span className="text-xs text-muted">Pending inspection</span>), hideBelow: 'lg' },
    { key: 'refund', header: 'Refund', align: 'right', sort: (x) => Number(x.v?.refund_amount ?? 0), cell: (x) => (x.v ? <div className="flex flex-col items-end gap-1"><span className="font-medium">{money(x.v.refund_amount)}</span><StatusBadge value={x.v.refund_status} meta={REFUND_STATUS} /></div> : <span className="text-xs text-muted">—</span>) },
    { key: 'filed', header: 'Filed', sort: (x) => x.r.created_at_utc, cell: (x) => <span className="text-[13px] text-ink-2 tabular">{date(x.r.created_at_utc)}</span>, hideBelow: 'xl' },
  ]

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={Undo2} onClick={() => setFiling(true)}>File a return</Button>} />
      <StatGrid cols={4}>
        <Stat label="Returns filed" value={num(m.returns.length)} sub={`${m.returns.filter((x) => x.r.status !== 'Closed').length} still open`} icon={Undo2} />
        <Stat label="Units returned" value={num(m.returns.reduce((s, x) => s + x.r.quantity_returned, 0))} sub="across all claims" icon={Undo2} tone="info" />
        <Stat label="Refunds paid" value={money(refunded)} sub="vouchers processed" icon={Wallet} tone="good" />
        <Stat label="Refunds pending" value={money(pending)} sub="approved, awaiting payout" icon={IndianRupee} tone="warn" />
      </StatGrid>

      <Card className="mt-5">
        <CardHeader title="My returns" subtitle="Filed → In transit → At depot → Assessed → Closed. Click a row for the full trail." />
        <DataTable bare rows={m.returns} columns={cols} rowKey={(x) => x.r.return_id} loading={m.isLoading} onRowClick={(x) => setOpenId(x.r.return_id)} searchText={(x) => `${x.r.return_id} ${L.batchNo(x.r.batch_id)} ${x.r.return_reason}`} initialSort={{ key: 'id', dir: 'desc' }} emptyTitle="No returns filed" />
      </Card>

      <Drawer open={!!open} onClose={() => setOpenId(null)} title={open ? `Return #${open.r.return_id}` : ''} subtitle={open ? `${L.batchNo(open.r.batch_id)} · ${L.medName(open.r.batch_id)}` : ''}>
        {open && (
          <div className="space-y-4">
            <Card>
              <CardBody className="pt-5">
                <Stepper steps={RETURN_FLOW} current={open.r.status} labels={STEP_LABELS} />
              </CardBody>
            </Card>
            <Card>
              <CardHeader title="Claim" />
              <CardBody className="space-y-1 text-[13px]">
                <p className="text-ink">
                  {num(open.r.quantity_returned)} units · filed {dateTime(open.r.created_at_utc)}
                </p>
                <p className="text-ink-2">{open.r.return_reason}</p>
                {open.r.recall_id && <Badge tone="critical">Linked to recall #{open.r.recall_id}</Badge>}
              </CardBody>
            </Card>
            {open.a && (
              <Card>
                <CardHeader title="Inspection" actions={<StatusBadge value={open.a.disposition_action} meta={DISPOSITION} />} />
                <CardBody className="space-y-1 text-[13px]">
                  <p className="text-ink">“{open.a.inspection_result}”</p>
                  <p className="text-ink-2">
                    Inspected by {L.userName(open.a.inspector_user_id)} · {dateTime(open.a.assessed_at_utc)}
                  </p>
                </CardBody>
              </Card>
            )}
            {open.v && (
              <Card>
                <CardHeader title="Refund voucher" actions={<StatusBadge value={open.v.refund_status} meta={REFUND_STATUS} />} />
                <CardBody className="text-[13px]">
                  <p className="text-2xl font-semibold text-ink tabular">{money(open.v.refund_amount)}</p>
                  <p className="text-ink-2">Voucher #{open.v.voucher_id} · issued {dateTime(open.v.issued_at_utc)}</p>
                </CardBody>
              </Card>
            )}
          </div>
        )}
      </Drawer>

      <FileReturnModal open={filing} onClose={() => setFiling(false)} />
    </>
  )
}
