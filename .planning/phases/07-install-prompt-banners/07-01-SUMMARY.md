---
phase: 07-install-prompt-banners
plan: "01"
subsystem: pwa
tags: [elm, ports, pwa, install-prompt, javascript, localStorage]

# Dependency graph
requires: []
provides:
  - JS bridge capturing BeforeInstallPrompt event before Elm loads
  - Three Elm ports: triggerInstall (Cmd), persistDismiss (Cmd), onBeforeInstallPrompt (Sub)
  - Extended Flags with isStandalone, isIOS, installBannerDismissCount
  - InstallBannerState type (BannerHidden, BannerShowingIOS, BannerShowingAndroid) in Model
  - Msg variants and update handlers for all install banner interactions
affects: [08-form-mobile-polish, any plan adding install banner UI]

# Tech tracking
tech-stack:
  added: [Elm port module (Ports.elm)]
  patterns:
    - Early JS variable declaration in <head> before main.js loads for event capture
    - Port-based bridge for asynchronous browser API (BeforeInstallPrompt) to Elm
    - Flags for synchronous browser state (isStandalone, isIOS) read at Elm init time

key-files:
  created:
    - src/Ports.elm
  modified:
    - src/index.html
    - src/Types.elm
    - src/Main.elm

key-decisions:
  - "deferredPrompt variable declared in <head> before main.js load so BeforeInstallPrompt captured early; forwarded to Elm via onBeforeInstallPrompt port after app init"
  - "isIOS and isStandalone passed as flags (synchronous at init time); BeforeInstallPrompt availability passed via port message (async)"
  - "BannerShowingIOS derived immediately in init from isIOS flag; BannerShowingAndroid set only when port fires"
  - "onBeforeInstallPrompt uses Maybe () to handle JS null send gracefully"

patterns-established:
  - "Port module pattern: separate Ports.elm file with all port declarations"
  - "Flags extension pattern: add new fields to Flags type alias, extend init in Main.elm to derive state, keep Types.init signature unchanged"

requirements-completed: [INST-01, INST-02, INST-04]

# Metrics
duration: 15min
completed: 2026-02-28
---

# Phase 7 Plan 01: Install Prompt JS-Elm Bridge Summary

**JS bridge with deferredPrompt capture, port module (triggerInstall/persistDismiss/onBeforeInstallPrompt), InstallBannerState type, and init-time iOS/standalone banner derivation from flags**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-02-28T23:04:30Z
- **Completed:** 2026-02-28T23:20:00Z
- **Tasks:** 2
- **Files modified:** 4 (3 modified, 1 created)

## Accomplishments
- JS side captures BeforeInstallPrompt early (before main.js), stores in deferredPrompt, forwards to Elm via port after app init
- Elm reads isStandalone, isIOS, installBannerDismissCount as synchronous flags at startup
- New Ports.elm module with three port declarations wiring JS and Elm
- Model extended with installBanner (InstallBannerState) and installBannerDismissCount; all three Msg variants handled in update

## Task Commits

Each task was committed atomically:

1. **Task 1: JS bridge in index.html** - `ec2eb93` (feat)
2. **Task 2: Elm types, Ports.elm, Main.elm** - `dbf48b4` (feat)

## Files Created/Modified
- `src/Ports.elm` - New port module: triggerInstall (Cmd), persistDismiss (Cmd), onBeforeInstallPrompt (Sub)
- `src/index.html` - deferredPrompt capture in head, three new flags, port wiring for all three ports
- `src/Types.elm` - Extended Flags, new InstallBannerState type, Model fields installBanner/installBannerDismissCount, three new Msg variants
- `src/Main.elm` - Import Ports, derive initialBannerState in init, port subscription, three update handlers

## Decisions Made
- deferredPrompt captured as early as possible (head script) so BeforeInstallPrompt never missed even on fast loads
- iOS detection via userAgent flag passed from JS (Elm has no DOM access); Android detection deferred to port message since BeforeInstallPrompt is async
- `Maybe ()` type for onBeforeInstallPrompt because JS sends null and Elm needs to handle that gracefully
- Types.init kept with unchanged signature; banner state derived and patched in Main.elm init

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- JS-Elm bridge complete; banner state flows into Model on every page load
- Ready for plan 02: install banner UI components (will consume installBanner field from Model)
- No blockers

---
*Phase: 07-install-prompt-banners*
*Completed: 2026-02-28*
