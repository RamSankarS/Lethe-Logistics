import { useEffect, useRef, useState, type FormEvent } from 'react'
import { Navigate } from 'react-router'
import { useQuery } from '@tanstack/react-query'
import { ArrowRight, Eye, EyeOff, FlaskConical, Lock, Mail, RotateCcw, ScrollText, Snowflake, Moon, Sun } from 'lucide-react'
import { DEV_PREVIEW_ENABLED, useAuth } from '@/auth/AuthProvider'
import { Brand } from '@/components/layout/Brand'
import { Button } from '@/components/ui/Button'
import { Callout } from '@/components/ui/Feedback'
import { Field, Input, Select } from '@/components/ui/Form'
import { DEMO_ACCOUNTS } from '@/config/demo'
import { PORTALS, PORTAL_ORDER, resolvePortal } from '@/portals/registry'
import { db } from '@/lib/supabase'
import { useTheme } from '@/lib/theme'
import type { FriendlyError } from '@/lib/errors'
import type { OrgType } from '@/lib/types'

const FEATURES = [
  { icon: FlaskConical, title: 'Batch pedigree', text: 'Every unit traced from production line to pharmacy shelf, return and disposal.' },
  { icon: Snowflake, title: 'Cold-chain guard', text: 'A sensor breach automatically quarantines stock and pulls it back into QC.' },
  { icon: ScrollText, title: 'Immutable ledger', text: 'Write-once audit log that even administrators cannot edit or delete.' },
]

function DevPreview() {
  const { startPreview } = useAuth()
  const [userId, setUserId] = useState('')
  const users = useQuery({
    queryKey: ['dev-preview-users'],
    queryFn: async () => {
      const { data, error } = await db('identity').from('users').select('user_id, first_name, last_name, is_active, roles(role_name), organisations(org_name, org_type)').eq('is_active', true)
      if (error) throw error
      return (data ?? []) as unknown as { user_id: string; first_name: string; last_name: string; roles: { role_name: string } | null; organisations: { org_name: string; org_type: OrgType } | null }[]
    },
  })
  const options = (users.data ?? [])
    .map((u) => ({ ...u, portal: resolvePortal(u.roles?.role_name, u.organisations?.org_type) }))
    .filter((u) => u.portal)
    .sort((a, b) => PORTAL_ORDER.indexOf(a.portal!) - PORTAL_ORDER.indexOf(b.portal!))
  return (
    <div className="mt-6 rounded-xl border border-dashed border-warn/60 bg-warn-soft p-4">
      <p className="text-[12.5px] font-semibold text-warn-text">Developer preview (npm run dev only)</p>
      <p className="mt-0.5 text-xs text-ink-2">Render a portal as a seeded identity without signing in. Writes are disabled.</p>
      {users.error && (
        <p className="mt-2 text-xs text-critical-text">
          Cannot load identities. Row-level security (supabase/rls.sql) refuses signed-out reads, so the preview only works on a database without it. Sign in instead.
        </p>
      )}
      <div className="mt-3 flex gap-2">
        <div className="flex-1">
          <Select value={userId} onChange={(e) => setUserId(e.target.value)}>
            <option value="">Choose an identity…</option>
            {options.map((u) => (
              <option key={u.user_id} value={u.user_id}>
                {PORTALS[u.portal!].short} · {u.first_name} {u.last_name} ({u.organisations?.org_name})
              </option>
            ))}
          </Select>
        </div>
        <Button size="md" disabled={!userId} onClick={() => void startPreview(userId)}>
          Preview
        </Button>
      </div>
    </div>
  )
}

