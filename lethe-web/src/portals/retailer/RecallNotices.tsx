import { useState } from 'react'
import { BellRing, CheckCircle2, ShieldCheck, Undo2 } from 'lucide-react'
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
        <div className="retailer-recall-list">
          {cards.map((rc) => {
            const mine = m.notices.filter((n) => n.recall_id === rc.recall_id)
            const acked = mine.some((n) => n.delivery_status === 'Read')
            const held = m.received.get(rc.batch_id)
            const filed = m.returns.filter((x) => x.r.batch_id === rc.batch_id).reduce((s, x) => s + x.r.quantity_returned, 0)
            const outstanding = Math.max(0, (held?.qty ?? 0) - filed)
            return (
              <Card key={rc.recall_id} className={rc.quarantine_status === 'Active' ? 'retailer-recall-active' : ''}>
                <CardBody className="retailer-recall-body">
                  <div className="flex flex-wrap items-start justify-between gap-3">
                    <div className="min-w-0">
                      <div className="flex flex-wrap items-center gap-2">
                        <p className="retailer-recall-med">{L.medName(rc.batch_id)}</p>
                        <Code>{L.batchNo(rc.batch_id)}</Code>
                        <StatusBadge value={rc.quarantine_status} meta={RECALL_STATUS} />
                      </div>
                      <p className="retailer-recall-reason">{rc.recall_reason}</p>
                      <p className="retailer-recall-meta">
                        Recall #{rc.recall_id} by {L.orgName(rc.initiated_by_org_id)} · {dateTime(rc.created_at_utc)} ({relative(rc.created_at_utc)})
                      </p>
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

                  <div className="retailer-recall-facts grid gap-3 md:grid-cols-3">
                    <div className="retailer-fact-box">
                      <p className="retailer-fact-label">Units you received</p>
                      <p className="retailer-fact-num">{num(held?.qty ?? 0)}</p>
                      <p className="retailer-fact-sub">{held ? `orders ${held.orders.map((o) => `#${o}`).join(', ')}` : 'not in your deliveries'}</p>
                    </div>
                    <div className="retailer-fact-box">
                      <p className="retailer-fact-label">Already returned</p>
                      <p className="retailer-fact-num">{num(filed)}</p>
                    </div>
                    <div className="retailer-fact-box">
                      <p className="retailer-fact-label">Notices to you</p>
                      <div className="retailer-fact-tags">
                        {mine.length === 0 && <span className="retailer-fact-sub">Network-wide notice</span>}
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
