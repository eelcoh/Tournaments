---
phase: 17-topscorer-search
plan: "01"
subsystem: form/topscorer
tags: [search, filter, elm-ui, topscorer, card-state]
dependency_graph:
  requires: []
  provides: [topscorer-search-input, topscorer-filtering]
  affects: [src/Types.elm, src/Main.elm, src/Form/Topscorer.elm, src/Form/View.elm, src/View.elm, src/Form/Dashboard.elm]
tech_stack:
  added: [Html.Events.onInput, Html.input via Element.html]
  patterns: [card-state-mutation-at-top-level, prefix-filter-case-insensitive]
key_files:
  created: []
  modified:
    - src/Types.elm
    - src/View.elm
    - src/Form/View.elm
    - src/Form/Card.elm
    - src/Form/Dashboard.elm
    - src/Form/Topscorer/Types.elm
    - src/Form/Topscorer.elm
    - src/Main.elm
decisions:
  - "UpdateSearch does not mutate Bet — card state updated at top-level update via TopscorerMsg pattern match"
  - "Search input uses Html.input via Element.html (consistent with terminal aesthetic, avoids elm-ui Input.text styling constraints)"
  - "Filtering uses String.startsWith (prefix match) on both T.display (3-letter code) and T.displayFull (full name), case-insensitive"
  - "SelectTeam clears searchQuery to empty string at top-level update, restoring grouped view automatically"
metrics:
  duration_seconds: 124
  completed_date: "2026-03-08"
  tasks_completed: 3
  tasks_total: 3
  files_modified: 8
---

# Phase 17 Plan 01: Topscorer Search Summary

Live search filter input added to TopscorerCard using prefix matching on team code/name, with card state mutation wired through the top-level Elm update.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Add searchQuery state to TopscorerCard | 0066dc5 | Types.elm, View.elm, Form/View.elm, Form/Dashboard.elm |
| 2 | Add UpdateSearch msg, filtering logic, search input view | d310047 | Form/Topscorer/Types.elm, Form/Topscorer.elm |
| 3 | Wire card state through top-level update | df3a073 | Main.elm |

## What Was Built

- `TopscorerCard { searchQuery : String }` — card variant now carries search state
- `> zoeken:` prefixed HTML input at top of TopscorerCard, always visible
- Real-time prefix filtering: matches against T.display (3-letter code) or T.displayFull (full name), case-insensitive
- Empty search: full A-L grouped layout shown (unchanged from before)
- Non-empty search with matches: flat list with no group headers
- Non-empty search with no matches: `geen landen gevonden voor "xyz"` message
- SelectTeam auto-clears searchQuery at top-level update, returning to full grouped view

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Missing pattern match] Form/Dashboard.elm had bare TopscorerCard pattern**
- Found during: Task 1 (first compile attempt)
- Issue: Form/Dashboard.elm had `TopscorerCard ->` in findCardIndex (not mentioned in plan)
- Fix: Updated to `TopscorerCard _ ->`
- Files modified: src/Form/Dashboard.elm
- Commit: 0066dc5

## Self-Check

- [x] Build passes: `make debug` exits 0
- [x] TopscorerCard { searchQuery : String } present in Types.elm (line 92)
- [x] UpdateSearch String in Form/Topscorer/Types.elm (line 9)
- [x] "> zoeken:" in Form/Topscorer.elm (line 154)
- [x] "geen landen gevonden voor" in Form/Topscorer.elm (line 178)
- [x] All 3 task commits present: 0066dc5, d310047, df3a073

## Self-Check: PASSED