export function LoginPage() {
  const { status, portal, signIn, notice, clearNotice } = useAuth()
  const { theme, toggle } = useTheme()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [show, setShow] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<FriendlyError | null>(null)
  const passwordRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    document.title = 'Sign in · Lethe Logistics'
  }, [])

  if (status === 'ready') return <Navigate to={portal ? `/${portal}` : '/'} replace />
  if (status === 'unlinked') return <Navigate to="/" replace />

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault()
    setError(null)
    clearNotice()
    setBusy(true)
    const res = await signIn(email, password)
    setBusy(false)
    if (!res.ok) setError(res.error)
  }

  const shown = error ?? notice

  return (
    <div className="flex min-h-full bg-page">
      {/* Story panel */}
      <section className="relative hidden w-[50%] max-w-[760px] flex-col justify-between overflow-hidden bg-[#0b1220] p-12 text-white lg:flex">
        <div
          className="pointer-events-none absolute inset-0 opacity-[0.35]"
          style={{ backgroundImage: 'radial-gradient(rgba(148,163,184,0.18) 1px, transparent 1px)', backgroundSize: '22px 22px' }}
        />
        <div className="pointer-events-none absolute -top-40 -left-32 size-[520px] rounded-full bg-[#2dd4bf]/15 blur-[120px]" />
        <div className="pointer-events-none absolute -right-40 -bottom-48 size-[560px] rounded-full bg-[#8b5cf6]/20 blur-[130px]" />

        <div className="relative">
          <Brand />
        </div>

        <div className="relative max-w-xl">
          <p className="mb-4 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1 text-[12px] text-white/70">
            <RotateCcw className="size-3.5 text-[#5eead4]" /> Closed-loop pharmaceutical traceability
          </p>
          <h1 className="text-[40px] leading-[1.1] font-semibold tracking-tight text-balance">
            Every batch, every hand-off, <span className="text-[#5eead4]">accounted for.</span>
          </h1>
          <p className="mt-4 text-[15px] leading-7 text-white/65">
            Production, cold storage, fulfilment, recalls and disposal on one PostgreSQL backbone, with database triggers enforcing the rules and a ledger that never forgets.
          </p>

          <div className="mt-8 grid gap-4">
            {FEATURES.map((f) => (
              <div key={f.title} className="flex gap-3.5">
                <span className="grid size-10 shrink-0 place-items-center rounded-xl border border-white/10 bg-white/5 text-[#5eead4]">
                  <f.icon className="size-[18px]" />
                </span>
                <div>
                  <p className="text-[14px] font-semibold">{f.title}</p>
                  <p className="text-[13px] leading-5 text-white/55">{f.text}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="relative">
          <p className="mb-3 text-[11px] font-semibold tracking-[0.14em] text-white/40 uppercase">Five isolated portals</p>
          <div className="flex flex-wrap gap-2">
            {PORTAL_ORDER.map((id) => {
              const P = PORTALS[id]
              return (
                <span key={id} data-theme="dark" data-portal={id} className="inline-flex items-center gap-1.5 rounded-full border border-white/10 bg-white/[0.04] px-3 py-1.5 text-[12.5px] text-white/80">
                  <P.icon className="size-3.5 text-accent-text" /> {P.short}
                </span>
              )
            })}
          </div>
          <p className="mt-6 text-[12px] text-white/35">MCA Database Management Systems project · MANIT Bhopal</p>
        </div>
      </section>

      {/* Sign-in panel */}
      <section className="relative flex flex-1 items-center justify-center px-5 py-10 sm:px-10">
        <button onClick={toggle} className="absolute top-5 right-5 grid size-9 place-items-center rounded-lg border border-line bg-surface text-ink-2 hover:bg-surface-2" aria-label="Toggle dark mode">
          {theme === 'dark' ? <Sun className="size-4" /> : <Moon className="size-4" />}
        </button>

        <div className="w-full max-w-[420px]">
          <div className="mb-8 lg:hidden">
            <div className="inline-flex rounded-2xl bg-[#0b1220] px-4 py-3">
              <Brand />
            </div>
          </div>

          <h2 className="text-[26px] leading-8 font-semibold tracking-tight text-ink">Sign in to your portal</h2>
          <p className="mt-1.5 text-[14px] text-ink-2">Your role and organisation decide which portal opens.</p>

          <form onSubmit={onSubmit} className="mt-7 space-y-4">
            <Field label="Work email" htmlFor="email">
              <div className="relative">
                <Mail className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted" />
                <Input id="email" type="email" autoComplete="username" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@lethe.com" className="h-11 pl-9" />
              </div>
            </Field>
            <Field label="Password" htmlFor="password">
              <div className="relative">
                <Lock className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted" />
                <Input
                  id="password"
                  ref={passwordRef}
                  type={show ? 'text' : 'password'}
                  autoComplete="current-password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  className="h-11 pr-10 pl-9"
                />
                <button type="button" onClick={() => setShow((s) => !s)} className="absolute top-1/2 right-2 grid size-8 -translate-y-1/2 place-items-center rounded-md text-muted hover:text-ink" aria-label={show ? 'Hide password' : 'Show password'}>
                  {show ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
                </button>
              </div>
            </Field>

            {shown && (
              <Callout tone="critical" title={shown.title}>
                {shown.message}
              </Callout>
            )}

            <Button type="submit" variant="primary" size="lg" className="w-full" loading={busy || status === 'loading'} iconRight={ArrowRight}>
              Sign in
            </Button>
          </form>

          <div className="mt-8">
            <div className="mb-3 flex items-center gap-3">
              <span className="h-px flex-1 bg-line" />
              <span className="text-[11.5px] font-semibold tracking-[0.12em] text-muted uppercase">Demo portals</span>
              <span className="h-px flex-1 bg-line" />
            </div>
            <div className="grid gap-1.5">
              {DEMO_ACCOUNTS.map((d) => {
                const P = PORTALS[d.portal]
                const active = email.toLowerCase() === d.email
                return (
                  <button
                    key={d.email}
                    type="button"
                    data-portal={d.portal}
                    onClick={() => {
                      setEmail(d.email)
                      setError(null)
                      passwordRef.current?.focus()
                    }}
                    className={`flex items-center gap-3 rounded-xl border px-3 py-2.5 text-left transition-colors ${active ? 'border-accent bg-accent-soft' : 'border-line bg-surface hover:border-line-strong hover:bg-surface-2'}`}
                  >
                    <span className="grid size-9 shrink-0 place-items-center rounded-lg bg-accent-soft text-accent-text">
                      <P.icon className="size-[18px]" />
                    </span>
                    <span className="min-w-0 flex-1">
                      <span className="block text-[13.5px] font-semibold text-ink">{P.short}</span>
                      <span className="block truncate text-[12px] text-ink-2">{d.org}</span>
                    </span>
                    <span className="hidden truncate font-mono text-[11.5px] text-muted sm:block">{d.email}</span>
                  </button>
                )
              })}
            </div>
            <p className="mt-3 text-center text-[12px] text-muted">Pick a portal to fill its e-mail, then enter the password.</p>
          </div>

          {DEV_PREVIEW_ENABLED && <DevPreview />}
        </div>
      </section>
    </div>
  )
}
