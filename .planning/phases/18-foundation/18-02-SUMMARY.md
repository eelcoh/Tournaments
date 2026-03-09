---
phase: 18-foundation
plan: "02"
subsystem: form-chrome
tags: [nav, progress-rail, bottom-nav, elm-ui, form]
dependency_graph:
  requires: []
  provides: [form-progress-rail, form-bottom-nav]
  affects: [src/Form/View.elm]
tech_stack:
  added: []
  patterns: [Element.inFront + alignBottom for fixed overlay, fillPortion for proportional segments, mouseOver for hover state]
key_files:
  created: []
  modified:
    - src/Form/View.elm
decisions:
  - "Used [!] indicator instead of exact incomplete counts — simpler and satisfies NAV-03"
  - "incompleteIndicator returns empty string for DashboardCard/IntroCard/SubmitCard (no counting needed)"
  - "groupSectionTargetIndex kept as utility even though no longer used by removed viewTopCheckboxes — left for potential future use"
metrics:
  duration: "~2 minutes"
  completed_date: "2026-03-09"
  tasks_completed: 2
  files_modified: 1
---

# Phase 18 Plan 02: Form Navigation Chrome Summary

**One-liner:** Segmented progress rail replacing checkbox row, plus fixed bottom nav with prev/next and amber incomplete indicator using elm-ui inFront overlay pattern.

## What Was Built

Replaced the old `[x]/[.]/[ ]` checkbox navigation row in `src/Form/View.elm` with two new components:

1. **`viewProgressRail`** — a full-width row of thin colored bar segments (one per card), using `fillPortion 1` for equal sizing, `Background.color` for state colors (orange=active, green=completed, grey+alpha=pending), and `Element.Events.onClick (NavigateTo i)` for click navigation.

2. **`viewBottomNav`** — a fixed bottom overlay (via `Element.inFront` + `Element.alignBottom` on `viewCardChrome`) with three zones: `< vorige` / card label + `[!]` indicator / `volgende >`. Boundary cards have prev/next disabled via `Element.alpha 0.35` and `not-allowed` cursor. Active buttons show hover color via `Element.mouseOver [Font.color Color.activeNav]`.

Helper functions added:
- `cardLabel : Card -> String` — maps Card variants to Dutch display names
- `incompleteIndicator : Model Msg -> Card -> String` — returns `" [!]"` when a card has unfinished items, empty string otherwise

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Replace viewTopCheckboxes with viewProgressRail | cd7728b | src/Form/View.elm |
| 2 | Add fixed bottom nav with prev/next and step label | 1b87a2b | src/Form/View.elm |

## Deviations from Plan

None — plan executed exactly as written.

## Verification

- `make build` exits 0
- `viewProgressRail` present in Form/View.elm (3 references)
- `viewTopCheckboxes` completely removed (0 references)
- `viewBottomNav` present (3 references)
- `inFront` used to attach bottom nav (1 reference)
- No `Debug.log` or `Debug.todo` in Form/View.elm

## Self-Check: PASSED

Files exist:
- src/Form/View.elm — FOUND (modified)

Commits exist:
- cd7728b — feat(18-02): replace viewTopCheckboxes with segmented progress rail
- 1b87a2b — feat(18-02): add fixed bottom nav with prev/next and step label
