import { useMemo, useState } from 'react'
import { BellRing, CheckCircle2, Megaphone, Siren, Undo2, XCircle } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody } from '@/components/ui/Card'
import { Callout, EmptyState, Spinner } from '@/components/ui/Feedback'
import { Checkbox, Field, Select, Textarea } from '@/components/ui/Form'
import { ConfirmDialog, Modal } from '@/components/ui/Modal'
import { SegmentedBar } from '@/components/ui/Progress'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { BATCH_STATUS, COMM_CHANNELS, COMM_STATUS, ORG_TYPE_LABEL, RECALL_STATUS } from '@/lib/domain'
import { dateTime, humanize, money, num, pct, relative } from '@/lib/format'
import type { CommChannel, Recall, RecallStatus } from '@/lib/types'
import { useMyBatches } from './shared'

const CLASSES = [
  { id: 'Class I', hint: 'Reasonable probability of serious harm or death' },
  { id: 'Class II', hint: 'May cause temporary or reversible health problems' },
  { id: 'Class III', hint: 'Unlikely to cause harm; violates regulation' },
]

function InitiateRecall({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const { batches, stock } = useMyBatches()
  const t = useTables(['orderItems', 'orders', 'organisations'] as const)
  const { run, busy } = useRunner()
  const [batchId, setBatchId] = useState('')
  const [cls, setCls] = useState('Class II')
  const [reason, setReason] = useState('')
  const [channels, setChannels] = useState<CommChannel[]>(['System_Alert', 'Email'])
  const [excluded, setExcluded] = useState<Set<string>>(new Set())
  const [confirming, setConfirming] = useState(false)

  const eligible = batches.filter((b) => b.status !== 'Recalled' && b.status !== 'Rejected')
  const batch = eligible.find((b) => String(b.batch_id) === batchId)

  const impacted = useMemo(() => {
    if (!batch) return []
    const orderIds = new Set(t.data.orderItems.filter((i) => i.batch_id === batch.batch_id).map((i) => i.order_id))
    const buyers = new Set(t.data.orders.filter((o) => orderIds.has(o.order_id)).map((o) => o.buyer_org_id))
    return t.data.organisations
      .filter((o) => o.is_active && o.org_id !== profile.org?.org_id && (buyers.has(o.org_id) || o.org_type === 'Distributor' || o.org_type === 'Transporter' || o.org_type === 'Regulatory_Body'))
      .map((o) => ({ org: o, why: buyers.has(o.org_id) ? 'Bought this batch' : o.org_type === 'Regulatory_Body' ? 'Regulator' : 'Network partner' }))
  }, [batch, t.data, profile.org])

  const recipients = impacted.filter((i) => !excluded.has(i.org.org_id))
  const valid = batch && reason.trim().length >= 10 && channels.length > 0

  const submit = async () => {
    if (!batch) return
    const r = await run(
      'recall',
      async () => {
        const { data: rec, error } = await db('reverse')
          .from('global_recall_ledger')
          .insert({ batch_id: batch.batch_id, initiated_by_org_id: profile.org!.org_id, recall_reason: `${cls}: ${reason.trim()}`, quarantine_status: 'Active' })
          .select('recall_id')
          .single()
        if (error) throw error
        const recallId = (rec as { recall_id: number }).recall_id
        await mustChange(db('product').from('batch_master').update({ status: 'Recalled' }).eq('batch_id', batch.batch_id).select('batch_id'))
        if (recipients.length) {
          const rows = recipients.flatMap((rcp) =>
            channels.map((c) => ({ recall_id: recallId, notified_org_id: rcp.org.org_id, channel: c, delivery_status: c === 'System_Alert' || c === 'Email' ? 'Delivered' : 'Pending' })),
          )
          const { error: e3 } = await db('reverse').from('recall_communication_logs').insert(rows)
          if (e3) throw e3
        }
        await logEvent(profile.user_id, 'RECALL_NOTICES_SENT', 'REVERSE_LOGISTICS', { recall_id: recallId, batch_id: batch.batch_id, batch_number: batch.batch_number, recipients: recipients.length, channels, severity: 'HIGH' })
      },
      { success: `Recall broadcast for ${batch.batch_number}`, description: `${recipients.length} organisations notified. The batch is now locked as Recalled.` },
    )
    if (r.ok) {
      setConfirming(false)
      setBatchId('')
      setReason('')
      setExcluded(new Set())
      onClose()
    }
  }

  return (
    <>
      <Modal
        open={open && !confirming}
        onClose={onClose}
        size="lg"
        icon={Megaphone}
        title="Initiate a global recall"
        description="Withdraws a batch from the market and notifies every partner that may hold it."
        footer={
          <>
            <Button variant="ghost" onClick={onClose}>
              Cancel
            </Button>
            <Button variant="danger" icon={Siren} disabled={!valid} onClick={() => setConfirming(true)}>
              Review & broadcast
            </Button>
          </>
        }
      >
        <div className="space-y-4">
          <Field label="Batch to recall" required>
            <Select value={batchId} onChange={(e) => setBatchId(e.target.value)}>
              <option value="">Choose a batch…</option>
              {eligible.map((b) => (
                <option key={b.batch_id} value={b.batch_id}>
                  {b.batch_number} · {L.medOf(b)?.brand_name} · {b.status} · {num(stock.get(b.batch_id) ?? 0)} in network
                </option>
              ))}
            </Select>
          </Field>
          <div className="grid gap-2 sm:grid-cols-3">
            {CLASSES.map((c) => (
              <button
                key={c.id}
                type="button"
                onClick={() => setCls(c.id)}
                className={`rounded-xl border p-3 text-left transition-colors ${cls === c.id ? 'border-critical bg-critical-soft' : 'border-line hover:bg-surface-2'}`}
              >
                <p className={`text-[13px] font-semibold ${cls === c.id ? 'text-critical-text' : 'text-ink'}`}>{c.id}</p>
                <p className="mt-0.5 text-xs text-ink-2">{c.hint}</p>
              </button>
            ))}
          </div>
          <Field label="Reason / regulatory cause" required hint="At least 10 characters. Stored on the recall ledger and the audit log.">
            <Textarea value={reason} onChange={(e) => setReason(e.target.value)} placeholder="Sub-standard dissolution rate detected in post-market surveillance." />
          </Field>
          <Field label="Channels">
            <div className="flex flex-wrap gap-4">
              {COMM_CHANNELS.map((c) => (
                <Checkbox key={c} label={humanize(c)} checked={channels.includes(c)} onChange={(v) => setChannels((p) => (v ? [...p, c] : p.filter((x) => x !== c)))} />
              ))}
            </div>
          </Field>
          {batch && (
            <div>
              <p className="mb-2 text-[13px] font-medium text-ink">
                Recipients <span className="text-ink-2">({recipients.length} of {impacted.length})</span>
              </p>
              <div className="max-h-48 space-y-1.5 overflow-y-auto rounded-xl border border-line p-2">
                {impacted.length === 0 && <p className="p-2 text-[13px] text-ink-2">No partner organisations found.</p>}
                {impacted.map((i) => (
                  <div key={i.org.org_id} className="flex items-center justify-between gap-3 rounded-lg px-2 py-1.5 hover:bg-surface-2">
                    <Checkbox
                      label={i.org.org_name}
                      description={ORG_TYPE_LABEL[i.org.org_type]}
                      checked={!excluded.has(i.org.org_id)}
                      onChange={(v) =>
                        setExcluded((p) => {
                          const n = new Set(p)
                          if (v) n.delete(i.org.org_id)
                          else n.add(i.org.org_id)
                          return n
                        })
                      }
                    />
                    <Badge tone={i.why === 'Bought this batch' ? 'critical' : 'neutral'}>{i.why}</Badge>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </Modal>

      <ConfirmDialog
        open={open && confirming}
        onClose={() => setConfirming(false)}
        onConfirm={submit}
        loading={busy === 'recall'}
        danger
        icon={Siren}
        title={`Recall ${batch?.batch_number ?? ''}?`}
        confirmLabel="Broadcast recall"
      >
        This writes a <b className="text-ink">{cls}</b> recall to the global recall ledger, locks the batch as <b className="text-ink">Recalled</b> (irreversible) and sends{' '}
        {recipients.length * channels.length} notices to {recipients.length} organisations. The database records a CRITICAL event in the audit ledger.
      </ConfirmDialog>
    </>
  )
}

function RecallCard({ recall }: { recall: Recall }) {
  const profile = useProfile()
  const L = useLookups()
  const t = useTables(['recallComms', 'returns', 'vwNonCompliance', 'organisations'] as const)
  const { run, busy } = useRunner()
  const [changing, setChanging] = useState<RecallStatus | null>(null)
  const batch = L.batchOf(recall.batch_id)

  const comms = t.data.recallComms.filter((c) => c.recall_id === recall.recall_id)
  const returns = t.data.returns.filter((r) => r.recall_id === recall.recall_id)
  const cost = t.data.vwNonCompliance.find((c) => c.recall_id === recall.recall_id)
  const count = (s: string) => comms.filter((c) => c.delivery_status === s).length
  const orgsNotified = new Set(comms.map((c) => c.notified_org_id))
  const orgsAcked = new Set(comms.filter((c) => c.delivery_status === 'Read').map((c) => c.notified_org_id))
  const unacked = [...orgsNotified].filter((o) => !orgsAcked.has(o))
  const returnedQty = returns.reduce((s, r) => s + r.quantity_returned, 0)

  const setStatus = (status: RecallStatus) =>
    run(
      `recall-${recall.recall_id}`,
      async () => {
        await mustChange(db('reverse').from('global_recall_ledger').update({ quarantine_status: status }).eq('recall_id', recall.recall_id).select('recall_id'))
        await logEvent(profile.user_id, status === 'Resolved' ? 'RECALL_RESOLVED' : 'RECALL_CANCELLED', 'REVERSE_LOGISTICS', { recall_id: recall.recall_id, batch_id: recall.batch_id, batch_number: batch?.batch_number, severity: 'MEDIUM' })
      },
      { success: `Recall #${recall.recall_id} marked ${status.toLowerCase()}` },
    )

  const remind = () =>
    run(
      `remind-${recall.recall_id}`,
      async () => {
        const { error } = await db('reverse')
          .from('recall_communication_logs')
          .insert(unacked.map((org) => ({ recall_id: recall.recall_id, notified_org_id: org, channel: 'System_Alert', delivery_status: 'Delivered' })))
        if (error) throw error
        await logEvent(profile.user_id, 'RECALL_REMINDER_SENT', 'REVERSE_LOGISTICS', { recall_id: recall.recall_id, recipients: unacked.length, severity: 'LOW' })
      },
      { success: `Reminder sent to ${unacked.length} organisations` },
    )

  return (
    <Card>
      <CardBody className="pt-5">
        <div className="flex flex-wrap items-start justify-between gap-3">
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-2">
              <span className="text-[13px] font-semibold text-ink">Recall #{recall.recall_id}</span>
              <StatusBadge value={recall.quarantine_status} meta={RECALL_STATUS} />
              {batch && <Code>{batch.batch_number}</Code>}
              {batch && <StatusBadge value={batch.status} meta={BATCH_STATUS} />}
            </div>
            <p className="mt-2 text-[15px] font-semibold text-ink">{L.medOf(batch)?.brand_name ?? 'Unknown medicine'}</p>
            <p className="mt-1 max-w-3xl text-[13px] leading-5 text-ink-2">{recall.recall_reason}</p>
            <p className="mt-1 text-xs text-muted">
              Initiated by {L.orgName(recall.initiated_by_org_id)} · {dateTime(recall.created_at_utc)} ({relative(recall.created_at_utc)})
            </p>
          </div>
          {recall.quarantine_status === 'Active' && (
            <div className="flex flex-wrap gap-2">
              <Button size="sm" icon={BellRing} disabled={!unacked.length} loading={busy === `remind-${recall.recall_id}`} onClick={() => void remind()}>
                Remind {unacked.length || ''}
              </Button>
              <Button size="sm" variant="success" icon={CheckCircle2} onClick={() => setChanging('Resolved')}>
                Resolve
              </Button>
              <Button size="sm" variant="ghost" icon={XCircle} onClick={() => setChanging('Cancelled')}>
                Cancel
              </Button>
            </div>
          )}
        </div>

        <div className="mt-5 grid gap-5 lg:grid-cols-3">
          <div className="lg:col-span-2">
            <p className="mb-2 text-[12px] font-semibold tracking-wide text-muted uppercase">
              Notification delivery · {comms.length} notices to {orgsNotified.size} organisations
            </p>
            <SegmentedBar
              parts={[
                { key: 'Read', label: 'Acknowledged', value: count('Read'), color: 'var(--good)' },
                { key: 'Delivered', label: 'Delivered', value: count('Delivered'), color: 'var(--info)' },
                { key: 'Pending', label: 'Pending', value: count('Pending'), color: 'var(--warn)', darkText: true },
                { key: 'Failed', label: 'Failed', value: count('Failed'), color: 'var(--critical)' },
              ]}
            />
          </div>
          <div className="grid grid-cols-3 gap-2 lg:grid-cols-1">
            <div className="rounded-xl bg-surface-2 px-3 py-2">
              <p className="text-[11.5px] text-muted">Orgs acknowledged</p>
              <p className="text-[15px] font-semibold text-ink tabular">
                {orgsAcked.size}/{orgsNotified.size} <span className="text-xs font-normal text-ink-2">{pct(orgsNotified.size ? orgsAcked.size / orgsNotified.size : 0)}</span>
              </p>
            </div>
            <div className="rounded-xl bg-surface-2 px-3 py-2">
              <p className="text-[11.5px] text-muted">Units returned</p>
              <p className="text-[15px] font-semibold text-ink tabular">
                {num(returnedQty)} <span className="text-xs font-normal text-ink-2">in {returns.length} returns</span>
              </p>
            </div>
            <div className="rounded-xl bg-surface-2 px-3 py-2">
              <p className="text-[11.5px] text-muted">Cost of non-compliance</p>
              <p className="text-[15px] font-semibold text-ink tabular">{money(cost?.total_financial_loss ?? 0)}</p>
            </div>
          </div>
        </div>

        {comms.length > 0 && (
          <details className="group mt-4">
            <summary className="cursor-pointer text-[13px] font-medium text-accent-text select-none">Show notices by organisation</summary>
            <div className="mt-3 grid gap-2 md:grid-cols-2">
              {[...orgsNotified].map((orgId) => {
                const mine = comms.filter((c) => c.notified_org_id === orgId)
                return (
                  <div key={orgId} className="rounded-xl border border-line px-3 py-2">
                    <p className="text-[13px] font-medium text-ink">{L.orgName(orgId)}</p>
                    <div className="mt-1.5 flex flex-wrap gap-1.5">
                      {mine.map((c) => (
                        <Badge key={c.log_id} tone={COMM_STATUS[c.delivery_status].tone} dot title={dateTime(c.sent_at_utc)}>
                          {humanize(c.channel)}: {COMM_STATUS[c.delivery_status].label}
                        </Badge>
                      ))}
                    </div>
                  </div>
                )
              })}
            </div>
          </details>
        )}
      </CardBody>

      <ConfirmDialog
        open={!!changing}
        onClose={() => setChanging(null)}
        title={changing === 'Resolved' ? 'Resolve this recall?' : 'Cancel this recall?'}
        confirmLabel={changing === 'Resolved' ? 'Mark resolved' : 'Cancel recall'}
        danger={changing === 'Cancelled'}
        loading={busy === `recall-${recall.recall_id}`}
        onConfirm={async () => {
          if (!changing) return
          const r = await setStatus(changing)
          if (r.ok) setChanging(null)
        }}
      >
        {changing === 'Resolved'
          ? 'Use this when affected stock has been returned or destroyed. The batch itself stays Recalled: a recalled batch can never be re-released.'
          : 'Cancelling records that the recall was raised in error. The batch remains Recalled because the database forbids reviving recalled batches.'}
      </ConfirmDialog>
    </Card>
  )
}

export function Recalls() {
  const { ids, isLoading } = useMyBatches()
  const t = useTables(['recalls', 'recallComms', 'returns', 'vwNonCompliance'] as const)
  const [open, setOpen] = useState(false)

  const mine = t.data.recalls.filter((r) => ids.has(r.batch_id))
  const active = mine.filter((r) => r.quarantine_status === 'Active')
  const comms = t.data.recallComms.filter((c) => mine.some((r) => r.recall_id === c.recall_id))
  const acked = comms.filter((c) => c.delivery_status === 'Read').length
  const units = t.data.returns.filter((r) => r.recall_id != null && mine.some((m) => m.recall_id === r.recall_id)).reduce((s, r) => s + r.quantity_returned, 0)
  const cost = t.data.vwNonCompliance.filter((c) => mine.some((m) => m.recall_id === c.recall_id)).reduce((s, c) => s + Number(c.total_financial_loss ?? 0), 0)

  if (isLoading || t.isLoading) return <Spinner />

  return (
    <>
      <PageHeader
        actions={
          <Button variant="danger" icon={Megaphone} onClick={() => setOpen(true)}>
            Initiate recall
          </Button>
        }
      />
      <StatGrid cols={4}>
        <Stat label="Active recalls" value={num(active.length)} sub={`${mine.length} recalls in total`} icon={Siren} tone="critical" />
        <Stat label="Notices sent" value={num(comms.length)} sub={`${pct(comms.length ? acked / comms.length : 0)} acknowledged`} icon={BellRing} tone="info" />
        <Stat label="Units returned" value={num(units)} sub="against recall directives" icon={Undo2} tone="warn" />
        <Stat label="Cost of non-compliance" value={money(cost)} sub="refunds issued on recalls" icon={XCircle} tone="serious" />
      </StatGrid>

      <div className="mt-5 space-y-4">
        {mine.length === 0 ? (
          <Card>
            <EmptyState icon={Siren} title="No recalls">
              When a batch fails post-market surveillance, initiate a recall to withdraw it network-wide.
            </EmptyState>
          </Card>
        ) : (
          mine.map((r) => <RecallCard key={r.recall_id} recall={r} />)
        )}
        <Callout tone="neutral" title="How recalls work in Lethe">
          Initiating a recall writes to <code className="font-mono">reverse_logistics.global_recall_ledger</code>; the <code className="font-mono">tr_audit_global_recall</code> trigger logs a CRITICAL event, and the
          batch is locked as Recalled. Retailers see the notice in their portal and file returns against it.
        </Callout>
      </div>

      <InitiateRecall open={open} onClose={() => setOpen(false)} />
    </>
  )
}
