# Tournaments — WC2026 Betting SPA

## What This Is

A football tournament betting SPA (World Cup 2026) where players predict group match scores, knockout bracket results, and the top scorer. Built with Elm 0.19.1 and elm-ui; deployed as a static site with PWA installability. Players fill in bets on their phone before the tournament starts and track results live.

## Core Value

Players can comfortably fill in all their tournament predictions on their phone in a single session.

## Requirements

### Validated

- ✓ Card-based bet form (IntroCard → GroupMatchesCard → BracketCard → TopscorerCard → ParticipantCard → SubmitCard) — existing
- ✓ Group matches scroll wheel — single card with 48 matches, scroll up/down, group boundary markers — existing
- ✓ Bracket wizard — round-by-round top-down selection (champion → finalists → semis → quarters → R16 → R32) — existing
- ✓ Completeness tracking — form cards show [x]/[.]/[ ] state, bracket completeness check — existing
- ✓ Results & standings view — rankings, match scores, knockout display — existing
- ✓ Activities feed — comments and blog posts with terminal log-line format — existing
- ✓ Authentication — bearer token login — existing
- ✓ Terminal ASCII aesthetic — `--- TITLE ---` headers, `>` prompts, monospace font — existing
- ✓ Responsive screen width detection — viewport width/height passed as flags — existing
- ✓ PWA installability — manifest.json + service worker so players can add to home screen — v1.0
- ✓ App-shell caching — service worker caches static assets for instant subsequent loads — v1.0
- ✓ Mobile touch targets — 44px minimum on all interactive elements (nav, score buttons, bracket badges) — v1.0
- ✓ Mobile score input UX — inputmode=numeric shows number keypad; 60px input width; 296px content at 320px — v1.0
- ✓ Mobile bracket wizard UX — compact stepper (Phone), 4-column team grid; no overflow at 375px — v1.0
- ✓ Mobile navigation UX — responsive 8px padding on Phone; all nav elements 44px tall — v1.0
- ✓ UI consistency — UI.Page.container + UI.Button.dataRow + terminal inputs across all pages; all Results pages width-constrained — v1.0
- ✓ Install prompt banner — iOS Safari "Add to Home Screen" tip + Android Chrome BeforeInstallPrompt banner, dismissable, terminal aesthetic — v1.1
- ✓ Group matches scroll wheel stability — active match fixed at line 4; empty lines consistent height; group label always visible in lines 1–3; -- END -- stays below active line — v1.1
- ✓ Form flow mobile polish — fixed bottom nav bar, per-card incomplete count, scroll-to-top, tap feedback on submit and nav — v1.1
- ✓ Keyboard-primary score input — flag header always visible, keyboard as default, "andere score" overlay for text inputs, no text-selection jank on tap — v1.1
- ✓ Zenburn-inspired color scheme — warm low-contrast palette (#3f3f3f bg, #dcdccc cream text, #f0dfaf amber) applied app-wide; amber replaces orange for active/highlight states — v1.2
- ✓ Terminal nav aesthetic — navlinks plain monospace text (no box/border); active state uses saturated Color.activeNav (#F0A030); inactive links use soft amber hover — v1.2
- ✓ Form card nav centering — fillPortion 1/2/1 layout + allCenteredText gives vorige/volgende truly centered tap zones — v1.2
- ✓ Consistent 600px page width — UI.Screen.maxWidth returns fixed 600; outer page column capped so nav/content/footer all left-align on desktop — v1.2
- ✓ Terminal loading states — activities loading copy `[ ophalen... ]`; empty state silenced; comment/author input labels hidden (> prompt as visual label) — v1.2
- ✓ Distinct team placeholders — `?` SVG for unknown teamIDs, `···` SVG for TBD bracket slots — v1.2

- ✓ Dashboard home — DashboardCard at form index 0 with [x]/[.]/[ ] per section, progress counts, tap-to-jump; all-done banner — v1.3
- ✓ Group matches reduction — 36 matches (1 per matchday × 3 × 12 groups); scroll wheel and keyboard preserved; group completion at 3/3 — v1.3
- ✓ Bracket minimap — horizontal dot rail (R32 R16 KF HF F ★) above wizard; green/amber/dim dot states; all dots tappable via JumpToRound — v1.3
- ✓ Topscorer search — live prefix filter on player name and 3-letter country code; clears on selection; empty-state message — v1.3

### Active (v1.4)

- [ ] Live results data integration — match scores and group standings updating during tournament

### Out of Scope

- Offline bet submission — requires syncing strategy; keep it simple: network required to submit
- Full offline results cache — too complex for now; fast load covers the main pain
- Native app / React Native — Elm SPA served as PWA is sufficient
- Score input gesture controls (+/- buttons, swipe) — user prefers keyboard input with better layout
- Swipe-between-cards navigation — conflicts with scroll wheel swipe handler

## Context

- **Current state:** v1.3 shipped — form flow redesign complete: dashboard home, 36-match group stage, bracket minimap, topscorer search. ~20,196 LOC Elm.
- **Tech stack:** Elm 0.19.1, elm-ui, vanilla JS service worker, static hosting
- Players fill in bets before the tournament starts; they mostly use phones
- The app is statically hosted — no server-side rendering, just `build/` files served
- Service worker must live outside Elm (JS file registered in `src/index.html`)
- Any new static assets must be manually added to APP_SHELL in `src/sw.js`
- iOS Safari: 7-day cache eviction is a known constraint; do not architect features assuming persistent cache

## Constraints

- **Tech stack**: Elm 0.19.1 — no new JS frameworks; service worker is the only new JS
- **Styling**: elm-ui only — no CSS files; all layout via `Element.*` attributes
- **Service worker**: must be a plain JS file at build root; registered in `index.html`
- **No offline sync**: app shell + static assets cached; API calls still require network
- **No debug.log**: production builds use `--optimize` which rejects Debug calls

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| PWA over native app | Elm SPA + service worker is zero-overhead installability | ✓ Good — works on both Android and iOS |
| App-shell caching only (no offline data) | Avoids sync complexity; fast load solves the main pain | ✓ Good — simple and correct |
| Keep keyboard score input, improve layout | User prefers typing; focus on spacing/touch-target size | ✓ Good — inputmode=numeric + 60px width works |
| No skipWaiting() in SW | Cache version bump is correct update mechanism | ✓ Good — avoids disrupting active tabs |
| inputmode=numeric (not type=number) | Avoids iOS/Android leading-zero stripping bugs | ✓ Good |
| Invisible-wrapper tap zones | Terminal aesthetic (small text) stays intact; only hit area grows to 44px | ✓ Good |
| viewingRound in WizardState | Keeps navigation state co-located with wizard selections | ✓ Good |
| UI.Page.container spacing 24 | Distinct rhythm from Form pages (spacing 20 via viewCardChrome) | ✓ Good — no migration needed |
| Form CON-01 via viewCardChrome | fill \|> maximum Screen.maxWidth already enforced at card chrome level | ✓ Good — no migration needed |
| Fixed-length windowing (buildWindow) | Flat sequence + cursor index + N above/below + WLPadding = guaranteed 7-line output | ✓ Good — eliminates all height jumps |
| WLPadding at 44px | Matches match-row height exactly — no layout shift at scroll edges | ✓ Good |
| Group label anchoring at line 1 only | Replace above[0] with WLGroupLabel; never touch above[1]/above[2] | ✓ Good — simple and correct |
| deferredPrompt in \<head\> pre-main.js | Captures BeforeInstallPrompt before Elm app loads; forwarded via port post-init | ✓ Good — avoids race condition |
| isIOS/isStandalone as flags, BeforeInstallPrompt as port | Flags = sync; port = async; matches when data is available | ✓ Good |
| Single inFront column for banner+statusbar | Avoids z-index stacking complexity | ✓ Good |
| ScrollToTop as discard Task target | Browser.Dom.setViewport always succeeds in practice; no error handling needed | ✓ Good |
| Greyed (not hidden) disabled nav buttons | Avoids layout shift when transitioning between cards | ✓ Good |
| mouseOver as tap-flash mechanism | Zero new state/Msg; CSS :hover maps to brief tap on mobile = instant feedback | ✓ Good |
| user-select: none at scoreButton_ leaf | Each button cell individually non-selectable; -webkit prefix for Safari | ✓ Good |
| ManualInput bool in GroupMatches.State | Simple toggle for keyboard vs text-input mode; no separate type needed | ✓ Good |
| Zenburn palette via named constants in UI/Color.elm | All consumers auto-update; no per-page edits required | ✓ Good |
| Color.activeNav separate from Color.orange | Semantic naming; saturated #F0A030 vs soft amber #F0DFAF keeps clear visual hierarchy | ✓ Good |
| fillPortion 1/2/1 for form nav bar | Center zone truly centered regardless of prev/next label width | ✓ Good |
| UI.Screen.maxWidth returns fixed 600 (ignores arg) | Simple constant; underscore param suppresses unused warning | ✓ Good |
| inFront overlay column stays full-width | Form nav bar, status bar, install banner must not be constrained | ✓ Good |
| Input.labelHidden when > prompt is visual label | Avoids elm-ui labelAbove contradicting terminal aesthetic | ✓ Good |
| Two distinct SVG placeholders (? vs ···) | Makes it visually obvious whether a slot is bad data vs empty/pending | ✓ Good |
| DashboardCard has no payload (reads Model directly) | No state management needed; dashboard always shows live model state | ✓ Good |
| Form.Dashboard.view accepts full Model Msg | Computes all card indices and completion state internally via findCardIndex | ✓ Good |
| Tournament.elm selectedMatches filter pre-wired for 36 | Only display string in Dashboard.elm needed updating; no data-layer change | ✓ Good |
| viewBracketMinimap replaces 3-variant stepper | Single function for all screen sizes; dot rail is device-independent | ✓ Good |
| UpdateSearch at top-level update (not Topscorer.update) | Consistent with ParticipantCard pattern; card state mutation stays at app boundary | ✓ Good |
| Search uses Html.input via Element.html | Avoids elm-ui Input.text styling constraints for terminal aesthetic | ✓ Good |
| SelectTeam clears searchQuery | Restores grouped view automatically without extra Msg | ✓ Good |

---
*Last updated: 2026-03-09 after v1.3 milestone*
