import { useMemo, useState } from 'react'
import { FlaskConical, Lock, PackageOpen, Pill, Plus, Snowflake, Thermometer } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card } from '@/components/ui/Card'
import { Callout, EmptyState, Spinner } from '@/components/ui/Feedback'
import { Field, FormGrid, Input, Select, Switch } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { MEDICINE_CATEGORIES, isColdChain } from '@/lib/domain'
import { compact, num } from '@/lib/format'
import type { MedicineCategory } from '@/lib/types'

const EMPTY_FORM = {
  brand: '', generic: '', category: 'Analgesic' as MedicineCategory,
  ingredient: '', strength: '', form: 'Tablet',
  minT: '15', maxT: '25', humidity: '60', fragility: '2',
  purity: '99', dissolution: '30 mins', ph: '7', certs: 'GMP-Certified',
}

function AddMedicine({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['medicines'] as const)
  const { run, busy } = useRunner()
  const [f, setF] = useState(EMPTY_FORM)
  const set = (k: keyof typeof EMPTY_FORM) => (e: { target: { value: string } }) => setF((p) => ({ ...p, [k]: e.target.value }))

  const dup = data.medicines.some((m) => m.brand_name.toLowerCase() === f.brand.trim().toLowerCase())
  const tempOk = Number(f.minT) < Number(f.maxT)
  const valid =
    f.brand.trim() && f.generic.trim() && !dup && f.ingredient.trim() && f.strength.trim() && f.form.trim() && tempOk &&
    Number(f.humidity) >= 0 && Number(f.humidity) <= 100 && Number(f.fragility) >= 1 && Number(f.fragility) <= 10 &&
    Number(f.purity) >= 0 && Number(f.purity) <= 100 && Number(f.ph) >= 0 && Number(f.ph) <= 14 && f.dissolution.trim() && f.certs.trim()

  const submit = async () => {
    const r = await run(
      'add-medicine',
      async () => {
        const { data: med, error } = await db('product')
          .from('medicines')
          .insert({ brand_name: f.brand.trim(), generic_name: f.generic.trim(), category: f.category, is_active: true })
          .select('medicine_id')
          .single()
        if (error) throw error
        const id = (med as { medicine_id: number }).medicine_id
        try {
          const steps = await Promise.all([
            db('product').from('chemical_compositions').insert({ medicine_id: id, active_ingredient: f.ingredient.trim(), strength: f.strength.trim(), dosage_form: f.form.trim() }),
            db('product').from('packaging_standards').insert({ medicine_id: id, min_temp_celsius: Number(f.minT), max_temp_celsius: Number(f.maxT), humidity_limit: Number(f.humidity), fragility_index: Number(f.fragility) }),
            db('product').from('quality_check_specs').insert({ medicine_id: id, purity_threshold: Number(f.purity), dissolution_rate: f.dissolution.trim(), ph_balance_req: Number(f.ph), required_certs: f.certs.trim() }),
          ])
          const failed = steps.find((s) => s.error)
          if (failed) throw failed.error
        } catch (e) {
          // Roll back: children cascade on delete of the medicine.
          await db('product').from('medicines').delete().eq('medicine_id', id)
          throw e
        }
        await logEvent(profile.user_id, 'MEDICINE_REGISTERED', 'PRODUCT_INTELLIGENCE', { medicine_id: id, brand_name: f.brand.trim(), category: f.category, severity: 'LOW' })
      },
      { success: `${f.brand.trim()} added to the catalog` },
    )
    if (r.ok) {
      setF(EMPTY_FORM)
      onClose()
    }
  }

  return (
    <Modal
      open={open}
      onClose={onClose}
      size="xl"
      icon={Pill}
      title="Add a medicine to the catalog"
      description="Master data, chemical composition, storage standard and QC specification are saved together."
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Plus} disabled={!valid} loading={busy === 'add-medicine'} onClick={submit}>
            Add medicine
          </Button>
        </>
      }
    >
      <div className="space-y-6">
        <section>
          <p className="mb-3 text-[12px] font-semibold tracking-wide text-muted uppercase">Master data</p>
          <FormGrid className="sm:grid-cols-3">
            <Field label="Brand name" required error={dup ? 'Brand name already exists.' : undefined}>
              <Input value={f.brand} onChange={set('brand')} placeholder="Cardio-Safe 10" />
            </Field>
            <Field label="Generic name" required>
              <Input value={f.generic} onChange={set('generic')} placeholder="Rosuvastatin" />
            </Field>
            <Field label="Category" required>
              <Select value={f.category} onChange={set('category')}>
                {MEDICINE_CATEGORIES.map((c) => (
                  <option key={c}>{c}</option>
                ))}
              </Select>
            </Field>
          </FormGrid>
        </section>
        <section>
          <p className="mb-3 text-[12px] font-semibold tracking-wide text-muted uppercase">Chemical composition</p>
          <FormGrid className="sm:grid-cols-3">
            <Field label="Active ingredient" required>
              <Input value={f.ingredient} onChange={set('ingredient')} placeholder="Rosuvastatin Calcium" />
            </Field>
            <Field label="Strength" required>
              <Input value={f.strength} onChange={set('strength')} placeholder="10mg" />
            </Field>
            <Field label="Dosage form" required>
              <Input value={f.form} onChange={set('form')} placeholder="Tablet" />
            </Field>
          </FormGrid>
        </section>
        <section>
          <p className="mb-3 text-[12px] font-semibold tracking-wide text-muted uppercase">Storage standard</p>
          <FormGrid className="sm:grid-cols-4">
            <Field label="Min °C" required>
              <Input type="number" step="0.5" value={f.minT} onChange={set('minT')} />
            </Field>
            <Field label="Max °C" required error={!tempOk ? 'Must exceed min.' : undefined}>
              <Input type="number" step="0.5" value={f.maxT} onChange={set('maxT')} />
            </Field>
            <Field label="Humidity limit %" required>
              <Input type="number" min={0} max={100} value={f.humidity} onChange={set('humidity')} />
            </Field>
            <Field label="Fragility (1–10)" required>
              <Input type="number" min={1} max={10} value={f.fragility} onChange={set('fragility')} />
            </Field>
          </FormGrid>
          {Number(f.maxT) <= 8 && (
            <Callout tone="info" icon={Snowflake} className="mt-3">
              Cold-chain product: it can only be stored in Cold Storage zones and should ship on Reefer vehicles.
            </Callout>
          )}
        </section>
        <section>
          <p className="mb-3 text-[12px] font-semibold tracking-wide text-muted uppercase">Quality specification</p>
          <FormGrid className="sm:grid-cols-4">
            <Field label="Purity threshold %" required>
              <Input type="number" step="0.01" min={0} max={100} value={f.purity} onChange={set('purity')} />
            </Field>
            <Field label="Dissolution" required>
              <Input value={f.dissolution} onChange={set('dissolution')} />
            </Field>
            <Field label="pH requirement" required>
              <Input type="number" step="0.05" min={0} max={14} value={f.ph} onChange={set('ph')} />
            </Field>
            <Field label="Required certificates" required>
              <Input value={f.certs} onChange={set('certs')} />
            </Field>
          </FormGrid>
        </section>
      </div>
    </Modal>
  )
}

