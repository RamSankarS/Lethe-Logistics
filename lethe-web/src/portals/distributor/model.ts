import { useMemo } from 'react'
import { useLookups, useTables } from '@/data/hooks'
import { isExpired, latestReadings, readingState, type ReadingState } from '@/lib/domain'
import type { InventoryRow, SensorLog, StorageLocation, Warehouse } from '@/lib/types'

export interface LocationView {
  loc: StorageLocation
  wh: Warehouse | undefined
  stock: number
  utilisation: number
  reading: SensorLog | undefined
  state: ReadingState
  items: InventoryRow[]
  readings: SensorLog[]
}

/** Warehouse network model shared by the distributor tabs. */
export function useWarehouseModel() {
  const L = useLookups()
  const t = useTables(['warehouses', 'locations', 'inventory', 'sensorLogs', 'quarantine', 'batches'] as const)

  return useMemo(() => {
    const d = t.data
    const latest = latestReadings(d.sensorLogs)
    const byLoc = new Map<number, InventoryRow[]>()
    for (const i of d.inventory) byLoc.set(i.location_id, [...(byLoc.get(i.location_id) ?? []), i])
    const readingsByLoc = new Map<number, SensorLog[]>()
    for (const s of d.sensorLogs) readingsByLoc.set(s.location_id, [...(readingsByLoc.get(s.location_id) ?? []), s])

    const locations: LocationView[] = d.locations.map((loc) => {
      const items = (byLoc.get(loc.location_id) ?? []).filter((i) => i.available_quantity > 0)
      const stock = items.reduce((s, i) => s + i.available_quantity, 0)
      const reading = latest.get(loc.location_id)
      return {
        loc,
        wh: L.wh.get(loc.warehouse_id),
        stock,
        utilisation: loc.max_capacity ? stock / loc.max_capacity : 0,
        reading,
        state: readingState(reading, loc),
        items,
        readings: readingsByLoc.get(loc.location_id) ?? [],
      }
    })

    const warehouses = d.warehouses.map((w) => {
      const locs = locations.filter((l) => l.loc.warehouse_id === w.warehouse_id)
      const active = locs.filter((l) => l.loc.is_active)
      const stock = locs.reduce((s, l) => s + l.stock, 0)
      const capacity = active.reduce((s, l) => s + l.loc.max_capacity, 0)
      return {
        w,
        locs,
        stock,
        capacity,
        cold: locs.filter((l) => l.loc.zone_type === 'Cold Storage'),
        general: locs.filter((l) => l.loc.zone_type === 'General'),
        breaches: locs.filter((l) => l.loc.is_active && (l.state === 'high' || l.state === 'low')).length,
        quarantines: d.quarantine.filter((q) => q.status === 'Active' && locs.some((l) => l.loc.location_id === q.location_id)).length,
      }
    })

    const totalStock = locations.reduce((s, l) => s + l.stock, 0)
    const totalCapacity = locations.filter((l) => l.loc.is_active).reduce((s, l) => s + l.loc.max_capacity, 0)
    const breaches = locations.filter((l) => l.loc.is_active && (l.state === 'high' || l.state === 'low'))
    const activeQuarantine = d.quarantine.filter((q) => q.status === 'Active')
    const expiredStock = d.inventory.filter((i) => {
      const b = L.batchOf(i.batch_id)
      return i.available_quantity > 0 && b && isExpired(b)
    })
    return { locations, warehouses, totalStock, totalCapacity, breaches, activeQuarantine, expiredStock, isLoading: t.isLoading || L.isLoading }
  }, [t.data, t.isLoading, L])
}
