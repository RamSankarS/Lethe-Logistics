import { useMemo, useState } from 'react'
import { BadgeCheck, Ban, FlaskConical, PauseCircle } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { Button } from '@/components/ui/Button'
import { Checkbox } from '@/components/ui/Form'
import { Callout } from '@/components/ui/Feedback'
import { ConfirmDialog, Modal } from '@/components/ui/Modal'
import { BATCH_TRANSITIONS } from '@/lib/domain'
import type { Batch, BatchStatus } from '@/lib/types'

/** Batches owned by the signed-in manufacturer organisation. */
export function useMyBatches() {
  const profile = useProfile()
  const t = useTables(['batches', 'inventory'] as const)
  const orgId = profile.org?.org_id
  return useMemo(() => {
    const mine = t.data.batches.filter((b) => b.manufacturer_id === orgId)
    const stock = new Map<number, number>()
    for (const i of t.data.inventory) stock.set(i.batch_id, (stock.get(i.batch_id) ?? 0) + i.available_quantity)
    return { batches: mine, stock, isLoading: t.isLoading, ids: new Set(mine.map((b) => b.batch_id)) }
  }, [t.data.batches, t.data.inventory, t.isLoading, orgId])
}

const ACTION: Record<BatchStatus, { label: string; icon: typeof FlaskConical; variant: 'primary' | 'secondary' | 'danger' | 'success' }> = {
  'Quality-Check': { label: 'Send to QC', icon: FlaskConical, variant: 'secondary' },
  Released: { label: 'Release', icon: BadgeCheck, variant: 'success' },
  Rejected: { label: 'Reject', icon: Ban, variant: 'danger' },
  Pending: { label: 'Pending', icon: PauseCircle, variant: 'secondary' },
  Recalled: { label: 'Recall', icon: Ban, variant: 'danger' },
}

/**
 * QC workflow buttons for one batch. Release requires ticking every line of the
 * medicine's quality specification; Reject is terminal and asks for confirmation.
 * The database (tr_enforce_batch_workflow) enforces the same rules.
 */
export function BatchActions({ batch, size = 'sm' }: { batch: Batch; size?: 'xs' | 'sm' }) {
  const profile = useProfile()
  const L = useLookups()
  const { data } = useTables(['specs'] as const)
  const { run, busy } = useRunner()
  const [releasing, setReleasing] = useState(false)
  const [rejecting, setRejecting] = useState(false)
  const [checks, setChecks] = useState<Record<string, boolean>>({})

  const transitions = BATCH_TRANSITIONS[batch.status]
  const spec = data.specs.find((s) => s.medicine_id === batch.medicine_id)
  const med = L.medOf(batch)
  const checklist = spec
    ? [
        { id: 'purity', label: `Assay purity ≥ ${spec.purity_threshold}%` },
        { id: 'diss', label: `Dissolution within ${spec.dissolution_rate}` },
        { id: 'ph', label: `pH balance at ${spec.ph_balance_req}` },
        { id: 'certs', label: `Certificates on file: ${spec.required_certs}` },
        { id: 'pack', label: 'Packaging, labelling and batch coding verified' },
      ]
    : [{ id: 'manual', label: 'Manual QC inspection completed (no spec on file)' }]
  const allChecked = checklist.every((c) => checks[c.id])

  const setStatus = (status: BatchStatus) =>
    run(
      `status-${batch.batch_id}`,
      async () => {
        await mustChange(db('product').from('batch_master').update({ status }).eq('batch_id', batch.batch_id).select('batch_id'))
        if (status === 'Released') await logEvent(profile.user_id, 'BATCH_QC_PASSED', 'PRODUCT_INTELLIGENCE', { batch_id: batch.batch_id, batch_number: batch.batch_number, checklist: checklist.map((c) => c.label), severity: 'MEDIUM' })
      },
      { success: `${batch.batch_number} → ${status}` },
    )

  if (!transitions.length) return <span className="mfr-locked-text">Locked</span>

  return (
    <div className="mfr-qc-buttons" onClick={(e) => e.stopPropagation()}>
      {transitions.map((s) => {
        const a = s === 'Quality-Check' && batch.status === 'Released' ? { ...ACTION[s], label: 'Hold for QC' } : ACTION[s]
        return (
          <Button
            key={s}
            size={size}
            variant={a.variant === 'success' ? 'success' : a.variant === 'danger' ? 'ghost' : 'secondary'}
            icon={a.icon}
            loading={busy === `status-${batch.batch_id}`}
            className={a.variant === 'danger' ? 'mfr-reject-btn' : undefined}
            onClick={() => (s === 'Released' ? (setChecks({}), setReleasing(true)) : s === 'Rejected' ? setRejecting(true) : void setStatus(s))}
          >
            {a.label}
          </Button>
        )
      })}

      <Modal
        open={releasing}
        onClose={() => setReleasing(false)}
        icon={BadgeCheck}
        title={`Release ${batch.batch_number}`}
        description={`${med?.brand_name ?? 'Medicine'}: confirm every quality specification before release.`}
        footer={
          <>
            <Button variant="ghost" onClick={() => setReleasing(false)}>
              Cancel
            </Button>
            <Button
              variant="success"
              icon={BadgeCheck}
              disabled={!allChecked}
              loading={busy === `status-${batch.batch_id}`}
              onClick={async () => {
                const r = await setStatus('Released')
                if (r.ok) setReleasing(false)
              }}
            >
              Release batch
            </Button>
          </>
        }
      >
        <div className="mfr-checklist">
          {checklist.map((c) => (
            <Checkbox key={c.id} label={c.label} checked={!!checks[c.id]} onChange={(v) => setChecks((p) => ({ ...p, [c.id]: v }))} />
          ))}
          <Callout tone="info" className="mfr-checklist-note">
            Released batches become orderable by retailers. The database rejects releasing a batch that skipped the quality check.
          </Callout>
        </div>
      </Modal>

      <ConfirmDialog
        open={rejecting}
        onClose={() => setRejecting(false)}
        danger
        icon={Ban}
        title={`Reject ${batch.batch_number}?`}
        confirmLabel="Reject batch"
        loading={busy === `status-${batch.batch_id}`}
        onConfirm={async () => {
          const r = await setStatus('Rejected')
          if (r.ok) setRejecting(false)
        }}
      >
        A rejected batch can <b className="mfr-strong">never</b> re-enter the supply chain. The governance trigger blocks any attempt to revive it, and the decision is written to the immutable audit ledger.
      </ConfirmDialog>
    </div>
  )
}

export { useReferencePrice } from '@/data/pricing'
