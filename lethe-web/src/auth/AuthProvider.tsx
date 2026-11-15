import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { db, supabase } from '@/lib/supabase'
import { describeError, type FriendlyError } from '@/lib/errors'
import type { Organisation, Role } from '@/lib/types'
import { resolvePortal, type PortalId } from '@/portals/registry'

export interface Profile {
  user_id: string
  email: string | null
  first_name: string
  last_name: string
  is_active: boolean
  org: Organisation | null
  role: Role | null
}

type Status = 'loading' | 'signed-out' | 'ready' | 'unlinked'

interface AuthContextValue {
  status: Status
  profile: Profile | null
  portal: PortalId | null
  /** Developer preview (vite dev only): rendering a portal without a real session. */
  isPreview: boolean
  notice: FriendlyError | null
  signIn: (email: string, password: string) => Promise<{ ok: true } | { ok: false; error: FriendlyError }>
  signOut: () => Promise<void>
  startPreview: (userId: string) => Promise<void>
  clearNotice: () => void
}

const AuthContext = createContext<AuthContextValue | null>(null)

export const DEV_PREVIEW_ENABLED = import.meta.env.DEV && import.meta.env.VITE_DEV_PREVIEW === 'true'
const SESSION_KEY = 'lethe-session-id'
const PREVIEW_KEY = 'lethe-preview-user'

async function fetchProfile(userId: string, email: string | null): Promise<Profile | null> {
  const { data, error } = await db('identity')
    .from('users')
    .select(
      'user_id, first_name, last_name, is_active, roles(role_id, role_name, description), organisations(org_id, org_name, org_type, reg_no, contact_email, is_active, created_at_utc)',
    )
    .eq('user_id', userId)
    .maybeSingle()
  if (error) throw error
  if (!data) return null
  const row = data as unknown as {
    user_id: string
    first_name: string
    last_name: string
    is_active: boolean
    roles: Role | Role[] | null
    organisations: Organisation | Organisation[] | null
  }
  const one = <T,>(v: T | T[] | null): T | null => (Array.isArray(v) ? (v[0] ?? null) : v)
  return {
    user_id: row.user_id,
    email,
    first_name: row.first_name,
    last_name: row.last_name,
    is_active: row.is_active,
    role: one(row.roles),
    org: one(row.organisations),
  }
}

