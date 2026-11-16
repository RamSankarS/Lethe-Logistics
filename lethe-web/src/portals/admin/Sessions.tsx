import { useMemo } from 'react'
import { Activity, LogIn, ShieldCheck, Users } from 'lucide-react'
import { useAuditFeed } from '@/data/audit'
import { useLookups, useTables } from '@/data/hooks'
import { PageHeader } from '@/components/layout/PageContext'
import { Badge } from '@/components/ui/Badge'
import { Card, CardBody, CardHeader } from '@/components/ui/Card'
import { DataTable, type Column } from '@/components/ui/DataTable'
import { Stat, StatGrid } from '@/components/ui/Stat'
import { severityOf, SEVERITY_TONE } from '@/lib/domain'
import { dateTime, humanize, num, relative } from '@/lib/format'
import type { UserSession } from '@/lib/types'

function duration(s: UserSession) {
  const end = s.log_out_time_utc ? new Date(s.log_out_time_utc) : null
  if (!end) return null
  const mins = Math.round((end.getTime() - new Date(s.login_time_utc).getTime()) / 60000)
  return mins < 60 ? `${mins} min` : `${Math.floor(mins / 60)} h ${mins % 60} min`
}

export function Sessions() {
  const L = useLookups()
  const t = useTables(['sessions'] as const)
  const feed = useAuditFeed({ modules: ['IDENTITY'], limit: 20 }, { refetchInterval: 20_000 })

  const stats = useMemo(() => {
    const s = t.data.sessions
    return { total: s.length, open: s.filter((x) => !x.log_out_time_utc).length, users: new Set(s.map((x) => x.user_id)).size, last: s[0]?.login_time_utc }
  }, [t.data.sessions])

  const cols: Column<UserSession>[] = [
    { key: 'user', header: 'User', sort: (s) => L.userName(s.user_id), cell: (s) => <div><p className="admin-cell-main">{L.userName(s.user_id)}</p><p className="admin-cell-sub">{L.orgName(L.user.get(s.user_id ?? '')?.org_id)}</p></div> },
    { key: 'ip', header: 'Source', cell: (s) => <span className="admin-cell-ip">{s.ip_address ?? '—'}</span>, hideBelow: 'md' },
    { key: 'in', header: 'Signed in', sort: (s) => s.login_time_utc, cell: (s) => <span className="admin-cell-text" title={dateTime(s.login_time_utc)}>{dateTime(s.login_time_utc)}</span> },
    { key: 'out', header: 'Signed out', sort: (s) => s.log_out_time_utc ?? '', cell: (s) => <span className="admin-cell-text">{s.log_out_time_utc ? dateTime(s.log_out_time_utc) : '—'}</span>, hideBelow: 'lg' },
    { key: 'dur', header: 'Duration', cell: (s) => <span className="admin-cell-text">{duration(s) ?? '—'}</span>, hideBelow: 'lg' },
    { key: 'state', header: 'State', sort: (s) => (s.log_out_time_utc ? 1 : 0), cell: (s) => (s.log_out_time_utc ? <Badge>Ended</Badge> : <Badge tone="good" dot>Open</Badge>) },
  ]

  return (
    <>
      <PageHeader />
      <StatGrid cols={4}>
        <Stat label="Sessions recorded" value={num(stats.total)} sub="identity_mod.user_sessions" icon={LogIn} />
        <Stat label="Open sessions" value={num(stats.open)} sub="no sign-out recorded" icon={Activity} tone="good" />
        <Stat label="Distinct users" value={num(stats.users)} sub="have signed in" icon={Users} tone="info" />
        <Stat label="Latest sign-in" value={stats.last ? relative(stats.last) : '—'} sub={stats.last ? dateTime(stats.last) : ''} icon={ShieldCheck} tone="accent" />
      </StatGrid>
      <div className="admin-sessions-grid grid gap-5 2xl:grid-cols-5">
        <Card className="2xl:col-span-3">
          <CardHeader title="Session log" subtitle="Each sign-in through Lethe inserts a row; the trigger mirrors it to the audit ledger" />
          <DataTable bare rows={t.data.sessions} columns={cols} rowKey={(s) => s.session_id} loading={t.isLoading} initialSort={{ key: 'in', dir: 'desc' }} searchText={(s) => `${L.userName(s.user_id)} ${s.ip_address ?? ''}`} />
        </Card>
        <Card className="2xl:col-span-2">
          <CardHeader title="Identity events" subtitle="Live feed from the IDENTITY module" />
          <CardBody className="admin-feed-body">
            <ul className="admin-feed-list">
              {(feed.data ?? []).map((e) => (
                <li key={e.log_id} className="admin-feed-item">
                  <div className="admin-feed-top">
                    <span className="admin-feed-action">{humanize(e.action_type)}</span>
                    <Badge tone={SEVERITY_TONE[severityOf(e)]} dot>
                      {severityOf(e).toLowerCase()}
                    </Badge>
                  </div>
                  <p className="admin-feed-meta">
                    {e.user_id ? L.userName(e.user_id) : 'System'} · {e.ip_address ?? 'no IP'} · {relative(e.log_time_stamp_utc)}
                  </p>
                </li>
              ))}
            </ul>
          </CardBody>
        </Card>
      </div>
    </>
  )
}
