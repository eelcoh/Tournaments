# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-28 after v1.1 milestone started)

**Core value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.
**Current focus:** Phase 9 — Group Match Score Input Improvements

## Current Position

Phase: 9 of 9 (Group Match Score Input Improvements)
Plan: 1 of 3 (09-01 complete)
Status: In Progress — Phase 9 plan 1 done
Last activity: 2026-03-01 — 09-01 executed (user-select none on score buttons)

Progress: [██████████] (phase 9 started; 1/3 plans complete)

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
| 8. Form Mobile Polish | 2/2 | ~7min | ~3.5min |
| 9. Group Match Score Input | 1/3 | ~5min | ~5min |

## Accumulated Context

### Roadmap Evolution

- Phase 9 added: Group Match score input improvements

### Decisions

All decisions logged in PROJECT.md Key Decisions table.

Recent decisions affecting v1.1 work:
- user-select: none applied at scoreButton_ leaf level (not container) so each button cell is individually non-selectable; -webkit-user-select: none added for Safari

- iOS Safari install prompt: pass navigator.standalone as Elm flag (from index.html/JS)
- Any new static assets must be added to APP_SHELL in src/sw.js
- Scroll wheel uses buildWindow (flat-list + index) for strict 7-item output; WLPadding at 44px eliminates height jumps
- Group label anchoring replaces only above[0] (line 1), never above[1]/above[2]
- deferredPrompt captured in <head> before main.js loads; forwarded to Elm via onBeforeInstallPrompt port after init
- isIOS and isStandalone passed as flags (sync); BeforeInstallPrompt availability via port message (async)
- BannerShowingIOS derived in init from isIOS flag; BannerShowingAndroid set when port fires
- Single inFront column stacks install banner above status bar — avoids z-index issues
- BannerHidden returns Element.none — no DOM node, no layout shift
- ScrollToTop is discard target for Browser.Dom.setViewport Task result; fires on every NavigateTo
- navButton disabled: Font.color Color.grey + NoOp (not hidden) to avoid layout shifts
- cardCenterInfo lives in View.elm alongside viewFormNavBar for co-location of related logic
- 64px bottom padding on card column (larger than 48px nav bar) for visual breathing room
- mouseOver maps to CSS :hover on mobile; tap briefly triggers hover before navigation — flash feedback with no new Msg or state
- Disabled nav buttons do not get mouseOver — only active (orange) buttons receive white highlight on press
- verzenden... (not inzenden...) used for the Loading branch label to match Dutch verb for sending

### Pending Todos

None.

### Blockers/Concerns

None — clean slate for v1.1.

## Session Continuity

Last session: 2026-03-01
Stopped at: Completed 09-01-PLAN.md — user-select none on score buttons; Phase 9 plan 1 done
Resume file: None
