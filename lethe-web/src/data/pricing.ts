import { useMemo } from 'react'
import { useTables } from './hooks'
import type { MedicineCategory } from '@/lib/types'

/**
 * The schema has no price-list table: prices live only on order lines.
 * When a medicine has never been sold, these demo list prices (₹ per unit) are used.
 */
export const CATEGORY_LIST_PRICE: Record<MedicineCategory, number> = {
  Antibiotic: 120,
  Analgesic: 25,
  Vaccine: 450,
  'Anti-Diabetic': 60,
  Statin: 90,
  Antacid: 45,
  Antihypertensive: 55,
  Hormone: 380,
  Antihistamine: 30,
  NSAID: 40,
  Immunomodulatory: 300,
}

/**
 * Reference unit price for a batch: average of its own order lines, else the
 * medicine's historical average, else the category list price.
 */
export function useReferencePrice() {
  const { data } = useTables(['orderItems', 'batches', 'medicines'] as const)
  return useMemo(() => {
    const avg = (xs?: number[]) => (xs?.length ? xs.reduce((a, b) => a + b, 0) / xs.length : undefined)
    const round = (n: number) => Math.round(n * 100) / 100
    const byBatch = new Map<number, number[]>()
    const medOfBatch = new Map(data.batches.map((b) => [b.batch_id, b.medicine_id]))
    const byMed = new Map<number, number[]>()
    for (const i of data.orderItems) {
      byBatch.set(i.batch_id, [...(byBatch.get(i.batch_id) ?? []), Number(i.unit_price)])
      const m = medOfBatch.get(i.batch_id)
      if (m != null) byMed.set(m, [...(byMed.get(m) ?? []), Number(i.unit_price)])
    }
    const category = new Map(data.medicines.map((m) => [m.medicine_id, m.category]))
    const forMedicine = (medicineId: number | null | undefined) => {
      if (medicineId == null) return 100
      const hist = avg(byMed.get(medicineId))
      if (hist) return round(hist)
      const cat = category.get(medicineId)
      return cat ? CATEGORY_LIST_PRICE[cat] : 100
    }
    const forBatch = (batchId: number) => {
      const own = avg(byBatch.get(batchId))
      return own ? round(own) : forMedicine(medOfBatch.get(batchId))
    }
    return Object.assign(forBatch, { forMedicine })
  }, [data.orderItems, data.batches, data.medicines])
}
