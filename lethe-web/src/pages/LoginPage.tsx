import { useEffect, useRef, useState, type FormEvent } from 'react'
import { Navigate } from 'react-router'
import { useQuery } from '@tanstack/react-query'
import { DEV_PREVIEW_ENABLED, useAuth } from '@/auth/AuthProvider'
import { Brand } from '@/components/layout/Brand'
import { Callout } from '@/components/ui/Feedback'
import { DEMO_ACCOUNTS } from '@/config/demo'
import { PORTALS, PORTAL_ORDER, resolvePortal } from '@/portals/registry'
import { db } from '@/lib/supabase'
import { useTheme } from '@/lib/theme'
import type { FriendlyError } from '@/lib/errors'
import type { OrgType } from '@/lib/types'

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
    <div className="dev-preview-box">
      <b>Developer preview (npm run dev only)</b>
      <div>Open a portal as one of the users without logging in. Saving is turned off.</div>
      {users.error && (
        <p className="form-error">
          Cannot load identities. Row-level security (supabase/rls.sql) refuses signed-out reads, so the preview only works on a database without it. Sign in instead.
        </p>
      )}
      <div className="preview-row">
        <select className="select-box" value={userId} onChange={(e) => setUserId(e.target.value)}>
          <option value="">Choose an identity...</option>
          {options.map((u) => (
            <option key={u.user_id} value={u.user_id}>
              {PORTALS[u.portal!].short} - {u.first_name} {u.last_name} ({u.organisations?.org_name})
            </option>
          ))}
        </select>
        <button className="btn btn-blue" disabled={!userId} onClick={() => void startPreview(userId)}>
          Preview
        </button>
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
  const working = busy || status === 'loading'

  return (
    <div className="login-page">
      <div className="login-strip">
        <Brand />
        <span className="strip-text">Pharmaceutical Supply Chain System</span>
        <button className="theme-link" onClick={toggle} aria-label="Toggle dark mode">
          {theme === 'dark' ? 'Light mode' : 'Dark mode'}
        </button>
      </div>

      <p className="login-intro">
        Track medicine batches from the factory to the pharmacy and back (returns, recalls and disposal). Each organisation logs in to its own portal.
      </p>

      <div className="login-box">
        <h2 className="login-title">Login</h2>
        <p className="login-subtitle">Your role and organisation decide which portal opens.</p>

        <form onSubmit={onSubmit}>
          <div className="login-row">
            <label htmlFor="email">Email:</label>
            <input
              id="email"
              className="login-input"
              type="email"
              autoComplete="username"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="name@lethe.com"
            />
          </div>
          <div className="login-row">
            <label htmlFor="password">Password:</label>
            <input
              id="password"
              className="login-input"
              ref={passwordRef}
              type={show ? 'text' : 'password'}
              autoComplete="current-password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <label className="show-pass">
              <input type="checkbox" checked={show} onChange={(e) => setShow(e.target.checked)} /> Show password
            </label>
          </div>

          {shown && (
            <Callout tone="critical" title={shown.title} className="login-error">
              {shown.message}
            </Callout>
          )}

          <button type="submit" className="login-btn" disabled={working}>
            {working ? 'Please wait...' : 'Login'}
          </button>
        </form>

        <div className="demo-section">
          <p>
            <b>Demo accounts</b> (click an email to fill it in, then type the password)
          </p>
          <table className="demo-table">
            <tbody>
              {DEMO_ACCOUNTS.map((d) => (
                <tr key={d.email} className={email.toLowerCase() === d.email ? 'picked' : undefined}>
                  <td>
                    <b>{PORTALS[d.portal].short}</b>
                    <br />
                    <span style={{ color: '#777', fontSize: '12px' }}>{d.org}</span>
                  </td>
                  <td>
                    <button
                      type="button"
                      className="demo-link"
                      onClick={() => {
                        setEmail(d.email)
                        setError(null)
                        passwordRef.current?.focus()
                      }}
                    >
                      {d.email}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {DEV_PREVIEW_ENABLED && <DevPreview />}
      </div>

      <p className="login-footer">MCA Database Management Systems project - MANIT Bhopal</p>
    </div>
  )
}
