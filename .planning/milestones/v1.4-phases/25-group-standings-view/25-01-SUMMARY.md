---
phase: 25-group-standings-view
plan: "01"
subsystem: results
tags: [standings, group-results, elm, ui]
dependency_graph:
  requires: [Results module, matchResults WebData, UI.Style.resultCard]
  provides: [Results.GroupStandings module, GroupStandings App variant, #groepsstand route]
  affects: [src/Types.elm, src/View.elm]
tech_stack:
  added: [Results.GroupStandings]
  patterns: [WebData pattern matching, List.Extra.groupWhile, Dict accumulation, resultCard]
key_files:
  created:
    - src/Results/GroupStandings.elm
  modified:
    - src/Types.elm
    - src/View.elm
decisions:
  - Used Dict String TeamStanding keyed by teamID for match stat accumulation
  - Fixed 6-element tuple (Elm max is 3) by inlining win/draw/loss logic into updateHome/updateAway functions directly
  - positionColor applies Font.color to entire row element for uniform row color
  - groupWhile used (not groupBy) consistent with Results.Matches pattern since match results arrive ordered by group
  - RefreshResults reused for groepsstand route since matchResults is the shared data source
metrics:
  duration: "~2 min"
  completed: "2026-03-12T20:23:05Z"
  tasks_completed: 2
  files_modified: 3
---

# Phase 25 Plan 01: Group Standings View Summary

Group standings view with color-coded team rows computed from match results data, reachable at `#groepsstand` from the authenticated nav.

## Tasks Completed

| Task | Description | Commit | Files |
|------|-------------|--------|-------|
| 1 | Create Results.GroupStandings module | 045f2ce | src/Results/GroupStandings.elm |
| 2 | Wire GroupStandings into Types, View routing, and navigation | f3eae74 | src/Types.elm, src/View.elm |

## What Was Built

`src/Results/GroupStandings.elm` — new module with:
- `TeamStanding` record tracking played/won/drawn/lost/goalsFor/goalsAgainst/points
- `computeStandings` using `List.Extra.groupWhile` to group MatchResult by `.group`, then Dict accumulation for per-match stat folding
- `positionColor` helper: green for positions 1-2, orange for 3, white for 4+
- `viewStandingRow` with fixed-width columns (pos 20px, team 60px, stats 24px each, pts 28px bold)
- `viewGroupStandings` wrapping each group in `UI.Style.resultCard` with `displayHeader`
- `view` dispatching on `model.matchResults` WebData states

`src/Types.elm` — `GroupStandings` App variant added after `BetsDetailsView`.

`src/View.elm` — full wiring: import, view dispatch, `#groepsstand` route (triggers `RefreshResults`), explicit link branch, added to authenticated `linkList` after `Results`, added to `viewStatusBar` case.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Elm does not allow tuples with more than 3 elements**
- **Found during:** Task 1 compilation
- **Issue:** Initial implementation used a 6-element tuple `(homeWon, homeDraw, homeLost, awayWon, awayDraw, awayLost)` which Elm rejects
- **Fix:** Inlined win/draw/loss logic directly into `updateHome`/`updateAway` helper functions using chained if-else expressions, eliminating the tuple
- **Files modified:** src/Results/GroupStandings.elm
- **Commit:** 045f2ce (fixed before commit, same commit)

## Self-Check

- [x] `src/Results/GroupStandings.elm` — created and exports `view`
- [x] `GroupStandings` in `Types.App` — verified in src/Types.elm
- [x] `#groepsstand` route in `View.getApp` — verified in src/View.elm
- [x] Nav link `groepsstand` in authenticated `linkList` — verified
- [x] `make debug` compiles cleanly — confirmed "Success! Compiled 3 modules."
- [x] Commits 045f2ce and f3eae74 exist

## Self-Check: PASSED
