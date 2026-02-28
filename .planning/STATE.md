# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-23)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 4 — Make the UI More Consistent Across All Pages

## Current Position

Phase: 4 of 5 (Make the UI More Consistent Across All Pages) — Complete
Plan: 4 of 4 in current phase — Plan 04 complete
Status: Plan 04-04 complete — human visual verification approved all UI consistency changes across all pages and viewports
Last activity: 2026-02-28 — Plan 04-04 complete

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
| Phase 04-make-the-ui-more-consistent-across-all-pages P01 | 5 min | 2 tasks | 2 files |
| Phase 04-make-the-ui-more-consistent-across-all-pages P02 | 2 | 2 tasks | 2 files |
| Phase 04-make-the-ui-more-consistent-across-all-pages P03 | 4 min | 2 tasks | 5 files |
| Phase 04-make-the-ui-more-consistent-across-all-pages P04 | 5 min | 2 tasks | 0 files |

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
- [Phase 04-01]: UI.Page.container uses spacing 24 (section-gap tier) while page uses spacing 20 — distinct rhythm for non-form pages
- [Phase 04-01]: dataRow returns Element.row for horizontal children — matches ranking/topscorer row layout patterns
- [Phase 04-01]: UI.Page.container was pre-completed in Phase 5 stray commit b6db886; Task 1 required no code changes
- [Phase 04-make-the-ui-more-consistent-across-all-pages]: viewCommentInput already had terminalInput from Phase 5 P03 — only viewPostInput needed updating in this plan
- [Phase 04-03]: Topscorers viewTopscorerResults changed from wrappedRow to column — terminalBorder separators require column layout for full-width rows
- [Phase 04-03]: terminalBorder separator placed at viewRankingGroup level (one per rank-position group) — groups are the logical section boundaries matching Activities.elm commentBox pattern
- [Phase 04-03]: Removed Element.Events and Font imports from Topscorers; Events import from Ranking after replacing raw onClick with UI.Button.dataRow
- [Phase 04-04]: Form pages satisfy CON-01 through viewCardChrome (fill |> maximum Screen.maxWidth) — no migration of Form internals to UI.Page.container needed; human visual verification approved all 10 checkpoint items

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
Stopped at: Completed 04-04-PLAN.md — human visual verification approved full UI consistency pass across all pages and viewports
Resume file: None
