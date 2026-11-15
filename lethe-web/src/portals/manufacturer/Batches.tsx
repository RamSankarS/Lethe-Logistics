import { useMemo, useState } from 'react'
import { FlaskConical, Plus } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, FormGrid, Input, Select } from '@/components/ui/Form'
import { Drawer, Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { BatchPedigree } from '@/components/domain/BatchPedigree'
import { ExpiryBadge, MedicineCell, StorageBand } from '@/components/domain/Cells'
import { BATCH_STATUS } from '@/lib/domain'
import { date, num, todayISO } from '@/lib/format'
import type { Batch, BatchStatus } from '@/lib/types'
import { BatchActions, useMyBatches } from './shared'

type Filter = 'all' | BatchStatus

function suggestBatchNumber(brand: string, existing: Batch[]) {
  const prefix = brand.replace(/[^A-Za-z]/g, '').slice(0, 3).toUpperCase() || 'MED'
  const year = new Date().getFullYear()
  const base = `B-${prefix}-${year}-`
  const used = new Set(existing.map((b) => b.batch_number))
  let n = existing.filter((b) => b.batch_number.startsWith(base)).length + 1
  while (used.has(`${base}${String(n).padStart(2, '0')}`)) n++
  return `${base}${String(n).padStart(2, '0')}`
}

function RegisterBatch({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const { data } = useTables(['medicines', 'batches'] as const)
  const { run, busy } = useRunner()
  const active = data.medicines.filter((m) => m.is_active)
  const [medicineId, setMedicineId] = useState('')
  const [batchNo, setBatchNo] = useState('')
  const [qty, setQty] = useState('10000')
  const [mfg, setMfg] = useState(todayISO())
  const [exp, setExp] = useState(todayISO(730))

  const med = active.find((m) => String(m.medicine_id) === medicineId)
  const dup = data.batches.some((b) => b.batch_number.toLowerCase() === batchNo.trim().toLowerCase())
  const datesOk = exp > mfg
  const qtyOk = Number(qty) > 0
  const valid = med && batchNo.trim() && !dup && datesOk && qtyOk

  const reset = () => {
    setMedicineId('')
    setBatchNo('')
    setQty('10000')
    setMfg(todayISO())
    setExp(todayISO(730))
  }

  const submit = async () => {
    if (!valid || !med) return
    const r = await run(
      'register',
      async () => {
        const { error } = await db('product').from('batch_master').insert({
          medicine_id: med.medicine_id,
          manufacturer_id: profile.org!.org_id,
          registered_by_user_id: profile.user_id,
          batch_number: batchNo.trim(),
          mfg_date: mfg,
          expiry_date: exp,
          quantity_produced: Number(qty),
          status: 'Pending',
        })
        if (error) throw error
      },
      { success: `Batch ${batchNo.trim()} registered`, description: 'Status: Pending. Send it to QC when production is complete.' },
    )
    if (r.ok) {
      reset()
      onClose()
    }
  }

  return (
    <Modal
      open={open}
      onClose={onClose}
      icon={Plus}
      title="Register a new batch"
      description="Creates the batch in Pending state. The database logs BATCH_CREATED to the audit ledger."
      size="lg"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Plus} disabled={!valid} loading={busy === 'register'} onClick={submit}>
            Register batch
          </Button>
        </>
      }
    >
      <FormGrid>
        <Field label="Medicine" required className="sm:col-span-2">
          <Select
            value={medicineId}
            onChange={(e) => {
              setMedicineId(e.target.value)
              const m = active.find((x) => String(x.medicine_id) === e.target.value)
              if (m) setBatchNo(suggestBatchNumber(m.brand_name, data.batches))
            }}
          >
            <option value="">Choose a medicine…</option>
            {active.map((m) => (
              <option key={m.medicine_id} value={m.medicine_id}>
                {m.brand_name} ({m.generic_name}) · {m.category}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Batch number" required error={dup ? 'This batch number already exists.' : undefined} hint="Suggested from the brand name; must be unique.">
          <Input value={batchNo} onChange={(e) => setBatchNo(e.target.value)} placeholder="B-AMX-2026-03" className="font-mono" />
        </Field>
        <Field label="Quantity produced" required error={!qtyOk ? 'Must be greater than zero.' : undefined}>
          <Input type="number" min={1} step={100} value={qty} onChange={(e) => setQty(e.target.value)} />
        </Field>
        <Field label="Manufacturing date" required>
          <Input type="date" value={mfg} onChange={(e) => setMfg(e.target.value)} />
        </Field>
        <Field label="Expiry date" required error={!datesOk ? 'Expiry must be after the manufacturing date.' : undefined}>
          <Input type="date" value={exp} onChange={(e) => setExp(e.target.value)} />
        </Field>
      </FormGrid>
      {med && (
        <Callout tone="info" className="mt-5" title="Storage requirement">
          <StorageBand pkg={L.pkgByMed.get(med.medicine_id)} />. Warehouses will only accept this batch into zones that match.
        </Callout>
      )}
    </Modal>
  )
}

export function Batches() {
  const L = useLookups()
  const { batches, stock, isLoading } = useMyBatches()
  const [filter, setFilter] = useState<Filter>('all')
  const [registering, setRegistering] = useState(false)
  const [openId, setOpenId] = useState<number | null>(null)

  const counts = useMemo(() => {
    const c: Record<string, number> = { all: batches.length }
    for (const b of batches) c[b.status] = (c[b.status] ?? 0) + 1
    return c
  }, [batches])

  const rows = filter === 'all' ? batches : batches.filter((b) => b.status === filter)
  const open = openId != null ? L.batchOf(openId) : undefined

  const columns: Column<Batch>[] = [
    { key: 'batch', header: 'Batch', sort: (b) => b.batch_number, cell: (b) => <Code>{b.batch_number}</Code> },
    { key: 'medicine', header: 'Medicine', sort: (b) => L.medOf(b)?.brand_name ?? '', cell: (b) => <MedicineCell med={L.medOf(b)} /> },
    { key: 'status', header: 'Status', sort: (b) => b.status, cell: (b) => <StatusBadge value={b.status} meta={BATCH_STATUS} /> },
    { key: 'qty', header: 'Produced', align: 'right', sort: (b) => Number(b.quantity_produced), cell: (b) => num(b.quantity_produced) },
    { key: 'stock', header: 'In network', align: 'right', sort: (b) => stock.get(b.batch_id) ?? 0, cell: (b) => <span className="text-ink-2">{num(stock.get(b.batch_id) ?? 0)}</span>, hideBelow: 'md' },
    { key: 'mfg', header: 'Mfg date', sort: (b) => b.mfg_date, cell: (b) => <span className="text-ink-2 tabular">{date(b.mfg_date)}</span>, hideBelow: 'lg' },
    { key: 'exp', header: 'Expiry', sort: (b) => b.expiry_date, cell: (b) => <ExpiryBadge value={b.expiry_date} /> },
    { key: 'actions', header: 'QC workflow', cell: (b) => <BatchActions batch={b} size="xs" /> },
  ]

  return (
    <>
      <PageHeader
        actions={
          <Button variant="primary" icon={Plus} onClick={() => setRegistering(true)}>
            Register batch
          </Button>
        }
      />

      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <Segmented<Filter>
          value={filter}
          onChange={setFilter}
          options={[
            { value: 'all', label: 'All', count: counts.all ?? 0 },
            { value: 'Pending', label: 'Pending', count: counts.Pending ?? 0 },
            { value: 'Quality-Check', label: 'Quality check', count: counts['Quality-Check'] ?? 0 },
            { value: 'Released', label: 'Released', count: counts.Released ?? 0 },
            { value: 'Rejected', label: 'Rejected', count: counts.Rejected ?? 0 },
            { value: 'Recalled', label: 'Recalled', count: counts.Recalled ?? 0 },
          ]}
        />
        <p className="flex items-center gap-1.5 text-[12.5px] text-ink-2">
          <FlaskConical className="size-4 text-accent-text" /> Pending → Quality check → Released. Rejected and recalled batches are locked by the database.
        </p>
      </div>

      <DataTable
        rows={rows}
        columns={columns}
        rowKey={(b) => b.batch_id}
        loading={isLoading}
        searchText={(b) => `${b.batch_number} ${L.medOf(b)?.brand_name ?? ''} ${L.medOf(b)?.generic_name ?? ''}`}
        searchPlaceholder="Search batch or medicine…"
        onRowClick={(b) => setOpenId(b.batch_id)}
        initialSort={{ key: 'batch', dir: 'asc' }}
        pageSize={12}
        exportName="lethe-batches"
        exportRow={(b) => ({
          batch_number: b.batch_number,
          medicine: L.medOf(b)?.brand_name,
          status: b.status,
          quantity_produced: b.quantity_produced,
          network_stock: stock.get(b.batch_id) ?? 0,
          mfg_date: b.mfg_date,
          expiry_date: b.expiry_date,
        })}
      />

      <RegisterBatch open={registering} onClose={() => setRegistering(false)} />

      <Drawer open={!!open} onClose={() => setOpenId(null)} title={open ? `Batch ${open.batch_number}` : ''} subtitle="Batch pedigree" actions={open && <BatchActions batch={open} />}>
        {open && <BatchPedigree batchId={open.batch_id} />}
      </Drawer>
    </>
  )
}
