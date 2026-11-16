import { cn } from '@/lib/cn'

/** Plain text logo used in the top bar and on the login page. */
export function Brand({ className, subtitle = 'Logistics' }: { className?: string; subtitle?: string }) {
  return (
    <span className={cn('logo-text', className)}>
      Lethe<span className="logo-small">{subtitle}</span>
    </span>
  )
}
