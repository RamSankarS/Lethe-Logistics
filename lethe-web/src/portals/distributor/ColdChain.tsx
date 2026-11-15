import { useMemo, useState } from 'react'
import { CheckCircle2, Droplets, Flame, Radio, ShieldAlert, Snowflake, Sun, Thermometer, TriangleAlert } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { BandChart, Sparkline } from '@/components/charts/Charts'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, FormGrid, Input, Select } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { QUARANTINE_STATUS } from '@/lib/domain'
import { dateTime, num, plural, relative, shortDate, temp, time } from '@/lib/format'
import { cn } from '@/lib/cn'
import type { QuarantineLog } from '@/lib/types'
import { useWarehouseModel, type LocationView } from './model'

function LogReading({ open, onClose, preset }: { open: boolean; onClose: () => void; preset?: number }) {
  const profile = useProfile()
  const L = useLookups()
  const m = useWarehouseModel()
  const { run, busy } = useRunner()
  const [locId, setLocId] = useState(preset ? String(preset) : '')
  const [t, setT] = useState('')
  const [h, setH] = useState('45')

  const v = m.locations.find((l) => String(l.loc.location_id) === locId)
  const value = Number(t)
  const hasT = t.trim() !== '' && Number.isFinite(value)
  const breach = v && hasT && (value > Number(v.loc.target_max_temp) || value < Number(v.loc.target_min_temp))
  const locked = breach ? v!.items.filter((i) => ['Rejected', 'Recalled'].includes(L.batchOf(i.batch_id)?.status ?? '')) : []
  const valid = v && hasT && Number(h) >= 0 && Number(h) <= 100

  const submit = async () => {
    if (!v) return
    const r = await run(
      'reading',
      async () => {
        const { error } = await db('warehouse').from('environmental_sensor_logs').insert({ location_id: v.loc.location_id, temperature_celsius: value, humidity_percentage: Number(h) })
        if (error) throw error
        if (breach) {
          await logEvent(profile.user_id, 'TEMPERATURE_BREACH', 'WAREHOUSE_OPS', {
            location_id: v.loc.location_id,
            location: L.locLabel(v.loc.location_id),
            temperature: value,
            target: `${v.loc.target_min_temp}-${v.loc.target_max_temp}`,
            batches_quarantined: v.items.map((i) => L.batchNo(i.batch_id)),
            severity: v.loc.zone_type === 'Cold Storage' ? 'CRITICAL' : 'HIGH',
          })
        }
      },
      breach
        ? { success: 'Breach recorded: stock quarantined', description: `${v.items.length} batch(es) quarantined and sent back to Quality-Check by tr_monitor_temperature_breach.` }
        : { success: 'Reading logged', description: 'Within target range.' },
    )
    if (r.ok) {
      setT('')
      onClose()
    }
  }

  return (
    <Modal
      open={open}
      onClose={onClose}
      icon={Radio}
      title="Log a sensor reading"
      description="Simulates an IoT probe. Out-of-range readings trigger automatic quarantine in the database."
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant={breach ? 'danger' : 'primary'} icon={breach ? TriangleAlert : Radio} disabled={!valid} loading={busy === 'reading'} onClick={submit}>
            {breach ? 'Record breach' : 'Log reading'}
          </Button>
        </>
      }
    >
      <div className="space-y-4">
        <Field label="Storage location" required>
          <Select value={locId} onChange={(e) => setLocId(e.target.value)}>
            <option value="">Choose a location…</option>
            {m.locations
              .filter((l) => l.loc.is_active)
              .map((l) => (
                <option key={l.loc.location_id} value={l.loc.location_id}>
                  {L.locLabel(l.loc.location_id)} · target {l.loc.target_min_temp}–{l.loc.target_max_temp}°C
                </option>
              ))}
          </Select>
        </Field>
        <FormGrid>
          <Field label="Temperature (°C)" required>
            <Input type="number" step="0.1" value={t} onChange={(e) => setT(e.target.value)} placeholder={v ? `${(Number(v.loc.target_min_temp) + Number(v.loc.target_max_temp)) / 2}` : '5.0'} />
          </Field>
          <Field label="Humidity (%)" required>
            <Input type="number" step="1" min={0} max={100} value={h} onChange={(e) => setH(e.target.value)} />
          </Field>
        </FormGrid>
        {v && hasT && !breach && (
          <Callout tone="good" title="Within target range">
            {temp(value)} sits inside {v.loc.target_min_temp}–{v.loc.target_max_temp}°C. No action will be taken.
          </Callout>
        )}
        {breach && (
          <Callout tone="critical" title={`Breach: ${value > Number(v!.loc.target_max_temp) ? 'too warm' : 'too cold'}`}>
            The database trigger will quarantine{' '}
            {v!.items.length ? (
              <>
                <b className="text-ink">{v!.items.length} batch(es)</b> on this shelf ({v!.items.map((i) => L.batchNo(i.batch_id)).join(', ')}) and flag them for Quality-Check network-wide.
              </>
            ) : (
              'nothing: this shelf is empty.'
            )}
            {locked.length > 0 && (
              <p className="mt-2 font-medium text-critical-text">
                {locked.map((i) => L.batchNo(i.batch_id)).join(', ')} is Recalled/Rejected. Recalled batches can never be re-flagged for QC, so the database may reject this reading. Move that stock first.
              </p>
            )}
          </Callout>
        )}
      </div>
    </Modal>
  )
}

