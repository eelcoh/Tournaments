---
phase: 32-team-badge-tiles
plan: 01
subsystem: ui
tags: [elm-ui, group-matches, flags, scroll-wheel]

# Dependency graph
requires:
  - phase: 31-card-headers
    provides: viewScrollLine base layout in Form/GroupMatches.elm
provides:
  - Updated viewScrollLine with 22x16 flags, 11px font, and home/away orientation
affects: [33-activities, visual-consistency]

# Tech tracking
tech-stack:
  added: []
  patterns: [elm-ui row-reverse via child order reversal for home side layout]

key-files:
  created: []
  modified:
    - src/Form/GroupMatches.elm

key-decisions:
  - "Row-reverse for home side achieved by reversing child order [text, flag] in elm-ui (no layoutDirection API)"
  - "Font.size 11 applied to parent row to uniformly set all match row text size"
  - "Element.centerY removed from flagImg (redundant when centerY already on parent row)"

patterns-established:
  - "elm-ui row-reverse: use [text, flag] child order instead of layoutDirection (not available)"

requirements-completed: [BADGES-01]

# Metrics
duration: 5min
completed: 2026-03-15
---

# Phase 32 Plan 01: Team Badge Tiles — Group Match Row Layout Summary

**Group match scroll wheel rows updated to 22x16px SVG flags, 11px monospace text, and home-side row-reverse (text then flag) via elm-ui child order**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-03-15T18:25:00Z
- **Completed:** 2026-03-15T18:30:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Flag images in scroll wheel rows resized from 24x24px to 22x16px (standard landscape flag aspect ratio)
- All match row text set to explicit 11px via Font.size on parent row
- Home side restructured to `[text, flag]` child order achieving prototype row-reverse effect (flag faces inward toward score)
- Away side maintains normal `[flag, text]` order
- Build passes clean with no compiler errors

## Task Commits

Each task was committed atomically:

1. **Task 1: Update group match row — flag size, font size, home/away orientation** - `cf679dc` (feat)

**Plan metadata:** (pending docs commit)

## Files Created/Modified
- `src/Form/GroupMatches.elm` - Updated `viewScrollLine`: flagImg 22x16px, Font.size 11 on parent row, home side [text, flag] / away side [flag, text]

## Decisions Made
- Row-reverse for home side achieved by reversing child order in the sub-row (`[mkEl textColor home, flagImg homeTeam]`) — elm-ui has no `layoutDirection` or `Element.rtl` API
- `Font.size 11` placed on parent row for uniform 11px across all text children (simpler than per-element sizing)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- BADGES-01 complete; group match row layout now matches prototype `.team-side` spec
- Phase 32 Plan 02 can proceed with further badge tile work if planned

---
*Phase: 32-team-badge-tiles*
*Completed: 2026-03-15*
