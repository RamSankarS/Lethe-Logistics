import { forwardRef, type ButtonHTMLAttributes, type ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { cn } from '@/lib/cn'

type Variant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'subtle' | 'success'
type Size = 'xs' | 'sm' | 'md' | 'lg'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant
  size?: Size
  icon?: LucideIcon
  iconRight?: LucideIcon
  loading?: boolean
  children?: ReactNode
}

// which css class each kind of button gets (see styles/main.css)
const COLOURS: Record<Variant, string> = {
  primary: 'btn-blue',
  secondary: 'btn-grey',
  ghost: 'btn-plain',
  danger: 'btn-red',
  subtle: 'btn-lightblue',
  success: 'submit-btn-green',
}

const SIZES: Record<Size, string> = {
  xs: 'btn-tiny',
  sm: 'btn-small',
  md: '',
  lg: 'btn-big',
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = 'secondary', size = 'md', icon: Icon, iconRight: IconRight, loading, className, children, disabled, type = 'button', ...rest },
  ref,
) {
  return (
    <button
      ref={ref}
      type={type}
      disabled={disabled || loading}
      className={cn('btn', COLOURS[variant], SIZES[size], !children && 'icon-btn', className)}
      {...rest}
    >
      {loading ? (children ? 'Please wait...' : '...') : (
        <>
          {Icon && <Icon />}
          {children}
          {IconRight && <IconRight />}
        </>
      )}
    </button>
  )
})