function ZoneCard({ v, onLog, selected, onSelect }: { v: LocationView; onLog: () => void; selected: boolean; onSelect: () => void }) {
  const cold = v.loc.zone_type === 'Cold Storage'
  const breach = v.state === 'high' || v.state === 'low'
  return (
    <Card className={cn('cursor-pointer p-4 transition-colors', selected ? 'border-accent ring-[3px] ring-accent/15' : 'hover:border-line-strong')} onClick={onSelect}>
      <div className="flex items-start justify-between gap-2">
        <div className="min-w-0">
          <p className="flex items-center gap-1.5 text-[13.5px] font-semibold text-ink">
            {cold ? <Snowflake className="size-4 text-info-text" /> : <Sun className="size-4 text-warn-text" />}
            {v.wh?.warehouse_name}
          </p>
          <p className="text-xs text-ink-2">
            L{v.loc.location_id} · {v.loc.zone_type} · target {v.loc.target_min_temp}–{v.loc.target_max_temp}°C
          </p>
        </div>
        {v.state === 'none' ? <Badge>No data</Badge> : breach ? <Badge tone="critical" icon={TriangleAlert}>{v.state === 'high' ? 'Too warm' : 'Too cold'}</Badge> : <Badge tone="good" icon={CheckCircle2}>In range</Badge>}
      </div>
      <div className="mt-3 flex items-end justify-between gap-2">
        <div>
          <p className={cn('text-[30px] leading-9 font-semibold tracking-tight tabular', breach ? 'text-critical-text' : 'text-ink')}>{v.reading ? temp(v.reading.temperature_celsius) : '—'}</p>
          <p className="flex items-center gap-1 text-xs text-ink-2">
            <Droplets className="size-3.5" /> {v.reading ? `${num(v.reading.humidity_percentage)}% RH` : 'no humidity data'} · {v.reading ? relative(v.reading.recorded_at) : 'never'}
          </p>
        </div>
        <Sparkline values={v.readings.map((r) => r.temperature_celsius)} color={breach ? 'var(--critical)' : 'var(--series-1)'} />
      </div>
      <div className="mt-3 flex items-center justify-between border-t border-line pt-2.5">
        <span className="text-xs text-ink-2">
          {plural(v.items.length, 'batch', 'batches')} · {num(v.stock)} units
        </span>
        <Button
          size="xs"
          variant="ghost"
          icon={Radio}
          onClick={(e) => {
            e.stopPropagation()
            onLog()
          }}
        >
          Log reading
        </Button>
      </div>
    </Card>
  )
}