/** Blocks sign-in for deactivated users or suspended organisations. */
function accessProblem(p: Profile): FriendlyError | null {
  if (!p.is_active) return { kind: 'permission', title: 'Account deactivated', message: 'Your account has been deactivated by the system administrator.' }
  if (p.org && !p.org.is_active && p.role?.role_name !== 'Admin') {
    return { kind: 'permission', title: 'Organisation suspended', message: `${p.org.org_name} is currently inactive on the Lethe network.` }
  }
  return null
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const qc = useQueryClient()
  const [status, setStatus] = useState<Status>('loading')
  const [profile, setProfile] = useState<Profile | null>(null)
  const [isPreview, setIsPreview] = useState(false)
  const [notice, setNotice] = useState<FriendlyError | null>(null)
  const signingIn = useRef(false)
  const previewRef = useRef(false)

  const applyProfile = useCallback(async (userId: string, email: string | null, preview = false) => {
    const p = await fetchProfile(userId, email)
    if (!p) {
      setProfile(null)
      setStatus('unlinked')
      return null
    }
    if (!preview) {
      const problem = accessProblem(p)
      if (problem) {
        await supabase.auth.signOut()
        setProfile(null)
        setNotice(problem)
        setStatus('signed-out')
        return null
      }
    }
    setProfile(p)
    setIsPreview(preview)
    previewRef.current = preview
    setStatus('ready')
    return p
  }, [])

  // Initial session + auth events
  useEffect(() => {
    let cancelled = false
    ;(async () => {
      try {
        if (!DEV_PREVIEW_ENABLED) sessionStorage.removeItem(PREVIEW_KEY)
        const previewUser = DEV_PREVIEW_ENABLED ? sessionStorage.getItem(PREVIEW_KEY) : null
        if (previewUser) {
          await applyProfile(previewUser, null, true)
          return
        }
        const { data } = await supabase.auth.getSession()
        if (cancelled) return
        if (data.session) await applyProfile(data.session.user.id, data.session.user.email ?? null)
        else setStatus('signed-out')
      } catch (e) {
        setNotice(describeError(e))
        setStatus('signed-out')
      }
    })()

    const { data: sub } = supabase.auth.onAuthStateChange((event, session) => {
      // Never await Supabase calls inside this callback (auth lock); defer instead.
      if (event === 'SIGNED_OUT') {
        if (previewRef.current) return
        setProfile(null)
        setStatus('signed-out')
      } else if (event === 'SIGNED_IN' && session && !signingIn.current) {
        setTimeout(() => {
          applyProfile(session.user.id, session.user.email ?? null).catch(() => setStatus('signed-out'))
        }, 0)
      }
    })
    return () => {
      cancelled = true
      sub.subscription.unsubscribe()
    }
  }, [applyProfile])

  const signIn = useCallback<AuthContextValue['signIn']>(
    async (email, password) => {
      signingIn.current = true
      setNotice(null)
      try {
        const { data, error } = await supabase.auth.signInWithPassword({ email: email.trim(), password })
        if (error) return { ok: false, error: describeError(error) }
        const p = await fetchProfile(data.user.id, data.user.email ?? null)
        if (!p) {
          await supabase.auth.signOut()
          return { ok: false, error: { kind: 'permission', title: 'No Lethe identity', message: 'This login is not linked to a user in identity_mod.users. Ask the SysAdmin to provision you.' } }
        }
        const problem = accessProblem(p)
        if (problem) {
          await supabase.auth.signOut()
          return { ok: false, error: problem }
        }
        // Record the session; the tr_after_session_started trigger writes USER_LOGIN_SUCCESS to the audit ledger.
        const { data: s } = await db('identity').from('user_sessions').insert({ user_id: p.user_id, ip_address: 'web-client' }).select('session_id').single()
        if (s?.session_id) localStorage.setItem(SESSION_KEY, s.session_id as string)
        qc.clear()
        sessionStorage.removeItem(PREVIEW_KEY)
        previewRef.current = false
        setProfile(p)
        setIsPreview(false)
        setStatus('ready')
        return { ok: true }
      } catch (e) {
        return { ok: false, error: describeError(e) }
      } finally {
        signingIn.current = false
      }
    },
    [qc],
  )

  const signOut = useCallback(async () => {
    if (previewRef.current) {
      sessionStorage.removeItem(PREVIEW_KEY)
      previewRef.current = false
    } else {
      const sid = localStorage.getItem(SESSION_KEY)
      if (sid) {
        await db('identity').from('user_sessions').update({ log_out_time_utc: new Date().toISOString() }).eq('session_id', sid)
        localStorage.removeItem(SESSION_KEY)
      }
      await supabase.auth.signOut()
    }
    qc.clear()
    setProfile(null)
    setIsPreview(false)
    setStatus('signed-out')
  }, [qc])

  const startPreview = useCallback(
    async (userId: string) => {
      if (!DEV_PREVIEW_ENABLED) return
      sessionStorage.setItem(PREVIEW_KEY, userId)
      setStatus('loading')
      await applyProfile(userId, null, true)
    },
    [applyProfile],
  )

  const portal = useMemo(() => (profile ? resolvePortal(profile.role?.role_name, profile.org?.org_type) : null), [profile])

  const value = useMemo<AuthContextValue>(
    () => ({ status, profile, portal, isPreview, notice, signIn, signOut, startPreview, clearNotice: () => setNotice(null) }),
    [status, profile, portal, isPreview, notice, signIn, signOut, startPreview],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used inside <AuthProvider>')
  return ctx
}

/** The signed-in profile; only call inside portal screens (always signed in there). */
export function useProfile(): Profile {
  const { profile } = useAuth()
  if (!profile) throw new Error('No profile')
  return profile
}
