// Business vocabulary shared by every portal: allowed values (mirroring the
// database CHECK constraints), status tones, workflow transitions and the
// cold-chain compatibility rules the database triggers enforce.

import type {
  AuditLog,
  Batch,
  BatchStatus,
  CommStatus,
  Disposition,
  ManifestStatus,
  MedicineCategory,
  OrderStatus,
  OrgType,
  PackagingStandard,
  PaymentStatus,
  QuarantineStatus,
  RecallStatus,
  RefundStatus,
  ReturnStatus,
  SensorLog,
  StorageLocation,
} from './types'

export type Tone = 'neutral' | 'info' | 'good' | 'warn' | 'serious' | 'critical' | 'accent'

export interface StatusMeta {
  label: string
  tone: Tone
  hint?: string
}

// ── Allowed values (CHECK constraints) ────────────────────────────────────
export const ORG_TYPES: OrgType[] = ['Manufacturer', 'Distributor', 'Transporter', 'Retailer', 'Regulatory_Body']
export const MEDICINE_CATEGORIES: MedicineCategory[] = [
  'Antibiotic', 'Analgesic', 'Vaccine', 'Anti-Diabetic', 'Statin', 'Antacid',
  'Antihypertensive', 'Hormone', 'Antihistamine', 'NSAID', 'Immunomodulatory',
]
export const VEHICLE_TYPES = ['Truck', 'Van', 'Reefer'] as const
export const DISPOSAL_METHODS = ['Incineration', 'Chemical_Neutralization', 'Bio-Hazard_Landfill'] as const
export const COMM_CHANNELS = ['System_Alert', 'Email', 'SMS', 'Registered_Post'] as const
export const MODULE_CATEGORIES = ['IDENTITY', 'PRODUCT', 'WAREHOUSE', 'FULFILLMENT', 'FINANCE', 'RECALL'] as const
export const RECEIVED_CONDITIONS = ['Good', 'Partial', 'Damaged'] as const

export const ORG_TYPE_LABEL: Record<OrgType, string> = {
  Manufacturer: 'Manufacturer',
  Distributor: 'Distributor',
  Transporter: 'Transporter',
  Retailer: 'Retailer',
  Regulatory_Body: 'Regulatory body',
}

// ── Status metadata ───────────────────────────────────────────────────────
export const BATCH_STATUS: Record<BatchStatus, StatusMeta> = {
  Pending: { label: 'Pending', tone: 'neutral', hint: 'Registered, awaiting quality check' },
  'Quality-Check': { label: 'Quality check', tone: 'warn', hint: 'Under inspection or quarantined' },
  Released: { label: 'Released', tone: 'good', hint: 'Cleared for sale and distribution' },
  Rejected: { label: 'Rejected', tone: 'critical', hint: 'Failed QC. Cannot re-enter the supply chain' },
  Recalled: { label: 'Recalled', tone: 'critical', hint: 'Withdrawn from market by recall' },
}

/** UI transitions, aligned with the tr_enforce_batch_workflow trigger. */
export const BATCH_TRANSITIONS: Record<BatchStatus, BatchStatus[]> = {
  Pending: ['Quality-Check', 'Rejected'],
  'Quality-Check': ['Released', 'Rejected'],
  Released: ['Quality-Check'],
  Rejected: [],
  Recalled: [],
}

export const ORDER_STATUS: Record<OrderStatus, StatusMeta> = {
  Pending: { label: 'Pending', tone: 'warn', hint: 'Awaiting distributor approval' },
  Approved: { label: 'Approved', tone: 'info', hint: 'Approved, waiting for dispatch' },
  Shipped: { label: 'Shipped', tone: 'accent', hint: 'On a vehicle, in transit' },
  Delivered: { label: 'Delivered', tone: 'good', hint: 'Signed for by the buyer' },
  Cancelled: { label: 'Cancelled', tone: 'neutral', hint: 'Cancelled before dispatch' },
}
export const ORDER_FLOW: OrderStatus[] = ['Pending', 'Approved', 'Shipped', 'Delivered']

