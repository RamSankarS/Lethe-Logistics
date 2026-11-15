import { useMemo, useState } from 'react'
import { useSearchParams } from 'react-router'
import { Minus, Plus, ShoppingCart, Snowflake, Trash2, XCircle } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { useReferencePrice } from '@/data/pricing'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input } from '@/components/ui/Form'
import { ConfirmDialog, Drawer, Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { Stepper } from '@/components/ui/Stepper'
import { MANIFEST_STATUS, ORDER_FLOW, ORDER_STATUS, PAYMENT_STATUS, isColdChain, isSellable } from '@/lib/domain'
import { date, dateTime, money, money2, num, relative, todayISO } from '@/lib/format'
import type { OrderStatus } from '@/lib/types'
import { useRetailerModel } from './shared'

interface CatalogEntry {
  medicineId: number
  brand: string
  generic: string
  category: string
  cold: boolean
  available: number
  price: number
  batches: { batchId: number; expiry: string; stock: number }[]
}

/** Released, unexpired batches with stock, grouped by medicine, earliest expiry first (FEFO). */
function useCatalog() {
  const L = useLookups()
  const { data } = useTables(['batches', 'inventory', 'medicines'] as const)
  const price = useReferencePrice()
  return useMemo(() => {
    const stock = new Map<number, number>()
    for (const i of data.inventory) stock.set(i.batch_id, (stock.get(i.batch_id) ?? 0) + i.available_quantity)
    const out: CatalogEntry[] = []
    for (const med of data.medicines.filter((m) => m.is_active)) {
      const batches = data.batches
        .filter((b) => b.medicine_id === med.medicine_id && isSellable(b) && (stock.get(b.batch_id) ?? 0) > 0)
        .sort((a, b) => a.expiry_date.localeCompare(b.expiry_date))
        .map((b) => ({ batchId: b.batch_id, expiry: b.expiry_date, stock: stock.get(b.batch_id) ?? 0 }))
      if (!batches.length) continue
      out.push({
        medicineId: med.medicine_id,
        brand: med.brand_name,
        generic: med.generic_name,
        category: med.category,
        cold: isColdChain(L.pkgByMed.get(med.medicine_id)),
        available: batches.reduce((s, b) => s + b.stock, 0),
        price: price.forMedicine(med.medicine_id),
        batches,
      })
    }
    return out
  }, [data, L.pkgByMed, price])
}

function NewOrder({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const catalog = useCatalog()
  const price = useReferencePrice()
  const { run, busy } = useRunner()
  const [cart, setCart] = useState<Record<number, number>>({})
  const [expected, setExpected] = useState(todayISO(3))

  const lines = catalog.filter((c) => (cart[c.medicineId] ?? 0) > 0)
  const set = (id: number, q: number, max: number) => setCart((p) => ({ ...p, [id]: Math.max(0, Math.min(max, Math.round(q) || 0)) }))
  // FEFO split per medicine into batch-level order lines
  const allocation = lines.flatMap((c) => {
    let need = cart[c.medicineId]
    const parts: { batchId: number; qty: number; unit: number; brand: string }[] = []
    for (const b of c.batches) {
      if (need <= 0) break
      const take = Math.min(need, b.stock)
      parts.push({ batchId: b.batchId, qty: take, unit: price(b.batchId), brand: c.brand })
      need -= take
    }
    return parts
  })
  const subtotal = allocation.reduce((s, a) => s + a.qty * a.unit, 0)
  const dateOk = expected > todayISO(0)
  const valid = allocation.length > 0 && dateOk

  const submit = async () => {
    const r = await run(
      'po',
      async () => {
        const { data: order, error } = await db('fulfillment')
          .from('sales_orders')
          .insert({ buyer_org_id: profile.org!.org_id, order_date: todayISO(0), order_status: 'Pending', expected_del_date: expected })
          .select('order_id')
          .single()
        if (error) throw error
        const orderId = (order as { order_id: number }).order_id
        const { error: e2 } = await db('fulfillment')
          .from('order_items')
          .insert(allocation.map((a) => ({ order_id: orderId, batch_id: a.batchId, quantity: a.qty, unit_price: a.unit })))
        if (e2) {
          await db('fulfillment').from('sales_orders').delete().eq('order_id', orderId)
          throw e2
        }
        await logEvent(profile.user_id, 'ORDER_PLACED', 'FORWARD_FULFILLMENT', { order_id: orderId, lines: allocation.length, units: allocation.reduce((s, a) => s + a.qty, 0), value: subtotal, severity: 'LOW' })
      },
      { success: 'Purchase order placed', description: 'Every line passed the database safety gate (released batch, stock available).' },
    )
    if (r.ok) {
      setCart({})
      onClose()
    }
  }

  return (
    <Modal
      open={open}
      onClose={onClose}
      size="xl"
      icon={ShoppingCart}
      title="New purchase order"
      description="Order by medicine. Lethe allocates the earliest-expiring released batches first (FEFO)."
      footer={
        <>
          <span className="mr-auto text-[13px] text-ink-2">
            Subtotal <b className="text-ink tabular">{money2(subtotal)}</b> · +5% GST on invoice
          </span>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={ShoppingCart} disabled={!valid} loading={busy === 'po'} onClick={submit}>
            Place order
          </Button>
        </>
      }
    >
      <div className="grid gap-5 lg:grid-cols-[1fr_320px]">
        <div className="space-y-2">
          {catalog.length === 0 && <EmptyState title="No released stock available" />}
          {catalog.map((c) => {
            const q = cart[c.medicineId] ?? 0
            return (
              <div key={c.medicineId} className={`grid grid-cols-1 items-center gap-3 rounded-xl border px-3.5 py-3 sm:grid-cols-[minmax(0,1fr)_auto] ${q ? 'border-accent bg-accent-soft' : 'border-line'}`}>
                <div className="min-w-0">
                  <p className="flex items-center gap-2 text-[13.5px] font-semibold text-ink">
                    {c.brand}
                    {c.cold && <Badge tone="info" icon={Snowflake}>Cold</Badge>}
                  </p>
                  <p className="text-xs text-ink-2">
                    {c.generic} · {c.category} · {money(c.price)}/unit · {num(c.available)} available
                  </p>
                </div>
                <div className="flex items-center gap-1.5">
                  <Button size="sm" variant="secondary" icon={Minus} aria-label="Less" onClick={() => set(c.medicineId, q - 50, c.available)} disabled={q <= 0} />
                  <Input type="number" min={0} max={c.available} value={q || ''} placeholder="0" onChange={(e) => set(c.medicineId, Number(e.target.value), c.available)} className="h-8 w-24 text-center tabular" />
                  <Button size="sm" variant="secondary" icon={Plus} aria-label="More" onClick={() => set(c.medicineId, q + 50, c.available)} disabled={q >= c.available} />
                </div>
              </div>
            )
          })}
        </div>
        <div className="space-y-4">
          <Field label="Expected delivery" required error={!dateOk ? 'Must be after today.' : undefined}>
            <Input type="date" min={todayISO(1)} value={expected} onChange={(e) => setExpected(e.target.value)} />
          </Field>
          <Card className="shadow-none">
            <CardHeader
              title="Batch allocation"
              subtitle="FEFO: first expiry, first out"
              actions={allocation.length > 0 && <Button size="xs" variant="ghost" icon={Trash2} onClick={() => setCart({})}>Clear</Button>}
            />
            <CardBody className="space-y-2">
              {allocation.length === 0 && <p className="text-[13px] text-ink-2">Add quantities to see which batches will be shipped.</p>}
              {allocation.map((a) => (
                <div key={a.batchId} className="flex items-center justify-between gap-2 text-[12.5px]">
                  <span className="min-w-0">
                    <Code>{num(a.qty)}</Code> <span className="text-ink-2">{a.brand}</span>
                  </span>
                  <span className="text-ink tabular">{money(a.qty * a.unit)}</span>
                </div>
              ))}
            </CardBody>
          </Card>
          <Callout tone="info">
            The database re-checks every line on insert: a batch must be <b>Released</b> and the network must hold enough stock, or the order is refused.
          </Callout>
        </div>
      </div>
    </Modal>
  )
}

type Filter = 'all' | 'open' | OrderStatus

export function Orders() {
  const profile = useProfile()
  const L = useLookups()
  const m = useRetailerModel()
  const { run, busy } = useRunner()
  const [params, setParams] = useSearchParams()
  const [filter, setFilter] = useState<Filter>('all')
  const [openId, setOpenId] = useState<number | null>(null)
  const [cancelling, setCancelling] = useState<number | null>(null)
  const creating = params.get('new') === '1'

  type Row = (typeof m.orders)[number]
  const match = (x: Row, f: Filter) => (f === 'all' ? true : f === 'open' ? ['Pending', 'Approved', 'Shipped'].includes(x.o.order_status) : x.o.order_status === f)
  const rows = m.orders.filter((x) => match(x, filter))
  const open = m.orders.find((x) => x.o.order_id === openId)

  const cancel = (orderId: number) =>
    run(
      `cancel-${orderId}`,
      async () => {
        await mustChange(db('fulfillment').from('sales_orders').update({ order_status: 'Cancelled', updated_at_utc: new Date().toISOString() }).eq('order_id', orderId).eq('order_status', 'Pending').select('order_id'))
        await logEvent(profile.user_id, 'ORDER_CANCELLED_BY_BUYER', 'FORWARD_FULFILLMENT', { order_id: orderId, severity: 'LOW' })
      },
      { success: `Order #${orderId} cancelled` },
    )

  const cols: Column<Row>[] = [
    { key: 'id', header: 'Order', sort: (x) => x.o.order_id, cell: (x) => <span className="font-semibold tabular">#{x.o.order_id}</span> },
    { key: 'date', header: 'Placed', sort: (x) => x.o.order_date, cell: (x) => <span className="text-[13px] text-ink-2 tabular">{date(x.o.order_date)}</span> },
    { key: 'lines', header: 'Items', cell: (x) => <span className="text-[13px] text-ink-2">{x.items.length ? [...new Set(x.items.map((i) => L.medName(i.batch_id)))].join(', ') : 'No lines'}</span>, hideBelow: 'lg' },
    { key: 'value', header: 'Value', align: 'right', sort: (x) => x.value, cell: (x) => money(x.value) },
    { key: 'expected', header: 'Expected', sort: (x) => x.o.expected_del_date ?? '', cell: (x) => <span className="text-[13px] text-ink-2 tabular">{date(x.o.expected_del_date)}</span>, hideBelow: 'md' },
    { key: 'status', header: 'Status', sort: (x) => ORDER_FLOW.indexOf(x.o.order_status), cell: (x) => <StatusBadge value={x.o.order_status} meta={ORDER_STATUS} /> },
    { key: 'invoice', header: 'Invoice', cell: (x) => (x.invoice ? <StatusBadge value={x.invoice.payment_status} meta={PAYMENT_STATUS} /> : <span className="text-xs text-muted">—</span>), hideBelow: 'md' },
    {
      key: 'act',
      header: '',
      cell: (x) =>
        x.o.order_status === 'Pending' ? (
          <div onClick={(e) => e.stopPropagation()}>
            <Button size="xs" variant="ghost" icon={XCircle} onClick={() => setCancelling(x.o.order_id)}>
              Cancel
            </Button>
          </div>
        ) : null,
    },
  ]

  const count = (f: Filter) => m.orders.filter((x) => match(x, f)).length

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={ShoppingCart} onClick={() => setParams({ new: '1' })}>New purchase order</Button>} />
      <div className="mb-4">
        <Segmented<Filter>
          value={filter}
          onChange={setFilter}
          options={[
            { value: 'all', label: 'All', count: count('all') },
            { value: 'open', label: 'Open', count: count('open') },
            { value: 'Pending', label: 'Pending', count: count('Pending') },
            { value: 'Shipped', label: 'Shipped', count: count('Shipped') },
            { value: 'Delivered', label: 'Delivered', count: count('Delivered') },
            { value: 'Cancelled', label: 'Cancelled', count: count('Cancelled') },
          ]}
        />
      </div>
      <DataTable
        rows={rows}
        columns={cols}
        rowKey={(x) => x.o.order_id}
        loading={m.isLoading}
        searchText={(x) => `${x.o.order_id} ${x.items.map((i) => L.medName(i.batch_id)).join(' ')}`}
        onRowClick={(x) => setOpenId(x.o.order_id)}
        initialSort={{ key: 'id', dir: 'desc' }}
        emptyTitle="No orders"
        exportName="my-purchase-orders"
        exportRow={(x) => ({ order_id: x.o.order_id, placed: x.o.order_date, expected: x.o.expected_del_date, status: x.o.order_status, value: x.value })}
      />

      <Drawer open={!!open} onClose={() => setOpenId(null)} title={open ? `Order #${open.o.order_id}` : ''} subtitle={open ? `Placed ${date(open.o.order_date)} · expected ${date(open.o.expected_del_date)}` : ''}>
        {open && (
          <div className="space-y-4">
            <Card>
              <CardBody className="pt-5">
                <Stepper steps={ORDER_FLOW} current={open.o.order_status === 'Cancelled' ? 'Pending' : open.o.order_status} failed={open.o.order_status === 'Cancelled'} />
              </CardBody>
            </Card>
            <Card>
              <CardHeader title="Lines" subtitle={money(open.value)} />
              <div className="divide-y divide-line border-t border-line">
                {open.items.map((i) => (
                  <div key={i.order_item_id} className="flex flex-wrap items-center justify-between gap-2 px-5 py-3 text-[13px]">
                    <span>
                      <b className="font-medium text-ink">{L.medName(i.batch_id)}</b> <Code>{L.batchNo(i.batch_id)}</Code>
                    </span>
                    <span className="tabular">
                      {num(i.quantity)} × {money(i.unit_price)}
                    </span>
                  </div>
                ))}
                {open.items.length === 0 && <p className="px-5 py-4 text-[13px] text-ink-2">No lines.</p>}
              </div>
            </Card>
            {open.manifest && (
              <Card>
                <CardHeader title="Shipment" actions={<StatusBadge value={open.manifest.manifest_status} meta={MANIFEST_STATUS} />} />
                <CardBody className="text-[13px] text-ink-2">
                  {L.vehicle.get(open.manifest.vehicle_id)?.vehicle_no} ({L.vehicle.get(open.manifest.vehicle_id)?.vehicle_type}) · driver {L.userName(open.manifest.driver_user_id)}
                  <br />
                  Dispatched {dateTime(open.manifest.dispatch_time_utc)} · ETA {open.manifest.estimated_arrival_time ? relative(open.manifest.estimated_arrival_time) : 'n/a'}
                </CardBody>
              </Card>
            )}
            {open.invoice && (
              <Card>
                <CardHeader title="Invoice" actions={<StatusBadge value={open.invoice.payment_status} meta={PAYMENT_STATUS} />} />
                <CardBody className="grid grid-cols-3 gap-3 text-[13px]">
                  <div><p className="text-muted">Base</p><p className="text-ink tabular">{money2(open.invoice.base_amount)}</p></div>
                  <div><p className="text-muted">GST</p><p className="text-ink tabular">{num(open.invoice.tax_percentage)}%</p></div>
                  <div><p className="text-muted">Total</p><p className="font-semibold text-ink tabular">{money2(open.invoice.total_transaction_amount)}</p></div>
                </CardBody>
              </Card>
            )}
          </div>
        )}
      </Drawer>

      <NewOrder
        open={creating}
        onClose={() => {
          params.delete('new')
          setParams(params, { replace: true })
        }}
      />
      <ConfirmDialog
        open={cancelling != null}
        onClose={() => setCancelling(null)}
        danger
        title={`Cancel order #${cancelling}?`}
        confirmLabel="Cancel order"
        loading={busy === `cancel-${cancelling}`}
        onConfirm={async () => {
          if (cancelling == null) return
          const r = await cancel(cancelling)
          if (r.ok) setCancelling(null)
        }}
      >
        Only pending orders can be cancelled. Once the distributor approves, contact them instead.
      </ConfirmDialog>
    </>
  )
}
