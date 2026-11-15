import type { ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { dateTime } from '@/lib/format'
import { TONE } from './tone'

export interface TimelineItem {
  id: string
  at: string
  title: ReactNode
  detail?: ReactNode
  icon: LucideIcon
  tone?: Tone
  tag?: ReactNode
}

export function Timeline({ items, className }: { items: TimelineItem[]; className?: string }) {
  return (
    <ol className={cn('relative', className)}>
      {items.map((it, i) => {
        const t = TONE[it.tone ?? 'neutral']
        const Icon = it.icon
        return (
          <li key={it.id} className="relative flex gap-3 pb-5 last:pb-0">
            {i < items.length - 1 && <span className="absolute top-8 bottom-0 left-[15px] w-px bg-line" />}
            <span className={cn('relative z-[1] grid size-8 shrink-0 place-items-center rounded-full ring-4 ring-page', t.soft, t.text)}>
              <Icon className="size-4" />
            </span>
            <div className="min-w-0 flex-1 pt-1">
              <div className="flex flex-wrap items-center gap-x-2 gap-y-1">
                <p className="text-[13.5px] font-medium text-ink">{it.title}</p>
                {it.tag}
              </div>
              {it.detail && <div className="mt-0.5 text-[12.5px] leading-5 text-ink-2">{it.detail}</div>}
              <p className="mt-0.5 text-[11.5px] text-muted tabular">{dateTime(it.at)}</p>
            </div>
          </li>
        )
      })}
    </ol>
  )
}
