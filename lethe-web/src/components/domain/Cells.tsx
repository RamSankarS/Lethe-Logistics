import type { ReactNode } from 'react'
import { AlertTriangle, CalendarClock, Snowflake } from 'lucide-react'
import { Badge } from '@/components/ui/Badge'
import { date, daysUntil, num } from '@/lib/format'
import { ORG_TYPE_LABEL } from '@/lib/domain'
import type { Medicine, Organisation, PackagingStandard } from '@/lib/types'

export function MedicineCell({ med, sub }: { med?: Medicine | null; sub?: string }) {
  if (!med) return <span className="text-muted">—</span>
  return (
    <div className="min-w-0">
      <p className="truncate font-medium text-ink">{med.brand_name}</p>
      <p className="truncate text-xs text-ink-2">{sub ?? med.generic_name}</p>
    </div>
  )
}

export function OrgCell({ org }: { org?: Organisation | null }) {
  if (!org) return <span className="text-muted">—</span>
  return (
    <div className="min-w-0">
      <p className="truncate font-medium text-ink">{org.org_name}</p>
      <p className="truncate text-xs text-ink-2">{ORG_TYPE_LABEL[org.org_type]}</p>
    </div>
  )
}

/** Expiry with urgency: expired / < 90 days / < 180 days / fine. */
export function ExpiryBadge({ value, compact }: { value: string; compact?: boolean }) {
  const d = daysUntil(value)
  if (Number.isNaN(d)) return <span className="text-muted">—</span>
  if (d < 0)
    return (
      <Badge tone="critical" icon={AlertTriangle} title={`Expired ${date(value)}`}>
        {compact ? 'Expired' : `Expired ${date(value)}`}
      </Badge>
    )
  if (d <= 90) return <Badge tone="serious" icon={CalendarClock} title={date(value)}>{`${d} days left`}</Badge>
  if (d <= 180) return <Badge tone="warn" icon={CalendarClock} title={date(value)}>{`${Math.round(d / 30)} months left`}</Badge>
  return <span className="text-[13px] text-ink-2 tabular">{date(value)}</span>
}

export function StorageBand({ pkg }: { pkg?: PackagingStandard | null }) {
  if (!pkg) return <span className="text-muted">—</span>
  const cold = Number(pkg.max_temp_celsius) <= 8
  return (
    <span className="inline-flex items-center gap-1.5 text-[13px] text-ink-2 tabular">
      {cold && <Snowflake className="size-3.5 text-info-text" />}
      {num(Number(pkg.min_temp_celsius))}–{num(Number(pkg.max_temp_celsius))}°C · ≤{num(Number(pkg.humidity_limit))}% RH
    </span>
  )
}

/** Label/value pair used in detail panels. */
export function KV({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="min-w-0">
      <p className="text-[11.5px] font-medium tracking-wide text-muted uppercase">{label}</p>
      <div className="mt-0.5 text-[13.5px] text-ink">{children}</div>
    </div>
  )
}
