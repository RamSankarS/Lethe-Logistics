import { useEffect, useMemo, useState } from 'react'
import { Undo2 } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { Field, FormGrid, Input, Select } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { num } from '@/lib/format'

/** Orders, lines, shipments, receipts, invoices, returns and refunds of the signed-in retailer. */
export function useRetailerModel() {
  const profile = useProfile()
  const t = useTables(['orders', 'orderItems', 'manifests', 'receipts', 'payments', 'returns', 'assessments', 'refunds', 'recalls', 'recallComms'] as const)
  const orgId = profile.org?.org_id
  return useMemo(() => {
    const d = t.data
    const orders = d.orders
      .filter((o) => o.buyer_org_id === orgId)
      .map((o) => {
        const items = d.orderItems.filter((i) => i.order_id === o.order_id)
        return {
          o,
          items,
          value: items.reduce((s, i) => s + i.quantity * Number(i.unit_price), 0),
          manifest: d.manifests.find((m) => m.order_id === o.order_id),
          receipt: d.receipts.filter((r) => r.order_id === o.order_id).sort((a, b) => b.delivery_time.localeCompare(a.delivery_time))[0],
          invoice: d.payments.find((p) => p.order_id === o.order_id),
        }
      })
    const delivered = orders.filter((x) => x.o.order_status === 'Delivered')
    // Units of each batch this pharmacy has received
    const received = new Map<number, { qty: number; orders: number[] }>()
    for (const x of delivered)
      for (const i of x.items) {
        const cur = received.get(i.batch_id) ?? { qty: 0, orders: [] }
        received.set(i.batch_id, { qty: cur.qty + i.quantity, orders: [...cur.orders, i.order_id] })
      }
    const returns = d.returns
      .filter((r) => r.returner_org_id === orgId)
      .map((r) => ({ r, a: d.assessments.find((a) => a.return_id === r.return_id), v: d.refunds.find((v) => v.return_id === r.return_id) }))
    const notices = d.recallComms.filter((c) => c.notified_org_id === orgId)
    const activeRecalls = d.recalls.filter((r) => r.quarantine_status === 'Active')
    return { orders, delivered, received, returns, notices, activeRecalls, recalls: d.recalls, payments: d.payments.filter((p) => p.payer_org_id === orgId), isLoading: t.isLoading }
  }, [t.data, t.isLoading, orgId])
}

const REASONS = ['Expired shelf life', 'Damaged packaging / broken seals', 'Damaged in transit', 'Temperature excursion', 'Mandatory recall', 'Short shipment', 'Order error / overstock', 'Other']

/** File a return request (reverse logistics), optionally pre-filled. */
export function FileReturnModal({ open, onClose, presetBatch, presetReason, presetQty }: { open: boolean; onClose: () => void; presetBatch?: number; presetReason?: string; presetQty?: number }) {
  const profile = useProfile()
  const L = useLookups()
  const m = useRetailerModel()
  const { run, busy } = useRunner()
  const [batchId, setBatchId] = useState('')
  const [reason, setReason] = useState(REASONS[0])
  const [detail, setDetail] = useState('')
  const [qty, setQty] = useState('')

  useEffect(() => {
    if (open) {
      setBatchId(presetBatch ? String(presetBatch) : '')
      setReason(presetReason ?? REASONS[0])
      setQty(presetQty ? String(presetQty) : '')
      setDetail('')
    }
  }, [open, presetBatch, presetReason, presetQty])

  const recallFor = (id: number) => m.activeRecalls.find((r) => r.batch_id === id)
  const options = useMemo(() => {
    const ids = new Set<number>([...m.received.keys(), ...m.activeRecalls.map((r) => r.batch_id)])
    return [...ids].map((id) => ({ id, received: m.received.get(id)?.qty ?? 0, recall: recallFor(id) })).sort((a, b) => L.batchNo(a.id).localeCompare(L.batchNo(b.id)))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [m.received, m.activeRecalls, L])

  const chosen = options.find((o) => String(o.id) === batchId)
  const recall = chosen?.recall
  const fullReason = (detail.trim() ? `${reason}: ${detail.trim()}` : reason).slice(0, 100)
  const n = Number(qty)
  const valid = chosen && n > 0 && (chosen.received === 0 || n <= chosen.received)

  const submit = async () => {
    if (!chosen) return
    const r = await run(
      'file-return',
      async () => {
        const { data, error } = await db('reverse')
          .from('return_requests')
          .insert({ returner_org_id: profile.org!.org_id, batch_id: chosen.id, recall_id: recall?.recall_id ?? null, quantity_returned: n, return_reason: fullReason, status: 'Initiated' })
          .select('return_id')
          .single()
        if (error) throw error
        await logEvent(profile.user_id, 'RETURN_FILED', 'REVERSE_LOGISTICS', { return_id: (data as { return_id: number }).return_id, batch_id: chosen.id, batch_number: L.batchNo(chosen.id), quantity: n, reason: fullReason, recall_id: recall?.recall_id ?? null, severity: recall ? 'MEDIUM' : 'LOW' })
      },
      { success: 'Return filed', description: 'The distributor will schedule a pickup.' },
    )
    if (r.ok) onClose()
  }

  return (
    <Modal
      open={open}
      onClose={onClose}
      icon={Undo2}
      title="File a return"
      description="Send stock back through Lethe's reverse logistics: pickup, inspection, refund or destruction."
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Undo2} disabled={!valid} loading={busy === 'file-return'} onClick={submit}>
            File return
          </Button>
        </>
      }
    >
      <div className="retailer-return-form">
        <Field label="Batch" required hint="Batches delivered to your pharmacy, plus any batch under an active recall.">
          <Select value={batchId} onChange={(e) => setBatchId(e.target.value)}>
            <option value="">Choose a batch…</option>
            {options.map((o) => (
              <option key={o.id} value={o.id}>
                {L.batchNo(o.id)} · {L.medName(o.id)}
                {o.received ? ` · ${num(o.received)} received` : ''}
                {o.recall ? ' · RECALLED' : ''}
              </option>
            ))}
          </Select>
        </Field>
        {recall && (
          <Callout tone="critical" title={`Under recall #${recall.recall_id}`}>
            {recall.recall_reason} This return will be linked to the recall automatically.
          </Callout>
        )}
        <FormGrid>
          <Field label="Reason" required>
            <Select value={reason} onChange={(e) => setReason(e.target.value)}>
              {REASONS.map((r) => (
                <option key={r}>{r}</option>
              ))}
            </Select>
          </Field>
          <Field label="Units to return" required error={qty && chosen && chosen.received > 0 && n > chosen.received ? `You received ${num(chosen.received)} units.` : undefined}>
            <Input type="number" min={1} value={qty} onChange={(e) => setQty(e.target.value)} />
          </Field>
        </FormGrid>
        <Field label="Details" hint={`${fullReason.length}/100 characters stored on the return (database limit).`}>
          <Input value={detail} maxLength={80} onChange={(e) => setDetail(e.target.value)} placeholder="e.g. 12 blister packs crushed in carton 3" />
        </Field>
      </div>
    </Modal>
  )
}
