# Requirements: Tournaments — WC2026 Betting SPA

**Defined:** 2026-03-15
**Core Value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.

## v1.6 Requirements

Requirements for the Visual Consistency milestone. Each maps to roadmap phases.

### NAV — Navigation & Menu

- [x] **NAV-01**: Navigation header matches prototype typography — logo 12px, letter-spacing 0.1em, bg-dark (`#2b2b2b`), 44px height, 1px bottom border
- [x] **NAV-02**: Progress rail step labels use 8px font with letter-spacing 0.12em (prototype `.p-name` style)
- [x] **NAV-03**: Bottom nav bar matches prototype — 56px height, bg-dark, border-top, `< vorige` / `volgende >` at 12px

### CHROME — Card Headers & Form Chrome

- [x] **CHROME-01**: Section/card headers use 10px amber text with letter-spacing 0.18em and `---` flanking (prototype `.sec-head` pattern)
- [x] **CHROME-02**: Card intro/description text uses dash-intro style — 2px orange left border, 11px dim text, 1.75 line-height, subtle orange-tinted bg (`rgba(240,160,48,0.04)`)
- [x] **CHROME-03**: Round badge header in bracket matches prototype — bordered box, 11px active-color title, 10px dim subtitle

### BADGES — Team Badge Tiles

- [x] **BADGES-01**: Group match team display aligns with prototype layout — SVG flag at consistent size, team abbreviation at 11px, proper spacing
- [x] **BADGES-02**: Bracket team tile layout matches prototype — SVG flag + team name (11px 500 weight) + 3-letter code (9px dim) in bordered tile
- [x] **BADGES-03**: Topscorer player tile layout matches prototype — SVG flag + player name (12px) + team name (10px dim) in `.player-item` style

### ACTIVITIES — Blog Posts & Comments

- [x] **ACTIVITIES-01**: Comment entries display with dash-intro style: amber (`#f0dfaf`) 2px left border, dim text, subtle amber-tinted bg
- [x] **ACTIVITIES-02**: Blog post entries display with dash-intro style: green (`#7f9f7f`) 2px left border, dim text, subtle green-tinted bg — visually distinct from comments

### FOCUS — Input Auto-focus

- [x] **FOCUS-01**: Comment input on home/activities page receives cursor focus when user taps into the comment area
- [x] **FOCUS-02**: Participant page first field (name) receives cursor focus when the card becomes active
- [x] **FOCUS-03**: Blog post entry text area receives cursor focus when the user opens the blog post form

## Future Requirements

None identified for v1.7 at this time.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Switch to emoji flags | User prefers keeping SVG flag files; layout alignment is the goal |
| Results pages badge alignment | Focus is form pages only for this milestone |
| Full CSS-level animation/transitions | Elm/elm-ui constraints; hover transitions already in place |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| NAV-01 | Phase 30 | Complete |
| NAV-02 | Phase 30 | Complete |
| NAV-03 | Phase 30 | Complete |
| CHROME-01 | Phase 31 | Complete |
| CHROME-02 | Phase 31 | Complete |
| CHROME-03 | Phase 31 | Complete |
| BADGES-01 | Phase 32 | Complete |
| BADGES-02 | Phase 32 | Complete |
| BADGES-03 | Phase 32 | Complete |
| ACTIVITIES-01 | Phase 33 | Complete |
| ACTIVITIES-02 | Phase 33 | Complete |
| FOCUS-01 | Phase 34 | Complete |
| FOCUS-02 | Phase 34 | Complete |
| FOCUS-03 | Phase 34 | Complete |

**Coverage:**
- v1.6 requirements: 14 total
- Mapped to phases: 14
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-15*
*Last updated: 2026-03-15 after roadmap creation*
