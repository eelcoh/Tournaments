---
phase: 16-bracket-minimap
plan: 01
subsystem: ui
tags: [elm, elm-ui, bracket, wizard, minimap, dot-rail]

# Dependency graph
requires:
  - phase: 16-bracket-minimap
    provides: Phase context and design prototype reference for dot minimap
provides:
  - viewBracketMinimap function in Form/Bracket/View.elm
  - Horizontal dot rail with 6 round indicators (R32 R16 KF HF F ★)
  - Tap-to-jump navigation for all bracket rounds
affects: [17-topscorer-search, any future bracket UI changes]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Element.Background and Element.Border used for filled vs border-only dot states"
    - "List.intersperse connector pattern for dot rail with connector lines between nodes"
    - "Single attribute (dotBg) switches between Background.color and Border.color based on round state"

key-files:
  created: []
  modified:
    - src/Form/Bracket/View.elm

key-decisions:
  - "Single viewBracketMinimap replaces two-variant stepper (viewRoundStepperFull / viewRoundStepperCompact); no device branching needed for the minimap"
  - "All 6 dots are always tappable (including pending rounds), firing JumpToRound — matching plan requirement BRACKET-03"
  - "Pending dots use Border.color Color.terminalBorder (not Background.color) to produce a border-only hollow dot"

patterns-established:
  - "Dot state pattern: isComplete → green fill; activeRound → amber fill; else → dim border-only"
  - "Both the column wrapper and inner dot element carry onClick to maximize tap target"

requirements-completed: [BRACKET-01, BRACKET-02, BRACKET-03]

# Metrics
duration: 20min
completed: 2026-03-08
---

# Phase 16 Plan 01: Bracket Minimap Summary

**Horizontal dot rail (R32 R16 KF HF F ★) with green/amber/dim states and tap-to-jump replaces two-variant ASCII round stepper in bracket wizard**

## Performance

- **Duration:** ~20 min
- **Started:** 2026-03-08T19:28:52Z
- **Completed:** 2026-03-08T19:50:00Z
- **Tasks:** 1 auto + 1 human-verify checkpoint (approved)
- **Files modified:** 1

## Accomplishments

- Replaced `viewRoundStepper` / `viewRoundStepperFull` / `viewRoundStepperCompact` (three functions, ~120 lines) with a single `viewBracketMinimap` (~70 lines)
- Dot rail shows done (green fill), current (amber fill), and pending (border-only) states derived from `roundTeams`/`roundRequired`
- Every dot and its label column are tappable, firing `JumpToRound` for both done and pending rounds
- Added `Element.Background as Background` and `Element.Border as Border` imports
- Build verified clean with `make build --optimize`; visual checkpoint approved by user

## Task Commits

Each task was committed atomically:

1. **Task 1: Implement viewBracketMinimap and replace old stepper** - `66a6f8d` (feat)

**Plan metadata:** _(docs commit to follow)_

## Files Created/Modified

- `src/Form/Bracket/View.elm` - Replaced three stepper functions with `viewBracketMinimap`; updated `view` call site; added Background/Border imports

## Decisions Made

- Single function for all screen sizes: no device branching needed for dot rail (the compact stepper's windowing logic is no longer required)
- Pending dots use `Border.color Color.terminalBorder` (not `Background.color`) to achieve a hollow-border appearance — the single `dotBg` attribute switches between the two
- Both the outer `Element.column` and the inner `dot` element carry `onClick` so the label text also acts as a tap target

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Bracket minimap is live and visually approved
- Phase 17 (topscorer search) can proceed independently
- No blockers

---
*Phase: 16-bracket-minimap*
*Completed: 2026-03-08*
