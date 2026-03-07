# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- 🚧 **v1.2 Visual Polish** — Phases 10-11 (in progress)

## Completed Phases

<details>
<summary>✅ v1.0 Mobile UX (Phases 1–5) — SHIPPED 2026-02-28</summary>

- [x] Phase 1: PWA Infrastructure (2/2 plans) — completed 2026-02-24
- [x] Phase 2: Touch Targets and Score Input (4/4 plans) — completed 2026-02-25
- [x] Phase 3: Bracket Wizard Mobile Layout (2/2 plans) — completed 2026-02-26
- [x] Phase 4: UI Consistency (4/4 plans) — completed 2026-02-28
- [x] Phase 5: Bug Fixes and UX Polish (4/4 plans) — completed 2026-02-28

Full details: `.planning/milestones/v1.0-ROADMAP.md`

</details>

<details>
<summary>✅ v1.1 UX Polish (Phases 6–9) — SHIPPED 2026-03-01</summary>

- [x] Phase 6: Scroll Wheel Stability (1/1 plans) — completed 2026-02-28
- [x] Phase 7: Install Prompt Banners (2/2 plans) — completed 2026-03-01
- [x] Phase 8: Form Mobile Polish (2/2 plans) — completed 2026-03-01
- [x] Phase 9: Group Match Score Input Improvements (2/2 plans) — completed 2026-03-01

Full details: `.planning/milestones/v1.1-ROADMAP.md`

</details>

## 🚧 v1.2 Visual Polish (In Progress)

**Milestone Goal:** Bring the terminal aesthetic to completion with a warm Zenburn color scheme and consistent alignment across all navigation.

### Phases

- [x] **Phase 10: Zenburn Color Scheme** — Apply warm low-contrast Zenburn palette across the whole app; amber replaces orange for active states
- [x] **Phase 11: Navigation Polish** — Terminal aesthetic and centering fixes for both main nav and form card bottom nav (completed 2026-03-07)

### Phase Details

### Phase 10: Zenburn Color Scheme
**Goal**: The app uses a warm, low-contrast Zenburn-inspired palette everywhere — background, text, and accent colors updated throughout
**Depends on**: Nothing (first phase of v1.2)
**Requirements**: COL-01, COL-02, COL-03, COL-04
**Success Criteria** (what must be TRUE):
  1. Every page (form, results, activities, auth) has a warm dark background (~#3f3f3f), not the previous darker/cooler tone
  2. Body text across all pages renders in muted Zenburn cream (~#dcdccc) instead of the previous text color
  3. Active nav items, highlighted scores, and bracket selections show amber (~#f0dfaf) instead of orange
  4. No page is left with mismatched colors — the palette change is visually consistent app-wide
**Plans**: 1 plan

Plans:
- [x] 10-01-PLAN.md — Update UI/Color.elm Zenburn palette + index.html body/theme-color

### Phase 11: Navigation Polish
**Goal**: Main app nav and form card bottom nav both have proper terminal aesthetic with correctly centered labels
**Depends on**: Phase 10
**Requirements**: NAV-01, NAV-02, NAV-03
**Success Criteria** (what must be TRUE):
  1. Main nav links are visually consistent with the app's ASCII/monospace terminal style
  2. Main nav labels are horizontally and vertically centered (using `allCenteredText`)
  3. Form card bottom nav bar shows vorige/volgende labels properly centered within their tap zones
**Plans**: 1 plan

Plans:
- [ ] 11-01-PLAN.md — Fix navlink terminal style + allCenteredText; fix form bottom nav fillPortion centering

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 10. Zenburn Color Scheme | v1.2 | Complete    | 2026-03-07 | 2026-03-07 |
| 11. Navigation Polish | 1/1 | Complete   | 2026-03-07 | - |
