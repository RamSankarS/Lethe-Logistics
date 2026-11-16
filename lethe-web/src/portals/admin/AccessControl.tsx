import { useMemo, useState } from 'react'
import { ArrowRight, BadgeCheck, Plus, ShieldPlus } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { logEvent, mustChange, useRunner } from '@/data/actions'
import { useLookups, useTables } from '@/data/hooks'
import { db } from '@/lib/supabase'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge, Code } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, Spinner } from '@/components/ui/Feedback'
import { Field, Input, Select, Textarea } from '@/components/ui/Form'
import { Modal } from '@/components/ui/Modal'
import { MODULE_CATEGORIES } from '@/lib/domain'
import { humanize, num } from '@/lib/format'
import { cn } from '@/lib/cn'
import { PORTALS, PORTAL_RULES, resolvePortal } from '@/portals/registry'
import type { Permission, Role } from '@/lib/types'

function AddRole({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['roles'] as const)
  const { run, busy } = useRunner()
  const [name, setName] = useState('')
  const [desc, setDesc] = useState('')
  const clean = name.trim().replace(/\s+/g, '_')
  const dup = data.roles.some((r) => r.role_name.toLowerCase() === clean.toLowerCase())
  const submit = async () => {
    const r = await run(
      'role',
      async () => {
        const { error } = await db('identity').from('roles').insert({ role_name: clean, description: desc.trim() || null })
        if (error) throw error
        await logEvent(profile.user_id, 'ROLE_CREATED', 'IDENTITY', { role_name: clean, severity: 'MEDIUM' })
      },
      { success: `Role ${humanize(clean)} created` },
    )
    if (r.ok) {
      setName('')
      setDesc('')
      onClose()
    }
  }
  return (
    <Modal open={open} onClose={onClose} size="sm" icon={ShieldPlus} title="Create a role" footer={<><Button variant="ghost" onClick={onClose}>Cancel</Button><Button variant="primary" disabled={clean.length < 3 || dup} loading={busy === 'role'} onClick={submit}>Create</Button></>}>
      <div className="admin-modal-form">
        <Field label="Role name" required error={dup ? 'Role already exists.' : undefined} hint="Spaces become underscores, e.g. Cold_Chain_Officer.">
          <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Cold Chain Officer" />
        </Field>
        <Field label="Description">
          <Textarea value={desc} onChange={(e) => setDesc(e.target.value)} />
        </Field>
      </div>
    </Modal>
  )
}

function AddPermission({ open, onClose }: { open: boolean; onClose: () => void }) {
  const profile = useProfile()
  const { data } = useTables(['permissions'] as const)
  const { run, busy } = useRunner()
  const [module, setModule] = useState<string>('WAREHOUSE')
  const [action, setAction] = useState('')
  const ok = /^[a-z_]+:[a-z_]+$/.test(action.trim())
  const dup = data.permissions.some((p) => p.action_name === action.trim())
  const submit = async () => {
    const r = await run(
      'perm',
      async () => {
        const { error } = await db('identity').from('permissions').insert({ module_category: module, action_name: action.trim() })
        if (error) throw error
        await logEvent(profile.user_id, 'PERMISSION_CREATED', 'IDENTITY', { module_category: module, action_name: action.trim(), severity: 'MEDIUM' })
      },
      { success: `Permission ${action.trim()} created` },
    )
    if (r.ok) {
      setAction('')
      onClose()
    }
  }
  return (
    <Modal open={open} onClose={onClose} size="sm" icon={Plus} title="Create a permission" footer={<><Button variant="ghost" onClick={onClose}>Cancel</Button><Button variant="primary" disabled={!ok || dup} loading={busy === 'perm'} onClick={submit}>Create</Button></>}>
      <div className="admin-modal-form">
        <Field label="Module">
          <Select value={module} onChange={(e) => setModule(e.target.value)}>
            {MODULE_CATEGORIES.map((m) => (
              <option key={m}>{m}</option>
            ))}
          </Select>
        </Field>
        <Field label="Action" required error={dup ? 'Already exists.' : action && !ok ? 'Use resource:verb, lowercase.' : undefined} hint="Format resource:verb, e.g. coldchain:override">
          <Input value={action} onChange={(e) => setAction(e.target.value)} placeholder="coldchain:override" className="font-mono" />
        </Field>
      </div>
    </Modal>
  )
}

