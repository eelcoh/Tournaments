# Project Research Summary

**Project:** WK 2026 — Tournament Betting SPA (PWA + Mobile UX Milestone)
**Domain:** Progressive Web App integration + mobile layout improvements for Elm 0.19.1 SPA
**Researched:** 2026-02-23
**Confidence:** HIGH

## Executive Summary

This milestone adds PWA installability and fixes mobile UX to an existing, working Elm 0.19.1 SPA. The app already has the right architecture: a `UI.Screen.Device` discriminator (`Phone | Computer`), a `model.screen` value threaded through views, and elm-ui as the sole styling layer. The recommended approach is minimal and additive — two new static files (`sw.js` and `manifest.json`), two Makefile copy rules, self-hosted fonts, and isolated elm-ui attribute changes. No new Elm dependencies, no build pipeline changes, no new modules. Everything fits within the existing patterns.

The highest-impact work is grouping: PWA infrastructure (manifest, service worker, font self-hosting) must come first because the service worker's cache list cannot be finalised until the fonts are local. Touch target enlargements and keyboard suppression are independent of each other and of the PWA work, but they deliver the most immediate usability improvement on real devices. The bracket stepper overflow is the most layout-risky change and should be validated in browser DevTools at 320–375px before any phase is marked complete.

The dominant risk is iOS Safari behaviour: no automatic install prompt, 7-day cache eviction, and standalone mode losing navigation state on restart. None of these require code workarounds beyond an in-app iOS install tip — they are constraints to document and accept. The second risk is stale assets after deployment: the service worker cache must use a versioned cache name keyed to the build, and `sw.js` must be served with `Cache-Control: no-cache`. Both are straightforward to implement if planned upfront.

---

## Key Findings

### Recommended Stack

The existing stack handles everything needed. No new dependencies are required. Vanilla JS service worker (no Workbox) is the right choice given the project's plain Makefile build — Workbox's CDN `importScripts` approach has documented limitations in non-webpack environments. The two additions are plain JS and JSON files, not npm packages.

**Core technologies:**
- Vanilla JS service worker (`src/sw.js`) — app-shell caching — simplest approach for static Makefile build; zero external dependencies
- `manifest.json` — PWA installability metadata — one static JSON file; no Elm changes
- Self-hosted `Sometype Mono` font (`assets/fonts/`) — required so service worker can cache the font as part of the app shell; eliminates cross-origin cache complexity
- Existing `UI.Screen.Device` (`Phone | Computer`) — responsive layout branching — already present at the 500px breakpoint; no new module needed
- Existing elm-ui attribute system — touch target sizing — all changes are `Element.padding` and `Element.height` adjustments in existing functions

**Critical version notes:**
- iOS Safari service worker support is stable since iOS 16.4; iOS 11.3+ covers the basics. No polyfills needed.
- `inputmode="none"` / `inputmode="numeric"` are via `Element.htmlAttribute` — no elm-ui version change needed.

### Expected Features

**Must have (table stakes — P1):**
- `manifest.json` — required for PWA installability; one file, zero risk
- Service worker with app-shell caching — required for install prompt + fast re-open; only new JS in the project
- Score keyboard buttons enlarged to 44px height — highest-impact single change; `height (px 28)` to `height (px 44)` in `UI.Button.Score.scoreButton_`
- Group nav tap area padding — `A B* C ... L` letters have no explicit height; add `paddingXY 8 8` and `width (px 32)` in `Form.GroupMatches.viewGroupNav`
- Bracket team badge tap area padding — `viewTeamBadge` and `viewPlacedBadge` have bare text with `onClick`; add `paddingXY 8 8`
- System keyboard suppressed on score inputs — `inputmode="none"` via `Element.htmlAttribute`; eliminates double-keyboard confusion
- Nav link tap area padding — `UI.Button.navlink` needs `paddingXY 8 12`

**Should have (P2 — add after device testing):**
- Safe area insets for status bar — `env(safe-area-inset-bottom)` for iPhone home indicator; requires `viewport-fit=cover` meta update
- Bracket stepper compact layout on narrow screens — shorten ` --- ` connectors or use `>` separator at `Phone` device size
- PWA icon with terminal aesthetic — `>_` or `WC` in orange on dark background; 192px and 512px PNG
- Theme color in manifest + meta tag — `#0d0d0d` background and `#ff8c00` theme color
- iOS install tip banner — one-time dismissable in-app message detected via `navigator.standalone` flag

**Defer (v2+):**
- Virtual scrolling for activities feed — only relevant if 500+ items accumulate
- Form draft auto-save (localStorage / backend) — needs separate milestone; backend coordination required
- Offline form fill — explicitly out of scope per project decisions

### Architecture Approach

The architecture is additive. The service worker and manifest are pure static files that live in `src/` alongside `index.html` and are copied to `build/` by two new Makefile targets. All Elm-side changes are attribute-level modifications within existing view functions — no new modules, no `elm.json` changes, no new type definitions. The `model.screen` value is already available in `Form.View.viewCardChrome`; child views that need mobile variants receive it as an additional `Screen.Size` argument using the existing pattern.

