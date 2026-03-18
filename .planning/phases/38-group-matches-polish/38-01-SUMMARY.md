---
phase: 38-group-matches-polish
plan: 01
subsystem: ui
tags: [elm-ui, responsive, group-matches, badges, screen-size]

# Dependency graph
requires: []
provides:
  - Responsive flag+name badges in group matches scroll wheel (150px wide / 85px compact)
  - Screen.Size threading through GroupMatches view stack
  - Mirrored home/away badge layout with fixed-width score column
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "isWide (screen.width >= 400) local helper for 400px responsive threshold"
    - "Thread Screen.Size as first param: view -> viewScrollWheel -> viewWindowLine -> viewScrollLine"
    - "Badge layout: homeBadge = flag + text, awayBadge = text + flag (mirrored)"

key-files:
  created: []
  modified:
    - src/Form/GroupMatches.elm
    - src/Form/View.elm

key-decisions:
  - "Used 400px threshold (not Screen.device's 500px) for badge width breakpoint as specified"
  - "T.displayFull / T.display take Team (not Maybe Team); T.flagUrl takes Maybe Team"
  - "homeTeam/awayTeam from M.homeTeam/awayTeam return Team directly, not Maybe Team — simplified case expression to direct badge calls"

patterns-established:
  - "Responsive badges: 150px (isWide) shows flag + full name; 85px shows flag + 3-letter code"
  - "Score column: fixed px 48, centered, orange when active, green when complete, grey otherwise"

requirements-completed: [GMATCH-01, GMATCH-02, GMATCH-03, GMATCH-04, GMATCH-05, GMATCH-06]

# Metrics
duration: 2min
completed: 2026-03-18
---

# Phase 38 Plan 01: Group Matches Polish Summary

**Responsive flag+name badges in group match scroll wheel: 150px wide badges on >=400px screens, 85px compact badges on narrow screens, with mirrored home/away layout and 48px fixed score column**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-18T22:09:54Z
- **Completed:** 2026-03-18T22:12:00Z
- **Tasks:** 1
- **Files modified:** 2

## Accomplishments
- Changed `view` signature to `Screen.Size -> Bet -> State -> Element.Element Msg`
- Added `isWide : Screen.Size -> Bool` using 400px threshold
- Threaded `screen` parameter through the entire view chain (viewScrollWheel, viewWindowLine, viewScrollLine)
- Rewrote match rows: home badge (flag-left, name-right), 48px score column, away badge (name-left, flag-right)
- Updated `Form.View.elm` call site to pass `model.screen`

## Task Commits

Each task was committed atomically:

1. **Task 1: Thread Screen.Size and rewrite viewScrollLine with responsive badges** - `1e6284e` (feat)

**Plan metadata:** (docs commit to follow)

## Files Created/Modified
- `src/Form/GroupMatches.elm` - Added Screen.Size threading, isWide helper, homeBadge/awayBadge functions with responsive widths
- `src/Form/View.elm` - Updated GroupMatches.view call to pass model.screen

## Decisions Made
- Used 400px breakpoint (not Screen.device's 500px threshold) as plan specified
- Discovered that `M.homeTeam` and `M.awayTeam` return `Team` (not `Maybe Team`), so the badge functions take `Team` directly — simplified the row body from `case` expressions to direct calls
- `T.display` and `T.displayFull` both take `Team` (not `Maybe Team`); `T.flagUrl` takes `Maybe Team`

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Corrected type signatures for T.display, T.displayFull, and M.homeTeam**
- **Found during:** Task 1 (build verification)
- **Issue:** Plan's interface section stated `T.display : Maybe Team -> String` and implied `M.homeTeam : Match -> Maybe Team`, but actual signatures are `T.display : Team -> String`, `T.displayFull : Team -> String`, and `M.homeTeam : Match -> Team`
- **Fix:** Removed `Just` wrapper from `T.display`/`T.displayFull` calls; simplified badge row from `case` unwrapping to direct `homeBadge homeTeam` calls
- **Files modified:** src/Form/GroupMatches.elm
- **Verification:** `make debug` exits 0
- **Committed in:** 1e6284e (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (Rule 1 - type mismatch in plan's interface spec)
**Impact on plan:** Fix required for compilation; no change to intended behavior or architecture.

## Issues Encountered
- Plan's interface section showed `T.display : Maybe Team -> String` but actual signature is `T.display : Team -> String`. Compiler error revealed this; fixed in the same task.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All 6 requirements (GMATCH-01 through GMATCH-06) addressed
- Group matches scroll wheel now has responsive, aligned badge layout matching bracket view style
- No blockers

---
*Phase: 38-group-matches-polish*
*Completed: 2026-03-18*
