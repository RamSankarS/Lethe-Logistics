import { forwardRef, type ButtonHTMLAttributes, type ReactNode } from 'react'
import type { LucideIcon } from 'lucide-react'
import { Loader2 } from 'lucide-react'
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

const VARIANTS: Record<Variant, string> = {
  primary: 'bg-accent text-accent-ink shadow-sm hover:brightness-110 active:brightness-95',
  secondary: 'bg-surface text-ink border border-line hover:bg-surface-2 hover:border-line-strong shadow-[0_1px_1px_rgba(16,24,40,0.04)]',
  ghost: 'text-ink-2 hover:bg-surface-3 hover:text-ink',
  danger: 'bg-critical text-white shadow-sm hover:brightness-110 active:brightness-95',
  subtle: 'bg-accent-soft text-accent-text hover:brightness-95',
  success: 'bg-good text-white shadow-sm hover:brightness-110',
}

const SIZES: Record<Size, string> = {
  xs: 'h-7 px-2 text-xs gap-1 rounded-md',
  sm: 'h-8 px-2.5 text-[13px] gap-1.5 rounded-lg',
  md: 'h-9 px-3.5 text-sm gap-2 rounded-lg',
  lg: 'h-11 px-5 text-[15px] gap-2 rounded-xl',
}

const ICON: Record<Size, string> = { xs: 'size-3.5', sm: 'size-4', md: 'size-4', lg: 'size-[18px]' }

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = 'secondary', size = 'md', icon: Icon, iconRight: IconRight, loading, className, children, disabled, type = 'button', ...rest },
  ref,
) {
  return (
    <button
      ref={ref}
      type={type}
      disabled={disabled || loading}
      className={cn(
        'inline-flex shrink-0 items-center justify-center font-medium whitespace-nowrap transition-[filter,background-color,border-color,color] duration-150 select-none',
        'disabled:pointer-events-none disabled:opacity-50',
        VARIANTS[variant],
        SIZES[size],
        !children && (size === 'xs' ? 'w-7 px-0' : size === 'sm' ? 'w-8 px-0' : size === 'md' ? 'w-9 px-0' : 'w-11 px-0'),
        className,
      )}
      {...rest}
    >
      {loading ? <Loader2 className={cn(ICON[size], 'animate-spin')} /> : Icon ? <Icon className={ICON[size]} /> : null}
      {children}
      {IconRight && !loading ? <IconRight className={ICON[size]} /> : null}
    </button>
  )
})
