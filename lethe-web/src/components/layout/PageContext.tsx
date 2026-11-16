import { createContext, useContext, type ReactNode } from 'react'
import type { PortalMeta, TabMeta } from '@/portals/registry'
import { cn } from '@/lib/cn'

export const PageContext = createContext<{ portal: PortalMeta | null; tab: TabMeta | null }>({ portal: null, tab: null })

export const usePage = () => useContext(PageContext)

/** Title row of a portal tab. Title/description come from the portal registry. */
export function PageHeader({ actions, title, description, children, className }: { actions?: ReactNode; title?: ReactNode; description?: ReactNode; children?: ReactNode; className?: string }) {
  const { tab } = usePage()
  return (
    <div className={cn('page-header', className)}>
      {actions && <div className="page-actions">{actions}</div>}
      <h1 className="page-title">{title ?? tab?.label}</h1>
      <p className="page-desc">{description ?? tab?.description}</p>
      {children}
      <div className="clear"></div>
    </div>
  )
}
