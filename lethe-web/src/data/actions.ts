import { useCallback, useState } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { db } from '@/lib/supabase'
import { notifyError, notifySuccess } from '@/lib/notify'
import { useAuth } from '@/auth/AuthProvider'

/** Unwraps a Supabase response, throwing its error. */
export function unwrap<T>(res: { data: T | null; error: unknown }): T {
  if (res.error) throw res.error
  return res.data as T
}

/** An UPDATE/DELETE that matched no rows (see mustChange). */
export class NothingChangedError extends Error {
  constructor() {
    super('No rows were changed.')
    this.name = 'NothingChangedError'
  }
}

/**
 * Awaits an UPDATE or DELETE built with `.select(...)` and throws if it changed
 * nothing. Under row-level security a write the database does not allow simply
 * matches no rows (no error), and a record someone else just changed may no
 * longer match its filter, so without this check the app would report success.
 */
export async function mustChange(query: PromiseLike<{ data: unknown; error: unknown }>): Promise<void> {
  const { data, error } = await query
  if (error) throw error
  if (!Array.isArray(data) || data.length === 0) throw new NothingChangedError()
}

export type RunResult<T> = { ok: true; value: T } | { ok: false; error: unknown }

/**
 * Runs a write against the database with consistent UX:
 * busy state, success toast, friendly error toast, and a full cache refresh
 * afterwards (triggers often change other tables, e.g. batch status or the audit log).
 */
export function useRunner() {
  const qc = useQueryClient()
  const { isPreview } = useAuth()
  const [busy, setBusy] = useState<string | null>(null)

  const run = useCallback(
    async <T,>(id: string, fn: () => Promise<T>, opts: { success?: string; description?: string } = {}): Promise<RunResult<T>> => {
      if (isPreview) {
        toast.warning('Preview mode is read-only', { description: 'Sign in with a real account to make changes.' })
        return { ok: false, error: new Error('preview') }
      }
      setBusy(id)
      try {
        const value = await fn()
        if (opts.success) notifySuccess(opts.success, opts.description)
        await qc.invalidateQueries()
        return { ok: true, value }
      } catch (error) {
        notifyError(error)
        await qc.invalidateQueries()
        return { ok: false, error }
      } finally {
        setBusy(null)
      }
    },
    [qc, isPreview],
  )

  return { run, busy, isBusy: (id: string) => busy === id }
}

export type AuditModule =
  | 'IDENTITY'
  | 'PRODUCT_INTELLIGENCE'
  | 'WAREHOUSE_OPS'
  | 'FORWARD_FULFILLMENT'
  | 'REVERSE_LOGISTICS'
  | 'FINANCIAL_ANALYTICS'

/**
 * Appends an event to the immutable governance ledger (identity_mod.auth_audit_logs).
 * Used for actions that have no database trigger of their own. Never throws.
 */
export async function logEvent(
  userId: string | null | undefined,
  action: string,
  module: AuditModule,
  payload: Record<string, unknown> = {},
) {
  try {
    const { error } = await db('identity').from('auth_audit_logs').insert({
      user_id: userId ?? null,
      action_type: action,
      source_module: module,
      event_payload: payload,
      ip_address: 'web-client',
    })
    if (error) console.warn('[audit] could not write event', action, error)
  } catch (e) {
    console.warn('[audit] could not write event', action, e)
  }
}
