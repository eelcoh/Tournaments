---
phase: 32-team-badge-tiles
plan: "02"
subsystem: Form/Bracket, Form/Topscorer
tags: [ui, tiles, flags, typography, bracket, topscorer]
dependency_graph:
  requires: []
  provides: [BADGES-02, BADGES-03]
  affects: [Form/Bracket/View.elm, Form/Topscorer.elm]
tech_stack:
  added: []
  patterns: [elm-ui paddingXY, Font.medium, Element.shrink]
key_files:
  modified:
    - src/Form/Bracket/View.elm
    - src/Form/Topscorer.elm
decisions:
  - "viewPlacedBadge uses Element.width shrink (not fill) to match unplaced tile visual consistency"
  - "viewSelectableTeam and viewTeamBadge both updated (same function, different call paths: Phone vs Computer layout)"
  - "Bracket tile height kept at 44px; padding 10/12 fits within that constraint"
metrics:
  duration_seconds: 72
  completed_date: "2026-03-15"
  tasks_completed: 2
  tasks_total: 2
  files_modified: 2
---

# Phase 32 Plan 02: Bracket and Topscorer Tile Layouts Summary

Bracket wizard team tiles and topscorer player tiles updated to match prototype `.team-tile` and `.player-item` specifications: correct SVG flag sizes, font sizes, padding, and name+code two-line column layout (BADGES-02, BADGES-03).

## Tasks Completed

| # | Task | Commit | Files |
|---|------|--------|-------|
| 1 | Update bracket team tiles — flag size, name+code column, padding | cef401f | src/Form/Bracket/View.elm |
| 2 | Update topscorer player tiles — flag size and font sizes | 71965f8 | src/Form/Topscorer.elm |

## Changes Made

### Task 1 — Bracket team tiles (src/Form/Bracket/View.elm)

Updated three functions: `viewSelectableTeam`, `viewTeamBadge`, `viewPlacedBadge`.

- Flag dimensions: 24x24 -> 28x20px in `viewSelectableTeam` and `viewTeamBadge`; 16x16 -> 28x20px in `viewPlacedBadge`
- Single text label replaced with name+code two-line column: 11px medium name + 9px dim lowercase code
- Inner row spacing: 4 -> 8px
- Tile container padding: `paddingXY 6 0` -> `paddingXY 12 10` in all three states
- Tile width: `Element.px 80` -> `Element.shrink` (content determines width; parent row constrains layout)
- `viewPlacedBadge`: added `paddingXY 12 10`, changed `width fill` -> `width shrink`, added name+code column (green name / grey code)

### Task 2 — Topscorer player tiles (src/Form/Topscorer.elm)

Updated `viewPlayerCard`:

- Flag height: 16 -> 18px (width stays 24px for ~3:2 ratio)
- Player name: `Font.size 14` -> `Font.size 12, Font.medium`
- Team code: `Font.size 12` -> `Font.size 10`
- Inner row spacing: 8 -> 10px
- Outer container padding and height unchanged (`paddingXY 12 10`, `height (px 44)`)

## Deviations from Plan

None - plan executed exactly as written.

## Self-Check: PASSED

- src/Form/Bracket/View.elm — modified (contains `Element.px 28`)
- src/Form/Topscorer.elm — modified (contains `Element.px 24`)
- Commit cef401f exists
- Commit 71965f8 exists
- Build passes clean (`make build` succeeded)
