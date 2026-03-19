---
phase: 31-card-headers-intro-chrome
plan: 01
subsystem: ui
tags: [elm-ui, typography, header, elm]

# Dependency graph
requires:
  - phase: 30-navigation-typography
    provides: Font.size literal pattern (12/8px) established for sub-pixel sizes
provides:
  - header2 style at 10px amber with 1.8px letter-spacing (no bottom border, no bold)
  - displayHeader as Element.row with color-split dashes (dim grey) and amber title
  - introduction style with 2px orange-amber left border, 11px grey text, 4% orange-tinted background
affects: [32-form-card-typography, any module using UI.Text.displayHeader or UI.Style.introduction]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Color-split row pattern: use Element.row with separate child els for different-colored segments of a heading"
    - "Literal Font.size for sub-16px values (10, 11) — UI.Font.scaled has no values at these sizes"
    - "rgba255 alpha as Float (0.04) not hex (0x0A) for transparent tint backgrounds"

key-files:
  created: []
  modified:
    - src/UI/Style.elm
    - src/UI/Text.elm
    - src/Form/Topscorer.elm

key-decisions:
  - "Use Element.row for displayHeader instead of single-color string concatenation — enables independent coloring of dashes vs title"
  - "Font.letterSpacing 1.8 (pixels) for 0.18em at 10px font-size — elm-ui letterSpacing is in px not em"
  - "Element.rgba255 alpha must be Float 0.04, not hex 0x0A (which equals 10/255 but reads as 10 alpha units, effectively opaque)"
  - "Topscorer intro/warning text uses Element.text directly inside paragraph — simpleText/boldText wrappers override font size"

patterns-established:
  - "Color-split heading: Element.row [ spacing 8 ] [ el dashStyle (text '---'), el titleStyle (text TITLE), el dashStyle (text '---') ]"
  - "Intro block: Border.widthEach left=2, Border.color activeNav, Background.color (rgba255 0xF0 0xA0 0x30 0.04), Font.size 11"

requirements-completed: [CHROME-01, CHROME-02]

# Metrics
duration: 10min
completed: 2026-03-15
---

# Phase 31 Plan 01: Card Headers and Intro Chrome Summary

**10px amber section headers with color-split dim dashes plus 2px orange-left-border intro blocks matching the prototype .sec-head and .dash-intro patterns**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-03-15T11:55:00Z
- **Completed:** 2026-03-15T12:05:35Z
- **Tasks:** 3 (2 auto + 1 human-verify)
- **Files modified:** 3

## Accomplishments

- `header2` style refactored to 10px amber, 1.8px letter-spacing, no bottom border, no bold
- `displayHeader` refactored from single amber string to `Element.row` with dim grey dashes flanking amber title
- `introduction` style updated to 11px grey text, 2px activeNav left border, 4% orange-tinted background
- Post-checkpoint alpha bug fixed: `rgba255` alpha was `0x0A` (hex literal treated as integer) — corrected to `0.04` (Float)
- Topscorer intro/warning text fixed to use `Element.text` directly so `Font.size 11` from paragraph style takes effect

## Task Commits

1. **Task 1: Fix header2 style** - `5ae9fba` (feat)
2. **Task 2: Refactor displayHeader + fix introduction** - `9656e13` (feat)
3. **Task 3: Human verify (approved) + post-checkpoint fixes** - `cd04938` (fix)

**Plan metadata:** (docs commit follows)

## Files Created/Modified

- `src/UI/Style.elm` - header2 at 10px/1.8px-spacing/no-border, introduction with left border + tinted bg + 11px grey; alpha float fix
- `src/UI/Text.elm` - displayHeader as Element.row with color-split dashes
- `src/Form/Topscorer.elm` - intro/warning text changed to Element.text to respect font-size

## Decisions Made

- Use `Element.row` for `displayHeader` so dashes and title can be independently colored (dim grey vs amber)
- `Font.letterSpacing 1.8` — elm-ui letterSpacing is in pixels; 0.18em at 10px = 1.8px
- `rgba255` alpha must be a `Float` (0.04), not a hex int (0x0A) which equals 10 — an opaque-looking value
- Topscorer intro text must use `Element.text` directly inside the paragraph; helper functions like `simpleText` apply their own font-size attribute overriding the paragraph style

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] rgba255 alpha 0x0A was effectively opaque instead of 4% transparent**
- **Found during:** Task 3 (human-verify — background tint invisible)
- **Issue:** `Background.color (Element.rgba255 0xF0 0xA0 0x30 0x0A)` — the last argument is a `Float` in elm-ui's API; `0x0A` is a hex integer literal equal to `10`, not `0.04`. The background rendered as near-opaque orange.
- **Fix:** Changed to `Element.rgba255 0xF0 0xA0 0x30 0.04`
- **Files modified:** `src/UI/Style.elm`
- **Verification:** Build passes; background renders as subtle 4% tint
- **Committed in:** `cd04938`

**2. [Rule 1 - Bug] Topscorer intro/warning text overriding font-size via helper wrappers**
- **Found during:** Task 3 (human-verify — intro text appeared larger than 11px)
- **Issue:** `introduction` paragraph used `simpleText`/`boldText` helpers which add their own `Font.size` attribute, overriding the 11px set on the container
- **Fix:** Replaced with `Element.text` directly inside the paragraph
- **Files modified:** `src/Form/Topscorer.elm`
- **Verification:** Build passes; intro text renders at 11px as specified
- **Committed in:** `cd04938`

---

**Total deviations:** 2 auto-fixed (both Rule 1 — bugs discovered during human verification)
**Impact on plan:** Both fixes were required for correctness; no scope creep.

## Issues Encountered

None beyond the two bugs auto-fixed above.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Section headers and intro blocks now match the prototype design system
- `UI.Text.displayHeader` and `UI.Style.introduction` are stable references for Phase 32 (form card typography)
- No blockers

---
*Phase: 31-card-headers-intro-chrome*
*Completed: 2026-03-15*
