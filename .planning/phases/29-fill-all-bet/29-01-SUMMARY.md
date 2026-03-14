---
phase: 29-fill-all-bet
plan: 01
subsystem: ui
tags: [elm, test-mode, fill-all, bracket, group-matches, topscorer]

# Dependency graph
requires:
  - phase: 26-mode-foundation
    provides: testMode flag on Model, ActivateTestMode Msg
  - phase: 93-completeness-check
    provides: rebuildBracket, BracketWizard, RoundSelections, addTeamToRound
provides:
  - TestData.Bet module with dummyRoundSelections (32 teams, France champion), dummyGroupScores (36 matches), dummyTopscorer (Mbappe/France)
  - FillAllBet Msg variant wired through Main.update
  - Dashboard fill-all button visible only in testMode
affects: [form-dashboard, test-mode, fill-all-demo]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - TestData.* static values pattern for dummy bet data
    - testMode guard on UI element rendering in Dashboard

key-files:
  created:
    - src/TestData/Bet.elm
  modified:
    - src/Types.elm
    - src/Main.elm
    - src/Form/Bracket.elm
    - src/Form/Dashboard.elm

key-decisions:
  - "dummyRoundSelections uses addTeamToRound cascade so all rounds are consistent (lastThirtyTwo → champion)"
  - "Third-place picks from groups A-H satisfy all T1-T8 BestThird slot constraints via greedy-with-sort in rebuildBracket"
  - "rebuildBracket and updateBracket exposed from Form.Bracket module (not just used internally)"
  - "FillAllBet update branch fills scores, bracket, topscorer and syncs BracketCard WizardState atomically"

patterns-established:
  - "TestData.Bet: static Elm values for fill-all demo, imports from Teams and Draw modules"
  - "testMode UI guard: if model.testMode then ... else Element.none pattern"

requirements-completed:
  - BET-01

# Metrics
duration: 3min
completed: 2026-03-14
---

# Phase 29 Plan 01: Fill All Bet Summary

**One-tap demo fill button: fills all 36 group scores, WC2026 bracket (via rebuildBracket), and Mbappé topscorer from Dashboard in test mode**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-14T23:06:58Z
- **Completed:** 2026-03-14T23:09:27Z
- **Tasks:** 3 of 4 (awaiting human verification at checkpoint)
- **Files modified:** 4 (+ 1 created)

## Accomplishments
- TestData.Bet module with 32-team dummyRoundSelections (France champion), 36 group match scores, Mbappé topscorer
- FillAllBet Msg variant + update branch atomically fills scores, bracket, topscorer, and syncs BracketCard WizardState
- Dashboard "[ fill all — test mode ]" button gated behind model.testMode — invisible outside test mode
- make build (--optimize) passes with zero errors

## Task Commits

Each task was committed atomically:

1. **Task 1: Create TestData.Bet** - `b1b0c8b` (feat)
2. **Task 2: FillAllBet Msg + update branch + expose rebuildBracket/updateBracket** - `c431d88` (feat)
3. **Task 3: Dashboard fill-all button** - `543b465` (feat)

## Files Created/Modified
- `src/TestData/Bet.elm` - Static dummy data: dummyRoundSelections, dummyGroupScores, dummyTopscorer
- `src/Types.elm` - FillAllBet variant added to Msg type
- `src/Form/Bracket.elm` - rebuildBracket and updateBracket added to exposing list
- `src/Main.elm` - FillAllBet update branch; imports Bets.Bet, Form.Bracket.Types, TestData.Bet
- `src/Form/Dashboard.elm` - fillAllButton let-binding behind testMode guard; included in page children

## Decisions Made
- Used addTeamToRound cascade starting from LastThirtyTwoRound, then progressively adding to higher rounds, ending with ChampionRound for France — guarantees internal consistency of RoundSelections
- Third-place picks from groups A-H: south_korea(A), qatar(B), haiti(C), australia(D), ivory_coast(E), team_f3(F), iran(G), saudi_arabia(H) — satisfies all T1-T8 BestThird slot constraints
- Added `import Bets.Bet` to Main.elm (was not previously imported); deviation Rule 3 (blocking)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added missing Bets.Bet import to Main.elm**
- **Found during:** Task 2 (FillAllBet update branch implementation)
- **Issue:** `Bets.Bet.setMatchScore` and `Bets.Bet.setTopscorer` referenced but `Bets.Bet` not imported
- **Fix:** Added `import Bets.Bet` to Main.elm imports
- **Files modified:** src/Main.elm
- **Verification:** make debug succeeded after fix
- **Committed in:** c431d88 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** Import fix was necessary for compilation. No scope creep.

## Issues Encountered
None beyond the missing import (documented as deviation above).

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Fill-all button ready for browser verification (Task 4 checkpoint pending human approval)
- After human verification, phase 29 is complete

## Self-Check: PASSED

- src/TestData/Bet.elm: FOUND
- src/Types.elm: FOUND
- src/Form/Bracket.elm: FOUND
- src/Main.elm: FOUND
- src/Form/Dashboard.elm: FOUND
- Commit b1b0c8b: FOUND
- Commit c431d88: FOUND
- Commit 543b465: FOUND

---
*Phase: 29-fill-all-bet*
*Completed: 2026-03-14*
