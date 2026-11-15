import { Check } from 'lucide-react'
import { cn } from '@/lib/cn'

/** Horizontal workflow progress (e.g. Pending → Approved → Shipped → Delivered). */
export function Stepper<S extends string>({
  steps,
  current,
  labels,
  failed,
  className,
}: {
  steps: S[]
  current: S | null | undefined
  labels?: Partial<Record<S, string>>
  /** Show the flow as stopped (e.g. a cancelled order). */
  failed?: boolean
  className?: string
}) {
  const idx = current ? steps.indexOf(current) : -1
  return (
    <ol className={cn('flex w-full items-center', className)}>
      {steps.map((s, i) => {
        const done = i < idx || (i === idx && i === steps.length - 1)
        const active = i === idx && !done
        return (
          <li key={s} className={cn('flex items-center', i < steps.length - 1 && 'flex-1')}>
            <div className="flex flex-col items-center gap-1">
              <span
                className={cn(
                  'grid size-6 place-items-center rounded-full border text-[11px] font-semibold transition-colors',
                  failed && i <= idx
                    ? 'border-line-strong bg-surface-3 text-muted'
                    : done
                      ? 'border-accent bg-accent text-accent-ink'
                      : active
                        ? 'border-accent bg-accent-soft text-accent-text ring-4 ring-accent/10'
                        : 'border-line-strong bg-surface text-muted',
                )}
              >
                {done && !failed ? <Check className="size-3.5" strokeWidth={3} /> : i + 1}
              </span>
              <span className={cn('text-[11px] whitespace-nowrap', active ? 'font-semibold text-ink' : 'text-ink-2')}>{labels?.[s] ?? s}</span>
            </div>
            {i < steps.length - 1 && <span className={cn('mx-1.5 mb-5 h-0.5 flex-1 rounded-full', i < idx && !failed ? 'bg-accent' : 'bg-line')} />}
          </li>
        )
      })}
    </ol>
  )
}
