---
phase: 26-mode-foundation
plan: 01
subsystem: ui
tags: [elm, elm-ui, test-mode, routing, navigation]

# Dependency graph
requires: []
provides:
  - testMode : Bool field on Model alias
  - titleTapCount : Int field on Model alias
  - ActivateTestMode and TitleTap Msg variants
  - #test URL route that activates test mode
  - 5-tap title gesture that activates test mode
  - [TEST MODE] badge in status bar when testMode is True
  - Unconditional full nav (9 items) in test mode
affects: [27-test-data, 28-fill-all, 29-offline-mode]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "testMode flag on Model — orthogonal boolean, not an App variant; avoids exhaustive routing case changes"
    - "URL route fires Cmd Msg via Task.succeed msg |> Task.perform identity"
    - "5-tap gesture: titleTapCount increments, resets to 0 on activation"

key-files:
  created: []
  modified:
    - src/Types.elm
    - src/View.elm
    - src/Main.elm

key-decisions:
  - "testMode : Bool on Model (not App variant) — orthogonal to navigation; no new routing or exhaustive case matching needed"
  - "ActivateTestMode handlers added to Main.elm (same task as Msg definition) so build always compiles after each commit"

patterns-established:
  - "Test mode activation: both URL (#test) and gesture (5 taps) routes through ActivateTestMode handler"
  - "Nav bypass: linkList uses if/else on model.testMode before token check"

requirements-completed: [MODE-01, MODE-02, MODE-03, MODE-04]

# Metrics
duration: 2min
completed: 2026-03-14
---

# Phase 26 Plan 01: Mode Foundation Summary

**testMode flag on Elm Model with dual activation (URL #test + 5-tap title), orange [TEST MODE] badge in status bar, and full 9-item nav bypass of auth gate**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-14T12:30:55Z
- **Completed:** 2026-03-14T12:32:35Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Added `testMode : Bool` and `titleTapCount : Int` to `Model msg` type alias and `init` function
- Added `ActivateTestMode` and `TitleTap` to `Msg` type with full update handlers
- Wired `#test` URL fragment to fire `ActivateTestMode` via `Task.perform identity`
- Added tappable "Voetbalpool" title element with `onClick TitleTap` — activates at 5 taps
- Status bar shows `[TEST MODE]  v2026` in orange when `testMode = True`
- `linkList` bypasses token check in test mode, showing all 9 nav items

## Task Commits

Each task was committed atomically:

1. **Task 1: Add testMode and titleTapCount to Types** - `0f2426d` (feat)
2. **Task 2: Wire test mode in View** - `d535813` (feat)

## Files Created/Modified
- `src/Types.elm` - Added testMode/titleTapCount to Model; ActivateTestMode/TitleTap to Msg; initialized in init
- `src/Main.elm` - Added ActivateTestMode and TitleTap update handlers
- `src/View.elm` - #test route, tappable title, [TEST MODE] badge, linkList bypass

## Decisions Made
- `ActivateTestMode` and `TitleTap` handlers added to `Main.elm` in Task 1 (alongside Msg definition) so the build compiles after each atomic commit — Elm's exhaustive pattern matching requires handlers to exist the moment Msg variants are declared.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added Main.elm handlers in Task 1 instead of Task 2**
- **Found during:** Task 1 (Types changes)
- **Issue:** Elm requires exhaustive case matching — adding `ActivateTestMode` and `TitleTap` to Msg without handlers in Main.elm causes a compile error, preventing Task 1's `make build` verification from passing
- **Fix:** Added the two handlers to `Main.elm` as part of Task 1's commit rather than Task 2's commit
- **Files modified:** src/Main.elm
- **Verification:** `make build` passed after Task 1
- **Committed in:** 0f2426d (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (Rule 3 - blocking)
**Impact on plan:** Task 2 files unchanged (handlers moved to Task 1 commit to unblock compilation). No scope creep.

## Issues Encountered
None — straightforward additive changes.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- `testMode` and `titleTapCount` fields are live on all Model instances
- `ActivateTestMode` and `TitleTap` are fully wired end-to-end
- Phase 27 (test data), 28 (fill-all), and 29 (offline mode) can now read `model.testMode` to gate behaviour

---
*Phase: 26-mode-foundation*
*Completed: 2026-03-14*
