import type { ReactNode } from 'react'
import { cn } from '@/lib/cn'

export interface SegmentOption<V extends string> {
  value: V
  label: ReactNode
  count?: number
}

/** Row of filter buttons (All / Pending / Shipped ...). */
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
    <div className={cn('tab-buttons', className)}>
      {options.map((o) => (
        <button key={o.value} onClick={() => onChange(o.value)} className={cn('tab-btn', size === 'sm' && 'tab-btn-small', o.value === value && 'selected')}>
          {o.label}
          {o.count != null && <span className="count-num"> ({o.count})</span>}
        </button>
      ))}
    </div>
  )
}
