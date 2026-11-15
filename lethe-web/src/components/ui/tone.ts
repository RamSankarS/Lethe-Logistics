import type { Tone } from '@/lib/domain'

/** Tailwind classes per semantic tone. Full class strings so Tailwind can see them. */
export const TONE: Record<Tone, { soft: string; text: string; dot: string; ring: string; solid: string; bar: string }> = {
  neutral: { soft: 'bg-surface-3', text: 'text-ink-2', dot: 'bg-muted', ring: 'ring-line-strong', solid: 'bg-ink-2 text-surface', bar: 'bg-muted' },
  info: { soft: 'bg-info-soft', text: 'text-info-text', dot: 'bg-info', ring: 'ring-info/30', solid: 'bg-info text-white', bar: 'bg-info' },
  good: { soft: 'bg-good-soft', text: 'text-good-text', dot: 'bg-good', ring: 'ring-good/30', solid: 'bg-good text-white', bar: 'bg-good' },
  warn: { soft: 'bg-warn-soft', text: 'text-warn-text', dot: 'bg-warn', ring: 'ring-warn/40', solid: 'bg-warn text-[#0b0b0b]', bar: 'bg-warn' },
  serious: { soft: 'bg-serious-soft', text: 'text-serious-text', dot: 'bg-serious', ring: 'ring-serious/30', solid: 'bg-serious text-white', bar: 'bg-serious' },
  critical: { soft: 'bg-critical-soft', text: 'text-critical-text', dot: 'bg-critical', ring: 'ring-critical/30', solid: 'bg-critical text-white', bar: 'bg-critical' },
  accent: { soft: 'bg-accent-soft', text: 'text-accent-text', dot: 'bg-accent', ring: 'ring-accent/30', solid: 'bg-accent text-accent-ink', bar: 'bg-accent' },
}
