---
phase: 18-foundation
plan: 01
subsystem: ui
tags: [elm, elm-ui, font, css, martian-mono, variable-font, crt]

# Dependency graph
requires: []
provides:
  - Martian Mono variable font self-hosted in assets/fonts/
  - fonts.css updated with Martian Mono @font-face declaration
  - UI.Font.mono attribute updated to Martian Mono (propagates globally)
  - CRT scanline overlay in index.html body::before pseudo-element
affects: [19-form-cards, 20-group-matches, 21-bracket, 22-results, 23-activities]

# Tech tracking
tech-stack:
  added: [Martian Mono variable font woff2 (OFL-1.1)]
  patterns: [Self-hosted variable font via @font-face, CRT scanline via CSS pseudo-element with pointer-events none]

key-files:
  created:
    - assets/fonts/MartianMono[wght].woff2
  modified:
    - assets/fonts/fonts.css
    - src/UI/Font.elm
    - src/index.html

key-decisions:
  - "Downloaded latin subset woff2 from Google Fonts CDN (fonts.gstatic.com) rather than GitHub TTF — direct woff2 avoids conversion step and is the correct web format"
  - "Single variable font file covers all weights 100-800 — no separate static files needed"
  - "CRT scanline z-index 9998 sits above elm-ui without blocking interaction via pointer-events: none"

patterns-established:
  - "Font: all text flows through UI.Font.mono; changing typeface string in one place propagates app-wide"
  - "CRT: body::before pseudo-element for fullscreen overlay effects that do not interfere with interaction"

requirements-completed: [FONT-01, GLOBAL-01]

# Metrics
duration: 2min
completed: 2026-03-09
---

# Phase 18 Plan 01: Foundation Summary

**Martian Mono variable font self-hosted and applied globally via one-line change in UI.Font.elm, plus CRT scanline overlay added as CSS pseudo-element in index.html**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-09T16:40:42Z
- **Completed:** 2026-03-09T16:42:36Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments
- Downloaded Martian Mono variable font woff2 (latin subset, weights 100-800) from Google Fonts CDN and placed in assets/fonts/
- Replaced Sometype Mono @font-face declarations in fonts.css with Martian Mono — no network requests for fonts at runtime
- Changed one string in UI.Font.mono from "Sometype Mono" to "Martian Mono" — all text in the app now uses Martian Mono automatically
- Added CRT scanline texture as body::before pseudo-element in index.html — faint 1px horizontal lines every 4px at 3.5% opacity, non-interactive

## Task Commits

Each task was committed atomically:

1. **Task 1: Self-host Martian Mono and update font attribute** - `ace7923` (feat)
2. **Task 2: Add CRT scanline overlay to index.html** - `b7c665e` (feat)

**Plan metadata:** (docs commit follows)

## Files Created/Modified
- `assets/fonts/MartianMono[wght].woff2` - Variable font file, latin subset, weights 100-800
- `assets/fonts/fonts.css` - Replaced Sometype Mono declarations with Martian Mono @font-face
- `src/UI/Font.elm` - Changed Font.typeface string from "Sometype Mono" to "Martian Mono"
- `src/index.html` - Added inline <style> block with body::before CRT scanline rule

## Decisions Made
- Downloaded latin subset woff2 from Google Fonts CDN (fonts.gstatic.com/martianmono) rather than GitHub TTF source — direct woff2 avoids format conversion and is already the correct browser-ready format
- Single variable font file (wdth,wght axes) covers all required weights 100-800 in one file
- Kept Sometype Mono woff2 files in assets/fonts/ — no harm in unused files, avoids breaking anything if referenced elsewhere

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
- GitHub raw TTF download returned HTML (LFS redirect issue); pivoted to Google Fonts CDN which returned valid woff2 directly

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Martian Mono foundation in place — all subsequent phases inherit the font automatically
- CRT scanline active globally — no per-phase action needed
- Phase 18 plan 02 and later phases can proceed

---
*Phase: 18-foundation*
*Completed: 2026-03-09*
