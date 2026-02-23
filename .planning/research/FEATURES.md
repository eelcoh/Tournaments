# Feature Research

**Domain:** Mobile UX improvements for form-heavy Elm SPA (tournament betting)
**Researched:** 2026-02-23
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete on mobile.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Touch targets >= 44px tall | iOS HIG and Android Material both mandate 44-48px minimum; users tap incorrectly on small targets and blame the app | LOW | Current buttons use `height (px 34)` — too small. Score keyboard buttons are `height (px 28)`. Group nav letters are unsized inline text. All need height bumps. |
| No layout overflow on narrow screens | Users expect content to fit without horizontal scrolling on a 375px-wide phone | MEDIUM | Score keyboard rows: 7 buttons × 46px = 322px + spacing — fits 375px but tight. Bracket stepper: 6 steps × (32+connector) — needs verification at 320px. |
| Viewport meta tag present | Prevents desktop-scale zoom-out on mobile; without it the app looks tiny | LOW | Already present: `<meta name="viewport" content="width=device-width, initial-scale=1.0" />` — no action needed. |
| Score input area doesn't get obscured by virtual keyboard | When a text input gets focus, the virtual keyboard covers ~50% of screen; the active input must remain visible | MEDIUM | Current layout puts scroll wheel + input row + keyboard grid all in a column. When system keyboard opens on `Input.text`, both the Elm keyboard grid AND the system keyboard show — double keyboard problem. The Elm `viewKeyboard` already provides score entry; the text inputs are redundant on mobile and cause the keyboard pop-up conflict. |
| PWA: manifest.json | "Add to Home Screen" prompt requires a linked manifest; without it the browser shows a plain bookmark | LOW | No manifest.json exists. Needs `name`, `short_name`, `start_url`, `display: standalone`, `background_color`, `theme_color`, `icons`. One JSON file + Makefile copy step. |
| PWA: service worker registration | Required for PWA installability alongside manifest; also needed for app-shell caching | MEDIUM | No service worker exists. Needs `sw.js` at build root + `navigator.serviceWorker.register` in `index.html`. |
| App-shell cached for fast re-open | Users opening the app after install expect near-instant load; a blank screen on second open feels broken | MEDIUM | Service worker must cache `main.js`, `index.html`, `assets/`, Google Fonts CSS/font files. Cache-first strategy for static assets; network-first for API calls. |
| Sufficient padding around page content | Mobile browsers show content edge-to-edge by default; without padding text sits flush against the screen edge | LOW | Current top-level padding is `paddingEach { top = 24, right = 24, bottom = 40, left = 24 }` — acceptable. Status bar at bottom uses `inFront` + `alignBottom`; bottom padding of 40px must clear the status bar (~32px). Already done. |

### Differentiators (Competitive Advantage)

