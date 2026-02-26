# Roadmap: Mobile UX Milestone

## Overview

Three phases deliver a PWA-installable, touch-friendly betting SPA for World Cup 2026. Phase 1 lays the static-file infrastructure (manifest, service worker, self-hosted fonts) that all caching depends on. Phases 2 and 3 are pure Elm-side attribute changes that make the existing card-based form usable on a 375px phone — no new modules, no new dependencies. The phases run in strict order: fonts must be local before the cache list is locked, and touch targets must be stable before the bracket layout is tuned.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: PWA Infrastructure** - Self-hosted fonts, manifest.json, service worker, and Makefile wiring so the app is installable and app-shell-cached
- [x] **Phase 2: Touch Targets and Score Input** - All interactive elements meet the 44px minimum; score fields show the numeric keypad; match rows fit a 320px screen (completed 2026-02-25)
- [x] **Phase 3: Bracket Wizard Mobile Layout** - Bracket stepper and team grid are usable on 375px phones without horizontal overflow (completed 2026-02-26)

## Phase Details

### Phase 1: PWA Infrastructure
**Goal**: Players can install the app to their home screen and get instant subsequent loads from cache
**Depends on**: Nothing (first phase)
**Requirements**: PWA-01, PWA-02, PWA-03, PWA-04, PWA-05, PWA-06
**Success Criteria** (what must be TRUE):
  1. Chrome on Android shows the "Add to Home Screen" install prompt when visiting the app
  2. iOS Safari "Add to Home Screen" sheet shows the app name and icon (not a generic globe)
  3. After install, the app opens full-screen without browser chrome on both platforms
  4. Sometype Mono font loads from `assets/fonts/` with no Google Fonts network request
  5. `make build` produces a `build/` directory that includes `sw.js`, `manifest.json`, and font files
**Plans**: 2 plans

Plans:
- [x] 01-01-PLAN.md — Font self-hosting, icons, and manifest.json (static assets, Wave 1)
- [x] 01-02-PLAN.md — Service worker, index.html PWA wiring, and Makefile extension (Wave 2)

### Phase 2: Touch Targets and Score Input
**Goal**: Every interactive element is comfortably tappable on a phone and score entry shows the right keyboard
**Depends on**: Phase 1
**Requirements**: MOB-01, MOB-02, MOB-03, MOB-04, MOB-05, MOB-06, SCR-01, SCR-02, SCR-03
**Success Criteria** (what must be TRUE):
  1. No interactive element (nav letter, score button, nav link, bracket badge, step indicator) is smaller than 44x44px on a 375px-wide screen
  2. Tapping a score input on iOS or Android raises the numeric keypad, not the QWERTY keyboard
  3. Group match rows are fully visible on a 320px-wide screen (iPhone SE) with no horizontal scroll or clipping
**Plans**: 4 plans

Plans:
- [x] 02-01-PLAN.md — UI.Button nav + score button heights to 44px (Wave 1)
- [x] 02-02-PLAN.md — GroupMatches nav letter tap zones, scroll line tap zones, inputmode=numeric (Wave 1)
- [x] 02-03-PLAN.md — Bracket team badge 44px tap zones + step indicator heights (Wave 1)
- [x] 02-04-PLAN.md — Responsive page padding for 320px screens (Wave 1)

### Phase 3: Bracket Wizard Mobile Layout
**Goal**: Players can navigate the full bracket wizard on a 375px phone without zooming or horizontal scrolling
**Depends on**: Phase 2
**Requirements**: BRK-01, BRK-02, BRK-03
**Success Criteria** (what must be TRUE):
  1. The ASCII pipeline stepper does not overflow horizontally at 375px (compact format active on Phone device type)
  2. The team selection grid uses 4 or fewer columns on Phone so all team codes are tappable without zooming
  3. Round header text is readable (effective size >= 14px) at 375px width
**Plans**: 2 plans

Plans:
- [ ] 03-01-PLAN.md — WizardState + Msg extension: add viewingRound field and JumpToRound Msg (Wave 1)
- [ ] 03-02-PLAN.md — View redesign: compact 3-step stepper and 4-column Phone team grid (Wave 2, has checkpoint)

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. PWA Infrastructure | 2/2 | Complete | 2026-02-24 |
| 2. Touch Targets and Score Input | 4/4 | Complete   | 2026-02-25 |
| 3. Bracket Wizard Mobile Layout | 2/2 | Complete   | 2026-02-26 |
