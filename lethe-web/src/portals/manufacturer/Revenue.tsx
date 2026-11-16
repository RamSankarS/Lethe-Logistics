import { useMemo, useState } from 'react'
import { AlertTriangle, FileBarChart, IndianRupee, Receipt, TrendingDown, Undo2, Wallet } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { BarList, ColumnChart, SERIES } from '@/components/charts/Charts'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { PAYMENT_STATUS } from '@/lib/domain'
import { date, money, moneyCompact, num, pct, shortDate, shortId } from '@/lib/format'
import type { Payment } from '@/lib/types'
import { useMyBatches } from './shared'

function GenerateReport({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { run, busy } = useRunner()
  const now = new Date()
  const [month, setMonth] = useState(`${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`)
  const lastDay = (() => {
    const [y, m] = month.split('-').map(Number)
    const d = new Date(y, m, 0)
    return `${y}-${String(m).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
  })()
  const submit = async () => {
    const r = await run(
      'report',
      async () => {
        const { error } = await db('finance').rpc('sp_generate_monthly_report', { p_org_id: profile.org!.org_id, p_report_date: lastDay, p_user_id: profile.user_id })
        if (error) throw error
        await logEvent(profile.user_id, 'MONTHLY_REPORT_GENERATED', 'FINANCIAL_ANALYTICS', { report_date: lastDay, org_id: profile.org!.org_id, severity: 'LOW' })
      },
      { success: `Report for ${month} generated`, description: 'Computed in the database by sp_generate_monthly_report.' },
    )
    if (r.ok) onClose()
  }
  return (
    <Modal
      open={open}
      onClose={onClose}
      size="sm"
      icon={FileBarChart}
      title="Generate monthly report"
      description="Runs the stored procedure that aggregates completed invoices for the month."
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={FileBarChart} loading={busy === 'report'} onClick={submit}>
            Generate
          </Button>
        </>
      }
    >
      <Field label="Reporting month" hint={`Report date will be ${date(lastDay)}.`}>
        <Input type="month" value={month} onChange={(e) => setMonth(e.target.value)} />
      </Field>
    </Modal>
  )
}

export function Revenue() {
  const profile = useProfile()
  const L = useLookups()
  const { batches, ids } = useMyBatches()
  const t = useTables(['payments', 'reports', 'losses', 'refunds', 'returns', 'orderItems', 'orders'] as const)
  const [generating, setGenerating] = useState(false)
  const orgId = profile.org?.org_id

  const m = useMemo(() => {
    const d = t.data
    const payments = d.payments.filter((p) => p.payee_org_id === orgId)
    const completed = payments.filter((p) => p.payment_status === 'Completed')
    const invoiced = completed.reduce((s, p) => s + Number(p.base_amount), 0)
    const tax = completed.reduce((s, p) => s + (Number(p.total_transaction_amount) - Number(p.base_amount)), 0)
    const myReturns = d.returns.filter((r) => ids.has(r.batch_id))
    const returnBatch = new Map(myReturns.map((r) => [r.return_id, r.batch_id]))
    const refunds = d.refunds.filter((v) => returnBatch.has(v.return_id) && v.refund_status !== 'Failed')
    const refundTotal = refunds.reduce((s, v) => s + Number(v.refund_amount), 0)
    const losses = d.losses.filter((l) => ids.has(l.batch_id))
    const lossTotal = losses.reduce((s, l) => s + Number(l.total_financial_loss), 0)
    const reports = d.reports.filter((r) => r.org_id === orgId)
    const seen = new Map<string, number>()
    const reportRows = reports.map((r) => {
      const n = (seen.get(r.report_date) ?? 0) + 1
      seen.set(r.report_date, n)
      return { label: `${shortDate(r.report_date)}${n > 1 ? ` (${n})` : ''}`, gross: Number(r.total_gross_revenue), net: Number(r.net_revenue) }
    })
    const lossByCat = new Map<string, number>()
    for (const l of losses) lossByCat.set(l.loss_category, (lossByCat.get(l.loss_category) ?? 0) + Number(l.total_financial_loss))
    const lossRows = [...lossByCat.entries()].map(([category, value]) => ({ category, value })).sort((a, b) => b.value - a.value)

    // Batch-level profitability
    const delivered = new Set(d.orders.filter((o) => o.order_status === 'Delivered').map((o) => o.order_id))
    const perBatch = batches
      .map((b) => {
        const lines = d.orderItems.filter((i) => i.batch_id === b.batch_id && delivered.has(i.order_id))
        const revenue = lines.reduce((s, i) => s + i.quantity * Number(i.unit_price), 0)
        const units = lines.reduce((s, i) => s + i.quantity, 0)
        const ref = refunds.filter((v) => returnBatch.get(v.return_id) === b.batch_id).reduce((s, v) => s + Number(v.refund_amount), 0)
        const loss = losses.filter((l) => l.batch_id === b.batch_id).reduce((s, l) => s + Number(l.total_financial_loss), 0)
        const net = revenue - ref - loss
        return { b, revenue, units, refunds: ref, losses: loss, net, margin: revenue > 0 ? net / revenue : null }
      })
      .filter((x) => x.revenue || x.refunds || x.losses)
    return { payments, invoiced, tax, refundTotal, refunds, lossTotal, reports, reportRows, lossRows, perBatch, failed: payments.filter((p) => p.payment_status === 'Failed' || p.payment_status === 'Refunded').length }
  }, [t.data, orgId, ids, batches])

  type BatchRow = (typeof m.perBatch)[number]
  const batchCols: Column<BatchRow>[] = [
    { key: 'batch', header: 'Batch', sort: (x) => x.b.batch_number, cell: (x) => <div><Code>{x.b.batch_number}</Code><p className="mfr-cell-sub">{L.medOf(x.b)?.brand_name}</p></div> },
    { key: 'units', header: 'Units delivered', align: 'right', sort: (x) => x.units, cell: (x) => num(x.units), hideBelow: 'md' },
    { key: 'revenue', header: 'Revenue', align: 'right', sort: (x) => x.revenue, cell: (x) => money(x.revenue) },
    { key: 'refunds', header: 'Refunds', align: 'right', sort: (x) => x.refunds, cell: (x) => <span className={x.refunds ? 'mfr-orange-num' : 'mfr-grey-text'}>{x.refunds ? `−${money(x.refunds)}` : '—'}</span> },
    { key: 'losses', header: 'Losses', align: 'right', sort: (x) => x.losses, cell: (x) => <span className={x.losses ? 'mfr-red-num' : 'mfr-grey-text'}>{x.losses ? `−${money(x.losses)}` : '—'}</span> },
    { key: 'net', header: 'Net', align: 'right', sort: (x) => x.net, cell: (x) => <span className={`mfr-net-num ${x.net < 0 ? 'mfr-red-num' : ''}`}>{money(x.net)}</span> },
    {
      key: 'margin',
      header: 'Margin',
      align: 'right',
      sort: (x) => x.margin ?? -999,
      cell: (x) => (x.margin == null ? <Badge tone="critical">Loss only</Badge> : <Badge tone={x.margin < 0 ? 'critical' : x.margin < 0.5 ? 'warn' : 'good'}>{pct(x.margin)}</Badge>),
    },
  ]

  const payCols: Column<Payment>[] = [
    { key: 'id', header: 'Payment', cell: (p) => <Code>{shortId(p.payment_id)}</Code> },
    { key: 'order', header: 'Order', sort: (p) => p.order_id, cell: (p) => <span className="mfr-order-no">#{p.order_id}</span> },
    { key: 'payer', header: 'Payer', sort: (p) => L.orgName(p.payer_org_id), cell: (p) => L.orgName(p.payer_org_id) },
    { key: 'base', header: 'Base', align: 'right', sort: (p) => Number(p.base_amount), cell: (p) => money(p.base_amount), hideBelow: 'md' },
    { key: 'tax', header: 'Tax', align: 'right', cell: (p) => `${num(p.tax_percentage)}%`, hideBelow: 'lg' },
    { key: 'total', header: 'Total', align: 'right', sort: (p) => Number(p.total_transaction_amount), cell: (p) => <span className="mfr-total-num">{money(p.total_transaction_amount)}</span> },
    { key: 'status', header: 'Status', sort: (p) => p.payment_status, cell: (p) => <StatusBadge value={p.payment_status} meta={PAYMENT_STATUS} /> },
    { key: 'date', header: 'Date', sort: (p) => p.created_at_utc, cell: (p) => <span className="mfr-date-text">{date(p.created_at_utc)}</span> },
  ]

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={FileBarChart} onClick={() => setGenerating(true)}>Generate monthly report</Button>} />

      <StatGrid>
        <Stat label="Invoiced revenue" value={moneyCompact(m.invoiced)} sub="completed invoices (pre-tax)" icon={IndianRupee} tone="good" loading={t.isLoading} />
        <Stat label="Tax collected" value={moneyCompact(m.tax)} sub="GST on completed invoices" icon={Receipt} tone="info" loading={t.isLoading} />
        <Stat label="Refunds issued" value={moneyCompact(m.refundTotal)} sub={`${m.refunds.length} vouchers`} icon={Undo2} tone="serious" loading={t.isLoading} />
        <Stat label="Losses booked" value={moneyCompact(m.lossTotal)} sub="spoilage, damage, recall, disposal" icon={TrendingDown} tone="critical" loading={t.isLoading} />
        <Stat label="Net position" value={moneyCompact(m.invoiced - m.refundTotal - m.lossTotal)} sub="revenue − refunds − losses" icon={Wallet} loading={t.isLoading} />
        <Stat label="Failed / refunded" value={num(m.failed)} sub="payments needing follow-up" icon={AlertTriangle} tone="warn" loading={t.isLoading} />
      </StatGrid>

      <div className="mfr-revenue-row grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Monthly financial reports" subtitle="Generated by the database (net revenue is a generated column)" />
          <CardBody>
            {m.reportRows.length ? (
              <ColumnChart
                data={m.reportRows}
                x="label"
                format={money}
                series={[
                  { key: 'gross', label: 'Gross revenue', color: SERIES[0] },
                  { key: 'net', label: 'Net revenue', color: SERIES[2] },
                ]}
              />
            ) : (
              <EmptyState title="No reports yet" />
            )}
          </CardBody>
        </Card>
        <Card className="xl:col-span-2">
          <CardHeader title="Losses by category" subtitle="From financial_analytics.loss_analytics_data" />
          <CardBody>{m.lossRows.length ? <BarList data={m.lossRows} y="category" value="value" label="Loss" color={SERIES[7]} format={moneyCompact} /> : <EmptyState title="No losses recorded" />}</CardBody>
        </Card>
      </div>

      <Card className="mfr-profit-card">
        <CardHeader title="Batch-level profitability" subtitle="Delivered revenue per batch, net of refunds and losses: the project's granular cost-analysis objective" />
        <DataTable bare rows={m.perBatch} columns={batchCols} rowKey={(x) => x.b.batch_id} initialSort={{ key: 'net', dir: 'desc' }} exportName="lethe-batch-profitability" exportRow={(x) => ({ batch: x.b.batch_number, medicine: L.medOf(x.b)?.brand_name, units_delivered: x.units, revenue: x.revenue, refunds: x.refunds, losses: x.losses, net: x.net })} />
      </Card>

      <Card className="mfr-ledger-card">
        <CardHeader title="Payment ledger" subtitle="Invoices auto-generated when a delivery is signed for in good or partial condition" />
        <DataTable bare rows={m.payments} columns={payCols} rowKey={(p) => p.payment_id} searchText={(p) => `${p.order_id} ${L.orgName(p.payer_org_id)} ${p.payment_status}`} initialSort={{ key: 'date', dir: 'desc' }} exportName="lethe-payments" exportRow={(p) => ({ payment_id: p.payment_id, order_id: p.order_id, payer: L.orgName(p.payer_org_id), base: p.base_amount, tax_pct: p.tax_percentage, total: p.total_transaction_amount, status: p.payment_status, date: p.created_at_utc })} />
      </Card>

      <Callout tone="neutral" className="mfr-revenue-note" title="Where these numbers come from">
        <code className="mfr-code">tr_auto_generate_invoice</code> writes the payment ledger, <code className="mfr-code">tr_log_disposal_loss</code> books disposal losses, and generated columns compute totals and net revenue. The frontend only reads them.
      </Callout>

      <GenerateReport open={generating} onClose={() => setGenerating(false)} />
    </>
  )
}
