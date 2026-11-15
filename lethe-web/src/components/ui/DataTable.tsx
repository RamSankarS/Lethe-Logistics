import { useMemo, useState, type ReactNode } from 'react'
import { ArrowDown, ArrowUp, ChevronLeft, ChevronRight, ChevronsUpDown, Download, Search } from 'lucide-react'
import { cn } from '@/lib/cn'
import { downloadCsv } from '@/lib/csv'
import { EmptyState } from './Feedback'

export interface Column<T> {
  key: string
  header: ReactNode
  cell: (row: T) => ReactNode
  /** Enables sorting on this column. */
  sort?: (row: T) => string | number | null | undefined
  align?: 'left' | 'right' | 'center'
  className?: string
  headerClassName?: string
  /** Hide on narrow screens. */
  hideBelow?: 'sm' | 'md' | 'lg' | 'xl'
}

const HIDE: Record<NonNullable<Column<unknown>['hideBelow']>, string> = {
  sm: 'hidden sm:table-cell',
  md: 'hidden md:table-cell',
  lg: 'hidden lg:table-cell',
  xl: 'hidden xl:table-cell',
}

export interface DataTableProps<T> {
  rows: T[]
  columns: Column<T>[]
  rowKey: (row: T) => string | number
  /** Text to match against the search box; enables search when given. */
  searchText?: (row: T) => string
  searchPlaceholder?: string
  toolbar?: ReactNode
  onRowClick?: (row: T) => void
  emptyTitle?: string
  emptyText?: ReactNode
  pageSize?: number
  initialSort?: { key: string; dir: 'asc' | 'desc' }
  loading?: boolean
  rowClassName?: (row: T) => string | undefined
  exportName?: string
  exportRow?: (row: T) => Record<string, unknown>
  className?: string
  bare?: boolean
}

