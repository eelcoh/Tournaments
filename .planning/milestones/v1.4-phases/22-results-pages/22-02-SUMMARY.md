---
phase: 22-results-pages
plan: "02"
subsystem: results-ui
tags: [elm-ui, resultCard, ranking, topscorers, knockouts, bets, visual-design]
dependency_graph:
  requires: [22-01]
  provides: [RESULTS-01-complete]
  affects: [src/Results/Ranking.elm, src/Results/Topscorers.elm, src/Results/Knockouts.elm, src/Results/Bets.elm]
tech_stack:
  added: []
  patterns: [resultCard container wrapper, spacing 8 card rhythm, Font.color semantic coloring]
key_files:
  created: []
  modified:
    - src/Results/Ranking.elm
    - src/Results/Topscorers.elm
    - src/Results/Knockouts.elm
    - src/Results/Bets.elm
decisions:
  - "[22-02] resultCard applied directly via wrapWithCard pattern in Topscorers and Knockouts — no outer separator wrapper needed"
  - "[22-02] Ranking position number uses Font.color UI.Color.grey, total points uses Font.color UI.Color.orange — consistent with v1.4 amber/grey semantic coloring"
  - "[22-02] Removed now-unused Border imports from Topscorers and Knockouts after separator pattern replaced by resultCard"
  - "[22-02] RESULTS-03 (group standings semantic colors) remains deferred — no group standings table exists in codebase"
metrics:
  duration: "~4 min"
  completed: "2026-03-10"
  tasks_completed: 2
  files_modified: 4
---

# Phase 22 Plan 02: Results Pages Card Treatment — Ranking, Topscorers, Knockouts, Bets Summary

`resultCard` container treatment applied to Ranking (with amber points + grey position), Topscorers, Knockouts, and Bets pages, completing RESULTS-01 card treatment across all five results pages.

## Tasks Completed

| # | Task | Commit | Files |
|---|------|--------|-------|
| 1 | Restyle Ranking page — resultCard with amber points and grey position | f3c54ab | src/Results/Ranking.elm |
| 2 | Apply resultCard to Topscorers, Knockouts, and Bets pages | 4f20d28 | src/Results/Topscorers.elm, src/Results/Knockouts.elm, src/Results/Bets.elm |

## What Was Built

### Ranking (`src/Results/Ranking.elm`)
- Replaced the double-wrapped `darkBox` + separator column in `viewRankingGroup` with a single `resultCard` `Element.row`
- Added `Font.color UI.Color.grey` to position number (dimmed, de-emphasized)
- Added `Font.color UI.Color.orange` to total points (amber, highlighted)
- Changed parent column spacing from `spacingXY 0 20` to `spacingXY 0 8` for tighter card rhythm
- Added `import Element.Font as Font`

### Topscorers (`src/Results/Topscorers.elm`)
- Renamed `wrapWithSeparator` to `wrapWithCard`
- Replaced separator-only `Border.widthEach` column with `UI.Style.resultCard [ Element.paddingXY 12 8 ]`
- Changed parent column spacing from `16` to `8`
- Removed now-unused `import Element.Border as Border`

### Knockouts (`src/Results/Knockouts.elm`)
- Same pattern as Topscorers: `wrapWithCard` using `resultCard`
- Changed parent column spacing from `16` to `8`
- Removed now-unused `import Element.Border as Border`

### Bets (`src/Results/Bets.elm`)
- `viewRow` changed from bare `Element.row [ paddingXY 0 20 ]` to `Element.column (UI.Style.resultCard [ Element.paddingXY 12 10 ])`
- `viewAdminRow` changed from `Element.row [ paddingXY 0 20, spaceEvenly, width (px 300) ]` to `Element.row (UI.Style.resultCard [ Element.paddingXY 12 10, spaceEvenly ])`
- Parent `items` column changed from `paddingXY 0 16` to `Element.spacing 8`
- Removed now-unused `px` and `width` from Element import

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Cleanup] Removed unused Border imports from Topscorers and Knockouts**
- **Found during:** Task 2
- **Issue:** After replacing separator pattern with resultCard, `Border` was no longer referenced in either file
- **Fix:** Removed `import Element.Border as Border` from both files
- **Files modified:** src/Results/Topscorers.elm, src/Results/Knockouts.elm
- **Commit:** 4f20d28

**2. [Rule 1 - Cleanup] Removed unused px and width imports from Bets.elm**
- **Found during:** Task 2
- **Issue:** `width (px 300)` was removed from viewAdminRow; `px` became unused; `width` was only used as qualified `Element.width`
- **Fix:** Removed `px` and `width` from Element expose list
- **Files modified:** src/Results/Bets.elm
- **Commit:** 4f20d28

## Verification

`make build` succeeded cleanly after all changes. No compiler errors or warnings.

## Self-Check: PASSED

All 4 modified files confirmed present. Both task commits (f3c54ab, 4f20d28) confirmed in git log.
