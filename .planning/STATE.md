# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-23)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 1 complete — PWA Infrastructure done

## Current Position

Phase: 1 of 3 (PWA Infrastructure) — COMPLETE
Plan: 2 of 2 in current phase — COMPLETE
Status: Phase 1 complete
Last activity: 2026-02-24 — Plan 01-02 complete (service worker, index.html, Makefile)

Progress: [██░░░░░░░░] 33%

## Performance Metrics

**Velocity:**
- Total plans completed: 2
- Average duration: 2 min
- Total execution time: 4 min

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 01-pwa-infrastructure | 2/2 | 4 min | 2 min |

**Recent Trend:**
- Last 5 plans: 2 min
- Trend: steady

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- [Planning]: PWA over native app — Elm SPA + service worker is zero-overhead installability
- [Planning]: App-shell caching only (no offline data) — avoids sync complexity
- [Planning]: Keep keyboard score input, improve layout — user prefers typing; focus on spacing/touch-target size
- [Planning]: Vanilla JS service worker (no Workbox) — plain Makefile build; zero external dependencies
- [Phase 01-pwa-infrastructure]: Font woff2 files downloaded from fonts/webfonts/ path in googlefonts/sometype-mono (not fonts/variable/ which has only TTF)
- [Phase 01-pwa-infrastructure]: PWA icons generated with CaskaydiaMono-NF-Bold (DejaVu-Sans-Bold unavailable on Arch Linux)
- [Phase 01-pwa-infrastructure]: No skipWaiting() in SW — cache version bump (CACHE_NAME) is correct update mechanism to avoid disrupting active tabs
- [Phase 01-pwa-infrastructure]: debug Makefile target does not depend on pwa — PWA files not needed for Elm debug iteration

### Pending Todos

None yet.

### Blockers/Concerns

- iOS Safari: no automatic install prompt; in-app tip needed (pass `navigator.standalone` as Elm flag)
- iOS Safari: 7-day cache eviction is a known constraint; do not architect features assuming persistent cache
- `preventDefaultOn "touchend"` must stay scoped to scroll wheel column only — audit during Phase 2
- Any new static assets added to project must be added to APP_SHELL in src/sw.js

## Session Continuity

Last session: 2026-02-24
Stopped at: Completed 01-02-PLAN.md — service worker, index.html PWA wiring, Makefile pwa target
Resume file: None
