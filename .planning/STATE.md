---
gsd_state_version: 1.0
milestone: v1.5
milestone_name: Test/Demo Mode
status: completed
stopped_at: Completed 27-dummy-activities-and-offline-submission-01-PLAN.md
last_updated: "2026-03-14T22:32:10.480Z"
last_activity: "2026-03-14 — Phase 27-01 executed: 2 tasks, 2 files, offline activities in test mode"
progress:
  total_phases: 4
  completed_phases: 2
  total_plans: 2
  completed_plans: 2
  percent: 100
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-03-14)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 27 — Dummy Activities and Offline Submission

## Current Position

Phase: 27 of 29 (Dummy Activities and Offline Submission)
Plan: 1 of 1 in current phase (complete)
Status: Phase 27 complete — ready for Phase 28
Last activity: 2026-03-14 — Phase 27-01 executed: 2 tasks, 2 files, offline activities in test mode

Progress: [██████████] 100% (v1.5 — 2/4 phases done)

## Performance Metrics

**Velocity (v1.5):**
- Total plans completed: 2
- Average duration: 3.5 min
- Total execution time: 7 min

| Phase | Plan | Duration | Tasks | Files |
|-------|------|----------|-------|-------|
| 26-mode-foundation | 01 | 2 min | 2 | 3 |
| 27-dummy-activities-and-offline-submission | 01 | 5 min | 2 | 2 |

**v1.4 reference:** 12 plans across 8 phases, ~20,847 LOC, ~2 min avg per plan

*Updated after each plan completion*

## Accumulated Context

### Decisions for v1.5

- testMode : Bool on Model (not App variant) — orthogonal to navigation; no new routing or exhaustive case matching needed
- TestData.elm holds all dummy data as static Elm values derived from Bets.Init data — never hand-write team IDs
- HTTP bypass via testMode guards in Main.update before call sites; API modules remain untouched
- "Fill all" must route through rebuildBracket to keep WizardState.selections in sync with Bet.answers.bracket (issue #93 invariant)
- Offline append to activities must handle NotAsked state — set to Success [newActivity] rather than prepend to empty
- TestData.Activities is a plain Elm module with static list — no dynamic generation needed for demo
- NotAsked fallback uses dummyActivities (not []) so offline submissions show populated list

### Pending Todos

None.

### Blockers/Concerns

- Phase 29: filledBet exact construction sequence must be enumerated during planning — confirm WC2026 match IDs (m01-m48 group, m73-m88 R1) against Tournament.elm
- Phase 29: WizardState RoundSelections field shape must be read from src/Form/Bracket/Types.elm before coding

## Session Continuity

Last session: 2026-03-14T22:29:51.657Z
Stopped at: Completed 27-dummy-activities-and-offline-submission-01-PLAN.md
Resume file: None
