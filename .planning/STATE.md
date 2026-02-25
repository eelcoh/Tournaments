# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-23)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 2 — Touch Targets and Score Input (in progress)

## Current Position

Phase: 2 of 3 (Touch Targets and Score Input) — IN PROGRESS
Plan: 4 of 4 in current phase — COMPLETE
Status: Phase 2 plan 04 complete — responsive page padding for Phone screen sizes
Last activity: 2026-02-25 — Plan 02-04 complete (8px padding on Phone, 24px on Computer, 296px content width on 320px screen)

Progress: [█████░░░░░] 50%

## Performance Metrics

**Velocity:**
- Total plans completed: 4
- Average duration: 1 min
- Total execution time: 6 min

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 01-pwa-infrastructure | 2/2 | 4 min | 2 min |
| 02-touch-targets-and-score-input | 4/4 | 4 min | 1 min |

**Recent Trend:**
- Last 5 plans: 1 min
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
- [Phase 02-touch-targets-and-score-input]: Use inputmode=numeric (not type=number) for score inputs — avoids iOS/Android bugs and leading-zero stripping
- [Phase 02-touch-targets-and-score-input]: Tap zone expansion via invisible-wrapper pattern — terminal aesthetic (small text) stays visually intact, only hit area grows to 44px
- [Phase 02-touch-targets-and-score-input]: Use Screen.device (existing Phone/Computer breakpoint at 500px) for padding selection — no new types needed
- [Phase 02-touch-targets-and-score-input]: Reduce both outer page horizontal padding AND inner contents padding to 8px on Phone — gives 296px content width on 320px screen

### Pending Todos

None yet.

### Blockers/Concerns

- iOS Safari: no automatic install prompt; in-app tip needed (pass `navigator.standalone` as Elm flag)
- iOS Safari: 7-day cache eviction is a known constraint; do not architect features assuming persistent cache
- `preventDefaultOn "touchend"` confirmed still scoped to scroll wheel column only — no action needed
- Any new static assets added to project must be added to APP_SHELL in src/sw.js

## Session Continuity

Last session: 2026-02-25
Stopped at: Completed 02-04-PLAN.md — responsive page padding for Phone screen sizes (8px sides on Phone, 296px content width on 320px screen)
Resume file: None
