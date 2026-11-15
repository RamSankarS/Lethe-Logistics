import { toast } from 'sonner'
import { ShieldAlert } from 'lucide-react'
import { describeError, type FriendlyError } from './errors'

export function notifySuccess(title: string, description?: string) {
  toast.success(title, { description })
}

export function notifyInfo(title: string, description?: string) {
  toast(title, { description })
}

/** Shows a database / network error. Trigger-enforced rules get a shield icon. */
export function notifyError(e: unknown): FriendlyError {
  const f = describeError(e)
  if (f.kind === 'rule') {
    toast.error(f.title, {
      description: f.message,
      icon: <ShieldAlert className="size-4" />,
      duration: 9000,
    })
  } else {
    toast.error(f.title, { description: f.message, duration: 7000 })
  }
  return f
}
