import { useEffect, useState, type ReactNode } from 'react'
import { NavLink } from 'react-router'
import { useIsFetching, useQueryClient } from '@tanstack/react-query'
import { useAuth } from '@/auth/AuthProvider'
import { useTheme } from '@/lib/theme'
import { fullName, relative } from '@/lib/format'
import { ORG_TYPE_LABEL } from '@/lib/domain'
import type { PortalMeta, TabMeta } from '@/portals/registry'
import { Brand } from './Brand'
import { PageContext } from './PageContext'

function SideMenu({ portal, open, onNavigate }: { portal: PortalMeta; open: boolean; onNavigate: () => void }) {
  const { profile } = useAuth()
  return (
    <div className={open ? 'side-menu menu-open' : 'side-menu'}>
      <div className="org-info">
        <b>{profile?.org?.org_name ?? 'Lethe network'}</b>
        {profile?.org && (
          <>
            <br />
            <small>
              {ORG_TYPE_LABEL[profile.org.org_type]} - {profile.org.reg_no}
            </small>
          </>
        )}
      </div>

      <ul className="menu-list" aria-label={portal.name}>
        {portal.tabs.map((t) => (
          <li key={t.id}>
            <NavLink to={`/${portal.id}/${t.id}`} onClick={onNavigate} className={({ isActive }) => (isActive ? 'menu-link active' : 'menu-link')}>
              {t.label}
            </NavLink>
          </li>
        ))}
      </ul>

      {portal.readOnly && <p className="readonly-note">* You have read only access</p>}
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
    <span className="sync-info">
      {fetching > 0 ? 'Loading data...' : `Last updated ${relative(last)}`}
      <button onClick={() => void qc.invalidateQueries()} title="Refresh all data">
        Refresh
      </button>
    </span>
  )
}

export function AppShell({ portal, tab, children }: { portal: PortalMeta; tab: TabMeta; children: ReactNode }) {
  const { theme, toggle } = useTheme()
  const { isPreview, profile, signOut } = useAuth()
  const [mobileOpen, setMobileOpen] = useState(false)
  const name = fullName(profile)

  useEffect(() => {
    document.title = `${tab.label} · ${portal.short} · Lethe Logistics`
  }, [tab, portal])

  return (
    <PageContext.Provider value={{ portal, tab }}>
      <div data-portal={portal.id}>
        <div className="top-bar">
          <button className="menu-btn" onClick={() => setMobileOpen((o) => !o)} aria-label="Open menu">
            Menu
          </button>
          <Brand />
          <span className="portal-name">{portal.name}</span>
          <div className="top-right">
            <span className="user-info">
              Logged in as <b>{name}</b> ({isPreview ? 'preview' : (profile?.role?.role_name?.replace(/_/g, ' ') ?? 'no role')})
            </span>
            <button className="btn btn-small" onClick={toggle} title="Toggle dark mode">
              {theme === 'dark' ? 'Light mode' : 'Dark mode'}
            </button>
            <button className="btn btn-small btn-red" onClick={() => void signOut()}>
              Logout
            </button>
          </div>
        </div>

        {isPreview && <div className="preview-banner">Developer preview: showing this portal without signing in. Saving is turned off.</div>}

        <div className="page-wrapper">
          <SideMenu portal={portal} open={mobileOpen} onNavigate={() => setMobileOpen(false)} />

          <div className="main-content">
            <div className="breadcrumb-line">
              <span>
                {portal.name} &gt; {tab.label}
              </span>
              <SyncStatus />
            </div>
            <div key={`${portal.id}-${tab.id}`}>{children}</div>
          </div>
        </div>
      </div>
    </PageContext.Provider>
  )
}
