// Turns Postgres / PostgREST / Auth errors into messages a person can act on.
// Errors raised by the database's own triggers (RAISE EXCEPTION -> code P0001)
// are surfaced as "blocked by a database rule": they are the governance layer
// of the project working as designed, and worth showing off.

export type DbErrorKind =
  | 'rule'
  | 'constraint'
  | 'duplicate'
  | 'reference'
  | 'permission'
  | 'network'
  | 'auth'
  | 'unknown'

export interface FriendlyError {
  kind: DbErrorKind
  title: string
  message: string
  raw?: string
}

const CONSTRAINT_TEXT: Record<string, string> = {
  chk_batch_dates: 'Expiry date must be later than the manufacturing date.',
  chk_quantity: 'Quantity produced must be greater than zero.',
  chk_batch_status: 'That batch status is not allowed.',
  batch_master_batch_number_key: 'A batch with this batch number already exists.',
  uq_brand_name: 'A medicine with this brand name already exists.',
  uq_medicine_composition: 'This medicine already has a composition record.',
  uq_medicine_packaging: 'This medicine already has packaging standards.',
  uq_medicine_spec: 'This medicine already has a quality specification.',
  chk_category_standard: 'That medicine category is not one of the approved categories.',
  organisations_reg_no_key: 'An organisation with this registration number already exists.',
  organisations_contact_email_key: 'An organisation with this contact email already exists.',
  chk_org_type: 'Organisation type must be Manufacturer, Distributor, Transporter, Retailer or Regulatory Body.',
  sales_orders_check: 'Expected delivery date must be after the order date.',
  sales_orders_order_status_check: 'That order status is not allowed.',
  shipping_manifest_check: 'Estimated arrival must be after the dispatch time.',
  chk_available_qty: 'Not enough stock at the source location for this movement.',
  chk_qty_moved: 'Quantity moved must be greater than zero.',
  chk_movement_logic: 'A stock movement needs a source or a destination.',
  chk_return_qty: 'Return quantity must be greater than zero.',
  chk_return_status: 'That return status is not allowed.',
  return_stock_assessments_return_id_key: 'This return has already been assessed.',
  disposal_certificates_assessment_id_key: 'A disposal certificate already exists for this assessment.',
  chk_disposal_method: 'Disposal method must be Incineration, Chemical Neutralization or Bio-Hazard Landfill.',
  vehicle_fleet_registry_vehicle_no_key: 'A vehicle with this registration number already exists.',
  vehicle_fleet_registry_vehicle_type_check: 'Vehicle type must be Truck, Van or Reefer.',
  roles_role_name_key: 'A role with this name already exists.',
  permissions_action_name_key: 'A permission with this action name already exists.',
  chk_module_category: 'Module category must be one of IDENTITY, PRODUCT, WAREHOUSE, FULFILLMENT, FINANCE, RECALL.',
  role_permissions_pkey: 'This role already has that permission.',
  uq_inventory_location_batch: 'This batch already has a stock row at that location.',
  chk_temp_logic: 'Minimum temperature must be lower than the maximum.',
  chk_capacity: 'Capacity must be greater than zero.',
  chk_humidity: 'Humidity limit must be between 0 and 100%.',
  chk_location_humidity: 'Humidity limit must be between 0 and 100%.',
  chk_humidity_range: 'Humidity reading must be between 0 and 100%.',
  chk_fragility: 'Fragility index must be between 1 and 10.',
  chk_ph_range: 'pH must be between 0 and 14.',
  chk_purity_range: 'Purity must be between 0 and 100%.',
  chk_refund_amount: 'Refund amount cannot be negative.',
  chk_zone_type: 'Zone type must be Cold Storage or General.',
  order_items_quantity_check: 'Quantity must be greater than zero.',
  order_items_unit_price_check: 'Unit price cannot be negative.',
  chk_quarantine_status: 'That status is not allowed.',
  chk_channel: 'Channel must be Email, SMS, System Alert or Registered Post.',
  chk_delivery_status: 'That delivery status is not allowed.',
  delivery_proof_receipt_received_condition_check: 'Condition must be Good, Damaged or Partial.',
  financial_aggregate_org_id_report_date_key: 'A report for this organisation and date already exists.',
}

interface PgLikeError {
  code?: string
  message?: string
  details?: string | null
  hint?: string | null
  name?: string
  status?: number
}

export function describeError(e: unknown): FriendlyError {
  const err = (e ?? {}) as PgLikeError
  const message = (err.message ?? String(e ?? 'Unknown error')).trim()
  const code = err.code ?? ''

  // An update that matched no rows (mustChange in data/actions.ts)
  if (err.name === 'NothingChangedError') {
    return {
      kind: 'permission',
      title: 'Nothing was changed',
      message: 'The record may have just been changed by someone else, or the database does not let your organisation change it. The page has been refreshed.',
      raw: message,
    }
  }
  // Network / offline
  if (/failed to fetch|networkerror|load failed|network request failed/i.test(message)) {
    return { kind: 'network', title: 'Cannot reach the server', message: 'Check your internet connection and try again.', raw: message }
  }

  // Supabase Auth errors
  if (err.name?.startsWith('Auth') || /invalid login credentials|email not confirmed|user not found/i.test(message)) {
    const m = /invalid login credentials/i.test(message)
      ? 'The email or password is incorrect.'
      : /email not confirmed/i.test(message)
        ? 'This account has not confirmed its email address yet.'
        : message
    return { kind: 'auth', title: 'Sign-in failed', message: m, raw: message }
  }

  // Trigger-raised governance rules
  if (code === 'P0001') {
    const title = /^SAFETY LOCK/i.test(message)
      ? 'Safety lock engaged'
      : /^INVENTORY ERROR/i.test(message)
        ? 'Inventory check failed'
        : /Governance/i.test(message)
          ? 'Governance rule enforced'
          : 'Blocked by a database rule'
    const clean = message.replace(/^(SAFETY LOCK|INVENTORY ERROR|Governance Violation|Lethe Governance Protocol)\s*:\s*/i, '')
    return { kind: 'rule', title, message: clean, raw: message }
  }

  const constraint = /constraint "([^"]+)"/.exec(message)?.[1]
  if (code === '23505') {
    return { kind: 'duplicate', title: 'Already exists', message: (constraint && CONSTRAINT_TEXT[constraint]) || 'A record with these details already exists.', raw: message }
  }
  if (code === '23514') {
    return { kind: 'constraint', title: 'Value not allowed', message: (constraint && CONSTRAINT_TEXT[constraint]) || message, raw: message }
  }
  if (code === '23503') {
    return { kind: 'reference', title: 'Linked record problem', message: 'This record is linked to data that is missing or still in use.', raw: message }
  }
  if (code === '23502') {
    const col = /column "([^"]+)"/.exec(message)?.[1]
    return { kind: 'constraint', title: 'Missing value', message: col ? `“${col}” is required.` : message, raw: message }
  }
  // Row-level security (supabase/rls.sql) refused the new or changed row
  if (code === '42501' && /row-level security/i.test(message)) {
    return { kind: 'permission', title: 'Blocked by row-level security', message: 'The database only lets your organisation create or change the records it is responsible for.', raw: message }
  }
  if (code === '42501' || err.status === 401 || err.status === 403) {
    return { kind: 'permission', title: 'Not allowed', message: 'Your account does not have permission for this action.', raw: message }
  }
  if (code === '22P02' || code === '22007' || code === '22008') {
    return { kind: 'constraint', title: 'Invalid value', message, raw: message }
  }
  return { kind: 'unknown', title: 'Something went wrong', message, raw: message }
}
