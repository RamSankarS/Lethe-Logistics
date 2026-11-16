import { useMemo } from 'react'
import { useNavigate } from 'react-router'
import { Flame, IndianRupee, OctagonAlert, ScrollText, ShieldAlert, Siren, Snowflake, TriangleAlert } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { useAuditAll } from '@/data/audit'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { Heatmap, TrendChart, SERIES } from '@/components/charts/Charts'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState, Spinner } from '@/components/ui/Feedback'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { SEVERITIES, SEVERITY_TONE, isBreach, moduleLabel, severityOf } from '@/lib/domain'
import { humanize, money, moneyCompact, num, relative, shortDate } from '@/lib/format'

export function RiskOverview() {
  const profile = useProfile()
  const navigate = useNavigate()
  const L = useLookups()
  const audit = useAuditAll()
  const t = useTables(['vwRiskHeatmap', 'vwNonCompliance', 'recalls', 'quarantine', 'sensorLogs', 'locations', 'losses'] as const)

  const m = useMemo(() => {
    const logs = audit.data ?? []
    const modules = [...new Set(logs.map((l) => l.source_module))].sort()
    const sev = new Map<string, number>()
    for (const l of logs) {
      const k = `${l.source_module}|${severityOf(l)}`
      sev.set(k, (sev.get(k) ?? 0) + 1)
    }
    // weekly volume
    const weekKey = (iso: string) => {
      const d = new Date(iso)
      const day = (d.getDay() + 6) % 7
      d.setDate(d.getDate() - day)
      d.setHours(0, 0, 0, 0)
      return d.toISOString().slice(0, 10)
    }
    const weeks = new Map<string, { total: number; flagged: number }>()
    for (const l of logs) {
      const k = weekKey(l.log_time_stamp_utc)
      const cur = weeks.get(k) ?? { total: 0, flagged: 0 }
      cur.total++
      const s = severityOf(l)
      if (s === 'CRITICAL' || s === 'HIGH') cur.flagged++
      weeks.set(k, cur)
    }
    const trend = [...weeks.entries()].sort(([a], [b]) => a.localeCompare(b)).map(([week, v]) => ({ week, total: v.total, flagged: v.flagged }))
    const flagged = logs.filter((l) => ['CRITICAL', 'HIGH'].includes(severityOf(l))).slice(0, 8)
    const locById = new Map(t.data.locations.map((l) => [l.location_id, l]))
    const breaches = t.data.sensorLogs.filter((s) => {
      const loc = locById.get(s.location_id)
      return loc ? isBreach(s, loc) : false
    })
    return {
      logs,
      modules,
      sev,
      trend,
      flagged,
      critical: logs.filter((l) => severityOf(l) === 'CRITICAL').length,
      high: logs.filter((l) => severityOf(l) === 'HIGH').length,
      breaches,
      activeRecalls: t.data.recalls.filter((r) => r.quarantine_status === 'Active').length,
      activeQ: t.data.quarantine.filter((q) => q.status === 'Active').length,
      cost: t.data.vwNonCompliance.reduce((s, r) => s + Number(r.total_financial_loss ?? 0), 0),
      losses: t.data.losses.reduce((s, r) => s + Number(r.total_financial_loss ?? 0), 0),
    }
  }, [audit.data, t.data])

  if (audit.isLoading || t.isLoading) return <Spinner label="Reading the governance ledger…" />

  return (
    <>
      <PageHeader
        title={`Regulatory oversight · ${profile.org?.org_name}`}
        description={`${num(m.logs.length)} immutable ledger events across ${m.modules.length} modules. You have read-only access to the whole network.`}
        actions={
          <Button variant="primary" icon={ScrollText} onClick={() => navigate('/compliance/ledger')}>
            Open audit ledger
          </Button>
        }
      />

      <StatGrid>
        <Stat label="Critical events" value={num(m.critical)} sub="recalls, spec tampering" icon={OctagonAlert} tone="critical" onClick={() => navigate('/compliance/ledger')} />
        <Stat label="High-risk warnings" value={num(m.high)} sub="destruction, breaches, access changes" icon={TriangleAlert} tone="serious" onClick={() => navigate('/compliance/ledger')} />
        <Stat label="Active recalls" value={num(m.activeRecalls)} sub="batches withdrawn from market" icon={Siren} tone="critical" onClick={() => navigate('/compliance/recalls')} />
        <Stat label="Cold-chain breaches" value={num(m.breaches.length)} sub={`${m.activeQ} quarantines still active`} icon={Snowflake} tone="info" onClick={() => navigate('/compliance/coldchain')} />
        <Stat label="Cost of non-compliance" value={money(m.cost)} sub="refunds paid on recalls" icon={IndianRupee} tone="warn" onClick={() => navigate('/compliance/financial')} />
        <Stat label="Losses booked" value={moneyCompact(m.losses)} sub="spoilage, damage, recall, disposal" icon={Flame} tone="serious" onClick={() => navigate('/compliance/financial')} />
      </StatGrid>

      <div className="comp-gap-top grid gap-5 2xl:grid-cols-5">
        <Card className="2xl:col-span-3">
          <CardHeader title="Compliance risk heatmap" subtitle="Ledger events per module and severity. Darker cells mean more events." icon={ShieldAlert} />
          <CardBody>
            {m.modules.length ? (
              <Heatmap rows={m.modules} cols={SEVERITIES} value={(r, c) => m.sev.get(`${r}|${c}`) ?? 0} rowLabel={moduleLabel} colLabel={(c) => humanize(c)} />
            ) : (
              <EmptyState title="No events" />
            )}
          </CardBody>
        </Card>
        <Card className="2xl:col-span-2">
          <CardHeader title="Department risk summary" subtitle="financial_analytics.vw_compliance_risk_heatmap" />
          <CardBody className="comp-list-body">
            <div className="comp-dept-list">
              {[...t.data.vwRiskHeatmap]
                .sort((a, b) => b.critical_violations * 100 + b.high_risk_warnings - (a.critical_violations * 100 + a.high_risk_warnings))
                .map((r) => (
                  <div key={r.department} className="comp-dept-row">
                    <div className="comp-dept-text">
                      <p className="comp-dept-name">{moduleLabel(r.department)}</p>
                      <p className="comp-small-grey">
                        {num(r.total_events)} events · last {relative(r.last_violation_time)}
                      </p>
                    </div>
                    <div className="comp-dept-tags">
                      <Badge tone={r.critical_violations ? 'critical' : 'neutral'} dot>
                        {r.critical_violations} critical
                      </Badge>
                      <Badge tone={r.high_risk_warnings ? 'serious' : 'neutral'} dot>
                        {r.high_risk_warnings} high
                      </Badge>
                    </div>
                  </div>
                ))}
            </div>
          </CardBody>
        </Card>
      </div>

      <div className="comp-gap-top-2 grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Ledger activity by week" subtitle="All events and the critical/high subset" />
          <CardBody>
            <TrendChart
              data={m.trend}
              x="week"
              xFormat={(v) => shortDate(v)}
              series={[
                { key: 'total', label: 'All events', color: SERIES[0] },
                { key: 'flagged', label: 'Critical + high', color: SERIES[7] },
              ]}
            />
          </CardBody>
        </Card>
        <Card className="xl:col-span-2">
          <CardHeader title="Latest flagged events" subtitle="Critical and high severity" />
          <CardBody className="comp-list-body">
            <ul className="comp-flag-list">
              {m.flagged.map((e) => {
                const p = (e.event_payload ?? {}) as Record<string, unknown>
                return (
                  <li key={e.log_id} className="comp-flag-item">
                    <div className="comp-flag-top">
                      <span className="comp-flag-name">{humanize(e.action_type)}</span>
                      <Badge tone={SEVERITY_TONE[severityOf(e)]} dot>
                        {severityOf(e).toLowerCase()}
                      </Badge>
                    </div>
                    <p className="comp-small-grey comp-flag-detail">
                      {moduleLabel(e.source_module)} · {String(p.reason ?? p.description ?? p.batch_number ?? L.userName(e.user_id))} · {relative(e.log_time_stamp_utc)}
                    </p>
                  </li>
                )
              })}
            </ul>
          </CardBody>
        </Card>
      </div>

      <Callout tone="neutral" className="comp-gap-top" title="Why this data can be trusted">
        Every row comes from <code className="code-text">identity_mod.auth_audit_logs</code>, which the <code className="code-text">tr_protect_audit_logs</code> trigger makes write-once: updates and deletes are rejected for every
        role. Run the tamper test on the Audit Ledger tab to see it.
      </Callout>
    </>
  )
}
