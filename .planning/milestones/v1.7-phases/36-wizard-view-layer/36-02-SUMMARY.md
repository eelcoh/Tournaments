---
phase: 36-wizard-view-layer
plan: "02"
subsystem: Form/Bracket/View
tags: [elm, ui, bracket-wizard, grid-layout]
dependency_graph:
  requires: [viewCompactBadge, viewWideBadge, viewPlacedBadge]
  provides: [viewActiveGrid, viewR32Grid, viewFlatGrid, viewRoundSection, viewGroup]
  affects: [Form/Bracket/View.elm]
tech_stack:
  added: []
  patterns: [round-based dispatch, screenWidth column threshold, amber group label, no-hide groups]
key_files:
  created: []
  modified:
    - src/Form/Bracket/View.elm
decisions:
  - "Tasks 1 and 2 committed together (680231b) — viewFlatGrid signature change required by viewActiveGrid call site; both tasks needed for successful compilation"
  - "Float->Int conversion for screen.width: round state.screen.width at call site (state.screen.width is Float in UI.Screen.Size)"
metrics:
  duration: "~2 minutes"
  completed: "2026-03-17"
  tasks_completed: 2
  tasks_total: 3
  files_modified: 1
---

# Phase 36 Plan 02: Wire Badge Functions into Grid Layouts Summary

Badge building blocks from Plan 01 wired into grid layout functions: `viewActiveGrid` dispatches R32 to group grid and all other rounds to flat grid, `viewR32Grid` shows all 12 groups with amber letter headers using `viewCompactBadge`, `viewFlatGrid` uses `viewCompactBadge` for R16 and `viewWideBadge` for QF+ with column threshold, `viewGroup` removes `"---"` placeholders and uses `viewCompactBadge` for dimmed placed teams.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Fix viewActiveGrid dispatch and viewR32Grid group display | 680231b | src/Form/Bracket/View.elm |
| 2 | Fix viewFlatGrid column dispatch and badge selection, fix viewGroup Computer path | 680231b | src/Form/Bracket/View.elm |

Note: Tasks 1 and 2 share commit 680231b — viewFlatGrid's new signature (Task 2) was required by the viewActiveGrid call site (Task 1), making them inseparable for compilation.

## What Was Built

**Task 1 — viewActiveGrid dispatch and viewR32Grid:**
- `viewActiveGrid` now dispatches on `SelectionRound` on Phone: `LastThirtyTwoRound -> viewR32Grid`, `_ -> viewFlatGrid`
- `viewRoundSection` and `viewActiveGrid` take new `screenWidth : Int` parameter (threaded from `view` via `round state.screen.width`)
- `viewR32Grid` removes `allPlaced` group-hiding logic — all 12 groups always rendered
- `viewR32Grid` replaces `"-- A --"` separator with amber single-letter group label via `Color.terminalAccentDim`, 12px, `UI.Font.mono`
- `viewR32Grid` uses `viewCompactBadge round sel teamData_` instead of `viewSelectableTeam`

**Task 2 — viewFlatGrid and viewGroup:**
- `viewFlatGrid` takes new `screenWidth : Int` parameter
- Column count: `LastSixteenRound` → 4 columns; QF+ → `if screenWidth < 360 then 2 else 3`
- Badge function: `LastSixteenRound` → `viewCompactBadge`; QF+ → `viewWideBadge`
- `viewGroup` replaces `"---"` placeholder for placed teams with `viewCompactBadge` (dimmed in-place)
- `viewGroup` uses amber `Color.terminalAccentDim` group label instead of `"A:"` format
- `viewGroup` removes `if List.all isPlaced allTeams then Element.none` hiding — all groups always rendered

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Float->Int conversion for state.screen.width**
- **Found during:** Task 1 compilation
- **Issue:** `state.screen.width` in `UI.Screen.Size` is `Float`, but plan specified `screenWidth : Int` in signatures
- **Fix:** Applied `round state.screen.width` at call site in `view` to convert Float to Int
- **Files modified:** src/Form/Bracket/View.elm
- **Commit:** 680231b

## Self-Check: PASSED

- src/Form/Bracket/View.elm — FOUND
- Commit 680231b — FOUND
- `make debug` exits 0 — VERIFIED
- `"---"` matches: 0 — VERIFIED
- `allPlaced` matches: 0 — VERIFIED
- `terminalAccentDim` matches: 2 — VERIFIED
- `screenWidth < 360` present — VERIFIED
- `viewCompactBadge|viewWideBadge|viewPlacedBadge` references: 11 — VERIFIED
