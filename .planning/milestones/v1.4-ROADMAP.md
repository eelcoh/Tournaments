# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- ✅ **v1.2 Visual Polish** — Phases 10-13 (shipped 2026-03-07)
- ✅ **v1.3 Form Flow Redesign** — Phases 14-17 (shipped 2026-03-09)
- 🚧 **v1.4 Visual Design Adoption** — Phases 18-25 (in progress)

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

---

### 🚧 v1.4 Visual Design Adoption (In Progress)

**Milestone Goal:** Adopt the prototype's visual language app-wide — Martian Mono font, card/tile components, styled inputs, progress rail, and semantic color coding.

## Phases

- [x] **Phase 18: Foundation** - Font switch, CRT overlay, and form navigation chrome (completed 2026-03-09)
- [x] **Phase 19: Group Matches & Bracket Tiles** - Score input styling, scroll wheel rows, bracket team tiles, and round header (completed 2026-03-09)
- [x] **Phase 20: Topscorer** - Player item cards and styled search bar (completed 2026-03-09)
- [x] **Phase 21: Participant & Submit** - Field row styling and submit summary box (completed 2026-03-10)
- [x] **Phase 22: Results Pages** - Card backgrounds, match score color coding, and group standings colors (completed 2026-03-10)
- [x] **Phase 23: Activities Feed** - Bordered card treatment and prototype typography (completed 2026-03-11)

## Phase Details

### Phase 18: Foundation
**Goal**: Global visual foundation is in place — Martian Mono renders everywhere, the CRT scanline texture overlays the whole app, and form navigation chrome shows the progress rail and styled prev/next buttons.
**Depends on**: Nothing (first phase of v1.4)
**Requirements**: FONT-01, GLOBAL-01, NAV-01, NAV-02, NAV-03
**Success Criteria** (what must be TRUE):
  1. All text in the app renders in Martian Mono (self-hosted; no network font requests)
  2. A repeating horizontal scanline texture is visible at low opacity over the entire app surface
  3. The form header shows a segmented progress rail where the active step is orange, completed steps are green, and pending steps are dimmed
  4. Bottom nav prev/next buttons show hover states and appear visually disabled (reduced opacity) at form boundaries
  5. Bottom nav center shows the current step label with an amber `[N]` count when the card has incomplete items
**Plans**: 2 plans

Plans:
- [ ] 18-01-PLAN.md — Self-host Martian Mono font and add CRT scanline overlay
- [ ] 18-02-PLAN.md — Progress rail header and fixed bottom nav chrome

### Phase 19: Group Matches & Bracket Tiles
**Goal**: The group matches scroll wheel and bracket wizard display prototype-style tiles — styled score inputs, SVG flag rows, bordered bracket team cards, and a round header with selection counter.
**Depends on**: Phase 18
**Requirements**: FORM-01, FORM-02, FORM-03, FORM-04
**Success Criteria** (what must be TRUE):
  1. Score input boxes have a dark background, orange text, and a visible border that changes on focus
  2. Scroll wheel match rows show SVG team flags alongside team names in a consistent boxed row layout
  3. Bracket team tiles are bordered cards with a distinct selected state (orange border + tinted background) and visible hover feedback
  4. The bracket round header displays the round title, a description, and a `N/M geselecteerd` counter that updates as teams are picked
**Plans**: 2 plans

Plans:
- [ ] 19-01-PLAN.md — Score input full border + scroll wheel tile rows (FORM-01, FORM-02)
- [ ] 19-02-PLAN.md — Bracket team tile cards + round header with description (FORM-03, FORM-04)

### Phase 20: Topscorer
**Goal**: The topscorer card shows player items as bordered cards and provides a styled search bar consistent with the prototype.
**Depends on**: Phase 19
**Requirements**: FORM-05, FORM-06
**Success Criteria** (what must be TRUE):
  1. Each player item in the topscorer list is a bordered card showing flag, player name, and team code; the selected player shows a `[x]` marker
  2. The search bar has a bordered container with a `>` prompt; the border turns orange when the input is focused
**Plans**: 1 plan

Plans:
- [ ] 20-01-PLAN.md — Flat player list with player cards and styled search bar (FORM-05, FORM-06)

### Phase 21: Participant & Submit
**Goal**: Participant field rows and the submit summary box match the prototype — bordered containers with uppercase labels and status indicators per section.
**Depends on**: Phase 20
**Requirements**: FORM-07, FORM-08
**Success Criteria** (what must be TRUE):
  1. Each participant field row has a bordered container with an uppercase label and a `>` prompt; the focused field's border is orange
  2. The submit card shows a summary box listing each form section with a green checkmark when complete and a red dash when incomplete
