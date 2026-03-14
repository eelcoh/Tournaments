---
phase: 22-results-pages
plan: 01
subsystem: ui
tags: [elm-ui, results, matches, styling, elm]

# Dependency graph
requires:
  - phase: 18-foundation
    provides: Color constants (orange, grey, primaryDark, terminalBorder) and UI.Style helpers
  - phase: 19-group-matches-bracket-tiles
    provides: matchRowTile pattern used as reference for resultCard design
provides:
  - resultCard style helper in UI.Style for section card containers
  - Grouped column match list layout in Results/Matches.elm
  - Amber/grey conditional score coloring
affects:
  - 22-results-pages (plan 02 uses resultCard)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - resultCard helper: no-padding container for section rows, match rows handle own paddingXY
    - List.Extra.groupWhile for grouping consecutive same-group matches into sections
    - Conditional Font.color based on Maybe Score for semantic color coding

key-files:
  created: []
  modified:
    - src/UI/Style.elm
    - src/Results/Matches.elm

key-decisions:
  - "22-01: resultCard has paddingXY 0 0 — match rows handle own paddingXY 12 8, consistent with matchRowTile pattern"
  - "22-01: List.Extra.groupWhile used (not groupBy) since matches are already ordered by group in API response"
  - "22-01: displayScore uses Font.color directly instead of UI.Style.score helper — avoids amber color being overridden by score helper's Font.center"

patterns-established:
  - "resultCard: width fill container with primaryDark bg and 1px terminalBorder, no padding"
  - "Section layout: header (displayHeader) + rows inside resultCard column"

requirements-completed:
  - RESULTS-01
  - RESULTS-02

# Metrics
duration: 2min
completed: 2026-03-10
---

# Phase 22 Plan 01: Results Matches Page Restyle Summary

**Matches results page restyled with group-section card containers, full-width match rows, and amber/grey conditional score coloring using List.Extra.groupWhile**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-10T19:58:37Z
- **Completed:** 2026-03-10T20:00:26Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- Added `resultCard` style helper to `UI.Style` for reuse across results pages (plan 02+)
- Replaced `wrappedRow` grid layout with grouped column sections per group (A-L)
- Each group section wrapped in `resultCard` card container with header
- `displayMatch` now renders full-width horizontal row: home team | score | away team
- `displayScore` uses `Color.orange` for played scores, `Color.grey` for unplayed `_-_` placeholder

## Task Commits

1. **Task 1: Add resultCard style helper to UI.Style** - `33a3621` (feat)
2. **Task 2: Restyle Results/Matches.elm grouped column layout** - `b549931` (feat)

## Files Created/Modified

- `src/UI/Style.elm` - Added `resultCard` export and function definition near `darkBox`
- `src/Results/Matches.elm` - New grouped layout, horizontal match rows, conditional score colors

## Decisions Made

- `resultCard` uses `paddingXY 0 0` (no padding) — match rows handle their own `paddingXY 12 8`, consistent with the Phase 19 `matchRowTile` pattern
- Used `List.Extra.groupWhile` (consecutive grouping) rather than `groupBy` — matches are already ordered by group in the API response, so groupWhile is correct and more efficient
- `displayScore` uses `Font.color` directly rather than reusing `UI.Style.score` helper to avoid the score helper's styling overriding the conditional amber/grey color

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

- `resultCard` is exported from `UI.Style` and ready for Plan 02 (Rankings/Standings page) to use
- Matches page grouped column layout is in place
- No blockers

---
*Phase: 22-results-pages*
*Completed: 2026-03-10*
