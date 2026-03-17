---
phase: 36-wizard-view-layer
plan: "01"
subsystem: Form/Bracket/View
tags: [elm, ui, badge, bracket-wizard]
dependency_graph:
  requires: []
  provides: [viewCompactBadge, viewWideBadge, viewPlacedBadge]
  affects: [Form/Bracket/View.elm]
tech_stack:
  added: []
  patterns: [three-state badge, grey veil via Element.inFront, round-aware dimensions]
key_files:
  created: []
  modified:
    - src/Form/Bracket/View.elm
decisions:
  - "viewBadgeVeil inlined (not extracted) — only two call sites, extraction would add noise"
  - "TeamData parameter passed as _ (unused) — viewCompactBadge/viewWideBadge use Bets.Init.teamData directly via canSelectTeam, matching existing patterns in file"
metrics:
  duration: "~3 minutes"
  completed: "2026-03-17"
  tasks_completed: 3
  tasks_total: 3
  files_modified: 1
---

# Phase 36 Plan 01: Bracket Wizard Badge Building Blocks Summary

Three badge functions implemented for the redesigned bracket wizard view layer: compact 48px badges for R32/R16, wide 80px badges for QF-Champion, and an updated placed badge with round-aware dimensions and green border.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Add viewCompactBadge (48px, R32/R16) | c4437d6 | src/Form/Bracket/View.elm |
| 2 | Add viewWideBadge (80px, QF-Champion) | 679a094 | src/Form/Bracket/View.elm |
| 3 | Update viewPlacedBadge (round-aware, green border) | 10efefb | src/Form/Bracket/View.elm |

## What Was Built

- `viewCompactBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg` — 48×44px badge for R32 and R16 with three states: can-select (normal border, `SelectTeam`), selected-in-round (grey veil + `DeselectTeam`), cannot-select (grey veil, no handler)
- `viewWideBadge : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg` — 80×44px badge for QF through Champion, same three-state model, content column shows `Element.paragraph` name (11px, clipX) + sub-code (9px grey)
- `viewPlacedBadge : SelectionRound -> Team -> Element Msg` — updated to accept round, uses `Element.px 48` for LastThirtyTwoRound/LastSixteenRound and `Element.px 80` for QuarterRound through ChampionRound; green border (`Border.color Color.green`) on all variants

Grey veil implemented via `Element.inFront` overlay pattern from UI-SPEC.md:
```elm
Element.el [ Element.inFront (Element.el [ Background.color (rgba 0 0 0 0.45), ... ] Element.none) ] flagImg
```

## Deviations from Plan

None — plan executed exactly as written.

## Self-Check: PASSED

- src/Form/Bracket/View.elm — FOUND
- Commit c4437d6 (viewCompactBadge) — FOUND
- Commit 679a094 (viewWideBadge) — FOUND
- Commit 10efefb (viewPlacedBadge) — FOUND
