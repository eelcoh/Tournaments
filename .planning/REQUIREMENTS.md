# Requirements: Tournaments v1.4 — Visual Design Adoption

**Defined:** 2026-03-09
**Core Value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.

## v1.4 Requirements

### Font

- [x] **FONT-01**: App uses Martian Mono as primary typeface (self-hosted, weights 300/400/500; replaces Sometype Mono)

### Form Cards

- [x] **FORM-01**: Score input boxes have dark background (`#252525`), orange text, visible border, and focus state — matches prototype `.s-inp`
- [x] **FORM-02**: Group match scroll wheel rows display SVG team flags + team names in a consistent prototype-style row layout (boxed, correct font sizing)
- [x] **FORM-03**: Bracket team tiles are bordered cards (`#353535` bg, `#4a4a4a` border) with selected (orange border + tinted bg) and hover states
- [x] **FORM-04**: Bracket round header shows round title, description, and `N/M geselecteerd` counter
- [x] **FORM-05**: Topscorer player items are bordered cards (flag, name, team code, `[x]` on selected)
- [x] **FORM-06**: Topscorer search bar has a bordered container with `>` prompt and orange focus border
- [x] **FORM-07**: Participant field rows have bordered containers with uppercase label, `>` prompt, and orange focus border
- [x] **FORM-08**: Submit card has a summary box showing each section with green checkmark or red dash per section

### Navigation & Chrome

- [x] **NAV-01**: Form header shows a horizontal progress rail — one segment per form step, active step in orange, completed in green, pending dimmed
- [x] **NAV-02**: Bottom nav prev/next buttons are styled text buttons with hover states and disabled (opacity) at form boundaries
- [x] **NAV-03**: Bottom nav center shows current step label with amber `[N]` incomplete count when applicable

### Results Pages

- [ ] **RESULTS-01**: Results pages use `#353535` card backgrounds with `#4a4a4a` borders — consistent with form card aesthetic
- [ ] **RESULTS-02**: Match result rows use prototype color coding: amber for scores, cream for team names, dimmed for metadata
- [ ] **RESULTS-03**: Group standings rows use semantic color coding: green for qualified (top 2), amber for third place, cream for eliminated

### Activities Feed

- [x] **ACT-01**: Activity entries (comments and posts) use bordered card treatment (`#353535` bg, `#4a4a4a` border) rather than plain log lines
- [x] **ACT-02**: Activity timestamps and author labels match prototype typography (dimmed, small, letter-spaced)

### Global

- [x] **GLOBAL-01**: CRT scanline texture applied globally via `index.html` `<style>` — repeating horizontal lines at 4px intervals, ~3.5% opacity overlay

## Future Requirements

### Live Data

- **LIVE-01**: Live results data integration — match scores and group standings updating during tournament

## Out of Scope

| Feature | Reason |
|---------|--------|
| Emoji flags | User prefers SVG badge images; emoji rendering inconsistent across devices |
| Group tab UI (A–L tabs) | User prefers scroll wheel; only styling adopted, not UX |
| Score input gesture controls | Deferred in v1.1; keyboard + styled inputs sufficient |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| FONT-01 | Phase 18 | Complete |
| GLOBAL-01 | Phase 18 | Complete |
| NAV-01 | Phase 18 | Complete |
| NAV-02 | Phase 18 | Complete |
| NAV-03 | Phase 18 | Complete |
| FORM-01 | Phase 19 | Complete |
| FORM-02 | Phase 19 | Complete |
| FORM-03 | Phase 19 | Complete |
| FORM-04 | Phase 19 | Complete |
| FORM-05 | Phase 20 | Complete |
| FORM-06 | Phase 20 | Complete |
| FORM-07 | Phase 21 | Complete |
| FORM-08 | Phase 21 | Complete |
| RESULTS-01 | Phase 24 | Pending |
| RESULTS-02 | Phase 24 | Pending |
| RESULTS-03 | Phase 25 | Pending |
| ACT-01 | Phase 23 | Complete |
| ACT-02 | Phase 23 | Complete |

**Coverage:**
- v1.4 requirements: 18 total
- Mapped to phases: 18
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-09*
*Last updated: 2026-03-11 — gap closure phases 24-25 added from v1.4 audit*
