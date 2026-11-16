import { cn } from '@/lib/cn'

/** Workflow steps (e.g. Pending → Approved → Shipped → Delivered). */
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
    <ol className={cn('steps', className)}>
      {steps.map((s, i) => {
        const done = i < idx || (i === idx && i === steps.length - 1)
        const active = i === idx && !done
        let circle = 'step-circle'
        if (failed && i <= idx) circle += ' step-stopped'
        else if (done) circle += ' step-done'
        else if (active) circle += ' step-now'
        return (
          <li key={s} className={cn('step', i < steps.length - 1 && 'step-grow')}>
            <div className="step-inner">
              <span className={circle}>{done && !failed ? '✓' : i + 1}</span>
              <span className={active ? 'step-name step-name-now' : 'step-name'}>{labels?.[s] ?? s}</span>
            </div>
            {i < steps.length - 1 && <span className={i < idx && !failed ? 'step-line step-line-done' : 'step-line'} />}
          </li>
        )
      })}
    </ol>
  )
}
