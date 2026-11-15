import { keepPreviousData, useQuery } from '@tanstack/react-query'
import { db } from '@/lib/supabase'
import type { AuditLog } from '@/lib/types'
import type { Severity } from '@/lib/domain'

const AUDIT_COLS = 'log_id,user_id,action_type,source_module,event_payload,ip_address,log_time_stamp_utc'

/** Every audit event (paged past the 1000-row cap) for aggregation and charts. */
export function useAuditAll(opts: { refetchInterval?: number } = {}) {
  return useQuery({
    queryKey: ['audit', 'all'],
    queryFn: async () => {
      const rows: AuditLog[] = []
      for (let from = 0; ; from += 1000) {
        const { data, error } = await db('identity')
          .from('auth_audit_logs')
          .select(AUDIT_COLS)
          .order('log_time_stamp_utc', { ascending: false })
          .range(from, from + 999)
        if (error) throw error
        rows.push(...((data ?? []) as AuditLog[]))
        if (!data || data.length < 1000) break
      }
      return rows
    },
    ...opts,
  })
}

/** The latest N events, optionally limited to some modules / actions (live feeds). */
export function useAuditFeed(params: { modules?: string[]; actions?: string[]; limit?: number }, opts: { refetchInterval?: number } = {}) {
  const { modules, actions, limit = 12 } = params
  return useQuery({
    queryKey: ['audit', 'feed', modules ?? null, actions ?? null, limit],
    queryFn: async () => {
      let q = db('identity').from('auth_audit_logs').select(AUDIT_COLS).order('log_time_stamp_utc', { ascending: false }).limit(limit)
      if (modules?.length) q = q.in('source_module', modules)
      if (actions?.length) q = q.in('action_type', actions)
      const { data, error } = await q
      if (error) throw error
      return (data ?? []) as AuditLog[]
    },
    ...opts,
  })
}

export interface AuditFilters {
  module: string
  action: string
  severity: Severity | ''
  userId: string
  search: string
  from: string
  to: string
}

export const EMPTY_AUDIT_FILTERS: AuditFilters = { module: '', action: '', severity: '', userId: '', search: '', from: '', to: '' }

// Severities derived from the action type when the payload carries none (see domain.severityOf)
const DERIVED: Record<Exclude<Severity, 'INFO'>, string[]> = {
  CRITICAL: ['GLOBAL_RECALL_INITIATED', 'CRITICAL_SPEC_TAMPERING'],
  HIGH: ['DRUGS_DESTROYED', 'TEMPERATURE_BREACH', 'RBAC_PERMISSION_GRANTED', 'RBAC_PERMISSION_REVOKED', 'USER_DEACTIVATED', 'ORG_DEACTIVATED'],
  MEDIUM: ['API_KEY_ROTATED'],
  LOW: ['BATCH_STATUS_CHANGE', 'SESSION_EXPIRED'],
}

const sanitize = (s: string) => s.replace(/[(),*%]/g, ' ').trim()

/** Server-side filtered, paginated view of the ledger. */
export function useAuditPage(filters: AuditFilters, page: number, pageSize: number) {
  return useQuery({
    queryKey: ['audit', 'page', filters, page, pageSize],
    placeholderData: keepPreviousData,
    queryFn: async () => {
      let q = db('identity')
        .from('auth_audit_logs')
        .select(AUDIT_COLS, { count: 'exact' })
        .order('log_time_stamp_utc', { ascending: false })
      if (filters.module) q = q.eq('source_module', filters.module)
      if (filters.action) q = q.eq('action_type', filters.action)
      if (filters.userId) q = q.eq('user_id', filters.userId)
      if (filters.from) q = q.gte('log_time_stamp_utc', `${filters.from}T00:00:00`)
      if (filters.to) q = q.lte('log_time_stamp_utc', `${filters.to}T23:59:59.999`)
      if (filters.severity) {
        if (filters.severity === 'INFO') {
          const all = Object.values(DERIVED).flat().join(',')
          q = q.is('event_payload->>severity', null).not('action_type', 'in', `(${all})`)
        } else {
          const derived = DERIVED[filters.severity]
          q = q.or(`event_payload->>severity.eq.${filters.severity},and(event_payload->>severity.is.null,action_type.in.(${derived.join(',')}))`)
        }
      }
      const term = sanitize(filters.search)
      if (term) {
        q = q.or(
          [
            `action_type.ilike.*${term}*`,
            `source_module.ilike.*${term}*`,
            `ip_address.ilike.*${term}*`,
            `event_payload->>batch_number.ilike.*${term}*`,
            `event_payload->>description.ilike.*${term}*`,
            `event_payload->>reason.ilike.*${term}*`,
          ].join(','),
        )
      }
      const fromRow = page * pageSize
      const { data, error, count } = await q.range(fromRow, fromRow + pageSize - 1)
      if (error) throw error
      return { rows: (data ?? []) as AuditLog[], total: count ?? 0 }
    },
  })
}

/** Distinct action types (for the ledger filter). */
export function useAuditActionTypes() {
  return useQuery({
    queryKey: ['audit', 'action-types'],
    staleTime: 5 * 60_000,
    queryFn: async () => {
      const seen = new Set<string>()
      for (let from = 0; ; from += 1000) {
        const { data, error } = await db('identity').from('auth_audit_logs').select('action_type').range(from, from + 999)
        if (error) throw error
        for (const r of data ?? []) seen.add((r as { action_type: string }).action_type)
        if (!data || data.length < 1000) break
      }
      return [...seen].sort()
    },
  })
}

/** Ledger events that mention one batch (by number or id). */
export function useAuditForBatch(batchNumber: string | undefined, batchId: number | undefined) {
  return useQuery({
    enabled: Boolean(batchNumber),
    queryKey: ['audit', 'batch', batchNumber, batchId],
    queryFn: async () => {
      const { data, error } = await db('identity')
        .from('auth_audit_logs')
        .select(AUDIT_COLS)
        .or(`event_payload->>batch_number.eq."${batchNumber}",event_payload->>batch_id.eq."${batchId}"`)
        .order('log_time_stamp_utc', { ascending: true })
        .limit(200)
      if (error) throw error
      return (data ?? []) as AuditLog[]
    },
  })
}
