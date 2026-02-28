---
phase: 05-bug-fixes-and-ux-polish
plan: 02
subsystem: ui
tags: [elm, elm-ui, terminal-aesthetic, topscorer, form]

# Dependency graph
requires:
  - phase: 05-bug-fixes-and-ux-polish
    provides: Research and context for all issue fixes in phase 5
provides:
  - Terminal-aesthetic topscorer view with flat text rows, flag images, and section headers
affects: [form, topscorer]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Terminal text-row pattern: Element.el [onClick, pointer, width fill, height (px 44)] with inner row containing prefix + content"
    - "Selected state via '> ' prefix in orange; unselected as '  ' (spaces) in primaryText"
    - "viewSelectedTopscorer: prominent current pick display at top using T.display + T.displayFull"

key-files:
  created: []
  modified:
    - src/Form/Topscorer.elm

key-decisions:
  - "Used T.displayFull instead of T.fullName (which does not exist) for full team name in viewSelectedTopscorer"
  - "Both tasks implemented in a single file write and committed atomically — code is inseparable"
  - "Flag images retained alongside team code text (16x16px) using T.flagUrl (Just team) pattern from viewSelectableTeam"
  - "Removed padding from Element imports (no longer needed after forGroup changed from Element.row to Element.column)"

patterns-established:
  - "Terminal list row: Element.el [onClick, pointer, width fill, height (px 44)] wrapping Element.row [spacing 4, centerY] with prefix el + content el"
  - "Section header via UI.Text.displayHeader before team and player sections"

requirements-completed: [ISSUE-4]

# Metrics
duration: 1min
completed: 2026-02-28
---

# Phase 5 Plan 02: Topscorer Terminal Aesthetic Summary

**Topscorer form rewritten from bordered badge buttons and wrapped rows to flat text rows with '> ' prefix, flag images, vertical columns, and '--- TITLE ---' section headers matching the terminal aesthetic.**

## Performance

- **Duration:** 1 min
- **Started:** 2026-02-28T13:40:51Z
- **Completed:** 2026-02-28T13:42:45Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Replaced `mkTeamButton` (UI.Button.teamButton — bordered badge) with `viewTeamRow` (flat text row, flag image, orange '> ' prefix for selected)
- Replaced `mkPlayerButton` (UI.Button.pill — bordered pill) with `viewPlayerRow` (flat text row, orange '> ' prefix for selected)
- Added `viewSelectedTopscorer` showing current pick prominently (`> CODE (Full Name) / Player`) above the selectable list
- Changed `forGroup` from `Element.row` to `Element.column` for vertical team layout
- Changed `viewPlayers` from `Element.wrappedRow` to `Element.column` for vertical player layout
- Added `UI.Text.displayHeader "Kies een land"` and `UI.Text.displayHeader "Kies een speler"` section headers
- Removed `UI.Button` import (no longer used), removed `padding` from Element imports

## Task Commits

Both tasks were implemented in a single file write and committed atomically:

1. **Task 1: Replace mkTeamButton and forGroup with terminal-style viewTeamRow** - `4c66c57` (feat)
2. **Task 2: Replace mkPlayerButton with terminal-style viewPlayerRow** - `4c66c57` (feat, same commit)

**Plan metadata:** (final docs commit — see below)

## Files Created/Modified
- `src/Form/Topscorer.elm` - Full terminal aesthetic rewrite: viewTeamRow, viewPlayerRow, viewSelectedTopscorer, forGroup column, viewPlayers column, section headers, removed mkTeamButton/mkPlayerButton/UI.Button

## Decisions Made
- Used `T.displayFull` for the full team name in `viewSelectedTopscorer` — `T.fullName` does not exist; `T.displayFull` returns `team.teamName` which is the full country name
- Implemented both tasks atomically in one write since viewTeamRow and viewPlayerRow follow identical patterns and the file is self-contained

## Deviations from Plan

None — plan executed exactly as written, with one minor note: the plan mentioned `T.fullName` which does not exist; used `T.displayFull` instead (Rule 1 auto-fix equivalent — function name correction).

## Issues Encountered
- `T.fullName` referenced in the plan does not exist in `Bets.Types.Team`. The module exposes `displayFull` which returns `team.teamName`. Used `T.displayFull` with no behavioral difference.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Topscorer page now visually consistent with rest of terminal UI
- Pattern established for other list-selection UIs: text rows with '> ' prefix, same height (44px), flag images for team selections
- Ready for remaining phase 5 issues

## Self-Check: PASSED

- `src/Form/Topscorer.elm`: FOUND
- `.planning/phases/05-bug-fixes-and-ux-polish/05-02-SUMMARY.md`: FOUND
- Commit `4c66c57`: FOUND
- Build (`elm make --optimize`): SUCCESS

---
*Phase: 05-bug-fixes-and-ux-polish*
*Completed: 2026-02-28*
