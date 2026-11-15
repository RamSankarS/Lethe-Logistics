import { Overview } from './Overview'
import { Batches } from './Batches'
import { Catalog } from './Catalog'
import { Recalls } from './Recalls'
import { Returns } from './Returns'
import { Trace } from './Trace'
import { Revenue } from './Revenue'

export default function ManufacturerPortal({ tab }: { tab: string }) {
  switch (tab) {
    case 'batches':
      return <Batches />
    case 'catalog':
      return <Catalog />
    case 'recalls':
      return <Recalls />
    case 'returns':
      return <Returns />
    case 'trace':
      return <Trace />
    case 'revenue':
      return <Revenue />
    default:
      return <Overview />
  }
}
