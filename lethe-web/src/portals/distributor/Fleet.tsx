import { useMemo, useState } from 'react'
import { Clock, Plus, Snowflake, Truck, UserRound } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardHeader } from '@/components/ui/Card'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input, Select } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { MANIFEST_STATUS, VEHICLE_TYPES } from '@/lib/domain'
import { dateTime, num, relative } from '@/lib/format'
import type { Vehicle } from '@/lib/types'

function AddVehicle({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['organisations', 'vehicles'] as const)
  const { run, busy } = useRunner()
  const [no, setNo] = useState('')
  const [type, setType] = useState<string>('Reefer')
  const [org, setOrg] = useState('')
  const transporters = data.organisations.filter((o) => o.org_type === 'Transporter')
  const dup = data.vehicles.some((v) => v.vehicle_no.toLowerCase() === no.trim().toLowerCase())
  const valid = no.trim().length >= 6 && !dup && org

  const submit = async () => {
    const r = await run(
      'vehicle',
      async () => {
        const { error } = await db('fulfillment').from('vehicle_fleet_registry').insert({ vehicle_no: no.trim().toUpperCase(), vehicle_type: type, transporter_org_id: org })
        if (error) throw error
        await logEvent(profile.user_id, 'VEHICLE_REGISTERED', 'FORWARD_FULFILLMENT', { vehicle_no: no.trim().toUpperCase(), vehicle_type: type, severity: 'LOW' })
      },
      { success: `Vehicle ${no.trim().toUpperCase()} registered` },
    )
    if (r.ok) {
      setNo('')
      onClose()
    }
  }
  return (
    <Modal
      open={open}
      onClose={onClose}
      icon={Truck}
      title="Register a vehicle"
      size="sm"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Plus} disabled={!valid} loading={busy === 'vehicle'} onClick={submit}>
            Register
          </Button>
        </>
      }
    >
      <div className="dist-modal-stack">
        <Field label="Registration number" required error={dup ? 'Already registered.' : undefined}>
          <Input value={no} onChange={(e) => setNo(e.target.value)} placeholder="MP-04-RF-3344" className="dist-reg-input" />
        </Field>
        <Field label="Vehicle type" required hint="Reefers are refrigerated and required for cold-chain medicines.">
          <Select value={type} onChange={(e) => setType(e.target.value)}>
            {VEHICLE_TYPES.map((t) => (
              <option key={t}>{t}</option>
            ))}
          </Select>
        </Field>
        <Field label="Transporter" required>
          <Select value={org} onChange={(e) => setOrg(e.target.value)}>
            <option value="">Choose a transporter…</option>
            {transporters.map((o) => (
              <option key={o.org_id} value={o.org_id}>
                {o.org_name}
                {o.is_active ? '' : ' (inactive)'}
              </option>
            ))}
          </Select>
        </Field>
      </div>
    </Modal>
  )
}

