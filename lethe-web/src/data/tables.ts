// Registry of every table/view the frontend reads, with its schema and default ordering.
import type { SchemaKey } from '@/lib/supabase'
import type * as T from '@/lib/types'

export interface TableDef {
  schema: SchemaKey
  table: string
  select?: string
  order?: { column: string; ascending?: boolean }
}

export const TABLES = {
  // identity_mod
  organisations: { schema: 'identity', table: 'organisations', order: { column: 'org_name', ascending: true } },
  roles: { schema: 'identity', table: 'roles', order: { column: 'role_name', ascending: true } },
  permissions: { schema: 'identity', table: 'permissions', order: { column: 'module_category', ascending: true } },
  rolePermissions: { schema: 'identity', table: 'role_permissions' },
  // password_hash is deliberately never fetched to the browser
  users: { schema: 'identity', table: 'users', select: 'user_id,org_id,role_id,first_name,last_name,is_active,created_at_utc', order: { column: 'created_at_utc', ascending: false } },
  sessions: { schema: 'identity', table: 'user_sessions', order: { column: 'login_time_utc', ascending: false } },

  // product_and_batch_intelligence
  medicines: { schema: 'product', table: 'medicines', order: { column: 'medicine_id', ascending: true } },
  batches: { schema: 'product', table: 'batch_master', order: { column: 'batch_id', ascending: true } },
  compositions: { schema: 'product', table: 'chemical_compositions', order: { column: 'composition_id', ascending: true } },
  packaging: { schema: 'product', table: 'packaging_standards', order: { column: 'packaging_id', ascending: true } },
  specs: { schema: 'product', table: 'quality_check_specs', order: { column: 'spec_id', ascending: true } },

  // smart_warehousing
  warehouses: { schema: 'warehouse', table: 'warehouse', order: { column: 'warehouse_id', ascending: true } },
  locations: { schema: 'warehouse', table: 'storage_location', order: { column: 'location_id', ascending: true } },
  inventory: { schema: 'warehouse', table: 'inventory', order: { column: 'inventory_id', ascending: true } },
  movements: { schema: 'warehouse', table: 'stock_movement_history', order: { column: 'moved_at', ascending: false } },
  sensorLogs: { schema: 'warehouse', table: 'environmental_sensor_logs', order: { column: 'recorded_at', ascending: true } },
  quarantine: { schema: 'warehouse', table: 'quarantine_area_logs', order: { column: 'quarantine_id', ascending: false } },
  // capacity totals per zone; only exists once supabase/rls.sql has been run
  locationLoad: { schema: 'warehouse', table: 'vw_location_load', order: { column: 'location_id', ascending: true } },

  // forward_fulfillment
  orders: { schema: 'fulfillment', table: 'sales_orders', order: { column: 'order_id', ascending: false } },
  orderItems: { schema: 'fulfillment', table: 'order_items', order: { column: 'order_item_id', ascending: true } },
  manifests: { schema: 'fulfillment', table: 'shipping_manifest', order: { column: 'dispatch_time_utc', ascending: false } },
  receipts: { schema: 'fulfillment', table: 'delivery_proof_receipt', order: { column: 'delivery_time', ascending: false } },
  vehicles: { schema: 'fulfillment', table: 'vehicle_fleet_registry', order: { column: 'vehicle_id', ascending: true } },

  // reverse_logistics
  recalls: { schema: 'reverse', table: 'global_recall_ledger', order: { column: 'created_at_utc', ascending: false } },
  recallComms: { schema: 'reverse', table: 'recall_communication_logs', order: { column: 'sent_at_utc', ascending: false } },
  returns: { schema: 'reverse', table: 'return_requests', order: { column: 'created_at_utc', ascending: false } },
  assessments: { schema: 'reverse', table: 'return_stock_assessments', order: { column: 'assessed_at_utc', ascending: false } },
  refunds: { schema: 'reverse', table: 'refund_vouchers', order: { column: 'issued_at_utc', ascending: false } },
  disposals: { schema: 'reverse', table: 'disposal_certificates', order: { column: 'disposed_at_utc', ascending: false } },

  // financial_analytics
  payments: { schema: 'finance', table: 'payment_ledger', order: { column: 'created_at_utc', ascending: false } },
  reports: { schema: 'finance', table: 'financial_aggregate', order: { column: 'report_date', ascending: true } },
  losses: { schema: 'finance', table: 'loss_analytics_data', order: { column: 'created_at_utc', ascending: false } },
  vwColdChain: { schema: 'finance', table: 'vw_cold_chain_violations', order: { column: 'violation_date', ascending: true } },
  vwRiskHeatmap: { schema: 'finance', table: 'vw_compliance_risk_heatmap' },
  vwNonCompliance: { schema: 'finance', table: 'vw_cost_of_non_compliance' },
} as const satisfies Record<string, TableDef>

export type TableKey = keyof typeof TABLES

export interface RowMap {
  organisations: T.Organisation
  roles: T.Role
  permissions: T.Permission
  rolePermissions: T.RolePermission
  users: T.AppUser
  sessions: T.UserSession
  medicines: T.Medicine
  batches: T.Batch
  compositions: T.ChemicalComposition
  packaging: T.PackagingStandard
  specs: T.QualitySpec
  warehouses: T.Warehouse
  locations: T.StorageLocation
  inventory: T.InventoryRow
  movements: T.StockMovement
  sensorLogs: T.SensorLog
  quarantine: T.QuarantineLog
  locationLoad: T.LocationLoad
  orders: T.SalesOrder
  orderItems: T.OrderItem
  manifests: T.ShippingManifest
  receipts: T.DeliveryReceipt
  vehicles: T.Vehicle
  recalls: T.Recall
  recallComms: T.RecallComm
  returns: T.ReturnRequest
  assessments: T.ReturnAssessment
  refunds: T.RefundVoucher
  disposals: T.DisposalCertificate
  payments: T.Payment
  reports: T.FinancialReport
  losses: T.LossRecord
  vwColdChain: T.ColdChainViolationRow
  vwRiskHeatmap: T.RiskHeatmapRow
  vwNonCompliance: T.NonComplianceCostRow
}
