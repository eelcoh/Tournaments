# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-28 after v1.1 milestone started)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 7 — Install Prompt Banners

## Current Position

Phase: 7 of 8 (Install Prompt Banners)
Plan: 2 of 2 (complete)
Status: Phase 07 complete
Last activity: 2026-03-01 — 07-02 install banner view layer implemented and verified end-to-end

Progress: [████░░░░░░] 44% (2/4 phases complete including phase 7 partial)

## Performance Metrics

**Velocity:**
- Total plans completed: 16 (v1.0)
- Average duration: — (not tracked for v1.1 yet)
- Total execution time: —

**By Phase (v1.1):**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 6. Scroll Wheel Stability | 1 | ~30min | ~30min |
| 7. Install Prompt Banners | 2/2 | ~35min | ~17min |
| 8. Form Mobile Polish | TBD | - | - |

## Accumulated Context

### Decisions

All decisions logged in PROJECT.md Key Decisions table.

Recent decisions affecting v1.1 work:
- iOS Safari install prompt: pass navigator.standalone as Elm flag (from index.html/JS)
- Any new static assets must be added to APP_SHELL in src/sw.js
- Scroll wheel uses buildWindow (flat-list + index) for strict 7-item output; WLPadding at 44px eliminates height jumps
- Group label anchoring replaces only above[0] (line 1), never above[1]/above[2]
- deferredPrompt captured in <head> before main.js loads; forwarded to Elm via onBeforeInstallPrompt port after init
- isIOS and isStandalone passed as flags (sync); BeforeInstallPrompt availability via port message (async)
- BannerShowingIOS derived in init from isIOS flag; BannerShowingAndroid set when port fires
- Single inFront column stacks install banner above status bar — avoids z-index issues
- BannerHidden returns Element.none — no DOM node, no layout shift

### Pending Todos

None.

### Blockers/Concerns

None — clean slate for v1.1.

## Session Continuity

Last session: 2026-03-01
Stopped at: Phase 7 Plan 02 complete — 07-02 install banner view layer implemented and verified
Resume file: None
