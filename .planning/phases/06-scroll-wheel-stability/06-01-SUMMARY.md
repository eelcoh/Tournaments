---
phase: 06-scroll-wheel-stability
plan: 01
subsystem: ui
tags: [elm, elm-ui, scroll-wheel, windowing, group-matches]

# Dependency graph
requires: []
provides:
  - Fixed 7-line scroll wheel window with active match always at line 4
  - Group label anchoring at line 1 (SCRW-02)
  - END marker staying at line 5 or below (SCRW-03)
  - No height jumps at group transitions (SCRW-01)
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "WindowLine type: WLMatch | WLGroupLabel | WLPadding | WLEndMarker covers all 7-line positions"
    - "buildWindow function: produces exactly 7 WindowLine items by slicing above/below cursor index with WLPadding fallback"
    - "Group label anchoring: replace above[0] with WLGroupLabel activeGroup unless it already is"

key-files:
  created: []
  modified:
    - src/Form/GroupMatches.elm

key-decisions:
  - "Replace buildScrollItems + viewScrollItem with buildWindow + viewWindowLine for strict 7-item output"
  - "Always anchor group label at line 1 (above[0]) even when the natural scroll position would put it higher"
  - "WLPadding renders as 44px invisible element — same height as match rows — to prevent any layout shift"
  - "WLEndMarker appended after all 48 matches in the flat sequence so it can only appear in below slice (lines 5-7)"

patterns-established:
  - "Fixed-length windowing: build a flat sequence, find cursor index, extract N above + N below, pad with neutral items"
  - "Elm WindowLine type: use custom type variants for each kind of scroll line to guarantee exhaustive pattern matching"

requirements-completed: [SCRW-01, SCRW-02, SCRW-03]

# Metrics
duration: ~30min
completed: 2026-02-28
---

# Phase 6 Plan 01: Scroll Wheel Stability Summary

**7-line fixed-window scroll wheel in `src/Form/GroupMatches.elm` with active match at line 4, group label anchored at line 1, END marker confined to lines 5-7, and WLPadding ensuring zero height jumps**

## Performance

- **Duration:** ~30 min
- **Started:** 2026-02-28
- **Completed:** 2026-02-28
- **Tasks:** 2 (1 auto + 1 human-verify checkpoint)
- **Files modified:** 1

## Accomplishments
- Replaced the variable-length `buildScrollItems`/`viewScrollItem` approach with a strict 7-item `buildWindow`/`viewWindowLine` algorithm
- Active match is now always at position 4 (index 3) of the window by construction — satisfying SCRW-01
- Group label anchoring: line 1 is always forced to `WLGroupLabel activeGroup`, even when the natural scroll position would have moved it above the viewport — satisfying SCRW-02
- `WLEndMarker` appended at the tail of the flat sequence so it can only ever appear in lines 5, 6, or 7 — satisfying SCRW-03
- `WLPadding` renders as a 44px invisible element (same height as match rows), eliminating all height jumps at group transitions

## Task Commits

Each task was committed atomically:

1. **Task 1: Rewrite scroll wheel windowing algorithm** - `6062b70` (feat)
2. **Task 2: Visual verification of scroll wheel stability** - human-approved checkpoint (no code commit)

**Plan metadata:** (docs commit — this plan)

## Files Created/Modified
- `src/Form/GroupMatches.elm` — Replaced `buildScrollItems`/`viewScrollItem` with `buildWindow`/`viewWindowLine`; added `WindowLine` custom type; removed old `ScrollItem` type

## Decisions Made
- Used a flat-list + index approach (`buildWindow`) rather than keeping the cursor-relative slice approach — cleaner to reason about and guarantees fixed output length
- `WLPadding` as an explicit type variant (not `Maybe WindowLine`) ensures pattern matching remains exhaustive and height is always 44px
- Group label anchoring only replaces `above[0]` (line 1), never touches `above[1]` or `above[2]` — prevents a second group label from appearing

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Phase 6 is complete with all SCRW requirements satisfied
- Phase 7 (Install Prompt Banners) and Phase 8 (Form Mobile Polish) are independent — either can proceed next
- No blockers or concerns

---
*Phase: 06-scroll-wheel-stability*
*Completed: 2026-02-28*
