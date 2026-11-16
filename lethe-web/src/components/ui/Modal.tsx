import { useEffect, useRef, type ReactNode } from 'react'
import { createPortal } from 'react-dom'
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

/** Keeps the data-portal attribute on popups rendered at <body>. */
function portalAttr(): string | undefined {
  return document.querySelector<HTMLElement>('[data-portal]')?.dataset.portal
}

const SIZE = { sm: 'modal-small', md: '', lg: 'modal-big', xl: 'modal-huge' }

export function Modal({
  open,
  onClose,
  title,
  description,
  children,
  footer,
  size = 'md',
}: {
  open: boolean
  onClose: () => void
  title: ReactNode
  description?: ReactNode
  /** kept so old code still compiles, not shown any more */
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
    <div data-portal={portalAttr()} className="modal-holder">
      <div className="modal-bg" onClick={onClose} />
      <div ref={panel} role="dialog" aria-modal="true" className={cn('modal-box', SIZE[size])}>
        <div className="modal-header">
          <div style={{ minWidth: 0 }}>
            <h2 className="modal-title">{title}</h2>
            {description && <p className="modal-desc">{description}</p>}
          </div>
          <button onClick={onClose} className="modal-close" aria-label="Close" title="Close">
            &times;
          </button>
        </div>
        <div className="modal-content">{children}</div>
        {footer && <div className="modal-footer">{footer}</div>}
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
    <div data-portal={portalAttr()} className="side-panel-holder">
      <div className="modal-bg" onClick={onClose} />
      <aside role="dialog" aria-modal="true" className={cn('side-panel', width)}>
        <div className="side-panel-header">
          <div style={{ minWidth: 0, flex: 1 }}>
            <h2 className="side-panel-title">{title}</h2>
            {subtitle && <div className="side-panel-sub">{subtitle}</div>}
          </div>
          {actions}
          <button onClick={onClose} className="modal-close" aria-label="Close" title="Close">
            &times;
          </button>
        </div>
        <div className="side-panel-body">{children}</div>
      </aside>
    </div>,
    document.body,
  )
}

/** Are you sure? popup for important actions. */
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
          <button onClick={onClose} className="btn btn-grey">
            Cancel
          </button>
          <button onClick={onConfirm} disabled={loading} className={danger ? 'btn btn-red' : 'btn btn-blue'}>
            {loading ? 'Working...' : confirmLabel}
          </button>
        </>
      }
    >
      <div className="confirm-text">{children}</div>
    </Modal>
  )
}
