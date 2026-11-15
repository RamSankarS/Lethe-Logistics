import { useMemo } from 'react'
import { useQueries, useQuery } from '@tanstack/react-query'
import { db } from '@/lib/supabase'
import { TABLES, type RowMap, type TableKey } from './tables'
import { fullName } from '@/lib/format'
import type { Batch, Medicine } from '@/lib/types'

const PAGE = 1000
const EMPTY: never[] = []

/** Reads a whole table, paging past the Data API's 1000-row cap. */
export async function fetchAll<K extends TableKey>(key: K): Promise<RowMap[K][]> {
  const def = TABLES[key] as { schema: Parameters<typeof db>[0]; table: string; select?: string; order?: { column: string; ascending?: boolean } }
  const rows: RowMap[K][] = []
  for (let from = 0; ; from += PAGE) {
    let q = db(def.schema).from(def.table).select(def.select ?? '*')
    if (def.order) q = q.order(def.order.column, { ascending: def.order.ascending ?? true })
    const { data, error } = await q.range(from, from + PAGE - 1)
    if (error) throw error
    rows.push(...((data ?? []) as unknown as RowMap[K][]))
    if (!data || data.length < PAGE) break
  }
  return rows
}

export const tableKey = (key: TableKey) => ['t', key] as const

/** One table as a cached query. */
export function useTable<K extends TableKey>(key: K, opts: { refetchInterval?: number; enabled?: boolean } = {}) {
  return useQuery({ queryKey: tableKey(key), queryFn: () => fetchAll(key), ...opts })
}

type DataOf<K extends readonly TableKey[]> = { [P in K[number]]: RowMap[P][] }

/** Several tables at once with a combined loading / error state. */
export function useTables<const K extends readonly TableKey[]>(keys: K, opts: { refetchInterval?: number } = {}) {
  return useQueries({
    queries: keys.map((k) => ({ queryKey: tableKey(k), queryFn: () => fetchAll(k), ...opts })),
    combine: (results) => {
      const data = {} as Record<string, unknown[]>
      keys.forEach((k, i) => {
        data[k] = (results[i]?.data as unknown[] | undefined) ?? EMPTY
      })
      return {
        data: data as DataOf<K>,
        isLoading: results.some((r) => r.isPending),
        isFetching: results.some((r) => r.isFetching),
        error: (results.find((r) => r.error)?.error as Error | null) ?? null,
        dataUpdatedAt: Math.max(0, ...results.map((r) => r.dataUpdatedAt)),
      }
    },
  })
}

/** Lookup maps for the reference tables used almost everywhere. */
export function useLookups() {
  const q = useTables(['organisations', 'users', 'roles', 'medicines', 'batches', 'locations', 'warehouses', 'vehicles', 'packaging'] as const)
  const { organisations, users, roles, medicines, batches, locations, warehouses, vehicles, packaging } = q.data

  const maps = useMemo(() => {
    const org = new Map(organisations.map((o) => [o.org_id, o]))
    const user = new Map(users.map((u) => [u.user_id, u]))
    const role = new Map(roles.map((r) => [r.role_id, r]))
    const med = new Map(medicines.map((m) => [m.medicine_id, m]))
    const batch = new Map(batches.map((b) => [b.batch_id, b]))
    const loc = new Map(locations.map((l) => [l.location_id, l]))
    const wh = new Map(warehouses.map((w) => [w.warehouse_id, w]))
    const vehicle = new Map(vehicles.map((v) => [v.vehicle_id, v]))
    const pkgByMed = new Map(packaging.map((p) => [p.medicine_id, p]))
    return { org, user, role, med, batch, loc, wh, vehicle, pkgByMed }
  }, [organisations, users, roles, medicines, batches, locations, warehouses, vehicles, packaging])

  const helpers = useMemo(() => {
    const orgName = (id?: string | null) => (id ? maps.org.get(id)?.org_name ?? 'Unknown organisation' : '—')
    const userName = (id?: string | null) => (id ? (maps.user.has(id) ? fullName(maps.user.get(id)) : 'Unknown user') : '—')
    const medOf = (b?: Batch | null): Medicine | undefined => (b?.medicine_id != null ? maps.med.get(b.medicine_id) : undefined)
    const batchOf = (id?: number | null) => (id != null ? maps.batch.get(id) : undefined)
    const medName = (batchId?: number | null) => medOf(batchOf(batchId))?.brand_name ?? '—'
    const batchNo = (id?: number | null) => batchOf(id)?.batch_number ?? (id != null ? `#${id}` : '—')
    const locLabel = (id?: number | null) => {
      if (id == null) return '—'
      const l = maps.loc.get(id)
      if (!l) return `Location ${id}`
      const w = maps.wh.get(l.warehouse_id)
      return `${w?.warehouse_name ?? 'Warehouse'} · ${l.zone_type} L${l.location_id}`
    }
    const pkgOfBatch = (id?: number | null) => {
      const b = batchOf(id)
      return b?.medicine_id != null ? maps.pkgByMed.get(b.medicine_id) : undefined
    }
    return { orgName, userName, medOf, batchOf, medName, batchNo, locLabel, pkgOfBatch }
  }, [maps])

  return { ...maps, ...helpers, isLoading: q.isLoading, error: q.error }
}

export type Lookups = ReturnType<typeof useLookups>
