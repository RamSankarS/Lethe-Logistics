import type { ReactNode } from 'react'
import { cn } from '@/lib/cn'

export interface SegmentOption<V extends string> {
  value: V
  label: ReactNode
  count?: number
}

/** Pill-style filter / sub-view switcher. */
export function Segmented<V extends string>({
  options,
  value,
  onChange,
  className,
  size = 'md',
}: {
  options: SegmentOption<V>[]
  value: V
  onChange: (v: V) => void
  className?: string
  size?: 'sm' | 'md'
}) {
  return (
    <div className={cn('scrollbar-none inline-flex max-w-full items-center gap-1 overflow-x-auto rounded-xl border border-line bg-surface-2 p-1', className)}>
      {options.map((o) => {
        const active = o.value === value
        return (
          <button
            key={o.value}
            onClick={() => onChange(o.value)}
            className={cn(
              'inline-flex shrink-0 items-center gap-1.5 rounded-lg font-medium whitespace-nowrap transition-colors',
              size === 'sm' ? 'h-7 px-2.5 text-xs' : 'h-8 px-3 text-[13px]',
              active ? 'bg-surface text-ink shadow-sm ring-1 ring-line' : 'text-ink-2 hover:text-ink',
            )}
          >
            {o.label}
            {o.count != null && (
              <span className={cn('tabular rounded-full px-1.5 text-[11px] leading-4', active ? 'bg-accent-soft text-accent-text' : 'bg-surface-3 text-ink-2')}>{o.count}</span>
            )}
          </button>
        )
      })}
    </div>
  )
}
