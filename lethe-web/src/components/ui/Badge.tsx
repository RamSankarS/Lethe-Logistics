import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { StatusMeta, Tone } from '@/lib/domain'

// css class for each colour
const TAG_COLOUR: Record<Tone, string> = {
  neutral: 'tag-grey',
  info: 'tag-teal',
  good: 'tag-green',
  warn: 'tag-yellow',
  serious: 'tag-orange',
  critical: 'tag-red',
  accent: 'tag-blue',
}

export function Badge({
  tone = 'neutral',
  icon: Icon,
  children,
  className,
  title,
}: {
  tone?: Tone
  icon?: LucideIcon
  /** not used any more */
  dot?: boolean
  children: ReactNode
  className?: string
  title?: string
}) {
  return (
    <span title={title} className={cn('label-tag', TAG_COLOUR[tone], className)}>
      {Icon && <Icon />}
      <span>{children}</span>
    </span>
  )
}

/** A status from one of the domain status maps. */
export function StatusBadge<K extends string>({ value, meta, icon }: { value: K | null | undefined; meta: Record<K, StatusMeta>; icon?: LucideIcon }) {
  if (!value) return <Badge>—</Badge>
  const m = meta[value] ?? { label: String(value), tone: 'neutral' as Tone }
  return (
    <Badge tone={m.tone} icon={icon} title={m.hint}>
      {m.label}
    </Badge>
  )
}

/** Monospace text for IDs, batch numbers and hashes. */
export function Code({ children, className }: { children: ReactNode; className?: string }) {
  return <span className={cn('code-text', className)}>{children}</span>
}
