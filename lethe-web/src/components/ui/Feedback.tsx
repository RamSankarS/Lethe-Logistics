import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { describeError } from '@/lib/errors'

export function Spinner({ className, label }: { className?: string; label?: string }) {
  return <div className={cn('loading-text', className)}>{label ?? 'Loading...'}</div>
}

export function Skeleton({ className }: { className?: string }) {
  return <div className={cn('skeleton-box', className)} />
}

export function EmptyState({
  title,
  children,
  action,
  className,
}: {
  /** kept so old code still compiles, not shown any more */
  icon?: LucideIcon
  title: string
  children?: ReactNode
  action?: ReactNode
  className?: string
}) {
  return (
    <div className={cn('empty-msg', className)}>
      <b className="empty-title">{title}</b>
      {children && <p>{children}</p>}
      {action && <div className="empty-action">{action}</div>}
    </div>
  )
}

export function ErrorState({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  const f = describeError(error)
  return (
    <div className="error-msg">
      <b className="error-title">Error: {f.title}</b>
      {f.message}
      {onRetry && (
        <div>
          <button onClick={onRetry}>Try again</button>
        </div>
      )}
    </div>
  )
}

// alert box colours
const ALERT_COLOUR: Record<Tone, string> = {
  neutral: 'alert-grey',
  info: 'alert-blue',
  accent: 'alert-blue',
  good: 'alert-green',
  warn: 'alert-yellow',
  serious: 'alert-orange',
  critical: 'alert-red',
}

/** Message box (like the bootstrap alerts). */
export function Callout({
  tone = 'info',
  title,
  children,
  action,
  className,
}: {
  tone?: Tone
  title?: ReactNode
  children?: ReactNode
  /** kept so old code still compiles, not shown any more */
  icon?: LucideIcon
  action?: ReactNode
  className?: string
}) {
  return (
    <div className={cn('alert-box', ALERT_COLOUR[tone], className)}>
      <div className="alert-text">
        {title && <b className="alert-title">{title}</b>}
        {children && <div>{children}</div>}
      </div>
      {action && <div>{action}</div>}
    </div>
  )
}
