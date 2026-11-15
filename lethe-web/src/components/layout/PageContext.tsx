import { createContext, useContext, type ReactNode } from 'react'
import type { PortalMeta, TabMeta } from '@/portals/registry'
import { cn } from '@/lib/cn'

export const PageContext = createContext<{ portal: PortalMeta | null; tab: TabMeta | null }>({ portal: null, tab: null })

export const usePage = () => useContext(PageContext)

/** Title row of a portal tab. Title/description come from the portal registry. */
export function PageHeader({ actions, title, description, children, className }: { actions?: ReactNode; title?: ReactNode; description?: ReactNode; children?: ReactNode; className?: string }) {
  const { tab } = usePage()
  return (
    <div className={cn('mb-6 flex flex-wrap items-end justify-between gap-4', className)}>
      <div className="min-w-0">
        <h1 className="text-[22px] leading-7 font-semibold tracking-tight text-ink">{title ?? tab?.label}</h1>
        <p className="mt-1 text-[13.5px] text-ink-2">{description ?? tab?.description}</p>
        {children}
      </div>
      {actions && <div className="flex flex-wrap items-center gap-2">{actions}</div>}
    </div>
  )
}
