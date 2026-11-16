import { useMemo } from 'react'
import { useNavigate } from 'react-router'
import { AlertTriangle, Boxes, CalendarX2, Gauge, PackageCheck, ShieldAlert, Snowflake, Thermometer, Truck } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { ColumnChart, SERIES } from '@/components/charts/Charts'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { EmptyState } from '@/components/ui/Feedback'
import { Meter } from '@/components/ui/Progress'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { compact, num, pct, plural, relative, temp } from '@/lib/format'
import { cn } from '@/lib/cn'
import { useWarehouseModel } from './model'

export function Overview() {
  const profile = useProfile()
  const navigate = useNavigate()
  const L = useLookups()
  const m = useWarehouseModel()
  const t = useTables(['orders', 'manifests'] as const)

  const orders = useMemo(() => {
    const toFulfil = t.data.orders.filter((o) => o.order_status === 'Pending' || o.order_status === 'Approved')
    const inTransit = t.data.manifests.filter((x) => x.manifest_status === 'In-Transit' || x.manifest_status === 'Delayed')
    const delayed = t.data.manifests.filter((x) => x.manifest_status === 'Delayed')
    return { toFulfil, inTransit, delayed, pending: toFulfil.filter((o) => o.order_status === 'Pending').length }
  }, [t.data])

  const chart = m.warehouses
    .filter((w) => w.w.is_active)
    .map((w) => ({
      name: w.w.warehouse_name.replace(/ (Distribution Center|Transit Facility|Medical Depot|Regional Hub|Central Hub)$/, ''),
      general: w.general.reduce((s, l) => s + l.stock, 0),
      cold: w.cold.reduce((s, l) => s + l.stock, 0),
    }))

  const alerts = [
    ...m.breaches.map((l) => ({
      id: `b-${l.loc.location_id}`,
      tone: 'critical' as const,
      icon: Thermometer,
      title: `${l.state === 'high' ? 'Too warm' : 'Too cold'}: ${L.locLabel(l.loc.location_id)}`,
      detail: `Read ${temp(l.reading?.temperature_celsius)} against ${l.loc.target_min_temp}–${l.loc.target_max_temp}°C · ${relative(l.reading?.recorded_at)}`,
      to: '/distributor/coldchain',
    })),
    ...m.expiredStock.map((i) => ({
      id: `e-${i.inventory_id}`,
      tone: 'serious' as const,
      icon: CalendarX2,
      title: `Expired stock on shelf: ${L.batchNo(i.batch_id)}`,
      detail: `${num(i.available_quantity)} units at ${L.locLabel(i.location_id)}. Write off or quarantine.`,
      to: '/distributor/inventory',
    })),
    ...orders.delayed.map((x) => ({
      id: `d-${x.manifest_id}`,
      tone: 'warn' as const,
      icon: Truck,
      title: `Shipment delayed: order #${x.order_id}`,
      detail: `${L.vehicle.get(x.vehicle_id)?.vehicle_no ?? 'Vehicle'} · ETA ${relative(x.estimated_arrival_time)}`,
      to: '/distributor/fulfillment',
    })),
  ]

  return (
    <>
      <PageHeader
        title={`Warehouse operations, ${profile.first_name}`}
        description={`${profile.org?.org_name} · ${m.warehouses.filter((w) => w.w.is_active).length} active facilities across Madhya Pradesh`}
        actions={
          <Button variant="primary" icon={PackageCheck} onClick={() => navigate('/distributor/fulfillment')}>
            Fulfil orders
          </Button>
        }
      />

      <StatGrid>
        <Stat label="Units on hand" value={compact(m.totalStock)} sub={`${m.locations.filter((l) => l.stock > 0).length} storage locations in use`} icon={Boxes} loading={m.isLoading} />
        <Stat label="Capacity used" value={pct(m.totalCapacity ? m.totalStock / m.totalCapacity : 0)} sub={`${compact(m.totalStock)} of ${compact(m.totalCapacity)} units`} icon={Gauge} tone="info" loading={m.isLoading} />
        <Stat label="Zones out of range" value={num(m.breaches.length)} sub="latest sensor reading breaches target" icon={Thermometer} tone="critical" loading={m.isLoading} onClick={() => navigate('/distributor/coldchain')} />
        <Stat label="Active quarantines" value={num(m.activeQuarantine.length)} sub="batches held after a breach" icon={ShieldAlert} tone="serious" loading={m.isLoading} onClick={() => navigate('/distributor/coldchain')} />
        <Stat label="Orders to fulfil" value={num(orders.toFulfil.length)} sub={`${orders.pending} awaiting approval`} icon={PackageCheck} tone="warn" loading={t.isLoading} onClick={() => navigate('/distributor/fulfillment')} />
        <Stat label="In transit" value={num(orders.inTransit.length)} sub={`${orders.delayed.length} delayed`} icon={Truck} tone="accent" loading={t.isLoading} onClick={() => navigate('/distributor/fleet')} />
      </StatGrid>

      <div className="dist-wh-grid grid md:grid-cols-2 2xl:grid-cols-3">
        {m.warehouses.map((w) => {
          const ratio = w.capacity ? w.stock / w.capacity : 0
          return (
            <Card key={w.w.warehouse_id} className={cn('dist-wh-box', !w.w.is_active && 'dist-faded')}>
              <div className="dist-wh-top">
                <div className="dist-wh-info">
                  <p className="dist-wh-name">{w.w.warehouse_name}</p>
                  <p className="dist-wh-city">
                    {w.w.city}, {w.w.state} · manager {L.userName(w.w.manager_user_id)}
                  </p>
                </div>
                {!w.w.is_active ? <Badge>Inactive</Badge> : w.breaches > 0 ? <Badge tone="critical" icon={AlertTriangle}>{plural(w.breaches, 'breach', 'breaches')}</Badge> : <Badge tone="good" dot>Nominal</Badge>}
              </div>
              <div className="dist-capacity">
                <div className="dist-capacity-row">
                  <span className="dist-grey">Capacity</span>
                  <span>
                    <b>{compact(w.stock)}</b> / {compact(w.capacity)} · {pct(ratio)}
                  </span>
                </div>
                <Meter value={w.stock} max={w.capacity} />
              </div>
              <div className="dist-tag-row">
                <Badge tone="info" icon={Snowflake}>
                  {w.cold.length} cold
                </Badge>
                <Badge>{w.general.length} general</Badge>
                {w.quarantines > 0 && <Badge tone="serious">{w.quarantines} quarantined</Badge>}
              </div>
            </Card>
          )
        })}
      </div>

      <div className="dist-chart-row grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Stock by facility" subtitle="Units on hand, split by zone type" />
          <CardBody>
            <ColumnChart
              data={chart}
              x="name"
              stacked
              format={(n) => `${num(n)} units`}
              series={[
                { key: 'general', label: 'General zone', color: SERIES[0] },
                { key: 'cold', label: 'Cold storage', color: SERIES[2] },
              ]}
            />
          </CardBody>
        </Card>
        <Card className="xl:col-span-2">
          <CardHeader title="Alerts" subtitle={`${alerts.length} items need attention`} icon={AlertTriangle} />
          <CardBody className="dist-alerts-body">
            {alerts.length === 0 ? (
              <EmptyState title="All clear" />
            ) : (
              <ul className="dist-alert-list">
                {alerts.map((a) => (
                  <li key={a.id}>
                    <button onClick={() => navigate(a.to)} className="dist-alert-btn">
                      <Badge tone={a.tone} icon={a.icon} className="dist-alert-tag">
                        {a.tone === 'critical' ? 'Critical' : a.tone === 'serious' ? 'Serious' : 'Warning'}
                      </Badge>
                      <span className="dist-alert-text">
                        <span className="dist-alert-title">{a.title}</span>
                        <span className="dist-alert-detail">{a.detail}</span>
                      </span>
                    </button>
                  </li>
                ))}
              </ul>
            )}
          </CardBody>
        </Card>
      </div>
    </>
  )
}
