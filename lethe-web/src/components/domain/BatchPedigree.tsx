import { useMemo, useState } from 'react'
import {
  ArrowRightLeft,
  BadgeCheck,
  Ban,
  Factory,
  FlaskConical,
  Flame,
  IndianRupee,
  PackageCheck,
  PackageMinus,
  PackagePlus,
  ShoppingCart,
  Siren,
  Thermometer,
  Truck,
  Undo2,
} from 'lucide-react'
import { useAuditForBatch } from '@/data/audit'
import { useLookups, useTables } from '@/data/hooks'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { EmptyState, Spinner } from '@/components/ui/Feedback'
import { Timeline, type TimelineItem } from '@/components/ui/Timeline'
import { BATCH_STATUS, DISPOSITION, type Tone } from '@/lib/domain'
import { date, humanize, money, num, temp } from '@/lib/format'
import type { BatchStatus } from '@/lib/types'
import { ExpiryBadge, KV, StorageBand } from './Cells'

const STATUS_TONE: Record<string, Tone> = { Released: 'good', 'Quality-Check': 'warn', Pending: 'neutral', Rejected: 'critical', Recalled: 'critical' }

/**
 * Full chain of custody for one batch: registration, QC decisions, warehouse
 * movements, quarantines, orders, shipments, deliveries, recalls, returns,
 * assessments, refunds, disposal and losses, merged into one timeline.
 */
