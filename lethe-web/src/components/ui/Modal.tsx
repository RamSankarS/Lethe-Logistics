import { useEffect, useRef, type ReactNode } from 'react'
import { createPortal } from 'react-dom'
import { X } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'

function useEscape(open: boolean, onClose: () => void) {
  useEffect(() => {
    if (!open) return
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose()
    document.addEventListener('keydown', onKey)
    const prev = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    return () => {
      document.removeEventListener('keydown', onKey)
      document.body.style.overflow = prev
    }
  }, [open, onClose])
}

/** Keeps the portal's accent colour inside modals rendered at <body>. */
function portalAttr(): string | undefined {
  return document.querySelector<HTMLElement>('[data-portal]')?.dataset.portal
}

const SIZE = { sm: 'max-w-md', md: 'max-w-lg', lg: 'max-w-2xl', xl: 'max-w-4xl' }

export function Modal({
  open,
  onClose,
  title,
  description,
  icon: Icon,
  children,
  footer,
  size = 'md',
}: {
  open: boolean
  onClose: () => void
  title: ReactNode
  description?: ReactNode
  icon?: LucideIcon
  children: ReactNode
  footer?: ReactNode
  size?: keyof typeof SIZE
}) {
  useEscape(open, onClose)
  const panel = useRef<HTMLDivElement>(null)
  useEffect(() => {
    if (open) setTimeout(() => panel.current?.querySelector<HTMLElement>('input:not([type=hidden]),select,textarea')?.focus(), 30)
  }, [open])
  if (!open) return null
  return createPortal(
    <div data-portal={portalAttr()} className="fixed inset-0 z-50 flex items-end justify-center p-0 sm:items-center sm:p-6">
      <div className="absolute inset-0 bg-[#060a12]/55 backdrop-blur-[2px]" onClick={onClose} />
      <div
        ref={panel}
        role="dialog"
        aria-modal="true"
        className={cn('animate-pop relative flex max-h-[92vh] w-full flex-col overflow-hidden rounded-t-2xl border border-line bg-surface shadow-2xl sm:rounded-2xl', SIZE[size])}
      >
        <div className="flex items-start gap-3 border-b border-line px-5 py-4">
          {Icon && (
            <span className="grid size-9 shrink-0 place-items-center rounded-xl bg-accent-soft text-accent-text">
              <Icon className="size-[18px]" />
            </span>
          )}
          <div className="min-w-0 flex-1">
            <h2 className="text-base font-semibold text-ink">{title}</h2>
            {description && <p className="mt-0.5 text-[13px] text-ink-2">{description}</p>}
          </div>
          <button onClick={onClose} className="-mt-1 -mr-2 grid size-8 place-items-center rounded-lg text-muted hover:bg-surface-3 hover:text-ink" aria-label="Close">
            <X className="size-4" />
          </button>
        </div>
        <div className="flex-1 overflow-y-auto px-5 py-5">{children}</div>
        {footer && <div className="flex flex-wrap items-center justify-end gap-2 border-t border-line bg-surface-2 px-5 py-3">{footer}</div>}
      </div>
    </div>,
    document.body,
  )
}

export function Drawer({
  open,
  onClose,
  title,
  subtitle,
  children,
  actions,
  width = 'max-w-2xl',
}: {
  open: boolean
  onClose: () => void
  title: ReactNode
  subtitle?: ReactNode
  children: ReactNode
  actions?: ReactNode
  width?: string
}) {
  useEscape(open, onClose)
  if (!open) return null
  return createPortal(
    <div data-portal={portalAttr()} className="fixed inset-0 z-40 flex justify-end">
      <div className="absolute inset-0 bg-[#060a12]/45" onClick={onClose} />
      <aside role="dialog" aria-modal="true" className={cn('animate-slide-in relative flex h-full w-full flex-col border-l border-line bg-page shadow-2xl', width)}>
        <div className="flex items-start gap-3 border-b border-line bg-surface px-6 py-4">
          <div className="min-w-0 flex-1">
            <h2 className="truncate text-lg font-semibold text-ink">{title}</h2>
            {subtitle && <div className="mt-0.5 text-[13px] text-ink-2">{subtitle}</div>}
          </div>
          {actions}
          <button onClick={onClose} className="grid size-8 place-items-center rounded-lg text-muted hover:bg-surface-3 hover:text-ink" aria-label="Close">
            <X className="size-4" />
          </button>
        </div>
        <div className="flex-1 overflow-y-auto px-6 py-5">{children}</div>
      </aside>
    </div>,
    document.body,
  )
}

/** Confirmation dialog for consequential actions. */
export function ConfirmDialog({
  open,
  onClose,
  onConfirm,
  title,
  children,
  confirmLabel = 'Confirm',
  danger,
  loading,
  icon,
}: {
  open: boolean
  onClose: () => void
  onConfirm: () => void
  title: ReactNode
  children?: ReactNode
  confirmLabel?: string
  danger?: boolean
  loading?: boolean
  icon?: LucideIcon
}) {
  return (
    <Modal
      open={open}
      onClose={onClose}
      title={title}
      icon={icon}
      size="sm"
      footer={
        <>
          <button onClick={onClose} className="h-9 rounded-lg px-3.5 text-sm font-medium text-ink-2 hover:bg-surface-3">
            Cancel
          </button>
          <button
            onClick={onConfirm}
            disabled={loading}
            className={cn(
              'inline-flex h-9 items-center gap-2 rounded-lg px-3.5 text-sm font-medium shadow-sm hover:brightness-110 disabled:opacity-60',
              danger ? 'bg-critical text-white' : 'bg-accent text-accent-ink',
            )}
          >
            {loading ? 'Working…' : confirmLabel}
          </button>
        </>
      }
    >
      <div className="text-sm leading-6 text-ink-2">{children}</div>
    </Modal>
  )
}
