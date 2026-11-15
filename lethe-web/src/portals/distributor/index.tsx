import { Overview } from './Overview'
import { Inventory } from './Inventory'
import { ColdChain } from './ColdChain'
import { Fulfillment } from './Fulfillment'
import { Fleet } from './Fleet'
import { InboundReturns } from './InboundReturns'
import { Facilities } from './Facilities'

export default function DistributorPortal({ tab }: { tab: string }) {
  switch (tab) {
    case 'inventory':
      return <Inventory />
    case 'coldchain':
      return <ColdChain />
    case 'fulfillment':
      return <Fulfillment />
    case 'fleet':
      return <Fleet />
    case 'returns':
      return <InboundReturns />
    case 'facilities':
      return <Facilities />
    default:
      return <Overview />
  }
}
