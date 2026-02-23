# Tournaments — Mobile UX Milestone

## What This Is

A football tournament betting SPA (World Cup 2026) where players predict group match scores, knockout bracket results, and the top scorer. Built with Elm 0.19.1 and elm-ui; deployed as a static site. This milestone focuses on making the experience genuinely good on mobile — the primary device players use to fill in their bets.

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

### Active

- [ ] PWA installability — manifest.json + service worker so players can add to home screen
- [ ] App-shell caching — service worker caches static assets for instant subsequent loads
- [ ] Mobile score input UX — better spacing and touch-friendly layout for score entry fields
- [ ] Mobile bracket wizard UX — tighter layout so rounds are navigable on a small screen
- [ ] Mobile navigation UX — overall layout and tap target improvements across the form

### Out of Scope

- Offline bet submission — requires syncing strategy; keep it simple: network required to submit
- Full offline results cache — too complex for now; fast load covers the main pain
- Native app / React Native — Elm SPA served as PWA is sufficient
- Score input gesture controls (+/- buttons, swipe) — user prefers keyboard input with better layout

## Context

- Players fill in bets before the tournament starts; they mostly use phones
- The app is statically hosted — no server-side rendering, just `build/` files served
- Service worker must live outside Elm (JS file registered in `src/index.html`)
- PWA manifest should use the tournament theme colors and a suitable icon
- The terminal aesthetic was a deliberate redesign (Issue #86) — mobile improvements must respect it
- Viewport width is already passed to Elm as flags, so the app is aware of screen size

## Constraints

- **Tech stack**: Elm 0.19.1 — no new JS frameworks; service worker is the only new JS
- **Styling**: elm-ui only — no CSS files; all layout via `Element.*` attributes
- **Service worker**: must be a plain JS file at build root; registered in `index.html`
- **No offline sync**: app shell + static assets cached; API calls still require network
- **No debug.log**: production builds use `--optimize` which rejects Debug calls

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| PWA over native app | Elm SPA + service worker is zero-overhead installability | — Pending |
| App-shell caching only (no offline data) | Avoids sync complexity; fast load solves the main pain | — Pending |
| Keep keyboard score input, improve layout | User prefers typing; focus on spacing/touch-target size | — Pending |

---
*Last updated: 2026-02-23 after initialization*
