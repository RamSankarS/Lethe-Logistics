import { useMemo } from 'react'
import { CircleAlert, IndianRupee, ReceiptText, TrendingDown, Undo2 } from 'lucide-react'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { BarList, SERIES } from '@/components/charts/Charts'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { EmptyState } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { PAYMENT_STATUS } from '@/lib/domain'
import { date, money, moneyCompact, num } from '@/lib/format'
import type { LossRecord, NonComplianceCostRow, Payment } from '@/lib/types'

export function FinancialExposure() {
  const L = useLookups()
  const t = useTables(['losses', 'payments', 'refunds', 'vwNonCompliance'] as const)

  const m = useMemo(() => {
    const d = t.data
    const lossTotal = d.losses.reduce((s, l) => s + Number(l.total_financial_loss), 0)
    const byCat = new Map<string, number>()
    const byOrg = new Map<string, number>()
    for (const l of d.losses) {
      byCat.set(l.loss_category, (byCat.get(l.loss_category) ?? 0) + Number(l.total_financial_loss))
      const name = L.orgName(l.org_id)
      byOrg.set(name, (byOrg.get(name) ?? 0) + Number(l.total_financial_loss))
    }
    const problems = d.payments.filter((p) => p.payment_status !== 'Completed')
    return {
      lossTotal,
      catRows: [...byCat.entries()].map(([category, value]) => ({ category, value })).sort((a, b) => b.value - a.value),
      orgRows: [...byOrg.entries()].map(([org, value]) => ({ org, value })).sort((a, b) => b.value - a.value),
      problems,
      failed: problems.filter((p) => p.payment_status === 'Failed').reduce((s, p) => s + Number(p.total_transaction_amount), 0),
      refundedPayments: problems.filter((p) => p.payment_status === 'Refunded').reduce((s, p) => s + Number(p.total_transaction_amount), 0),
      refunds: d.refunds.reduce((s, v) => s + Number(v.refund_amount), 0),
      cost: d.vwNonCompliance.reduce((s, r) => s + Number(r.total_financial_loss ?? 0), 0),
    }
  }, [t.data, L])

  const lossCols: Column<LossRecord>[] = [
    { key: 'cat', header: 'Category', sort: (l) => l.loss_category, cell: (l) => <Badge tone={l.loss_category === 'Recall' ? 'critical' : l.loss_category === 'Theft' ? 'serious' : 'warn'}>{l.loss_category}</Badge> },
    { key: 'batch', header: 'Batch', sort: (l) => L.batchNo(l.batch_id), cell: (l) => <div><Code>{L.batchNo(l.batch_id)}</Code><p className="mt-0.5 text-xs text-ink-2">{L.medName(l.batch_id)}</p></div> },
    { key: 'org', header: 'Borne by', sort: (l) => L.orgName(l.org_id), cell: (l) => <span className="text-[13px]">{L.orgName(l.org_id)}</span>, hideBelow: 'md' },
    { key: 'qty', header: 'Units', align: 'right', sort: (l) => l.quantity_lost, cell: (l) => num(l.quantity_lost) },
    { key: 'unit', header: 'Unit cost', align: 'right', cell: (l) => money(l.unit_cost_at_loss), hideBelow: 'lg' },
    { key: 'total', header: 'Loss', align: 'right', sort: (l) => Number(l.total_financial_loss), cell: (l) => <span className="font-semibold text-critical-text">{money(l.total_financial_loss)}</span> },
    { key: 'recall', header: 'Recall', cell: (l) => (l.recall_id ? <Badge tone="critical">#{l.recall_id}</Badge> : <span className="text-muted">—</span>), hideBelow: 'md' },
    { key: 'date', header: 'Booked', sort: (l) => l.created_at_utc, cell: (l) => <span className="text-[13px] text-ink-2 tabular">{date(l.created_at_utc)}</span>, hideBelow: 'xl' },
  ]

  const payCols: Column<Payment>[] = [
    { key: 'order', header: 'Order', sort: (p) => p.order_id, cell: (p) => <span className="tabular">#{p.order_id}</span> },
    { key: 'payer', header: 'Payer', cell: (p) => L.orgName(p.payer_org_id) },
    { key: 'payee', header: 'Payee', cell: (p) => L.orgName(p.payee_org_id), hideBelow: 'md' },
    { key: 'total', header: 'Amount', align: 'right', sort: (p) => Number(p.total_transaction_amount), cell: (p) => money(p.total_transaction_amount) },
    { key: 'status', header: 'Status', sort: (p) => p.payment_status, cell: (p) => <StatusBadge value={p.payment_status} meta={PAYMENT_STATUS} /> },
    { key: 'date', header: 'Date', sort: (p) => p.created_at_utc, cell: (p) => <span className="text-[13px] text-ink-2 tabular">{date(p.created_at_utc)}</span> },
  ]

  const costCols: Column<NonComplianceCostRow>[] = [
    { key: 'id', header: 'Recall', cell: (r) => <span className="tabular">#{r.recall_id}</span> },
    { key: 'reason', header: 'Reason', cell: (r) => <span className="block max-w-md truncate text-[13px] text-ink-2" title={r.recall_reason}>{r.recall_reason}</span> },
    { key: 'n', header: 'Refunds issued', align: 'right', cell: (r) => num(r.total_refunds_issued) },
    { key: 'loss', header: 'Total cost', align: 'right', cell: (r) => <span className="font-semibold">{money(r.total_financial_loss)}</span> },
    { key: 'date', header: 'Recall date', cell: (r) => <span className="text-[13px] text-ink-2 tabular">{date(r.recall_date)}</span>, hideBelow: 'md' },
  ]

  return (
    <>
      <PageHeader />
      <StatGrid cols={4}>
        <Stat label="Losses booked" value={moneyCompact(m.lossTotal)} sub={`${t.data.losses.length} loss records`} icon={TrendingDown} tone="critical" />
        <Stat label="Cost of non-compliance" value={money(m.cost)} sub="refunds tied to recalls" icon={IndianRupee} tone="serious" />
        <Stat label="Refund vouchers" value={moneyCompact(m.refunds)} sub={`${t.data.refunds.length} vouchers issued`} icon={Undo2} tone="warn" />
        <Stat label="Failed / reversed payments" value={moneyCompact(m.failed + m.refundedPayments)} sub={`${m.problems.length} payments not completed`} icon={CircleAlert} tone="info" />
      </StatGrid>

      <div className="mt-5 grid gap-5 xl:grid-cols-2">
        <Card>
          <CardHeader title="Losses by category" />
          <CardBody>{m.catRows.length ? <BarList data={m.catRows} y="category" value="value" label="Loss" color={SERIES[7]} format={moneyCompact} /> : <EmptyState title="No losses" />}</CardBody>
        </Card>
        <Card>
          <CardHeader title="Losses by organisation" />
          <CardBody>{m.orgRows.length ? <BarList data={m.orgRows} y="org" value="value" label="Loss" color={SERIES[1]} format={moneyCompact} /> : <EmptyState title="No losses" />}</CardBody>
        </Card>
      </div>

      <Card className="mt-5">
        <CardHeader title="Cost of non-compliance" subtitle="financial_analytics.vw_cost_of_non_compliance" icon={ReceiptText} />
        <DataTable bare rows={t.data.vwNonCompliance} columns={costCols} rowKey={(r) => r.recall_id} loading={t.isLoading} emptyTitle="No recall costs" />
      </Card>
      <Card className="mt-5">
        <CardHeader title="Loss register" subtitle="financial_analytics.loss_analytics_data (total loss is a generated column)" />
        <DataTable bare rows={t.data.losses} columns={lossCols} rowKey={(l) => l.loss_record_id} loading={t.isLoading} initialSort={{ key: 'total', dir: 'desc' }} exportName="lethe-losses" exportRow={(l) => ({ category: l.loss_category, batch: L.batchNo(l.batch_id), org: L.orgName(l.org_id), units: l.quantity_lost, unit_cost: l.unit_cost_at_loss, loss: l.total_financial_loss, recall: l.recall_id ?? '', booked: l.created_at_utc })} />
      </Card>
      <Card className="mt-5">
        <CardHeader title="Payments needing attention" subtitle="Pending, failed or refunded invoices" />
        <DataTable bare rows={m.problems} columns={payCols} rowKey={(p) => p.payment_id} loading={t.isLoading} emptyTitle="All payments completed" />
      </Card>
    </>
  )
}
