import { cn } from '@/lib/cn'

/** Lethe mark: an "L" (the closed loop's ledger) with a tracked unit. */
export function LetheMark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 64 64" className={cn('size-9', className)} aria-hidden>
      <rect width="64" height="64" rx="16" fill="#111a2e" />
      <path d="M20 16v32h24" fill="none" stroke="#5eead4" strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" />
      <circle cx="44" cy="20" r="6" fill="#a78bfa" />
    </svg>
  )
}

export function Brand({ className, subtitle = 'Logistics' }: { className?: string; subtitle?: string }) {
  return (
    <div className={cn('flex items-center gap-2.5', className)}>
      <LetheMark />
      <div className="leading-tight">
        <p className="text-[17px] font-semibold tracking-tight text-white">Lethe</p>
        <p className="text-[11px] font-medium tracking-[0.14em] text-white/55 uppercase">{subtitle}</p>
      </div>
    </div>
  )
}
