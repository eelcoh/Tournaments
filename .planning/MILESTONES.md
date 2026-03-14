# Milestones

## v1.4 Visual Design Adoption (Shipped: 2026-03-14)

**Phases:** 18–25 (8 phases, 12 plans)
**Files changed:** 62 files, +7,348 / −673 lines
**Elm LOC:** ~20,847
**Timeline:** 2026-03-09 → 2026-03-12 (4 days)
**Git range:** fed40f3 → 55a3c66

**Key accomplishments:**
1. Martian Mono font — self-hosted variable woff2 replacing Sometype Mono; CRT scanline overlay (4px repeating gradient, 3.5% opacity) applied globally via CSS `body::before`
2. Form chrome — segmented progress rail (active=orange, completed=green, pending=dimmed) + fixed bottom nav with amber `[!]` incomplete indicator and disabled states at boundaries
3. Score inputs + scroll wheel — dark bg/orange text/bordered inputs; group match rows as prototype-style tile rows with SVG flags and consistent spacing
4. Bracket tile cards — 80×44 bordered cards with selected (orange border + tinted bg) and hover states; round header with `N/M geselecteerd` counter and Dutch round descriptions
5. Topscorer + Participant + Submit — flat player cards with bordered search bar; participant field rows with uppercase labels and orange focus border; submit summary box with green/red section status per card
6. Results pages — `resultCard` (#353535 bg, #4a4a4a border) applied to all 5 results pages; amber score coloring in Matches and Ranking via `displayScore`
7. Activities feed — `commentBox` and `blogBox` use `resultCard` treatment; timestamps at 12px grey, author labels orange; `darkBox` for comment input
8. Group standings view — new `Results.GroupStandings` module at `#groepsstand` with semantic row coloring: green (top 2), amber (third), cream (eliminated)

**Archive:** `.planning/milestones/v1.4-ROADMAP.md`, `.planning/milestones/v1.4-REQUIREMENTS.md`

---

## v1.3 Form Flow Redesign (Shipped: 2026-03-09)

**Phases:** 14–17 (4 phases, 4 plans)
**Files changed:** 25 src files, +2221 / −205 lines
**Elm LOC:** ~20,196
**Timeline:** 2026-03-08 → 2026-03-09 (1 day)
**Git range:** f95ac4e → df3a073

**Key accomplishments:**
1. Dashboard home — DashboardCard replaces IntroCard at form index 0; styled section rows with `[x]/[.]/[ ]` indicators, progress counts (e.g. 36/36), and tap-to-jump to any section; all-done banner when complete
2. Group matches reduction — 36-match group stage activated (1 per matchday × 3 × 12 groups); Tournament.elm filter was pre-wired; only display string updated
3. Bracket minimap — horizontal dot rail (R32 R16 KF HF F ★) replaces 3-function ASCII stepper; green/amber/border-only states; all dots tappable via JumpToRound
4. Topscorer search — live prefix filter on name and country (case-insensitive); searchQuery card state updated at top-level; clears on team selection; empty-state message

**Archive:** `.planning/milestones/v1.3-ROADMAP.md`, `.planning/milestones/v1.3-REQUIREMENTS.md`

---

## v1.2 Visual Polish (Shipped: 2026-03-07)

**Phases:** 10–13 (4 phases, 6 plans)
**Files changed:** 8 src files, +105 / −77 lines
**Elm LOC:** ~19,880
**Timeline:** 2026-03-07 → 2026-03-07 (1 day)
**Git range:** e9f70dd → 8b978de

**Key accomplishments:**
1. Zenburn color scheme — warm dark palette (#3f3f3f bg, #dcdccc cream text, #f0dfaf amber) applied app-wide via 9 color constant changes; PWA theme-color updated to match
2. Terminal nav aesthetic — navlink rewritten as plain monospace text (no border/box); active state uses saturated `Color.activeNav` (#F0A030), clearly distinct from inactive cream body text
3. Form nav centering — fillPortion 1/2/1 layout gives vorige/volgende labels truly centered tap zones; allCenteredText for vertical+horizontal alignment
4. Consistent 600px page width — `UI.Screen.maxWidth` returns fixed 600; outer page column capped so nav, content, and footer left-align to the same boundary on desktop
5. Terminal loading states — activities loading copy changed to `[ ophalen... ]`; empty state silenced to `Element.none`; comment/author input labels hidden (> prompt is sole visual identifier)
6. Distinct team placeholders — two SVGs: grey `?` for unknown teamIDs (`404-not-found.svg`) and darker grey `···` for empty TBD bracket slots (`999-to-be-decided.svg`)

**Archive:** `.planning/milestones/v1.2-ROADMAP.md`, `.planning/milestones/v1.2-REQUIREMENTS.md`

---

## v1.0 Mobile UX (Shipped: 2026-02-28)

**Phases:** 1–5 (5 phases, 16 plans)
**Files changed:** 76 files, +8,758 / −231 lines
**Elm LOC:** ~19,400
**Timeline:** 2026-02-24 → 2026-02-28 (4 days)
**Git range:** ca7d8b8 → 541cd48

**Key accomplishments:**
1. PWA installable — self-hosted Sometype Mono fonts, manifest.json, cache-first service worker; app installs from Chrome (Android) and Safari (iOS)
2. Touch-friendly form — 44px tap zones on all interactive elements (nav letters, score buttons, bracket badges, step indicators); numeric keyboard for score inputs
3. iPhone SE fit — responsive 8px padding on Phone screens gives 296px content width on 320px viewport
4. Bracket wizard mobile — compact 3-step stepper on Phone (no horizontal overflow at 375px), 4-column team grid for comfortable tapping
5. UI consistency — UI.Page.container, UI.Button.dataRow, terminal input styling across all pages; all 5 Results pages width-constrained on desktop
6. UX polish — bracket team flags restored, sticky "Ga verder" button on R32 complete, checkmark stepper, topscorer terminal list, GroupBoundary height fix

**Archive:** `.planning/milestones/v1.0-ROADMAP.md`, `.planning/milestones/v1.0-REQUIREMENTS.md`

---

## v1.1 UX Polish (Shipped: 2026-03-01)

**Phases:** 6–9 (4 phases, 7 plans)
**Elm LOC:** ~19,800
**Timeline:** 2026-02-28 → 2026-03-01 (2 days)

**Key accomplishments:**
1. Scroll wheel stability — 7-line fixed-window with active match locked at line 4, group label anchored at line 1, WLPadding eliminating all height jumps, END marker confined to lines 5-7
2. iOS install prompt — terminal-styled banner from `navigator.standalone` flag, dismiss-persistent via localStorage, hidden when already installed
3. Android install prompt — JS-Elm port bridge capturing `BeforeInstallPrompt`, triggers native install dialog, dismissable
4. Fixed 48px bottom nav bar — vorige/volgende greyed at boundaries, per-card incomplete count, scroll-to-top on every card transition
5. Tap feedback — "verzenden..." loading state on submit; nav buttons flash white on tap via elm-ui mouseOver
6. Keyboard-primary score input — flag header always visible, keyboard as default, "andere score" overlay for text input
7. Touch polish — `user-select: none` on score buttons prevents mobile text-selection highlight on tap

**Archive:** `.planning/milestones/v1.1-ROADMAP.md`, `.planning/milestones/v1.1-REQUIREMENTS.md`

---

