---
phase: 07-install-prompt-banners
plan: "02"
subsystem: ui
tags: [elm, elm-ui, pwa, install-prompt, banner]

# Dependency graph
requires:
  - phase: 07-01
    provides: Ports.elm port declarations, InstallBannerState type, model fields, update handlers for install banner
provides:
  - viewInstallBanner function rendering iOS and Android install banners in terminal style
  - inFront column layout stacking install banner above status bar
  - Dismiss button ([x]) wiring to DismissInstallBanner Msg
  - Android CTA ([ Installeer App ]) wiring to TriggerAndroidInstall Msg
affects: [08-form-mobile-polish]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "inFront + alignBottom column stacks overlays: install banner above status bar"
    - "Element.none as BannerHidden case avoids layout shift when no banner visible"
    - "Unicode escape \\u{2197} for ↗ arrow in Elm string literals"

key-files:
  created: []
  modified:
    - src/View.elm

key-decisions:
  - "Banner rendered in single inFront column so banner + status bar stack vertically without multiple inFront z-index issues"
  - "iOS text locked: [ add to home screen ] -- tap ↗ then \"Add to Home Screen\""
  - "Android CTA text locked: [ Installeer App ] in orange; dismiss [x] in grey"
  - "BannerHidden returns Element.none — no DOM node, no layout shift"

patterns-established:
  - "Terminal banner pattern: dark bg (Color.black), top border (Color.terminalBorder), monospace font (UI.Font.mono), scaled 0 size"

requirements-completed: [INST-01, INST-02, INST-03, INST-04]

# Metrics
duration: 20min
completed: 2026-03-01
---

# Phase 7 Plan 02: Install Prompt Banners — View Layer Summary

**Terminal-styled iOS and Android install prompt banners rendered in View.elm above the status bar, with dismiss persistence and standalone-mode suppression verified end-to-end.**

## Performance

- **Duration:** ~20 min
- **Started:** 2026-03-01
- **Completed:** 2026-03-01
- **Tasks:** 2 (1 auto + 1 human-verify checkpoint)
- **Files modified:** 1

## Accomplishments

- `viewInstallBanner` function added to `src/View.elm` with three cases: `BannerHidden` (Element.none), `BannerShowingIOS` (instruction text + dismiss), `BannerShowingAndroid` (orange CTA + dismiss)
- Both banner variants use terminal aesthetic: monospace font, dark background (Color.black), top border (Color.terminalBorder)
- `body` layout updated: single `inFront` column stacks install banner above status bar — no layout shift when banner is hidden
- All 17 human-verify test points passed: iOS banner text correct, dismiss persistence (2-strike logic), Android port trigger, standalone suppression, no layout shift

## Task Commits

1. **Task 1: Add viewInstallBanner to View.elm and wire it into the inFront overlay** - `cca1cb5` (feat)
2. **Task 2: Human verify install prompt banners end-to-end** - checkpoint approved (no code commit)

## Files Created/Modified

- `src/View.elm` - Added `viewInstallBanner`, `bannerRow`, `dismissButton` helpers; updated `body` to use inFront column stacking banner above status bar

## Decisions Made

- Single `inFront` column approach chosen over two separate `inFront` attrs — avoids z-index stacking unpredictability and keeps banner + status bar as a unit
- `Element.none` for `BannerHidden` is idiomatic Elm/elm-ui — produces no DOM node and no layout shift
- Unicode escape `"\u{2197}"` used for ↗ arrow to avoid source encoding issues

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 7 complete: JS bridge (07-01) + view layer (07-02) give full install prompt flow
- Phase 8 (Form Mobile Polish) can proceed; install banner infrastructure is stable
- No blockers

---
*Phase: 07-install-prompt-banners*
*Completed: 2026-03-01*
