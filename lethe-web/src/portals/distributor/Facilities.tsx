import { useState } from 'react'
import { Building2, MapPin, Plus, Snowflake, Sun } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardHeader } from '@/components/ui/Card'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, FormGrid, Input, Select, Switch } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Meter } from '@/components/ui/Progress'
import { num } from '@/lib/format'
import { useWarehouseModel, type LocationView } from './model'

function AddLocation({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['warehouses'] as const)
  const { run, busy } = useRunner()
  const [wh, setWh] = useState('')
  const [zone, setZone] = useState<'Cold Storage' | 'General'>('Cold Storage')
  const [minT, setMinT] = useState('2')
  const [maxT, setMaxT] = useState('8')
  const [hum, setHum] = useState('45')
  const [cap, setCap] = useState('1000')
  const valid = wh && Number(minT) < Number(maxT) && Number(cap) > 0 && Number(hum) >= 0 && Number(hum) <= 100

  const submit = async () => {
    const r = await run(
      'loc',
      async () => {
        const { error } = await db('warehouse').from('storage_location').insert({ warehouse_id: Number(wh), zone_type: zone, target_min_temp: Number(minT), target_max_temp: Number(maxT), max_capacity: Number(cap), target_humidity_limit: Number(hum), is_active: true })
        if (error) throw error
        await logEvent(profile.user_id, 'STORAGE_LOCATION_CREATED', 'WAREHOUSE_OPS', { warehouse_id: Number(wh), zone_type: zone, band: `${minT}-${maxT}`, capacity: Number(cap), severity: 'LOW' })
      },
      { success: 'Storage location added' },
    )
    if (r.ok) onClose()
  }
  return (
    <Modal
      open={open}
      onClose={onClose}
      icon={MapPin}
      title="Add a storage location"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Plus} disabled={!valid} loading={busy === 'loc'} onClick={submit}>
            Add location
          </Button>
        </>
      }
    >
      <FormGrid>
        <Field label="Warehouse" required className="sm:col-span-2">
          <Select value={wh} onChange={(e) => setWh(e.target.value)}>
            <option value="">Choose a warehouse…</option>
            {data.warehouses.map((w) => (
              <option key={w.warehouse_id} value={w.warehouse_id} disabled={!w.is_active}>
                {w.warehouse_name} · {w.city}
                {w.is_active ? '' : ' (inactive)'}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Zone type" required>
          <Select
            value={zone}
            onChange={(e) => {
              const z = e.target.value as 'Cold Storage' | 'General'
              setZone(z)
              setMinT(z === 'Cold Storage' ? '2' : '15')
              setMaxT(z === 'Cold Storage' ? '8' : '25')
              setHum(z === 'Cold Storage' ? '45' : '60')
            }}
          >
            <option>Cold Storage</option>
            <option>General</option>
          </Select>
        </Field>
        <Field label="Capacity (units)" required>
          <Input type="number" min={1} value={cap} onChange={(e) => setCap(e.target.value)} />
        </Field>
        <Field label="Target min °C" required>
          <Input type="number" step="0.5" value={minT} onChange={(e) => setMinT(e.target.value)} />
        </Field>
        <Field label="Target max °C" required error={Number(minT) >= Number(maxT) ? 'Must exceed min.' : undefined}>
          <Input type="number" step="0.5" value={maxT} onChange={(e) => setMaxT(e.target.value)} />
        </Field>
        <Field label="Humidity limit %" required className="sm:col-span-2" hint="Medicines with a lower humidity tolerance will be refused here by the database.">
          <Input type="number" min={0} max={100} value={hum} onChange={(e) => setHum(e.target.value)} />
        </Field>
      </FormGrid>
    </Modal>
  )
}

export function Facilities() {
  const profile = useProfile()
  const L = useLookups()
  const m = useWarehouseModel()
  const { run, busy } = useRunner()
  const [adding, setAdding] = useState(false)

  const toggleWarehouse = (id: number, name: string, next: boolean) =>
    run(
      `wh-${id}`,
      async () => {
        await mustChange(db('warehouse').from('warehouse').update({ is_active: next }).eq('warehouse_id', id).select('warehouse_id'))
        await logEvent(profile.user_id, next ? 'WAREHOUSE_ACTIVATED' : 'WAREHOUSE_DEACTIVATED', 'WAREHOUSE_OPS', { warehouse_id: id, warehouse_name: name, severity: 'MEDIUM' })
      },
      { success: `${name} ${next ? 'activated' : 'deactivated'}` },
    )

  const toggleLocation = (v: LocationView, next: boolean) =>
    run(
      `loc-${v.loc.location_id}`,
      async () => {
        await mustChange(db('warehouse').from('storage_location').update({ is_active: next }).eq('location_id', v.loc.location_id).select('location_id'))
        await logEvent(profile.user_id, next ? 'STORAGE_LOCATION_ACTIVATED' : 'STORAGE_LOCATION_DEACTIVATED', 'WAREHOUSE_OPS', { location_id: v.loc.location_id, location: L.locLabel(v.loc.location_id), severity: 'LOW' })
      },
      { success: `L${v.loc.location_id} ${next ? 'activated' : 'deactivated'}` },
    )

  const cols: Column<LocationView>[] = [
    { key: 'id', header: 'Location', sort: (v) => v.loc.location_id, cell: (v) => <span className="inline-flex items-center gap-1.5 font-medium">{v.loc.zone_type === 'Cold Storage' ? <Snowflake className="size-4 text-info-text" /> : <Sun className="size-4 text-warn-text" />}L{v.loc.location_id}</span> },
    { key: 'wh', header: 'Warehouse', sort: (v) => v.wh?.warehouse_name ?? '', cell: (v) => <span className="text-[13px]">{v.wh?.warehouse_name}</span> },
    { key: 'zone', header: 'Zone', sort: (v) => v.loc.zone_type, cell: (v) => <Badge tone={v.loc.zone_type === 'Cold Storage' ? 'info' : 'neutral'}>{v.loc.zone_type}</Badge>, hideBelow: 'md' },
    { key: 'band', header: 'Target band', cell: (v) => <span className="text-[13px] text-ink-2 tabular">{v.loc.target_min_temp}–{v.loc.target_max_temp}°C · ≤{v.loc.target_humidity_limit}% RH</span>, hideBelow: 'lg' },
    {
      key: 'use',
      header: 'Utilisation',
      sort: (v) => v.utilisation,
      cell: (v) => (
        <div className="w-36">
          <div className="mb-1 flex justify-between text-xs text-ink-2 tabular">
            <span>{num(v.stock)}</span>
            <span>{num(v.loc.max_capacity)}</span>
          </div>
          <Meter value={v.stock} max={v.loc.max_capacity} />
        </div>
      ),
    },
    {
      key: 'active',
      header: 'Active',
      cell: (v) => <Switch checked={v.loc.is_active} disabled={busy === `loc-${v.loc.location_id}`} onChange={(next) => void toggleLocation(v, next)} label={`Toggle L${v.loc.location_id}`} />,
    },
  ]

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={Plus} onClick={() => setAdding(true)}>Add location</Button>} />
      <Callout tone="info" className="mb-5" title="Safety locks enforced by the database">
        A location still holding stock cannot be deactivated, and a warehouse cannot be shut while it has active locations. Try it: the trigger will refuse and explain why.
      </Callout>
      <div className="grid gap-4 md:grid-cols-2 2xl:grid-cols-3">
        {m.warehouses.map((w) => (
          <Card key={w.w.warehouse_id} className="p-4">
            <div className="flex items-start justify-between gap-3">
              <div className="flex items-start gap-3">
                <span className="grid size-9 place-items-center rounded-xl bg-accent-soft text-accent-text">
                  <Building2 className="size-[18px]" />
                </span>
                <div>
                  <p className="text-[14.5px] font-semibold text-ink">{w.w.warehouse_name}</p>
                  <p className="text-[12.5px] text-ink-2">
                    {w.w.city}, {w.w.state} · {L.userName(w.w.manager_user_id)}
                  </p>
                </div>
              </div>
              <Switch checked={w.w.is_active} disabled={busy === `wh-${w.w.warehouse_id}`} onChange={(v) => void toggleWarehouse(w.w.warehouse_id, w.w.warehouse_name, v)} label={`Toggle ${w.w.warehouse_name}`} />
            </div>
            <div className="mt-3 flex flex-wrap gap-1.5 text-xs">
              <Badge tone={w.w.is_active ? 'good' : 'neutral'} dot>
                {w.w.is_active ? 'Operational' : 'Shut'}
              </Badge>
              <Badge>{w.locs.filter((l) => l.loc.is_active).length} active locations</Badge>
              <Badge>{num(w.capacity)} capacity</Badge>
            </div>
          </Card>
        ))}
      </div>
      <Card className="mt-5">
        <CardHeader title="Storage locations" subtitle="smart_warehousing.storage_location" />
        <DataTable bare rows={m.locations} columns={cols} rowKey={(v) => v.loc.location_id} loading={m.isLoading} searchText={(v) => `L${v.loc.location_id} ${v.wh?.warehouse_name} ${v.loc.zone_type}`} initialSort={{ key: 'id', dir: 'asc' }} pageSize={12} />
      </Card>
      <AddLocation open={adding} onClose={() => setAdding(false)} />
    </>
  )
}