export const MANIFEST_STATUS: Record<ManifestStatus, StatusMeta> = {
  'In-Transit': { label: 'In transit', tone: 'info' },
  Delivered: { label: 'Delivered', tone: 'good' },
  Delayed: { label: 'Delayed', tone: 'serious' },
}

export const RETURN_STATUS: Record<ReturnStatus, StatusMeta> = {
  Initiated: { label: 'Filed', tone: 'warn', hint: 'Return filed by the returning organisation' },
  In_Transit: { label: 'In transit', tone: 'info', hint: 'Picked up, heading to the depot' },
  Received: { label: 'Received', tone: 'accent', hint: 'At the depot, awaiting inspection' },
  Assessed: { label: 'Assessed', tone: 'serious', hint: 'Inspected, disposition decided' },
  Closed: { label: 'Closed', tone: 'good', hint: 'Refund, restock or disposal complete' },
}
export const RETURN_FLOW: ReturnStatus[] = ['Initiated', 'In_Transit', 'Received', 'Assessed', 'Closed']

export const RECALL_STATUS: Record<RecallStatus, StatusMeta> = {
  Active: { label: 'Active', tone: 'critical' },
  Resolved: { label: 'Resolved', tone: 'good' },
  Cancelled: { label: 'Cancelled', tone: 'neutral' },
}

export const COMM_STATUS: Record<CommStatus, StatusMeta> = {
  Read: { label: 'Acknowledged', tone: 'good' },
  Delivered: { label: 'Delivered', tone: 'info' },
  Pending: { label: 'Pending', tone: 'warn' },
  Failed: { label: 'Failed', tone: 'critical' },
}

export const QUARANTINE_STATUS: Record<QuarantineStatus, StatusMeta> = {
  Active: { label: 'Quarantined', tone: 'critical' },
  Cleared: { label: 'Cleared', tone: 'good' },
  Destroyed: { label: 'Destroyed', tone: 'neutral' },
}

export const REFUND_STATUS: Record<RefundStatus, StatusMeta> = {
  Pending_Payout: { label: 'Pending payout', tone: 'warn' },
  Processed: { label: 'Paid out', tone: 'good' },
  Failed: { label: 'Failed', tone: 'critical' },
}

export const PAYMENT_STATUS: Record<PaymentStatus, StatusMeta> = {
  Completed: { label: 'Completed', tone: 'good' },
  Pending: { label: 'Pending', tone: 'warn' },
  Failed: { label: 'Failed', tone: 'critical' },
  Refunded: { label: 'Refunded', tone: 'neutral' },
}

export const DISPOSITION: Record<Disposition, StatusMeta> = {
  Approve_Refund_and_Destroy: { label: 'Refund + destroy', tone: 'serious', hint: 'Unsafe stock: refund the claim and destroy under witness' },
  Approve_Refund_and_Restock: { label: 'Refund + restock', tone: 'info', hint: 'Stock is safe: refund and return it to saleable inventory' },
  Reject_Claim: { label: 'Claim rejected', tone: 'neutral', hint: 'Claim not valid: no refund' },
}

// ── Audit severity ────────────────────────────────────────────────────────
export type Severity = 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW' | 'INFO'
export const SEVERITIES: Severity[] = ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW', 'INFO']
export const SEVERITY_TONE: Record<Severity, Tone> = {
  CRITICAL: 'critical',
  HIGH: 'serious',
  MEDIUM: 'warn',
  LOW: 'info',
  INFO: 'neutral',
}

const ACTION_SEVERITY: Record<string, Severity> = {
  GLOBAL_RECALL_INITIATED: 'CRITICAL',
  CRITICAL_SPEC_TAMPERING: 'CRITICAL',
  DRUGS_DESTROYED: 'HIGH',
  TEMPERATURE_BREACH: 'HIGH',
  RBAC_PERMISSION_GRANTED: 'HIGH',
  RBAC_PERMISSION_REVOKED: 'HIGH',
  USER_DEACTIVATED: 'HIGH',
  ORG_DEACTIVATED: 'HIGH',
  API_KEY_ROTATED: 'MEDIUM',
  BATCH_STATUS_CHANGE: 'LOW',
  SESSION_EXPIRED: 'LOW',
}

