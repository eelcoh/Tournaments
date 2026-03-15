# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- ✅ **v1.2 Visual Polish** — Phases 10-13 (shipped 2026-03-07)
- ✅ **v1.3 Form Flow Redesign** — Phases 14-17 (shipped 2026-03-09)
- ✅ **v1.4 Visual Design Adoption** — Phases 18-25 (shipped 2026-03-14)
- ✅ **v1.5 Test/Demo Mode** — Phases 26-29 (shipped 2026-03-15)
- 🚧 **v1.6 Visual Consistency** — Phases 30-34 (in progress)

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

<details>
<summary>✅ v1.2 Visual Polish (Phases 10–13) — SHIPPED 2026-03-07</summary>

- [x] Phase 10: Zenburn Color Scheme (1/1 plans) — completed 2026-03-07
- [x] Phase 11: Navigation Polish (2/2 plans) — completed 2026-03-07
- [x] Phase 12: Page Width Consistency (1/1 plans) — completed 2026-03-07
- [x] Phase 13: More UX Polish (2/2 plans) — completed 2026-03-07

Full details: `.planning/milestones/v1.2-ROADMAP.md`

</details>

<details>
<summary>✅ v1.3 Form Flow Redesign (Phases 14–17) — SHIPPED 2026-03-09</summary>

- [x] Phase 14: Dashboard Home (1/1 plans) — completed 2026-03-08
- [x] Phase 15: Group Matches Reduction (1/1 plans) — completed 2026-03-08
- [x] Phase 16: Bracket Minimap (1/1 plans) — completed 2026-03-08
- [x] Phase 17: Topscorer Search (1/1 plans) — completed 2026-03-08

Full details: `.planning/milestones/v1.3-ROADMAP.md`

</details>

<details>
<summary>✅ v1.4 Visual Design Adoption (Phases 18–25) — SHIPPED 2026-03-14</summary>

- [x] Phase 18: Foundation (2/2 plans) — completed 2026-03-09
- [x] Phase 19: Group Matches & Bracket Tiles (2/2 plans) — completed 2026-03-09
- [x] Phase 20: Topscorer (1/1 plans) — completed 2026-03-09
- [x] Phase 21: Participant & Submit (2/2 plans) — completed 2026-03-10
- [x] Phase 22: Results Pages (2/2 plans) — completed 2026-03-10
- [x] Phase 23: Activities Feed (1/1 plans) — completed 2026-03-11
- [x] Phase 24: Verify Phase 22 Results Pages (1/1 plans) — completed 2026-03-11
- [x] Phase 25: Group Standings View (1/1 plans) — completed 2026-03-12

Full details: `.planning/milestones/v1.4-ROADMAP.md`

</details>

<details>
<summary>✅ v1.5 Test/Demo Mode (Phases 26–29) — SHIPPED 2026-03-15</summary>

- [x] Phase 26: Mode Foundation (1/1 plans) — completed 2026-03-14
- [x] Phase 27: Dummy Activities and Offline Submission (1/1 plans) — completed 2026-03-14
- [x] Phase 28: Dummy Results (1/1 plans) — completed 2026-03-14
- [x] Phase 29: Fill All Bet (1/1 plans) — completed 2026-03-14

Full details: `.planning/milestones/v1.5-ROADMAP.md`

</details>

## 🚧 v1.6 Visual Consistency (In Progress)

**Milestone Goal:** Align navigation, card headers, intro texts, team tile layouts, and activities feed with the prototype design system.

### Phases

- [x] **Phase 30: Navigation Typography** - Header, progress rail step labels, and bottom nav bar match prototype sizing (completed 2026-03-15)
- [x] **Phase 31: Card Headers & Intro Chrome** - Section headers use `--- TITLE ---` amber pattern; intro text uses dash-intro style; bracket round badge matches prototype (completed 2026-03-15)
- [ ] **Phase 32: Team Badge Tiles** - Group match, bracket, and topscorer team tiles match prototype layout
- [ ] **Phase 33: Activities Feed Styling** - Comment and blog post entries use dash-intro style with distinct amber/green left borders
- [ ] **Phase 34: Input Auto-focus** - Comment, participant name, and blog post inputs receive cursor focus automatically

## Phase Details

