import { useMemo, useState, type ReactNode } from 'react'
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
  searchPlaceholder = 'Search...',
  toolbar,
  onRowClick,
  emptyTitle = 'No data found',
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
    <div className={cn(!bare && 'table-wrap', className)}>
      {showToolbar && (
        <div className="table-toolbar">
          {searchText && (
            <input
              className="search-box"
              value={query}
              onChange={(e) => {
                setQuery(e.target.value)
                setPage(0)
              }}
              placeholder={searchPlaceholder}
            />
          )}
          <div className="toolbar-right">
            {toolbar}
            {exportRow && (
              <button className="btn btn-grey btn-small" onClick={() => downloadCsv(exportName ?? 'lethe-export', filtered.map(exportRow))} disabled={!filtered.length}>
                Export CSV
              </button>
            )}
          </div>
        </div>
      )}

      <div className="table-scroll">
        <table className="my-table">
          <thead>
            <tr>
              {columns.map((c) => (
                <th
                  key={c.key}
                  scope="col"
                  className={cn(c.align === 'right' && 'text-right', c.align === 'center' && 'text-center', c.hideBelow && HIDE[c.hideBelow], c.headerClassName)}
                >
                  {c.sort ? (
                    <button onClick={() => toggleSort(c.key)} className="sort-btn" title="Sort">
                      {c.header}
                      {sort?.key === c.key && <span className="sort-arrow">{sort.dir === 'asc' ? '▲' : '▼'}</span>}
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
                  <tr key={i}>
                    {columns.map((c) => (
                      <td key={c.key} className={cn(c.hideBelow && HIDE[c.hideBelow])}>
                        <div className="loading-bar" />
                      </td>
                    ))}
                  </tr>
                ))
              : visible.map((row) => (
                  <tr key={rowKey(row)} onClick={onRowClick ? () => onRowClick(row) : undefined} className={cn(onRowClick && 'clickable-row', rowClassName?.(row))}>
                    {columns.map((c) => (
                      <td
                        key={c.key}
                        className={cn(c.align === 'right' && 'text-right tabular', c.align === 'center' && 'text-center', c.hideBelow && HIDE[c.hideBelow], c.className)}
                      >
                        {c.cell(row)}
                      </td>
                    ))}
                  </tr>
                ))}
          </tbody>
        </table>
        {!loading && filtered.length === 0 && <EmptyState title={query ? 'No matches' : emptyTitle}>{query ? `Nothing matches "${query}".` : emptyText}</EmptyState>}
      </div>

      {!loading && filtered.length > pageSize && (
        <div className="pager">
          <span>
            Showing {current * pageSize + 1} to {Math.min(filtered.length, (current + 1) * pageSize)} of {filtered.length}
          </span>
          <span>
            <button onClick={() => setPage(current - 1)} disabled={current === 0}>
              &laquo; Prev
            </button>
            Page {current + 1} of {pages}
            <button onClick={() => setPage(current + 1)} disabled={current >= pages - 1}>
              Next &raquo;
            </button>
          </span>
        </div>
      )}
    </div>
  )
}
