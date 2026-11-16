import type { HTMLAttributes, ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'

export function Card({ className, children, ...rest }: HTMLAttributes<HTMLDivElement>) {
  return (
    <div className={cn('box-1', className)} {...rest}>
      {children}
    </div>
  )
}

export function CardHeader({
  title,
  subtitle,
  actions,
  className,
}: {
  title: ReactNode
  subtitle?: ReactNode
  /** kept so old code still compiles, not shown any more */
  icon?: LucideIcon
  actions?: ReactNode
  className?: string
}) {
  return (
    <div className={cn('box-header', className)}>
      <div style={{ minWidth: 0 }}>
        <h3 className="box-title">{title}</h3>
        {subtitle && <p className="box-subtitle">{subtitle}</p>}
      </div>
      {actions && <div className="box-actions">{actions}</div>}
    </div>
  )
}

export function CardBody({ className, children }: { className?: string; children: ReactNode }) {
  return <div className={cn('box-body', className)}>{children}</div>
}

/** Section title used between groups of cards. */
export function SectionTitle({ children, hint, actions }: { children: ReactNode; hint?: ReactNode; actions?: ReactNode }) {
  return (
    <div className="section-heading">
      <div>
        <h2>{children}</h2>
        {hint && <p>{hint}</p>}
      </div>
      {actions}
    </div>
  )
}
