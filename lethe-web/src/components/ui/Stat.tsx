import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { TONE } from './tone'

/** KPI tile: label, value, optional sub-line and icon. */
export function Stat({
  label,
  value,
  sub,
  icon: Icon,
  tone = 'accent',
  loading,
  onClick,
  className,
}: {
  label: string
  value: ReactNode
  sub?: ReactNode
  icon?: LucideIcon
  tone?: Tone
  loading?: boolean
  onClick?: () => void
  className?: string
}) {
  const t = TONE[tone]
  const Comp = onClick ? 'button' : 'div'
  return (
    <Comp
      onClick={onClick}
      className={cn(
        'group relative flex min-w-0 flex-col gap-3 rounded-2xl border border-line bg-surface p-4 text-left shadow-[0_1px_2px_rgba(16,24,40,0.04)]',
        onClick && 'cursor-pointer transition-colors hover:border-line-strong hover:bg-surface-2',
        className,
      )}
    >
      <div className="flex items-start justify-between gap-2">
        <span className="text-[13px] leading-5 font-medium text-ink-2">{label}</span>
        {Icon && (
          <span className={cn('grid size-8 shrink-0 place-items-center rounded-lg', t.soft, t.text)}>
            <Icon className="size-4" />
          </span>
        )}
      </div>
      {loading ? (
        <div className="h-8 w-24 animate-pulse rounded-md bg-surface-3" />
      ) : (
        <div className="truncate text-[28px] leading-8 font-semibold tracking-tight text-ink">{value}</div>
      )}
      {sub && <div className="line-clamp-2 text-[12.5px] leading-[18px] text-ink-2">{sub}</div>}
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
