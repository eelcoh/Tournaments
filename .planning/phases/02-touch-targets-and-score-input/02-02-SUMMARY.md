---
phase: 02-touch-targets-and-score-input
plan: "02"
subsystem: ui
tags: [elm, elm-ui, touch-targets, mobile, inputmode, score-input]

# Dependency graph
requires: []
provides:
  - "Group nav letters (A-L) with 44px tap zones via height (px 44) and paddingXY 8 0"
  - "Scroll wheel match rows with 44px tap zones via height (px 44) on outer el"
  - "Score input fields 60px wide (up from 45px)"
  - "Score input fields trigger numeric keypad via inputmode=numeric attribute"
affects:
  - 02-touch-targets-and-score-input

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Invisible tap zone: wrap interactive text in outer Element.el with height (px 44) and paddingXY, inner el holds visual styling"
    - "centerY on both outer el and inner row ensures text stays vertically centered within 44px zone"
    - "Html.Attributes.attribute \"inputmode\" \"numeric\" for numeric-keypad triggering on mobile without using type=number"

key-files:
  created: []
  modified:
    - src/Form/GroupMatches.elm

key-decisions:
  - "Use inputmode=numeric (not type=number) for score inputs — avoids iOS bugs and leading-zero stripping while still raising numeric keypad"
  - "Tap zone expansion via invisible padding/wrapper — terminal aesthetic (small text) stays visually intact, only hit area grows"

patterns-established:
  - "Tap zone pattern: Element.el [ Events.onClick msg, pointer, height (px 44), paddingXY 8 0, centerY ] (Element.el [ Font.color clr, UI.Font.mono, centerY ] (Element.text label))"
  - "inputmode attribute: Element.htmlAttribute (Html.Attributes.attribute \"inputmode\" \"numeric\") inside Input.text attrs"

requirements-completed: [MOB-01, MOB-02, SCR-01, SCR-02]

# Metrics
duration: 1min
completed: 2026-02-25
---

# Phase 2 Plan 02: Group Match Touch Targets and Score Input Summary

**44px invisible tap zones on group nav letters and scroll-wheel rows, plus inputmode=numeric and 60px-wide score inputs in src/Form/GroupMatches.elm**

## Performance

- **Duration:** 1 min
- **Started:** 2026-02-25T18:53:47Z
- **Completed:** 2026-02-25T18:54:44Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Group nav letters (A-L) now have a 44px-tall invisible tap zone with 8px horizontal padding, while keeping visual letter size unchanged
- Scroll wheel match rows now have a 44px-tall outer el with centered inner row text
- Score input fields widened from 45px to 60px for easier targeting
- Score input fields now trigger numeric keypad on mobile via `inputmode="numeric"` (not `type="number"`)

## Task Commits

Each task was committed atomically:

1. **Task 1: Expand group nav letter and scroll line tap zones to 44px** - `56241b2` (feat)
2. **Task 2: Add inputmode=numeric and widen score inputs to 60px** - `49f15e3` (feat)

## Files Created/Modified
- `src/Form/GroupMatches.elm` - Added height (px 44) tap zones to viewGroupLetter and viewScrollLine; added Html.Attributes import; widened score inputs to 60px; added inputmode=numeric attribute

## Decisions Made
- Used `inputmode="numeric"` instead of `type="number"` as explicitly specified in the plan — avoids iOS/Android bugs (type=number breaks leading zeros and has inconsistent mobile behavior)
- Tap zone expansion uses the invisible-wrapper pattern: outer el owns click+height, inner el owns visual styling — preserves terminal aesthetic

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- MOB-01, MOB-02 (scroll line and group nav tap zones) complete
- SCR-01, SCR-02 (inputmode and input width) complete
- Ready to proceed to remaining plans in phase 02 (320px layout, bracket tap zones, nav tap zones)

---
*Phase: 02-touch-targets-and-score-input*
*Completed: 2026-02-25*