export function Fleet() {
  const L = useLookups()
  const t = useTables(['vehicles', 'manifests', 'users', 'organisations', 'orders'] as const)
  const [adding, setAdding] = useState(false)

  const model = useMemo(() => {
    const d = t.data
    // A vehicle is on a trip only while its manifest is open AND the order is still Shipped
    const shipped = new Set(d.orders.filter((o) => o.order_status === 'Shipped').map((o) => o.order_id))
    return d.vehicles.map((v) => {
      const trips = d.manifests.filter((m) => m.vehicle_id === v.vehicle_id)
      const current = trips.find((m) => m.manifest_status !== 'Delivered' && shipped.has(m.order_id))
      return { v, trips: trips.length, current }
    })
  }, [t.data])

  const transporterOrgs = new Set(t.data.organisations.filter((o) => o.org_type === 'Transporter').map((o) => o.org_id))
  const drivers = t.data.users.filter((u) => u.org_id && transporterOrgs.has(u.org_id))

  type Row = (typeof model)[number]
  const cols: Column<Row>[] = [
    { key: 'no', header: 'Vehicle', sort: (r) => r.v.vehicle_no, cell: (r) => <Code>{r.v.vehicle_no}</Code> },
    { key: 'type', header: 'Type', sort: (r) => r.v.vehicle_type, cell: (r) => (r.v.vehicle_type === 'Reefer' ? <Badge tone="info" icon={Snowflake}>Reefer</Badge> : <Badge icon={Truck}>{r.v.vehicle_type}</Badge>) },
    { key: 'org', header: 'Transporter', sort: (r) => L.orgName(r.v.transporter_org_id), cell: (r) => <span className="dist-cell-text">{L.orgName(r.v.transporter_org_id)}</span> },
    {
      key: 'current',
      header: 'Current assignment',
      cell: (r) =>
        r.current ? (
          <div className="dist-cell-text">
            <span className="dist-bold">Order #{r.current.order_id}</span>{' '}
            <StatusBadge value={r.current.manifest_status} meta={MANIFEST_STATUS} />
            <p className="dist-tiny-grey">
              {L.userName(r.current.driver_user_id)} · ETA {r.current.estimated_arrival_time ? relative(r.current.estimated_arrival_time) : 'n/a'}
            </p>
          </div>
        ) : (
          <Badge tone="good" dot>
            Available
          </Badge>
        ),
    },
    { key: 'trips', header: 'Trips', align: 'right', sort: (r) => r.trips, cell: (r) => num(r.trips) },
    { key: 'since', header: 'Registered', sort: (r) => r.v.created_at_utc, cell: (r) => <span className="dist-cell-grey">{dateTime(r.v.created_at_utc)}</span>, hideBelow: 'lg' },
  ]

  const reefers = t.data.vehicles.filter((v: Vehicle) => v.vehicle_type === 'Reefer').length
  const onTrip = model.filter((r) => r.current).length
  const delayed = model.filter((r) => r.current?.manifest_status === 'Delayed').length

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={Plus} onClick={() => setAdding(true)}>Register vehicle</Button>} />
      <StatGrid cols={4}>
        <Stat label="Fleet size" value={num(t.data.vehicles.length)} sub="registered vehicles" icon={Truck} />
        <Stat label="Refrigerated" value={num(reefers)} sub="Reefers for 2–8°C cargo" icon={Snowflake} tone="info" />
        <Stat label="On a trip" value={num(onTrip)} sub={`${t.data.vehicles.length - onTrip} available`} icon={Clock} tone="accent" />
        <Stat label="Delayed" value={num(delayed)} sub="manifests flagged late" icon={Clock} tone="serious" />
      </StatGrid>
      <Card className="dist-card-gap">
        <CardHeader title="Vehicle registry" subtitle="forward_fulfillment.vehicle_fleet_registry with live manifest assignments" />
        <DataTable bare rows={model} columns={cols} rowKey={(r) => r.v.vehicle_id} loading={t.isLoading} searchText={(r) => `${r.v.vehicle_no} ${r.v.vehicle_type} ${L.orgName(r.v.transporter_org_id)}`} />
      </Card>
      <Card className="dist-card-gap-2">
        <CardHeader title="Drivers" subtitle="Users belonging to transporter organisations" icon={UserRound} />
        <div className="dist-driver-grid grid sm:grid-cols-2 xl:grid-cols-3">
          {drivers.map((u) => {
            const trip = model.find((r) => r.current?.driver_user_id === u.user_id)
            return (
              <div key={u.user_id} className="dist-driver-box">
                <div>
                  <p className="dist-driver-name">
                    {u.first_name} {u.last_name}
                  </p>
                  <p className="dist-tiny-grey">{L.orgName(u.org_id)}</p>
                </div>
                {!u.is_active ? <Badge>Inactive</Badge> : trip ? <Badge tone="info">Driving {trip.v.vehicle_no}</Badge> : <Badge tone="good" dot>Free</Badge>}
              </div>
            )
          })}
        </div>
      </Card>
      <AddVehicle open={adding} onClose={() => setAdding(false)} />
    </>
  )
}
