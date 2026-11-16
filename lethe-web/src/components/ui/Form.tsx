import { forwardRef, useId, type InputHTMLAttributes, type ReactNode, type SelectHTMLAttributes, type TextareaHTMLAttributes } from 'react'
import { cn } from '@/lib/cn'

export function Field({
  label,
  hint,
  error,
  children,
  className,
  required,
  htmlFor,
}: {
  label?: ReactNode
  hint?: ReactNode
  error?: ReactNode
  children: ReactNode
  className?: string
  required?: boolean
  htmlFor?: string
}) {
  return (
    <div className={cn('form-group', className)}>
      {label && (
        <label htmlFor={htmlFor} className="form-label">
          {label}
          {required && <span className="req-star">*</span>}
        </label>
      )}
      {children}
      {error ? <p className="form-error">{error}</p> : hint ? <p className="form-hint">{hint}</p> : null}
    </div>
  )
}

export const Input = forwardRef<HTMLInputElement, InputHTMLAttributes<HTMLInputElement>>(function Input({ className, ...rest }, ref) {
  return <input ref={ref} className={cn('text-input', className)} {...rest} />
})

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaHTMLAttributes<HTMLTextAreaElement>>(function Textarea({ className, ...rest }, ref) {
  return <textarea ref={ref} className={cn('text-area', className)} {...rest} />
})

// just the normal browser dropdown
export const Select = forwardRef<HTMLSelectElement, SelectHTMLAttributes<HTMLSelectElement>>(function Select({ className, children, ...rest }, ref) {
  return (
    <select ref={ref} className={cn('select-box', className)} {...rest}>
      {children}
    </select>
  )
})

export function Checkbox({ label, checked, onChange, disabled, description }: { label: ReactNode; checked: boolean; onChange: (v: boolean) => void; disabled?: boolean; description?: ReactNode }) {
  const id = useId()
  return (
    <label htmlFor={id} className={cn('check-label', disabled && 'check-disabled')}>
      <input id={id} type="checkbox" checked={checked} disabled={disabled} onChange={(e) => onChange(e.target.checked)} />
      <span>
        {label}
        {description && <small>{description}</small>}
      </span>
    </label>
  )
}

/** ON / OFF button */
export function Switch({ checked, onChange, disabled, label }: { checked: boolean; onChange: (v: boolean) => void; disabled?: boolean; label?: string }) {
  return (
    <button type="button" role="switch" aria-checked={checked} aria-label={label} disabled={disabled} onClick={() => onChange(!checked)} className={checked ? 'toggle-btn on' : 'toggle-btn'}>
      {checked ? 'ON' : 'OFF'}
    </button>
  )
}

/** Two-column grid for forms. */
export function FormGrid({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={cn('form-grid', className)}>{children}</div>
}
