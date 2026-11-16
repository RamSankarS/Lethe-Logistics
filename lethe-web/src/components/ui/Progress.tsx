import { cn } from '@/lib/cn'
import type { Tone } from '@/lib/domain'
import { num } from '@/lib/format'

const FILL: Record<Tone, string> = {
  accent: 'fill-blue',
  good: 'fill-green',
  warn: 'fill-yellow',
  serious: 'fill-orange',
  critical: 'fill-red',
  info: 'fill-teal',
  neutral: 'fill-grey',
}

/** Usage bar. Turns yellow then red when it gets full. */
export function Meter({ value, max, className, thresholds = [0.8, 0.95], tone }: { value: number; max: number; className?: string; thresholds?: [number, number]; tone?: Tone }) {
  const ratio = max > 0 ? Math.min(1, Math.max(0, value / max)) : 0
  const t: Tone = tone ?? (ratio >= thresholds[1] ? 'critical' : ratio >= thresholds[0] ? 'warn' : 'accent')
  return (
    <div className={cn('meter-bar', className)} role="meter" aria-valuenow={value} aria-valuemin={0} aria-valuemax={max}>
      <div className={cn('meter-fill', FILL[t])} style={{ width: `${Math.max(ratio > 0 ? 2 : 0, ratio * 100)}%` }} />
    </div>
  )
}

export interface SegmentPart {
  key: string
  label: string
  value: number
  color: string
  /** Use black text inside the part (for light colours like yellow). */
  darkText?: boolean
}

/** One bar split into coloured parts, with a legend underneath. */
export function SegmentedBar({ parts, format = num, className }: { parts: SegmentPart[]; format?: (n: number) => string; className?: string }) {
  const total = parts.reduce((s, p) => s + p.value, 0)
  const shown = parts.filter((p) => p.value > 0)
  return (
    <div className={className}>
      <div className="split-bar" role="img" aria-label={parts.map((p) => `${p.label}: ${format(p.value)}`).join(', ')}>
        {total > 0 &&
          shown.map((p) => {
            const share = p.value / total
            return (
              <div
                key={p.key}
                title={`${p.label}: ${format(p.value)} (${Math.round(share * 100)}%)`}
                className="split-part"
                style={{ width: `${share * 100}%`, background: p.color, color: p.darkText ? '#000000' : '#FFFFFF' }}
              >
                {share > 0.09 && `${Math.round(share * 100)}%`}
              </div>
            )
          })}
      </div>
      <div className="split-legend">
        {parts.map((p) => (
          <span key={p.key}>
            <span className="color-square" style={{ background: p.color }} />
            {p.label}: <b>{format(p.value)}</b>
          </span>
        ))}
      </div>
    </div>
  )
}
