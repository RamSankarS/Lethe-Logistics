import type { ReactNode } from 'react'
import { AlertTriangle, CalendarClock, Snowflake } from 'lucide-react'
import { Badge } from '@/components/ui/Badge'
import { date, daysUntil, num } from '@/lib/format'
import { ORG_TYPE_LABEL } from '@/lib/domain'
import type { Medicine, Organisation, PackagingStandard } from '@/lib/types'

export function MedicineCell({ med, sub }: { med?: Medicine | null; sub?: string }) {
  if (!med) return <span className="trace-dash">—</span>
  return (
    <div className="trace-cell">
      <p className="trace-cell-main">{med.brand_name}</p>
      <p className="trace-cell-sub">{sub ?? med.generic_name}</p>
    </div>
  )
}

export function OrgCell({ org }: { org?: Organisation | null }) {
  if (!org) return <span className="trace-dash">—</span>
  return (
    <div className="trace-cell">
      <p className="trace-cell-main">{org.org_name}</p>
      <p className="trace-cell-sub">{ORG_TYPE_LABEL[org.org_type]}</p>
    </div>
  )
}

/** Expiry with urgency: expired / < 90 days / < 180 days / fine. */
export function ExpiryBadge({ value, compact }: { value: string; compact?: boolean }) {
  const d = daysUntil(value)
  if (Number.isNaN(d)) return <span className="trace-dash">—</span>
  if (d < 0)
    return (
      <Badge tone="critical" icon={AlertTriangle} title={`Expired ${date(value)}`}>
        {compact ? 'Expired' : `Expired ${date(value)}`}
      </Badge>
    )
  if (d <= 90) return <Badge tone="serious" icon={CalendarClock} title={date(value)}>{`${d} days left`}</Badge>
  if (d <= 180) return <Badge tone="warn" icon={CalendarClock} title={date(value)}>{`${Math.round(d / 30)} months left`}</Badge>
  return <span className="trace-date-text">{date(value)}</span>
}

export function StorageBand({ pkg }: { pkg?: PackagingStandard | null }) {
  if (!pkg) return <span className="trace-dash">—</span>
  const cold = Number(pkg.max_temp_celsius) <= 8
  return (
    <span className="trace-storage">
      {cold && <Snowflake className="trace-cold-icon" />}
      {num(Number(pkg.min_temp_celsius))}–{num(Number(pkg.max_temp_celsius))}°C · ≤{num(Number(pkg.humidity_limit))}% RH
    </span>
  )
}

/** Label/value pair used in detail panels. */
export function KV({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="trace-kv">
      <p className="trace-kv-label">{label}</p>
      <div className="trace-kv-value">{children}</div>
    </div>
  )
}
