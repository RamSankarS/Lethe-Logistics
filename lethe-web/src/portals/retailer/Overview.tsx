import { useMemo } from 'react'
import { useNavigate } from 'react-router'
import { BellRing, IndianRupee, PackageCheck, ShoppingCart, Siren, Truck, Undo2, Wallet } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState } from '@/components/ui/Feedback'
import { SegmentedBar } from '@/components/ui/Progress'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { Stepper } from '@/components/ui/Stepper'
import { MANIFEST_STATUS, ORDER_FLOW, ORDER_STATUS } from '@/lib/domain'
import { date, money, moneyCompact, num, relative } from '@/lib/format'
import { useRetailerModel } from './shared'

export function Overview() {
  const profile = useProfile()
  const navigate = useNavigate()
  const L = useLookups()
  const m = useRetailerModel()
  const { run, busy } = useRunner()

  const s = useMemo(() => {
    const open = m.orders.filter((x) => ['Pending', 'Approved', 'Shipped'].includes(x.o.order_status))
    const arriving = m.orders.filter((x) => x.o.order_status === 'Shipped')
    const spend = m.payments.filter((p) => p.payment_status === 'Completed').reduce((a, p) => a + Number(p.total_transaction_amount), 0)
    const pendingRefund = m.returns.filter((x) => x.v?.refund_status === 'Pending_Payout').reduce((a, x) => a + Number(x.v!.refund_amount), 0)
    const refunded = m.returns.filter((x) => x.v?.refund_status === 'Processed').reduce((a, x) => a + Number(x.v!.refund_amount), 0)
    const openReturns = m.returns.filter((x) => x.r.status !== 'Closed')
    // Recall alerts: active recalls that notified me and I have not acknowledged, or that hit batches I received
    const alerts = m.activeRecalls
      .map((rc) => {
        const mine = m.notices.filter((n) => n.recall_id === rc.recall_id)
        const acked = mine.some((n) => n.delivery_status === 'Read')
        const held = m.received.get(rc.batch_id)
        return { rc, mine, acked, held }
      })
      .filter((a) => a.mine.length > 0 || a.held)
    const byStatus = (st: string) => m.orders.filter((x) => x.o.order_status === st).length
    return { open, arriving, spend, pendingRefund, refunded, openReturns, alerts, byStatus }
  }, [m])

  const acknowledge = (recallId: number) =>
    run(
      `ack-${recallId}`,
      async () => {
        await mustChange(db('reverse').from('recall_communication_logs').update({ delivery_status: 'Read' }).eq('recall_id', recallId).eq('notified_org_id', profile.org!.org_id).neq('delivery_status', 'Read').select('log_id'))
        await logEvent(profile.user_id, 'RECALL_ACKNOWLEDGED', 'REVERSE_LOGISTICS', { recall_id: recallId, org: profile.org!.org_name, severity: 'LOW' })
      },
      { success: 'Recall notice acknowledged' },
    )

  return (
    <>
      <PageHeader
        title={`Welcome back, ${profile.first_name}`}
        description={`${profile.org?.org_name} · your orders, deliveries and returns`}
        actions={
          <Button variant="primary" icon={ShoppingCart} onClick={() => navigate('/retailer/orders?new=1')}>
            New purchase order
          </Button>
        }
      />

      {s.alerts.length > 0 && (
        <div className="mb-5 space-y-3">
          {s.alerts.map((a) => (
            <Callout
              key={a.rc.recall_id}
              tone="critical"
              icon={Siren}
              title={`Recall #${a.rc.recall_id}: ${L.medName(a.rc.batch_id)} batch ${L.batchNo(a.rc.batch_id)}`}
              action={
                <div className="flex flex-col gap-1.5 sm:flex-row">
                  {!a.acked && a.mine.length > 0 && (
                    <Button size="sm" icon={BellRing} loading={busy === `ack-${a.rc.recall_id}`} onClick={() => void acknowledge(a.rc.recall_id)}>
                      Acknowledge
                    </Button>
                  )}
                  <Button size="sm" variant="danger" icon={Undo2} onClick={() => navigate(`/retailer/recalls`)}>
                    Act on recall
                  </Button>
                </div>
              }
            >
              {a.rc.recall_reason}
              {a.held && (
                <span className="mt-1 block font-medium text-critical-text">
                  Your pharmacy received {num(a.held.qty)} units of this batch (order {a.held.orders.map((o) => `#${o}`).join(', ')}). Return them.
                </span>
              )}
              {a.acked && <span className="mt-1 block text-xs">Acknowledged</span>}
            </Callout>
          ))}
        </div>
      )}

      <StatGrid>
        <Stat label="Open orders" value={num(s.open.length)} sub={`${m.orders.length} orders placed in total`} icon={ShoppingCart} loading={m.isLoading} onClick={() => navigate('/retailer/orders')} />
        <Stat label="Arriving" value={num(s.arriving.length)} sub="shipped, awaiting your signature" icon={Truck} tone="info" loading={m.isLoading} onClick={() => navigate('/retailer/receiving')} />
        <Stat label="Delivered" value={num(m.delivered.length)} sub="orders signed for" icon={PackageCheck} tone="good" loading={m.isLoading} />
        <Stat label="Total spend" value={moneyCompact(s.spend)} sub="completed invoices incl. tax" icon={Wallet} loading={m.isLoading} />
        <Stat label="Refunds pending" value={moneyCompact(s.pendingRefund)} sub={`${moneyCompact(s.refunded)} already paid out`} icon={IndianRupee} tone="warn" loading={m.isLoading} onClick={() => navigate('/retailer/returns')} />
        <Stat label="Open returns" value={num(s.openReturns.length)} sub="in reverse logistics" icon={Undo2} tone="serious" loading={m.isLoading} onClick={() => navigate('/retailer/returns')} />
      </StatGrid>

      <div className="mt-5 grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Recent orders" subtitle="Where each purchase order is in the flow" actions={<Button size="sm" variant="ghost" onClick={() => navigate('/retailer/orders')}>All orders</Button>} />
          <CardBody className="space-y-3">
            {m.orders.length === 0 && <EmptyState icon={ShoppingCart} title="No orders yet" />}
            {m.orders.slice(0, 5).map((x) => (
              <div key={x.o.order_id} className="rounded-xl border border-line p-3.5">
                <div className="mb-3 flex flex-wrap items-center justify-between gap-2">
                  <div className="flex items-center gap-2">
                    <span className="text-[14px] font-semibold text-ink tabular">Order #{x.o.order_id}</span>
                    <StatusBadge value={x.o.order_status} meta={ORDER_STATUS} />
                  </div>
                  <span className="text-[12.5px] text-ink-2">
                    {x.items.length} lines · {money(x.value)} · expected {date(x.o.expected_del_date)}
                  </span>
                </div>
                <Stepper steps={ORDER_FLOW} current={x.o.order_status === 'Cancelled' ? 'Pending' : x.o.order_status} failed={x.o.order_status === 'Cancelled'} />
              </div>
            ))}
          </CardBody>
        </Card>

        <div className="space-y-5 xl:col-span-2">
          <Card>
            <CardHeader title="Order mix" subtitle="All purchase orders by status" />
            <CardBody>
              <SegmentedBar
                parts={[
                  { key: 'Delivered', label: 'Delivered', value: s.byStatus('Delivered'), color: 'var(--good)' },
                  { key: 'Shipped', label: 'Shipped', value: s.byStatus('Shipped'), color: 'var(--info)' },
                  { key: 'Approved', label: 'Approved', value: s.byStatus('Approved'), color: 'var(--series-7)' },
                  { key: 'Pending', label: 'Pending', value: s.byStatus('Pending'), color: 'var(--warn)', darkText: true },
                  { key: 'Cancelled', label: 'Cancelled', value: s.byStatus('Cancelled'), color: 'var(--muted)' },
                ]}
              />
            </CardBody>
          </Card>
          <Card>
            <CardHeader title="On the road" subtitle="Shipments heading to your pharmacy" icon={Truck} />
            <CardBody className="space-y-2">
              {s.arriving.length === 0 && <p className="text-[13px] text-ink-2">Nothing in transit right now.</p>}
              {s.arriving.map((x) => (
                <button key={x.o.order_id} onClick={() => navigate('/retailer/receiving')} className="flex w-full items-center justify-between gap-2 rounded-xl bg-surface-2 px-3 py-2.5 text-left hover:bg-surface-3">
                  <span>
                    <span className="block text-[13px] font-medium text-ink">Order #{x.o.order_id}</span>
                    <span className="block text-xs text-ink-2">
                      {x.manifest ? `${L.vehicle.get(x.manifest.vehicle_id)?.vehicle_no} · ETA ${x.manifest.estimated_arrival_time ? relative(x.manifest.estimated_arrival_time) : 'n/a'}` : 'Awaiting manifest'}
                    </span>
                  </span>
                  {x.manifest ? <StatusBadge value={x.manifest.manifest_status} meta={MANIFEST_STATUS} /> : <Badge>—</Badge>}
                </button>
              ))}
            </CardBody>
          </Card>
          {m.returns.length > 0 && (
            <Card>
              <CardHeader title="Latest return" icon={Undo2} />
              <CardBody>
                {(() => {
                  const x = m.returns[0]
                  return (
                    <div className="text-[13px]">
                      <p className="font-medium text-ink">
                        Return #{x.r.return_id} · <Code>{L.batchNo(x.r.batch_id)}</Code>
                      </p>
                      <p className="mt-0.5 text-ink-2">
                        {num(x.r.quantity_returned)} units · {x.r.status.replace('_', ' ')} {x.v ? `· refund ${money(x.v.refund_amount)}` : ''}
                      </p>
                    </div>
                  )
                })()}
              </CardBody>
            </Card>
          )}
        </div>
      </div>
    </>
  )
}