export function ColdChain() {
  const profile = useProfile()
  const L = useLookups()
  const m = useWarehouseModel()
  const t = useTables(['sensorLogs', 'quarantine'] as const)
  const { run, busy } = useRunner()
  const [logging, setLogging] = useState<{ preset?: number } | null>(null)
  const [selected, setSelected] = useState<number | null>(null)
  const [zone, setZone] = useState<'all' | 'cold' | 'breach'>('all')

  const zones = m.locations.filter((l) => l.loc.is_active && (zone === 'all' || (zone === 'cold' ? l.loc.zone_type === 'Cold Storage' : l.state === 'high' || l.state === 'low')))
  const sel = m.locations.find((l) => l.loc.location_id === (selected ?? m.breaches[0]?.loc.location_id ?? zones[0]?.loc.location_id))
  const sensorById = useMemo(() => new Map(t.data.sensorLogs.map((s) => [s.log_id, s])), [t.data.sensorLogs])

  const setQ = (q: QuarantineLog, status: 'Cleared' | 'Destroyed') =>
    run(
      `q-${q.quarantine_id}`,
      async () => {
        await mustChange(db('warehouse').from('quarantine_area_logs').update({ status }).eq('quarantine_id', q.quarantine_id).select('quarantine_id'))
        await logEvent(profile.user_id, status === 'Cleared' ? 'QUARANTINE_CLEARED' : 'QUARANTINE_DESTROYED', 'WAREHOUSE_OPS', { quarantine_id: q.quarantine_id, batch_id: q.batch_id, batch_number: L.batchNo(q.batch_id), location: L.locLabel(q.location_id), severity: status === 'Destroyed' ? 'HIGH' : 'MEDIUM' })
      },
      { success: status === 'Cleared' ? 'Quarantine cleared' : 'Quarantined stock marked destroyed', description: status === 'Cleared' ? 'The batch stays in Quality-Check until the manufacturer re-releases it.' : undefined },
    )

  const qCols: Column<QuarantineLog>[] = [
    { key: 'id', header: '#', sort: (q) => q.quarantine_id, cell: (q) => <span className="tabular text-ink-2">{q.quarantine_id}</span> },
    { key: 'batch', header: 'Batch', sort: (q) => L.batchNo(q.batch_id), cell: (q) => <div><Code>{L.batchNo(q.batch_id)}</Code><p className="mt-0.5 text-xs text-ink-2">{L.medName(q.batch_id)}</p></div> },
    { key: 'loc', header: 'Location', cell: (q) => <span className="text-[13px] text-ink-2">{L.locLabel(q.location_id)}</span>, hideBelow: 'md' },
    {
      key: 'reading',
      header: 'Trigger',
      cell: (q) => {
        const s = q.breaching_log_id != null ? sensorById.get(q.breaching_log_id) : undefined
        return s ? <span className="text-[13px]"><b className="font-semibold text-critical-text">{temp(s.temperature_celsius)}</b> <span className="text-ink-2">· {dateTime(s.recorded_at)}</span></span> : <span className="text-ink-2">{q.quarantine_reason}</span>
      },
    },
    { key: 'by', header: 'Responsible', cell: (q) => <span className="text-[13px] text-ink-2">{L.userName(q.action_taken_by)}</span>, hideBelow: 'lg' },
    { key: 'status', header: 'Status', sort: (q) => q.status, cell: (q) => <StatusBadge value={q.status} meta={QUARANTINE_STATUS} /> },
    {
      key: 'act',
      header: '',
      cell: (q) =>
        q.status === 'Active' ? (
          <div className="flex justify-end gap-1">
            <Button size="xs" variant="ghost" icon={CheckCircle2} loading={busy === `q-${q.quarantine_id}`} onClick={() => void setQ(q, 'Cleared')}>
              Clear
            </Button>
            <Button size="xs" variant="ghost" icon={Flame} className="text-critical-text hover:bg-critical-soft" onClick={() => void setQ(q, 'Destroyed')}>
              Destroyed
            </Button>
          </div>
        ) : null,
    },
  ]

  const inRange = m.locations.filter((l) => l.loc.is_active && l.state === 'ok').length
  const monitored = m.locations.filter((l) => l.loc.is_active && l.state !== 'none').length

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={Radio} onClick={() => setLogging({})}>Log sensor reading</Button>} />
      <StatGrid cols={4}>
        <Stat label="Zones monitored" value={`${monitored}/${m.locations.filter((l) => l.loc.is_active).length}`} sub="active locations with sensor data" icon={Thermometer} />
        <Stat label="In range" value={num(inRange)} sub="latest reading inside target band" icon={CheckCircle2} tone="good" />
        <Stat label="Breaching now" value={num(m.breaches.length)} sub="latest reading outside target band" icon={TriangleAlert} tone="critical" />
        <Stat label="Active quarantines" value={num(m.activeQuarantine.length)} sub="stock held pending QC" icon={ShieldAlert} tone="serious" />
      </StatGrid>

      <div className="mt-5 mb-3">
        <Segmented
          value={zone}
          onChange={setZone}
          options={[
            { value: 'all', label: 'All zones', count: m.locations.filter((l) => l.loc.is_active).length },
            { value: 'cold', label: 'Cold storage', count: m.locations.filter((l) => l.loc.is_active && l.loc.zone_type === 'Cold Storage').length },
            { value: 'breach', label: 'Breaching', count: m.breaches.length },
          ]}
        />
      </div>
      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4">
        {zones.map((v) => (
          <ZoneCard key={v.loc.location_id} v={v} selected={sel?.loc.location_id === v.loc.location_id} onSelect={() => setSelected(v.loc.location_id)} onLog={() => setLogging({ preset: v.loc.location_id })} />
        ))}
        {zones.length === 0 && (
          <Card className="sm:col-span-2 xl:col-span-3">
            <EmptyState icon={CheckCircle2} title="No zones in this view" />
          </Card>
        )}
      </div>

      {sel && (
        <Card className="mt-5">
          <CardHeader
            title={`Temperature trace · ${L.locLabel(sel.loc.location_id)}`}
            subtitle={`Green band = target ${sel.loc.target_min_temp}–${sel.loc.target_max_temp}°C. Red line marks the upper limit, blue the lower.`}
          />
          <CardBody>
            {sel.readings.length ? (
              <BandChart data={sel.readings.map((r) => ({ t: `${shortDate(r.recorded_at)} ${time(r.recorded_at)}`, value: r.temperature_celsius }))} min={Number(sel.loc.target_min_temp)} max={Number(sel.loc.target_max_temp)} />
            ) : (
              <EmptyState title="No readings for this zone" />
            )}
          </CardBody>
        </Card>
      )}

      <Card className="mt-5">
        <CardHeader title="Quarantine register" subtitle="Rows written by tr_monitor_temperature_breach when a reading leaves the target band" icon={ShieldAlert} />
        <DataTable bare rows={t.data.quarantine} columns={qCols} rowKey={(q) => q.quarantine_id} initialSort={{ key: 'id', dir: 'desc' }} />
      </Card>

      <LogReading open={!!logging} preset={logging?.preset} onClose={() => setLogging(null)} key={logging?.preset ?? 'new'} />
    </>
  )
}
