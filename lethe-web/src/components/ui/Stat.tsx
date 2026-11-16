import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'

// colour of the big number
const NUMBER_COLOUR: Record<Tone, string> = {
  accent: '',
  neutral: 'num-grey',
  info: 'num-teal',
  good: 'num-green',
  warn: 'num-yellow',
  serious: 'num-orange',
  critical: 'num-red',
}

/** KPI box: label, big number, small text under it. */
export function Stat({
  label,
  value,
  sub,
  tone = 'accent',
  loading,
  onClick,
  className,
}: {
  label: string
  value: ReactNode
  sub?: ReactNode
  /** kept so old code still compiles, not shown any more */
  icon?: LucideIcon
  tone?: Tone
  loading?: boolean
  onClick?: () => void
  className?: string
}) {
  const Comp = onClick ? 'button' : 'div'
  return (
    <Comp onClick={onClick} className={cn('stat-box', className)}>
      <div className="stat-label">{label}</div>
      <div className={cn('stat-number', NUMBER_COLOUR[tone])}>{loading ? '...' : value}</div>
      {sub && <div className="stat-sub">{sub}</div>}
    </Comp>
  )
}

const COLS = {
  3: 'grid-cols-1 sm:grid-cols-3',
  4: 'grid-cols-2 xl:grid-cols-4',
  6: 'grid-cols-2 md:grid-cols-3 2xl:grid-cols-6',
} as const

export function StatGrid({ children, className, cols = 6 }: { children: ReactNode; className?: string; cols?: keyof typeof COLS }) {
  return <div className={cn('grid gap-3', COLS[cols], className)}>{children}</div>
}
