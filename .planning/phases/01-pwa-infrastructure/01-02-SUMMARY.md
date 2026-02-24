---
phase: 01-pwa-infrastructure
plan: 02
subsystem: infra
tags: [pwa, service-worker, cache-first, manifest, fonts, makefile]

# Dependency graph
requires:
  - phase: 01-01
    provides: assets/fonts/, src/manifest.json, assets/apple-touch-icon.png
provides:
  - Vanilla cache-first service worker (src/sw.js) with /bets/ API pass-through
  - index.html updated: manifest link, theme-color, iOS PWA metas, self-hosted fonts, SW registration
  - Makefile pwa target: copies sw.js and manifest.json to build/ during make build
affects:
  - Phase 2+ (service worker cache list and index.html are finalized; any new static assets must be added to APP_SHELL)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Cache-first service worker with named CACHE_NAME for version-bump update mechanism"
    - "Network-only pass-through for /bets/ API prefix — never cache dynamic auth data"
    - "SW install pre-caches 7 same-origin paths atomically (failure = SW discarded)"
    - "Activate event purges all caches not matching current CACHE_NAME"
    - "Only cache successful same-origin GET responses (response.type === 'basic') to avoid opaque response issues"
    - "SW registration on window load event with .catch() for graceful degradation"

key-files:
  created:
    - src/sw.js
  modified:
    - src/index.html
    - Makefile

key-decisions:
  - "No skipWaiting() — cache version bump (CACHE_NAME) is the correct update mechanism to avoid serving stale content to active tabs"
  - "7 APP_SHELL paths cover /, /index.html, /main.js, /manifest.json, fonts.css, and both woff2 files — complete offline app shell"
  - "debug target does not depend on pwa — PWA files are environment-agnostic but Elm debug builds omit optimization flags"

patterns-established:
  - "Cache versioning: bump CACHE_NAME string to force clients to re-download all assets"
  - "API pass-through: url.pathname.startsWith('/bets/') returns early without respondWith"

requirements-completed: [PWA-04, PWA-05, PWA-06]

# Metrics
duration: 2min
completed: 2026-02-24
---

# Phase 1 Plan 02: Service Worker and PWA Wiring Summary

**Vanilla cache-first service worker with versioned APP_SHELL, index.html wired with manifest/iOS metas/SW registration, and Makefile pwa target producing deployable build/**

## Performance

- **Duration:** 2 min
- **Started:** 2026-02-24T20:20:30Z
- **Completed:** 2026-02-24T20:22:07Z
- **Tasks:** 3
- **Files modified:** 3

## Accomplishments
- src/sw.js: cache-first service worker with CACHE_NAME='voetbalpool-v1', 7-path APP_SHELL, install/activate/fetch handlers, /bets/ API pass-through
- src/index.html: removed Google Fonts, added manifest link, theme-color, iOS PWA metas, apple-touch-icon, fonts.css, SW registration
- Makefile: pwa target added as build dependency, copies src/manifest.json and src/sw.js to build/

## Task Commits

Each task was committed atomically:

1. **Task 1: Create src/sw.js — versioned cache-first service worker** - `a431bce` (feat)
2. **Task 2: Update src/index.html — PWA meta tags, local font, SW registration** - `35f75e0` (feat)
3. **Task 3: Extend Makefile — add pwa target, copy sw.js and manifest.json to build/** - `51aa83f` (feat)

## Files Created/Modified
- `src/sw.js` - Vanilla service worker: cache-first for app shell, network-only for /bets/ API
- `src/index.html` - PWA manifest link, theme-color, iOS metas, self-hosted fonts.css, SW registration script
- `Makefile` - pwa target added to build dependencies; copies manifest.json and sw.js to build/

## Decisions Made
- No skipWaiting() in service worker — bumping CACHE_NAME string is the correct mechanism so active tabs are not disrupted mid-session
- debug target left without pwa dependency — Elm debug builds serve for development iteration, not installability testing
- 7 same-origin paths in APP_SHELL cover the full offline-capable app shell without cross-origin entries

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- PWA stack is complete: manifest + icons (Plan 01) + service worker + wired HTML (Plan 02)
- `make build` produces a fully deployable build/ directory with sw.js, manifest.json, fonts, icons, and compiled Elm
- To verify in browser: serve build/ with `python3 -m http.server --directory build` and check Chrome DevTools Application > Manifest and Application > Service Workers
- iOS Safari: still no automatic install prompt; an in-app install tip using `navigator.standalone` flag is noted as a future concern
- Any new static assets added to the project must be added to APP_SHELL in src/sw.js

---
*Phase: 01-pwa-infrastructure*
*Completed: 2026-02-24*
