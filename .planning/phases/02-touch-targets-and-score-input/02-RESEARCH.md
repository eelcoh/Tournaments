# Phase 2: Touch Targets and Score Input - Research

**Researched:** 2026-02-24
**Domain:** Elm 0.19.1 / elm-ui 1.1.8 — mobile touch target sizing and numeric keyboard input
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Use **invisible tap zones** throughout — add invisible padding/wrapper so the hit area reaches 44px without changing the visual appearance
- The terminal aesthetic (small text, ASCII style) must stay visually intact; only the tappable area grows
- This applies uniformly to: nav letters, score buttons, nav links, bracket badges, step indicators
- **All interactive elements:** 44px minimum (both width and height)
- **Score buttons** (used intensively across 48 group matches): 44px minimum — consistent with everything else, not a special larger size
- **Bracket team badges:** 44px tap zones applied to ALL tappable badges — consistent rule, no exceptions for "probably large enough" elements
- Nav links stay **inline** (no full-width rows on mobile)
- Tap zone expanded to 44px height via invisible padding top/bottom
- Horizontal terminal nav layout is preserved

### Claude's Discretion
- Score input keyboard type (how to trigger numeric keypad on iOS/Android — `inputmode`, `type`, or elm-ui equivalent)
- Group match row layout at 320px (how to prevent horizontal overflow — truncation, layout change, or smaller elements)
- Group nav letters A–L at 320px (whether to wrap, scroll, or resize)
- Exact elm-ui implementation pattern for invisible tap zones (wrapping `el` with padding, or `Element.minimum`, etc.)

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| MOB-01 | All interactive elements have a minimum touch target of 44×44px | elm-ui `Element.minimum 44` on height + `paddingXY` pattern verified |
| MOB-02 | Group nav letters (A–L) in `Form/GroupMatches.elm viewGroupNav` have ≥44px height with horizontal padding ≥8px | Invisible wrapper `el` with `height (minimum 44 fill)` + `paddingXY 8 0`; already uses `spacing 8` |
| MOB-03 | Navigation buttons ("< vorige", "volgende >", etc.) have ≥44px height | `UI.Button.pill` / `UI.Button.navlink` currently at 30–34px; bump to 44px minimum |
| MOB-04 | Score keyboard buttons in `UI/Button/Score.elm` have ≥44px height | Currently `px 28` / `px 26`; change to `minimum 44 fill` or `px 44` |
| MOB-05 | Bracket team badges in `Form/Bracket/View.elm` have a minimum 44×44px tappable area | Wrap `viewTeamBadge` / `viewPlacedBadge` `el` with `width (minimum 44 fill)` + `height (minimum 44 fill)` |
| MOB-06 | Top checkboxes bar (`viewTopCheckboxes`) has 44px minimum height per step indicator | Wrap each `clickableCheck` with min-height 44 el |
| SCR-01 | Score input fields include `Html.Attributes.attribute "inputmode" "numeric"` via `Element.htmlAttribute` | Verified: `attribute` function exists in elm/html; elm-ui does not expose inputmode natively |
| SCR-02 | Score input fields have a minimum width of 60px (currently `px 45`) | Simple width change in `viewInput` in `Form/GroupMatches.elm` |
| SCR-03 | Group match rows do not overflow horizontally at 320px viewport width | Root cause identified: 24+24px outer padding in View.elm + 24px `el [padding 24]` = 72px consumed on 320px screen; fix: reduce outer page padding for `Phone` device type |
</phase_requirements>

---

## Summary

This phase is a set of pure elm-ui attribute changes across a small number of files — no new modules, no new dependencies. Every required change fits within Elm's existing APIs. The two technical questions marked as "Claude's Discretion" in CONTEXT.md have clear answers: use `Html.Attributes.attribute "inputmode" "numeric"` wrapped with `Element.htmlAttribute`, and reduce the outer page padding in `View.elm` from 24px to 8px for `Phone` device type to fix the 320px overflow.

The invisible tap zone pattern is straightforward in elm-ui: wrap the small visual element in an `Element.el` with `height (px 44)` (or `minimum 44 fill`) and `paddingXY` to give it invisible hit area while the child content stays visually unchanged. This is the correct elm-ui idiom — there is no dedicated "tap zone" API. Alternatively, for elements rendered with `Element.el [...] (text "A")`, simply adding `height (px 44)` and `centerY` to the `el` attributes achieves the same result.

