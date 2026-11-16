import { useEffect, useMemo, useState } from 'react'
import { BadgeCheck, CheckCircle2, Flame, IndianRupee, PackagePlus, ScanSearch, Undo2 } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardHeader } from '@/components/ui/Card'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input, Select, Textarea } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { DISPOSAL_METHODS, DISPOSITION, REFUND_STATUS, RETURN_FLOW, RETURN_STATUS, locationFits, sha256 } from '@/lib/domain'
import { date, humanize, money, num } from '@/lib/format'
import type { Disposition, ReturnRequest, ReturnStatus } from '@/lib/types'
import { useMyBatches, useReferencePrice } from './shared'

function AssessModal({ ret, onClose }: { ret: ReturnRequest | null; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const price = useReferencePrice()
  const { run, busy } = useRunner()
  const [findings, setFindings] = useState('')
  const [disposition, setDisposition] = useState<Disposition>('Approve_Refund_and_Destroy')
  const [amount, setAmount] = useState('')

  useEffect(() => {
    if (ret) {
      setFindings('')
      setDisposition(ret.recall_id ? 'Approve_Refund_and_Destroy' : 'Approve_Refund_and_Restock')
      setAmount(String(Math.round(ret.quantity_returned * price(ret.batch_id) * 100) / 100))
    }
    // Reset only when a different return is opened, not on background refetches.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [ret?.return_id])

  if (!ret) return null
  const refund = disposition !== 'Reject_Claim'
  const valid = findings.trim().length >= 5 && (!refund || Number(amount) >= 0)

  const submit = async () => {
    const r = await run(
      'assess',
      async () => {
        const { error } = await db('reverse').from('return_stock_assessments').insert({ return_id: ret.return_id, inspector_user_id: profile.user_id, inspection_result: findings.trim(), disposition_action: disposition })
        if (error) throw error
        await mustChange(db('reverse').from('return_requests').update({ status: 'Assessed' }).eq('return_id', ret.return_id).select('return_id'))
        if (refund) {
          const { error: e3 } = await db('reverse').from('refund_vouchers').insert({ return_id: ret.return_id, refund_amount: Number(amount), refund_status: 'Pending_Payout' })
          if (e3) throw e3
        }
        await logEvent(profile.user_id, 'RETURN_ASSESSED', 'REVERSE_LOGISTICS', { return_id: ret.return_id, batch_id: ret.batch_id, batch_number: L.batchNo(ret.batch_id), disposition, refund_amount: refund ? Number(amount) : 0, severity: 'MEDIUM' })
      },
      { success: `Return #${ret.return_id} assessed`, description: DISPOSITION[disposition].label },
    )
    if (r.ok) onClose()
  }

  return (
    <Modal
      open
      onClose={onClose}
      size="lg"
      icon={ScanSearch}
      title={`Inspect return #${ret.return_id}`}
      description={`${num(ret.quantity_returned)} units of ${L.batchNo(ret.batch_id)} (${L.medName(ret.batch_id)}) from ${L.orgName(ret.returner_org_id)}`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={BadgeCheck} disabled={!valid} loading={busy === 'assess'} onClick={submit}>
            Record assessment
          </Button>
        </>
      }
    >
      <div className="mfr-stack">
        <Callout tone={ret.recall_id ? 'critical' : 'neutral'} title={ret.recall_id ? `Returned under recall #${ret.recall_id}` : 'Claim reason'}>
          {ret.return_reason}
        </Callout>
        <Field label="Inspection findings" required>
          <Textarea value={findings} onChange={(e) => setFindings(e.target.value)} placeholder="Seals intact, temperature log verified…" />
        </Field>
        <div className="mfr-dispo-list">
          {(Object.keys(DISPOSITION) as Disposition[]).map((d) => (
            <button
              key={d}
              type="button"
              onClick={() => setDisposition(d)}
              className={`mfr-dispo-btn ${disposition === d ? 'mfr-dispo-btn-on' : ''}`}
            >
              <span className={`mfr-fake-radio ${disposition === d ? 'mfr-fake-radio-on' : ''}`}>
                {disposition === d && <span className="mfr-fake-radio-dot" />}
              </span>
              <span>
                <span className="mfr-dispo-name">{DISPOSITION[d].label}</span>
                <span className="mfr-dispo-hint">{DISPOSITION[d].hint}</span>
              </span>
            </button>
          ))}
        </div>
        {refund && (
          <Field label="Refund amount (₹)" hint={`Prefilled at the reference price of ${money(price(ret.batch_id))} per unit.`}>
            <Input type="number" min={0} step="0.01" value={amount} onChange={(e) => setAmount(e.target.value)} />
          </Field>
        )}
      </div>
    </Modal>
  )
}

function DisposeModal({ ret, assessmentId, onClose }: { ret: ReturnRequest | null; assessmentId?: number; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const { run, busy } = useRunner()
  const [method, setMethod] = useState<string>('Incineration')
  const [hash, setHash] = useState('')

  useEffect(() => {
    if (ret && assessmentId) void sha256(`${assessmentId}|${ret.batch_id}|${ret.quantity_returned}|${method}|${profile.user_id}|${Date.now()}`).then((h) => setHash(`sha256:${h}`))
  }, [ret, assessmentId, method, profile.user_id])

  if (!ret || !assessmentId) return null
  const submit = async () => {
    const r = await run(
      'dispose',
      async () => {
        const { error } = await db('reverse').from('disposal_certificates').insert({ assessment_id: assessmentId, witness_user_id: profile.user_id, disposal_method: method, evidence_hash: hash })
        if (error) throw error
      },
      { success: 'Disposal certificate issued', description: 'DRUGS_DESTROYED logged and the financial loss recorded by database triggers.' },
    )
    if (r.ok) onClose()
  }
  return (
    <Modal
      open
      onClose={onClose}
      icon={Flame}
      title={`Certify destruction for return #${ret.return_id}`}
      description={`${num(ret.quantity_returned)} units of ${L.batchNo(ret.batch_id)} · witnessed by you`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="danger" icon={Flame} disabled={!hash} loading={busy === 'dispose'} onClick={submit}>
            Issue certificate
          </Button>
        </>
      }
    >
      <div className="mfr-stack">
        <Field label="Disposal method">
          <Select value={method} onChange={(e) => setMethod(e.target.value)}>
            {DISPOSAL_METHODS.map((m) => (
              <option key={m} value={m}>
                {humanize(m)}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Evidence hash" hint="SHA-256 fingerprint of the destruction record, generated in your browser.">
          <Input readOnly value={hash} className="mfr-hash-input" />
        </Field>
        <Callout tone="warn">Certificates are permanent. Two triggers fire: one writes a HIGH-severity DRUGS_DESTROYED event, the other books the loss in financial analytics.</Callout>
      </div>
    </Modal>
  )
}

function RestockModal({ ret, onClose }: { ret: ReturnRequest | null; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const { data } = useTables(['locations', 'inventory', 'locationLoad'] as const)
  const { run, busy } = useRunner()
  const [loc, setLoc] = useState('')
  if (!ret) return null
  const pkg = L.pkgOfBatch(ret.batch_id)
  // With RLS a manufacturer only sees its own stock rows, so zone totals come from
  // vw_location_load; without it (before rls.sql) the inventory rows hold everything.
  const load = new Map(data.locationLoad.map((r) => [r.location_id, Number(r.units_stored)]))
  const usedAt = (id: number) => (load.size ? (load.get(id) ?? 0) : data.inventory.filter((i) => i.location_id === id).reduce((s, i) => s + i.available_quantity, 0))
  const options = data.locations.map((l) => ({ l, fit: locationFits(l, pkg), used: usedAt(l.location_id) }))
  const submit = async () => {
    const r = await run(
      'restock',
      async () => {
        const { error } = await db('warehouse').from('stock_movement_history').insert({ batch_id: ret.batch_id, source_location_id: null, destination_location_id: Number(loc), user_id: profile.user_id, quantity_moved: ret.quantity_returned, movement_type: 'Inbound' })
        if (error) throw error
        await mustChange(db('reverse').from('return_requests').update({ status: 'Closed' }).eq('return_id', ret.return_id).select('return_id'))
        await logEvent(profile.user_id, 'RETURN_RESTOCKED', 'REVERSE_LOGISTICS', { return_id: ret.return_id, batch_id: ret.batch_id, batch_number: L.batchNo(ret.batch_id), location_id: Number(loc), quantity: ret.quantity_returned, severity: 'LOW' })
      },
      { success: 'Stock returned to saleable inventory', description: 'Inventory updated by the stock-movement trigger; return closed.' },
    )
    if (r.ok) onClose()
  }
  return (
    <Modal
      open
      onClose={onClose}
      icon={PackagePlus}
      title={`Restock return #${ret.return_id}`}
      description={`${num(ret.quantity_returned)} units of ${L.batchNo(ret.batch_id)} back into inventory`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={PackagePlus} disabled={!loc} loading={busy === 'restock'} onClick={submit}>
            Restock & close
          </Button>
        </>
      }
    >
      <Field label="Destination location" hint="Only zones whose temperature and humidity match the medicine are selectable.">
        <Select value={loc} onChange={(e) => setLoc(e.target.value)}>
          <option value="">Choose a location…</option>
          {options.map(({ l, fit, used }) => (
            <option key={l.location_id} value={l.location_id} disabled={!fit.ok}>
              {L.locLabel(l.location_id)} · {num(used)}/{num(l.max_capacity)} {fit.ok ? '' : `· ${fit.reason}`}
            </option>
          ))}
        </Select>
      </Field>
    </Modal>
  )
}

type Filter = 'action' | ReturnStatus | 'all'

export function Returns() {
  const profile = useProfile()
  const L = useLookups()
  const { ids } = useMyBatches()
  const t = useTables(['returns', 'assessments', 'refunds', 'disposals'] as const)
  const { run, busy } = useRunner()
  const [filter, setFilter] = useState<Filter>('action')
  const [assessing, setAssessing] = useState<ReturnRequest | null>(null)
  const [disposing, setDisposing] = useState<ReturnRequest | null>(null)
  const [restocking, setRestocking] = useState<ReturnRequest | null>(null)

  const model = useMemo(() => {
    const d = t.data
    const assessmentByReturn = new Map(d.assessments.map((a) => [a.return_id, a]))
    const voucherByReturn = new Map(d.refunds.map((v) => [v.return_id, v]))
    const certByAssessment = new Map(d.disposals.map((c) => [c.assessment_id, c]))
    const rows = d.returns
      .filter((r) => ids.has(r.batch_id))
      .map((r) => {
        const a = assessmentByReturn.get(r.return_id)
        const v = voucherByReturn.get(r.return_id)
        const cert = a ? certByAssessment.get(a.assessment_id) : undefined
        let next: 'assess' | 'dispose' | 'restock' | 'close' | 'payout' | 'wait' | 'done' = 'wait'
        if (r.status === 'Received') next = 'assess'
        else if (r.status === 'Assessed' && a) {
          if (a.disposition_action === 'Approve_Refund_and_Destroy' && !cert) next = 'dispose'
          else if (a.disposition_action === 'Approve_Refund_and_Restock') next = 'restock'
          else next = 'close'
        } else if (r.status === 'Closed') next = v?.refund_status === 'Pending_Payout' ? 'payout' : 'done'
        if (r.status === 'Assessed' && v?.refund_status === 'Pending_Payout' && next === 'close') next = 'payout'
        return { r, a, v, cert, next }
      })
    return { rows }
  }, [t.data, ids])

  type Row = (typeof model.rows)[number]
  const needsAction = (x: Row) => ['assess', 'dispose', 'restock', 'close', 'payout'].includes(x.next)
  const rows = model.rows.filter((x) => (filter === 'all' ? true : filter === 'action' ? needsAction(x) : x.r.status === filter))

  const close = (r: ReturnRequest) =>
    run(
      `close-${r.return_id}`,
      async () => {
        await mustChange(db('reverse').from('return_requests').update({ status: 'Closed' }).eq('return_id', r.return_id).select('return_id'))
        await logEvent(profile.user_id, 'RETURN_CLOSED', 'REVERSE_LOGISTICS', { return_id: r.return_id, batch_id: r.batch_id, batch_number: L.batchNo(r.batch_id), severity: 'LOW' })
      },
      { success: `Return #${r.return_id} closed` },
    )

  const payout = (voucherId: number, amount: number, returnId: number) =>
    run(
      `payout-${voucherId}`,
      async () => {
        await mustChange(db('reverse').from('refund_vouchers').update({ refund_status: 'Processed' }).eq('voucher_id', voucherId).select('voucher_id'))
        await logEvent(profile.user_id, 'REFUND_PAID_OUT', 'FINANCIAL_ANALYTICS', { voucher_id: voucherId, return_id: returnId, refund_amount: amount, severity: 'LOW' })
      },
      { success: `Refund of ${money(amount)} paid out` },
    )

  const count = (f: Filter) => model.rows.filter((x) => (f === 'all' ? true : f === 'action' ? needsAction(x) : x.r.status === f)).length
  const pendingPayout = model.rows.filter((x) => x.v?.refund_status === 'Pending_Payout').reduce((s, x) => s + Number(x.v!.refund_amount), 0)

  const columns: Column<Row>[] = [
    { key: 'id', header: 'Return', sort: (x) => x.r.return_id, cell: (x) => <span className="mfr-return-id">#{x.r.return_id}</span> },
    {
      key: 'batch',
      header: 'Batch',
      sort: (x) => L.batchNo(x.r.batch_id),
      cell: (x) => (
        <div>
          <Code>{L.batchNo(x.r.batch_id)}</Code>
          <p className="mfr-cell-sub">{L.medName(x.r.batch_id)}</p>
        </div>
      ),
    },
    { key: 'from', header: 'Returned by', sort: (x) => L.orgName(x.r.returner_org_id), cell: (x) => <span className="mfr-cell-text">{L.orgName(x.r.returner_org_id)}</span>, hideBelow: 'md' },
    { key: 'qty', header: 'Units', align: 'right', sort: (x) => x.r.quantity_returned, cell: (x) => num(x.r.quantity_returned) },
    {
      key: 'reason',
      header: 'Reason',
      cell: (x) => (
        <div className="mfr-reason-cell">
          <p className="mfr-reason-text" title={x.r.return_reason}>
            {x.r.return_reason}
          </p>
          {x.r.recall_id && <Badge tone="critical">Recall #{x.r.recall_id}</Badge>}
        </div>
      ),
      hideBelow: 'lg',
    },
    { key: 'status', header: 'Stage', sort: (x) => RETURN_FLOW.indexOf(x.r.status), cell: (x) => <StatusBadge value={x.r.status} meta={RETURN_STATUS} /> },
    {
      key: 'outcome',
      header: 'Outcome',
      cell: (x) =>
        x.a ? (
          <div className="mfr-outcome-cell">
            <StatusBadge value={x.a.disposition_action} meta={DISPOSITION} />
            {x.v && <span className="mfr-cell-sub">{money(x.v.refund_amount)} · {REFUND_STATUS[x.v.refund_status].label}</span>}
            {x.cert && <span className="mfr-cell-sub">Destroyed · {humanize(x.cert.disposal_method)}</span>}
          </div>
        ) : (
          <span className="mfr-cell-muted">Not inspected</span>
        ),
    },
    {
      key: 'action',
      header: 'Next step',
      cell: (x) => {
        switch (x.next) {
          case 'assess':
            return <Button size="xs" variant="primary" icon={ScanSearch} onClick={() => setAssessing(x.r)}>Inspect</Button>
          case 'dispose':
            return <Button size="xs" variant="danger" icon={Flame} onClick={() => setDisposing(x.r)}>Certify disposal</Button>
          case 'restock':
            return <Button size="xs" icon={PackagePlus} onClick={() => setRestocking(x.r)}>Restock</Button>
          case 'payout':
            return <Button size="xs" variant="success" icon={IndianRupee} loading={busy === `payout-${x.v!.voucher_id}`} onClick={() => void payout(x.v!.voucher_id, Number(x.v!.refund_amount), x.r.return_id)}>Pay out</Button>
          case 'close':
            return <Button size="xs" icon={CheckCircle2} loading={busy === `close-${x.r.return_id}`} onClick={() => void close(x.r)}>Close</Button>
          case 'done':
            return <span className="mfr-done-text">Complete</span>
          default:
            return <span className="mfr-cell-muted">Awaiting depot</span>
        }
      },
    },
  ]

  return (
    <>
      <PageHeader />
      <StatGrid cols={4}>
        <Stat label="Needs your action" value={num(count('action'))} sub="inspect, dispose, restock, pay out or close" icon={ScanSearch} tone="warn" onClick={() => setFilter('action')} />
        <Stat label="Awaiting inspection" value={num(count('Received'))} sub="received at depot" icon={Undo2} tone="accent" onClick={() => setFilter('Received')} />
        <Stat label="Refunds pending payout" value={money(pendingPayout)} sub="issued vouchers not yet paid" icon={IndianRupee} tone="info" />
        <Stat label="Disposal certificates" value={num(model.rows.filter((x) => x.cert).length)} sub="witnessed destructions" icon={Flame} tone="serious" />
      </StatGrid>

      <Card className="mfr-returns-card">
        <CardHeader title="Reverse logistics pipeline" subtitle="Filed → In transit → Received → Assessed → Closed. Distributors handle pickup and receipt; you inspect and decide." />
        <div className="mfr-returns-filter">
          <Segmented<Filter>
            value={filter}
            onChange={setFilter}
            options={[
              { value: 'action', label: 'Needs action', count: count('action') },
              ...RETURN_FLOW.map((s) => ({ value: s as Filter, label: RETURN_STATUS[s].label, count: count(s) })),
              { value: 'all', label: 'All', count: count('all') },
            ]}
          />
        </div>
        <DataTable
          bare
          rows={rows}
          columns={columns}
          rowKey={(x) => x.r.return_id}
          loading={t.isLoading}
          searchText={(x) => `${x.r.return_id} ${L.batchNo(x.r.batch_id)} ${L.orgName(x.r.returner_org_id)} ${x.r.return_reason}`}
          emptyTitle="Nothing in this stage"
          initialSort={{ key: 'id', dir: 'desc' }}
          exportName="lethe-returns"
          exportRow={(x) => ({ return_id: x.r.return_id, batch: L.batchNo(x.r.batch_id), returned_by: L.orgName(x.r.returner_org_id), units: x.r.quantity_returned, reason: x.r.return_reason, stage: x.r.status, disposition: x.a?.disposition_action ?? '', refund: x.v?.refund_amount ?? '', filed: date(x.r.created_at_utc) })}
        />
      </Card>

      <AssessModal ret={assessing} onClose={() => setAssessing(null)} />
      <DisposeModal ret={disposing} assessmentId={disposing ? model.rows.find((x) => x.r.return_id === disposing.return_id)?.a?.assessment_id : undefined} onClose={() => setDisposing(null)} />
      <RestockModal ret={restocking} onClose={() => setRestocking(null)} />
    </>
  )
}
