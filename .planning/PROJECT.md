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

- ✓ Martian Mono font — self-hosted variable woff2 (replaces Sometype Mono); CRT scanline overlay via CSS `body::before` at 4px intervals, 3.5% opacity — v1.4
- ✓ Form navigation chrome — segmented progress rail (active=orange, completed=green, pending=dimmed) + fixed bottom nav with `[!]` incomplete indicator and disabled states at boundaries — v1.4
- ✓ Score inputs + scroll wheel tiles — dark bg/orange text/bordered inputs; group match rows as prototype-style tile layout with SVG flags — v1.4
- ✓ Bracket tile cards — 80×44 bordered cards with selected state (orange border + tinted bg) and hover; round header with `N/M geselecteerd` counter — v1.4
- ✓ Topscorer, Participant, Submit restyle — flat player cards with bordered search bar; field rows with uppercase labels and focus border; submit summary box with green/red per-section status — v1.4
- ✓ Results pages card aesthetic — `resultCard` (#353535 bg, #4a4a4a border) across all 5 results pages; amber score coloring in Matches and Ranking — v1.4
- ✓ Activities feed card treatment — `commentBox`/`blogBox` with `resultCard`; prototype typography for timestamps and author labels — v1.4
- ✓ Group standings view — `Results.GroupStandings` at `#groepsstand`; semantic row coloring (green top-2, amber third, cream eliminated) — v1.4

- ✓ Test mode activation — `#test` URL and 5-tap title gesture sets `testMode : Bool` on Model; orthogonal to routing — v1.5
- ✓ TEST MODE badge + full nav bypass — `[TEST MODE]` in status bar; all 9 nav items visible regardless of auth token or tournament state — v1.5
- ✓ Offline dummy activities — 5 lorem ipsum entries; offline comment/post submission prepends locally, no network call — v1.5
- ✓ Dummy results pages — rankings, match results, group standings, knockout bracket all show test data without backend — v1.5
- ✓ Fill-all Dashboard button — one tap fills all 36 group scores, full WC2026 bracket (France champion), Mbappé topscorer; only visible in test mode — v1.5

- ✓ Navigation surfaces aligned to prototype — 12px header logo (0.1em letter-spacing, #2b2b2b bg, 44px height, 1px bottom border), 8px progress rail step labels, 56px bottom nav bar — v1.6
- ✓ Card headers use `--- TITLE ---` amber pattern (10px, 0.18em letter-spacing); intro text blocks get dash-intro style (2px orange left border, 11px dim text, 1.75 line-height, subtle orange-tinted bg) — v1.6
- ✓ Bracket round badge header — bordered box with active-color 11px title and 10px dim subtitle — v1.6
- ✓ Team tiles across all form pages match prototype — group match rows (22×16px flags, 11px abbr), bracket tiles (28×20px flag, name+code column), topscorer tiles (24×18px flag, 12px name, 10px dim code) — v1.6
- ✓ Activities feed distinct content-type styling — comment entries: 2px amber left border + tint; blog posts: 2px zenGreen (#7F9F7F) left border + tint — v1.6
- ✓ Three text inputs auto-focus via `Browser.Dom.focus` — comment input (ShowCommentInput), blog post textarea (ShowPostInput), participant name field (NavigateTo ParticipantCard) — v1.6

### Out of Scope

- Offline bet submission — requires syncing strategy; keep it simple: network required to submit
- Full offline results cache — too complex for now; fast load covers the main pain
- Native app / React Native — Elm SPA served as PWA is sufficient
- Score input gesture controls (+/- buttons, swipe) — user prefers keyboard input with better layout
- Swipe-between-cards navigation — conflicts with scroll wheel swipe handler

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
| Latin-subset Martian Mono woff2 downloaded from Google Fonts CDN directly | Avoids TTF-to-woff2 conversion step; direct format = smaller file and correct web format | ✓ Good |
| CRT scanline via `body::before` CSS (not Elm) | Pseudo-element with `pointer-events: none` at z-index 9998 overlays entire viewport without Elm side effects | ✓ Good |
| viewProgressRail uses fillPortion 1 + Element.Events.onClick | Click-to-jump navigation for free; equal-width segments regardless of card count | ✓ Good |
| `[!]` indicator instead of exact incomplete count in nav | Simpler than counting per-card; user knows the section has incomplete items | ✓ Good |
| scoreInput: Border.width 1 all sides; focused = orange border + activeNav text | Full border (not just bottom) matches prototype `.s-inp`; focused state clearly communicates interactivity | ✓ Good |
| matchRowTile exported from UI.Style with Bool isActive | Reusable border-tile pattern across any list; bool avoids duplicating two nearly-identical style blocks | ✓ Good |
| Focus state driven by SearchFocused True/False msgs from Html onFocus/onBlur | Elm state tracks HTML input focus since elm-ui doesn't expose focus/blur events on text inputs | ✓ Good |
| Flat player list via List.concatMap over teamData | Removes team-grouping UX step; list filter by name OR team code substring is simpler and faster to use | ✓ Good |
| UI.Style.resultCard as shared style helper | Single point of truth for card aesthetic; add to any container as `attrs` list; override-friendly | ✓ Good |
| blogBox amber left border as override attrs to resultCard | Border.widthEach overrides resultCard's Border.width 1 cleanly — shows composition approach | ✓ Good |
| positionColor applies Font.color to entire row element | Uniform row color without per-cell markup; simple and consistent with how color theming works in elm-ui | ✓ Good |
| groupWhile (not groupBy) for group standings computation | Matches Results.Matches pattern; MatchResult list arrives ordered by group — groupWhile preserves order without sorting | ✓ Good |
| RefreshResults reused for groepsstand route | matchResults is the shared data source for all results; no new fetch Msg needed | ✓ Good |
| testMode : Bool on Model (not App variant) | Orthogonal to navigation; no new routing cases needed, all guards are simple if/else branches | ✓ Good |
| TestData.* namespace for static dummy data | Plain Elm modules with static values derived from Bets.Init — no hand-writing tournament constants | ✓ Good |
| testMode guard as outermost check in Refresh branches | Always injects test data before cache checks — no race condition with existing Success state | ✓ Good |
| rebuildBracket/updateBracket exposed from Form.Bracket | FillAllBet update branch needs both to set bracket + sync BracketCard WizardState atomically | ✓ Good |
| Literal Font.size values (12, 8) for nav typography | elm-ui scaled() has no values at 12 or 8 — literal pixel sizes required for prototype-exact nav | ✓ Good |
| viewProgressRail segments as Element.column (label+bar) | Label above bar in same column; shared color/alpha state without extra layout container | ✓ Good |
| Border.widthEach { left=2, right=0, top=0, bottom=0 } for accent cards | Setting right/top/bottom to 0 (not 1) prevents all four sides rendering colored borders | ✓ Good |
| Inline attrs in blogBox/commentBox (not resultCard override) | resultCard appends its own Border attrs after caller attrs — overrides are impossible; inlining is the only clean solution | ✓ Good |
| Color.zenGreen (#7F9F7F) in UI.Color | Muted green paired with amber for semantic content-type distinction in activities feed | ✓ Good |
| Html.Attributes.id via Element.htmlAttribute for auto-focus | Standard elm-ui pattern for native HTML attrs on elm-ui elements | ✓ Good |
| Task.attempt (\_ -> NoOp) (Browser.Dom.focus id) | Silently discards focus-not-found error — acceptable since focus failure is non-fatal | ✓ Good |
| Cmd.batch for NavigateTo to combine scroll + focus | Preserves existing scroll-to-top while adding conditional focus on ParticipantCard | ✓ Good |

## Context

- **Current state:** v1.6 shipped — UI alignment with prototype design system complete across all form surfaces and activities feed. ~21,200 LOC Elm (est.).
- **Tech stack:** Elm 0.19.1, elm-ui, Martian Mono (self-hosted), vanilla JS service worker, static hosting
- Players fill in bets before the tournament starts; they mostly use phones
- The app is statically hosted — no server-side rendering, just `build/` files served
- Service worker must live outside Elm (JS file registered in `src/index.html`)
- Any new static assets must be manually added to APP_SHELL in `src/sw.js`
- iOS Safari: 7-day cache eviction is a known constraint; do not architect features assuming persistent cache

---
*Last updated: 2026-03-15 after v1.6 milestone*
