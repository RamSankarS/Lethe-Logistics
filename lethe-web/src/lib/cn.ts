import clsx, { type ClassValue } from 'clsx'

/** Join class names conditionally. */
export function cn(...values: ClassValue[]) {
  return clsx(values)
}
