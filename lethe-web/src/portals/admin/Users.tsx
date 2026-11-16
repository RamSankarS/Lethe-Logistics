import { useMemo, useState } from 'react'
import { KeyRound, Pencil, Shuffle, UserPlus, Users as UsersIcon } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { createIsolatedClient, db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Field, FormGrid, Input, Select, Switch } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { Segmented } from '@/components/ui/Segmented'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { date, fullName, humanize, num } from '@/lib/format'
import { PORTALS, PORTAL_ORDER, resolvePortal, type PortalId } from '@/portals/registry'
import type { AppUser } from '@/lib/types'

function randomPassword() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789'
  const bytes = crypto.getRandomValues(new Uint8Array(10))
  return `Lethe@${Array.from(bytes, (b) => chars[b % chars.length]).join('')}`
}

function Provision({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['organisations', 'roles'] as const)
  const { run, busy } = useRunner()
  const [first, setFirst] = useState('')
  const [last, setLast] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState(randomPassword)
  const [orgId, setOrgId] = useState('')
  const [roleId, setRoleId] = useState('')
  const [result, setResult] = useState<{ email: string; confirm: boolean } | null>(null)

  const org = data.organisations.find((o) => o.org_id === orgId)
  const role = data.roles.find((r) => r.role_id === roleId)
  const portal = org ? resolvePortal(role?.role_name, org.org_type) : null
  const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())
  const valid = first.trim() && last.trim() && emailOk && password.length >= 8 && orgId && roleId

  const reset = () => {
    setFirst('')
    setLast('')
    setEmail('')
    setPassword(randomPassword())
    setOrgId('')
    setRoleId('')
    setResult(null)
  }

  const submit = async () => {
    const r = await run(
      'provision',
      async () => {
        // A throw-away client signs the new user up without touching the admin's own session.
        const isolated = createIsolatedClient()
        const { data: signUp, error } = await isolated.auth.signUp({ email: email.trim().toLowerCase(), password, options: { data: { first_name: first.trim(), last_name: last.trim() } } })
        if (error) throw error
        if (!signUp.user || (signUp.user.identities && signUp.user.identities.length === 0)) throw new Error('An account with this email already exists in Supabase Auth.')
        const { error: e2 } = await db('identity').from('users').insert({ user_id: signUp.user.id, org_id: orgId, role_id: roleId, first_name: first.trim(), last_name: last.trim(), password_hash: 'supabase_managed', is_active: true })
        if (e2) throw e2
        await logEvent(profile.user_id, 'USER_PROVISIONED', 'IDENTITY', { new_user_id: signUp.user.id, email: email.trim().toLowerCase(), org: org?.org_name, role: role?.role_name, portal, severity: 'MEDIUM' })
        return { confirm: !signUp.session }
      },
      { success: `${first.trim()} ${last.trim()} provisioned` },
    )
    if (r.ok) setResult({ email: email.trim().toLowerCase(), confirm: r.value.confirm })
  }

  return (
    <Modal
      open={open}
      onClose={() => {
        reset()
        onClose()
      }}
      icon={UserPlus}
      size="lg"
      title="Provision a user"
      description="Creates the Supabase Auth login and the matching identity_mod.users profile."
      footer={
        result ? (
          <Button
            variant="primary"
            onClick={() => {
              reset()
              onClose()
            }}
          >
            Done
          </Button>
        ) : (
          <>
            <Button variant="ghost" onClick={onClose}>
              Cancel
            </Button>
            <Button variant="primary" icon={UserPlus} disabled={!valid} loading={busy === 'provision'} onClick={submit}>
              Provision user
            </Button>
          </>
        )
      }
    >
      {result ? (
        <Callout tone="good" title="Identity created">
          <b className="admin-result-email">{result.email}</b> can now sign in to the {portal ? PORTALS[portal].name : 'assigned portal'}.
          {result.confirm && <span className="admin-result-line">Your Supabase project requires email confirmation, so the user must click the link in their inbox before the first sign-in.</span>}
          <span className="admin-result-line">Share the temporary password through a secure channel; it is not stored anywhere in Lethe.</span>
        </Callout>
      ) : (
        <div className="admin-modal-form">
          <FormGrid>
            <Field label="First name" required>
              <Input value={first} onChange={(e) => setFirst(e.target.value)} />
            </Field>
            <Field label="Last name" required>
              <Input value={last} onChange={(e) => setLast(e.target.value)} />
            </Field>
            <Field label="Work email" required error={email && !emailOk ? 'Enter a valid email.' : undefined}>
              <Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@org.in" />
            </Field>
            <Field label="Temporary password" required hint="At least 8 characters. Generated securely in your browser.">
              <div className="admin-pass-row">
                <Input value={password} onChange={(e) => setPassword(e.target.value)} className="font-mono" />
                <Button icon={Shuffle} aria-label="Generate password" onClick={() => setPassword(randomPassword())} />
              </div>
            </Field>
            <Field label="Organisation" required>
              <Select value={orgId} onChange={(e) => setOrgId(e.target.value)}>
                <option value="">Choose…</option>
                {data.organisations.filter((o) => o.is_active).map((o) => (
                  <option key={o.org_id} value={o.org_id}>
                    {o.org_name} · {humanize(o.org_type)}
                  </option>
                ))}
              </Select>
            </Field>
            <Field label="Role" required>
              <Select value={roleId} onChange={(e) => setRoleId(e.target.value)}>
                <option value="">Choose…</option>
                {data.roles.map((r) => (
                  <option key={r.role_id} value={r.role_id}>
                    {humanize(r.role_name)}
                  </option>
                ))}
              </Select>
            </Field>
          </FormGrid>
          {org && role && (
            <Callout tone={portal ? 'info' : 'warn'} icon={KeyRound} title={portal ? `Lands in the ${PORTALS[portal].name}` : 'No portal'}>
              {portal ? PORTALS[portal].tagline : 'Transporter users have no portal; they appear as drivers in fulfilment.'}
            </Callout>
          )}
        </div>
      )}
    </Modal>
  )
}

