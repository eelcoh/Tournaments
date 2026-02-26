# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-23)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 3 — Bracket Wizard Mobile Layout (in progress)

## Current Position

Phase: 3 of 3 (Bracket Wizard Mobile Layout) — IN PROGRESS
Plan: 1 of 4 in current phase — COMPLETE
Status: Phase 3 plan 01 complete — WizardState extended with viewingRound and JumpToRound Msg
Last activity: 2026-02-26 — Plan 03-01 complete (viewingRound : Maybe SelectionRound in WizardState, JumpToRound handler in update)

Progress: [██████░░░░] 58%

## Performance Metrics

**Velocity:**
- Total plans completed: 7
- Average duration: 1 min
- Total execution time: 8 min

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 01-pwa-infrastructure | 2/2 | 4 min | 2 min |
| 02-touch-targets-and-score-input | 4/4 | 4 min | 1 min |
| 03-bracket-wizard-mobile-layout | 1/4 | 1 min | 1 min |

**Recent Trend:**
- Last 5 plans: 1 min
- Trend: steady

*Updated after each plan completion*
| Phase 03-bracket-wizard-mobile-layout P02 | 2 | 2 tasks | 1 files |

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
- [Phase 02-touch-targets-and-score-input]: Only height changed for pill/navlink/scoreButton_ — terminal aesthetic stays intact, only hit area grows to 44px
- [Phase 03-bracket-wizard-mobile-layout]: viewingRound lives in WizardState (inside BracketWizard), not in BracketState — keeps navigation state co-located with wizard selections
- [Phase 03-bracket-wizard-mobile-layout]: SelectTeam/DeselectTeam use { wizardState | selections = newSelections } record update syntax to preserve viewingRound across team picks
- [Phase 03-bracket-wizard-mobile-layout]: List.Extra.slice unavailable in list-extra 8.2.4 — replaced with List.drop/List.take for compact stepper window
- [Phase 03-bracket-wizard-mobile-layout]: viewSelectableTeam uses Element.width fill so 4-column row distributes ~85px per cell (flag + 3-char code fits comfortably)

### Pending Todos

None yet.

### Blockers/Concerns

- iOS Safari: no automatic install prompt; in-app tip needed (pass `navigator.standalone` as Elm flag)
- iOS Safari: 7-day cache eviction is a known constraint; do not architect features assuming persistent cache
- `preventDefaultOn "touchend"` confirmed still scoped to scroll wheel column only — no action needed
- Any new static assets added to project must be added to APP_SHELL in src/sw.js

## Session Continuity

Last session: 2026-02-26
Stopped at: Completed 03-01-PLAN.md — WizardState extended with viewingRound and JumpToRound Msg for stepper tap navigation
Resume file: None
