import { useMemo, useState } from 'react'
import { CheckCircle2, Clock, PackageCheck, Snowflake, Truck, XCircle } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, FormGrid, Input, Select } from '@/components/ui/Form'
import { ConfirmDialog, Drawer, Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { Stepper } from '@/components/ui/Stepper'
import { MANIFEST_STATUS, ORDER_FLOW, ORDER_STATUS, isColdChain } from '@/lib/domain'
import { date, dateTime, daysUntil, money, num, relative } from '@/lib/format'
import type { OrderItem, OrderStatus, SalesOrder } from '@/lib/types'

/** Plan which storage locations each order line draws from (largest stock first). */
function usePickPlan(items: OrderItem[]) {
  const { data } = useTables(['inventory'] as const)
  return useMemo(() => {
    const left = new Map(data.inventory.map((i) => [i.inventory_id, i.available_quantity]))
    const plan: { item: OrderItem; draws: { location_id: number; qty: number }[]; short: number }[] = []
    for (const item of items) {
      const sources = data.inventory.filter((i) => i.batch_id === item.batch_id && (left.get(i.inventory_id) ?? 0) > 0).sort((a, b) => (left.get(b.inventory_id) ?? 0) - (left.get(a.inventory_id) ?? 0))
      let need = item.quantity
      const draws: { location_id: number; qty: number }[] = []
      for (const s of sources) {
        if (need <= 0) break
        const take = Math.min(need, left.get(s.inventory_id) ?? 0)
        if (take > 0) {
          draws.push({ location_id: s.location_id, qty: take })
          left.set(s.inventory_id, (left.get(s.inventory_id) ?? 0) - take)
          need -= take
        }
      }
      plan.push({ item, draws, short: Math.max(0, need) })
    }
    return plan
  }, [items, data.inventory])
}

function DispatchModal({ order, items, onClose }: { order: SalesOrder | null; items: OrderItem[]; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const t = useTables(['vehicles', 'manifests', 'users', 'organisations', 'orders'] as const)
  const { run, busy } = useRunner()
  const plan = usePickPlan(items)
  const tomorrow = new Date(Date.now() + 26 * 3600 * 1000)
  const [vehicleId, setVehicleId] = useState('')
  const [driverId, setDriverId] = useState('')
  const [eta, setEta] = useState(() => new Date(tomorrow.getTime() - tomorrow.getTimezoneOffset() * 60000).toISOString().slice(0, 16))

  if (!order) return null
  const needsReefer = items.some((i) => isColdChain(L.pkgOfBatch(i.batch_id)))
  const shippedOrders = new Set(t.data.orders.filter((o) => o.order_status === 'Shipped').map((o) => o.order_id))
  const busyVehicles = new Set(t.data.manifests.filter((m) => m.manifest_status !== 'Delivered' && shippedOrders.has(m.order_id)).map((m) => m.vehicle_id))
  const transporterOrgs = new Set(t.data.organisations.filter((o) => o.org_type === 'Transporter').map((o) => o.org_id))
  const drivers = t.data.users.filter((u) => u.is_active && u.org_id && transporterOrgs.has(u.org_id))
  const short = plan.filter((p) => p.short > 0)
  const vehicle = t.data.vehicles.find((v) => String(v.vehicle_id) === vehicleId)
  const etaOk = new Date(eta).getTime() > Date.now()
  const valid = vehicle && driverId && etaOk && short.length === 0 && items.length > 0 && (!needsReefer || vehicle.vehicle_type === 'Reefer')

  const submit = async () => {
    const r = await run(
      'dispatch',
      async () => {
        const moves = plan.flatMap((p) => p.draws.map((d) => ({ batch_id: p.item.batch_id, source_location_id: d.location_id, destination_location_id: null, user_id: profile.user_id, quantity_moved: d.qty, movement_type: 'Outbound' })))
        if (moves.length) {
          const { error } = await db('warehouse').from('stock_movement_history').insert(moves)
          if (error) throw error
        }
        const { error: e2 } = await db('fulfillment')
          .from('shipping_manifest')
          .insert({ order_id: order.order_id, vehicle_id: vehicle!.vehicle_id, driver_user_id: driverId, dispatch_time_utc: new Date().toISOString(), estimated_arrival_time: new Date(eta).toISOString(), manifest_status: 'In-Transit' })
        if (e2) throw e2
        await logEvent(profile.user_id, 'SHIPMENT_DISPATCHED', 'FORWARD_FULFILLMENT', { order_id: order.order_id, vehicle: vehicle!.vehicle_no, driver_user_id: driverId, eta, cold_chain: needsReefer, units: items.reduce((s, i) => s + i.quantity, 0), severity: 'LOW' })
      },
      { success: `Order #${order.order_id} dispatched`, description: 'Stock picked from inventory; tr_auto_status_shipped set the order to Shipped.' },
    )
    if (r.ok) onClose()
  }

  return (
    <Modal
      open
      onClose={onClose}
      size="lg"
      icon={Truck}
      title={`Dispatch order #${order.order_id}`}
      description={`To ${L.orgName(order.buyer_org_id)} · expected ${date(order.expected_del_date)}`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Truck} disabled={!valid} loading={busy === 'dispatch'} onClick={submit}>
            Dispatch shipment
          </Button>
        </>
      }
    >
      <div className="space-y-4">
        {needsReefer && (
          <Callout tone="info" icon={Snowflake} title="Cold-chain shipment">
            At least one line needs 2–8°C storage. Only refrigerated (Reefer) vehicles can be selected.
          </Callout>
        )}
        <FormGrid>
          <Field label="Vehicle" required>
            <Select value={vehicleId} onChange={(e) => setVehicleId(e.target.value)}>
              <option value="">Choose a vehicle…</option>
              {t.data.vehicles.map((v) => {
                const blocked = needsReefer && v.vehicle_type !== 'Reefer'
                return (
                  <option key={v.vehicle_id} value={v.vehicle_id} disabled={blocked}>
                    {v.vehicle_no} · {v.vehicle_type} · {L.orgName(v.transporter_org_id)}
                    {busyVehicles.has(v.vehicle_id) ? ' · on a trip' : ''}
                    {blocked ? ' · not refrigerated' : ''}
                  </option>
                )
              })}
            </Select>
          </Field>
          <Field label="Driver" required>
            <Select value={driverId} onChange={(e) => setDriverId(e.target.value)}>
              <option value="">Choose a driver…</option>
              {drivers.map((u) => (
                <option key={u.user_id} value={u.user_id}>
                  {u.first_name} {u.last_name} · {L.orgName(u.org_id)}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Estimated arrival" required error={!etaOk ? 'Must be in the future.' : undefined}>
            <Input type="datetime-local" value={eta} onChange={(e) => setEta(e.target.value)} />
          </Field>
        </FormGrid>
        <div>
          <p className="mb-2 text-[13px] font-medium text-ink">Pick list</p>
          <div className="space-y-2">
            {plan.map((p) => (
              <div key={p.item.order_item_id} className="rounded-xl border border-line px-3 py-2.5">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <span className="text-[13px]">
                    <Code>{L.batchNo(p.item.batch_id)}</Code> <span className="text-ink-2">{L.medName(p.item.batch_id)}</span>
                  </span>
                  <span className="text-[13px] font-semibold text-ink tabular">{num(p.item.quantity)} units</span>
                </div>
                <div className="mt-1.5 flex flex-wrap gap-1.5">
                  {p.draws.map((d) => (
                    <Badge key={d.location_id} tone="info">
                      {num(d.qty)} from {L.locLabel(d.location_id)}
                    </Badge>
                  ))}
                  {p.short > 0 && <Badge tone="critical">Short by {num(p.short)}</Badge>}
                </div>
              </div>
            ))}
            {items.length === 0 && <Callout tone="warn">This order has no line items, so there is nothing to ship.</Callout>}
          </div>
        </div>
      </div>
    </Modal>
  )
}

type Filter = OrderStatus | 'all' | 'open'

export function Fulfillment() {
  const profile = useProfile()
  const L = useLookups()
  const t = useTables(['orders', 'orderItems', 'manifests', 'receipts', 'inventory'] as const)
  const { run, busy } = useRunner()
  const [filter, setFilter] = useState<Filter>('open')
  const [openId, setOpenId] = useState<number | null>(null)
  const [dispatching, setDispatching] = useState<SalesOrder | null>(null)
  const [cancelling, setCancelling] = useState<SalesOrder | null>(null)

  const model = useMemo(() => {
    const d = t.data
    const stock = new Map<number, number>()
    for (const i of d.inventory) stock.set(i.batch_id, (stock.get(i.batch_id) ?? 0) + i.available_quantity)
    return d.orders.map((o) => {
      const items = d.orderItems.filter((i) => i.order_id === o.order_id)
      const value = items.reduce((s, i) => s + i.quantity * Number(i.unit_price), 0)
      const manifest = d.manifests.find((m) => m.order_id === o.order_id)
      const receipt = d.receipts.find((r) => r.order_id === o.order_id)
      const covered = items.every((i) => (stock.get(i.batch_id) ?? 0) >= i.quantity)
      const cold = items.some((i) => isColdChain(L.pkgOfBatch(i.batch_id)))
      const overdue = (o.order_status === 'Pending' || o.order_status === 'Approved' || o.order_status === 'Shipped') && o.expected_del_date != null && daysUntil(o.expected_del_date) < 0
      return { o, items, value, manifest, receipt, covered, cold, overdue }
    })
  }, [t.data, L])

  type Row = (typeof model)[number]
  const match = (r: Row, f: Filter) => (f === 'all' ? true : f === 'open' ? ['Pending', 'Approved', 'Shipped'].includes(r.o.order_status) : r.o.order_status === f)
  const rows = model.filter((r) => match(r, filter))
  const open = model.find((r) => r.o.order_id === openId)

  const setStatus = (o: SalesOrder, status: OrderStatus) =>
    run(
      `order-${o.order_id}`,
      async () => {
        await mustChange(db('fulfillment').from('sales_orders').update({ order_status: status, updated_at_utc: new Date().toISOString() }).eq('order_id', o.order_id).select('order_id'))
        await logEvent(profile.user_id, status === 'Approved' ? 'ORDER_APPROVED' : 'ORDER_CANCELLED', 'FORWARD_FULFILLMENT', { order_id: o.order_id, buyer: L.orgName(o.buyer_org_id), severity: status === 'Cancelled' ? 'MEDIUM' : 'LOW' })
      },
      { success: `Order #${o.order_id} ${status.toLowerCase()}` },
    )

  const setManifest = (manifestId: number, orderId: number, status: 'Delayed' | 'In-Transit') =>
    run(
      `manifest-${manifestId}`,
      async () => {
        await mustChange(db('fulfillment').from('shipping_manifest').update({ manifest_status: status }).eq('manifest_id', manifestId).select('manifest_id'))
        await logEvent(profile.user_id, status === 'Delayed' ? 'SHIPMENT_DELAYED' : 'SHIPMENT_BACK_ON_SCHEDULE', 'FORWARD_FULFILLMENT', { manifest_id: manifestId, order_id: orderId, severity: status === 'Delayed' ? 'MEDIUM' : 'LOW' })
      },
      { success: status === 'Delayed' ? 'Shipment flagged as delayed' : 'Shipment back on schedule' },
    )

  const actions = (r: Row) => {
    if (r.o.order_status === 'Pending')
      return (
        <div className="flex gap-1" onClick={(e) => e.stopPropagation()}>
          <Button size="xs" variant="success" icon={CheckCircle2} disabled={!r.items.length} loading={busy === `order-${r.o.order_id}`} onClick={() => void setStatus(r.o, 'Approved')} title={!r.items.length ? 'Order has no lines' : undefined}>
            Approve
          </Button>
          <Button size="xs" variant="ghost" icon={XCircle} onClick={() => setCancelling(r.o)}>
            Cancel
          </Button>
        </div>
      )
    if (r.o.order_status === 'Approved')
      return (
        <div onClick={(e) => e.stopPropagation()}>
          <Button size="xs" variant="primary" icon={Truck} onClick={() => setDispatching(r.o)}>
            Dispatch
          </Button>
        </div>
      )
    if (r.o.order_status === 'Shipped' && r.manifest)
      return (
        <div onClick={(e) => e.stopPropagation()}>
          {r.manifest.manifest_status === 'Delayed' ? (
            <Button size="xs" variant="ghost" icon={Clock} loading={busy === `manifest-${r.manifest.manifest_id}`} onClick={() => void setManifest(r.manifest!.manifest_id, r.o.order_id, 'In-Transit')}>
              Back on time
            </Button>
          ) : (
            <Button size="xs" variant="ghost" icon={Clock} loading={busy === `manifest-${r.manifest.manifest_id}`} onClick={() => void setManifest(r.manifest!.manifest_id, r.o.order_id, 'Delayed')}>
              Flag delay
            </Button>
          )}
        </div>
      )
    return <span className="text-xs text-muted">{r.o.order_status === 'Shipped' ? 'Awaiting signature' : '—'}</span>
  }

  const cols: Column<Row>[] = [
    { key: 'id', header: 'Order', sort: (r) => r.o.order_id, cell: (r) => <span className="font-semibold tabular">#{r.o.order_id}</span> },
    { key: 'buyer', header: 'Retailer', sort: (r) => L.orgName(r.o.buyer_org_id), cell: (r) => <span className="text-[13px]">{L.orgName(r.o.buyer_org_id)}</span> },
    { key: 'lines', header: 'Lines', align: 'right', sort: (r) => r.items.length, cell: (r) => <span className="text-ink-2">{r.items.length}</span>, hideBelow: 'md' },
    { key: 'value', header: 'Value', align: 'right', sort: (r) => r.value, cell: (r) => money(r.value) },
    {
      key: 'flags',
      header: 'Checks',
      cell: (r) => (
        <div className="flex flex-wrap gap-1">
          {r.cold && <Badge tone="info" icon={Snowflake}>Cold</Badge>}
          {['Pending', 'Approved'].includes(r.o.order_status) && (r.items.length === 0 ? <Badge tone="warn">No lines</Badge> : r.covered ? <Badge tone="good" dot>Stock OK</Badge> : <Badge tone="critical" dot>Short</Badge>)}
          {r.overdue && <Badge tone="serious" icon={Clock}>Overdue</Badge>}
        </div>
      ),
      hideBelow: 'lg',
    },
    { key: 'expected', header: 'Expected', sort: (r) => r.o.expected_del_date ?? '', cell: (r) => <span className="text-[13px] text-ink-2 tabular">{date(r.o.expected_del_date)}</span>, hideBelow: 'md' },
    { key: 'status', header: 'Status', sort: (r) => ORDER_FLOW.indexOf(r.o.order_status), cell: (r) => <div className="flex flex-col items-start gap-1"><StatusBadge value={r.o.order_status} meta={ORDER_STATUS} />{r.manifest && r.o.order_status === 'Shipped' && <StatusBadge value={r.manifest.manifest_status} meta={MANIFEST_STATUS} />}</div> },
    { key: 'act', header: 'Action', cell: actions },
  ]

  const count = (f: Filter) => model.filter((r) => match(r, f)).length

  return (
    <>
      <PageHeader />
      <div className="mb-4">
        <Segmented<Filter>
          value={filter}
          onChange={setFilter}
          options={[
            { value: 'open', label: 'Open', count: count('open') },
            { value: 'Pending', label: 'Needs approval', count: count('Pending') },
            { value: 'Approved', label: 'Ready to dispatch', count: count('Approved') },
            { value: 'Shipped', label: 'In transit', count: count('Shipped') },
            { value: 'Delivered', label: 'Delivered', count: count('Delivered') },
            { value: 'Cancelled', label: 'Cancelled', count: count('Cancelled') },
            { value: 'all', label: 'All', count: count('all') },
          ]}
        />
      </div>
      <DataTable
        rows={rows}
        columns={cols}
        rowKey={(r) => r.o.order_id}
        loading={t.isLoading}
        searchText={(r) => `${r.o.order_id} ${L.orgName(r.o.buyer_org_id)}`}
        onRowClick={(r) => setOpenId(r.o.order_id)}
        initialSort={{ key: 'id', dir: 'desc' }}
        pageSize={12}
        emptyTitle="No orders in this stage"
        exportName="lethe-orders"
        exportRow={(r) => ({ order_id: r.o.order_id, retailer: L.orgName(r.o.buyer_org_id), status: r.o.order_status, lines: r.items.length, value: r.value, order_date: r.o.order_date, expected: r.o.expected_del_date })}
      />

      <Drawer open={!!open} onClose={() => setOpenId(null)} title={open ? `Order #${open.o.order_id}` : ''} subtitle={open ? `${L.orgName(open.o.buyer_org_id)} · placed ${date(open.o.order_date)}` : ''} actions={open && actions(open)}>
        {open && (
          <div className="space-y-4">
            <Card>
              <CardBody className="pt-5">
                <Stepper steps={ORDER_FLOW} current={open.o.order_status === 'Cancelled' ? 'Pending' : open.o.order_status} failed={open.o.order_status === 'Cancelled'} />
                {open.o.order_status === 'Cancelled' && <Callout tone="neutral" className="mt-4">This order was cancelled.</Callout>}
              </CardBody>
            </Card>
            <Card>
              <CardHeader title="Order lines" subtitle={`${open.items.length} lines · ${money(open.value)}`} />
              <div className="divide-y divide-line border-t border-line">
                {open.items.map((i) => (
                  <div key={i.order_item_id} className="flex flex-wrap items-center justify-between gap-2 px-5 py-3">
                    <div>
                      <Code>{L.batchNo(i.batch_id)}</Code> <span className="text-[13px] text-ink-2">{L.medName(i.batch_id)}</span>
                      {isColdChain(L.pkgOfBatch(i.batch_id)) && <Badge tone="info" icon={Snowflake} className="ml-2">Cold</Badge>}
                    </div>
                    <span className="text-[13px] text-ink tabular">
                      {num(i.quantity)} × {money(i.unit_price)} = <b>{money(i.quantity * Number(i.unit_price))}</b>
                    </span>
                  </div>
                ))}
                {open.items.length === 0 && <p className="px-5 py-4 text-[13px] text-ink-2">No lines on this order.</p>}
              </div>
            </Card>
            {open.manifest && (
              <Card>
                <CardHeader title="Shipment" icon={Truck} actions={<StatusBadge value={open.manifest.manifest_status} meta={MANIFEST_STATUS} />} />
                <CardBody className="grid grid-cols-2 gap-3 text-[13px]">
                  <div><p className="text-muted">Vehicle</p><p className="text-ink">{L.vehicle.get(open.manifest.vehicle_id)?.vehicle_no} ({L.vehicle.get(open.manifest.vehicle_id)?.vehicle_type})</p></div>
                  <div><p className="text-muted">Driver</p><p className="text-ink">{L.userName(open.manifest.driver_user_id)}</p></div>
                  <div><p className="text-muted">Dispatched</p><p className="text-ink">{dateTime(open.manifest.dispatch_time_utc)}</p></div>
                  <div><p className="text-muted">ETA</p><p className="text-ink">{open.manifest.estimated_arrival_time ? `${dateTime(open.manifest.estimated_arrival_time)} (${relative(open.manifest.estimated_arrival_time)})` : '—'}</p></div>
                </CardBody>
              </Card>
            )}
            {open.receipt && (
              <Card>
                <CardHeader title="Proof of delivery" icon={PackageCheck} actions={<Badge tone={open.receipt.received_condition === 'Good' ? 'good' : 'serious'}>{open.receipt.received_condition}</Badge>} />
                <CardBody className="space-y-1 text-[13px]">
                  <p className="text-ink">Signed by {L.userName(open.receipt.received_by_user_id)} · {dateTime(open.receipt.delivery_time)}</p>
                  {open.receipt.remarks && <p className="text-ink-2">“{open.receipt.remarks}”</p>}
                  <p className="font-mono text-xs break-all text-muted">{open.receipt.digital_signature}</p>
                </CardBody>
              </Card>
            )}
          </div>
        )}
      </Drawer>

      <DispatchModal key={dispatching?.order_id ?? "none"} order={dispatching} items={dispatching ? model.find((r) => r.o.order_id === dispatching.order_id)?.items ?? [] : []} onClose={() => setDispatching(null)} />
      <ConfirmDialog
        open={!!cancelling}
        onClose={() => setCancelling(null)}
        danger
        icon={XCircle}
        title={`Cancel order #${cancelling?.order_id}?`}
        confirmLabel="Cancel order"
        loading={busy === `order-${cancelling?.order_id}`}
        onConfirm={async () => {
          if (!cancelling) return
          const r = await setStatus(cancelling, 'Cancelled')
          if (r.ok) setCancelling(null)
        }}
      >
        The retailer will see the order as cancelled. This is recorded in the audit ledger.
      </ConfirmDialog>
    </>
  )
}
