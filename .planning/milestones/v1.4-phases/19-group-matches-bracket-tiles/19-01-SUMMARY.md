---
phase: 19-group-matches-bracket-tiles
plan: "01"
subsystem: UI/Form
tags: [styling, group-matches, scroll-wheel, score-input, elm-ui]
dependency_graph:
  requires: []
  provides: [FORM-01, FORM-02]
  affects: [src/UI/Style.elm, src/Form/GroupMatches.elm]
tech_stack:
  added: []
  patterns: [elm-ui Element.focused, matchRowTile border tile pattern]
key_files:
  created: []
  modified:
    - src/UI/Style.elm
    - src/Form/GroupMatches.elm
decisions:
  - "scoreInput uses Border.width 1 all sides; terminalBorder unfocused, orange+activeNav on focus"
  - "matchRowTile exported from UI.Style; takes Bool isActive for orange vs grey border"
  - "Prefix/suffix ASCII arrows removed; tile border now signals active row"
  - "Scroll wheel spacing changed to 0; tiles stack flush with border as separator"
metrics:
  duration: ~1 min
  completed: "2026-03-09"
  tasks_completed: 2
  files_modified: 2
---

# Phase 19 Plan 01: Group Matches Tile Styling Summary

Score input fields and scroll wheel match rows styled to match the prototype tile aesthetic with full borders and larger flags.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Update scoreInput — full border + focus state | 083f7c1 | src/UI/Style.elm |
| 2 | Style scroll wheel rows as bordered tiles with larger flags | 4048d12 | src/UI/Style.elm, src/Form/GroupMatches.elm |

## What Was Built

**Task 1 — scoreInput full border:**
- Changed from bottom-border-only to `Border.width 1` (all 4 sides)
- Unfocused: `Color.terminalBorder` (grey `#4F4F4F`)
- Background: `Color.primaryDark` (`#353535`, matching prototype `.s-inp`)
- Focus state: `Element.focused [ Border.color Color.orange, Font.color Color.activeNav ]` — border turns orange and text brightens to `#F0A030`

**Task 2 — matchRowTile + scroll wheel updates:**
- New `matchRowTile : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)` exported from `UI.Style`
- Active row: `Color.orange` border; inactive: `Color.terminalBorder` border; both `Color.primaryDark` background
- `viewScrollLine` outer container now uses `matchRowTile isActive` with `Element.width fill`
- Flag images enlarged from 16px to 24px
- `textColor` logic: active=`Color.white`, completed=`Color.green`, inactive=`Color.grey`
- ASCII prefix/suffix arrows (`> ... <`) removed; tile border signals active row
- `viewScrollWheel` spacing changed from `2` to `0` (tiles stack flush)

## Deviations from Plan

None - plan executed exactly as written. Added `width fill` to `viewScrollWheel` column as a minor enhancement to ensure tiles span full available width (Rule 2 — correctness for the tile layout).

## Self-Check: PASSED

- src/UI/Style.elm: modified with matchRowTile exported
- src/Form/GroupMatches.elm: modified with tile borders and 24px flags
- Commit 083f7c1: exists
- Commit 4048d12: exists
- `make debug` compiles cleanly