### Phase 30: Navigation Typography
**Goal**: All navigation surfaces — app header, form progress rail, and bottom nav bar — match the prototype's exact typography and sizing
**Depends on**: Nothing (first v1.6 phase)
**Requirements**: NAV-01, NAV-02, NAV-03
**Success Criteria** (what must be TRUE):
  1. The app header shows a 12px logo with 0.1em letter-spacing on a `#2b2b2b` background that is exactly 44px tall with a 1px bottom border
  2. Progress rail step labels render at 8px with 0.12em letter-spacing, matching the prototype `.p-name` style
  3. The bottom nav bar is 56px tall with a dark background, border-top, and `< vorige` / `volgende >` labels at 12px
**Plans**: 1 plan

Plans:
- [ ] 30-01-PLAN.md — App header logo typography, progress rail step labels, bottom nav 56px height

### Phase 31: Card Headers & Intro Chrome
**Goal**: Card section headers, intro/description text blocks, and the bracket round badge header all match the prototype design system typography and decoration
**Depends on**: Phase 30
**Requirements**: CHROME-01, CHROME-02, CHROME-03
**Success Criteria** (what must be TRUE):
  1. Section and card headers display as 10px amber text with 0.18em letter-spacing flanked by `---` dashes on both sides
  2. Card intro/description text blocks show a 2px orange left border, 11px dim text at 1.75 line-height, and a subtle orange-tinted background
  3. The bracket round badge header shows a bordered box with an 11px active-color title and a 10px dim subtitle
**Plans**: 2 plans

Plans:
- [ ] 31-01-PLAN.md — Section headers (sec-head pattern) and intro text blocks (dash-intro style)
- [ ] 31-02-PLAN.md — Bracket round badge header (bordered box with active title and dim subtitle)

### Phase 32: Team Badge Tiles
**Goal**: Team badge tiles on the group matches page, bracket wizard, and topscorer page all match the prototype layout with correct flag size, typography, and spacing
**Depends on**: Phase 31
**Requirements**: BADGES-01, BADGES-02, BADGES-03
**Success Criteria** (what must be TRUE):
  1. Group match team tiles show an SVG flag at consistent size with the team abbreviation at 11px and correct spacing between elements
  2. Bracket team tiles show an SVG flag, 11px 500-weight team name, and 9px dim 3-letter code inside a bordered tile
  3. Topscorer player tiles show an SVG flag, 12px player name, and 10px dim team name in `.player-item` style
**Plans**: TBD

### Phase 33: Activities Feed Styling
**Goal**: Comment and blog post entries in the activities feed display with visually distinct dash-intro styles that communicate the content type at a glance
**Depends on**: Phase 30
**Requirements**: ACTIVITIES-01, ACTIVITIES-02
**Success Criteria** (what must be TRUE):
  1. Comment entries display with a 2px amber (`#f0dfaf`) left border, dim text, and a subtle amber-tinted background
  2. Blog post entries display with a 2px green (`#7f9f7f`) left border, dim text, and a subtle green-tinted background — visually distinct from comment entries at a glance
**Plans**: TBD

### Phase 34: Input Auto-focus
**Goal**: The three primary text entry points in the app automatically receive cursor focus so players can start typing without an extra tap
**Depends on**: Phase 30
**Requirements**: FOCUS-01, FOCUS-02, FOCUS-03
**Success Criteria** (what must be TRUE):
  1. When a player navigates to the home/activities page, the comment input field has cursor focus and is ready to accept text without a tap
  2. When the participant card becomes the active form card, the name field has cursor focus
  3. When a player opens the blog post entry form, the text area has cursor focus
**Plans**: TBD

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1–5 | v1.0 | Complete | Shipped | 2026-02-28 |
| 6–9 | v1.1 | Complete | Shipped | 2026-03-01 |
| 10–13 | v1.2 | Complete | Shipped | 2026-03-07 |
| 14–17 | v1.3 | Complete | Shipped | 2026-03-09 |
| 18–25 | v1.4 | Complete | Shipped | 2026-03-14 |
| 26–29 | v1.5 | Complete | Shipped | 2026-03-15 |
| 30. Navigation Typography | 2/2 | Complete    | 2026-03-15 | - |
| 31. Card Headers & Intro Chrome | 2/2 | Complete   | 2026-03-15 | - |
| 32. Team Badge Tiles | v1.6 | 0/TBD | Not started | - |
| 33. Activities Feed Styling | v1.6 | 0/TBD | Not started | - |
| 34. Input Auto-focus | v1.6 | 0/TBD | Not started | - |
