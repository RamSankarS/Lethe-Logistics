import type { ReactNode } from 'react'
import { Link } from 'react-router'
import { ArrowLeft, Ban, LogOut, ShieldX, UserX } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { useAuth } from '@/auth/AuthProvider'
import { Button } from '@/components/ui/Button'
import { PORTALS, type PortalId } from '@/portals/registry'
import { ORG_TYPE_LABEL } from '@/lib/domain'

function Shell({ icon: Icon, title, children, actions }: { icon: LucideIcon; title: string; children: ReactNode; actions?: ReactNode }) {
  return (
    <div className="flex min-h-full items-center justify-center bg-page px-6 py-16">
      <div className="animate-pop w-full max-w-md rounded-3xl border border-line bg-surface p-8 text-center shadow-xl">
        <span className="mx-auto mb-5 grid size-14 place-items-center rounded-2xl bg-critical-soft text-critical-text">
          <Icon className="size-7" />
        </span>
        <h1 className="text-xl font-semibold text-ink">{title}</h1>
        <div className="mt-2 text-[14px] leading-6 text-ink-2">{children}</div>
        {actions && <div className="mt-6 flex flex-wrap justify-center gap-2">{actions}</div>}
      </div>
    </div>
  )
}

/** Shown when a signed-in user opens another role's portal URL. */
export function AccessDenied({ requested }: { requested: PortalId }) {
  const { portal, profile } = useAuth()
  const own = portal ? PORTALS[portal] : null
  return (
    <Shell
      icon={ShieldX}
      title="This portal is not yours"
      actions={
        own && (
          <Link to={`/${own.id}`}>
            <Button variant="primary" icon={ArrowLeft}>
              Back to {own.name}
            </Button>
          </Link>
        )
      }
    >
      The <b className="text-ink">{PORTALS[requested].name}</b> is restricted. You are signed in as{' '}
      <b className="text-ink">{profile?.org?.org_name}</b>
      {profile?.org ? ` (${ORG_TYPE_LABEL[profile.org.org_type]})` : ''}, which only has access to the {own?.name ?? 'portal assigned to your role'}.
    </Shell>
  )
}

/** Signed in, but the organisation type has no portal (e.g. Transporter). */
export function NoPortal() {
  const { profile, signOut } = useAuth()
  return (
    <Shell icon={Ban} title="No portal for this organisation" actions={<Button icon={LogOut} onClick={() => void signOut()}>Sign out</Button>}>
      {profile?.org ? `${profile.org.org_name} is a ${ORG_TYPE_LABEL[profile.org.org_type]} organisation.` : 'Your account has no organisation.'} Portals exist for manufacturers, distributors, retailers, regulators and the
      system administrator. Ask the SysAdmin to move your identity to one of those.
    </Shell>
  )
}

/** Auth user exists but has no row in identity_mod.users. */
export function Unlinked() {
  const { signOut } = useAuth()
  return (
    <Shell icon={UserX} title="No Lethe identity" actions={<Button icon={LogOut} onClick={() => void signOut()}>Sign out</Button>}>
      You signed in successfully, but this login is not linked to a user in <code className="font-mono text-ink">identity_mod.users</code>. Ask the SysAdmin to provision your identity.
    </Shell>
  )
}

export function NotFound() {
  return (
    <Shell icon={Ban} title="Page not found" actions={<Link to="/"><Button variant="primary" icon={ArrowLeft}>Go to my portal</Button></Link>}>
      That address does not exist in Lethe Logistics.
    </Shell>
  )
}
