import { useMemo, useState } from 'react'
import { GitBranch } from 'lucide-react'
import { useLookups, useTables } from '@/data/hooks'
import { StatusBadge } from '@/components/ui/Badge'
import { Card } from '@/components/ui/Card'
import { EmptyState } from '@/components/ui/Feedback'
import { BatchPedigree, BatchSearch } from '@/components/domain/BatchPedigree'
import { BATCH_STATUS } from '@/lib/domain'
import { cn } from '@/lib/cn'

/** Traceability workbench: pick any batch and see its full chain of custody. */
export function TraceWorkbench({ scope }: { scope?: Set<number> }) {
  const L = useLookups()
  const t = useTables(['recalls', 'quarantine', 'returns'] as const)
  const [picked, setPicked] = useState<number | null>(null)

  const quick = useMemo(() => {
    const inScope = (id: number) => !scope || scope.has(id)
    const recalled = t.data.recalls.map((r) => r.batch_id)
    const quarantined = t.data.quarantine.filter((q) => q.status === 'Active').map((q) => q.batch_id)
    const returned = t.data.returns.map((r) => r.batch_id)
    const ids = [...new Set([...recalled, ...quarantined, ...returned])].filter(inScope).slice(0, 8)
    return ids.map((id) => ({ id, why: recalled.includes(id) ? 'Recalled' : quarantined.includes(id) ? 'Quarantined' : 'Returned' }))
  }, [t.data, scope])

  const current = picked ?? quick[0]?.id ?? null

  return (
    <div className="grid gap-5 xl:grid-cols-[320px_1fr]">
      <div className="space-y-4">
        <BatchSearch onPick={setPicked} />
        <Card className="p-2">
          <p className="px-3 pt-2 pb-1 text-[11.5px] font-semibold tracking-wide text-muted uppercase">Batches worth investigating</p>
          {quick.length === 0 && <p className="px-3 py-2 text-[13px] text-ink-2">No flagged batches.</p>}
          {quick.map((q) => {
            const b = L.batchOf(q.id)
            if (!b) return null
            return (
              <button
                key={q.id}
                onClick={() => setPicked(q.id)}
                className={cn('flex w-full items-center justify-between gap-2 rounded-xl px-3 py-2.5 text-left transition-colors', current === q.id ? 'bg-accent-soft' : 'hover:bg-surface-2')}
              >
                <span className="min-w-0">
                  <span className="block truncate font-mono text-[13px] text-ink">{b.batch_number}</span>
                  <span className="block truncate text-xs text-ink-2">
                    {L.medOf(b)?.brand_name} · {q.why}
                  </span>
                </span>
                <StatusBadge value={b.status} meta={BATCH_STATUS} />
              </button>
            )
          })}
        </Card>
      </div>
      <div className="min-w-0">
        {current != null ? (
          <BatchPedigree batchId={current} />
        ) : (
          <Card>
            <EmptyState icon={GitBranch} title="Pick a batch">
              Search by batch number or medicine to reconstruct its full chain of custody.
            </EmptyState>
          </Card>
        )}
      </div>
    </div>
  )
}
