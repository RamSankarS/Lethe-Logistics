import { createClient, type SupabaseClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL as string | undefined
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY as string | undefined

export const isSupabaseConfigured = Boolean(url && key)

/** Main client: carries the signed-in user's session. */
export const supabase: SupabaseClient = createClient(url ?? 'http://localhost:54321', key ?? 'missing-key', {
  auth: { persistSession: true, autoRefreshToken: true, storageKey: 'lethe-auth' },
})

/**
 * Throw-away client used only by the SysAdmin "provision user" flow.
 * Signing a new user up with it never touches the admin's own session.
 */
export function createIsolatedClient(): SupabaseClient {
  return createClient(url ?? 'http://localhost:54321', key ?? 'missing-key', {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false, storageKey: 'lethe-provision' },
  })
}

/** The six domain schemas exposed through the Supabase Data API. */
export const SCHEMAS = {
  identity: 'identity_mod',
  product: 'product_and_batch_intelligence',
  warehouse: 'smart_warehousing',
  fulfillment: 'forward_fulfillment',
  reverse: 'reverse_logistics',
  finance: 'financial_analytics',
} as const

export type SchemaKey = keyof typeof SCHEMAS

/** Query builder scoped to one schema: `db('product').from('batch_master')`. */
export const db = (schema: SchemaKey) => supabase.schema(SCHEMAS[schema])
