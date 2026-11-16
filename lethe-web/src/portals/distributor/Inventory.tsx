import { useMemo, useState } from 'react'
import { ArrowRightLeft, PackageMinus, PackagePlus, Snowflake, Sun } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input, Select } from '@/components/ui/Form'
import { Drawer, Modal } from '@/components/ui/Modal'
import { Meter } from '@/components/ui/Progress'
import { Segmented } from '@/components/ui/Segmented'
import { BatchPedigree } from '@/components/domain/BatchPedigree'
import { ExpiryBadge, MedicineCell, StorageBand } from '@/components/domain/Cells'
import { BATCH_STATUS, locationFits } from '@/lib/domain'
import { dateTime, num, plural, relative, temp } from '@/lib/format'
import { cn } from '@/lib/cn'
import type { InventoryRow, StockMovement } from '@/lib/types'
import { useWarehouseModel, type LocationView } from './model'

type MoveKind = 'Inbound' | 'Internal' | 'Outbound'

const OUT_REASONS = ['Expired stock write-off', 'Damaged in warehouse', 'Transfer to external facility', 'Sample / QC destructive test']

function MoveStock({ kind, row, onClose }: { kind: MoveKind | null; row?: InventoryRow; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const m = useWarehouseModel()
  const { data } = useTables(['batches'] as const)
  const { run, busy } = useRunner()
  const [batchId, setBatchId] = useState('')
  const [dest, setDest] = useState('')
  const [qty, setQty] = useState('')
  const [reason, setReason] = useState(OUT_REASONS[0])

  if (!kind) return null
  const bId = kind === 'Inbound' ? Number(batchId) || undefined : row?.batch_id
  const pkg = L.pkgOfBatch(bId)
  const available = row?.available_quantity ?? 0
  const destView = m.locations.find((l) => String(l.loc.location_id) === dest)
  const room = destView ? destView.loc.max_capacity - destView.stock : Infinity
  const n = Number(qty)
  const qtyOk = n > 0 && (kind === 'Inbound' || n <= available) && (kind === 'Outbound' || n <= room)
  const valid = qtyOk && (kind === 'Outbound' || dest) && bId != null

  const receivable = data.batches.filter((b) => b.status !== 'Rejected' && b.status !== 'Recalled')
  const destinations = m.locations.filter((l) => l.loc.location_id !== row?.location_id)

  const submit = async () => {
    if (bId == null) return
    const r = await run(
      'move',
      async () => {
        const { error } = await db('warehouse')
          .from('stock_movement_history')
          .insert({
            batch_id: bId,
            source_location_id: kind === 'Inbound' ? null : row!.location_id,
            destination_location_id: kind === 'Outbound' ? null : Number(dest),
            user_id: profile.user_id,
            quantity_moved: n,
            movement_type: kind,
          })
        if (error) throw error
        await logEvent(profile.user_id, kind === 'Inbound' ? 'STOCK_RECEIVED' : kind === 'Internal' ? 'STOCK_TRANSFERRED' : 'STOCK_REMOVED', 'WAREHOUSE_OPS', {
          batch_id: bId,
          batch_number: L.batchNo(bId),
          quantity: n,
          from: kind === 'Inbound' ? null : L.locLabel(row!.location_id),
          to: kind === 'Outbound' ? null : L.locLabel(Number(dest)),
          reason: kind === 'Outbound' ? reason : undefined,
          severity: kind === 'Outbound' ? 'MEDIUM' : 'LOW',
        })
      },
      { success: kind === 'Inbound' ? 'Stock received' : kind === 'Internal' ? 'Stock transferred' : 'Stock removed', description: 'Inventory updated by the tr_sync_inventory_on_movement trigger.' },
    )
    if (r.ok) {
      setBatchId('')
      setDest('')
      setQty('')
      onClose()
    }
  }

  const title = kind === 'Inbound' ? 'Receive stock' : kind === 'Internal' ? 'Transfer between bins' : 'Remove stock'
  const icon = kind === 'Inbound' ? PackagePlus : kind === 'Internal' ? ArrowRightLeft : PackageMinus

  return (
    <Modal
      open
      onClose={onClose}
      icon={icon}
      title={title}
      description={kind === 'Inbound' ? 'Book a delivery from the manufacturer into a storage location.' : `${L.batchNo(row?.batch_id)} · ${num(available)} units at ${L.locLabel(row?.location_id)}`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant={kind === 'Outbound' ? 'danger' : 'primary'} icon={icon} disabled={!valid} loading={busy === 'move'} onClick={submit}>
            {title}
          </Button>
        </>
      }
    >
      <div className="dist-modal-stack">
        {kind === 'Inbound' && (
          <Field label="Batch" required>
            <Select value={batchId} onChange={(e) => setBatchId(e.target.value)}>
              <option value="">Choose a batch…</option>
              {receivable.map((b) => (
                <option key={b.batch_id} value={b.batch_id}>
                  {b.batch_number} · {L.medOf(b)?.brand_name} · {b.status}
                </option>
              ))}
            </Select>
          </Field>
        )}
        {bId != null && (
          <Callout tone="info" icon={pkg && Number(pkg.max_temp_celsius) <= 8 ? Snowflake : Sun}>
            Storage requirement: <StorageBand pkg={pkg} />
          </Callout>
        )}
        {kind !== 'Outbound' && (
          <Field label="Destination" required hint="Locations that cannot meet the medicine's temperature or humidity band are disabled. The database would reject them anyway.">
            <Select value={dest} onChange={(e) => setDest(e.target.value)}>
              <option value="">Choose a location…</option>
              {destinations.map((l) => {
                const fit = locationFits(l.loc, pkg)
                return (
                  <option key={l.loc.location_id} value={l.loc.location_id} disabled={!fit.ok}>
                    {L.locLabel(l.loc.location_id)} · {num(l.stock)}/{num(l.loc.max_capacity)}
                    {fit.ok ? '' : ` · ✕ ${fit.reason}`}
                  </option>
                )
              })}
            </Select>
          </Field>
        )}
        {kind === 'Outbound' && (
          <Field label="Reason">
            <Select value={reason} onChange={(e) => setReason(e.target.value)}>
              {OUT_REASONS.map((r) => (
                <option key={r}>{r}</option>
              ))}
            </Select>
          </Field>
        )}
        <Field
          label="Quantity"
          required
          error={qty && !qtyOk ? (kind !== 'Inbound' && n > available ? `Only ${num(available)} units available.` : n > room ? `Only ${num(room)} units of space left at the destination.` : 'Enter a positive quantity.') : undefined}
          hint={kind !== 'Inbound' ? `Up to ${num(available)} units.` : destView ? `${num(room)} units of space left at the destination.` : undefined}
        >
          <Input type="number" min={1} value={qty} onChange={(e) => setQty(e.target.value)} />
        </Field>
      </div>
    </Modal>
  )
}

function LocationCard({ v, selected, onClick }: { v: LocationView; selected: boolean; onClick: () => void }) {
  const cold = v.loc.zone_type === 'Cold Storage'
  const breach = v.state === 'high' || v.state === 'low'
  return (
    <button
      onClick={onClick}
      className={cn('dist-loc-box', selected && 'dist-loc-selected', !v.loc.is_active && 'dist-faded')}
    >
      <div className="dist-loc-top">
        <span className="dist-loc-name">
          {cold ? <Snowflake className="dist-zone-icon dist-icon-cold" /> : <Sun className="dist-zone-icon dist-icon-warm" />}L{v.loc.location_id} · {v.loc.zone_type}
        </span>
        {!v.loc.is_active ? <Badge>Inactive</Badge> : breach ? <Badge tone="critical" dot>Breach</Badge> : v.state === 'ok' ? <Badge tone="good" dot>In range</Badge> : <Badge>No sensor</Badge>}
      </div>
      <p className="dist-loc-target">
        Target {v.loc.target_min_temp}–{v.loc.target_max_temp}°C · ≤{v.loc.target_humidity_limit}% RH
        {v.reading && <> · now {temp(v.reading.temperature_celsius)}</>}
      </p>
      <div className="dist-loc-count">
        <span>{plural(v.items.length, 'batch', 'batches')}</span>
        <span>
          {num(v.stock)} / {num(v.loc.max_capacity)}
        </span>
      </div>
      <Meter value={v.stock} max={v.loc.max_capacity} />
    </button>
  )
}

export function Inventory() {
  const L = useLookups()
  const m = useWarehouseModel()
  const t = useTables(['movements'] as const)
  const [wh, setWh] = useState<string>('all')
  const [locId, setLocId] = useState<number | null>(null)
  const [view, setView] = useState<'stock' | 'history'>('stock')
  const [move, setMove] = useState<{ kind: MoveKind; row?: InventoryRow } | null>(null)
  const [pedigree, setPedigree] = useState<number | null>(null)

  const locs = m.locations.filter((l) => wh === 'all' || String(l.loc.warehouse_id) === wh)
  const rows = useMemo(
    () => locs.filter((l) => locId == null || l.loc.location_id === locId).flatMap((l) => l.items),
    [locs, locId],
  )
  const movements = t.data.movements.filter((mv) => {
    const inScope = (id: number | null) => id != null && locs.some((l) => l.loc.location_id === id)
    return wh === 'all' || inScope(mv.source_location_id) || inScope(mv.destination_location_id)
  })

  const cols: Column<InventoryRow>[] = [
    { key: 'batch', header: 'Batch', sort: (i) => L.batchNo(i.batch_id), cell: (i) => <Code>{L.batchNo(i.batch_id)}</Code> },
    { key: 'med', header: 'Medicine', sort: (i) => L.medName(i.batch_id), cell: (i) => <MedicineCell med={L.medOf(L.batchOf(i.batch_id))} /> },
    { key: 'loc', header: 'Location', sort: (i) => L.locLabel(i.location_id), cell: (i) => <span className="dist-cell-grey">{L.locLabel(i.location_id)}</span>, hideBelow: 'md' },
    { key: 'qty', header: 'On hand', align: 'right', sort: (i) => i.available_quantity, cell: (i) => <span className="dist-bold">{num(i.available_quantity)}</span> },
    { key: 'status', header: 'Batch status', sort: (i) => L.batchOf(i.batch_id)?.status ?? '', cell: (i) => <StatusBadge value={L.batchOf(i.batch_id)?.status} meta={BATCH_STATUS} /> },
    { key: 'exp', header: 'Expiry', sort: (i) => L.batchOf(i.batch_id)?.expiry_date ?? '', cell: (i) => (L.batchOf(i.batch_id) ? <ExpiryBadge value={L.batchOf(i.batch_id)!.expiry_date} compact /> : '—'), hideBelow: 'lg' },
    { key: 'verified', header: 'Last verified', sort: (i) => i.last_update, cell: (i) => <span className="dist-tiny-grey">{L.userName(i.last_verified_by)} · {relative(i.last_update)}</span>, hideBelow: 'xl' },
    {
      key: 'act',
      header: '',
      cell: (i) => (
        <div className="dist-action-btns dist-btns-right" onClick={(e) => e.stopPropagation()}>
          <Button size="xs" variant="ghost" icon={ArrowRightLeft} onClick={() => setMove({ kind: 'Internal', row: i })}>
            Move
          </Button>
          <Button size="xs" variant="ghost" icon={PackageMinus} onClick={() => setMove({ kind: 'Outbound', row: i })} className="dist-red-link">
            Remove
          </Button>
        </div>
      ),
    },
  ]

  const histCols: Column<StockMovement>[] = [
    { key: 'type', header: 'Type', sort: (mv) => mv.movement_type, cell: (mv) => <Badge tone={mv.movement_type === 'Inbound' ? 'good' : mv.movement_type === 'Outbound' ? 'serious' : 'info'} icon={mv.movement_type === 'Inbound' ? PackagePlus : mv.movement_type === 'Outbound' ? PackageMinus : ArrowRightLeft}>{mv.movement_type}</Badge> },
    { key: 'batch', header: 'Batch', sort: (mv) => L.batchNo(mv.batch_id), cell: (mv) => <Code>{L.batchNo(mv.batch_id)}</Code> },
    { key: 'from', header: 'From', cell: (mv) => <span className="dist-cell-grey">{mv.source_location_id ? L.locLabel(mv.source_location_id) : 'Supplier'}</span>, hideBelow: 'md' },
    { key: 'to', header: 'To', cell: (mv) => <span className="dist-cell-grey">{mv.destination_location_id ? L.locLabel(mv.destination_location_id) : 'Out of network'}</span>, hideBelow: 'md' },
    { key: 'qty', header: 'Units', align: 'right', sort: (mv) => mv.quantity_moved, cell: (mv) => num(mv.quantity_moved) },
    { key: 'by', header: 'By', cell: (mv) => <span className="dist-cell-grey">{L.userName(mv.user_id)}</span>, hideBelow: 'lg' },
    { key: 'at', header: 'When', sort: (mv) => mv.moved_at, cell: (mv) => <span className="dist-cell-grey">{dateTime(mv.moved_at)}</span> },
  ]

  return (
    <>
      <PageHeader
        actions={
          <Button variant="primary" icon={PackagePlus} onClick={() => setMove({ kind: 'Inbound' })}>
            Receive stock
          </Button>
        }
      />

      <div className="dist-filter-row">
        <Segmented
          value={wh}
          onChange={(v) => {
            setWh(v)
            setLocId(null)
          }}
          options={[{ value: 'all', label: 'All facilities' }, ...m.warehouses.map((w) => ({ value: String(w.w.warehouse_id), label: w.w.city, count: w.locs.length }))]}
        />
      </div>

      <div className="dist-loc-grid grid sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4">
        {locs.map((v) => (
          <LocationCard key={v.loc.location_id} v={v} selected={locId === v.loc.location_id} onClick={() => setLocId(locId === v.loc.location_id ? null : v.loc.location_id)} />
        ))}
      </div>

      <div className="dist-table-top">
        <Segmented
          value={view}
          onChange={setView}
          options={[
            { value: 'stock', label: 'Stock on hand', count: rows.length },
            { value: 'history', label: 'Movement history', count: movements.length },
          ]}
        />
        {locId != null && (
          <Button size="sm" variant="ghost" onClick={() => setLocId(null)}>
            Showing L{locId} only · clear filter
          </Button>
        )}
      </div>

      {view === 'stock' ? (
        <DataTable
          rows={rows}
          columns={cols}
          rowKey={(i) => i.inventory_id}
          loading={m.isLoading}
          searchText={(i) => `${L.batchNo(i.batch_id)} ${L.medName(i.batch_id)} ${L.locLabel(i.location_id)}`}
          onRowClick={(i) => setPedigree(i.batch_id)}
          initialSort={{ key: 'qty', dir: 'desc' }}
          emptyTitle="No stock here"
          exportName="lethe-inventory"
          exportRow={(i) => ({ batch: L.batchNo(i.batch_id), medicine: L.medName(i.batch_id), location: L.locLabel(i.location_id), on_hand: i.available_quantity, status: L.batchOf(i.batch_id)?.status, last_update: i.last_update })}
        />
      ) : (
        <DataTable rows={movements} columns={histCols} rowKey={(mv) => mv.movement_id} loading={t.isLoading} searchText={(mv) => `${L.batchNo(mv.batch_id)} ${mv.movement_type}`} initialSort={{ key: 'at', dir: 'desc' }} pageSize={15} />
      )}

      <MoveStock kind={move?.kind ?? null} row={move?.row} onClose={() => setMove(null)} />
      <Drawer open={pedigree != null} onClose={() => setPedigree(null)} title={pedigree != null ? `Batch ${L.batchNo(pedigree)}` : ''} subtitle="Batch pedigree">
        {pedigree != null && <BatchPedigree batchId={pedigree} />}
      </Drawer>
    </>
  )
}
