---
phase: 28-dummy-results
plan: 01
subsystem: ui
tags: [elm, test-mode, dummy-data, results, ranking, match-results, knockouts]

# Dependency graph
requires:
  - phase: 26-mode-foundation
    provides: testMode flag on Model and test-mode routing infrastructure
  - phase: 27-dummy-activities-and-offline-submission
    provides: TestData.Activities pattern reference for new TestData modules
provides:
  - TestData.MatchResults module with dummyMatchResults and dummyKnockoutsResults
  - TestData.Ranking module with dummyRankingSummary
  - testMode guards in Main.elm for RefreshRanking, RefreshResults, RefreshKnockoutsResults
affects: [29-dummy-bet]

# Tech tracking
tech-stack:
  added: []
  patterns: [testMode outermost guard pattern in Main.update branches, Bets.Init.teamData as authoritative team source]

key-files:
  created:
    - src/TestData/MatchResults.elm
    - src/TestData/Ranking.elm
  modified:
    - src/Main.elm

key-decisions:
  - "testMode guard placed as outermost check in each Refresh branch, not nested inside Success cache check"
  - "knockoutsResults injected as Fresh(RemoteData.Success ...) to match DataStatus(WebData) type shape"
  - "dummyKnockoutsResults uses Bets.Init.teamData as source for all 48 teams — no hand-written IDs"
  - "dummyMatchResults patches 12 scores onto matches from Bets.Init.matches — partial results for realistic demo"
  - "RefreshResults covers both #uitslagen and #groepsstand — one guard handles both pages"

patterns-established:
  - "TestData module pattern: derive data from Bets.Init to avoid hand-writing tournament constants"
  - "testMode guard: if model.testMode then inject Success else existing logic"

requirements-completed: [RES-01, RES-02, RES-03, RES-04]

# Metrics
duration: 1min
completed: 2026-03-14
---

# Phase 28 Plan 01: Dummy Results Summary

**Dummy data injection for all four results pages via testMode guards in Main.elm, using two new TestData modules derived from Bets.Init**

## Performance

- **Duration:** ~1 min
- **Started:** 2026-03-14T22:46:43Z
- **Completed:** 2026-03-14T22:47:41Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Created TestData.MatchResults with 48-match results list (12 with scores) and all-48-teams knockout results
- Created TestData.Ranking with 3-bettor ranking table for offline demo
- Added testMode guards in Main.update for RefreshRanking, RefreshResults, RefreshKnockoutsResults

## Task Commits

Each task was committed atomically:

1. **Task 1: Create TestData.MatchResults and TestData.Ranking modules** - `ff847d4` (feat)
2. **Task 2: Add testMode guards in Main.elm** - `7b8f5df` (feat)

**Plan metadata:** (docs commit follows)

## Files Created/Modified
- `src/TestData/MatchResults.elm` - dummyMatchResults (48 group matches, 12 scored) and dummyKnockoutsResults (all 48 teams TBD)
- `src/TestData/Ranking.elm` - dummyRankingSummary with Jan/Pieter/Sophie/Eelco as dummy bettors
- `src/Main.elm` - testMode imports added, three Refresh branches guarded with testMode check

## Decisions Made
- testMode guard is outermost in each branch (not nested in Success cache check) to ensure test data is always injected when flag is set
- knockoutsResults uses Fresh(RemoteData.Success ...) wrapper to match the DataStatus(WebData KnockoutsResults) type
- Bets.Init.teamData drives the knockout data — never hand-writing team IDs or counts

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- All four results pages now show dummy data in test mode with no backend calls
- Phase 29 (dummy-bet) can proceed: requires reading Form/Bracket/Types.elm for WizardState shape before coding filledBet
- Known prep needed: enumerate WC2026 match IDs (m01-m48 group, m73-m88 R1) from Tournament.elm

## Self-Check: PASSED

All created files exist. Both task commits verified.

---
*Phase: 28-dummy-results*
*Completed: 2026-03-14*
