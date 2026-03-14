---
phase: 21-participant-submit
plan: 02
subsystem: ui
tags: [elm, elm-ui, form, submit, completeness]

# Dependency graph
requires:
  - phase: 21-01
    provides: Participant card restyle (Form.Participant)
  - phase: 20-01
    provides: Form.Topscorer.isComplete
  - phase: 19-01
    provides: color system, terminalBorder
provides:
  - viewSummaryBox — 5-row bordered status box in submit card
  - Restyled submit button — full-width inline buttons with amber/grey/green states
  - viewIncompleteNote — dim grey note when form incomplete
affects: [submit-card, form-ux, FORM-08]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "List.intersperse divider for bordered row separators in elm-ui"
    - "Inline Element.Input.button for semantic button states (no UI.Button wrapper)"
    - "Color-coded completeness rows: Color.green when complete, Color.red when incomplete"

key-files:
  created: []
  modified:
    - src/Form/Submit.elm

key-decisions:
  - "Removed introSubmittable / introNotReady paragraphs; summary box replaces them"
  - "viewSubmitButton is a standalone function with exhaustive case expression for all states"
  - "StringField.value not used — pattern matched inline to control color logic correctly"
  - "AnswerGroupMatches is List (MatchID, AnswerGroupMatch); filtered with tuple second element"

patterns-established:
  - "Submit card summary box pattern: border-wrapped column of interspersed rows + dividers"

requirements-completed:
  - FORM-08

# Metrics
duration: 5min
completed: 2026-03-10
---

# Phase 21 Plan 02: Submit Card Summary Box Summary

**Bordered 5-row summary box in submit card with green/red completion status per section plus full-width amber/grey/green inline submit button states**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-03-10T18:46:13Z
- **Completed:** 2026-03-10T18:51:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- `viewSummaryBox` renders a bordered box with 5 rows: groepswedstrijden (N/48), knock-out schema (volledig/onvolledig), topscorer (name or —), naam, e-mail
- Each row colored green when section complete, red when incomplete; rows separated by 1px dividers
- Submit button replaced with inline `Element.Input.button` elements: amber (active), grey (inactive/loading), green (submitted)
- `viewIncompleteNote` shows dim grey note below button when form not ready to submit

## Task Commits

1. **Task 1: Add summary box and restyle submit button** - `de692cf` (feat)

**Plan metadata:** (docs commit to follow)

## Files Created/Modified
- `src/Form/Submit.elm` — Rewrote with viewSummaryBox, viewSubmitButton, viewIncompleteNote; removed old introSubmittable/introNotReady; kept submitted/error/loading intro paragraphs

## Decisions Made
- Removed `introSubmittable` and `introNotReady` paragraph elements — the summary box provides equivalent status information in a more structured visual form
- Kept `introSubmitted`, `introSubmittedErr`, and `introSubmitting` paragraph text appended below button for those states since they carry distinct informational messages
- Pattern-matched `StringField` inline for color logic rather than using `StringField.isValid` — needed to show `Changed _` as green while `Error _` stays red (same value displayed but different color semantics)
- `AnswerGroupMatches = List (MatchID, AnswerGroupMatch)` — filtered with `List.filter (\( _, gm ) -> GroupMatch.isComplete gm)`
- Used `\u{2014}` (em dash) for missing values instead of literal `—` for clean Elm source

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Submit card now satisfies FORM-08 with a clear visual status summary
- Phase 21 is complete; ready to proceed to Phase 22

---
*Phase: 21-participant-submit*
*Completed: 2026-03-10*
