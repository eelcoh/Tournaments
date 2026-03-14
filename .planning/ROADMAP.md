# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- ✅ **v1.1 UX Polish** — Phases 6-9 (shipped 2026-03-01)
- ✅ **v1.2 Visual Polish** — Phases 10-13 (shipped 2026-03-07)
- ✅ **v1.3 Form Flow Redesign** — Phases 14-17 (shipped 2026-03-09)
- ✅ **v1.4 Visual Design Adoption** — Phases 18-25 (shipped 2026-03-14)
- 🚧 **v1.5 Test/Demo Mode** — Phases 26-29 (in progress)

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

---

## 🚧 v1.5 Test/Demo Mode (In Progress)

**Milestone Goal:** Enable offline testing and UI demonstration without a live backend — test mode activation, dummy data across all pages, offline activity submission, and one-tap bet fill.

### Phases

- [x] **Phase 26: Mode Foundation** — testMode flag, #test route, 5-tap gesture, TEST badge, nav override (completed 2026-03-14)
- [x] **Phase 27: Dummy Activities and Offline Submission** — lorem ipsum feed, offline comment/post append (completed 2026-03-14)
- [x] **Phase 28: Dummy Results** — dummy data injected on all 4 results pages (completed 2026-03-14)
- [ ] **Phase 29: Fill All Bet** — one-tap Dashboard button fills every section of the bet

## Phase Details

### Phase 26: Mode Foundation
**Goal**: Users can activate test mode and immediately see that it is active
**Depends on**: Phase 25 (v1.4 complete)
**Requirements**: MODE-01, MODE-02, MODE-03, MODE-04
**Success Criteria** (what must be TRUE):
  1. Navigating to `#test` in the browser activates test mode without a page reload
  2. Tapping the app title 5 times on mobile/PWA activates test mode
  3. A visible TEST MODE badge appears in the status bar while test mode is active
  4. All navigation items (form, stand, uitslagen, groepsstand, knock-out, activiteiten) are visible in test mode regardless of tournament state or auth token
**Plans**: 1 plan

Plans:
- [x] 26-01-PLAN.md — Add testMode/titleTapCount to Model, wire #test route, 5-tap title gesture, TEST MODE badge, and nav gate bypass

### Phase 27: Dummy Activities and Offline Submission
**Goal**: Users see a populated activities page and can interact with it without a network connection
**Depends on**: Phase 26
**Requirements**: ACT-01, ACT-02, ACT-03
**Success Criteria** (what must be TRUE):
  1. Navigating to the activities page in test mode shows pre-populated lorem ipsum comments and blog posts
  2. Submitting a comment in test mode prepends it to the activity list without any network request
  3. Submitting a blog post in test mode prepends it to the activity list without any network request
**Plans**: 1 plan

Plans:
- [x] 27-01-PLAN.md — Create TestData.Activities module and add testMode guards in Main.elm for RefreshActivities, SaveComment, SavePost

### Phase 28: Dummy Results
**Goal**: Users can browse all results pages in test mode without a live backend
**Depends on**: Phase 26
**Requirements**: RES-01, RES-02, RES-03, RES-04
**Success Criteria** (what must be TRUE):
  1. The #stand page shows a dummy bettor rankings table in test mode
  2. The #uitslagen page shows dummy match results in test mode
  3. The #groepsstand page shows dummy group standings in test mode
  4. The #knock-out page shows a dummy knockout bracket in test mode
**Plans**: 1 plan

Plans:
- [ ] 28-01-PLAN.md — Create TestData.MatchResults and TestData.Ranking modules; add testMode guards for RefreshRanking, RefreshResults, RefreshKnockoutsResults in Main.elm

### Phase 29: Fill All Bet
**Goal**: Users can populate their entire bet instantly with one button tap on the Dashboard
**Depends on**: Phase 26
**Requirements**: BET-01
**Success Criteria** (what must be TRUE):
  1. A "fill all" button is visible on the Dashboard card only when test mode is active
  2. Tapping the button fills all 36 group match scores, the full WC2026 knockout bracket, and a topscorer selection in a single action
  3. After tapping, the Dashboard shows all sections as complete ([x]) and the form is submittable
**Plans**: 1 plan

Plans:
- [ ] 29-01-PLAN.md — Create TestData.Bet, add FillAllBet Msg, implement update branch (scores+bracket+topscorer), add Dashboard button behind testMode guard

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1–5 | v1.0 | Complete | Shipped | 2026-02-28 |
| 6–9 | v1.1 | Complete | Shipped | 2026-03-01 |
| 10–13 | v1.2 | Complete | Shipped | 2026-03-07 |
| 14–17 | v1.3 | Complete | Shipped | 2026-03-09 |
| 18–25 | v1.4 | Complete | Shipped | 2026-03-14 |
| 26. Mode Foundation | 1/1 | Complete    | 2026-03-14 | - |
| 27. Dummy Activities and Offline Submission | 1/1 | Complete    | 2026-03-14 | - |
| 28. Dummy Results | 1/1 | Complete    | 2026-03-14 | - |
| 29. Fill All Bet | v1.5 | 0/? | Not started | - |
