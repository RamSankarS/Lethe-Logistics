// Formatting helpers. Lethe operates in India, so numbers use en-IN grouping
// (1,00,000) and money is shown in rupees.

const intFmt = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 })
const decFmt = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 2 })
const moneyFmt = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 })
const moneyFmt2 = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', minimumFractionDigits: 2, maximumFractionDigits: 2 })
const dateFmt = new Intl.DateTimeFormat('en-IN', { day: '2-digit', month: 'short', year: 'numeric' })
const shortDateFmt = new Intl.DateTimeFormat('en-IN', { day: '2-digit', month: 'short' })
const dateTimeFmt = new Intl.DateTimeFormat('en-IN', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false })
const timeFmt = new Intl.DateTimeFormat('en-IN', { hour: '2-digit', minute: '2-digit', hour12: false })

export const num = (n: number | null | undefined) => (n == null || Number.isNaN(n) ? '—' : intFmt.format(n))
export const dec = (n: number | null | undefined) => (n == null || Number.isNaN(n) ? '—' : decFmt.format(n))

/** Compact number in Indian units: 950 / 12.5K / 4.2L / 1.3Cr */
export function compact(n: number | null | undefined): string {
  if (n == null || Number.isNaN(n)) return '—'
  const a = Math.abs(n)
  const sign = n < 0 ? '-' : ''
  if (a >= 1e7) return `${sign}${trim(a / 1e7)}Cr`
  if (a >= 1e5) return `${sign}${trim(a / 1e5)}L`
  if (a >= 1e4) return `${sign}${trim(a / 1e3)}K`
  return intFmt.format(n)
}
const trim = (v: number) => (v >= 100 ? v.toFixed(0) : v.toFixed(1).replace(/\.0$/, ''))

export const money = (n: number | null | undefined) => (n == null || Number.isNaN(n) ? '—' : moneyFmt.format(n))
export const money2 = (n: number | null | undefined) => (n == null || Number.isNaN(n) ? '—' : moneyFmt2.format(n))
export const moneyCompact = (n: number | null | undefined) => (n == null || Number.isNaN(n) ? '—' : `${n < 0 ? '−' : ''}₹${compact(Math.abs(n))}`)

export const pct = (n: number | null | undefined, digits = 0) =>
  n == null || !Number.isFinite(n) ? '—' : `${(n * 100).toFixed(digits)}%`

function toDate(v: string | Date | null | undefined): Date | null {
  if (!v) return null
  const d = v instanceof Date ? v : new Date(v.length === 10 ? `${v}T00:00:00` : v)
  return Number.isNaN(d.getTime()) ? null : d
}

export const date = (v: string | Date | null | undefined) => {
  const d = toDate(v)
  return d ? dateFmt.format(d) : '—'
}
export const shortDate = (v: string | Date | null | undefined) => {
  const d = toDate(v)
  return d ? shortDateFmt.format(d) : '—'
}
export const dateTime = (v: string | Date | null | undefined) => {
  const d = toDate(v)
  return d ? dateTimeFmt.format(d) : '—'
}
export const time = (v: string | Date | null | undefined) => {
  const d = toDate(v)
  return d ? timeFmt.format(d) : '—'
}

/** "3 min ago", "5 days ago", "in 2 months" */
export function relative(v: string | Date | null | undefined, now = new Date()): string {
  const d = toDate(v)
  if (!d) return '—'
  const diff = (d.getTime() - now.getTime()) / 1000
  const abs = Math.abs(diff)
  const rtf = new Intl.RelativeTimeFormat('en', { numeric: 'auto' })
  if (abs < 60) return rtf.format(Math.round(diff), 'second')
  if (abs < 3600) return rtf.format(Math.round(diff / 60), 'minute')
  if (abs < 86400) return rtf.format(Math.round(diff / 3600), 'hour')
  if (abs < 86400 * 30) return rtf.format(Math.round(diff / 86400), 'day')
  if (abs < 86400 * 365) return rtf.format(Math.round(diff / (86400 * 30)), 'month')
  return rtf.format(Math.round(diff / (86400 * 365)), 'year')
}

/** Whole days from today until the given date (negative = in the past). */
export function daysUntil(v: string | null | undefined, now = new Date()): number {
  const d = toDate(v)
  if (!d) return Number.NaN
  const start = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  return Math.round((d.getTime() - start.getTime()) / 86400000)
}

export const temp = (c: number | null | undefined) => (c == null ? '—' : `${decFmt.format(c)}°C`)
export const humidity = (h: number | null | undefined) => (h == null ? '—' : `${decFmt.format(h)}%`)

/** Today's date as yyyy-mm-dd in local time (for date inputs). */
export function todayISO(offsetDays = 0): string {
  const d = new Date()
  d.setDate(d.getDate() + offsetDays)
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${d.getFullYear()}-${m}-${day}`
}

export const fullName = (u: { first_name?: string; last_name?: string } | null | undefined) =>
  u ? `${u.first_name ?? ''} ${u.last_name ?? ''}`.trim() || 'Unknown user' : 'Unknown user'

export const initials = (name: string) =>
  name
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((s) => s[0]?.toUpperCase())
    .join('')

/** Turn SNAKE_CASE / Snake_Case identifiers into readable words. */
export const humanize = (s: string | null | undefined) =>
  (s ?? '')
    .replace(/[_-]+/g, ' ')
    .toLowerCase()
    .replace(/\b\w/g, (c) => c.toUpperCase())
    .trim()

export const shortId = (id: string | null | undefined, n = 8) => (id ? id.slice(0, n) : '—')

/** "1 batch", "3 batches" */
export const plural = (n: number, one: string, many = `${one}s`) => `${num(n)} ${n === 1 ? one : many}`
