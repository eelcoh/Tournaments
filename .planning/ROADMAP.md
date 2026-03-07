# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- 🚧 **v1.2 Visual Polish** — Phases 10-12 (in progress)

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
- [x] **Phase 12: Page Width Consistency** — Constrain outer page column to 600px so nav, content, and footer all align (completed 2026-03-07)

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

### Phase 12: make page width consistent
**Goal**: The outer page column (nav + content + footer) is constrained to a fixed 600px on desktop, matching inner content width so all elements left-align to the same boundary
**Depends on**: Phase 11
**Requirements**: WIDTH-01, WIDTH-02
**Success Criteria** (what must be TRUE):
  1. Nav bar left edge aligns with content left edge on desktop — no more nav stretching past content
  2. UI.Screen.maxWidth returns 600 (fixed constant) instead of 80% of viewport
  3. Bottom overlay bars (form nav, status bar, install banner) remain full-width
  4. Phone layout (< 500px) is visually unchanged
**Plans**: 1 plan

Plans:
- [ ] 12-01-PLAN.md — Fix UI.Screen.maxWidth to 600px constant + cap View.elm page column

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 10. Zenburn Color Scheme | v1.2 | Complete    | 2026-03-07 | 2026-03-07 |
| 11. Navigation Polish | 2/2 | Complete    | 2026-03-07 | - |
| 12. Page Width Consistency | 1/1 | Complete    | 2026-03-07 | - |

### Phase 13: more ux polish

**Goal:** Fix the most noticeable remaining UX rough edges: loading state copy matches terminal aesthetic, input fields are visually discoverable, home page comment inputs use `>` prompt style, and placeholder SVGs distinguish unknown teams from TBD bracket slots.
**Requirements**: UX-POLISH-01, UX-POLISH-02, UX-POLISH-03, UX-POLISH-04
**Depends on:** Phase 12
**Plans:** 2 plans

Plans:
- [ ] 13-01-PLAN.md — Fix Activities loading copy + input label style + terminalInput background
- [ ] 13-02-PLAN.md — Create placeholder SVGs + fix flagUrl/flagUrlRound routing in Team.elm
