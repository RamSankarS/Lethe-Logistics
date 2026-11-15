import { useEffect, useState, type ReactNode } from 'react'
import { NavLink } from 'react-router'
import { useIsFetching, useQueryClient } from '@tanstack/react-query'
import { Eye, LogOut, Menu, Moon, RefreshCw, Sun, X } from 'lucide-react'
import { useAuth } from '@/auth/AuthProvider'
import { cn } from '@/lib/cn'
import { useTheme } from '@/lib/theme'
import { fullName, initials, relative } from '@/lib/format'
import { ORG_TYPE_LABEL } from '@/lib/domain'
import type { PortalMeta, TabMeta } from '@/portals/registry'
import { Brand } from './Brand'
import { PageContext } from './PageContext'

function Sidebar({ portal, onNavigate }: { portal: PortalMeta; onNavigate?: () => void }) {
  const { profile, signOut, isPreview } = useAuth()
  const PortalIcon = portal.icon
  const name = fullName(profile)
  return (
    <div data-theme="dark" data-portal={portal.id} className="flex h-full flex-col bg-sidebar text-ink">
      <div className="px-5 pt-5 pb-4">
        <Brand />
      </div>

      <div className="mx-3 rounded-xl border border-white/8 bg-white/[0.04] p-3">
        <div className="flex items-center gap-2.5">
          <span className="grid size-9 shrink-0 place-items-center rounded-lg bg-accent-soft text-accent-text">
            <PortalIcon className="size-[18px]" />
          </span>
          <div className="min-w-0">
            <p className="text-[11px] font-semibold tracking-[0.12em] text-accent-text uppercase">{portal.name}</p>
            <p className="truncate text-[13.5px] font-medium text-ink">{profile?.org?.org_name ?? 'Lethe network'}</p>
          </div>
        </div>
        {profile?.org && (
          <p className="mt-2 truncate font-mono text-[11px] text-muted">
            {ORG_TYPE_LABEL[profile.org.org_type]} · {profile.org.reg_no}
          </p>
        )}
      </div>

      <nav className="mt-4 flex-1 space-y-0.5 overflow-y-auto px-3" aria-label={portal.name}>
        {portal.tabs.map((t) => (
          <NavLink
            key={t.id}
            to={`/${portal.id}/${t.id}`}
            onClick={onNavigate}
            className={({ isActive }) =>
              cn(
                'group flex items-center gap-3 rounded-lg px-3 py-2 text-[13.5px] font-medium transition-colors',
                isActive ? 'bg-white/[0.08] text-ink' : 'text-ink-2 hover:bg-white/[0.04] hover:text-ink',
              )
            }
          >
            {({ isActive }) => (
              <>
                <t.icon className={cn('size-[18px] shrink-0', isActive ? 'text-accent-text' : 'text-muted group-hover:text-ink-2')} />
                <span className="truncate">{t.label}</span>
              </>
            )}
          </NavLink>
        ))}
      </nav>

      {portal.readOnly && (
        <div className="mx-3 mb-3 flex items-center gap-2 rounded-lg border border-accent/25 bg-accent-soft px-3 py-2 text-[12px] text-accent-text">
          <Eye className="size-4 shrink-0" /> Read-only regulatory access
        </div>
      )}

      <div className="border-t border-white/8 p-3">
        <div className="flex items-center gap-3 rounded-xl px-2 py-1.5">
          <span className="grid size-9 shrink-0 place-items-center rounded-full bg-accent text-[13px] font-semibold text-accent-ink">{initials(name)}</span>
          <div className="min-w-0 flex-1">
            <p className="truncate text-[13.5px] font-medium text-ink">{name}</p>
            <p className="truncate text-[11.5px] text-muted">{isPreview ? 'Developer preview' : (profile?.role?.role_name?.replace(/_/g, ' ') ?? 'No role')}</p>
          </div>
          <button onClick={() => void signOut()} className="grid size-8 shrink-0 place-items-center rounded-lg text-muted hover:bg-white/[0.06] hover:text-ink" title="Sign out" aria-label="Sign out">
            <LogOut className="size-4" />
          </button>
        </div>
      </div>
    </div>
  )
}