export function Catalog() {
  const profile = useProfile()
  const t = useTables(['medicines', 'compositions', 'packaging', 'specs', 'batches'] as const)
  const { run, busy } = useRunner()
  const [adding, setAdding] = useState(false)
  const [cat, setCat] = useState<'all' | 'active' | 'inactive' | 'cold'>('all')

  const cards = useMemo(() => {
    const d = t.data
    return d.medicines.map((m) => {
      const batches = d.batches.filter((b) => b.medicine_id === m.medicine_id)
      return {
        m,
        comp: d.compositions.find((c) => c.medicine_id === m.medicine_id),
        pkg: d.packaging.find((p) => p.medicine_id === m.medicine_id),
        spec: d.specs.find((s) => s.medicine_id === m.medicine_id),
        batchCount: batches.length,
        units: batches.reduce((s, b) => s + Number(b.quantity_produced), 0),
      }
    })
  }, [t.data])

  const shown = cards.filter((c) => (cat === 'active' ? c.m.is_active : cat === 'inactive' ? !c.m.is_active : cat === 'cold' ? isColdChain(c.pkg) : true))

  const toggle = (medicineId: number, brand: string, next: boolean) =>
    run(
      `toggle-${medicineId}`,
      async () => {
        await mustChange(db('product').from('medicines').update({ is_active: next }).eq('medicine_id', medicineId).select('medicine_id'))
        await logEvent(profile.user_id, next ? 'MEDICINE_ACTIVATED' : 'MEDICINE_DISCONTINUED', 'PRODUCT_INTELLIGENCE', { medicine_id: medicineId, brand_name: brand, severity: next ? 'LOW' : 'MEDIUM' })
      },
      { success: `${brand} ${next ? 'reactivated' : 'discontinued'}` },
    )

  if (t.isLoading) return <Spinner />

  return (
    <>
      <PageHeader
        actions={
          <Button variant="primary" icon={Plus} onClick={() => setAdding(true)}>
            Add medicine
          </Button>
        }
      />
      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <Segmented
          value={cat}
          onChange={setCat}
          options={[
            { value: 'all', label: 'All', count: cards.length },
            { value: 'active', label: 'Active', count: cards.filter((c) => c.m.is_active).length },
            { value: 'inactive', label: 'Discontinued', count: cards.filter((c) => !c.m.is_active).length },
            { value: 'cold', label: 'Cold chain', count: cards.filter((c) => isColdChain(c.pkg)).length },
          ]}
        />
        <p className="flex items-center gap-1.5 text-[12.5px] text-ink-2">
          <Lock className="size-3.5" /> QC specifications are locked after registration. Changes would be flagged as spec tampering.
        </p>
      </div>

      {shown.length === 0 ? (
        <EmptyState icon={PackageOpen} title="No medicines match" />
      ) : (
        <div className="grid gap-4 md:grid-cols-2 2xl:grid-cols-3">
          {shown.map(({ m, comp, pkg, spec, batchCount, units }) => (
            <Card key={m.medicine_id} className={m.is_active ? '' : 'opacity-70'}>
              <div className="flex items-start justify-between gap-3 px-5 pt-4">
                <div className="min-w-0">
                  <div className="flex flex-wrap items-center gap-2">
                    <h3 className="truncate text-[15px] font-semibold text-ink">{m.brand_name}</h3>
                    {isColdChain(pkg) && (
                      <Badge tone="info" icon={Snowflake}>
                        Cold chain
                      </Badge>
                    )}
                  </div>
                  <p className="text-[13px] text-ink-2">
                    {m.generic_name} · {m.category}
                  </p>
                </div>
                <div className="flex items-center gap-2 pt-0.5">
                  <span className="text-[11.5px] text-muted">{m.is_active ? 'Active' : 'Off'}</span>
                  <Switch checked={m.is_active} disabled={busy === `toggle-${m.medicine_id}`} onChange={(v) => void toggle(m.medicine_id, m.brand_name, v)} label={`Toggle ${m.brand_name}`} />
                </div>
              </div>
              <div className="mt-3 grid grid-cols-1 gap-2 px-5 pb-4 text-[12.5px]">
                <div className="flex items-start gap-2 rounded-lg bg-surface-2 px-3 py-2">
                  <Pill className="mt-0.5 size-3.5 shrink-0 text-accent-text" />
                  <span className="text-ink-2">{comp ? `${comp.active_ingredient} · ${comp.strength} · ${comp.dosage_form}` : 'No composition on file'}</span>
                </div>
                <div className="flex items-start gap-2 rounded-lg bg-surface-2 px-3 py-2">
                  <Thermometer className="mt-0.5 size-3.5 shrink-0 text-accent-text" />
                  <span className="text-ink-2 tabular">
                    {pkg ? `${pkg.min_temp_celsius}–${pkg.max_temp_celsius}°C · humidity ≤ ${pkg.humidity_limit}% · fragility ${pkg.fragility_index}/10` : 'No storage standard'}
                  </span>
                </div>
                <div className="flex items-start gap-2 rounded-lg bg-surface-2 px-3 py-2">
                  <FlaskConical className="mt-0.5 size-3.5 shrink-0 text-accent-text" />
                  <span className="text-ink-2">{spec ? `Purity ≥ ${spec.purity_threshold}% · ${spec.dissolution_rate} · pH ${spec.ph_balance_req} · ${spec.required_certs}` : 'No QC specification'}</span>
                </div>
              </div>
              <div className="flex items-center justify-between border-t border-line px-5 py-2.5 text-[12.5px] text-ink-2">
                <span>
                  <b className="font-semibold text-ink tabular">{num(batchCount)}</b> {batchCount === 1 ? 'batch' : 'batches'}
                </span>
                <span>
                  <b className="font-semibold text-ink tabular">{compact(units)}</b> units produced
                </span>
              </div>
            </Card>
          ))}
        </div>
      )}

      <AddMedicine open={adding} onClose={() => setAdding(false)} />
    </>
  )
}
