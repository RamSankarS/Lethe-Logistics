import { useMemo } from 'react'
import { Activity, Percent, ShieldAlert, Snowflake, Thermometer } from 'lucide-react'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { BarList, SERIES } from '@/components/charts/Charts'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { EmptyState } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { QUARANTINE_STATUS, isBreach } from '@/lib/domain'
import { date, dateTime, dec, humanize, num, pct, temp } from '@/lib/format'
import type { ColdChainViolationRow, QuarantineLog, SensorLog, StorageLocation } from '@/lib/types'

interface BreachRow {
  s: SensorLog
  loc: StorageLocation
  deviation: number
  direction: 'warm' | 'cold'
  quarantines: QuarantineLog[]
}

export function ColdChainViolations() {
  const L = useLookups()
  const t = useTables(['sensorLogs', 'locations', 'quarantine', 'inventory', 'vwColdChain'] as const)

  const m = useMemo(() => {
    const locById = new Map(t.data.locations.map((l) => [l.location_id, l]))
    const breaches: BreachRow[] = []
    for (const s of t.data.sensorLogs) {
      const loc = locById.get(s.location_id)
      if (!loc || !isBreach(s, loc)) continue
      const warm = s.temperature_celsius > Number(loc.target_max_temp)
      breaches.push({
        s,
        loc,
        direction: warm ? 'warm' : 'cold',
        deviation: warm ? s.temperature_celsius - Number(loc.target_max_temp) : Number(loc.target_min_temp) - s.temperature_celsius,
        quarantines: t.data.quarantine.filter((q) => q.breaching_log_id === s.log_id),
      })
    }
    const byWarehouse = new Map<string, number>()
    for (const b of breaches) {
      const name = L.wh.get(b.loc.warehouse_id)?.warehouse_name ?? 'Unknown'
      byWarehouse.set(name, (byWarehouse.get(name) ?? 0) + 1)
    }
    const qty = (q: QuarantineLog) => t.data.inventory.find((i) => i.batch_id === q.batch_id && i.location_id === q.location_id)?.available_quantity ?? 0
    return {
      breaches,
      warehouseRows: [...byWarehouse.entries()].map(([name, count]) => ({ name, count })).sort((a, b) => b.count - a.count),
      atRisk: t.data.quarantine.filter((q) => q.status === 'Active').map((q) => ({ q, qty: qty(q) })),
    }
  }, [t.data, L])

  const cols: Column<BreachRow>[] = [
    { key: 'when', header: 'Recorded', sort: (b) => b.s.recorded_at, cell: (b) => <span className="text-[13px] text-ink-2 tabular">{dateTime(b.s.recorded_at)}</span> },
    { key: 'loc', header: 'Location', sort: (b) => L.locLabel(b.loc.location_id), cell: (b) => <span className="text-[13px]">{L.locLabel(b.loc.location_id)}</span> },
    { key: 'reading', header: 'Reading', align: 'right', sort: (b) => b.s.temperature_celsius, cell: (b) => <span className="font-semibold text-critical-text">{temp(b.s.temperature_celsius)}</span> },
    { key: 'band', header: 'Target', cell: (b) => <span className="text-[13px] text-ink-2 tabular">{b.loc.target_min_temp}–{b.loc.target_max_temp}°C</span>, hideBelow: 'md' },
    { key: 'dev', header: 'Deviation', align: 'right', sort: (b) => b.deviation, cell: (b) => <Badge tone={b.deviation >= 5 ? 'critical' : 'serious'}>{b.direction === 'warm' ? '+' : '−'}{dec(b.deviation)}°C {b.direction === 'warm' ? 'warm' : 'cold'}</Badge> },
    { key: 'q', header: 'Quarantined', align: 'right', sort: (b) => b.quarantines.length, cell: (b) => (b.quarantines.length ? <span className="font-medium">{b.quarantines.length} batch{b.quarantines.length > 1 ? 'es' : ''}</span> : <span className="text-xs text-muted">none on shelf</span>) },
    { key: 'status', header: 'Resolution', cell: (b) => (b.quarantines.length ? <div className="flex flex-wrap gap-1">{b.quarantines.map((q) => <StatusBadge key={q.quarantine_id} value={q.status} meta={QUARANTINE_STATUS} />)}</div> : '—') },
  ]

  const viewCols: Column<ColdChainViolationRow>[] = [
    { key: 'd', header: 'Date', sort: (r) => r.violation_date, cell: (r) => <span className="tabular">{date(r.violation_date)}</span> },
    { key: 'a', header: 'Event', cell: (r) => humanize(r.action_type) },
    { key: 'r', header: 'Resulting action', cell: (r) => (r.resulting_action ? humanize(r.resulting_action) : <span className="text-muted">—</span>) },
    { key: 'n', header: 'Incidents', align: 'right', sort: (r) => r.incident_count, cell: (r) => num(r.incident_count) },
  ]

  const total = t.data.sensorLogs.length
  return (
    <>
      <PageHeader />
      <StatGrid cols={4}>
        <Stat label="Sensor readings" value={num(total)} sub="environmental_sensor_logs" icon={Activity} />
        <Stat label="Breaches" value={num(m.breaches.length)} sub={`${m.breaches.filter((b) => b.loc.zone_type === 'Cold Storage').length} in cold storage`} icon={Thermometer} tone="critical" />
        <Stat label="Breach rate" value={pct(total ? m.breaches.length / total : 0)} sub="share of readings out of band" icon={Percent} tone="serious" />
        <Stat label="Stock at risk" value={num(m.atRisk.reduce((s, x) => s + x.qty, 0))} sub={`${m.atRisk.length} active quarantines`} icon={ShieldAlert} tone="warn" />
      </StatGrid>

      <Card className="mt-5">
        <CardHeader title="Temperature breaches" subtitle="Readings outside the location's target band, and the quarantines the database raised in response" icon={Snowflake} />
        <DataTable bare rows={m.breaches} columns={cols} rowKey={(b) => b.s.log_id} loading={t.isLoading} initialSort={{ key: 'when', dir: 'desc' }} emptyTitle="No breaches recorded" exportName="lethe-cold-chain-breaches" exportRow={(b) => ({ recorded_at: b.s.recorded_at, location: L.locLabel(b.loc.location_id), reading_c: b.s.temperature_celsius, target: `${b.loc.target_min_temp}-${b.loc.target_max_temp}`, deviation_c: b.deviation.toFixed(1), quarantined_batches: b.quarantines.length })} />
      </Card>

      <div className="mt-5 grid gap-5 xl:grid-cols-2">
        <Card>
          <CardHeader title="Breaches by facility" />
          <CardBody>{m.warehouseRows.length ? <BarList data={m.warehouseRows} y="name" value="count" label="Breaches" color={SERIES[7]} /> : <EmptyState title="No breaches" />}</CardBody>
        </Card>
        <Card>
          <CardHeader title="Products held in quarantine" subtitle="Active quarantine rows with the stock still on that shelf" />
          <CardBody className="space-y-2">
            {m.atRisk.length === 0 && <p className="text-[13px] text-ink-2">No active quarantines.</p>}
            {m.atRisk.map(({ q, qty }) => (
              <div key={q.quarantine_id} className="flex flex-wrap items-center justify-between gap-2 rounded-xl border border-line px-3 py-2.5">
                <span className="text-[13px]">
                  <Code>{L.batchNo(q.batch_id)}</Code> <span className="text-ink-2">{L.medName(q.batch_id)} · {L.locLabel(q.location_id)}</span>
                </span>
                <Badge tone="critical">{num(qty)} units held</Badge>
              </div>
            ))}
          </CardBody>
        </Card>
      </div>

      <Card className="mt-5">
        <CardHeader title="Cold-chain violation ledger view" subtitle="financial_analytics.vw_cold_chain_violations (destruction and breach events per day)" />
        <DataTable bare rows={t.data.vwColdChain} columns={viewCols} rowKey={(r) => `${r.violation_date}-${r.action_type}-${r.resulting_action}`} loading={t.isLoading} emptyTitle="No violations in the view" />
      </Card>
    </>
  )
}