export function BatchPedigree({ batchId }: { batchId: number }) {
  const L = useLookups()
  const t = useTables([
    'inventory', 'movements', 'quarantine', 'sensorLogs', 'orderItems', 'orders', 'manifests', 'receipts',
    'returns', 'assessments', 'refunds', 'disposals', 'recalls', 'losses', 'specs', 'compositions',
  ] as const)
  const batch = L.batchOf(batchId)
  const audit = useAuditForBatch(batch?.batch_number, batch?.batch_id)

  const view = useMemo(() => {
    if (!batch) return null
    const d = t.data
    const items: TimelineItem[] = []
    const med = L.medOf(batch)

    items.push({
      id: 'reg',
      at: batch.created_at,
      icon: Factory,
      tone: 'accent',
      title: `Batch registered by ${L.orgName(batch.manufacturer_id)}`,
      detail: `${num(batch.quantity_produced)} units · manufactured ${date(batch.mfg_date)} · registered by ${L.userName(batch.registered_by_user_id)}`,
    })

    for (const a of audit.data ?? []) {
      if (a.action_type !== 'BATCH_STATUS_CHANGE') continue
      const p = (a.event_payload ?? {}) as Record<string, string>
      items.push({
        id: `audit-${a.log_id}`,
        at: a.log_time_stamp_utc,
        icon: FlaskConical,
        tone: STATUS_TONE[p.new_status] ?? 'neutral',
        title: `Status changed: ${p.old_status ?? '?'} → ${p.new_status ?? '?'}`,
        detail: p.description,
      })
    }

    const movements = d.movements.filter((m) => m.batch_id === batchId)
    for (const m of movements) {
      const icon = m.movement_type === 'Inbound' ? PackagePlus : m.movement_type === 'Outbound' ? PackageMinus : ArrowRightLeft
      const title =
        m.movement_type === 'Inbound'
          ? `Received ${num(m.quantity_moved)} units into ${L.locLabel(m.destination_location_id)}`
          : m.movement_type === 'Outbound'
            ? `Dispatched ${num(m.quantity_moved)} units from ${L.locLabel(m.source_location_id)}`
            : `Moved ${num(m.quantity_moved)} units`
      items.push({
        id: `mv-${m.movement_id}`,
        at: m.moved_at,
        icon,
        tone: 'info',
        title,
        detail: m.movement_type === 'Internal' ? `${L.locLabel(m.source_location_id)} → ${L.locLabel(m.destination_location_id)}` : `by ${L.userName(m.user_id)}`,
      })
    }

    const sensorById = new Map(d.sensorLogs.map((s) => [s.log_id, s]))
    for (const q of d.quarantine.filter((x) => x.batch_id === batchId)) {
      const s = q.breaching_log_id != null ? sensorById.get(q.breaching_log_id) : undefined
      items.push({
        id: `q-${q.quarantine_id}`,
        at: s?.recorded_at ?? batch.created_at,
        icon: Thermometer,
        tone: q.status === 'Active' ? 'critical' : 'neutral',
        title: `Quarantined at ${L.locLabel(q.location_id)}`,
        detail: `${q.quarantine_reason}${s ? ` · sensor read ${temp(s.temperature_celsius)}` : ''} · now ${q.status.toLowerCase()}`,
      })
    }

    const lines = d.orderItems.filter((i) => i.batch_id === batchId)
    const orderIds = new Set(lines.map((l) => l.order_id))
    const orderById = new Map(d.orders.map((o) => [o.order_id, o]))
    for (const li of lines) {
      const o = orderById.get(li.order_id)
      items.push({
        id: `oi-${li.order_item_id}`,
        at: li.created_at_utc,
        icon: ShoppingCart,
        tone: 'neutral',
        title: `Ordered by ${L.orgName(o?.buyer_org_id)} (order #${li.order_id})`,
        detail: `${num(li.quantity)} units × ${money(li.unit_price)} · order ${o?.order_status.toLowerCase() ?? ''}`,
      })
    }
    for (const m of d.manifests.filter((x) => orderIds.has(x.order_id))) {
      const v = L.vehicle.get(m.vehicle_id)
      items.push({
        id: `mf-${m.manifest_id}`,
        at: m.dispatch_time_utc,
        icon: Truck,
        tone: m.manifest_status === 'Delayed' ? 'serious' : 'info',
        title: `Shipped on ${v?.vehicle_no ?? 'vehicle'} (${v?.vehicle_type ?? '?'}) for order #${m.order_id}`,
        detail: `Driver ${L.userName(m.driver_user_id)} · ${m.manifest_status}`,
      })
    }
    for (const r of d.receipts.filter((x) => orderIds.has(x.order_id))) {
      items.push({
        id: `rc-${r.receipt_id}`,
        at: r.delivery_time,
        icon: PackageCheck,
        tone: r.received_condition === 'Good' ? 'good' : 'serious',
        title: `Delivered (order #${r.order_id}): ${r.received_condition}`,
        detail: r.remarks ?? `Signed by ${L.userName(r.received_by_user_id)}`,
      })
    }

    for (const rc of d.recalls.filter((x) => x.batch_id === batchId)) {
      items.push({ id: `recall-${rc.recall_id}`, at: rc.created_at_utc, icon: Siren, tone: 'critical', title: `Global recall #${rc.recall_id} (${rc.quarantine_status})`, detail: rc.recall_reason })
    }

    const returns = d.returns.filter((x) => x.batch_id === batchId)
    const returnIds = new Set(returns.map((r) => r.return_id))
    for (const r of returns) {
      items.push({ id: `ret-${r.return_id}`, at: r.created_at_utc, icon: Undo2, tone: 'warn', title: `Return filed by ${L.orgName(r.returner_org_id)}: ${num(r.quantity_returned)} units`, detail: `${r.return_reason} · ${humanize(r.status)}` })
    }
    const assessments = d.assessments.filter((a) => returnIds.has(a.return_id))
    const assessmentIds = new Set(assessments.map((a) => a.assessment_id))
    for (const a of assessments) {
      items.push({ id: `as-${a.assessment_id}`, at: a.assessed_at_utc, icon: BadgeCheck, tone: DISPOSITION[a.disposition_action].tone, title: `Inspected: ${DISPOSITION[a.disposition_action].label}`, detail: a.inspection_result })
    }
    for (const c of d.disposals.filter((x) => assessmentIds.has(x.assessment_id))) {
      items.push({ id: `dc-${c.certificate_id}`, at: c.disposed_at_utc, icon: Flame, tone: 'serious', title: `Destroyed by ${humanize(c.disposal_method)}`, detail: <span>Witness {L.userName(c.witness_user_id)} · evidence <Code>{c.evidence_hash.slice(0, 24)}…</Code></span> })
    }
    for (const v of d.refunds.filter((x) => returnIds.has(x.return_id))) {
      items.push({ id: `rf-${v.voucher_id}`, at: v.issued_at_utc, icon: IndianRupee, tone: 'info', title: `Refund voucher ${money(v.refund_amount)}`, detail: humanize(v.refund_status) })
    }
    for (const l of d.losses.filter((x) => x.batch_id === batchId)) {
      items.push({ id: `ls-${l.loss_record_id}`, at: l.created_at_utc, icon: Ban, tone: 'critical', title: `Loss recorded: ${l.loss_category}`, detail: `${num(l.quantity_lost)} units · ${money(l.total_financial_loss)} · ${L.orgName(l.org_id)}` })
    }

    items.sort((a, b) => new Date(a.at).getTime() - new Date(b.at).getTime())

    const custody = d.inventory.filter((i) => i.batch_id === batchId && i.available_quantity > 0)
    const sold = lines.reduce((s, l) => s + l.quantity, 0)
    const returned = returns.reduce((s, r) => s + r.quantity_returned, 0)
    const spec = d.specs.find((s) => s.medicine_id === batch.medicine_id)
    const comp = d.compositions.find((c) => c.medicine_id === batch.medicine_id)
    return { items, custody, sold, returned, spec, comp, med }
  }, [batch, batchId, t.data, audit.data, L])

  if (t.isLoading || L.isLoading) return <Spinner />
  if (!batch || !view) return <EmptyState title="Batch not found" />

  const onHand = view.custody.reduce((s, i) => s + i.available_quantity, 0)

  return (
    <div className="space-y-4">
      <Card>
        <CardBody className="trace-head-body">
          <div className="flex flex-wrap items-start justify-between gap-3">
            <div>
              <div className="flex flex-wrap items-center gap-2">
                <Code className="trace-batch-code">{batch.batch_number}</Code>
                <StatusBadge value={batch.status as BatchStatus} meta={BATCH_STATUS} />
              </div>
              <p className="trace-med-name">{view.med?.brand_name ?? 'Unknown medicine'}</p>
              <p className="trace-med-sub">
                {view.med?.generic_name}
                {view.comp ? ` · ${view.comp.active_ingredient} ${view.comp.strength} ${view.comp.dosage_form}` : ''}
              </p>
            </div>
            <ExpiryBadge value={batch.expiry_date} />
          </div>
          <div className="trace-kv-grid grid grid-cols-2 gap-4 sm:grid-cols-4">
            <KV label="Produced">{num(batch.quantity_produced)}</KV>
            <KV label="On hand (network)">{num(onHand)}</KV>
            <KV label="Ordered">{num(view.sold)}</KV>
            <KV label="Returned">{num(view.returned)}</KV>
            <KV label="Manufacturer">{L.orgName(batch.manufacturer_id)}</KV>
            <KV label="Mfg / expiry">
              {date(batch.mfg_date)} → {date(batch.expiry_date)}
            </KV>
            <KV label="Storage">
              <StorageBand pkg={L.pkgOfBatch(batch.batch_id)} />
            </KV>
            <KV label="QC spec">{view.spec ? `≥${view.spec.purity_threshold}% purity · pH ${view.spec.ph_balance_req}` : '—'}</KV>
          </div>
        </CardBody>
      </Card>

      <Card>
        <CardHeader title="Current custody" subtitle="Where this batch physically sits right now" />
        <CardBody>
          {view.custody.length === 0 ? (
            <p className="trace-none-text">No stock of this batch is held in any warehouse.</p>
          ) : (
            <div className="grid gap-2 sm:grid-cols-2">
              {view.custody.map((i) => (
                <div key={i.inventory_id} className="trace-custody-item">
                  <span className="trace-custody-loc">{L.locLabel(i.location_id)}</span>
                  <Badge tone="info">{num(i.available_quantity)} units</Badge>
                </div>
              ))}
            </div>
          )}
        </CardBody>
      </Card>

      <Card>
        <CardHeader title="Chain of custody" subtitle={`${view.items.length} events across production, warehousing, fulfilment and reverse logistics`} />
        <CardBody>
          <Timeline items={view.items} />
        </CardBody>
      </Card>
    </div>
  )
}

