# Requirements: Tournaments WC2026

**Defined:** 2026-03-14
**Core Value:** Players can comfortably fill in all their tournament predictions on their phone in a single session.

## v1.5 Requirements

Requirements for v1.5 Test/Demo Mode. Each maps to roadmap phases.

### Mode Activation & Infrastructure

- [x] **MODE-01**: User can enter test mode by navigating to the `#test` URL route
- [x] **MODE-02**: User can enter test mode by tapping the app title 5 times on mobile/PWA
- [x] **MODE-03**: User sees a persistent TEST MODE badge while test mode is active
- [x] **MODE-04**: All navigation items are visible in test mode regardless of tournament state

### Activities

- [ ] **ACT-01**: User sees dummy lorem ipsum comments and blog posts on the activities page in test mode
- [ ] **ACT-02**: User can add a comment in test mode; it appends to the list locally without a network call
- [ ] **ACT-03**: User can add a blog post in test mode; it appends to the list locally without a network call

### Bet Fill

- [ ] **BET-01**: User can fill the entire bet (all 36 group match scores, full knockout bracket, topscorer) with one button tap on the Dashboard card in test mode

### Results

- [ ] **RES-01**: User sees dummy bettors rankings on the #stand page in test mode
- [ ] **RES-02**: User sees dummy match results on the #uitslagen page in test mode
- [ ] **RES-03**: User sees dummy group standings on the #groepsstand page in test mode
- [ ] **RES-04**: User sees dummy knockout bracket results on the #knock-out page in test mode

## Future Requirements

### Test Mode Enhancements

- **TEST-01**: Test mode persists across page reloads (localStorage flag)
- **TEST-02**: Test mode can be exited via a button in the badge/banner
- **TEST-03**: Submit bet in test mode returns a fake success response

## Out of Scope

| Feature | Reason |
|---------|--------|
| localStorage persistence of test mode | Session-only keeps it simple and avoids accidental production test mode |
| Randomized dummy data | Static data is predictable and easier to debug |
| Network interception / service worker mocking | Overkill; conditional branches in update are sufficient |
| React to test mode in E2E / automated tests | No test suite exists; out of scope |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| MODE-01 | Phase 26 | Complete |
| MODE-02 | Phase 26 | Complete |
| MODE-03 | Phase 26 | Complete |
| MODE-04 | Phase 26 | Complete |
| ACT-01 | Phase 27 | Pending |
| ACT-02 | Phase 27 | Pending |
| ACT-03 | Phase 27 | Pending |
| BET-01 | Phase 29 | Pending |
| RES-01 | Phase 28 | Pending |
| RES-02 | Phase 28 | Pending |
| RES-03 | Phase 28 | Pending |
| RES-04 | Phase 28 | Pending |

**Coverage:**
- v1.5 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-14*
*Last updated: 2026-03-14 after initial definition*
