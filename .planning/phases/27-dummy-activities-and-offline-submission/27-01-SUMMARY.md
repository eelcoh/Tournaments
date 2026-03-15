---
phase: 27-dummy-activities-and-offline-submission
plan: 01
subsystem: testing
tags: [elm, testMode, activities, offline, dummy-data]

# Dependency graph
requires:
  - phase: 26-mode-foundation
    provides: testMode flag on Model and ActivateTestMode Msg

provides:
  - TestData.Activities module with 5 dummy Activity entries (APost, AComment, AComment, ANewBet, AComment)
  - testMode guards in Main.update for RefreshActivities, SaveComment, SavePost
  - Fully offline activities feed in test mode — no network requests

affects: [28-dummy-bet-data, 29-fill-all-automation]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "testMode guard pattern: if model.testMode then ... else <original code>"
    - "NotAsked fallback to dummyActivities as base list (not empty)"
    - "Offline prepend: newActivity :: existingList with form reset via initComment/initPost"

key-files:
  created:
    - src/TestData/Activities.elm
  modified:
    - src/Main.elm

key-decisions:
  - "TestData.Activities is a plain Elm module with a static list — no dynamic generation needed"
  - "NotAsked fallback uses dummyActivities (not []) so offline submissions look populated"
  - "All branching stays in Main.update; Activities.elm is untouched per plan spec"

patterns-established:
  - "TestData.* namespace for static dummy data modules"
  - "testMode guards wrap original else branch to preserve non-test behavior exactly"

requirements-completed: [ACT-01, ACT-02, ACT-03]

# Metrics
duration: 5min
completed: 2026-03-14
---

# Phase 27 Plan 01: Dummy Activities and Offline Submission Summary

**Static dummy activities injected in test mode with fully offline comment/post submission via testMode guards in Main.update**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-14T22:24:00Z
- **Completed:** 2026-03-14T22:29:10Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Created `src/TestData/Activities.elm` with 5 dummy entries (1 APost, 3 AComment, 1 ANewBet) covering the 2026 tournament window
- Added testMode guard in `RefreshActivities`: injects dummyActivities as Success, no HTTP call
- Added testMode guard in `SaveComment`: prepends new AComment to activity list, resets comment form, no HTTP call
- Added testMode guard in `SavePost`: prepends new APost to activity list, resets post form, no HTTP call
- NotAsked fallback always uses dummyActivities as base, so offline submissions show populated list

## Task Commits

Each task was committed atomically:

1. **Task 1: Create TestData.Activities module with dummy activity list** - `bc0bcce` (feat)
2. **Task 2: Add testMode guards in Main.elm for RefreshActivities, SaveComment, SavePost** - `bbd7af3` (feat)

**Plan metadata:** (docs commit — see final commit)

## Files Created/Modified
- `src/TestData/Activities.elm` - New module: static list of 5 dummy Activity values, exported as `dummyActivities : List Activity`
- `src/Main.elm` - Added `TestData.Activities` import, expanded Types import to include `Activity(..)`, `initComment`, `initPost`; replaced 3 single-line branches with testMode guards

## Decisions Made
- TestData.Activities is a plain Elm module with a static list — no dynamic generation needed for demo purposes
- NotAsked fallback uses dummyActivities (not []) so offline comment/post submissions look populated rather than showing a single entry
- All branching stays in Main.update; Activities.elm module is untouched per plan spec

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Test mode activities feed is fully functional offline
- Ready for Phase 28 (dummy bet data) and Phase 29 (fill-all automation)
- No blockers

---
*Phase: 27-dummy-activities-and-offline-submission*
*Completed: 2026-03-14*
