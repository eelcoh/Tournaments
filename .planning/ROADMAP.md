# Roadmap: Tournaments (WC2026 Betting SPA)

## Milestones

- ✅ **v1.0 Mobile UX** — Phases 1-5 (shipped 2026-02-28)
- 🚧 **v1.1 UX Polish** — Phases 6-8 (in progress)

## Phases

<details>
<summary>✅ v1.0 Mobile UX (Phases 1–5) — SHIPPED 2026-02-28</summary>

- [x] Phase 1: PWA Infrastructure (2/2 plans) — completed 2026-02-24
- [x] Phase 2: Touch Targets and Score Input (4/4 plans) — completed 2026-02-25
- [x] Phase 3: Bracket Wizard Mobile Layout (2/2 plans) — completed 2026-02-26
- [x] Phase 4: UI Consistency (4/4 plans) — completed 2026-02-28
- [x] Phase 5: Bug Fixes and UX Polish (4/4 plans) — completed 2026-02-28

Full details: `.planning/milestones/v1.0-ROADMAP.md`

</details>

### 🚧 v1.1 UX Polish (In Progress)

**Milestone Goal:** Fix scroll wheel stability, add platform install prompt banners, and polish the bet form mobile UX so the app feels solid on phone.

- [x] **Phase 6: Scroll Wheel Stability** — Active match fixed at line 4; consistent line heights; group label always visible; END marker stays put
- [ ] **Phase 7: Install Prompt Banners** — iOS tip banner + Android BeforeInstallPrompt banner, terminal aesthetic, dismissable with persistence
- [ ] **Phase 8: Form Mobile Polish** — Navigation, feedback, and transition UX pass on the bet form for phone screens

## Phase Details

### Phase 6: Scroll Wheel Stability
**Goal**: The group matches scroll wheel displays reliably — active match anchored, group context always visible, and boundary markers behave predictably
**Depends on**: Nothing (independent of phases 7 and 8)
**Requirements**: SCRW-01, SCRW-02, SCRW-03
**Success Criteria** (what must be TRUE):
  1. The active match is always displayed at exactly line 4 of the 7-line window, with empty padding lines above it having the same pixel height as match lines
  2. Lines 1–3 always show the group label for the active match's group — the label anchors at line 1 when it would otherwise scroll above the viewport
  3. The `-- END --` marker never appears above line 4 (it stays below the active line, not above it)
  4. Scrolling through all 48 matches in sequence shows no height jumps or layout shifts at any position
**Plans**: 1 plan

Plans:
- [x] 06-01-PLAN.md — Rewrite scroll wheel windowing algorithm (7-line window, group label anchoring, END marker, padding lines)

### Phase 7: Install Prompt Banners
**Goal**: Players who haven't installed the app are nudged to add it to their home screen via platform-appropriate, dismissable banners that match the terminal aesthetic
**Depends on**: Nothing (independent of phases 6 and 8)
**Requirements**: INST-01, INST-02, INST-03, INST-04
**Success Criteria** (what must be TRUE):
  1. On iOS Safari (navigator.standalone === false), a banner appears at the bottom of the screen explaining how to add to Home Screen
  2. On Android Chrome, when BeforeInstallPrompt fires, a banner appears at the bottom; tapping it triggers the native install dialog
  3. Both banners use monospace font, dark background, and terminal formatting consistent with the rest of the app
  4. After dismissing a banner, it does not reappear on subsequent visits or page reloads
  5. On a device where the app is already installed (standalone mode), no banner appears
**Plans**: TBD

### Phase 8: Form Mobile Polish
**Goal**: The bet form feels smooth and clear to fill in on a phone — navigation works reliably, incomplete state is obvious, and actions feel acknowledged
**Depends on**: Nothing (independent of phases 6 and 7)
**Requirements**: FORM-01, FORM-02, FORM-03
**Success Criteria** (what must be TRUE):
  1. The vorige/volgende navigation buttons are clearly visible and reliably tappable on a 375px phone screen without accidental mis-taps
  2. A user who opens an incomplete card can immediately see what is still missing without needing to attempt submission
  3. Tapping a form action (submit, navigate, confirm) produces visible feedback — no silent no-ops or jarring layout jumps
**Plans**: TBD

## Progress

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. PWA Infrastructure | v1.0 | 2/2 | Complete | 2026-02-24 |
| 2. Touch Targets and Score Input | v1.0 | 4/4 | Complete | 2026-02-25 |
| 3. Bracket Wizard Mobile Layout | v1.0 | 2/2 | Complete | 2026-02-26 |
| 4. UI Consistency | v1.0 | 4/4 | Complete | 2026-02-28 |
| 5. Bug Fixes and UX Polish | v1.0 | 4/4 | Complete | 2026-02-28 |
| 6. Scroll Wheel Stability | v1.1 | 1/1 | Complete | 2026-02-28 |
| 7. Install Prompt Banners | v1.1 | 0/? | Not started | - |
| 8. Form Mobile Polish | v1.1 | 0/? | Not started | - |
