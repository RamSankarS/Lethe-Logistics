// Row types mirroring the Supabase schemas (see dump.sql).
// IDs: bigint identity columns arrive as numbers, uuid columns as strings.

export type UUID = string
export type ISODate = string // yyyy-mm-dd
export type ISOTime = string // timestamptz

// ── identity_mod ──────────────────────────────────────────────────────────
export type OrgType = 'Manufacturer' | 'Distributor' | 'Transporter' | 'Retailer' | 'Regulatory_Body'

export interface Organisation {
  org_id: UUID
  org_name: string
  org_type: OrgType
  reg_no: string
  contact_email: string
  is_active: boolean
  created_at_utc: ISOTime
}

export interface Role {
  role_id: UUID
  role_name: string
  description: string | null
}

export type ModuleCategory = 'IDENTITY' | 'PRODUCT' | 'WAREHOUSE' | 'FULFILLMENT' | 'FINANCE' | 'RECALL'

export interface Permission {
  permission_id: UUID
  module_category: ModuleCategory
  action_name: string
}

export interface RolePermission {
  role_id: UUID
  permission_id: UUID
}

export interface AppUser {
  user_id: UUID
  org_id: UUID | null
  role_id: UUID | null
  password_hash?: string
  first_name: string
  last_name: string
  is_active: boolean
  created_at_utc: ISOTime
}

export interface UserSession {
  session_id: UUID
  user_id: UUID | null
  ip_address: string | null
  login_time_utc: ISOTime
  log_out_time_utc: ISOTime | null
}

export interface AuditLog {
  log_id: UUID
  user_id: UUID | null
  action_type: string
  source_module: string
  event_payload: Record<string, unknown> | null
  ip_address: string | null
  log_time_stamp_utc: ISOTime
}

// ── product_and_batch_intelligence ────────────────────────────────────────
export type MedicineCategory =
  | 'Antibiotic' | 'Analgesic' | 'Vaccine' | 'Anti-Diabetic' | 'Statin' | 'Antacid'
  | 'Antihypertensive' | 'Hormone' | 'Antihistamine' | 'NSAID' | 'Immunomodulatory'

export interface Medicine {
  medicine_id: number
  brand_name: string
  generic_name: string
  category: MedicineCategory
  is_active: boolean
  created_at: ISOTime
}

export type BatchStatus = 'Pending' | 'Released' | 'Quality-Check' | 'Rejected' | 'Recalled'

export interface Batch {
  batch_id: number
  medicine_id: number | null
  manufacturer_id: UUID
  registered_by_user_id: UUID
  batch_number: string
  mfg_date: ISODate
  expiry_date: ISODate
  quantity_produced: number
  status: BatchStatus
  created_at: ISOTime
}

export interface ChemicalComposition {
  composition_id: number
  medicine_id: number
  active_ingredient: string
  strength: string
  dosage_form: string
}

export interface PackagingStandard {
  packaging_id: number
  medicine_id: number
  min_temp_celsius: number
  max_temp_celsius: number
  humidity_limit: number
  fragility_index: number
}

export interface QualitySpec {
  spec_id: number
  medicine_id: number
  purity_threshold: number
  dissolution_rate: string
  ph_balance_req: number
  required_certs: string
}

// ── smart_warehousing ─────────────────────────────────────────────────────
export interface Warehouse {
  warehouse_id: number
  warehouse_name: string
  city: string
  state: string
  manager_user_id: UUID
  is_active: boolean
}

export type ZoneType = 'Cold Storage' | 'General'

export interface StorageLocation {
  location_id: number
  warehouse_id: number
  zone_type: ZoneType
  target_min_temp: number
  target_max_temp: number
  max_capacity: number
  is_active: boolean
  target_humidity_limit: number
}

export interface InventoryRow {
  inventory_id: number
  location_id: number
  batch_id: number
  available_quantity: number
  last_verified_by: UUID
  last_update: ISOTime
}

export type MovementType = 'Inbound' | 'Internal' | 'Outbound'

export interface StockMovement {
  movement_id: number
  batch_id: number
  source_location_id: number | null
  destination_location_id: number | null
  user_id: UUID
  quantity_moved: number
  movement_type: MovementType
  moved_at: ISOTime
}

export interface SensorLog {
  log_id: number
  location_id: number
  temperature_celsius: number
  humidity_percentage: number
  recorded_at: ISOTime
}

export type QuarantineStatus = 'Active' | 'Cleared' | 'Destroyed'

export interface QuarantineLog {
  quarantine_id: number
  batch_id: number
  location_id: number
  quarantine_reason: 'Temp Breach' | 'Expired'
  breaching_log_id: number | null
  action_taken_by: UUID
  status: QuarantineStatus
}

/** smart_warehousing.vw_location_load (created by supabase/rls.sql): units per zone, no batch detail. */
export interface LocationLoad {
  location_id: number
  units_stored: number
}

// ── forward_fulfillment ───────────────────────────────────────────────────
export type OrderStatus = 'Pending' | 'Approved' | 'Shipped' | 'Delivered' | 'Cancelled'

