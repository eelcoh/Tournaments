---
phase: 13-more-ux-polish
plan: "02"
subsystem: ui
tags: [elm, svg, flags, placeholder, team]

# Dependency graph
requires:
  - phase: 13-more-ux-polish
    provides: UX polish context and phase structure
provides:
  - Distinct placeholder SVGs for unknown teamIDs (404-not-found.svg) and TBD bracket slots (999-to-be-decided.svg)
  - Correct routing in Bets.Types.Team so Nothing and unknown IDs show different visuals
affects: [ui, bracket, group-matches, team-flags]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Inline SVG placeholders with square viewBox for scale-independent rendering"
    - "Separate visual treatment: ? for data errors vs ··· for pending/empty slots"

key-files:
  created:
    - assets/svg/404-not-found.svg
    - assets/svg/999-to-be-decided.svg
  modified:
    - src/Bets/Types/Team.elm

key-decisions:
  - "flagUrl Nothing returns 999-to-be-decided.svg directly (no delegation to flagUrlRound)"
  - "flagUrlRound default case returns 404-not-found.svg (renamed from 404.svg)"
  - "Two distinct placeholders: ? for unknown teams (#5A5A5A), ··· for TBD slots (#4A4A4A)"

patterns-established:
  - "SVG placeholders: square viewBox 0 0 100 100, no fixed width/height, scales with img element"

requirements-completed: [UX-POLISH-04]

# Metrics
duration: 3min
completed: 2026-03-07
---

# Phase 13 Plan 02: Placeholder SVGs for Unknown and TBD Team Slots Summary

**Two SVG placeholder files with distinct visuals: grey ? for unknown teamIDs and darker grey ··· for empty TBD bracket slots, with corrected routing in Bets.Types.Team**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-07T19:35:00Z
- **Completed:** 2026-03-07T19:38:00Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Created `assets/svg/404-not-found.svg` — grey (#5A5A5A) square with white `?` for unknown teamIDs
- Created `assets/svg/999-to-be-decided.svg` — darker grey (#4A4A4A) square with white `···` for Nothing/TBD slots
- Fixed `flagUrl Nothing` to return `999-to-be-decided.svg` directly instead of delegating to `flagUrlRound "xyz"` which hit the wrong catch-all
- Fixed `flagUrlRound` default case to return `404-not-found.svg` (was `404.svg`, a non-existent file)
- Simplified `flagUrl` by removing the unnecessary `let` block with `uri` and `default` helpers

## Task Commits

Each task was committed atomically:

1. **Task 1: Create placeholder SVG files** - `8c39751` (feat)
2. **Task 2: Fix flagUrl and flagUrlRound routing in Team.elm** - `8c4f893` (fix)

## Files Created/Modified
- `assets/svg/404-not-found.svg` - Placeholder for unknown teamIDs: grey square with `?` symbol
- `assets/svg/999-to-be-decided.svg` - Placeholder for Nothing/TBD bracket slots: darker grey square with `···` symbol
- `src/Bets/Types/Team.elm` - Fixed routing: Nothing -> 999-to-be-decided.svg, unknown -> 404-not-found.svg

## Decisions Made
- Two distinct placeholder styles make it visually clear whether a slot is empty (TBD) vs incorrectly mapped (unknown team)
- `flagUrl` simplified to plain `case` expression — `let` block was only needed to create a dummy `team "xyz" ""` value to call `flagUrlRound`, which is no longer needed
- Color palette matches Zenburn: `#DCDCCC` cream text, dark grey backgrounds with subtle rx rounded corners

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Placeholder SVGs are in place; any bracket or group match view that renders team flags will now show meaningful distinctions between empty and unknown slots
- No blockers

---
*Phase: 13-more-ux-polish*
*Completed: 2026-03-07*