**Plans**: 2 plans

Plans:
- [ ] 21-01-PLAN.md — Participant field rows with bordered containers, uppercase labels, and focus state (FORM-07)
- [ ] 21-02-PLAN.md — Submit card summary box, restyled submit button, and incomplete note (FORM-08)

### Phase 22: Results Pages
**Goal**: All results pages use the prototype card aesthetic with semantic color coding for match scores and group standings.
**Depends on**: Phase 18
**Requirements**: RESULTS-01, RESULTS-02, RESULTS-03
**Success Criteria** (what must be TRUE):
  1. Results page cards use `#353535` backgrounds with `#4a4a4a` borders, visually matching the form card aesthetic
  2. Match result rows show scores in amber, team names in cream, and metadata (date, round) in a dimmed color
  3. Group standings rows show the top-2 qualifier rows in green, third-place rows in amber, and eliminated rows in the default cream color
**Plans**: 2 plans

Plans:
- [ ] 22-01-PLAN.md — resultCard style helper + Matches page grouped column layout with amber scores (RESULTS-01, RESULTS-02)
- [ ] 22-02-PLAN.md — Card treatment for Ranking, Topscorers, Knockouts, Bets pages (RESULTS-01, RESULTS-03 deferred)

### Phase 23: Activities Feed
**Goal**: Activity entries appear as bordered cards with prototype typography for timestamps and author labels.
**Depends on**: Phase 18
**Requirements**: ACT-01, ACT-02
**Success Criteria** (what must be TRUE):
  1. Each activity entry (comment or post) is rendered inside a bordered card (`#353535` background, `#4a4a4a` border) rather than a plain log line
  2. Activity timestamps and author labels render in a visually distinct style — dimmed, smaller, and letter-spaced — matching the prototype
**Plans**: 1 plan

Plans:
- [ ] 23-01-PLAN.md — Card treatment for commentBox/blogBox, notification lines, and darkBox comment input (ACT-01, ACT-02)

### Phase 24: Verify Phase 22 Results Pages
**Goal**: Phase 22 is fully verified with a VERIFICATION.md that confirms resultCard application and amber score coloring across all results pages.
**Depends on**: Phase 22
**Requirements**: RESULTS-01, RESULTS-02
**Gap Closure**: Closes gaps from v1.4 audit — Phase 22 VERIFICATION.md missing (integration blocker)
**Success Criteria** (what must be TRUE):
  1. A VERIFICATION.md exists in `.planning/phases/22-results-pages/` with evidence for RESULTS-01 and RESULTS-02
  2. RESULTS-01 and RESULTS-02 are confirmed satisfied with code references
**Plans**: 1 plan

Plans:
- [ ] 24-01-PLAN.md — Create Phase 22 VERIFICATION.md with evidence for RESULTS-01 and RESULTS-02

### Phase 25: Group Standings View
**Goal**: A group standings table exists in the app showing each group's teams ranked by points, with semantic color coding for qualified (green), third-place (amber), and eliminated (cream) rows.
**Depends on**: Phase 22
**Requirements**: RESULTS-03
**Gap Closure**: Closes gaps from v1.4 audit — RESULTS-03 unsatisfied (group standings semantic colors)
**Success Criteria** (what must be TRUE):
  1. A group standings view is accessible from the results section, showing all 12 WC2026 groups with teams ranked by points
  2. Top-2 rows render in green, third-place rows in amber, and eliminated rows in the default cream color
  3. The standings view uses `resultCard` background treatment consistent with the other results pages
**Plans**: 1 plan

Plans:
- [ ] 25-01-PLAN.md — Group standings view with semantic color coding (RESULTS-03)

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 18. Foundation | 2/2 | Complete    | 2026-03-09 | - |
| 19. Group Matches & Bracket Tiles | 2/2 | Complete    | 2026-03-09 | - |
| 20. Topscorer | 1/1 | Complete    | 2026-03-09 | - |
| 21. Participant & Submit | 2/2 | Complete    | 2026-03-10 | - |
| 22. Results Pages | 2/2 | Complete   | 2026-03-10 | - |
| 23. Activities Feed | 1/1 | Complete    | 2026-03-11 | - |
| 24. Verify Phase 22 Results Pages | 1/1 | Complete    | 2026-03-11 | - |
| 25. Group Standings View | 1/1 | Complete    | 2026-03-12 | - |
