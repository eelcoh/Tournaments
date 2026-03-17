# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- ✅ **v1.2 Visual Polish** — Phases 10-13 (shipped 2026-03-07)
- ✅ **v1.3 Form Flow Redesign** — Phases 14-17 (shipped 2026-03-09)
- ✅ **v1.4 Visual Design Adoption** — Phases 18-25 (shipped 2026-03-14)
- ✅ **v1.5 Test/Demo Mode** — Phases 26-29 (shipped 2026-03-15)
- ✅ **v1.6 Visual Consistency** — Phases 30-34 (shipped 2026-03-15)
- 🚧 **v1.7 Bracket Wizard Redesign** — Phases 35-37 (in progress)

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

<details>
<summary>✅ v1.6 Visual Consistency (Phases 30–34) — SHIPPED 2026-03-15</summary>

- [x] Phase 30: Navigation Typography (2/2 plans) — completed 2026-03-15
- [x] Phase 31: Card Headers & Intro Chrome (2/2 plans) — completed 2026-03-15
- [x] Phase 32: Team Badge Tiles (2/2 plans) — completed 2026-03-15
- [x] Phase 33: Activities Feed Styling (1/1 plans) — completed 2026-03-15
- [x] Phase 34: Input Auto-focus (1/1 plans) — completed 2026-03-15

Full details: `.planning/milestones/v1.6-ROADMAP.md`

</details>

## 🚧 v1.7 Bracket Wizard Redesign (In Progress)

**Milestone Goal:** Redesign the bracket wizard from top-down (champion-first) to bottom-up (R32-first) selection, with per-round badge layouts and group-organized R32 display.

### Phases

- [x] **Phase 35: Wizard State Model** - Rewrite four helper functions in Form/Bracket/Types.elm for bottom-up semantics (completed 2026-03-17)
- [ ] **Phase 36: Wizard View Layer** - Fix round order, grid routing, badge sizing, and selected badge color in Form/Bracket/View.elm
- [ ] **Phase 37: Test Mode Validation** - Rewrite FillAllBet for bottom-up construction and verify end-to-end

### Phase Details

### Phase 35: Wizard State Model
**Goal**: The wizard's internal state helpers correctly encode bottom-up round progression — R32 opens first, each round locks to its own field, pool membership is enforced for R16+, and completion requires all six rounds at capacity.
**Depends on**: Nothing (first phase of milestone)
**Requirements**: WIZ-01, WIZ-02, WIZ-03, WIZ-04
**Success Criteria** (what must be TRUE):
  1. Opening the bracket card shows the R32 round grid, not the champion picker
  2. Selecting a team in R32 does not pre-populate R16 or any later round
  3. Removing a team from R32 immediately removes it from R16 and all subsequent rounds
  4. The "Ga verder" button stays disabled until all six rounds are filled to their required counts
  5. A team cannot be added to R16 unless it was selected in R32
**Plans**: 1 plan

Plans:
- [ ] 35-01-PLAN.md — Rewrite addTeamToRound, canSelectTeam, currentActiveRound, isWizardComplete + fix GoNext

### Phase 36: Wizard View Layer
**Goal**: The wizard renders rounds in the correct bottom-up order with per-round badge layouts — R32 shows 48 teams grouped by group letter, R16 shows code-only badges from the R32 pool, QF through Champion show full-name+code badges, and selected badges show green outlines.
**Depends on**: Phase 35
**Requirements**: R32-01, R32-02, R16-01, R16-02, LATE-01, LATE-02, BADGE-01, BADGE-02
**Success Criteria** (what must be TRUE):
  1. The bracket wizard opens at R32 and steps forward through R16, QF, SF, Final, Champion in that order
  2. R32 displays all 48 teams grouped by group letter (A–L) with an amber 12px header per group
  3. R16 and earlier badge cells show only the 3-letter country code; QF through Champion badges show full team name with code below
  4. Selected team badges show a green outline; badges that cannot be selected (round max reached) appear dimmed
  5. All badge grids align consistently at 320px viewport width with no text overflow
**Plans**: TBD

### Phase 37: Test Mode Validation
**Goal**: The fill-all test button correctly populates the redesigned bottom-up wizard in a single tap, leaving all six rounds at capacity and the bracket completeness check passing.
**Depends on**: Phase 36
**Requirements**: TEST-01
**Success Criteria** (what must be TRUE):
  1. Tapping "fill all" in test mode fills all 6 wizard rounds (R32, R16, QF, SF, Final, Champion) with valid team selections
  2. After fill-all, the bracket minimap shows all dots green and "Ga verder" is enabled
  3. Navigating forward from BracketCard advances to TopscorerCard
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
| 30–34 | v1.6 | Complete | Shipped | 2026-03-15 |
| 35. Wizard State Model | 1/1 | Complete    | 2026-03-17 | - |
| 36. Wizard View Layer | v1.7 | 0/? | Not started | - |
| 37. Test Mode Validation | v1.7 | 0/? | Not started | - |
