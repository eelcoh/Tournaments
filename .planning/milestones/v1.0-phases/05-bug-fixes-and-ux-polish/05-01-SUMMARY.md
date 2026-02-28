---
phase: 05-bug-fixes-and-ux-polish
plan: 01
subsystem: ui
tags: [elm-ui, bracket-wizard, flags, sticky-button, checkmark, inFront]

# Dependency graph
requires:
  - phase: 03-bracket-wizard-mobile-layout
    provides: viewTeamBadge and viewSelectableTeam rendering pattern; viewRoundStepperFull/Compact
provides:
  - Flag images in computer-layout bracket team cells (viewTeamBadge fix)
  - Checkmark (U+2713) for completed rounds in both full and compact steppers
  - Sticky "Ga verder" button via Element.inFront + Element.alignBottom on bracket page
affects: [06-future-polish, bracket-wizard, Form/Bracket/View.elm]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Element.inFront + Element.alignBottom on page-scoped wrapper el for sticky overlay (bracket-only, not global layout)"
    - "flagImg let-binding with Element.image + T.flagUrl in viewTeamBadge mirrors viewSelectableTeam pattern"

key-files:
  created: []
  modified:
    - src/Form/Bracket/View.elm

key-decisions:
  - "Sticky button uses Element.inFront on outer Element.el wrapping page call — keeps UI.Page.page signature unchanged and scopes overlay to bracket page only"
  - "Cell width for viewTeamBadge increased from 44px to 60px to accommodate 16px flag + spacing + 3-char code"
  - "Removed viewCompletionButton function after making it dead code — keeps file clean"

patterns-established:
  - "Page-scoped sticky overlay: wrap page call in Element.el [Element.inFront stickyEl, Element.width Element.fill] rather than adding inFront at Element.layout root"

requirements-completed: [ISSUE-1, ISSUE-3]

# Metrics
duration: 1min
completed: 2026-02-28
---

# Phase 05 Plan 01: Bracket Wizard Flags and Sticky Button Summary

**Flag images added to computer-layout bracket grid (viewTeamBadge) and sticky Ga verder button via elm-ui inFront overlay with checkmark stepper indicators**

## Performance

- **Duration:** 1 min
- **Started:** 2026-02-28T13:40:40Z
- **Completed:** 2026-02-28T13:41:40Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added flag images to `viewTeamBadge` (computer layout bracket), matching the pattern already used in `viewSelectableTeam` (phone layout)
- Changed "x" to checkmark character (U+2713) in both `viewRoundStepperFull` dotChar and `viewRoundStepperCompact` prefix for completed rounds
- Replaced inline completion button in page content with sticky `inFront` overlay anchored to bottom of bracket page via `Element.alignBottom`
- Removed now-unused `viewCompletionButton` function to keep the file clean

## Task Commits

Each task was committed atomically:

1. **Task 1: Add flag images to viewTeamBadge (computer layout)** - `8504287` (feat)
2. **Task 2: Checkmark in ASCII stepper + sticky Ga verder button** - `9cb6f75` (feat)

## Files Created/Modified
- `src/Form/Bracket/View.elm` - Added flagImg to viewTeamBadge, checkmark in steppers, sticky inFront button in view

## Decisions Made
- Used `Element.inFront` on a wrapper `Element.el` around the `page "bracket"` call rather than modifying `UI.Page.page` signature — avoids changing all call sites while scoping the overlay to the bracket page only
- Increased `viewTeamBadge` cell width from 44px to 60px to fit 16px flag icon + 4px spacing + 3-char team code
- Removed `viewCompletionButton` function entirely since it became dead code after the sticky button refactor

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

`make build` failed initially because `elm` was not in the shell PATH. Resolved by prepending `/home/eelco/bin` to PATH in all build commands. No code changes required.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Bracket wizard computer layout now shows flags in group selection grid
- Completed rounds show checkmark in both stepper variants
- Sticky "Ga verder" button appears at bracket page bottom when R32 is complete, absent on other pages
- Ready to proceed to Plan 02 (remaining bug fixes: topscorer terminal aesthetic, home page input, group boundary cursor)

## Self-Check: PASSED

- `src/Form/Bracket/View.elm` modified and committed: FOUND (commits 8504287, 9cb6f75)
- `build/main.js` produced by `make build`: FOUND
- Both task commits verified in git log

---
*Phase: 05-bug-fixes-and-ux-polish*
*Completed: 2026-02-28*
