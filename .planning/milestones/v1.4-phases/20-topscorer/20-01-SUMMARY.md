---
phase: 20-topscorer
plan: 01
subsystem: ui
tags: [elm-ui, topscorer, search, form, flat-list, player-cards]

# Dependency graph
requires:
  - phase: 18-foundation
    provides: Color constants (terminalBorder, activeNav, orange), UI.Font.mono, UI.Style patterns
  - phase: 19-group-matches-bracket-tiles
    provides: Bordered card tile aesthetic established for form cards
provides:
  - Flat searchable player list replacing team->player two-step flow
  - viewPlayerCard: bordered card with flag, name, team code, [x] marker
  - viewSearchInput: bordered container with > prompt, focus-driven border color
  - SearchFocused Bool msg wired through TopscorerCard state
affects: [21-submit-card, 22-results, 23-activities]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Focus state driven by SearchFocused True/False msgs from Html onFocus/onBlur on inner Html.input element"
    - "Flat player list via List.concatMap over teamData; filter by name OR team code substring"
    - "Toggle deselect: direct tuple construction (Just player, Just team) / (Nothing, Nothing)"
    - "isDirty guard in TopscorerMsg handler prevents betState = Dirty for UI-only msgs"

key-files:
  created: []
  modified:
    - src/Form/Topscorer/Types.elm
    - src/Types.elm
    - src/Main.elm
    - src/Form/View.elm
    - src/Form/Topscorer.elm

key-decisions:
  - "Direct tuple construction for Topscorer instead of setTeam/setPlayer helpers — avoids toggle side-effects when switching players within same team"
  - "SearchFocused and UpdateSearch do not set betState = Dirty — only actual bet data changes trigger dirty"
  - "SelectPlayer arm in Main.elm resets searchQuery = '' and searchFocused = False on selection"
  - "matchesSearch returns False for empty query — ensures no pre-loaded list in default state"

patterns-established:
  - "Player card bordered tile: Border.width 1, transparent border when not selected, activeNav border + rgba amber bg tint when selected, orange hover border via mouseOver"
  - "Search container border: terminalBorder grey when unfocused, activeNav orange when focused (driven by parent state, not Element.focused)"

requirements-completed: [FORM-05, FORM-06]

# Metrics
duration: 2min
completed: 2026-03-09
---

# Phase 20 Plan 01: Topscorer Card Restyle Summary

**Flat searchable player list with bordered player cards and focus-tracked search bar replacing the old team->player two-step UX**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-09T21:33:20Z
- **Completed:** 2026-03-09T21:35:18Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments
- Replaced two-step team->player selection with flat list searchable by player name OR team code substring
- Player items render as bordered cards: flag image left, name + team code two-line text, [x] marker right when selected
- Search bar has bordered container with > prompt; border turns orange (activeNav) when input focused
- Toggle deselect: clicking a selected player clears both player and team
- Default state shows only search bar + intro text (no pre-loaded list); selected player shown when returning to card

## Task Commits

Each task was committed atomically:

1. **Task 1: Extend state types and wire SearchFocused through handlers** - `e9ccae7` (feat)
2. **Task 2: Rewrite Form/Topscorer.elm — flat player list, player cards, styled search bar** - `2326160` (feat)

**Plan metadata:** (docs commit, see below)

## Files Created/Modified
- `src/Form/Topscorer/Types.elm` - Replaced SelectTeam with SearchFocused Bool; removed Team import
- `src/Types.elm` - Extended TopscorerCard with searchFocused : Bool field
- `src/Main.elm` - Updated TopscorerMsg handler; SearchFocused/UpdateSearch don't set betState = Dirty
- `src/Form/View.elm` - Passes searchFocused from card state to Form.Topscorer.view
- `src/Form/Topscorer.elm` - Full rewrite: flat allPlayers list, viewPlayerCard, viewSearchInput with focus tracking, toggle deselect

## Decisions Made
- Used direct tuple construction `( Just player, Just t )` instead of `TS.setTeam` + `TS.setPlayer` helpers to avoid the toggle side-effect when the same team was previously selected (setTeam toggles off if team matches)
- `SearchFocused` and `UpdateSearch` msgs do not set `betState = Dirty` since they only change UI state, not bet data
- `matchesSearch` returns `False` for empty query to enforce the "no pre-loaded list" requirement

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Replaced setTeam/setPlayer helpers with direct tuple construction**
- **Found during:** Task 2 (Form/Topscorer.elm rewrite)
- **Issue:** Plan's suggested implementation called `TS.setPlayer (TS.setTeam topscorer t) player`. But `setTeam` toggles off if same team is already selected — switching between players of the same team would clear the selection instead of updating it
- **Fix:** Construct Topscorer tuple directly: `( Just player, Just t )` for selection, `( Nothing, Nothing )` for toggle-off
- **Files modified:** src/Form/Topscorer.elm
- **Verification:** `make debug` passes; logic handles same-team player switching correctly
- **Committed in:** `2326160` (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 bug — incorrect toggle behavior with setTeam helper)
**Impact on plan:** Essential correctness fix. No scope creep.

## Issues Encountered
None beyond the deviation above.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Topscorer card matches the prototype card/tile aesthetic (bordered cards, focus states, flat list UX)
- FORM-05 and FORM-06 requirements fulfilled
- Ready for phase 21 (submit card) and phase 22 (results)

---
*Phase: 20-topscorer*
*Completed: 2026-03-09*
