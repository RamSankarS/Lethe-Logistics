import type { PortalId } from '@/portals/registry'

/**
 * The five demo identities shown on the sign-in screen.
 * Only e-mails are listed here; passwords are never stored in frontend code.
 */
export const DEMO_ACCOUNTS: { portal: PortalId; email: string; org: string }[] = [
  { portal: 'manufacturer', email: 'adminsys@gmail.com', org: 'Avant-Garde LifeSciences' },
  { portal: 'distributor', email: 'distributor@lethe.com', org: 'MP Central Drug Depot' },
  { portal: 'retailer', email: 'retailer@lethe.com', org: 'Bhopal City Care Pharmacy' },
  { portal: 'compliance', email: 'compliance@lethe.com', org: 'Federal Compliance Office' },
  { portal: 'admin', email: 'sysadmin@lethe.com', org: 'Lethe Master Hub' },
]
