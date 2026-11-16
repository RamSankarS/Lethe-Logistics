import { useEffect, useState } from 'react'
import { Clock, PackageCheck, PenLine, Truck, Undo2 } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, useRunner } from '@/data/actions'
import { useLookups } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input, Textarea } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { MANIFEST_STATUS, sha256 } from '@/lib/domain'
import { dateTime, fullName, money, num, relative } from '@/lib/format'
import type { ReceivedCondition } from '@/lib/types'
import { FileReturnModal, useRetailerModel } from './shared'

type OrderView = ReturnType<typeof useRetailerModel>['orders'][number]

const CONDITIONS: { id: ReceivedCondition; label: string; hint: string }[] = [
  { id: 'Good', label: 'Good', hint: 'Everything arrived intact and complete' },
  { id: 'Partial', label: 'Partial', hint: 'Some units missing from the manifest count' },
  { id: 'Damaged', label: 'Damaged', hint: 'Packaging or product damaged on arrival' },
]

function ConfirmReceipt({ order, onClose, onDamaged }: { order: OrderView | null; onClose: () => void; onDamaged: (batchId: number, qty: number, reason: string) => void }) {
  const profile = useProfile()
  const { run, busy } = useRunner()
  const [condition, setCondition] = useState<ReceivedCondition>('Good')
  const [remarks, setRemarks] = useState('')
  const [signature, setSignature] = useState('')

  useEffect(() => {
    if (order) {
      setCondition('Good')
      setRemarks('')
      setSignature('')
    }
  }, [order])

  if (!order) return null
  const needsRemarks = condition !== 'Good'
  const valid = signature.trim().length >= 3 && (!needsRemarks || remarks.trim().length >= 5)

  const submit = async () => {
    const r = await run(
      'receipt',
      async () => {
        const hash = await sha256(`${order.o.order_id}|${signature.trim()}|${profile.user_id}|${new Date().toISOString()}`)
        const { error } = await db('fulfillment').from('delivery_proof_receipt').insert({
          order_id: order.o.order_id,
          received_by_user_id: profile.user_id,
          delivery_time: new Date().toISOString(),
          received_condition: condition,
          digital_signature: `sig:sha256:${hash}`,
          remarks: remarks.trim() || null,
        })
        if (error) throw error
        if (order.manifest) await db('fulfillment').from('shipping_manifest').update({ manifest_status: 'Delivered' }).eq('manifest_id', order.manifest.manifest_id)
        await logEvent(profile.user_id, 'DELIVERY_CONFIRMED', 'FORWARD_FULFILLMENT', { order_id: order.o.order_id, condition, signed_by: signature.trim(), severity: condition === 'Good' ? 'LOW' : 'MEDIUM' })
      },
      {
        success: `Order #${order.o.order_id} received`,
        description: condition === 'Damaged' ? 'Marked delivered. No invoice is raised for damaged deliveries.' : 'Marked delivered; the invoice was generated automatically by a database trigger.',
      },
    )
    if (r.ok) {
      onClose()
      if (condition !== 'Good' && order.items[0]) onDamaged(order.items[0].batch_id, 1, condition === 'Partial' ? 'Short shipment' : 'Damaged in transit')
    }
  }

  return (
    <Modal
      open
      onClose={onClose}
      size="lg"
      icon={PackageCheck}
      title={`Sign for order #${order.o.order_id}`}
      description={`${order.items.length} lines · ${money(order.value)}`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={PenLine} disabled={!valid} loading={busy === 'receipt'} onClick={submit}>
            Sign & confirm
          </Button>
        </>
      }
    >
      <div className="retailer-sign-form">
        <div className="retailer-sign-lines">
          {order.items.map((i, idx) => (
            <LineRow key={i.order_item_id} batchId={i.batch_id} qty={i.quantity} last={idx === order.items.length - 1} />
          ))}
        </div>
        <div className="grid gap-2 sm:grid-cols-3">
          {CONDITIONS.map((c) => (
            <button
              key={c.id}
              type="button"
              onClick={() => setCondition(c.id)}
              className={`retailer-cond-btn ${condition === c.id ? (c.id === 'Good' ? 'retailer-cond-good' : 'retailer-cond-bad') : 'retailer-cond-off'}`}
            >
              <p className="retailer-cond-name">{c.label}</p>
              <p className="retailer-cond-hint">{c.hint}</p>
            </button>
          ))}
        </div>
        <Field label="Remarks" required={needsRemarks} hint={needsRemarks ? 'Describe what is missing or damaged. You can file a return right after signing.' : 'Optional'}>
          <Textarea value={remarks} onChange={(e) => setRemarks(e.target.value)} placeholder={needsRemarks ? 'Water damage on 15 boxes in carton 2' : 'All cartons sealed, temperature log OK'} />
        </Field>
        <Field label="Digital signature" required hint="Type your full name. Lethe stores a SHA-256 fingerprint of it as proof of delivery.">
          <Input value={signature} onChange={(e) => setSignature(e.target.value)} placeholder={fullName(profile)} className="retailer-sig-input" />
        </Field>
        {condition === 'Good' || condition === 'Partial' ? (
          <Callout tone="info">Signing triggers two database actions: the order flips to Delivered and an invoice (base + 5% GST) is written to the payment ledger.</Callout>
        ) : (
          <Callout tone="warn">Damaged deliveries are marked Delivered but no invoice is raised.</Callout>
        )}
      </div>
    </Modal>
  )
}

function LineRow({ batchId, qty, last }: { batchId: number; qty: number; last: boolean }) {
  const L = useLookups()
  return (
    <div className={`retailer-sign-line ${last ? '' : 'retailer-sign-line-border'}`}>
      <span>
        <b>{L.medName(batchId)}</b> <Code>{L.batchNo(batchId)}</Code>
      </span>
      <span className="retailer-line-qty">{num(qty)} units</span>
    </div>
  )
}