**Major components:**
1. `src/sw.js` — Cache-first for static assets; network-only for `/api/` requests; versioned cache name for deployment cache busting
2. `src/manifest.json` — PWA metadata (name, icons, theme, display: standalone, start_url: "/")
3. `src/index.html` (modified) — Add `<link rel="manifest">`, `<meta name="theme-color">`, SW registration script, local `@font-face` for self-hosted Sometype Mono
4. `src/UI/Style.elm` (modified) — Parameterize button height to support 44px touch targets; mobile-aware helpers
5. `src/Form/GroupMatches.elm` (modified) — `inputmode="none"` on score inputs, larger touch targets, overflow audit at 320px
6. `src/Form/Bracket/View.elm` (modified) — Compact stepper connector format at `Phone` device size

**Files that do not change:**
- `src/Main.elm`, `src/Types.elm`, `src/Bets/` — screen tracking and domain logic are unaffected
- `src/UI/Screen.elm` — `Device` type and 500px breakpoint already correct
- `src/Results/` — results views are out of scope for this milestone

### Critical Pitfalls

1. **Stale `main.js` after deployment** — versioned cache name in `sw.js` (e.g. `app-shell-v2026-1`) with old-cache deletion in `activate`; `sw.js` served with `Cache-Control: no-cache`; use `skipWaiting()` + `clients.claim()`

2. **`sw.js` missing from build** — must add `cp src/sw.js $(BUILD)/sw.js` to Makefile `build` (and `debug`) targets; verify `build/sw.js` exists after `make build` before testing

3. **Google Fonts offline failure** — self-host Sometype Mono in `assets/fonts/`; remove Google Fonts `<link>` from `index.html`; add local `@font-face` in a `<style>` block; list font files in `sw.js` precache list

4. **iOS Safari: no install prompt and 7-day cache eviction** — add in-app "Add to Home Screen" tip on iOS (detected via `navigator.standalone` JS flag passed as Elm flag); document 7-day eviction as a known constraint; do not architect features assuming persistent cache

5. **`preventDefaultOn "touchend"` scope leak** — keep this attribute scoped to the scroll wheel column in `Form/GroupMatches.elm`; never promote it to a card wrapper or page wrapper; test activities feed scroll on real iOS device

6. **`inputmode` not surfaced by elm-ui `Input.text`** — apply via `Element.htmlAttribute (Html.Attributes.attribute "inputmode" "none")` on score inputs; use `type="text"` not `type="number"` (avoids iOS decimal pad and spinner issues)

7. **Bracket stepper overflow on 320–375px** — test in DevTools at 320px; use compact connector format (`>`) at `Phone` device size via `UI.Screen.device model.screen` branch

---

## Implications for Roadmap

Based on combined research, three phases are suggested. The dependency chain is strict: PWA infrastructure must precede mobile layout work (fonts must be local before cache list is locked), and layout changes should be validated on real devices before the phase closes.

### Phase 1: PWA Infrastructure

**Rationale:** Service worker cache list cannot be finalised until fonts are self-hosted. manifest.json and SW registration are prerequisite for installability. Everything else in later phases is independent of the network layer. This phase has no Elm code changes — it is pure JS, JSON, and Makefile.

**Delivers:** Installable PWA with app-shell caching; fast re-open on mobile; offline-resilient font rendering

**Addresses:**
- manifest.json (P1 table stake)
- Service worker + app-shell caching (P1 table stake)
- Font self-hosting (prerequisite for correct caching)
- `start_url: "/"` and manifest `<head>` position (Pitfall 11)
- iOS install tip banner (Pitfall 3)

**Avoids:**
- Stale `main.js` after deployment (Pitfall 1) — versioned cache name
- `sw.js` missing from build (Pitfall 2) — Makefile target
- Google Fonts offline failure (Pitfall 8) — self-hosted fonts
- Manifest `start_url` fragment issue (Pitfall 11)

**Research flag:** Standard patterns — well-documented PWA setup; no additional research needed.

---

### Phase 2: Mobile Touch Targets and Score Input UX

**Rationale:** These are pure elm-ui attribute changes in isolated view functions. They are the highest-impact usability improvements per unit of effort. Each change is independent and can be implemented and tested separately. `model.screen` is already available in all relevant view functions.

**Delivers:** All interactive elements meet 44px touch target minimum; score entry no longer shows conflicting system keyboard; number pad appears on score inputs on iOS

**Addresses:**
- Score buttons enlarged to 44px (P1)
- Group nav tap area padding (P1)
- Bracket team badge tap area padding (P1)
- System keyboard suppressed on score inputs (`inputmode="none"`) (P1)
- Nav link tap area padding (P1)
- Safe area insets for status bar (P2)
- Monospace overflow on 320px screens (Pitfall 7)

**Avoids:**
- `inputmode` not surfaced by elm-ui (Pitfall 6) — `Element.htmlAttribute` workaround
- iOS navigation history lost on restart (Pitfall 5) — accept as known constraint; note in code
- `preventDefaultOn` scope leak (Pitfall 9) — audit and comment during this phase

