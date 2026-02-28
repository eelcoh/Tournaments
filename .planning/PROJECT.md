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

### Active

<!-- v1.1 UX Polish -->
- [ ] Install prompt banner — iOS Safari "Add to Home Screen" tip + Android Chrome BeforeInstallPrompt banner, dismissable, terminal aesthetic
- [ ] Group matches scroll wheel stability — active match fixed at line 4; empty lines consistent height; group label always visible in lines 1–3; -- END -- stays below active line
- [ ] Form flow mobile polish — general mobile UX pass on bet form (navigation, feedback, rough edges on phone)

<!-- Deferred from v1.0 -->
- [ ] Live results data integration — match scores and group standings updating during tournament

### Out of Scope

- Offline bet submission — requires syncing strategy; keep it simple: network required to submit
- Full offline results cache — too complex for now; fast load covers the main pain
- Native app / React Native — Elm SPA served as PWA is sufficient
- Score input gesture controls (+/- buttons, swipe) — user prefers keyboard input with better layout
- Swipe-between-cards navigation — conflicts with scroll wheel swipe handler

## Context

- **Current state:** v1.0 shipped — PWA installable, full mobile UX complete. ~19,400 LOC Elm.
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
| UI.Page.container spacing 24 | Distinct rhythm from Form pages (spacing 20 via viewCardChrome) | ✓ Good |
| Form CON-01 via viewCardChrome | fill \|> maximum Screen.maxWidth already enforced at card chrome level | ✓ Good — no migration needed |

## Current Milestone: v1.1 UX Polish

**Goal:** Fix the group matches scroll wheel stability, add platform install prompt banners, and polish the bet form mobile UX.

**Target features:**
- Install prompt banner (iOS tip + Android BeforeInstallPrompt), dismissable, terminal aesthetic
- Group matches scroll wheel: active match fixed at line 4, consistent line heights, group label always in lines 1–3
- Form flow mobile polish: general UX pass on navigation, feedback, and rough edges on phone

---
*Last updated: 2026-02-28 after v1.1 milestone started*