export function AccessControl() {
  const profile = useProfile()
  const L = useLookups()
  const t = useTables(['roles', 'permissions', 'rolePermissions', 'users', 'organisations'] as const)
  const { run, busy } = useRunner()
  const [addingRole, setAddingRole] = useState(false)
  const [addingPerm, setAddingPerm] = useState(false)

  const granted = useMemo(() => new Set(t.data.rolePermissions.map((rp) => `${rp.role_id}|${rp.permission_id}`)), [t.data.rolePermissions])
  const perms = useMemo(() => [...t.data.permissions].sort((a, b) => a.module_category.localeCompare(b.module_category) || a.action_name.localeCompare(b.action_name)), [t.data.permissions])
  const usersPerRole = useMemo(() => {
    const m = new Map<string, number>()
    for (const u of t.data.users) if (u.role_id && u.is_active) m.set(u.role_id, (m.get(u.role_id) ?? 0) + 1)
    return m
  }, [t.data.users])
  const portalCounts = useMemo(() => {
    const m = new Map<string, number>()
    for (const u of t.data.users) {
      if (!u.is_active) continue
      const org = u.org_id ? L.org.get(u.org_id) : undefined
      const role = u.role_id ? L.role.get(u.role_id) : undefined
      const p = resolvePortal(role?.role_name, org?.org_type) ?? 'none'
      m.set(p, (m.get(p) ?? 0) + 1)
    }
    return m
  }, [t.data.users, L])

  const toggle = (role: Role, perm: Permission) => {
    const key = `${role.role_id}|${perm.permission_id}`
    const has = granted.has(key)
    return run(
      `rp-${key}`,
      async () => {
        if (has) {
          await mustChange(db('identity').from('role_permissions').delete().eq('role_id', role.role_id).eq('permission_id', perm.permission_id).select('role_id'))
        } else {
          const { error } = await db('identity').from('role_permissions').insert({ role_id: role.role_id, permission_id: perm.permission_id })
          if (error) throw error
        }
        await logEvent(profile.user_id, has ? 'RBAC_PERMISSION_REVOKED' : 'RBAC_PERMISSION_GRANTED', 'IDENTITY', { role: role.role_name, permission: perm.action_name, module: perm.module_category, severity: 'HIGH' })
      },
      { success: `${perm.action_name} ${has ? 'revoked from' : 'granted to'} ${humanize(role.role_name)}` },
    )
  }

  if (t.isLoading) return <Spinner />

  return (
    <>
      <PageHeader
        actions={
          <>
            <Button icon={Plus} onClick={() => setAddingPerm(true)}>
              New permission
            </Button>
            <Button variant="primary" icon={ShieldPlus} onClick={() => setAddingRole(true)}>
              New role
            </Button>
          </>
        }
      />

      <Card>
        <CardHeader title="Role-permission matrix" subtitle="identity_mod.role_permissions. Click a cell to grant or revoke. Every change is a HIGH-severity ledger event." icon={BadgeCheck} />
        <div className="admin-matrix-scroll">
          <table className="my-table admin-matrix-table">
            <thead>
              <tr>
                <th className="admin-matrix-rolehead">Role</th>
                {perms.map((p) => (
                  <th key={p.permission_id}>
                    <span className="admin-matrix-module">{p.module_category}</span>
                    <span className="admin-matrix-action">{p.action_name}</span>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {t.data.roles.map((r) => (
                <tr key={r.role_id}>
                  <td className="admin-matrix-role">
                    <p className="admin-role-name">{humanize(r.role_name)}</p>
                    <p className="admin-role-desc" title={r.description ?? ''}>
                      {num(usersPerRole.get(r.role_id) ?? 0)} active users · {r.description ?? 'No description'}
                    </p>
                  </td>
                  {perms.map((p) => {
                    const key = `${r.role_id}|${p.permission_id}`
                    const on = granted.has(key)
                    return (
                      <td key={p.permission_id}>
                        <button
                          onClick={() => void toggle(r, p)}
                          disabled={busy === `rp-${key}`}
                          aria-pressed={on}
                          aria-label={`${on ? 'Revoke' : 'Grant'} ${p.action_name} for ${r.role_name}`}
                          className={cn('admin-matrix-cell', on && 'admin-cell-on')}
                        >
                          {on && '✓'}
                        </button>
                      </td>
                    )
                  })}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>

      <div className="admin-access-grid grid gap-5 xl:grid-cols-2">
        <Card>
          <CardHeader title="Portal routing rules" subtitle="How a login is mapped to exactly one portal" />
          <CardBody>
            {PORTAL_RULES.map((rule) => {
              const P = PORTALS[rule.portal]
              return (
                <div key={rule.portal} data-portal={rule.portal} className="admin-rule-row">
                  <span className="admin-rule-when">{rule.when}</span>
                  <span className="admin-rule-target">
                    <ArrowRight className="admin-rule-arrow" />
                    {P.short}
                    <Badge tone="accent">{num(portalCounts.get(rule.portal) ?? 0)}</Badge>
                  </span>
                </div>
              )
            })}
            <p className="admin-small-note">{num(portalCounts.get('none') ?? 0)} active users (e.g. transporter drivers) have no portal.</p>
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="Defined permissions" subtitle="identity_mod.permissions" />
          <CardBody>
            {perms.map((p) => (
              <div key={p.permission_id} className="admin-perm-row">
                <Code>{p.action_name}</Code>
                <span className="admin-perm-info">
                  {p.module_category} · held by {t.data.rolePermissions.filter((rp) => rp.permission_id === p.permission_id).length} role(s)
                </span>
              </div>
            ))}
          </CardBody>
        </Card>
      </div>
      <Callout tone="neutral" className="admin-note-box">
        Portal access is decided by organisation type and the Admin role. The permission matrix models fine-grained capabilities (DFD process 1.x) and is audited like every other governance change.
      </Callout>
      <AddRole open={addingRole} onClose={() => setAddingRole(false)} />
      <AddPermission open={addingPerm} onClose={() => setAddingPerm(false)} />
    </>
  )
}