Features that set the product apart. Not required, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Disable system keyboard for score fields | Score inputs only accept 0-9; the Elm `viewKeyboard` grid already provides all valid entries. Hiding the system keyboard removes double-keyboard confusion and prevents layout reflow entirely | MEDIUM | Use `Input.text` with `type="text"` + `readonly` attribute + `Element.htmlAttribute (Html.Attributes.attribute "inputmode" "none")`. Click handler on the row triggers selection; Elm keyboard fires the `Update` msg. This is cleaner than fighting keyboard-obscures-content. |
| Score keyboard button size increase | Current score buttons are 46×28px — undersized for thumb taps. Enlarging to 46×44px gives a comfortable tap target without changing the grid layout | LOW | Change `height (px 28)` to `height (px 44)` in `UI.Button.Score.scoreButton_`. The 7-column × 46px layout still fits 360px width. |
| Group nav jump letters — larger tap area | Single-letter group nav items (`A B* C ... L`) currently have no explicit height/padding; tap area is line-height only (~20px) | LOW | Add `Element.paddingXY 8 8` and `Element.width (px 32)` to `viewGroupLetter` in `Form.GroupMatches.viewGroupNav`. Center text. Wraps gracefully to two lines on very narrow screens. |
| Bracket team badges — larger tap area | `viewTeamBadge` in `Form.Bracket.View` renders bare text with `onClick`. No padding. On mobile, the 3-4 character team codes are tiny tap targets | LOW | Add `Element.paddingXY 8 8` to `viewTeamBadge` and `viewPlacedBadge`. This also makes selected/deselect interactions more reliable. |
| Bracket stepper — compact on narrow screens | The `viewRoundStepper` renders 6 columns + 5 connectors using ` --- ` (5 chars each). Total ~(6×32) + (5×40) = 392px — tight on 360px screens | LOW | Shorten connector from ` --- ` (5 chars) to `-` (1 char with smaller px width, e.g. `px 16`). Or make connector responsive using `Screen.device`. |
| Status bar safe area inset | On phones with home indicator (iPhone X+, Android gesture nav), the bottom status bar can be hidden behind the gesture zone | LOW | Add `padding-bottom: env(safe-area-inset-bottom)` via `Element.htmlAttribute (Html.Attributes.style "padding-bottom" "env(safe-area-inset-bottom)")` to the status bar's outer `Element.row`. Also add `<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />`. |
| PWA theme color matches terminal aesthetic | When installed, the browser chrome (address bar, task switcher) uses the manifest `theme_color`. Using the app's dark background (`#0d0d0d`) makes the installed app look native | LOW | Set `theme_color: "#0d0d0d"` and `background_color: "#0d0d0d"` in manifest. Add `<meta name="theme-color" content="#0d0d0d">` to `index.html` for non-PWA browsers too. |
| PWA icon — terminal aesthetic appropriate | App icon should match the terminal/ASCII aesthetic rather than a generic football | LOW | Create a simple icon: dark background with ASCII text like `>_` or `WC` in orange monospace. Needs at least 192×192 and 512×512 PNG. SVG source kept in `assets/`. |
| Navigation links — tap-friendly height | The top nav items (`home`, `formulier`, `stand`, etc.) are rendered as `navlink` text. If `navlink` lacks explicit height/padding, targets may be under 44px | LOW | Add `Element.paddingXY 8 12` to `UI.Button.navlink` to ensure tap area. The `wrappedRow` handles overflow gracefully. |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems in this specific Elm + elm-ui context.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| +/- increment buttons for score inputs | "Tapping 0-6 is awkward; just let me tap + and -" | Rejected by user preference. Also: multi-tap interactions feel slower than grid selection for scores like 3-1. Adds state machine for which field is active. | Keep grid keyboard; make it bigger (44px buttons). |
| Swipe-left/right between form cards | Mobile-native navigation pattern | `preventDefaultOn "touchend"` already used on scroll wheel; conflicting swipe handlers would intercept scroll-wheel swipes causing misnavigation. The card chrome already has `< vorige` / `volgende >` buttons. | Increase tap target on those nav buttons instead. |
| Full offline mode (bet form works without network) | Users want to fill in bets on the train | Requires localStorage sync strategy, conflict resolution on submit, offline state detection. Out of scope per PROJECT.md decision. | App-shell caching makes reload instant; form fills fine once loaded. API required only on submit. |
| Virtual keyboard with decimal/fractional scores | Some betting pools allow 0.5 goals | WC football scores are always whole numbers 0-9. Adding non-integer support changes domain model (`Score = Maybe Int` → `Maybe Float`), requires JSON schema changes, backend changes. | Keep `Maybe Int` score model. |
| Pinch-to-zoom on bracket view | Bracket wizard spans many rounds; zoom would help navigation | elm-ui renders into a single `Element.layout` div. elm-ui does not support pointer-events passthrough for pinch gestures on sub-elements without significant custom JS. The wizard approach (round-by-round) replaces the need for an overview zoom. | Ensure each round section is individually scrollable and accessible one at a time (current design). |
| Real-time score sync / push notifications | Show live match updates as user fills in bets | Tournament betting form is filled in before the tournament starts; there are no live scores to sync during form fill. During results phase, adds WebSocket complexity (Elm Port required). Out of scope. | Poll on page load; users navigate to results view to see updates. |
| Auto-advance to next match after score entry | After entering away score, automatically move cursor to next match | `UpdateAway` already calls `updateCursor state allMatchIDs Implicit` which advances cursor. This feature already exists. | Document it, maybe add a subtle visual cue. |
| Undo/rollback bracket picks | Accidental tap deselects a team | Requires edit history in state; adds complexity. The `DeselectTeam` msg already allows intentional deselection. | Require confirmation on deselect, or just make tap targets large enough to prevent accidental taps. |

## Feature Dependencies

```
[PWA Installability]
    requires --> [manifest.json]
    requires --> [service worker registration]
                     requires --> [sw.js file at build root]
                     requires --> [Makefile copies sw.js to build/]

[App-shell caching]
    requires --> [service worker registration]
    enhances --> [PWA Installability]

[System keyboard suppression for scores]
    requires --> [Score keyboard provides all entries via onClick]
                     (already true: viewKeyboard covers all valid scores 0-7)
    conflicts --> [Input.text onChange handlers] (must be kept for accessibility fallback)

[Safe area insets for status bar]
    requires --> [viewport-fit=cover in meta tag]

[Score button size increase (44px)]
    enhances --> [System keyboard suppression] (bigger buttons reduce mis-taps)

[Group nav tap areas]
    independent of all other features

[Bracket team badge tap areas]
    independent of all other features

[PWA icon]
    requires --> [manifest.json]
```

### Dependency Notes

