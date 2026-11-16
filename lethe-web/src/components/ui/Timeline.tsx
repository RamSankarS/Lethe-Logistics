import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { dateTime } from '@/lib/format'

export interface TimelineItem {
  id: string
  at: string
  title: ReactNode
  detail?: ReactNode
  icon: LucideIcon
  tone?: Tone
  tag?: ReactNode
}

// colour of the little square next to each event
const DOT: Record<Tone, string> = {
  neutral: 'fill-grey',
  info: 'fill-teal',
  good: 'fill-green',
  warn: 'fill-yellow',
  serious: 'fill-orange',
  critical: 'fill-red',
  accent: 'fill-blue',
}

export function Timeline({ items, className }: { items: TimelineItem[]; className?: string }) {
  return (
    <ol className={cn('event-list', className)}>
      {items.map((it) => {
        const Icon = it.icon
        return (
          <li key={it.id} className="event-item">
            <span className={cn('event-dot', DOT[it.tone ?? 'neutral'])} />
            <div className="event-title">
              <Icon />
              {it.title}
              {it.tag}
            </div>
            {it.detail && <div className="event-detail">{it.detail}</div>}
            <div className="event-date">{dateTime(it.at)}</div>
          </li>
        )
      })}
    </ol>
  )
}
