# Requirements: Tournaments — WC2026 Betting SPA

**Defined:** 2026-03-16
**Milestone:** v1.7 Bracket Wizard Redesign
**Core Value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.

## v1.7 Requirements

### Wizard Flow

- [x] **WIZ-01**: Wizard presents rounds bottom-up: Final 32 → Final 16 → Quarter Finals → Semi Finals → Finals → Champion
- [x] **WIZ-02**: Each round (R16 onwards) only offers teams selected in the previous round
- [x] **WIZ-03**: Deselecting a team in an earlier round immediately removes it from all later rounds
- [x] **WIZ-04**: Forward navigation ("Ga verder") is disabled until the required number of teams for the current round is selected

### R32 Display

- [x] **R32-01**: All 48 group-phase teams are grouped by group letter (12px amber header per group)
- [x] **R32-02**: Team badges show only the 3-letter country code (11px) in a fixed-width grid (text does not affect alignment)

### R16 Display

- [ ] **R16-01**: The 32 teams from the user's R32 selection are shown in a fixed-width grid
- [ ] **R16-02**: Team badges show only the 3-letter country code (11px)

### QF through Champion

- [x] **LATE-01**: Team badges show the full team name (11px, clipped at badge boundary) with country code (9px) below
- [x] **LATE-02**: Team badges use fixed-width grid cells

### Badge States

- [x] **BADGE-01**: Selected team badges display a green outline
- [x] **BADGE-02**: Teams that cannot be selected (round max reached) are dimmed

### Test Mode

- [ ] **TEST-01**: Fill-all button correctly populates all 6 wizard rounds in bottom-up order

## Future Requirements

(None identified — scope is focused and complete for v1.7)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Animated round transitions | elm-ui has no animation primitives; marginal UX gain for significant effort |
| Per-group selection count in R32 header ("A — 2/4 geselecteerd") | Low value for v1.7; can add later |
| Third-place candidate field separation in RoundSelections | Architectural cleanup; no user-visible benefit in v1.7 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| WIZ-01 | Phase 35 | Complete |
| WIZ-02 | Phase 35 | Complete |
| WIZ-03 | Phase 35 | Complete |
| WIZ-04 | Phase 35 | Complete |
| R32-01 | Phase 36 | Complete |
| R32-02 | Phase 36 | Complete |
| R16-01 | Phase 36 | Pending |
| R16-02 | Phase 36 | Pending |
| LATE-01 | Phase 36 | Complete |
| LATE-02 | Phase 36 | Complete |
| BADGE-01 | Phase 36 | Complete |
| BADGE-02 | Phase 36 | Complete |
| TEST-01 | Phase 37 | Pending |

**Coverage:**
- v1.7 requirements: 13 total
- Mapped to phases: 13
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-16*
*Last updated: 2026-03-16 after initial definition*