The 320px overflow on group match rows is caused by stacked padding: the main `page` column in `View.elm` uses `paddingEach { left=24, right=24 }`, and the `contents_` is wrapped in `Element.el [padding 24]`, consuming 96px total horizontal padding. On a 320px screen, only 224px remain for content. The `viewInput` row with two 45px score inputs, spacing, team codes, and padding needs approximately 228px — overflow. The fix is to make the `page` padding responsive: detect `Phone` (screen width < 500) via the already-existing `Screen.device` function and reduce page padding to 8px on both sides.

**Primary recommendation:** Change `px N` heights to `px 44` or `minimum 44 fill` on all interactive elements; add `Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")` to score `Input.text` fields; reduce page padding from 24px to 8px for `Phone` device type in `View.elm`.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mdgriffith/elm-ui | 1.1.8 | Layout and styling — no CSS files | Already in use; all changes are attribute additions |
| elm/html | 1.0.0 | `Html.Attributes.attribute` for `inputmode` | Already in use; provides the generic attribute escape hatch |

### No New Dependencies
This phase requires no new Elm packages. All needed APIs exist in the current dependency set.

---

## Architecture Patterns

### Pattern 1: Invisible Tap Zone via Wrapping `el`

**What:** Wrap a visually-small element in a transparent `el` that has the full 44px hit area. The visual appearance is unchanged because the child element stays at its natural size; only the outer `el` is tappable.

**When to use:** When the visual element (text letter, small badge, ASCII prompt) must stay small but needs a 44px hit area. Use for: group nav letters, step indicators, bracket team text badges.

**Example:**
```elm
-- BEFORE: letter is visually and tappably small
Element.el
    [ Element.Events.onClick (JumpToGroup grp)
    , Element.pointer
    , Font.color clr
    , UI.Font.mono
    ]
    (Element.text label)

-- AFTER: outer el absorbs the tap; inner text stays visually the same
Element.el
    [ Element.Events.onClick (JumpToGroup grp)
    , Element.pointer
    , Element.height (Element.px 44)
    , Element.paddingXY 8 0
    , Element.centerY
    ]
    (Element.el
        [ Font.color clr
        , UI.Font.mono
        , Element.centerY
        ]
        (Element.text label)
    )
```

### Pattern 2: Minimum Height on Button Components

**What:** Change `height (px N)` to `height (px 44)` on button-like elements that are already interactive but fall below 44px.

**When to use:** For `pill`, `navlink`, and score buttons that already have explicit pixel heights set below 44px.

**Example:**
```elm
-- In UI.Button.pill — currently height (px 30)
-- Change to:
buttonLayout =
    Style.button semantics [ paddingXY 4 4, height (px 44), onClick msg, centerY, centerX ]

-- In UI.Button.navlink — currently height (px 34)
-- Change to:
linkStyle =
    Style.button semantics
        [ paddingXY 15 5
        , height (px 44)
        , rounded 0
        , centerX
        , centerY
        ]
```

### Pattern 3: `inputmode="numeric"` via `Element.htmlAttribute`

**What:** elm-ui's `Input.text` renders an HTML `<input>` element. HTML5 `inputmode` attribute controls which virtual keyboard the browser shows. elm-ui does not expose `inputmode` natively, but any HTML attribute can be passed via `Element.htmlAttribute (Html.Attributes.attribute "name" "value")`.

**When to use:** On all score `Input.text` fields. The `type="number"` alternative is explicitly out of scope (REQUIREMENTS.md: "user prefers keyboard input") and causes UX issues on iOS. `inputmode="numeric"` with `type="text"` is the correct combination.

**Why `inputmode` over `type="number"`:**
- `type="number"` removes leading zeros, adds scroll-wheel on desktop, breaks string-based score storage
- `inputmode="numeric"` shows the numeric keypad without changing the input's value semantics
- Works on both iOS (iOS 12.2+) and Android Chrome

