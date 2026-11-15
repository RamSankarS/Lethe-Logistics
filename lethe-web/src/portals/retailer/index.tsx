import { Overview } from './Overview'
import { Orders } from './Orders'
import { Receiving } from './Receiving'
import { Returns } from './Returns'
import { RecallNotices } from './RecallNotices'

export default function RetailerPortal({ tab }: { tab: string }) {
  switch (tab) {
    case 'orders':
      return <Orders />
    case 'receiving':
      return <Receiving />
    case 'returns':
      return <Returns />
    case 'recalls':
      return <RecallNotices />
    default:
      return <Overview />
  }
}