function SyncStatus() {
  const qc = useQueryClient()
  const fetching = useIsFetching()
  const [, tick] = useState(0)
  const [last, setLast] = useState(() => new Date())
  useEffect(() => {
    if (fetching === 0) setLast(new Date())
  }, [fetching])
  useEffect(() => {
    const id = setInterval(() => tick((n) => n + 1), 15000)
    return () => clearInterval(id)
  }, [])
  return (
    <button
      onClick={() => void qc.invalidateQueries()}
      className="hidden h-9 items-center gap-2 rounded-lg border border-line bg-surface px-3 text-[12.5px] text-ink-2 hover:bg-surface-2 sm:inline-flex"
      title="Refresh all data"
    >
      {fetching > 0 ? (
        <RefreshCw className="size-3.5 animate-spin text-accent-text" />
      ) : (
        <span className="relative flex size-2">
          <span className="animate-live absolute inset-0 rounded-full bg-good" />
          <span className="relative size-2 rounded-full bg-good" />
        </span>
      )}
      {fetching > 0 ? 'Syncing…' : `Live · synced ${relative(last)}`}
    </button>
  )
}

export function AppShell({ portal, tab, children }: { portal: PortalMeta; tab: TabMeta; children: ReactNode }) {
  const { theme, toggle } = useTheme()
  const { isPreview, profile } = useAuth()
  const [mobileOpen, setMobileOpen] = useState(false)

  useEffect(() => {
    document.title = `${tab.label} · ${portal.short} · Lethe Logistics`
  }, [tab, portal])

  return (
    <PageContext.Provider value={{ portal, tab }}>
      <div data-portal={portal.id} className="flex h-full min-h-0">
        <aside className="hidden w-[268px] shrink-0 lg:block">
          <div className="fixed inset-y-0 left-0 w-[268px]">
            <Sidebar portal={portal} />
          </div>
        </aside>

        {mobileOpen && (
          <div className="fixed inset-0 z-50 lg:hidden">
            <div className="absolute inset-0 bg-black/50" onClick={() => setMobileOpen(false)} />
            <div className="animate-slide-in absolute inset-y-0 left-0 w-[280px] shadow-2xl">
              <Sidebar portal={portal} onNavigate={() => setMobileOpen(false)} />
              <button onClick={() => setMobileOpen(false)} className="absolute top-4 right-3 grid size-8 place-items-center rounded-lg text-white/70 hover:bg-white/10" aria-label="Close menu">
                <X className="size-4" />
              </button>
            </div>
          </div>
        )}

        <div className="flex min-w-0 flex-1 flex-col">
          <header className="sticky top-0 z-30 flex h-16 shrink-0 items-center gap-3 border-b border-line bg-surface/85 px-4 backdrop-blur-md lg:px-8">
            <button onClick={() => setMobileOpen(true)} className="grid size-9 place-items-center rounded-lg text-ink-2 hover:bg-surface-3 lg:hidden" aria-label="Open menu">
              <Menu className="size-5" />
            </button>
            <div className="min-w-0 flex-1">
              <p className="truncate text-[12px] font-medium text-muted">
                {portal.name} <span className="mx-1 text-line-strong">/</span> {profile?.org?.org_name}
              </p>
              <p className="truncate text-[15px] font-semibold text-ink">{tab.label}</p>
            </div>
            <SyncStatus />
            <button onClick={toggle} className="grid size-9 place-items-center rounded-lg border border-line bg-surface text-ink-2 hover:bg-surface-2" title="Toggle dark mode" aria-label="Toggle dark mode">
              {theme === 'dark' ? <Sun className="size-4" /> : <Moon className="size-4" />}
            </button>
          </header>

          {isPreview && (
            <div className="flex items-center gap-2 border-b border-warn/40 bg-warn-soft px-4 py-2 text-[12.5px] text-warn-text lg:px-8">
              <Eye className="size-4" /> Developer preview: rendering this portal without signing in. All changes are disabled.
            </div>
          )}

          <main className="flex-1">
            <div key={`${portal.id}-${tab.id}`} className="animate-fade-in mx-auto w-full max-w-[1480px] px-4 py-6 lg:px-8 lg:py-7">
              {children}
            </div>
          </main>
        </div>
      </div>
    </PageContext.Provider>
  )
}