**Research flag:** Standard patterns — elm-ui attribute changes are fully understood; no additional research needed. However, real-device testing on iOS and Android is required to verify 44px targets work in practice.

---

### Phase 3: Bracket Wizard Layout and PWA Polish

**Rationale:** Bracket stepper overflow is isolated to `Form/Bracket/View.elm` and requires the most careful layout work (testing at multiple widths). PWA polish items (icon, theme color, compact stepper) are low-risk cosmetic changes that should come after core UX is validated.

**Delivers:** Bracket wizard usable on 320–375px phones without overflow; app icon with terminal aesthetic; installed PWA looks native in iOS/Android task switcher

**Addresses:**
- Bracket stepper compact layout on narrow screens (P2)
- PWA icon with terminal aesthetic (P2)
- Theme color in manifest + meta tag (P2)

**Avoids:**
- Bracket stepper overflow on 320–375px (Pitfall 10) — compact connector format at `Phone` device size

**Research flag:** Standard patterns — bracket layout changes use existing `UI.Screen.device` branching pattern. Icon creation is a design task, not a code task. No additional research needed.

---

### Phase Ordering Rationale

- **Phase 1 must precede Phase 2 and 3** because font self-hosting must be complete before the service worker cache list is locked. If fonts are still on Google CDN when the SW is deployed, the cache will miss them and the terminal aesthetic breaks offline.
- **Phase 2 before Phase 3** because Phase 2 changes (touch targets, keyboard suppression) affect the forms that Phase 3's bracket wizard also lives in. Completing Phase 2 first provides a stable, tested foundation.
- **Phase 3 is independently deferrable** — PWA polish items do not block core usability. If the tournament start date is imminent, Phase 3 can be deferred entirely without degrading the user experience.

### Research Flags

Phases with standard patterns (skip additional research-phase):
- **Phase 1:** PWA setup is exhaustively documented; patterns are proven; pitfalls are specific and already catalogued in PITFALLS.md
- **Phase 2:** elm-ui attribute changes are first-party patterns; `inputmode` via `htmlAttribute` is confirmed in MDN and CSS-Tricks
- **Phase 3:** `UI.Screen.device` branching pattern already used in codebase; no unknowns

No phases require deeper research. The PITFALLS.md already contains recovery strategies for every identified risk.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Vanilla SW + manifest is the standard approach for static Elm apps; no Workbox dependency to manage; pattern confirmed by web.dev and MDN |
| Features | HIGH | Based on direct codebase analysis (pixel measurements of existing buttons, confirmed missing manifest/SW) plus iOS HIG and Material Design spec references |
| Architecture | HIGH | Additive changes only; existing `UI.Screen` and elm-ui attribute patterns are confirmed working in production; no new architecture decisions required |
| Pitfalls | HIGH | iOS Safari pitfalls documented from multiple independent sources (brainhub, vinova, magicbell, web.dev); codebase-specific risks confirmed by source analysis |

**Overall confidence:** HIGH

### Gaps to Address

- **Real-device testing:** Browser DevTools emulation is not a substitute for testing on a real iPhone (especially iOS standalone mode, storage eviction, and `preventDefaultOn` behaviour). Real-device testing should gate Phase 2 and Phase 3 completion.
- **`sw.js` cache version strategy:** The version constant approach is confirmed but the specific trigger (git commit hash vs. manual version bump vs. build timestamp) is a team convention decision, not a research question.
- **iOS install tip implementation:** The in-app tip requires `navigator.standalone` to be passed as an Elm flag. The flag plumbing (`index.html` → Elm `flags` → `Main.init`) needs a small implementation decision but no research.
- **Icon design:** The 192px and 512px PNG creation is a design task. The research confirms requirements (non-transparent, square, maskable variant recommended) but the actual image creation is out of research scope.

---

## Sources

### Primary (HIGH confidence)
- MDN Web Docs: Service Worker API, Cache API, `inputmode` attribute
- web.dev: PWA installability checklist, service worker lifecycle, app manifest
- Apple Human Interface Guidelines: minimum touch target 44pt
- Material Design 3: minimum touch target 48dp
- Codebase analysis: `src/index.html`, `src/UI/Screen.elm`, `src/UI/Style.elm`, `src/UI/Button.elm`, `src/Form/GroupMatches.elm`, `src/Form/Bracket/View.elm`, `Makefile`

### Secondary (MEDIUM confidence)
- CSS-Tricks: `inputmode` finger-friendly numeric inputs
- Taming PWA Cache Behavior — Infinity Interactive
- The Service Worker Lifecycle — web.dev
- Service Worker Update Strategies — web.dev
- Rich Harris / Stuff I Wish I'd Known About Service Workers (GitHub Gist)

### Tertiary (MEDIUM-LOW confidence for iOS specifics)
- iOS Safari PWA Limitations — Vinova SG
- PWA on iOS 2025 — Brainhub
- PWA iOS Limitations and Safari Support — MagicBell
- iOS Safari history lost in standalone — remix-run/history #645

---
*Research completed: 2026-02-23*
*Ready for roadmap: yes*
