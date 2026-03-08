# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- ✅ **v1.2 Visual Polish** — Phases 10-13 (shipped 2026-03-07)
- 🔄 **v1.3 Form Flow Redesign** — Phases 14-17 (in planning 2026-03-08)

## Active Milestone: v1.3 Form Flow Redesign

**Goal:** Redesign the betting form flow based on the HTML prototype — dashboard home, reduced group matches, bracket minimap, and topscorer search.

**Design reference:** `design-prototype.html` in project root

### Phases

- [x] **Phase 14: Dashboard Home** — Replace IntroCard with a completion overview (`[x]/[.]/[ ]` per section, tap to jump directly to any section) (completed 2026-03-08)
- [x] **Phase 15: Group Matches Reduction** — Reduce to 1 match per matchday per group (3 per group × 12 = 36 total); preserve scroll wheel and keyboard input (completed 2026-03-08)
- [x] **Phase 16: Bracket Minimap** — Add round-progress dot rail above the bracket wizard; tap dot to jump to round (completed 2026-03-08)
- [ ] **Phase 17: Topscorer Search** — Add live search/filter input to TopscorerCard; filter by name or country

### Phase 14: Dashboard Home

**Goal:** Replace the plain IntroCard with a completion overview that shows all form sections with `[x]/[.]/[ ]` status and lets players tap directly to any section — eliminating the forced-linear intro.

**Requirements:** DASH-01, DASH-02, DASH-03, DASH-04

**Plans:** 1/1 plans complete

Plans:
- [ ] 14-01-PLAN.md — DashboardCard type + Form.Dashboard view with completion overview and tap-to-jump

**Deliverables:**
- New DashboardCard variant (or updated IntroCard) displaying all sections and their completion state
- Tap-to-jump navigation from the overview to any form section
- Live completion status updates as player fills in sections
- "Ready to submit" indicator when all sections are complete

### Phase 15: Group Matches Reduction

**Goal:** Reduce the group stage betting from 72 matches (6 per group) to 36 matches (1 per matchday × 3 matchdays × 12 groups), preserving the scroll wheel and keyboard-first score input.

**Requirements:** GROUPS-01, GROUPS-02, GROUPS-03

**Plans:** 1/1 plans complete

Plans:
- [ ] 15-01-PLAN.md — Update dashboard description text; data filter already in place (selectedMatches)

**Deliverables:**
- Tournament data updated to include only 1 match per matchday per group
- Scroll wheel and keyboard score input unchanged
- Group completion tracking updated to reflect 3 matches per group = done

### Phase 16: Bracket Minimap

**Goal:** Add a round-progress dot rail above the bracket wizard showing all 6 rounds as dots (done/current/pending) with tap-to-jump to any round.

**Requirements:** BRACKET-01, BRACKET-02, BRACKET-03

**Plans:** 1/1 plans complete

Plans:
- [ ] 16-01-PLAN.md — Replace viewRoundStepper with viewBracketMinimap dot rail

**Deliverables:**
- Minimap row rendered above the round badge in the bracket wizard
- Dot states: done (green), current (amber), pending (dim)
- Tap on any dot jumps to that round

### Phase 17: Topscorer Search

**Goal:** Add a live search/filter input at the top of the TopscorerCard so players can quickly find a player by name or country.

**Requirements:** TOP-01, TOP-02, TOP-03

**Plans:** 1 plan

Plans:
- [ ] 17-01-PLAN.md — TopscorerCard search state + filter logic + search input view + top-level wiring

**Deliverables:**
- Search input field with `> zoeken:` prompt prefix in TopscorerCard
- Real-time filtering of team list by name or country as player types (prefix, case-insensitive)
- Empty-state message when no teams match the search term

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
