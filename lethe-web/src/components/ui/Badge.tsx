import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { StatusMeta, Tone } from '@/lib/domain'
import { TONE } from './tone'

export function Badge({
  tone = 'neutral',
  icon: Icon,
  dot,
  children,
  className,
  title,
}: {
  tone?: Tone
  icon?: LucideIcon
  dot?: boolean
  children: ReactNode
  className?: string
  title?: string
}) {
  const t = TONE[tone]
  return (
    <span
      title={title}
      className={cn('inline-flex max-w-full items-center gap-1.5 rounded-full px-2 py-0.5 text-xs leading-5 font-medium whitespace-nowrap', t.soft, t.text, className)}
    >
      {Icon ? <Icon className="size-3.5 shrink-0" /> : dot ? <span className={cn('size-1.5 shrink-0 rounded-full', t.dot)} /> : null}
      <span className="truncate">{children}</span>
    </span>
  )
}

/** A status from one of the domain status maps (always dot + label, never colour alone). */
export function StatusBadge<K extends string>({ value, meta, icon }: { value: K | null | undefined; meta: Record<K, StatusMeta>; icon?: LucideIcon }) {
  if (!value) return <Badge>—</Badge>
  const m = meta[value] ?? { label: String(value), tone: 'neutral' as Tone }
  return (
    <Badge tone={m.tone} dot={!icon} icon={icon} title={m.hint}>
      {m.label}
    </Badge>
  )
}

/** Monospace chip for IDs, batch numbers and hashes. */
export function Code({ children, className }: { children: ReactNode; className?: string }) {
  return <span className={cn('rounded-md bg-surface-3 px-1.5 py-0.5 font-mono text-[12px] whitespace-nowrap text-ink', className)}>{children}</span>
}
