// Chart primitives built on Recharts, styled to one system:
// validated categorical order (--series-N), bars <= 24px with 4px rounded data-ends,
// hairline solid gridlines, 2px lines, ~10% area washes, value-first tooltips,
// and a legend whenever two or more series are plotted.
import type { ReactElement, ReactNode } from 'react'
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  LabelList,
  Line,
  LineChart,
  ReferenceArea,
  ReferenceLine,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { compact, num } from '@/lib/format'
import { cn } from '@/lib/cn'
import { useTheme } from '@/lib/theme'

export const SERIES = ['var(--series-1)', 'var(--series-2)', 'var(--series-3)', 'var(--series-4)', 'var(--series-5)', 'var(--series-6)', 'var(--series-7)', 'var(--series-8)']

export interface SeriesDef {
  key: string
  label: string
  color: string
}

const axisTick = { fill: 'var(--muted)', fontSize: 11.5 }
type Row = Record<string, unknown>

interface TipPayload {
  name?: string | number
  value?: number | string
  color?: string
  dataKey?: string | number
  payload?: Record<string, unknown>
}

/** Tooltip: values lead, labels follow, short line keys. */
function ChartTip({
  active,
  payload,
  label,
  format = num,
  labelFormat,
}: {
  active?: boolean
  payload?: TipPayload[]
  label?: string | number
  format?: (n: number) => string
  labelFormat?: (l: string | number) => string
}) {
  if (!active || !payload?.length) return null
  return (
    <div className="min-w-[150px] rounded-xl border border-line bg-surface px-3 py-2 shadow-lg">
      {label != null && <p className="mb-1.5 text-[11.5px] font-medium text-ink-2">{labelFormat ? labelFormat(label) : label}</p>}
      <div className="flex flex-col gap-1">
        {payload.map((p, i) => (
          <div key={`${p.dataKey}-${i}`} className="flex items-center gap-2 text-[12.5px]">
            <span className="h-0.5 w-3 rounded-full" style={{ background: p.color }} />
            <span className="tabular font-semibold text-ink">{typeof p.value === 'number' ? format(p.value) : p.value}</span>
            <span className="truncate text-ink-2">{p.name}</span>
          </div>
        ))}
      </div>
    </div>
  )
}

export function Legend({ series, className }: { series: SeriesDef[]; className?: string }) {
  if (series.length < 2) return null
  return (
    <div className={cn('flex flex-wrap gap-x-4 gap-y-1', className)}>
      {series.map((s) => (
        <span key={s.key} className="inline-flex items-center gap-1.5 text-[12px] text-ink-2">
          <span className="size-2.5 rounded-sm" style={{ background: s.color }} />
          {s.label}
        </span>
      ))}
    </div>
  )
}

function Frame({ height, children, legend }: { height: number; children: ReactNode; legend?: ReactNode }) {
  return (
    <div className="w-full">
      {legend}
      <div style={{ height }} className="w-full">
        <ResponsiveContainer width="100%" height="100%">
          {children as ReactElement}
        </ResponsiveContainer>
      </div>
    </div>
  )
}

/** Vertical columns over categories; one or more series side by side, or stacked. */
export function ColumnChart<T extends object>({
  data,
  x,
  series,
  height = 240,
  format = num,
  stacked,
  xFormat,
}: {
  data: T[]
  x: keyof T & string
  series: SeriesDef[]
  height?: number
  format?: (n: number) => string
  stacked?: boolean
  xFormat?: (v: string) => string
}) {
  return (
    <Frame height={height} legend={<Legend series={series} className="mb-3" />}>
      <BarChart data={data as Row[]} margin={{ top: 8, right: 4, left: -8, bottom: 0 }} barGap={2} barCategoryGap="28%">
        <CartesianGrid vertical={false} stroke="var(--grid)" />
        <XAxis dataKey={x as string} tick={axisTick} tickLine={false} axisLine={{ stroke: 'var(--axis)' }} interval={0} tickFormatter={xFormat} minTickGap={4} />
        <YAxis tick={axisTick} tickLine={false} axisLine={false} tickFormatter={(v: number) => compact(v)} width={48} allowDecimals={false} />
        <Tooltip cursor={{ fill: 'var(--surface-3)', opacity: 0.6 }} content={<ChartTip format={format} />} />
        {series.map((s, i) => (
          <Bar
            key={s.key}
            dataKey={s.key}
            name={s.label}
            fill={s.color}
            maxBarSize={24}
            stackId={stacked ? 'stack' : undefined}
            stroke={stacked ? 'var(--surface)' : undefined}
            strokeWidth={stacked ? 2 : 0}
            radius={stacked ? (i === series.length - 1 ? [4, 4, 0, 0] : [0, 0, 0, 0]) : [4, 4, 0, 0]}
          />
        ))}
      </BarChart>
    </Frame>
  )
}

