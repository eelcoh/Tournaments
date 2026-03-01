---
phase: 08-form-mobile-polish
plan: 01
subsystem: ui
tags: [elm, elm-ui, mobile, navigation, pwa]

# Dependency graph
requires:
  - phase: 07-install-prompt-banners
    provides: viewInstallBanner and viewStatusBar in inFront column stack
provides:
  - viewFormNavBar: 48px fixed bottom nav bar visible on Form app
  - ScrollToTop Msg: triggers Browser.Dom.setViewport 0 0 on NavigateTo
  - cardCenterInfo: per-card incomplete count helper in View.elm
affects:
  - 08-02-tap-feedback (uses same nav bar layout)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Fixed bottom overlay column in Element.layout inFront — viewFormNavBar above viewInstallBanner above viewStatusBar"
    - "ScrollToTop as Task discard target: Task.attempt (\\_ -> ScrollToTop) (Browser.Dom.setViewport 0 0)"
    - "Per-card completeness computed inline in cardCenterInfo by pattern-matching List.drop model.idx model.cards"

key-files:
  created: []
  modified:
    - src/View.elm
    - src/Main.elm
    - src/Types.elm
    - src/Form/View.elm

key-decisions:
  - "ScrollToTop fires on every NavigateTo — discard target for Browser.Dom.setViewport Task result"
  - "navButton disabled state uses Font.color Color.grey + NoOp msg, active state uses Color.orange + NavigateTo"
  - "Bottom padding of 64px added to card column in Form/View.elm to prevent content hiding behind fixed bar"
  - "cardCenterInfo placed in View.elm (not Form/View.elm) because it needs model.cards pattern match alongside viewFormNavBar"
  - "Removed UI.Button and UI.Style imports from Form/View.elm after removing old nav pills"

patterns-established:
  - "Form-only fixed bar: case model.app of Form -> ... _ -> Element.none"
  - "Boundary-aware nav button: isFirst/isLast flags select between greyed NoOp and orange NavigateTo"

requirements-completed: [FORM-01, FORM-02]

# Metrics
duration: 2min
completed: 2026-03-01
---

# Phase 08 Plan 01: Form Mobile Polish — Fixed Nav Bar Summary

**48px fixed bottom nav bar with vorige/volgende greyed at boundaries and per-card incomplete count, plus Browser.Dom scroll-to-top on each card navigation**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-01T08:40:12Z
- **Completed:** 2026-03-01T08:42:33Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments

- Fixed 48px bottom nav bar rendered only on Form app — dark bg, terminal border top, always visible above install banner
- vorige button greyed at card 0, volgende button greyed at last card; both orange and tappable for middle cards
- Center shows `stap N/M` with card-specific open count: wedstrijden open (GroupMatches), ronden open (Bracket), open/[x] for Topscorer/Participant
- ScrollToTop Msg added to Types.elm; NavigateTo now fires Browser.Dom.setViewport 0 0 to scroll viewport to top on each card change
- Old prevPill/nextPill/nav row removed from Form/View.viewCardChrome; 64px bottom padding added to prevent content obscured by fixed bar

## Task Commits

1. **Task 1: Add ScrollToTop Msg and Browser.Dom scroll-to-top on NavigateTo** - `b1cae41` (feat)
2. **Task 2: Replace floating nav pills with fixed bottom nav bar in View.elm + update Form/View.elm** - `df7d2a9` (feat)

## Files Created/Modified

- `src/Types.elm` - Added `ScrollToTop` Msg variant to union type
- `src/Main.elm` - Added `Browser.Dom` import; NavigateTo now fires setViewport 0 0; ScrollToTop handler is no-op
- `src/View.elm` - Added `cardCenterInfo` helper and `viewFormNavBar` function; wired into inFront column above install banner; added imports for Form.Bracket.Types, Form.GroupMatches, Form.Topscorer, Form.Participant, Bets.Types.Answer.GroupMatch, Form.Bracket
- `src/Form/View.elm` - Removed prevPill/nextPill/nav from viewCardChrome; added 64px bottom padding; removed unused UI.Button and UI.Style imports

## Decisions Made

- ScrollToTop is a discard target (no-op handler) — the setViewport call itself does the scrolling
- navButton disabled uses `Font.color Color.grey + NoOp` rather than hiding to avoid layout shifts
- cardCenterInfo lives in View.elm alongside viewFormNavBar since both need the same model traversal
- 64px bottom padding (larger than 48px nav bar) gives visual breathing room at bottom of last card

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Removed unused imports from Form/View.elm**
- **Found during:** Task 2 (Form/View.elm cleanup)
- **Issue:** After removing nav pills, UI.Button and UI.Style were no longer referenced in Form/View.elm
- **Fix:** Removed both import lines
- **Files modified:** src/Form/View.elm
- **Verification:** Build succeeds with no errors
- **Committed in:** df7d2a9 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (cleanup)
**Impact on plan:** Minor cleanup only. No scope creep.

## Issues Encountered

None — plan executed cleanly. Both modules compiled on first attempt after changes.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Fixed nav bar in place — 08-02 tap feedback can build on the same nav bar
- viewFormNavBar is standalone in View.elm and straightforward to extend

## Self-Check: PASSED

- src/View.elm: FOUND
- src/Main.elm: FOUND
- src/Types.elm: FOUND
- src/Form/View.elm: FOUND
- 08-01-SUMMARY.md: FOUND
- commit b1cae41: FOUND
- commit df7d2a9: FOUND

---
*Phase: 08-form-mobile-polish*
*Completed: 2026-03-01*
