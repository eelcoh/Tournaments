# Requirements: Mobile UX Milestone

**Status:** Active
**Source:** Questioning + Research (2026-02-23)

---

## PWA Infrastructure

| ID | Requirement | Priority | Complexity |
|----|-------------|----------|------------|
| PWA-01 | Sometype Mono font self-hosted in `assets/fonts/` and served from `index.html` with local `@font-face` or `<link>` — eliminates cross-origin font dependency that blocks app-shell caching | Must Have | Low |
| PWA-02 | `src/manifest.json` with: `name`, `short_name`, `start_url: "/"`, `display: "standalone"`, `background_color: "#1a1a1a"`, `theme_color: "#ff8c00"`, icons array (192px any, 512px any, 512px maskable) | Must Have | Low |
| PWA-03 | PNG icons at `assets/icon-192.png` (192×192), `assets/icon-512.png` (512×512, purpose "any"), `assets/icon-512-maskable.png` (512×512, purpose "maskable" with safe-zone design) | Must Have | Low |
| PWA-04 | `src/sw.js` vanilla service worker: cache-first strategy for app-shell assets (index.html, main.js, fonts), network-only pass-through for `/api/` requests, versioned `CACHE_NAME`, old cache cleanup on activate | Must Have | Medium |
| PWA-05 | `src/index.html` updated: `<link rel="manifest">`, `<meta name="theme-color">`, `<meta name="apple-mobile-web-app-capable" content="yes">`, `<meta name="apple-mobile-web-app-status-bar-style">`, SW registration script | Must Have | Low |
| PWA-06 | Makefile `build` target copies `src/manifest.json` and `src/sw.js` to `build/` | Must Have | Low |

**Success criteria:** Chrome on Android shows "Add to Home Screen" prompt; iOS Safari shows app icon and name in "Add to Home Screen" sheet; app opens full-screen without browser chrome after install.

---

## Mobile Touch Targets

| ID | Requirement | Priority | Complexity |
|----|-------------|----------|------------|
| MOB-01 | All interactive elements have a minimum touch target of 44×44px — apply `Element.minimum 44 Element.height` and padding where needed | Must Have | Low |
| MOB-02 | Group nav letters (A–L) in `Form/GroupMatches.elm viewGroupNav` have ≥44px height with horizontal padding ≥8px | Must Have | Low |
| MOB-03 | Navigation buttons ("< vorige", "volgende >", "< groep", "groep >") have ≥44px height | Must Have | Low |
| MOB-04 | Score keyboard buttons in `UI/Button/Score.elm` (the 0–9 grid buttons) have ≥44px height | Must Have | Low |
| MOB-05 | Bracket team badges in `Form/Bracket/View.elm` have a minimum 44×44px tappable area (wrap in `el [width (minimum 44 fill), height (minimum 44 fill)]` if needed) | Must Have | Low |
| MOB-06 | Top checkboxes bar (`viewTopCheckboxes`) has 44px minimum height per step indicator | Should Have | Low |

**Success criteria:** No interactive element smaller than 44×44px on a 375px-wide screen; all taps register on the intended target without requiring precision.

---

## Score Input UX

| ID | Requirement | Priority | Complexity |
|----|-------------|----------|------------|
| SCR-01 | Score input fields in `Form/GroupMatches.elm` include `Html.Attributes.attribute "inputmode" "numeric"` via `Element.htmlAttribute` — shows numeric keyboard on mobile | Must Have | Low |
| SCR-02 | Score input fields have a minimum width of 60px on mobile (currently `px 45`) to be comfortably tappable | Must Have | Low |
| SCR-03 | Group match scroll wheel rows do not overflow horizontally at 320px viewport width (iPhone SE) — reduce padding or font size conditionally for `Phone` device type | Must Have | Medium |

**Success criteria:** Tapping a score field on iOS/Android shows the number keypad, not the QWERTY keyboard; match rows are fully visible on a 320px-wide screen.

---

## Bracket Wizard Mobile Layout

| ID | Requirement | Priority | Complexity |
|----|-------------|----------|------------|
| BRK-01 | Bracket step indicator (ASCII pipeline stepper) does not overflow horizontally at 375px — use compact format (abbreviations or vertical layout) on `Phone` device type | Must Have | Medium |
| BRK-02 | Team selection grid in `Form/Bracket/View.elm` uses ≤4 columns on `Phone` device type (instead of the wider desktop layout) so teams are large enough to tap | Must Have | Low |
| BRK-03 | Round header text and instructions in the bracket wizard are readable (≥14px effective) on 375px-wide screens | Should Have | Low |

**Success criteria:** Bracket wizard is usable on a 375px-wide phone with no horizontal scroll; all team names/codes are tappable without zooming.

---

## Out of Scope

- Offline bet submission (requires sync strategy — out of scope)
- Full offline results cache (data still requires network)
- Push notifications or background sync
- Score +/− increment buttons (user prefers keyboard input)
- Swipe-between-cards navigation (conflicts with scroll wheel swipe handler)
- Pinch-to-zoom on bracket
- Progressive enhancement for very old iOS (<16.4 service worker support)

---

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| PWA-01 | Phase 1 | Complete |
| PWA-02 | Phase 1 | Complete |
| PWA-03 | Phase 1 | Complete |
| PWA-04 | Phase 1 | Pending |
| PWA-05 | Phase 1 | Pending |
| PWA-06 | Phase 1 | Pending |
| MOB-01 | Phase 2 | Pending |
| MOB-02 | Phase 2 | Pending |
| MOB-03 | Phase 2 | Pending |
| MOB-04 | Phase 2 | Pending |
| MOB-05 | Phase 2 | Pending |
| MOB-06 | Phase 2 | Pending |
| SCR-01 | Phase 2 | Pending |
| SCR-02 | Phase 2 | Pending |
| SCR-03 | Phase 2 | Pending |
| BRK-01 | Phase 3 | Pending |
| BRK-02 | Phase 3 | Pending |
| BRK-03 | Phase 3 | Pending |

---

*Last updated: 2026-02-23*
