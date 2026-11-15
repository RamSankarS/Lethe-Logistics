import { SystemHealth } from './SystemHealth'
import { Organisations } from './Organisations'
import { Users } from './Users'
import { AccessControl } from './AccessControl'
import { Sessions } from './Sessions'

export default function AdminPortal({ tab }: { tab: string }) {
  switch (tab) {
    case 'organisations':
      return <Organisations />
    case 'users':
      return <Users />
    case 'access':
      return <AccessControl />
    case 'sessions':
      return <Sessions />
    default:
      return <SystemHealth />
  }
}
