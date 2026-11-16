import { useMemo } from 'react'
import { useNavigate } from 'react-router'
import { AlertOctagon, Boxes, CheckCircle2, Factory, FlaskConical, Layers, Siren } from 'lucide-react'
import { useProfile } from '@/auth/AuthProvider'
import { useAuditFeed } from '@/data/audit'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { BarList, SERIES } from '@/components/charts/Charts'
import { Badge, Code, StatusBadge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { Callout, EmptyState } from '@/components/ui/Feedback'
import { SegmentedBar } from '@/components/ui/Progress'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { ExpiryBadge } from '@/components/domain/Cells'
import { BATCH_STATUS, isExpired, severityOf, SEVERITY_TONE } from '@/lib/domain'
import { compact, daysUntil, num, pct, relative, humanize } from '@/lib/format'
import { BatchActions, useMyBatches } from './shared'

export function Overview() {
  const profile = useProfile()
  const navigate = useNavigate()
  const L = useLookups()
  const { batches, stock, isLoading, ids } = useMyBatches()
  const t = useTables(['recalls', 'returns'] as const)
  const feed = useAuditFeed({ modules: ['PRODUCT_INTELLIGENCE', 'REVERSE_LOGISTICS'], limit: 8 })

  const s = useMemo(() => {
    const by = (st: string) => batches.filter((b) => b.status === st)
    const units = batches.reduce((a, b) => a + Number(b.quantity_produced), 0)
    const network = batches.reduce((a, b) => a + (stock.get(b.batch_id) ?? 0), 0)
    const activeRecalls = t.data.recalls.filter((r) => ids.has(r.batch_id) && r.quarantine_status === 'Active')
    const openReturns = t.data.returns.filter((r) => ids.has(r.batch_id) && r.status !== 'Closed')
    const byMedicine = new Map<string, number>()
    for (const b of batches) {
      const name = L.medOf(b)?.brand_name ?? 'Unknown'
      byMedicine.set(name, (byMedicine.get(name) ?? 0) + Number(b.quantity_produced))
    }
    const medicineRows = [...byMedicine.entries()].map(([name, units]) => ({ name, units })).sort((a, b) => b.units - a.units)
    const expiring = [...batches]
      .filter((b) => b.status !== 'Rejected' && b.status !== 'Recalled' && daysUntil(b.expiry_date) <= 540)
      .sort((a, b) => a.expiry_date.localeCompare(b.expiry_date))
    const expiredReleased = batches.filter((b) => b.status === 'Released' && isExpired(b))
    return { by, units, network, activeRecalls, openReturns, medicineRows, expiring, expiredReleased }
  }, [batches, stock, ids, t.data, L])

  const statusParts = [
    { key: 'Released', label: 'Released', value: s.by('Released').length, color: 'var(--good)' },
    { key: 'Quality-Check', label: 'Quality check', value: s.by('Quality-Check').length, color: 'var(--warn)', darkText: true },
    { key: 'Pending', label: 'Pending', value: s.by('Pending').length, color: 'var(--muted)' },
    { key: 'Rejected', label: 'Rejected', value: s.by('Rejected').length, color: 'var(--serious)' },
    { key: 'Recalled', label: 'Recalled', value: s.by('Recalled').length, color: 'var(--critical)' },
  ]

  return (
    <>
      <PageHeader
        title={`Good to see you, ${profile.first_name}`}
        description={`${profile.org?.org_name} · production and batch health across the Lethe network`}
        actions={
          <Button variant="primary" icon={FlaskConical} onClick={() => navigate('/manufacturer/batches')}>
            Manage batches
          </Button>
        }
      />

      {s.expiredReleased.length > 0 && (
        <Callout tone="critical" title={`${s.expiredReleased.length} expired batch${s.expiredReleased.length > 1 ? 'es are' : ' is'} still marked Released`} className="mfr-expired-alert">
          <div className="mfr-expired-list">
            {s.expiredReleased.map((b) => (
              <span key={b.batch_id} className="mfr-expired-item">
                <Code>{b.batch_number}</Code>
                <ExpiryBadge value={b.expiry_date} compact />
                <BatchActions batch={b} size="xs" />
              </span>
            ))}
          </div>
        </Callout>
      )}

      <StatGrid>
        <Stat label="Batches registered" value={num(batches.length)} sub={`${s.medicineRows.length} medicines in production`} icon={Layers} loading={isLoading} />
        <Stat label="Units produced" value={compact(s.units)} sub="across all batches" icon={Factory} loading={isLoading} />
        <Stat label="Released" value={num(s.by('Released').length)} sub={`${pct(batches.length ? s.by('Released').length / batches.length : 0)} of batches cleared`} icon={CheckCircle2} tone="good" loading={isLoading} />
        <Stat
          label="Awaiting QC"
          value={num(s.by('Pending').length + s.by('Quality-Check').length)}
          sub={`${s.by('Pending').length} pending · ${s.by('Quality-Check').length} in QC`}
          icon={FlaskConical}
          tone="warn"
          loading={isLoading}
          onClick={() => navigate('/manufacturer/batches')}
        />
        <Stat label="Network stock" value={compact(s.network)} sub="units held in warehouses" icon={Boxes} tone="info" loading={isLoading} />
        <Stat label="Active recalls" value={num(s.activeRecalls.length)} sub={`${s.openReturns.length} open returns`} icon={Siren} tone="critical" loading={isLoading} onClick={() => navigate('/manufacturer/recalls')} />
      </StatGrid>

      <div className="mfr-row-1 grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Batch status" subtitle="Lifecycle position of every batch you have registered" />
          <CardBody>
            <SegmentedBar parts={statusParts} />
            <div className="mfr-status-boxes grid gap-2 sm:grid-cols-2">
              {statusParts.map((p) => (
                <div key={p.key} className="mfr-status-box">
                  <span className="color-square" style={{ background: p.color }} />
                  <div>
                    <p className="mfr-status-name">
                      {p.label} <span className="mfr-grey-text">· {p.value}</span>
                    </p>
                    <p className="mfr-status-hint">{BATCH_STATUS[p.key as keyof typeof BATCH_STATUS].hint}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardBody>
        </Card>

        <Card className="xl:col-span-2">
          <CardHeader title="Units produced by medicine" subtitle="Total quantity across all batches" />
          <CardBody>
            {s.medicineRows.length ? <BarList data={s.medicineRows} y="name" value="units" label="Units produced" color={SERIES[0]} format={compact} /> : <EmptyState title="No batches yet" />}
          </CardBody>
        </Card>
      </div>

      <div className="mfr-row-2 grid gap-5 xl:grid-cols-5">
        <Card className="xl:col-span-3">
          <CardHeader title="Expiry watch" subtitle="Active batches expiring within 18 months, soonest first" icon={AlertOctagon} />
          <CardBody className="mfr-list-body">
            {s.expiring.length === 0 ? (
              <EmptyState title="Nothing expiring soon" />
            ) : (
              <div className="mfr-expiry-list">
                {s.expiring.slice(0, 7).map((b) => (
                  <div key={b.batch_id} className="mfr-expiry-row">
                    <div className="min-w-0">
                      <Code>{b.batch_number}</Code>
                      <span className="mfr-expiry-med">{L.medOf(b)?.brand_name}</span>
                    </div>
                    <div className="mfr-expiry-tags">
                      <StatusBadge value={b.status} meta={BATCH_STATUS} />
                      <ExpiryBadge value={b.expiry_date} />
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardBody>
        </Card>

        <Card className="xl:col-span-2">
          <CardHeader title="Recent batch & recall events" subtitle="Live from the governance ledger" />
          <CardBody className="mfr-list-body">
            {(feed.data ?? []).length === 0 ? (
              <EmptyState title="No events yet" />
            ) : (
              <ul className="mfr-event-list">
                {(feed.data ?? []).map((e) => {
                  const p = (e.event_payload ?? {}) as Record<string, string>
                  return (
                    <li key={e.log_id} className="mfr-event-item">
                      <div className="mfr-event-top">
                        <span className="mfr-event-name">{humanize(e.action_type)}</span>
                        <Badge tone={SEVERITY_TONE[severityOf(e)]} dot>
                          {severityOf(e).toLowerCase()}
                        </Badge>
                      </div>
                      <p className="mfr-event-sub">
                        {p.description ?? p.reason ?? p.batch_number ?? L.userName(e.user_id)} · {relative(e.log_time_stamp_utc)}
                      </p>
                    </li>
                  )
                })}
              </ul>
            )}
          </CardBody>
        </Card>
      </div>
    </>
  )
}