export function Receiving() {
  const L = useLookups()
  const m = useRetailerModel()
  const [signing, setSigning] = useState<OrderView | null>(null)
  const [returning, setReturning] = useState<{ batchId: number; qty: number; reason: string } | null>(null)

  const incoming = m.orders.filter((x) => x.o.order_status === 'Shipped')
  const history = m.orders.filter((x) => x.receipt)

  const cols: Column<OrderView>[] = [
    { key: 'order', header: 'Order', sort: (x) => x.o.order_id, cell: (x) => <span className="retailer-id-cell">#{x.o.order_id}</span> },
    { key: 'when', header: 'Received', sort: (x) => x.receipt!.delivery_time, cell: (x) => <span className="retailer-cell-grey">{dateTime(x.receipt!.delivery_time)}</span> },
    { key: 'cond', header: 'Condition', sort: (x) => x.receipt!.received_condition, cell: (x) => <Badge tone={x.receipt!.received_condition === 'Good' ? 'good' : 'serious'} dot>{x.receipt!.received_condition}</Badge> },
    { key: 'by', header: 'Signed by', cell: (x) => <span className="retailer-cell-text">{L.userName(x.receipt!.received_by_user_id)}</span>, hideBelow: 'md' },
    { key: 'remarks', header: 'Remarks', cell: (x) => <span className="retailer-remarks-cell" title={x.receipt!.remarks ?? ''}>{x.receipt!.remarks ?? '—'}</span>, hideBelow: 'lg' },
    { key: 'sig', header: 'Signature', cell: (x) => <Code className="retailer-sig-code">{x.receipt!.digital_signature.slice(0, 22)}…</Code>, hideBelow: 'xl' },
    {
      key: 'act',
      header: '',
      cell: (x) =>
        x.receipt!.received_condition !== 'Good' && x.items[0] ? (
          <Button size="xs" variant="ghost" icon={Undo2} onClick={() => setReturning({ batchId: x.items[0].batch_id, qty: 1, reason: x.receipt!.received_condition === 'Partial' ? 'Short shipment' : 'Damaged in transit' })}>
            File return
          </Button>
        ) : null,
    },
  ]

  return (
    <>
      <PageHeader />
      <Card>
        <CardHeader title="Incoming shipments" subtitle="Orders dispatched to your pharmacy and awaiting your signature" icon={Truck} />
        <CardBody>
          {incoming.length === 0 ? (
            <EmptyState icon={Truck} title="Nothing on the way">
              Shipped orders will appear here for you to sign for.
            </EmptyState>
          ) : (
            <div className="grid gap-3 lg:grid-cols-2">
              {incoming.map((x) => {
                const late = x.manifest?.estimated_arrival_time && new Date(x.manifest.estimated_arrival_time) < new Date()
                return (
                  <div key={x.o.order_id} className="retailer-ship-box">
                    <div className="flex flex-wrap items-start justify-between gap-2">
                      <div>
                        <p className="retailer-ship-title">Order #{x.o.order_id}</p>
                        <p className="retailer-ship-sub">
                          {x.items.length} lines · {money(x.value)}
                        </p>
                      </div>
                      <div className="flex flex-wrap gap-1.5">
                        {x.manifest && <StatusBadge value={x.manifest.manifest_status} meta={MANIFEST_STATUS} />}
                        {late && <Badge tone="serious" icon={Clock}>Past ETA</Badge>}
                      </div>
                    </div>
                    {x.manifest ? (
                      <div className="retailer-ship-details grid grid-cols-2 gap-2">
                        <div><p className="retailer-small-label">Vehicle</p><p className="retailer-detail-value">{L.vehicle.get(x.manifest.vehicle_id)?.vehicle_no} · {L.vehicle.get(x.manifest.vehicle_id)?.vehicle_type}</p></div>
                        <div><p className="retailer-small-label">Driver</p><p className="retailer-detail-value">{L.userName(x.manifest.driver_user_id)}</p></div>
                        <div><p className="retailer-small-label">Dispatched</p><p className="retailer-detail-value">{relative(x.manifest.dispatch_time_utc)}</p></div>
                        <div><p className="retailer-small-label">ETA</p><p className="retailer-detail-value">{x.manifest.estimated_arrival_time ? dateTime(x.manifest.estimated_arrival_time) : 'Not set'}</p></div>
                      </div>
                    ) : (
                      <p className="retailer-ship-nomanifest">No manifest attached yet.</p>
                    )}
                    <div className="retailer-ship-btn-row">
                      <Button variant="primary" icon={PenLine} onClick={() => setSigning(x)}>
                        Sign for delivery
                      </Button>
                    </div>
                  </div>
                )
              })}
            </div>
          )}
        </CardBody>
      </Card>

      <Card className="retailer-history-box">
        <CardHeader title="Proof-of-delivery history" subtitle="Every delivery you have signed for" icon={PackageCheck} />
        <DataTable bare rows={history} columns={cols} rowKey={(x) => x.o.order_id} loading={m.isLoading} initialSort={{ key: 'when', dir: 'desc' }} emptyTitle="No deliveries yet" />
      </Card>

      <ConfirmReceipt order={signing} onClose={() => setSigning(null)} onDamaged={(batchId, qty, reason) => setReturning({ batchId, qty, reason })} />
      <FileReturnModal open={!!returning} onClose={() => setReturning(null)} presetBatch={returning?.batchId} presetQty={returning?.qty} presetReason={returning?.reason === 'Short shipment' ? 'Short shipment' : 'Damaged in transit'} />
    </>
  )
}
