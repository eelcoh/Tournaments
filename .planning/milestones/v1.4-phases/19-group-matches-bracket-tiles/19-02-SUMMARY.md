---
phase: 19-group-matches-bracket-tiles
plan: 02
subsystem: ui
tags: [elm, elm-ui, bracket, form, tiles, bordered-cards]

# Dependency graph
requires:
  - phase: 18-foundation
    provides: Color tokens (terminalBorder, orange, primaryDark, grey, primaryText) used for tile borders
provides:
  - viewTeamBadge with 80x44 bordered card shape, 24x24 flag, hover to orange border
  - viewSelectableTeam with bordered card variants for placed/selectable/disabled states
  - roundDescription helper with Dutch descriptions for each SelectionRound
  - Updated counter format "N/M geselecteerd" with checkmark when complete
affects:
  - Future phases touching Form/Bracket/View.elm

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "elm-ui bordered card tile: Border.width 1, Border.rounded 2, paddingXY 6 0 on Element.el"
    - "Subtle tinted background using rgba float values (0.94, 0.87, 0.69, 0.15) for selected state"
    - "Element.mouseOver [ Border.color Color.orange ] for hover state on selectable tiles"

key-files:
  created: []
  modified:
    - src/Form/Bracket/View.elm

key-decisions:
  - "Both viewTeamBadge and viewSelectableTeam use fixed 80px width to maintain consistent grid layout"
  - "rgba tinted background applied only to placed/selected tiles to distinguish selection state clearly"
  - "roundDescription placed after roundTitle function to keep round-label helpers co-located"

patterns-established:
  - "Bordered tile pattern: primaryDark bg, terminalBorder border default, orange border on hover/selected"
  - "Counter format: N/M geselecteerd (not parenthesised) with Unicode checkmark on completion"

requirements-completed: [FORM-03, FORM-04]

# Metrics
duration: 5min
completed: 2026-03-09
---

# Phase 19 Plan 02: Bracket Tile Cards and Round Header Summary

**Bracket team tiles restyled as 80x44 bordered cards with grey/orange states; round headers updated with "N/M geselecteerd" counter and Dutch description line below title**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-09T17:10:00Z
- **Completed:** 2026-03-09T17:15:00Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- `viewTeamBadge` (Computer grid) updated to 80x44 px bordered card with 24x24 flag, grey border defaulting to orange on hover, grey text for disabled
- `viewSelectableTeam` (Phone grid) updated with three variants: placed (orange border + rgba tinted bg + orange text), selectable (grey border, hover to orange), disabled (grey border + grey text)
- `roundDescription` helper added with Dutch text for all six SelectionRound values
- Counter format changed from `" (N/M)"` to `"N/M geselecteerd"` with checkmark suffix on completion
- Description line rendered below title+counter row in grey at font size 12

## Task Commits

Each task was committed atomically:

1. **Task 1: Bordered bracket team tile cards with selected/hover states** - `26df3f1` (feat)
2. **Task 2: Round header with description and updated counter format** - `b37e43d` (feat)

## Files Created/Modified
- `src/Form/Bracket/View.elm` - Both tasks: viewTeamBadge, viewSelectableTeam, viewRoundSection, roundDescription

## Decisions Made
- Fixed-width 80px cards in both viewTeamBadge and viewSelectableTeam for consistent grid alignment
- rgba(0.94, 0.87, 0.69, 0.15) tint for placed/selected state to subtly distinguish without overwhelming
- roundDescription placed immediately after roundTitle to keep round-related helpers together

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- FORM-03 and FORM-04 requirements satisfied; bracket tile visual redesign complete
- Remaining phase 19 plans (if any) can proceed; bracket card visuals are consistent with the bordered tile pattern

---
*Phase: 19-group-matches-bracket-tiles*
*Completed: 2026-03-09*
