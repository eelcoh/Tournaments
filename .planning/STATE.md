# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-23)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 5 — Bug Fixes and UX Polish

## Current Position

Phase: 5 of 5 (Bug Fixes and UX Polish) — COMPLETE
Plan: 4 of 4 in current phase — COMPLETE (Plans 01-04 all complete)
Status: Plan 05-04 complete — all 5 visual/interactive bug fixes verified by human in browser
Last activity: 2026-02-28 — Plan 05-04 complete (human sign-off on all 5 Phase 5 fixes)

Progress: [██████████] complete

## Performance Metrics

**Velocity:**
- Total plans completed: 8
- Average duration: 1 min
- Total execution time: 9 min

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 01-pwa-infrastructure | 2/2 | 4 min | 2 min |
| 02-touch-targets-and-score-input | 4/4 | 4 min | 1 min |
| 03-bracket-wizard-mobile-layout | 2/2 | 2 min | 1 min |
| 05-bug-fixes-and-ux-polish | 4/4 | ongoing | ~5 min |

**Recent Trend:**
- Last 5 plans: 1 min
- Trend: steady

*Updated after each plan completion*
| Phase 03-bracket-wizard-mobile-layout P02 | 2 | 2 tasks | 1 files |
| Phase 05-bug-fixes-and-ux-polish P03 | 5 min | 2 tasks | 2 files |
| Phase 05-bug-fixes-and-ux-polish P01 | 1 min | 2 tasks | 1 files |
| Phase 05-bug-fixes-and-ux-polish P02 | 1 min | 2 tasks | 1 files |
| Phase 05-bug-fixes-and-ux-polish P04 | 5 min | 2 tasks | 1 files |

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
- [Phase 05-bug-fixes-and-ux-polish P03]: Apply terminalInput False (not True) to comment inputs — no error state on these fields; multiline > prompt uses alignTop + paddingXY 0 8
- [Phase 05-bug-fixes-and-ux-polish P03]: GroupBoundary fix uses centerY on outer el only — text is direct content, no separate centerY needed; height (px 44) matches MatchRow height
- [Phase 05-bug-fixes-and-ux-polish P01]: Sticky button uses Element.inFront on outer el wrapping page — scopes overlay to bracket page only; UI.Page.page signature unchanged
- [Phase 05-bug-fixes-and-ux-polish P01]: viewTeamBadge cell width increased 44px to 60px to fit 16px flag + spacing + 3-char code
- [Phase 05-bug-fixes-and-ux-polish P02]: Used T.displayFull instead of T.fullName (which does not exist) for full team name in viewSelectedTopscorer
- [Phase 05-bug-fixes-and-ux-polish P02]: Terminal list row pattern: height (px 44), onClick, pointer on outer el; prefix + flag/text in inner row

### Roadmap Evolution

- Phase 4 added: make the UI more consistent across all pages

### Pending Todos

None yet.

### Blockers/Concerns

- iOS Safari: no automatic install prompt; in-app tip needed (pass `navigator.standalone` as Elm flag)
- iOS Safari: 7-day cache eviction is a known constraint; do not architect features assuming persistent cache
- `preventDefaultOn "touchend"` confirmed still scoped to scroll wheel column only — no action needed
- Any new static assets added to project must be added to APP_SHELL in src/sw.js

## Session Continuity

Last session: 2026-02-28
Stopped at: Completed 05-04-PLAN.md — human verification of all 5 Phase 5 bug fixes (approved)
Resume file: None
