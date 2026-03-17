---
phase: 35-wizard-state-model
plan: 01
subsystem: ui
tags: [elm, bracket-wizard, round-selection, bottom-up]

# Dependency graph
requires: []
provides:
  - "nextRound helper: bottom-up SelectionRound progression"
  - "addTeamToRound: isolated round addition (no cascade)"
  - "canSelectTeam: per-round pool membership enforcement"
  - "currentActiveRound: bottom-up scan (R32 first, fallback ChampionRound)"
  - "isWizardComplete: all six rounds must be at capacity with unique teams"
  - "GoNext handler: advances viewingRound via nextRound"
affects: [36-bracket-view]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Bottom-up wizard: R32 is entry point; each add touches only that round's field"
    - "Pool enforcement: canSelectTeam gates R16+ on prior-round membership"
    - "Greedy-first: currentActiveRound picks lowest incomplete round bottom-up"

key-files:
  created: []
  modified:
    - src/Form/Bracket/Types.elm
    - src/Form/Bracket.elm

key-decisions:
  - "addTeamToRound adds only to the targeted round field — upward cascade removed"
  - "canSelectTeam enforces pool membership for R16+; group cap (max 3) only for R32"
  - "currentActiveRound scans bottom-up; fallback is ChampionRound (all rounds done)"
  - "isWizardComplete uses List.Extra.uniqueBy to count unique teams per round"
  - "GoNext stores next round in viewingRound without any capacity guard (guard is view-side)"

patterns-established:
  - "Round isolation: each SelectionRound field is modified independently, never cascaded"
  - "Pool gates: prior round membership is the constraint for advancement selection"

requirements-completed: [WIZ-01, WIZ-02, WIZ-03, WIZ-04]

# Metrics
duration: 3min
completed: 2026-03-17
---

# Phase 35 Plan 01: Wizard State Model Summary

**Bottom-up bracket wizard state: addTeamToRound isolated per round, canSelectTeam enforces pool membership, currentActiveRound scans R32-first, GoNext advances viewingRound via nextRound**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-17T18:04:16Z
- **Completed:** 2026-03-17T18:06:47Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- Stripped cascade logic from `addTeamToRound` — each round case now modifies only its own field
- Added `nextRound` helper and exposed it so `Form/Bracket.elm` can import it for GoNext
- Rewrote `canSelectTeam` with per-round pool membership checks (R16 requires membership in lastThirtyTwo, etc.)
- Rewrote `currentActiveRound` to scan bottom-up so the wizard opens at LastThirtyTwoRound
- Rewrote `isWizardComplete` to require all six rounds at capacity using `List.Extra.uniqueBy`
- Implemented GoNext to advance `viewingRound` using `nextRound`

## Task Commits

Each task was committed atomically:

1. **Task 1: Rewrite four state helpers in Form/Bracket/Types.elm** - `62fab3a` (feat)
2. **Task 2: Fix GoNext handler in Form/Bracket.elm** - `ce44a93` (feat)

## Files Created/Modified

- `src/Form/Bracket/Types.elm` - Rewrote addTeamToRound, canSelectTeam, currentActiveRound, isWizardComplete; added nextRound; added List.Extra import; exposed nextRound
- `src/Form/Bracket.elm` - Added nextRound import; replaced GoNext no-op with viewingRound advancement

## Decisions Made

- No capacity guard in GoNext update branch — capacity enforcement stays view-side only (disabled "Ga verder" button)
- nextRound at ChampionRound returns ChampionRound (idempotent clamp at top)
- isWizardComplete uses uniqueBy rather than raw List.length to avoid counting duplicates

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None. Build compiled cleanly on first attempt after both changes.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- State helpers are ready for Phase 36 (bracket view redesign)
- View layer can rely on: GoNext advancing round, canSelectTeam gating pool members, currentActiveRound returning R32 for fresh wizard state
- Concern from STATE.md still applies: manual render check at 320px viewport required after Phase 36 QF+ badge changes

## Self-Check: PASSED

All files exist and both task commits verified in git log.

---
*Phase: 35-wizard-state-model*
*Completed: 2026-03-17*
