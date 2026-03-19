---
phase: 37-test-mode-validation
plan: "01"
subsystem: test-data
tags: [verification, bracket, wizard, fill-all, test-mode]
dependency_graph:
  requires: [35-01, 36-01, 36-02]
  provides: [confirmed-fill-all-completeness]
  affects: [src/TestData/Bet.elm, src/Main.elm]
tech_stack:
  added: []
  patterns: [pool-membership-validation, wizard-completeness-chain]
key_files:
  created: []
  modified: []
decisions:
  - "dummyRoundSelections was already correct: 32+16+8+4+2+1 with valid pool membership"
  - "FillAllBet handler already calls rebuildBracket, updateBracket, and updateBracketCard correctly"
  - "viewingRound=Nothing + isWizardComplete=True correctly enables Ga-verder button"
  - "GoNext in BracketCard view correctly maps to NavigateTo(idx+1), advancing to TopscorerCard"
metrics:
  duration_minutes: 5
  completed_date: "2026-03-18"
  tasks_completed: 2
  files_modified: 0
---

# Phase 37 Plan 01: Test Mode Validation Summary

**One-liner:** Verified fill-all button completeness chain end-to-end — dummyRoundSelections has valid pool membership for all 6 wizard rounds and FillAllBet handler correctly populates wizard state.

## What Was Built

This was a verification-only plan. Both tasks confirmed that the existing code was already correct after the wizard redesign in phases 35-36.

### Task 1: dummyRoundSelections pool membership verification

Traced all 63 team additions in `src/TestData/Bet.elm`:

| Round | Required | Actual | Pool check |
|-------|----------|--------|-----------|
| LastThirtyTwo | 32 | 32 | Groups A-H: 3 teams each; Groups I-L: 2 teams each |
| LastSixteen | 16 | 16 | All 16 R16 teams present in R32 |
| Quarter | 8 | 8 | All 8 QF teams present in R16 |
| Semi | 4 | 4 | All 4 SF teams present in QF |
| Finalist | 2 | 2 | Both finalists (france, brazil) present in SF |
| Champion | 1 | 1 | Champion (france) present in finalists |

Pool membership: valid at every level. No violations found.

**Placeholder teams verified:** `team_b2` (group B), `team_f3` (group F), `team_k2` (group K) all exist in `Teams.elm` with correct group assignments.

### Task 2: FillAllBet handler end-to-end verification

Confirmed all four operations in `src/Main.elm` FillAllBet branch:

1. Group scores filled via `dummyGroupScores` — present
2. `Bracket.rebuildBracket TestData.Bet.dummyRoundSelections Bets.Init.teamData` — present
3. `Bracket.updateBracket newBet1 newBracket` — present
4. `Cards.updateBracketCard model.cards newBracketState` with `BracketWizard { selections = TestData.Bet.dummyRoundSelections, viewingRound = Nothing }` — present

**Completeness chain verified:**

- `isWizardComplete` in `Form/Bracket/View.elm` checks all 6 round counts — returns True for 32+16+8+4+2+1 teams
- `viewingRound = Nothing` means `currentActiveRound` returns `ChampionRound` (all rounds complete)
- The sticky "Ga verder" button is shown when `isWizardComplete sel` is True
- In `Form/View.elm`, `BracketTypes.GoNext` maps to `NavigateTo (idx + 1)`
- Card list ordering: `BracketCard` immediately precedes `TopscorerCard` — forward navigation works correctly
- `isCompleteQualifiers` in `Form/View.elm` checks bracket completeness via `setBulk` qualifier fields set by `rebuildBracket`

**Build verification:** `make build` exits 0 with no compiler errors.

## Deviations from Plan

None — plan executed exactly as written. Both tasks were verification-only and required no code changes.

## Self-Check: PASSED

- `src/TestData/Bet.elm` — file exists, counts verified: 32+16+8+4+2+1
- `src/Main.elm` FillAllBet handler — all 4 operations verified
- `make build` — exits 0
- No commits needed (verification-only, no code changes)