/** Searchable batch picker used by the traceability screens. */
export function BatchSearch({ onPick, placeholder = 'Search batch number or medicine…' }: { onPick: (batchId: number) => void; placeholder?: string }) {
  const L = useLookups()
  const [q, setQ] = useState('')
  const [open, setOpen] = useState(false)
  const all = useMemo(() => [...L.batch.values()].sort((a, b) => a.batch_number.localeCompare(b.batch_number)), [L.batch])
  const term = q.trim().toLowerCase()
  const matches = all.filter((b) => !term || b.batch_number.toLowerCase().includes(term) || (L.medOf(b)?.brand_name ?? '').toLowerCase().includes(term)).slice(0, 8)
  return (
    <div className="trace-search-wrap">
      <input
        value={q}
        onChange={(e) => {
          setQ(e.target.value)
          setOpen(true)
        }}
        onFocus={() => setOpen(true)}
        onBlur={() => setTimeout(() => setOpen(false), 150)}
        placeholder={placeholder}
        className="text-input trace-search-input"
      />
      {open && matches.length > 0 && (
        <div className="trace-search-list">
          {matches.map((b) => (
            <button
              key={b.batch_id}
              onMouseDown={(e) => e.preventDefault()}
              onClick={() => {
                onPick(b.batch_id)
                setQ(b.batch_number)
                setOpen(false)
              }}
              className="trace-search-option"
            >
              <span className="trace-pick-text">
                <span className="trace-batch-no">{b.batch_number}</span>
                <span className="trace-pick-sub">{L.medOf(b)?.brand_name ?? '—'}</span>
              </span>
              <StatusBadge value={b.status} meta={BATCH_STATUS} />
            </button>
          ))}
        </div>
      )}
    </div>
  )
}
