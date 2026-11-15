import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { num } from '@/lib/format'
import { TONE } from './tone'

/** Utilisation meter. Fill tone follows severity: accent -> warn -> critical. */
export function Meter({ value, max, className, thresholds = [0.8, 0.95], tone }: { value: number; max: number; className?: string; thresholds?: [number, number]; tone?: Tone }) {
  const ratio = max > 0 ? Math.min(1, Math.max(0, value / max)) : 0
  const t: Tone = tone ?? (ratio >= thresholds[1] ? 'critical' : ratio >= thresholds[0] ? 'warn' : 'accent')
  return (
    <div className={cn('h-2 w-full overflow-hidden rounded-full bg-surface-3', className)} role="meter" aria-valuenow={value} aria-valuemin={0} aria-valuemax={max}>
      <div className={cn('h-full rounded-full transition-[width] duration-500', TONE[t].bar)} style={{ width: `${Math.max(ratio > 0 ? 2 : 0, ratio * 100)}%` }} />
    </div>
  )
}

export interface SegmentPart {
  key: string
  label: string
  value: number
  color: string
  /** Use near-black text inside the part (for light fills such as yellow). */
  darkText?: boolean
}

/**
 * Tall segmented bar: one whole split into parts (28px, 4px corners, 2px gaps).
 * Values print inside a part only when it is wide enough; the legend names every part.
 */
export function SegmentedBar({ parts, format = num, className }: { parts: SegmentPart[]; format?: (n: number) => string; className?: string }) {
  const total = parts.reduce((s, p) => s + p.value, 0)
  const shown = parts.filter((p) => p.value > 0)
  return (
    <div className={className}>
      <div className="flex h-7 w-full gap-[2px]" role="img" aria-label={parts.map((p) => `${p.label}: ${format(p.value)}`).join(', ')}>
        {total === 0 ? (
          <div className="h-full w-full rounded bg-surface-3" />
        ) : (
          shown.map((p) => {
            const share = p.value / total
            return (
              <div
                key={p.key}
                title={`${p.label}: ${format(p.value)} (${Math.round(share * 100)}%)`}
                className={cn('flex h-full min-w-[3px] items-center overflow-hidden rounded px-2 text-[11.5px] font-semibold', p.darkText ? 'text-[#0b0b0b]' : 'text-white')}
                style={{ width: `${share * 100}%`, background: p.color }}
              >
                {share > 0.09 && <span className="truncate">{Math.round(share * 100)}%</span>}
              </div>
            )
          })
        )}
      </div>
      <div className="mt-3 flex flex-wrap gap-x-4 gap-y-1.5">
        {parts.map((p) => (
          <span key={p.key} className="inline-flex items-center gap-1.5 text-[12.5px] text-ink-2">
            <span className="size-2.5 rounded-sm" style={{ background: p.color }} />
            {p.label}
            <span className="tabular font-medium text-ink">{format(p.value)}</span>
          </span>
        ))}
      </div>
    </div>
  )
}