**Example:**
```elm
-- In Form/GroupMatches.elm viewInput > inputField
inputField v act =
    let
        inp =
            { onChange = makeAction act
            , text = v
            , label = Input.labelHidden ".."
            , placeholder = Just (Input.placeholder [] (Element.text v))
            }
    in
    Input.text
        (UI.Style.scoreInput
            [ width (px 60)   -- was px 45 (SCR-02 fix)
            , Border.rounded 0
            , Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")
            ]
        )
        inp
```

### Pattern 4: Responsive Padding via `Screen.device`

**What:** The `Screen.device` function already exists in `UI.Screen` and returns `Phone` when `screen.width < 500`. Use this to vary the outer page padding in `View.elm` so 320px screens have enough content area.

**When to use:** For SCR-03. The `Model` has `model.screen : Screen.Size` (passed from flags). Thread it into the layout decision.

**Root cause of 320px overflow:**
```
320px viewport
 - 24px left padding (View.elm page column)
 - 24px right padding (View.elm page column)
 - 24px inner padding (Element.el [ padding 24 ] contents_)
 - 24px inner padding (same el, right side)
= 224px content width

viewInput row needs approximately:
 - ">" prompt: ~9px
 - home team code (4 chars): ~36px
 - homeInput: 45px
 - "-" separator: ~9px
 - awayInput: 45px
 - away team code (4 chars): ~36px
 - spacing 8 × 5: 40px
 - paddingXY 4 16 (horizontal): 8px
= ~228px (overflows 224px)
```

**Fix:**
```elm
-- In View.elm, replace:
Element.el [ Element.padding 24 ] contents_

-- With:
let
    contentPadding =
        case Screen.device model.screen of
            Screen.Phone ->
                Element.padding 8
            Screen.Computer ->
                Element.padding 24
in
Element.el [ contentPadding ] contents_

-- Also reduce the page column paddingEach for Phone:
let
    horizontalPad =
        case Screen.device model.screen of
            Screen.Phone ->
                8
            Screen.Computer ->
                24
in
Element.paddingEach { top = 24, right = horizontalPad, bottom = 40, left = horizontalPad }
```

With 8px padding on both levels: `320 - 8 - 8 - 8 - 8 = 296px` content width — comfortably fits the ~228px input row.

### Anti-Patterns to Avoid

- **Adding `Element.minimum 44 fill` to height without `fill` parent:** `minimum N fill` only works if the parent allows filling. For isolated clickable elements, `px 44` is simpler and more reliable.
- **Using `type_="number"` for score inputs:** Breaks on iOS (shows different keyboard on some versions), strips leading zeros, adds unwanted spinner. Use `inputmode="numeric"` with `type_="text"` (the elm-ui default).
- **Changing the visual element's font size to achieve target size:** Violates the locked decision that terminal aesthetic stays visually intact.
- **Applying tap zone padding to the visual child instead of the wrapper:** The visual text/badge must keep its natural size; padding belongs on the wrapper `el`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Custom virtual keyboard for score entry | On-screen digit buttons (already exists as `viewKeyboard` in `UI/Button/Score.elm`) | The on-screen keyboard already works — just add `inputmode` to the text input for when users prefer it | Score buttons are 7-column score preset grid, not a numeric keyboard |
| CSS media queries for responsiveness | Raw `Html.Attribute` CSS injection | `Screen.device model.screen` (already in `UI.Screen`) | The device detection is already wired; use it |
| Touch target library | npm package or custom JS | elm-ui `height (px 44)` + `paddingXY` | Pure Elm, no external dep needed |

**Key insight:** All problems are solved by adding attributes to existing elements. No new abstractions or libraries are needed.

---

## Common Pitfalls

### Pitfall 1: `height (px 44)` Fight with Inner Text Alignment

**What goes wrong:** Setting `height (px 44)` on an `el` wrapping text causes the text to be top-aligned by default, not vertically centered.
**Why it happens:** elm-ui elements default to top alignment unless `centerY` is explicitly added.
**How to avoid:** Add `Element.centerY` to the wrapper `el` attributes AND to the inner text element if it's in a column context.
**Warning signs:** Tap zone is 44px but text appears at the top of the element.

### Pitfall 2: `wrappedRow` Group Nav Wrapping at 320px