export interface SalesOrder {
  order_id: number
  buyer_org_id: UUID
  order_date: ISODate
  order_status: OrderStatus
  expected_del_date: ISODate | null
  created_at_utc: ISOTime
  updated_at_utc: ISOTime
}

export interface OrderItem {
  order_item_id: number
  order_id: number
  batch_id: number
  quantity: number
  unit_price: number
  created_at_utc: ISOTime
}

export type ManifestStatus = 'In-Transit' | 'Delivered' | 'Delayed'

export interface ShippingManifest {
  manifest_id: number
  order_id: number
  vehicle_id: number
  driver_user_id: UUID
  dispatch_time_utc: ISOTime
  estimated_arrival_time: ISOTime | null
  manifest_status: ManifestStatus
}

export type ReceivedCondition = 'Good' | 'Damaged' | 'Partial'

export interface DeliveryReceipt {
  receipt_id: number
  order_id: number
  received_by_user_id: UUID
  delivery_time: ISOTime
  received_condition: ReceivedCondition
  digital_signature: string
  remarks: string | null
}

export type VehicleType = 'Truck' | 'Van' | 'Reefer'

export interface Vehicle {
  vehicle_id: number
  vehicle_no: string
  vehicle_type: VehicleType
  transporter_org_id: UUID
  created_at_utc: ISOTime
}

// ── reverse_logistics ─────────────────────────────────────────────────────
export type RecallStatus = 'Active' | 'Resolved' | 'Cancelled'

export interface Recall {
  recall_id: number
  batch_id: number
  initiated_by_org_id: UUID
  recall_reason: string
  quarantine_status: RecallStatus
  created_at_utc: ISOTime
}

export type CommChannel = 'Email' | 'SMS' | 'System_Alert' | 'Registered_Post'
export type CommStatus = 'Pending' | 'Delivered' | 'Failed' | 'Read'

export interface RecallComm {
  log_id: number
  recall_id: number
  notified_org_id: UUID
  channel: CommChannel
  delivery_status: CommStatus
  sent_at_utc: ISOTime
}

export type ReturnStatus = 'Initiated' | 'In_Transit' | 'Received' | 'Assessed' | 'Closed'

export interface ReturnRequest {
  return_id: number
  returner_org_id: UUID
  batch_id: number
  recall_id: number | null
  quantity_returned: number
  return_reason: string
  status: ReturnStatus
  created_at_utc: ISOTime
}

export type Disposition = 'Approve_Refund_and_Destroy' | 'Approve_Refund_and_Restock' | 'Reject_Claim'

export interface ReturnAssessment {
  assessment_id: number
  return_id: number
  inspector_user_id: UUID
  inspection_result: string
  disposition_action: Disposition
  assessed_at_utc: ISOTime
}

export type RefundStatus = 'Pending_Payout' | 'Processed' | 'Failed'

export interface RefundVoucher {
  voucher_id: number
  return_id: number
  refund_amount: number
  refund_status: RefundStatus
  issued_at_utc: ISOTime
}

export type DisposalMethod = 'Incineration' | 'Chemical_Neutralization' | 'Bio-Hazard_Landfill'

export interface DisposalCertificate {
  certificate_id: number
  assessment_id: number
  witness_user_id: UUID
  disposal_method: DisposalMethod
  evidence_hash: string
  disposed_at_utc: ISOTime
}

// ── financial_analytics ───────────────────────────────────────────────────
export type PaymentStatus = 'Pending' | 'Completed' | 'Failed' | 'Refunded'

export interface Payment {
  payment_id: UUID
  order_id: number
  payer_org_id: UUID
  payee_org_id: UUID
  base_amount: number
  tax_percentage: number
  total_transaction_amount: number
  payment_status: PaymentStatus
  created_at_utc: ISOTime
}

export interface FinancialReport {
  report_id: UUID
  org_id: UUID
  report_date: ISODate
  total_orders: number
  total_gross_revenue: number
  total_tax_liability: number
  net_revenue: number
  generated_by_user_id: UUID
  created_at_utc: ISOTime
}

export type LossCategory = 'Spoilage' | 'Damage' | 'Recall' | 'Theft' | 'Disposal'

export interface LossRecord {
  loss_record_id: UUID
  org_id: UUID
  batch_id: number
  recall_id: number | null
  quantity_lost: number
  unit_cost_at_loss: number
  total_financial_loss: number
  loss_category: LossCategory
  created_at_utc: ISOTime
}

export interface RiskHeatmapRow {
  department: string
  total_events: number
  critical_violations: number
  high_risk_warnings: number
  last_violation_time: ISOTime
}

export interface ColdChainViolationRow {
  violation_date: ISODate
  action_type: string
  resulting_action: string | null
  incident_count: number
}

export interface NonComplianceCostRow {
  recall_id: number
  recall_reason: string
  total_refunds_issued: number
  total_financial_loss: number
  recall_date: ISOTime
}