/** Horizontal bars for ranked categories, value at the tip. */
export function BarList<T extends object>({
  data,
  y,
  value,
  label,
  color = SERIES[0],
  colorOf,
  height,
  format = num,
}: {
  data: T[]
  y: keyof T & string
  value: keyof T & string
  label: string
  color?: string
  colorOf?: (row: T) => string
  height?: number
  format?: (n: number) => string
}) {
  const h = height ?? Math.max(120, data.length * 34 + 16)
  return (
    <Frame height={h}>
      <BarChart data={data as Row[]} layout="vertical" margin={{ top: 0, right: 56, left: 0, bottom: 0 }} barCategoryGap="30%">
        <CartesianGrid horizontal={false} stroke="var(--grid)" />
        <XAxis type="number" hide />
        <YAxis type="category" dataKey={y as string} tick={{ ...axisTick, fill: 'var(--ink-2)' }} tickLine={false} axisLine={false} width={120} />
        <Tooltip cursor={{ fill: 'var(--surface-3)', opacity: 0.6 }} content={<ChartTip format={format} />} />
        <Bar dataKey={value as string} name={label} fill={color} maxBarSize={20} radius={[0, 4, 4, 0]}>
          {colorOf && data.map((row, i) => <Cell key={i} fill={colorOf(row)} />)}
          <LabelList dataKey={value as string} position="right" formatter={(v: unknown) => format(Number(v))} style={{ fill: 'var(--ink-2)', fontSize: 11.5, fontWeight: 600 }} />
        </Bar>
      </BarChart>
    </Frame>
  )
}

/** Change over time: area washes (or lines) with a crosshair tooltip. */
export function TrendChart<T extends object>({
  data,
  x,
  series,
  height = 240,
  format = num,
  xFormat,
  lines,
}: {
  data: T[]
  x: keyof T & string
  series: SeriesDef[]
  height?: number
  format?: (n: number) => string
  xFormat?: (v: string) => string
  lines?: boolean
}) {
  const common = (
    <>
      <CartesianGrid vertical={false} stroke="var(--grid)" />
      <XAxis dataKey={x as string} tick={axisTick} tickLine={false} axisLine={{ stroke: 'var(--axis)' }} tickFormatter={xFormat} minTickGap={24} />
      <YAxis tick={axisTick} tickLine={false} axisLine={false} tickFormatter={(v: number) => compact(v)} width={48} allowDecimals={false} />
      <Tooltip cursor={{ stroke: 'var(--line-strong)', strokeWidth: 1 }} content={<ChartTip format={format} labelFormat={xFormat ? (l) => xFormat(String(l)) : undefined} />} />
    </>
  )
  return (
    <Frame height={height} legend={<Legend series={series} className="mb-3" />}>
      {lines ? (
        <LineChart data={data as Row[]} margin={{ top: 8, right: 8, left: -8, bottom: 0 }}>
          {common}
          {series.map((s) => (
            <Line key={s.key} type="monotone" dataKey={s.key} name={s.label} stroke={s.color} strokeWidth={2} dot={false} activeDot={{ r: 4, strokeWidth: 2, stroke: 'var(--surface)' }} />
          ))}
        </LineChart>
      ) : (
        <AreaChart data={data as Row[]} margin={{ top: 8, right: 8, left: -8, bottom: 0 }}>
          {common}
          {series.map((s) => (
            <Area
              key={s.key}
              type="monotone"
              dataKey={s.key}
              name={s.label}
              stroke={s.color}
              strokeWidth={2}
              fill={s.color}
              fillOpacity={0.1}
              dot={false}
              activeDot={{ r: 4, strokeWidth: 2, stroke: 'var(--surface)' }}
            />
          ))}
        </AreaChart>
      )}
    </Frame>
  )
}

