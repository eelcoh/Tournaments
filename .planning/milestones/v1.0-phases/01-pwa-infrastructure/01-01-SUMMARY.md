---
phase: 01-pwa-infrastructure
plan: 01
subsystem: infra
tags: [pwa, fonts, manifest, icons, woff2, imagemagick]

# Dependency graph
requires: []
provides:
  - Self-hosted Sometype Mono variable woff2 fonts (upright + italic, 400-700 weight range)
  - fonts.css with @font-face declarations for service worker caching
  - Four PWA icons: icon-192.png, icon-512.png, icon-512-maskable.png, apple-touch-icon.png
  - src/manifest.json with display:standalone, theme/background colors, and 3 icon entries
affects:
  - 01-02 (service worker cache list needs font paths and manifest finalized)
  - index.html (needs manifest link tag and apple-touch-icon link tag, added in Plan 02)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Self-hosted variable woff2 fonts with relative url() paths in fonts.css"
    - "Separate manifest icon entries for purpose:any and purpose:maskable (not combined)"
    - "Maskable icon reuses any-purpose 512 design — dark bg fills full canvas safely"

key-files:
  created:
    - assets/fonts/SometypeMono[wght].woff2
    - assets/fonts/SometypeMono-Italic[wght].woff2
    - assets/fonts/fonts.css
    - assets/icon-192.png
    - assets/icon-512.png
    - assets/icon-512-maskable.png
    - assets/apple-touch-icon.png
    - src/manifest.json
  modified: []

key-decisions:
  - "Font files downloaded from fonts/webfonts/ path in googlefonts/sometype-mono (master branch), not fonts/variable/ — only TTF variable files exist there, woff2 variable files are in webfonts/"
  - "Used CaskaydiaMono-NF-Bold ImageMagick font instead of DejaVu-Sans-Bold (not available on system)"
  - "Icon files are 27-29KB (slightly under 30KB plan estimate) — valid woff2 variable fonts from the CFF-based webfonts build"

patterns-established:
  - "Icon design: orange #ff8c00 text on dark #0d0d0d background — matches terminal theme"
  - "Manifest colors: background_color #0d0d0d, theme_color #ff8c00 — must match index.html body bg"

requirements-completed: [PWA-01, PWA-02, PWA-03]

# Metrics
duration: 2min
completed: 2026-02-24
---

# Phase 1 Plan 01: PWA Static Assets Summary

**Sometype Mono variable woff2 fonts self-hosted with fonts.css, four PWA icons generated with ImageMagick, and Web App Manifest created with display:standalone for Chrome install prompt**

## Performance

- **Duration:** 2 min
- **Started:** 2026-02-24T20:15:58Z
- **Completed:** 2026-02-24T20:17:58Z
- **Tasks:** 3
- **Files modified:** 8

## Accomplishments
- Self-hosted Sometype Mono variable fonts (upright + italic woff2) downloaded from googlefonts/sometype-mono
- fonts.css written with @font-face declarations using relative url() paths and font-weight range 400 700
- Four PWA icons generated: icon-192.png (192x192), icon-512.png (512x512), icon-512-maskable.png (512x512), apple-touch-icon.png (180x180)
- src/manifest.json created with display:standalone, orange theme color, dark background, and three icon entries (192 any, 512 any, 512 maskable)

## Task Commits

Each task was committed atomically:

1. **Task 1: Download Sometype Mono variable font files and write fonts.css** - `2899391` (chore)
2. **Task 2: Generate PNG icons (192, 512, 512-maskable, 180 apple-touch-icon)** - `557d0c2` (chore)
3. **Task 3: Create src/manifest.json** - `73f4112` (feat)

## Files Created/Modified
- `assets/fonts/SometypeMono[wght].woff2` - Variable upright font, weights 400-700 (27KB woff2)
- `assets/fonts/SometypeMono-Italic[wght].woff2` - Variable italic font, weights 400-700 (29KB woff2)
- `assets/fonts/fonts.css` - @font-face declarations for both font axes with relative url() paths
- `assets/icon-192.png` - 192x192 icon for Android install prompt
- `assets/icon-512.png` - 512x512 icon for splash screen / any purpose
- `assets/icon-512-maskable.png` - 512x512 maskable icon for Android adaptive icons
- `assets/apple-touch-icon.png` - 180x180 icon for iOS Safari Add to Home Screen
- `src/manifest.json` - Web App Manifest with display:standalone, three icon entries

## Decisions Made
- Font files downloaded from `fonts/webfonts/` path (master branch), not `fonts/variable/` — the variable/ path only has TTF files; woff2 variable fonts are in webfonts/
- Used CaskaydiaMono-NF-Bold font for icon generation (DejaVu-Sans-Bold was not available on this Arch Linux system)
- Font files are 27-29KB — slightly under the 30KB estimate in the plan, but these are valid woff2 variable fonts from the CFF-based webfonts build in the repository

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Used correct GitHub font repository path**
- **Found during:** Task 1 (Download Sometype Mono variable font files)
- **Issue:** Plan URL path `fonts/variable/SometypeMono[wght].woff2` returned HTTP 404 — woff2 files are not in fonts/variable/, only TTF variable files are there
- **Fix:** Used GitHub API to discover `fonts/webfonts/` contains the woff2 variable files; downloaded from correct path
- **Files modified:** assets/fonts/SometypeMono[wght].woff2, assets/fonts/SometypeMono-Italic[wght].woff2
- **Verification:** file command confirms Web Open Font Format (Version 2), TrueType
- **Committed in:** 2899391 (Task 1 commit)

**2. [Rule 3 - Blocking] Used available monospace font for icon generation**
- **Found during:** Task 2 (Generate PNG icons)
- **Issue:** DejaVu-Sans-Bold font not available on system; ImageMagick returned error
- **Fix:** Used CaskaydiaMono-NF-Bold (available Nerd Font monospace bold) — produces same orange "WC26" text on dark background
- **Files modified:** assets/icon-*.png, assets/apple-touch-icon.png
- **Verification:** identify command confirms correct PNG dimensions for all four icons
- **Committed in:** 557d0c2 (Task 2 commit)

---

**Total deviations:** 2 auto-fixed (2 blocking — path discovery, font substitution)
**Impact on plan:** Both auto-fixes necessary to complete the tasks. No scope creep. All required artifacts produced at correct specifications.

## Issues Encountered
- googlefonts/sometype-mono repository changed to `master` branch (not `main`) and stores woff2 variable fonts in `fonts/webfonts/` not `fonts/variable/`. Discovery via GitHub API took one extra step.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All static assets are ready for Plan 02 (service worker + index.html updates)
- fonts.css path: `assets/fonts/fonts.css` (relative paths inside the file point to sibling woff2 files)
- Manifest path: `src/manifest.json` (Plan 02 Makefile must copy it to build root)
- apple-touch-icon link tag needs adding to index.html (Plan 02)
- manifest.json link tag needs adding to index.html (Plan 02)

---
*Phase: 01-pwa-infrastructure*
*Completed: 2026-02-24*