export function DataTable<T>({
  rows,
  columns,
  rowKey,
  searchText,
  searchPlaceholder = 'Search…',
  toolbar,
  onRowClick,
  emptyTitle = 'Nothing here yet',
  emptyText,
  pageSize = 10,
  initialSort,
  loading,
  rowClassName,
  exportName,
  exportRow,
  className,
  bare,
}: DataTableProps<T>) {
  const [query, setQuery] = useState('')
  const [sort, setSort] = useState(initialSort ?? null)
  const [page, setPage] = useState(0)

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase()
    let out = q && searchText ? rows.filter((r) => searchText(r).toLowerCase().includes(q)) : rows
    if (sort) {
      const col = columns.find((c) => c.key === sort.key)
      if (col?.sort) {
        const get = col.sort
        out = [...out].sort((a, b) => {
          const va = get(a)
          const vb = get(b)
          if (va == null && vb == null) return 0
          if (va == null) return 1
          if (vb == null) return -1
          const r = typeof va === 'number' && typeof vb === 'number' ? va - vb : String(va).localeCompare(String(vb), undefined, { numeric: true })
          return sort.dir === 'asc' ? r : -r
        })
      }
    }
    return out
  }, [rows, query, sort, columns, searchText])

  const pages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const current = Math.min(page, pages - 1)
  const visible = filtered.slice(current * pageSize, current * pageSize + pageSize)

  const toggleSort = (key: string) => {
    setPage(0)
    setSort((s) => (s?.key !== key ? { key, dir: 'desc' } : s.dir === 'desc' ? { key, dir: 'asc' } : null))
  }

  const showToolbar = Boolean(searchText || toolbar || exportRow)

  return (
    <div className={cn(!bare && 'overflow-hidden rounded-2xl border border-line bg-surface shadow-[0_1px_2px_rgba(16,24,40,0.04)]', className)}>
      {showToolbar && (
        <div className="flex flex-wrap items-center gap-2 border-b border-line px-4 py-3">
          {searchText && (
            <div className="relative w-full max-w-xs min-w-[180px] flex-1">
              <Search className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted" />
              <input
                value={query}
                onChange={(e) => {
                  setQuery(e.target.value)
                  setPage(0)
                }}
                placeholder={searchPlaceholder}
                className="h-9 w-full rounded-lg border border-line bg-surface-2 pr-3 pl-9 text-sm text-ink outline-none placeholder:text-muted focus:border-accent focus:bg-surface focus:ring-[3px] focus:ring-accent/15"
              />
            </div>
          )}
          <div className="flex flex-1 flex-wrap items-center justify-end gap-2">
            {toolbar}
            {exportRow && (
              <button
                onClick={() => downloadCsv(exportName ?? 'lethe-export', filtered.map(exportRow))}
                disabled={!filtered.length}
                className="inline-flex h-9 items-center gap-1.5 rounded-lg border border-line px-3 text-[13px] font-medium text-ink-2 hover:bg-surface-2 disabled:opacity-50"
              >
                <Download className="size-4" /> CSV
              </button>
            )}
          </div>
        </div>
      )}

      <div className="overflow-x-auto">
        <table className="w-full min-w-[640px] border-collapse text-left text-[13.5px]">
          <thead>
            <tr className="border-b border-line bg-surface-2">
              {columns.map((c) => (
                <th
                  key={c.key}
                  scope="col"
                  className={cn(
                    'px-4 py-2.5 text-[11.5px] font-semibold tracking-wide whitespace-nowrap text-muted uppercase',
                    c.align === 'right' && 'text-right',
                    c.align === 'center' && 'text-center',
                    c.hideBelow && HIDE[c.hideBelow],
                    c.headerClassName,
                  )}
                >
                  {c.sort ? (
                    <button onClick={() => toggleSort(c.key)} className={cn('inline-flex items-center gap-1 uppercase hover:text-ink', c.align === 'right' && 'flex-row-reverse')}>
                      {c.header}
                      {sort?.key === c.key ? sort.dir === 'asc' ? <ArrowUp className="size-3.5" /> : <ArrowDown className="size-3.5" /> : <ChevronsUpDown className="size-3.5 opacity-40" />}
                    </button>
                  ) : (
                    c.header
                  )}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading
              ? Array.from({ length: 5 }).map((_, i) => (
                  <tr key={i} className="border-b border-line last:border-0">
                    {columns.map((c) => (
                      <td key={c.key} className={cn('px-4 py-3.5', c.hideBelow && HIDE[c.hideBelow])}>
                        <div className="h-4 w-3/4 animate-pulse rounded bg-surface-3" />
                      </td>
                    ))}
                  </tr>
                ))
              : visible.map((row) => (
                  <tr
                    key={rowKey(row)}
                    onClick={onRowClick ? () => onRowClick(row) : undefined}
                    className={cn('border-b border-line transition-colors last:border-0', onRowClick && 'cursor-pointer hover:bg-surface-2', rowClassName?.(row))}
                  >
                    {columns.map((c) => (
                      <td
                        key={c.key}
                        className={cn(
                          'px-4 py-3 align-middle text-ink',
                          c.align === 'right' && 'text-right tabular',
                          c.align === 'center' && 'text-center',
                          c.hideBelow && HIDE[c.hideBelow],
                          c.className,
                        )}
                      >
                        {c.cell(row)}
                      </td>
                    ))}
                  </tr>
                ))}
          </tbody>
        </table>
        {!loading && filtered.length === 0 && <EmptyState title={query ? 'No matches' : emptyTitle}>{query ? `Nothing matches “${query}”.` : emptyText}</EmptyState>}
      </div>

      {!loading && filtered.length > pageSize && (
        <div className="flex items-center justify-between gap-2 border-t border-line px-4 py-2.5 text-[13px] text-ink-2">
          <span className="tabular">
            {current * pageSize + 1}–{Math.min(filtered.length, (current + 1) * pageSize)} of {filtered.length}
          </span>
          <div className="flex items-center gap-1">
            <button onClick={() => setPage(current - 1)} disabled={current === 0} className="grid size-8 place-items-center rounded-lg hover:bg-surface-3 disabled:opacity-40" aria-label="Previous page">
              <ChevronLeft className="size-4" />
            </button>
            <span className="tabular px-1">
              {current + 1} / {pages}
            </span>
            <button onClick={() => setPage(current + 1)} disabled={current >= pages - 1} className="grid size-8 place-items-center rounded-lg hover:bg-surface-3 disabled:opacity-40" aria-label="Next page">
              <ChevronRight className="size-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