/** Sensor trace with the target band shaded and the limits marked. */
export function BandChart({
  data,
  min,
  max,
  height = 180,
}: {
  data: { t: string; value: number }[]
  min: number
  max: number
  height?: number
}) {
  const values = data.map((d) => d.value)
  const lo = Math.min(min, ...values) - 2
  const hi = Math.max(max, ...values) + 2
  return (
    <Frame height={height}>
      <LineChart data={data} margin={{ top: 8, right: 12, left: -16, bottom: 0 }}>
        <CartesianGrid vertical={false} stroke="var(--grid)" />
        <ReferenceArea y1={min} y2={max} fill="var(--good)" fillOpacity={0.08} />
        <ReferenceLine y={max} stroke="var(--critical)" strokeOpacity={0.5} />
        <ReferenceLine y={min} stroke="var(--info)" strokeOpacity={0.5} />
        <XAxis dataKey="t" tick={axisTick} tickLine={false} axisLine={{ stroke: 'var(--axis)' }} minTickGap={24} />
        <YAxis domain={[Math.floor(lo), Math.ceil(hi)]} tick={axisTick} tickLine={false} axisLine={false} width={44} tickFormatter={(v: number) => `${v}°`} />
        <Tooltip cursor={{ stroke: 'var(--line-strong)' }} content={<ChartTip format={(n) => `${n}°C`} />} />
        <Line type="monotone" dataKey="value" name="Temperature" stroke="var(--series-1)" strokeWidth={2} dot={{ r: 4, strokeWidth: 2, stroke: 'var(--surface)', fill: 'var(--series-1)' }} />
      </LineChart>
    </Frame>
  )
}

/** Tiny trend line for tables and tiles. */
export function Sparkline({ values, color = 'var(--series-1)', height = 28, width = 96 }: { values: number[]; color?: string; height?: number; width?: number }) {
  if (values.length < 2) return <span className="text-xs text-muted">—</span>
  const min = Math.min(...values)
  const max = Math.max(...values)
  const span = max - min || 1
  const pts = values.map((v, i) => `${(i / (values.length - 1)) * (width - 4) + 2},${height - 2 - ((v - min) / span) * (height - 4)}`).join(' ')
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} aria-hidden>
      <polyline points={pts} fill="none" stroke={color} strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  )
}

/** Sequential blue ramp. Light mode runs light -> dark; dark mode is its own selection, dark -> light. */
const RAMP_LIGHT = ['#cde2fb', '#9ec5f4', '#6da7ec', '#3987e5', '#256abf', '#1c5cab', '#104281', '#0d366b']
const RAMP_DARK = ['#0d366b', '#104281', '#184f95', '#1c5cab', '#256abf', '#3987e5', '#6da7ec', '#9ec5f4']

export function heatColor(value: number, max: number, dark = false): { bg: string; fg: string } {
  if (value <= 0 || max <= 0) return { bg: 'var(--surface-3)', fg: 'var(--muted)' }
  const ramp = dark ? RAMP_DARK : RAMP_LIGHT
  const i = Math.min(ramp.length - 1, Math.floor((value / max) * (ramp.length - 1) + 0.0001))
  const darkText = dark ? i >= 6 : i < 3
  return { bg: ramp[i], fg: darkText ? '#0b0b0b' : '#ffffff' }
}

/** Matrix heatmap: rows x columns with value-coded cells and hover titles. */
export function Heatmap({
  rows,
  cols,
  value,
  rowLabel = (r) => r,
  colLabel = (c) => c,
  format = num,
  cellTitle,
}: {
  rows: string[]
  cols: string[]
  value: (row: string, col: string) => number
  rowLabel?: (r: string) => string
  colLabel?: (c: string) => string
  format?: (n: number) => string
  cellTitle?: (row: string, col: string, v: number) => string
}) {
  const { theme } = useTheme()
  const dark = theme === 'dark'
  const ramp = dark ? RAMP_DARK : RAMP_LIGHT
  const max = Math.max(0, ...rows.flatMap((r) => cols.map((c) => value(r, c))))
  return (
    <div className="overflow-x-auto">
      <table className="w-full border-separate border-spacing-[3px] text-[12px]">
        <thead>
          <tr>
            <th />
            {cols.map((c) => (
              <th key={c} className="px-1 pb-1 text-center font-medium whitespace-nowrap text-muted">
                {colLabel(c)}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r}>
              <th scope="row" className="pr-2 text-left font-medium whitespace-nowrap text-ink-2">
                {rowLabel(r)}
              </th>
              {cols.map((c) => {
                const v = value(r, c)
                const { bg, fg } = heatColor(v, max, dark)
                return (
                  <td
                    key={c}
                    title={cellTitle ? cellTitle(r, c, v) : `${rowLabel(r)} · ${colLabel(c)}: ${format(v)}`}
                    className="h-9 min-w-[44px] rounded-md text-center font-semibold tabular"
                    style={{ background: bg, color: fg }}
                  >
                    {v > 0 ? format(v) : ''}
                  </td>
                )
              })}
            </tr>
          ))}
        </tbody>
      </table>
      <div className="mt-3 flex items-center gap-2 text-[11.5px] text-muted">
        <span>Fewer</span>
        <div className="flex gap-[2px]">
          {ramp.map((c) => (
            <span key={c} className="h-2.5 w-5 rounded-sm" style={{ background: c }} />
          ))}
        </div>
        <span>More</span>
      </div>
    </div>
  )
}
