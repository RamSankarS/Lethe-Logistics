import { useMemo, useState } from 'react'
import { Building2, Plus } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, Input, Select, Switch } from '@/components/ui/Form'
import { ConfirmDialog, Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { ORG_TYPES, ORG_TYPE_LABEL } from '@/lib/domain'
import { date, num } from '@/lib/format'
import { PORTALS, resolvePortal } from '@/portals/registry'
import type { Organisation, OrgType } from '@/lib/types'

function Onboard({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['organisations'] as const)
  const { run, busy } = useRunner()
  const [name, setName] = useState('')
  const [type, setType] = useState<OrgType>('Retailer')
  const [reg, setReg] = useState('')
  const [email, setEmail] = useState('')
  const dupReg = data.organisations.some((o) => o.reg_no.toLowerCase() === reg.trim().toLowerCase())
  const dupEmail = data.organisations.some((o) => o.contact_email.toLowerCase() === email.trim().toLowerCase())
  const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())
  const valid = name.trim().length >= 3 && reg.trim().length >= 3 && emailOk && !dupReg && !dupEmail
  const portal = resolvePortal(null, type)

  const submit = async () => {
    const r = await run(
      'onboard',
      async () => {
        const { error } = await db('identity').from('organisations').insert({ org_name: name.trim(), org_type: type, reg_no: reg.trim(), contact_email: email.trim().toLowerCase(), is_active: true })
        if (error) throw error
        await logEvent(profile.user_id, 'ORG_ONBOARDED', 'IDENTITY', { org_name: name.trim(), org_type: type, reg_no: reg.trim(), severity: 'MEDIUM' })
      },
      { success: `${name.trim()} onboarded` },
    )
    if (r.ok) {
      setName('')
      setReg('')
      setEmail('')
      onClose()
    }
  }

  return (
    <Modal
      open={open}
      onClose={onClose}
      icon={Building2}
      title="Onboard an organisation"
      description="Adds a supply-chain partner to the Lethe network."
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" icon={Plus} disabled={!valid} loading={busy === 'onboard'} onClick={submit}>
            Onboard
          </Button>
        </>
      }
    >
      <div className="space-y-4">
        <Field label="Organisation name" required>
          <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Narmada Health Pharmacy" />
        </Field>
        <Field label="Type" required hint={portal ? `Its users will sign in to the ${PORTALS[portal].name}.` : 'Transporters have no portal; their users act as drivers.'}>
          <Select value={type} onChange={(e) => setType(e.target.value as OrgType)}>
            {ORG_TYPES.map((t) => (
              <option key={t} value={t}>
                {ORG_TYPE_LABEL[t]}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Registration / licence no." required error={dupReg ? 'Already registered.' : undefined}>
          <Input value={reg} onChange={(e) => setReg(e.target.value)} placeholder="RET/BPL/2026/411" className="font-mono" />
        </Field>
        <Field label="Contact email" required error={dupEmail ? 'Another organisation uses this email.' : email && !emailOk ? 'Enter a valid email.' : undefined}>
          <Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="ops@narmadahealth.in" />
        </Field>
      </div>
    </Modal>
  )
}

export function Organisations() {
  const profile = useProfile()
  const t = useTables(['organisations', 'users'] as const)
  const { run, busy } = useRunner()
  const [open, setOpen] = useState(false)
  const [type, setType] = useState<'all' | OrgType>('all')
  const [confirm, setConfirm] = useState<Organisation | null>(null)

  const users = useMemo(() => {
    const m = new Map<string, number>()
    for (const u of t.data.users) if (u.org_id && u.is_active) m.set(u.org_id, (m.get(u.org_id) ?? 0) + 1)
    return m
  }, [t.data.users])

  const setActive = (o: Organisation, next: boolean) =>
    run(
      `org-${o.org_id}`,
      async () => {
        await mustChange(db('identity').from('organisations').update({ is_active: next }).eq('org_id', o.org_id).select('org_id'))
        await logEvent(profile.user_id, next ? 'ORG_ACTIVATED' : 'ORG_DEACTIVATED', 'IDENTITY', { org_id: o.org_id, org_name: o.org_name, active_users: users.get(o.org_id) ?? 0, severity: next ? 'MEDIUM' : 'HIGH' })
      },
      { success: `${o.org_name} ${next ? 'activated' : 'suspended'}`, description: next ? undefined : 'Its users can no longer sign in.' },
    )

  const rows = type === 'all' ? t.data.organisations : t.data.organisations.filter((o) => o.org_type === type)
  const cols: Column<Organisation>[] = [
    { key: 'name', header: 'Organisation', sort: (o) => o.org_name, cell: (o) => <div><p className="font-medium text-ink">{o.org_name}</p><p className="text-xs text-ink-2">{o.contact_email}</p></div> },
    { key: 'type', header: 'Type', sort: (o) => o.org_type, cell: (o) => <Badge tone={o.org_type === 'Regulatory_Body' ? 'warn' : o.org_type === 'Manufacturer' ? 'accent' : o.org_type === 'Distributor' ? 'info' : o.org_type === 'Retailer' ? 'good' : 'neutral'}>{ORG_TYPE_LABEL[o.org_type]}</Badge> },
    { key: 'reg', header: 'Registration', sort: (o) => o.reg_no, cell: (o) => <Code>{o.reg_no}</Code>, hideBelow: 'md' },
    { key: 'portal', header: 'Portal', cell: (o) => { const p = resolvePortal(null, o.org_type); return p ? <span className="text-[13px] text-ink-2">{PORTALS[p].short}</span> : <span className="text-xs text-muted">None</span> }, hideBelow: 'lg' },
    { key: 'users', header: 'Active users', align: 'right', sort: (o) => users.get(o.org_id) ?? 0, cell: (o) => num(users.get(o.org_id) ?? 0) },
    { key: 'since', header: 'Joined', sort: (o) => o.created_at_utc, cell: (o) => <span className="text-[13px] text-ink-2 tabular">{date(o.created_at_utc)}</span>, hideBelow: 'xl' },
    {
      key: 'active',
      header: 'Active',
      cell: (o) => (
        <Switch
          checked={o.is_active}
          disabled={busy === `org-${o.org_id}` || o.org_id === profile.org?.org_id}
          onChange={(next) => (next ? void setActive(o, true) : setConfirm(o))}
          label={`Toggle ${o.org_name}`}
        />
      ),
    },
  ]

  const count = (k: 'all' | OrgType) => (k === 'all' ? t.data.organisations.length : t.data.organisations.filter((o) => o.org_type === k).length)

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={Plus} onClick={() => setOpen(true)}>Onboard organisation</Button>} />
      <StatGrid cols={4}>
        <Stat label="Organisations" value={num(t.data.organisations.length)} sub={`${t.data.organisations.filter((o) => o.is_active).length} active`} icon={Building2} />
        <Stat label="Manufacturers" value={num(count('Manufacturer'))} icon={Building2} tone="accent" />
        <Stat label="Distributors & transporters" value={num(count('Distributor') + count('Transporter'))} icon={Building2} tone="info" />
        <Stat label="Retailers & regulators" value={num(count('Retailer') + count('Regulatory_Body'))} icon={Building2} tone="good" />
      </StatGrid>
      <div className="mt-5 mb-3">
        <Segmented value={type} onChange={setType} options={[{ value: 'all', label: 'All', count: count('all') }, ...ORG_TYPES.map((o) => ({ value: o, label: ORG_TYPE_LABEL[o], count: count(o) }))]} />
      </div>
      <DataTable rows={rows} columns={cols} rowKey={(o) => o.org_id} loading={t.isLoading} searchText={(o) => `${o.org_name} ${o.reg_no} ${o.contact_email}`} initialSort={{ key: 'name', dir: 'asc' }} pageSize={12} exportName="lethe-organisations" exportRow={(o) => ({ name: o.org_name, type: o.org_type, reg_no: o.reg_no, email: o.contact_email, active: o.is_active, users: users.get(o.org_id) ?? 0 })} />
      <Callout tone="neutral" className="mt-5">
        Suspending an organisation blocks its users at sign-in (the SysAdmin's own organisation cannot be suspended). Every change is written to the audit ledger.
      </Callout>
      <Onboard open={open} onClose={() => setOpen(false)} />
      <ConfirmDialog
        open={!!confirm}
        onClose={() => setConfirm(null)}
        danger
        title={`Suspend ${confirm?.org_name}?`}
        confirmLabel="Suspend"
        loading={busy === `org-${confirm?.org_id}`}
        onConfirm={async () => {
          if (!confirm) return
          const r = await setActive(confirm, false)
          if (r.ok) setConfirm(null)
        }}
      >
        {users.get(confirm?.org_id ?? '') ?? 0} active user(s) will be locked out until the organisation is reactivated.
      </ConfirmDialog>
    </>
  )
}
