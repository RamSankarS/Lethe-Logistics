// The five portals. Each login is routed to exactly one portal, decided by the
// user's role and organisation type stored in identity_mod.
import type { LucideIcon } from 'lucide-react'
import {
  Activity,
  BadgeCheck,
  Boxes,
  Building2,
  ClipboardCheck,
  Factory,
  FileSearch,
  FlaskConical,
  Gauge,
  GitBranch,
  IndianRupee,
  KeyRound,
  LayoutDashboard,
  PackageCheck,
  PackageOpen,
  Radio,
  ScrollText,
  ShieldCheck,
  ShoppingCart,
  Siren,
  Snowflake,
  Store,
  Thermometer,
  Truck,
  Undo2,
  Users,
  Warehouse,
} from 'lucide-react'
import type { OrgType } from '@/lib/types'

export type PortalId = 'manufacturer' | 'distributor' | 'retailer' | 'compliance' | 'admin'

export interface TabMeta {
  id: string
  label: string
  icon: LucideIcon
  description: string
}

export interface PortalMeta {
  id: PortalId
  name: string
  short: string
  tagline: string
  icon: LucideIcon
  readOnly?: boolean
  tabs: TabMeta[]
}

export const PORTALS: Record<PortalId, PortalMeta> = {
  manufacturer: {
    id: 'manufacturer',
    name: 'Manufacturer Portal',
    short: 'Manufacturer',
    tagline: 'Production output, batch quality and network-wide recalls',
    icon: Factory,
    tabs: [
      { id: 'overview', label: 'Overview', icon: LayoutDashboard, description: 'Production output and batch health across the network' },
      { id: 'batches', label: 'Batches & QC', icon: FlaskConical, description: 'Register batches and move them through quality control' },
      { id: 'catalog', label: 'Medicine Catalog', icon: PackageOpen, description: 'Drug master data, composition, storage and QC standards' },
      { id: 'recalls', label: 'Recalls', icon: Siren, description: 'Initiate global recalls and track network acknowledgement' },
      { id: 'returns', label: 'Returns & Disposal', icon: Undo2, description: 'Inspect returned stock, issue refunds and disposal certificates' },
      { id: 'trace', label: 'Traceability', icon: GitBranch, description: 'Full pedigree of any batch, from production to disposal' },
      { id: 'revenue', label: 'Revenue', icon: IndianRupee, description: 'Invoices, monthly reports and batch-level profitability' },
    ],
  },
  distributor: {
    id: 'distributor',
    name: 'Distributor Portal',
    short: 'Distributor',
    tagline: 'Warehouse stock, cold chain and order fulfillment',
    icon: Warehouse,
    tabs: [
      { id: 'overview', label: 'Overview', icon: LayoutDashboard, description: 'Stock, capacity and alerts across the warehouse network' },
      { id: 'inventory', label: 'Inventory', icon: Boxes, description: 'Stock by warehouse, zone and bin; receive and move stock' },
      { id: 'coldchain', label: 'Cold Chain', icon: Thermometer, description: 'Live zone temperatures, sensor readings and quarantine' },
      { id: 'fulfillment', label: 'Fulfillment', icon: PackageCheck, description: 'Approve orders and dispatch shipments' },
      { id: 'fleet', label: 'Fleet', icon: Truck, description: 'Vehicle registry and live assignments' },
      { id: 'returns', label: 'Inbound Returns', icon: Undo2, description: 'Pick up and receive returned stock at the depot' },
      { id: 'facilities', label: 'Facilities', icon: Building2, description: 'Warehouses and storage locations' },
    ],
  },
  retailer: {
    id: 'retailer',
    name: 'Retailer Portal',
    short: 'Retailer',
    tagline: 'Purchase orders, deliveries, returns and refunds',
    icon: Store,
    tabs: [
      { id: 'overview', label: 'Overview', icon: LayoutDashboard, description: 'Your orders, deliveries and recall alerts at a glance' },
      { id: 'orders', label: 'Purchase Orders', icon: ShoppingCart, description: 'Order medicines from released network stock' },
      { id: 'receiving', label: 'Receiving', icon: PackageCheck, description: 'Sign for incoming shipments and report damage' },
      { id: 'returns', label: 'Returns & Refunds', icon: Undo2, description: 'File returns and track refund vouchers' },
      { id: 'recalls', label: 'Recall Notices', icon: Siren, description: 'Recall notices sent to your pharmacy' },
    ],
  },
  compliance: {
    id: 'compliance',
    name: 'Compliance Portal',
    short: 'Compliance',
    tagline: 'Read-only regulatory oversight of the whole network',
    icon: ShieldCheck,
    readOnly: true,
    tabs: [
      { id: 'overview', label: 'Risk Overview', icon: Gauge, description: 'Risk heatmap, violations and cost of non-compliance' },
      { id: 'ledger', label: 'Audit Ledger', icon: ScrollText, description: 'The immutable (WORM) governance log' },
      { id: 'coldchain', label: 'Cold-Chain Violations', icon: Snowflake, description: 'Temperature breaches and the quarantines they triggered' },
      { id: 'recalls', label: 'Recalls & Disposal', icon: Radio, description: 'Recall notification effectiveness, returns and destruction' },
      { id: 'financial', label: 'Financial Exposure', icon: IndianRupee, description: 'Losses, refunds and failed payments' },
      { id: 'trace', label: 'Batch Trace', icon: FileSearch, description: 'Investigate the pedigree of any batch' },
    ],
  },
  admin: {
    id: 'admin',
    name: 'SysAdmin Portal',
    short: 'SysAdmin',
    tagline: 'Organisations, identities, access control and system health',
    icon: KeyRound,
    tabs: [
      { id: 'health', label: 'System Health', icon: Activity, description: 'API latency, data volumes and database automation' },
      { id: 'organisations', label: 'Organisations', icon: Building2, description: 'Onboard and manage supply-chain organisations' },
      { id: 'users', label: 'Users', icon: Users, description: 'Provision identities and assign roles' },
      { id: 'access', label: 'Access Control', icon: BadgeCheck, description: 'Role-permission matrix and portal routing' },
      { id: 'sessions', label: 'Sessions & Security', icon: ClipboardCheck, description: 'Login sessions and identity events' },
    ],
  },
}

export const PORTAL_ORDER: PortalId[] = ['manufacturer', 'distributor', 'retailer', 'compliance', 'admin']

/** Role "Admin" wins; otherwise the organisation type picks the portal. */
export function resolvePortal(roleName: string | null | undefined, orgType: OrgType | null | undefined): PortalId | null {
  if (roleName === 'Admin') return 'admin'
  switch (orgType) {
    case 'Manufacturer':
      return 'manufacturer'
    case 'Distributor':
      return 'distributor'
    case 'Retailer':
      return 'retailer'
    case 'Regulatory_Body':
      return 'compliance'
    default:
      return null
  }
}

export const PORTAL_RULES: { when: string; portal: PortalId }[] = [
  { when: 'Role is “Admin” (any organisation)', portal: 'admin' },
  { when: 'Organisation type is Manufacturer', portal: 'manufacturer' },
  { when: 'Organisation type is Distributor', portal: 'distributor' },
  { when: 'Organisation type is Retailer', portal: 'retailer' },
  { when: 'Organisation type is Regulatory body', portal: 'compliance' },
]
