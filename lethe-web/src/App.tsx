import { lazy, Suspense, type ComponentType, type LazyExoticComponent } from 'react'
import { Navigate, Route, Routes, useParams } from 'react-router'
import { useAuth } from '@/auth/AuthProvider'
import { AppShell } from '@/components/layout/AppShell'
import { ErrorBoundary } from '@/components/layout/ErrorBoundary'
import { Spinner } from '@/components/ui/Feedback'
import { LoginPage } from '@/pages/LoginPage'
import { AccessDenied, NoPortal, NotFound, Unlinked } from '@/pages/StatusPages'
import { PORTALS, type PortalId } from '@/portals/registry'
import { isSupabaseConfigured } from '@/lib/supabase'

type PortalComponent = LazyExoticComponent<ComponentType<{ tab: string }>>

const PORTAL_COMPONENTS: Record<PortalId, PortalComponent> = {
  manufacturer: lazy(() => import('@/portals/manufacturer')),
  distributor: lazy(() => import('@/portals/distributor')),
  retailer: lazy(() => import('@/portals/retailer')),
  compliance: lazy(() => import('@/portals/compliance')),
  admin: lazy(() => import('@/portals/admin')),
}

function FullPageLoader() {
  return (
    <div className="flex h-full items-center justify-center bg-page">
      <Spinner label="Loading Lethe…" />
    </div>
  )
}

function PortalRoute() {
  const { status, portal } = useAuth()
  const { portalId, tabId } = useParams()

  if (status === 'loading') return <FullPageLoader />
  if (status === 'signed-out') return <Navigate to="/login" replace />
  if (status === 'unlinked') return <Unlinked />
  if (!portal) return <NoPortal />

  if (!portalId || !(portalId in PORTALS)) return <NotFound />
  const requested = portalId as PortalId
  if (requested !== portal) return <AccessDenied requested={requested} />

  const meta = PORTALS[portal]
  const tab = meta.tabs.find((t) => t.id === tabId)
  if (!tab) return <Navigate to={`/${portal}/${meta.tabs[0].id}`} replace />

  const Portal = PORTAL_COMPONENTS[portal]
  return (
    <AppShell portal={meta} tab={tab}>
      <ErrorBoundary resetKey={`${portal}/${tab.id}`}>
        <Suspense fallback={<Spinner />}>
          <Portal tab={tab.id} />
        </Suspense>
      </ErrorBoundary>
    </AppShell>
  )
}

function RootRedirect() {
  const { status, portal } = useAuth()
  if (status === 'loading') return <FullPageLoader />
  if (status === 'ready' && portal) return <Navigate to={`/${portal}`} replace />
  if (status === 'ready' && !portal) return <NoPortal />
  if (status === 'unlinked') return <Unlinked />
  return <Navigate to="/login" replace />
}

function NotConfigured() {
  return (
    <div className="flex h-full items-center justify-center bg-page p-6">
      <div className="max-w-lg rounded-2xl border border-line bg-surface p-6 text-sm text-ink-2 shadow">
        <h1 className="mb-2 text-lg font-semibold text-ink">Supabase is not configured</h1>
        Copy <code className="font-mono text-ink">.env.example</code> to <code className="font-mono text-ink">.env.local</code>, set <code className="font-mono text-ink">VITE_SUPABASE_URL</code> and{' '}
        <code className="font-mono text-ink">VITE_SUPABASE_PUBLISHABLE_KEY</code>, then restart <code className="font-mono text-ink">npm run dev</code>.
      </div>
    </div>
  )
}

export default function App() {
  if (!isSupabaseConfigured) return <NotConfigured />
  return (
    <Routes>
      <Route path="/" element={<RootRedirect />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/:portalId" element={<PortalRoute />} />
      <Route path="/:portalId/:tabId" element={<PortalRoute />} />
      <Route path="*" element={<NotFound />} />
    </Routes>
  )
}
