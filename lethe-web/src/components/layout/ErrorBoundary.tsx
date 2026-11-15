import { Component, type ErrorInfo, type ReactNode } from 'react'
import { AlertOctagon, RotateCcw } from 'lucide-react'

interface State {
  error: Error | null
}

/** Keeps one broken screen from blanking the whole app. */
export class ErrorBoundary extends Component<{ children: ReactNode; resetKey?: string }, State> {
  state: State = { error: null }

  static getDerivedStateFromError(error: Error): State {
    return { error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error('[Lethe] screen crashed', error, info.componentStack)
  }

  componentDidUpdate(prev: { resetKey?: string }) {
    if (prev.resetKey !== this.props.resetKey && this.state.error) this.setState({ error: null })
  }

  render() {
    if (!this.state.error) return this.props.children
    return (
      <div className="mx-auto mt-10 max-w-lg rounded-2xl border border-line bg-surface p-8 text-center shadow">
        <span className="mx-auto mb-4 grid size-12 place-items-center rounded-2xl bg-critical-soft text-critical-text">
          <AlertOctagon className="size-6" />
        </span>
        <h2 className="text-lg font-semibold text-ink">This screen hit an error</h2>
        <p className="mt-1 text-sm text-ink-2">{this.state.error.message}</p>
        <button
          onClick={() => this.setState({ error: null })}
          className="mt-5 inline-flex h-9 items-center gap-2 rounded-lg border border-line px-3.5 text-sm font-medium text-ink hover:bg-surface-2"
        >
          <RotateCcw className="size-4" /> Try again
        </button>
      </div>
    )
  }
}
