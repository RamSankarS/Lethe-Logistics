import { useState } from 'react'
import { BellRing, CheckCircle2, ShieldCheck, Siren, Undo2 } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody } from '@/components/ui/Card'
import { EmptyState } from '@/components/ui/Feedback'
import { COMM_STATUS, RECALL_STATUS } from '@/lib/domain'
import { dateTime, humanize, num, relative } from '@/lib/format'
import { FileReturnModal, useRetailerModel } from './shared'

export function RecallNotices() {
  const profile = useProfile()
  const L = useLookups()
  const m = useRetailerModel()
  const { run, busy } = useRunner()
  const [returning, setReturning] = useState<{ batchId: number; qty: number } | null>(null)

  const recallIds = [...new Set([...m.notices.map((n) => n.recall_id), ...m.activeRecalls.map((r) => r.recall_id)])]
  const cards = recallIds
    .map((id) => m.recalls.find((r) => r.recall_id === id))
    .filter((r): r is NonNullable<typeof r> => !!r)
    .sort((a, b) => b.created_at_utc.localeCompare(a.created_at_utc))

  const acknowledge = (recallId: number) =>
    run(
      `ack-${recallId}`,
      async () => {
        await mustChange(db('reverse').from('recall_communication_logs').update({ delivery_status: 'Read' }).eq('recall_id', recallId).eq('notified_org_id', profile.org!.org_id).neq('delivery_status', 'Read').select('log_id'))
        await logEvent(profile.user_id, 'RECALL_ACKNOWLEDGED', 'REVERSE_LOGISTICS', { recall_id: recallId, org: profile.org!.org_name, severity: 'LOW' })
      },
      { success: 'Recall acknowledged', description: 'The manufacturer can see your acknowledgement.' },
    )

  return (
    <>
      <PageHeader />
      {cards.length === 0 ? (
        <Card>
          <EmptyState icon={ShieldCheck} title="No recall notices">
            When a manufacturer recalls a batch, the notice arrives here.
          </EmptyState>
        </Card>
      ) : (
        <div className="space-y-4">
          {cards.map((rc) => {
            const mine = m.notices.filter((n) => n.recall_id === rc.recall_id)
            const acked = mine.some((n) => n.delivery_status === 'Read')
            const held = m.received.get(rc.batch_id)
            const filed = m.returns.filter((x) => x.r.batch_id === rc.batch_id).reduce((s, x) => s + x.r.quantity_returned, 0)
            const outstanding = Math.max(0, (held?.qty ?? 0) - filed)
            return (
              <Card key={rc.recall_id} className={rc.quarantine_status === 'Active' ? 'border-critical/40' : ''}>
                <CardBody className="pt-5">
                  <div className="flex flex-wrap items-start justify-between gap-3">
                    <div className="flex min-w-0 items-start gap-3">
                      <span className="grid size-10 shrink-0 place-items-center rounded-xl bg-critical-soft text-critical-text">
                        <Siren className="size-5" />
                      </span>
                      <div className="min-w-0">
                        <div className="flex flex-wrap items-center gap-2">
                          <p className="text-[15px] font-semibold text-ink">{L.medName(rc.batch_id)}</p>
                          <Code>{L.batchNo(rc.batch_id)}</Code>
                          <StatusBadge value={rc.quarantine_status} meta={RECALL_STATUS} />
                        </div>
                        <p className="mt-1 text-[13px] leading-5 text-ink-2">{rc.recall_reason}</p>
                        <p className="mt-1 text-xs text-muted">
                          Recall #{rc.recall_id} by {L.orgName(rc.initiated_by_org_id)} · {dateTime(rc.created_at_utc)} ({relative(rc.created_at_utc)})
                        </p>
                      </div>
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {mine.length > 0 &&
                        (acked ? (
                          <Badge tone="good" icon={CheckCircle2}>
                            Acknowledged
                          </Badge>
                        ) : (
                          <Button size="sm" icon={BellRing} loading={busy === `ack-${rc.recall_id}`} onClick={() => void acknowledge(rc.recall_id)}>
                            Acknowledge
                          </Button>
                        ))}
                      {rc.quarantine_status === 'Active' && (
                        <Button size="sm" variant="danger" icon={Undo2} onClick={() => setReturning({ batchId: rc.batch_id, qty: outstanding || 1 })}>
                          Return stock
                        </Button>
                      )}
                    </div>
                  </div>

                  <div className="mt-4 grid gap-3 md:grid-cols-3">
                    <div className="rounded-xl bg-surface-2 px-3 py-2.5">
                      <p className="text-[11.5px] text-muted">Units you received</p>
                      <p className="text-[15px] font-semibold text-ink tabular">{num(held?.qty ?? 0)}</p>
                      <p className="text-xs text-ink-2">{held ? `orders ${held.orders.map((o) => `#${o}`).join(', ')}` : 'not in your deliveries'}</p>
                    </div>
                    <div className="rounded-xl bg-surface-2 px-3 py-2.5">
                      <p className="text-[11.5px] text-muted">Already returned</p>
                      <p className="text-[15px] font-semibold text-ink tabular">{num(filed)}</p>
                    </div>
                    <div className="rounded-xl bg-surface-2 px-3 py-2.5">
                      <p className="text-[11.5px] text-muted">Notices to you</p>
                      <div className="mt-1 flex flex-wrap gap-1">
                        {mine.length === 0 && <span className="text-xs text-ink-2">Network-wide notice</span>}
                        {mine.map((n) => (
                          <Badge key={n.log_id} tone={COMM_STATUS[n.delivery_status].tone} dot>
                            {humanize(n.channel)}
                          </Badge>
                        ))}
                      </div>
                    </div>
                  </div>
                </CardBody>
              </Card>
            )
          })}
        </div>
      )}
      <FileReturnModal open={!!returning} onClose={() => setReturning(null)} presetBatch={returning?.batchId} presetQty={returning?.qty} presetReason="Mandatory recall" />
    </>
  )
}