function EditUser({ user, onClose }: { user: AppUser | null; onClose: () => void }) {
  const profile = useProfile()
  const L = useLookups()
  const { data } = useTables(['organisations', 'roles'] as const)
  const { run, busy } = useRunner()
  const [orgId, setOrgId] = useState(user?.org_id ?? '')
  const [roleId, setRoleId] = useState(user?.role_id ?? '')
  if (!user) return null
  const org = data.organisations.find((o) => o.org_id === orgId)
  const role = data.roles.find((r) => r.role_id === roleId)
  const portal = org ? resolvePortal(role?.role_name, org.org_type) : null
  const changed = orgId !== user.org_id || roleId !== user.role_id

  const submit = async () => {
    const r = await run(
      `edit-${user.user_id}`,
      async () => {
        await mustChange(db('identity').from('users').update({ org_id: orgId, role_id: roleId }).eq('user_id', user.user_id).select('user_id'))
        await logEvent(profile.user_id, 'USER_ACCESS_CHANGED', 'IDENTITY', {
          target_user_id: user.user_id,
          target: fullName(user),
          from: { org: L.orgName(user.org_id), role: L.role.get(user.role_id ?? '')?.role_name },
          to: { org: org?.org_name, role: role?.role_name },
          severity: 'HIGH',
        })
      },
      { success: `${fullName(user)} updated`, description: portal ? `Now routed to the ${PORTALS[portal].name}.` : undefined },
    )
    if (r.ok) onClose()
  }

  return (
    <Modal
      open
      onClose={onClose}
      icon={Pencil}
      title={`Edit access · ${fullName(user)}`}
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button variant="primary" disabled={!changed || !orgId || !roleId} loading={busy === `edit-${user.user_id}`} onClick={submit}>
            Save access
          </Button>
        </>
      }
    >
      <div className="admin-modal-form">
        <Field label="Organisation">
          <Select value={orgId} onChange={(e) => setOrgId(e.target.value)}>
            {data.organisations.map((o) => (
              <option key={o.org_id} value={o.org_id}>
                {o.org_name} · {humanize(o.org_type)}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Role">
          <Select value={roleId} onChange={(e) => setRoleId(e.target.value)}>
            {data.roles.map((r) => (
              <option key={r.role_id} value={r.role_id}>
                {humanize(r.role_name)}
              </option>
            ))}
          </Select>
        </Field>
        <Callout tone="warn" title={portal ? `Will route to the ${PORTALS[portal].name}` : 'No portal for this combination'}>
          Access changes are logged as HIGH severity and take effect at the user's next sign-in.
        </Callout>
      </div>
    </Modal>
  )
}

export function Users() {
  const profile = useProfile()
  const L = useLookups()
  const t = useTables(['users', 'organisations', 'roles'] as const)
  const { run, busy } = useRunner()
  const [provisioning, setProvisioning] = useState(false)
  const [editing, setEditing] = useState<AppUser | null>(null)
  const [portalFilter, setPortalFilter] = useState<'all' | PortalId | 'none'>('all')

  const rows = useMemo(
    () =>
      t.data.users.map((u) => {
        const org = u.org_id ? L.org.get(u.org_id) : undefined
        const role = u.role_id ? L.role.get(u.role_id) : undefined
        return { u, org, role, portal: resolvePortal(role?.role_name, org?.org_type) }
      }),
    [t.data.users, L],
  )
  type Row = (typeof rows)[number]
  const shown = rows.filter((r) => portalFilter === 'all' || (portalFilter === 'none' ? !r.portal : r.portal === portalFilter))

  const setActive = (u: AppUser, next: boolean) =>
    run(
      `user-${u.user_id}`,
      async () => {
        await mustChange(db('identity').from('users').update({ is_active: next }).eq('user_id', u.user_id).select('user_id'))
        await logEvent(profile.user_id, next ? 'USER_ACTIVATED' : 'USER_DEACTIVATED', 'IDENTITY', { target_user_id: u.user_id, target: fullName(u), severity: next ? 'MEDIUM' : 'HIGH' })
      },
      { success: `${fullName(u)} ${next ? 'activated' : 'deactivated'}` },
    )

  const cols: Column<Row>[] = [
    { key: 'name', header: 'User', sort: (r) => fullName(r.u), cell: (r) => <div><p className="admin-cell-main">{fullName(r.u)}</p><p className="admin-cell-id">{r.u.user_id.slice(0, 8)}</p></div> },
    { key: 'org', header: 'Organisation', sort: (r) => r.org?.org_name ?? '', cell: (r) => <span className="admin-cell-text">{r.org?.org_name ?? '—'}</span> },
    { key: 'role', header: 'Role', sort: (r) => r.role?.role_name ?? '', cell: (r) => <span className="admin-cell-text">{r.role ? humanize(r.role.role_name) : 'Unassigned'}</span>, hideBelow: 'md' },
    { key: 'portal', header: 'Portal', sort: (r) => r.portal ?? 'zz', cell: (r) => (r.portal ? <Badge tone="accent">{PORTALS[r.portal].short}</Badge> : <Badge>None</Badge>) },
    { key: 'since', header: 'Created', sort: (r) => r.u.created_at_utc, cell: (r) => <span className="admin-cell-text">{date(r.u.created_at_utc)}</span>, hideBelow: 'xl' },
    { key: 'active', header: 'Active', cell: (r) => <Switch checked={r.u.is_active} disabled={busy === `user-${r.u.user_id}` || r.u.user_id === profile.user_id} onChange={(v) => void setActive(r.u, v)} label={`Toggle ${fullName(r.u)}`} /> },
    { key: 'edit', header: '', cell: (r) => <Button size="xs" variant="ghost" icon={Pencil} onClick={() => setEditing(r.u)} disabled={r.u.user_id === profile.user_id}>Edit</Button> },
  ]

  const count = (k: 'all' | PortalId | 'none') => rows.filter((r) => k === 'all' || (k === 'none' ? !r.portal : r.portal === k)).length

  return (
    <>
      <PageHeader actions={<Button variant="primary" icon={UserPlus} onClick={() => setProvisioning(true)}>Provision user</Button>} />
      <StatGrid cols={4}>
        <Stat label="Identities" value={num(rows.length)} sub={`${rows.filter((r) => r.u.is_active).length} active`} icon={UsersIcon} />
        <Stat label="Deactivated" value={num(rows.filter((r) => !r.u.is_active).length)} sub="blocked at sign-in" icon={UsersIcon} tone="neutral" />
        <Stat label="Roles" value={num(t.data.roles.length)} sub="defined in identity_mod.roles" icon={KeyRound} tone="info" />
        <Stat label="Without a portal" value={num(count('none'))} sub="e.g. transporter drivers" icon={UsersIcon} tone="warn" />
      </StatGrid>
      <div className="admin-filter-row">
        <Segmented
          value={portalFilter}
          onChange={setPortalFilter}
          options={[{ value: 'all', label: 'All', count: count('all') }, ...PORTAL_ORDER.map((p) => ({ value: p, label: PORTALS[p].short, count: count(p) })), { value: 'none', label: 'No portal', count: count('none') }]}
        />
      </div>
      <DataTable rows={shown} columns={cols} rowKey={(r) => r.u.user_id} loading={t.isLoading} searchText={(r) => `${fullName(r.u)} ${r.org?.org_name ?? ''} ${r.role?.role_name ?? ''}`} initialSort={{ key: 'name', dir: 'asc' }} pageSize={12} />
      <Callout tone="neutral" className="admin-note-box">
        Password hashes are never sent to the browser: Supabase Auth owns credentials, and Lethe only stores the profile, organisation and role.
      </Callout>
      <Provision open={provisioning} onClose={() => setProvisioning(false)} />
      <EditUser key={editing?.user_id ?? 'none'} user={editing} onClose={() => setEditing(null)} />
    </>
  )
}