export function severityOf(log: Pick<AuditLog, 'action_type' | 'event_payload'>): Severity {
  const s = String((log.event_payload as Record<string, unknown> | null)?.severity ?? '').toUpperCase()
  if (s === 'CRITICAL' || s === 'HIGH' || s === 'MEDIUM' || s === 'LOW') return s
  return ACTION_SEVERITY[log.action_type] ?? 'INFO'
}

export const MODULE_LABEL: Record<string, string> = {
  IDENTITY: 'Identity & access',
  PRODUCT_INTELLIGENCE: 'Product & batch',
  WAREHOUSE_OPS: 'Warehousing',
  FORWARD_FULFILLMENT: 'Fulfillment',
  REVERSE_LOGISTICS: 'Reverse logistics',
  FINANCIAL_ANALYTICS: 'Finance',
}
export const moduleLabel = (m: string) => MODULE_LABEL[m] ?? m.replace(/_/g, ' ').toLowerCase().replace(/^\w/, (c) => c.toUpperCase())

// ── Cold chain rules (mirror smart_warehousing triggers) ──────────────────
export const isColdChain = (pkg?: PackagingStandard | null) => !!pkg && pkg.max_temp_celsius <= 8

/**
 * Mirrors tr_prevent_env_mismatch: the shelf's temperature band must sit inside
 * the medicine's band and its baseline humidity must not exceed the medicine's limit.
 */
export function locationFits(loc: StorageLocation, pkg?: PackagingStandard | null): { ok: boolean; reason?: string } {
  if (!loc.is_active) return { ok: false, reason: 'Location is inactive' }
  if (!pkg) return { ok: true }
  if (Number(loc.target_min_temp) < Number(pkg.min_temp_celsius) || Number(loc.target_max_temp) > Number(pkg.max_temp_celsius)) {
    return { ok: false, reason: `Needs ${pkg.min_temp_celsius}–${pkg.max_temp_celsius}°C, shelf runs ${loc.target_min_temp}–${loc.target_max_temp}°C` }
  }
  if (Number(loc.target_humidity_limit) > Number(pkg.humidity_limit)) {
    return { ok: false, reason: `Shelf humidity ${loc.target_humidity_limit}% exceeds the ${pkg.humidity_limit}% limit` }
  }
  return { ok: true }
}

export type ReadingState = 'ok' | 'high' | 'low' | 'none'

export function readingState(reading: SensorLog | undefined, loc: StorageLocation): ReadingState {
  if (!reading) return 'none'
  if (reading.temperature_celsius > Number(loc.target_max_temp)) return 'high'
  if (reading.temperature_celsius < Number(loc.target_min_temp)) return 'low'
  return 'ok'
}

/** Latest sensor reading for every location. */
export function latestReadings(logs: SensorLog[]): Map<number, SensorLog> {
  const map = new Map<number, SensorLog>()
  for (const l of logs) {
    const cur = map.get(l.location_id)
    if (!cur || new Date(l.recorded_at) > new Date(cur.recorded_at) || (l.recorded_at === cur.recorded_at && l.log_id > cur.log_id)) {
      map.set(l.location_id, l)
    }
  }
  return map
}

export const isBreach = (reading: SensorLog, loc: StorageLocation) =>
  reading.temperature_celsius > Number(loc.target_max_temp) || reading.temperature_celsius < Number(loc.target_min_temp)

/** Batches a buyer can order: released and not expired. */
export const isSellable = (b: Batch, today = new Date()) => b.status === 'Released' && new Date(`${b.expiry_date}T23:59:59`) >= today

export const isExpired = (b: Pick<Batch, 'expiry_date'>, today = new Date()) => new Date(`${b.expiry_date}T23:59:59`) < today

/** Simple deterministic SHA-256 (hex) using Web Crypto, for signatures and evidence hashes. */
export async function sha256(text: string): Promise<string> {
  const buf = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(text))
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('')
}
