import { PageHeader } from '@/components/layout/PageContext'
import { TraceWorkbench } from '@/components/domain/TraceWorkbench'
import { RiskOverview } from './RiskOverview'
import { AuditLedger } from './AuditLedger'
import { ColdChainViolations } from './ColdChainViolations'
import { RecallOversight } from './RecallOversight'
import { FinancialExposure } from './FinancialExposure'

export default function CompliancePortal({ tab }: { tab: string }) {
  switch (tab) {
    case 'ledger':
      return <AuditLedger />
    case 'coldchain':
      return <ColdChainViolations />
    case 'recalls':
      return <RecallOversight />
    case 'financial':
      return <FinancialExposure />
    case 'trace':
      return (
        <>
          <PageHeader />
          <TraceWorkbench />
        </>
      )
    default:
      return <RiskOverview />
  }
}
