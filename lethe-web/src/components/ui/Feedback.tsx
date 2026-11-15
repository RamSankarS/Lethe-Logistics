import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { AlertTriangle, CheckCircle2, Info, Inbox, Loader2, ShieldAlert, XCircle } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { describeError } from '@/lib/errors'
import { TONE } from './tone'

export function Spinner({ className, label }: { className?: string; label?: string }) {
  return (
    <div className={cn('flex items-center justify-center gap-2 py-10 text-sm text-ink-2', className)}>
      <Loader2 className="size-4 animate-spin" />
      {label ?? 'Loading…'}
    </div>
  )
}

export function Skeleton({ className }: { className?: string }) {
  return <div className={cn('animate-pulse rounded-lg bg-surface-3', className)} />
}

export function EmptyState({
  icon: Icon = Inbox,
  title,
  children,
  action,
  className,
}: {
  icon?: LucideIcon
  title: string
  children?: ReactNode
  action?: ReactNode
  className?: string
}) {
  return (
    <div className={cn('flex flex-col items-center justify-center px-6 py-10 text-center', className)}>
      <span className="mb-3 grid size-11 place-items-center rounded-2xl bg-surface-3 text-muted">
        <Icon className="size-5" />
      </span>
      <p className="text-sm font-semibold text-ink">{title}</p>
      {children && <p className="mt-1 max-w-sm text-[13px] text-ink-2">{children}</p>}
      {action && <div className="mt-4">{action}</div>}
    </div>
  )
}

export function ErrorState({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  const f = describeError(error)
  return (
    <div className="flex flex-col items-center justify-center px-6 py-10 text-center">
      <span className="mb-3 grid size-11 place-items-center rounded-2xl bg-critical-soft text-critical-text">
        <XCircle className="size-5" />
      </span>
      <p className="text-sm font-semibold text-ink">{f.title}</p>
      <p className="mt-1 max-w-md text-[13px] text-ink-2">{f.message}</p>
      {onRetry && (
        <button onClick={onRetry} className="mt-4 text-sm font-medium text-accent-text hover:underline">
          Try again
        </button>
      )}
    </div>
  )
}

const CALLOUT_ICON: Record<Tone, LucideIcon> = {
  neutral: Info,
  info: Info,
  accent: Info,
  good: CheckCircle2,
  warn: AlertTriangle,
  serious: AlertTriangle,
  critical: ShieldAlert,
}

/** Inline message box with an icon. */
export function Callout({
  tone = 'info',
  title,
  children,
  icon,
  action,
  className,
}: {
  tone?: Tone
  title?: ReactNode
  children?: ReactNode
  icon?: LucideIcon
  action?: ReactNode
  className?: string
}) {
  const t = TONE[tone]
  const Icon = icon ?? CALLOUT_ICON[tone]
  return (
    <div className={cn('flex items-start gap-3 rounded-xl px-4 py-3', t.soft, className)}>
      <Icon className={cn('mt-0.5 size-[18px] shrink-0', t.text)} />
      <div className="min-w-0 flex-1 text-[13px] leading-5 text-ink">
        {title && <p className={cn('font-semibold', t.text)}>{title}</p>}
        {children && <div className={cn(title && 'mt-0.5', 'text-ink-2')}>{children}</div>}
      </div>
      {action && <div className="shrink-0">{action}</div>}
    </div>
  )
}
