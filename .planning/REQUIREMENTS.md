# Requirements: Tournaments — WC2026 Betting SPA

**Defined:** 2026-03-07
**Core Value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.

## v1.2 Requirements

### Colors

- [x] **COL-01**: App uses a Zenburn-inspired warm background (~`#3f3f3f`) across all pages
- [x] **COL-02**: App uses Zenburn muted text (~`#dcdccc`) as the primary text color
- [x] **COL-03**: Active/highlight states use Zenburn amber (~`#f0dfaf`) instead of orange
- [x] **COL-04**: Color changes applied consistently to nav, form, results, activities, and all other pages

### Navigation

- [x] **NAV-01**: Main app nav has proper terminal aesthetic (consistent with the app's ASCII/monospace style)
- [x] **NAV-02**: Main nav labels are horizontally and vertically centered using `allCenteredText` from `UI/Text.elm`
- [x] **NAV-03**: Form card bottom nav bar (vorige/volgende) labels are properly centered and aligned

### Page Width

- [x] **WIDTH-01**: `UI.Screen.maxWidth` returns a fixed 600px constant (replaces 80% formula) so all inner content shares the same cap
- [x] **WIDTH-02**: The outer page column in `View.elm` (nav + content + footer) is constrained to 600px and centered, matching inner content width

## Future Requirements

### Live Data

- **LIVE-01**: Match scores update during the tournament
- **LIVE-02**: Group standings update based on live match results
- **LIVE-03**: Knockout bracket reflects live results

## Out of Scope

| Feature | Reason |
|---------|--------|
| Offline bet submission | Requires syncing strategy; network required to submit |
| Native app | Elm SPA + PWA is sufficient |
| Score input gestures | User prefers keyboard; layout already improved in v1.1 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| COL-01 | Phase 10 | Complete |
| COL-02 | Phase 10 | Complete |
| COL-03 | Phase 10 | Complete |
| COL-04 | Phase 10 | Complete |
| NAV-01 | Phase 11 | Complete |
| NAV-02 | Phase 11 | Complete |
| NAV-03 | Phase 11 | Complete |
| WIDTH-01 | Phase 12 | Planned |
| WIDTH-02 | Phase 12 | Planned |

**Coverage:**
- v1.2 requirements: 9 total
- Mapped to phases: 9
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-07*
*Last updated: 2026-03-07 after phase 12 planning*
