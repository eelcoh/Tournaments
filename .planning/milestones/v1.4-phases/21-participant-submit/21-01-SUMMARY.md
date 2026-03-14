---
phase: 21-participant-submit
plan: 01
subsystem: ui
tags: [elm-ui, form, terminal-style, participant, bordered-container]

# Dependency graph
requires:
  - phase: 20-topscorer-card
    provides: focus-tracked bordered container pattern (outer border driven by parent state, onFocus/onBlur on inner input)
  - phase: 18-foundation
    provides: Color, UI.Style.terminalInput, UI.Font.mono
provides:
  - Participant card field rows with uppercase labels and bordered containers
  - Focus-driven border colour (orange/red/grey) on participant inputs
affects: [22-submit-card, 23-results-activities]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Uppercase label (Font.size 9, letterSpacing 0.14) above bordered container row"
    - "Bordered container: Border.width 1, border colour = red|orange|terminalBorder driven by hasError/isActive"
    - "Prompt char inside container: '!' error, '>' active, '-' default with matching colour"
    - "Placeholder text per field with Font.color Color.grey, UI.Font.mono"

key-files:
  created: []
  modified:
    - src/Form/Participant.elm

key-decisions:
  - "Outer Element.column spacing 12 wraps all 6 field columns for visual separation"
  - "terminalInput still applied to inner Element.Input.text; outer container border separately driven by state"
  - "Font.letterSpacing 0.14 on uppercase label for spaced-out terminal feel"

patterns-established:
  - "Participant field row: labelEl (uppercase) above borderedContainer (prompt + input inline)"

requirements-completed: [FORM-07]

# Metrics
duration: 5min
completed: 2026-03-10
---

# Phase 21 Plan 01: Participant Card Restyle Summary

**Participant field rows restyled with uppercase labels above bordered containers — border colour tracks focus/error state via `activeField` state**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-03-10T18:40:00Z
- **Completed:** 2026-03-10T18:45:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Each of 6 participant fields now renders uppercase label (NAAM, ADRES, etc.) above a dark bordered container
- Container border changes to orange on focus, red on error, terminalBorder grey otherwise
- Prompt character inside container: `>` when active, `!` on error, `-` default
- Placeholder text added per field in grey monospace
- Outer field list uses spacing 12 for visual breathing room between fields

## Task Commits

Each task was committed atomically:

1. **Task 1: Restyle participant field rows with bordered containers and uppercase labels** - `24a96af` (feat)

## Files Created/Modified
- `src/Form/Participant.elm` - Rewrote `inputField` helper; added `Element.Background` and `Element.Border` imports; added `placeholders` list; updated `lines` construction to thread placeholder values through tuple nesting

## Decisions Made
- Used `Font.size 9` directly for the uppercase label (smallest readable size in Martian Mono at phone widths), matching plan spec
- Used `Font.letterSpacing 0.14` for spaced capitals — subtle tracking consistent with terminal aesthetic
- Wrapped all 6 rendered field columns in a single `Element.column [spacing 12, width fill]` inserted into the page list, keeping header and introduction as-is
- `terminalInput` retained on the inner `Element.Input.text` unchanged; outer container border controlled separately by `borderColor` computed from `hasError`/`isActive`

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Participant card visually complete; matches v1.4 terminal pattern
- FORM-07 satisfied
- Phase 22 (submit card) and phase 23 (results/activities) can proceed independently

---
*Phase: 21-participant-submit*
*Completed: 2026-03-10*