**What goes wrong:** 12 group letters (A–L) with spacing 8 in a `wrappedRow` may wrap onto two lines at very narrow screens.
**Why it happens:** 12 × (letter + spacing) ≈ 12 × (9 + 8) = ~204px — this fits in 296px content width. But with 44px height tap zones and 8px horizontal padding per letter: 12 × (9 + 8 + 8 + 8) = 12 × 33 = 396px — does NOT fit in 296px and will wrap to two lines.
**How to avoid:** Wrapping is acceptable per the locked decisions ("Group nav letters A–L at 320px — whether to wrap, scroll, or resize" is Claude's discretion). Two lines of 6 letters is the correct behavior and maintains usability. No special handling needed beyond the `wrappedRow` already in place.
**Warning signs:** Letters stack into more than 2 rows (would indicate padding is too large).

### Pitfall 3: Score Button Grid Total Width at 320px

**What goes wrong:** The keyboard grid has 7 buttons per row × 46px each = 322px — already wider than 320px viewport.
**Why it happens:** `scoreButton_` sets `width (px 46)` and `spacing 2` is between items, giving 7 × 46 + 6 × 2 = 334px for the row.
**How to avoid:** For MOB-04, change `height` to `px 44` but do NOT increase the width of score buttons — they would overflow. Width stays at 46px (which is already fine for width target; only height needs fixing). The keyboard grid centers itself and clips gracefully in elm-ui.
**Warning signs:** Horizontal scroll on the score keyboard grid.

### Pitfall 4: `elm/html` Import Missing for `Html.Attributes.attribute`

**What goes wrong:** Adding `Html.Attributes.attribute "inputmode" "numeric"` causes a compilation error if `Html.Attributes` is not imported in `Form/GroupMatches.elm`.
**Why it happens:** `Form/GroupMatches.elm` does not currently import `Html.Attributes` (only `Html.Events` is imported for touch events).
**How to avoid:** Add `import Html.Attributes` at the top of the file before using `Html.Attributes.attribute`.
**Warning signs:** Elm compiler error "Could not find module Html.Attributes".

### Pitfall 5: `preventDefaultOn "touchend"` Scope Audit

**What goes wrong:** The touch handler in `viewScrollWheel` uses `preventDefaultOn "touchend"` which prevents default browser behavior globally on that column. This is intentional for the scroll wheel, but adding larger tap zones to elements inside the scroll wheel could interfere.
**Why it happens:** The touch handler is on the outer `Element.column` containing the scroll items. MOB-02 (group nav) is OUTSIDE the scroll wheel column, so it's safe. MOB-01 scroll line items are inside it — click handlers already work because `SelectMatch` fires on `onClick`, not touch.
**How to avoid:** Keep `preventDefaultOn "touchend"` scoped to `viewScrollWheel`'s column only (already the case). Do not add touch handlers to group nav letters.
**Warning signs:** Tapping group nav letters triggers scroll behavior.

---

## Code Examples

Verified patterns from official sources:

### `Element.minimum` for minimum height (elm-ui 1.1.8 source)
```elm
-- Source: https://github.com/mdgriffith/elm-ui/blob/master/src/Element.elm
minimum : Int -> Length -> Length

-- Usage: element grows to fill but never smaller than 44px
Element.el
    [ Element.height (Element.fill |> Element.minimum 44)
    , Element.Events.onClick msg
    ]
    (Element.text "A")

-- Simpler: fixed 44px height (preferred for isolated tap zones)
Element.el
    [ Element.height (Element.px 44)
    , Element.centerY
    , Element.Events.onClick msg
    ]
    (Element.el [ Element.centerY ] (Element.text "A"))
```

### `Html.Attributes.attribute` for inputmode (elm/html 1.0.0)
```elm
-- Source: https://github.com/elm/html/blob/master/src/Html/Attributes.elm
-- attribute : String -> String -> Attribute msg

import Html.Attributes

-- In elm-ui Input.text attributes list:
Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")
```

### Screen-conditional padding in View.elm
```elm
-- Source: UI/Screen.elm (existing project code)
-- Screen.device : Size -> Device   returns Phone | Computer

let
    hPad =
        case Screen.device model.screen of
            Screen.Phone -> 8
            Screen.Computer -> 24
in
Element.paddingEach { top = 24, right = hPad, bottom = 40, left = hPad }
```

---

## File-by-File Change Map

This phase touches exactly these files:

| File | Requirements | Change Summary |
|------|-------------|----------------|
| `src/View.elm` | SCR-03, MOB-03 | Reduce page padding for `Phone`; `navlink` height bump |
| `src/UI/Button.elm` | MOB-03 | `pill`, `navlink` — change `height (px 30/34)` to `height (px 44)` |
| `src/UI/Button/Score.elm` | MOB-04 | Change `height (px 26/28)` to `height (px 44)` |
| `src/Form/GroupMatches.elm` | MOB-01, MOB-02, SCR-01, SCR-02, SCR-03 | Nav letters: wrap with 44px tap zone; score input: add `inputmode`, widen to 60px |
| `src/Form/Bracket/View.elm` | MOB-05 | Wrap `viewTeamBadge` and `viewPlacedBadge` with 44×44px outer `el` |
| `src/Form/View.elm` | MOB-06 | `clickableCheck` — wrap with `height (px 44)` |

---

## State of the Art

| Old Approach | Current Approach | Notes |
|--------------|------------------|-------|
| `type_="number"` for numeric inputs | `inputmode="numeric"` with `type="text"` | Better iOS compatibility, no value parsing side effects |
| Fixed `px N` height on all buttons | `px 44` minimum touch target | Apple HIG and Material Design both recommend 44–48px minimum |

---

## Open Questions

1. **Score button grid width at 320px**
   - What we know: 7 buttons × 46px + 6 × 2px spacing = 334px total per row; 320px content area (even after padding fix) may clip the grid.
   - What's unclear: Whether elm-ui clips or scrolls when a row overflows its parent; and whether the score button grid is centered within the card or full-width.
   - Recommendation: During implementation, test on a 320px-width emulator. If the grid clips, the fix is to reduce button width from 46px to 40px (7 × 40 + 6 × 2 = 292px — fits). MOB-04 only requires height ≥ 44px; width reduction is compatible.

2. **`Screen.device` thread-through to `Form/GroupMatches.elm`**
   - What we know: `model.screen` exists in the `Model` record; `Form.GroupMatches.view` receives only `Bet` and `State`.
   - What's unclear: Whether `Screen.Size` needs to be added to `GroupMatches.State` or passed separately to `view`.
   - Recommendation: If SCR-03 layout change is handled in `View.elm`/`Form/View.elm` (outer padding reduction), no change to `GroupMatches.view` signature is needed. If per-element conditional sizing is needed inside `GroupMatches.elm`, pass `Screen.Size` as a third parameter to `view`.

---

## Sources

### Primary (HIGH confidence)
- `https://github.com/mdgriffith/elm-ui/blob/master/src/Element.elm` — `minimum`, `maximum` type signatures confirmed
- `https://github.com/elm/html/blob/master/src/Html/Attributes.elm` — `attribute : String -> String -> Attribute msg` confirmed; `inputmode` not natively exposed (must use `attribute`)
- Project source files read directly — current heights, widths, and padding values confirmed

### Secondary (MEDIUM confidence)
- `https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element` — elm-ui 1.1.8 API page (dynamically rendered, content not extractable; structure confirmed by GitHub source)
- Apple Human Interface Guidelines: 44×44pt minimum touch target (widely established standard; confirmed by multiple accessibility references)

### Tertiary (LOW confidence)
- `inputmode="numeric"` iOS 12.2+ compatibility — referenced in multiple Elm community discussions; recommend manual test on device during verification

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — no new packages; all APIs confirmed in source
- Architecture: HIGH — elm-ui `px 44` / wrapping `el` pattern is idiomatic and confirmed
- Root cause (SCR-03 overflow): HIGH — calculated from actual padding values in source
- `inputmode` iOS support: MEDIUM — functional on modern iOS confirmed in community; recommend device test
- Score button grid width at 320px: LOW — needs empirical verification during implementation

**Research date:** 2026-02-24
**Valid until:** 2026-03-24 (elm-ui 1.1.8 is stable; no breaking changes expected)