- **PWA Installability requires both manifest.json and service worker:** Chrome and Safari both require a linked manifest AND a registered service worker for "Add to Home Screen" prompt. Manifest alone is insufficient.
- **App-shell caching requires service worker:** The caching strategy lives inside `sw.js`. The service worker and the caching are the same delivery vehicle — implement together.
- **System keyboard suppression requires viewKeyboard to cover all entries:** The grid already covers scores 0-0 through 5-5 plus common lopsided scores. All scores realistically needed for football are present.
- **Safe area insets requires viewport-fit=cover:** `env(safe-area-inset-bottom)` only works when the viewport meta has `viewport-fit=cover`. Changing the meta tag affects nothing else.
- **Score button size increase enhances system keyboard suppression:** If the system keyboard is suppressed, users rely entirely on the Elm grid. Larger buttons then become more critical.

## MVP Definition

### Launch With (v1)

Minimum viable to call the milestone "mobile UX improved."

- [ ] manifest.json — required for PWA installability; zero-risk one-file change
- [ ] service worker (app-shell caching) — required for installability + fast re-open; only new JS in the project
- [ ] Score keyboard buttons enlarged to 44px height — highest-impact mobile UX change; pure elm-ui change in one function
- [ ] Touch targets enlarged: group nav letters, bracket team badges, nav links — fixes the most common mis-tap points; all are small isolated elm-ui padding changes
- [ ] System keyboard suppressed on score inputs — eliminates double-keyboard confusion; medium complexity but high payoff

### Add After Validation (v1.x)

Features to add once core is working and tested on real devices.

- [ ] Safe area insets for status bar — needed for iPhones with home indicator; small change but requires device testing to verify
- [ ] Bracket stepper compact on narrow screens — nice to have but wizard is already usable on 360px
- [ ] PWA icon with terminal aesthetic — polish item; app installs without it (placeholder icon) but looks better with it
- [ ] Theme color in manifest and meta tag — purely cosmetic; improves installed app feel

### Future Consideration (v2+)

Features to defer until after the tournament starts (when results UX matters more).

- [ ] Virtual scrolling for activities feed — only needed if 500+ activities accumulate; not relevant during bet-fill phase
- [ ] Form draft auto-save — important but requires separate milestone (backend coordination, localStorage strategy)
- [ ] Offline form fill — explicitly out of scope per PROJECT.md

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| manifest.json | HIGH | LOW | P1 |
| Service worker + app-shell cache | HIGH | MEDIUM | P1 |
| Score buttons 44px height | HIGH | LOW | P1 |
| Group nav tap area padding | HIGH | LOW | P1 |
| Bracket team badge tap area padding | HIGH | LOW | P1 |
| Suppress system keyboard on score inputs | HIGH | MEDIUM | P1 |
| Nav links tap area padding | MEDIUM | LOW | P1 |
| PWA icon (terminal aesthetic) | MEDIUM | LOW | P2 |
| Theme color in manifest + meta | LOW | LOW | P2 |
| Safe area insets | MEDIUM | LOW | P2 |
| Bracket stepper compact | LOW | LOW | P2 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

This is a private friend-group betting pool, not a commercial product. Relevant comparisons are to generic mobile form UX patterns rather than competing products.

| Feature | Generic Mobile Form Best Practice | Our Current State | Our Plan |
|---------|-----------------------------------|-------------------|----------|
| Touch target size | 44-48px (iOS HIG / Material Design) | 28-34px on most interactive elements | Enlarge to 44px across score buttons, group nav, bracket badges, nav links |
| Virtual keyboard conflict | Inputs scroll into view; or keyboard is suppressed for non-text inputs | System keyboard opens on score `Input.text`; obscures content | Suppress system keyboard via `inputmode="none"`; rely on Elm grid |
| PWA installability | manifest.json + service worker | Neither present | Add both |
| App shell caching | Cache-first for static assets | No caching | Service worker with precache list |
| Safe area (notch/home indicator) | `env(safe-area-inset-*)` | No safe area handling | Add to status bar bottom padding |
| Scroll affordance | Visual indicators for scrollable areas | Scroll wheel arrows/swipe works but no visual hint of "more below" | Out of scope for this milestone; scroll positions suffice |

## Sources

- Apple Human Interface Guidelines: minimum touch target 44×44pt
- Material Design 3: minimum touch target 48×48dp
- Web.dev PWA checklist: manifest.json + service worker required for installability
- MDN: `inputmode="none"` attribute suppresses virtual keyboard while keeping element focusable
- W3C viewport-fit=cover: required for CSS env(safe-area-inset-bottom) to work
- Codebase analysis: `UI.Button.Score.scoreButton_` uses `height (px 28)`, `UI.Style.buttonInactive` uses `height (px 34)`, all below 44px threshold
- Codebase analysis: `Form.GroupMatches.viewGroupNav` uses unsized `Element.text` with no padding
- Codebase analysis: `Form.Bracket.View.viewTeamBadge` uses bare `Element.text` with `onClick` and no padding
- Codebase analysis: `src/index.html` has no manifest link, no service worker registration, no theme-color meta

---
*Feature research for: Mobile UX improvements — Elm 0.19.1 tournament betting SPA*
*Researched: 2026-02-23*
