# Requirements: Tournaments — WC2026 Betting SPA

**Defined:** 2026-02-28
**Core Value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.

## v1.1 Requirements

### Scroll Wheel

- [x] **SCRW-01**: The active match is always displayed at line 4 of 7 — empty padding lines above have the same height as match lines
- [x] **SCRW-02**: Lines 1–3 always contain exactly one group label — the label of the active group. It anchors at line 1 when it would otherwise scroll above the viewport
- [x] **SCRW-03**: The `-- END --` marker (after last match) never scrolls above line 4

### Install Prompts

- [x] **INST-01**: On iOS Safari, when the app is not installed (`navigator.standalone === false`), a dismissable banner appears at the bottom explaining how to add to Home Screen
- [x] **INST-02**: On Android Chrome, when the `BeforeInstallPrompt` event fires, a dismissable banner appears at the bottom; tapping it triggers the native install dialog
- [x] **INST-03**: Both banners match the terminal aesthetic (monospace, dark background, consistent with app style)
- [x] **INST-04**: Dismissed state persists so the banner doesn't reappear on every visit

### Form Polish

- [x] **FORM-01**: Mobile bet form navigation (vorige/volgende) is clear and works reliably on phone screens
- [x] **FORM-02**: Incomplete or invalid card state is visually obvious — user knows what still needs filling in
- [ ] **FORM-03**: Actions and transitions in the form feel acknowledged — no jarring jumps or silent failures on mobile

## Future Requirements

### Live Results

- **LIVE-01**: Match scores update during the tournament without a full page reload
- **LIVE-02**: Group standings update live as match scores come in
- **LIVE-03**: Knockout bracket updates reflect confirmed results

## Out of Scope

| Feature | Reason |
|---------|--------|
| Offline bet submission | Requires syncing strategy; network required to submit |
| Full offline results cache | Too complex; fast load via app shell is sufficient |
| Score input gesture controls | User prefers keyboard input |
| Swipe-between-cards navigation | Conflicts with scroll wheel swipe handler |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| SCRW-01 | Phase 6 | Complete |
| SCRW-02 | Phase 6 | Complete |
| SCRW-03 | Phase 6 | Complete |
| INST-01 | Phase 7 | Complete |
| INST-02 | Phase 7 | Complete |
| INST-03 | Phase 7 | Complete |
| INST-04 | Phase 7 | Complete |
| FORM-01 | Phase 8 | Complete |
| FORM-02 | Phase 8 | Complete |
| FORM-03 | Phase 8 | Pending |

**Coverage:**
- v1.1 requirements: 10 total
- Mapped to phases: 10
- Unmapped: 0 ✓

---
*Requirements defined: 2026-02-28*
*Last updated: 2026-03-01 after Phase 8 plan 01 completion (FORM-01, FORM-02 complete)*
