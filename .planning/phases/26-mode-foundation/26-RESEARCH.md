# Phase 26: Mode Foundation - Research

**Researched:** 2026-03-14
**Domain:** Elm SPA state management, URL routing, touch event handling, UI status bar
**Confidence:** HIGH

## Summary

Phase 26 introduces a `testMode : Bool` flag on the Model and wires up three activation paths: (1) navigating to `#test` sets the flag via `UrlChange`/`getApp`, (2) tapping the app title five times increments a counter in model state and fires `ActivateTestMode` at count 5, (3) all navigation items become unconditionally visible when `testMode` is true. A visible `[TEST MODE]` badge is appended to the right side of the existing `viewStatusBar`.

The project already has a working pattern for URL-driven app switching (`getApp` in `View.elm`), touch-event handling via `Html.Events.on "touchstart"` in `Form/GroupMatches.elm`, and a bottom status bar (`viewStatusBar`) that is the natural home for the TEST MODE badge. No new ports, subscriptions, or modules are needed — this is entirely pure Elm model additions and view changes.

**Primary recommendation:** Add `testMode : Bool` and `titleTapCount : Int` to `Model`, add `ActivateTestMode`, `TitleTap`, and `DeactivateTestMode` (reserved) to `Msg`, handle `#test` in `getApp`, render a click-counter on the nav title area, and extend `viewStatusBar` and `linkList` to respect `testMode`.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| elm-ui (`mdgriffith/elm-ui`) | 1.1.8 | Layout and events | Already in use throughout |
| Elm core (`Browser`, `Url`) | 0.19.1 | URL parsing, Browser.application | Already in use |

No new dependencies required. Everything this phase needs is already present in the codebase.

**Installation:** None needed.

## Architecture Patterns

### Recommended Model Changes

```elm
-- In Types.elm, Model alias
type alias Model msg =
    { ...
    , testMode : Bool          -- NEW: MODE-01, MODE-02, MODE-03, MODE-04
    , titleTapCount : Int      -- NEW: MODE-02 tap counter
    }
```

```elm
-- In Types.init
init formId sz navKey =
    { ...
    , testMode = False
    , titleTapCount = 0
    }
```

### New Msg Variants

```elm
-- In Types.elm, Msg type
type Msg
    = ...
    | ActivateTestMode          -- sets testMode = True, resets titleTapCount
    | TitleTap                  -- increments titleTapCount; fires ActivateTestMode at 5
```

### Pattern 1: URL Route Activation (MODE-01)

`getApp` in `View.elm` returns `(App, Cmd Msg)`. For `#test` we do not change `App` (no new page); instead we emit `ActivateTestMode` as the command.

**What:** Handle `"test" :: _` in `getApp` to dispatch `ActivateTestMode`.
**When to use:** User navigates to `#test` in the browser — works on desktop and mobile.

```elm
-- In View.elm, getApp inspect function
"test" :: _ ->
    ( Home, ActivateTestMode )
```

This is consistent with other routes that pair an `App` value with a side-effect `Msg`. `Home` is shown while test mode activates; the URL stays `#test` which is fine.

### Pattern 2: Title Tap Counter (MODE-02)

The app title "Voetbalpool" is currently only the `title` field of `Browser.Document` (a browser tab title string) — it is **not** rendered as a visible elm-ui element. For the tap target to exist on screen, a title element must be added to the navigation area in `View.elm`.

The navigation area in `View.elm` currently renders `links` (a wrappedRow of nav links) with no preceding title. The plan should add a tappable title element above or within the `links` block.

**Existing touch pattern (from `Form/GroupMatches.elm`):**

```elm
-- Source: src/Form/GroupMatches.elm lines 295-301
touchStartAttr =
    Element.htmlAttribute
        (Html.Events.on "touchstart"
            (Json.Decode.map TouchStart
                (Json.Decode.at [ "touches", "0", "clientY" ] Json.Decode.float)
            )
        )
```

For the title tap, we do not need the Y coordinate — just `onClick` (works for both mouse and touch):

```elm
-- Title element in View.elm
Element.el
    [ Element.Events.onClick TitleTap
    , Element.pointer
    , Font.color Color.orange
    , UI.Font.mono
    , Font.size (UI.Font.scaled 1)
    ]
    (Element.text "Voetbalpool")
```

`update` for `TitleTap`:

```elm
TitleTap ->
    let
        newCount = model.titleTapCount + 1
    in
    if newCount >= 5 then
        ( { model | testMode = True, titleTapCount = 0 }, Cmd.none )
    else
        ( { model | titleTapCount = newCount }, Cmd.none )

ActivateTestMode ->
    ( { model | testMode = True, titleTapCount = 0 }, Cmd.none )
```

### Pattern 3: TEST MODE Badge in Status Bar (MODE-03)

`viewStatusBar` in `View.elm` already renders a right-aligned `v2026` version string. The TEST MODE badge replaces or supplements it when `testMode` is true.

```elm
-- In viewStatusBar, modify the right-side element
, Element.el
    [ Element.alignRight
    , Font.color
        (if model.testMode then Color.activeNav else Color.grey)
    , UI.Font.mono
    , Font.size (UI.Font.scaled 0)
    ]
    (Element.text
        (if model.testMode then "[TEST MODE]  v2026" else "v2026")
    )
```

### Pattern 4: All Nav Items Visible in Test Mode (MODE-04)

`linkList` in `View.elm` currently gates items behind `model.token`:

```elm
linkList =
    case model.token of
        RemoteData.Success (Token _) ->
            [ Home, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]

        _ ->
            [ Home, Ranking, Form ]
```

In test mode, always show all items. The full list is:
`[ Home, Form, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]`

```elm
linkList =
    if model.testMode then
        [ Home, Form, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]

    else
        case model.token of
            RemoteData.Success (Token _) ->
                [ Home, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]

            _ ->
                [ Home, Ranking, Form ]
```

### Anti-Patterns to Avoid

- **New App variant for test mode:** `testMode : Bool` on Model is orthogonal to navigation (confirmed in STATE.md decisions). Do not add a `TestMode` App variant — that would require exhaustive case matches across View.elm, Form.View.elm, and anywhere `model.app` is matched.
- **Port/JS for the tap counter:** The 5-tap counter is pure Elm model state — no JS needed.
- **Changing URL on ActivateTestMode:** The URL stays `#test` after navigation. Do not push a new URL. The app stays on `Home` visually.
- **Using touchstart for the title tap:** `onClick` is sufficient — it works on both mouse and mobile touch. The `touchstart`/`touchend` pattern in GroupMatches is needed to intercept scroll gestures, not here.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| URL routing | Custom URL parser | Existing `getApp` pattern | Already handles fragment routing |
| Touch events | Custom JS port | `Element.Events.onClick` | Sufficient for tap detection on mobile |
| Persistent test mode | localStorage port | Session-only Bool on Model | Scope decision from STATE.md |

## Common Pitfalls

### Pitfall 1: App Title Not Rendered as Element
**What goes wrong:** `title = "Voetbalpool"` in `view` is the browser document title (`Browser.Document.title`), not a rendered element. There is no current elm-ui element for the app name.
**Why it happens:** The `view` function uses `title` only in `{ title = title, body = [...] }` — it never appears in `page` or `links`.
**How to avoid:** Add a dedicated title `Element.el` in the `links` block (or above it) in `View.elm`. The tap handler goes on this new element.
**Warning signs:** If you add `onClick TitleTap` to an existing element and nothing happens on mobile, the element may not be where you think.

### Pitfall 2: `getApp` Only Fires on UrlChange, Not UrlRequest
**What goes wrong:** `UrlRequest` in `update` only handles `#home` and `#formulier` fragments specifically. All other fragments including `#test` go through `UrlChange` which calls `getApp`.
**Why it happens:** The `UrlRequest` handler has a small explicit switch that defaults to `Home`. `UrlChange` uses `getApp` which handles all routes.
**How to avoid:** Add `"test"` to `getApp`'s `inspect` function. Also update `UrlRequest` handler if needed — but for `#test` navigation via address bar, `UrlChange` is what fires.

### Pitfall 3: linkList Shows Login/Bets Items That Require Auth
**What goes wrong:** Showing `Login`, `EditMatchResult`, `RankingDetailsView`, `BetsDetailsView` in test mode nav could expose broken admin pages.
**Why it happens:** These `App` variants exist but are not in any normal `linkList`.
**How to avoid:** The test mode `linkList` should mirror the authenticated list exactly: `[ Home, Form, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]`. Do not add Login, EditMatchResult, or admin-only items.

### Pitfall 4: Model Alias Has `msg` Type Parameter
**What goes wrong:** `Model msg` (not `Model`) is the type. Adding fields requires updating both the alias definition AND `Types.init` function AND anywhere the full model record is constructed.
**Why it happens:** `Model Msg` is the concrete type used in Main; `Model msg` is the generic alias.
**How to avoid:** Add `testMode : Bool` and `titleTapCount : Int` to the `type alias Model msg` record, and initialize both in `Types.init`. Search for other `init`-like construction sites.

### Pitfall 5: Exposing New Msg Variants
**What goes wrong:** New `Msg` variants added to `Types.elm` but not exposed in the `module Types exposing (...)` list — compiler error in Main.elm.
**Why it happens:** `Types.elm` has an explicit exposing list: `Msg(..)` — the `..` means all constructors are auto-exposed. Actually `Msg(..)` exposes all variants, so this is NOT a pitfall for Msg. But `Model` fields are not separately exposed — they are used through the alias.
**How to avoid:** `Msg(..)` in the exposing list already exposes all variants. New Msg constructors are automatically available once added to the `Msg` type.

## Code Examples

### Touch/click event on elm-ui element (existing pattern)

```elm
-- Source: src/Form/GroupMatches.elm (lines 297-309)
-- For Y-position capture. For simple tap, just use onClick:
Element.el
    [ Element.Events.onClick TitleTap
    , Element.pointer
    ]
    (Element.text "Voetbalpool")
```

### Fragment route returning a Cmd Msg (existing pattern)

```elm
-- Source: src/View.elm getApp function
"home" :: _ ->
    ( Home, RefreshActivities )

-- New pattern for test mode:
"test" :: _ ->
    ( Home, ActivateTestMode )
```

### Conditional element visibility (existing pattern in viewStatusBar)

```elm
-- Source: src/View.elm viewStatusBar
Element.el [ Element.alignRight, Font.color Color.grey, UI.Font.mono, Font.size (UI.Font.scaled 0) ]
    (Element.text "v2026")

-- Extended pattern:
Element.el
    [ Element.alignRight
    , Font.color (if model.testMode then Color.activeNav else Color.grey)
    , UI.Font.mono
    , Font.size (UI.Font.scaled 0)
    ]
    (Element.text (if model.testMode then "[TEST MODE]  v2026" else "v2026"))
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Separate card for each group (12 group cards) | Single `GroupMatchesCard` with scroll | Issue #91 | Fewer Card variants |
| `BracketCard` + `BracketKnockoutsCard` | Single `BracketCard` with wizard | Issue #81 | Fewer Card variants |

No state-of-the-art changes relevant to this phase's domain.

## Open Questions

1. **Title element placement**
   - What we know: No visible title element exists currently in the nav area
   - What's unclear: Should the title sit above the link row, or replace/precede the first link?
   - Recommendation: Add it as the first element in the `links` column in `View.elm`, above the wrappedRow of link items. This is visually consistent with typical terminal app headers.

2. **titleTapCount reset**
   - What we know: Requirement says 5 taps activates test mode
   - What's unclear: Should the counter reset after a timeout (to avoid accidental activation over time)?
   - Recommendation: No timeout — CLAUDE.md says no `Debug.log` and no subscriptions beyond what exists. A simple counter that never resets (until activation fires) is correct for this phase. Future enhancement if needed.

3. **UrlRequest handler for #test**
   - What we know: `UrlRequest` in `update` explicitly handles only `"home"` and `"formulier"` — everything else falls through to `Home`. `UrlChange` calls `getApp`.
   - What's unclear: When user types `#test` in address bar, does `UrlRequest` or `UrlChange` fire?
   - Recommendation: In a `Browser.application`, typing a hash URL and pressing Enter fires `UrlChange` (not `UrlRequest`). `UrlRequest` fires when clicking `<a>` links. Adding `#test` to `getApp` is sufficient. No change to `UrlRequest` handler needed.

## Validation Architecture

> `workflow.nyquist_validation` is not present in `.planning/config.json` — treating as enabled.

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None — `elm-test` is not configured (per CLAUDE.md) |
| Config file | None |
| Quick run command | `make build` (compilation is the test) |
| Full suite command | `make build` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| MODE-01 | `#test` URL activates test mode | manual-smoke | `make build` (compile check) | N/A |
| MODE-02 | 5 title taps activates test mode | manual-smoke | `make build` (compile check) | N/A |
| MODE-03 | TEST MODE badge visible in status bar | manual-smoke | `make build` (compile check) | N/A |
| MODE-04 | All nav items visible in test mode | manual-smoke | `make build` (compile check) | N/A |

**Manual-only justification:** No `elm-test` suite exists and CLAUDE.md confirms "No test suite — `elm-test` is not configured." Verification is: `make build` passes (no compiler errors), then manually open browser and verify each requirement.

### Sampling Rate
- **Per task commit:** `make build`
- **Per wave merge:** `make build`
- **Phase gate:** `make build` green + manual browser verification before `/gsd:verify-work`

### Wave 0 Gaps
None — no test infrastructure exists and none is being added. The only gate is `make build`.

## Sources

### Primary (HIGH confidence)
- Direct source read: `src/Types.elm` — Model alias, Msg type, init function
- Direct source read: `src/View.elm` — getApp, viewStatusBar, linkList, view layout
- Direct source read: `src/Main.elm` — update function, UrlRequest/UrlChange handlers
- Direct source read: `src/Form/GroupMatches.elm` / `Types.elm` — touch event pattern
- Direct source read: `.planning/STATE.md` — architectural decisions for v1.5
- Direct source read: `.planning/REQUIREMENTS.md` — MODE-01 through MODE-04 definitions
- Direct source read: `CLAUDE.md` — Elm conventions, no elm-test, module patterns

### Secondary (MEDIUM confidence)
- None needed — all findings are from direct source inspection.

### Tertiary (LOW confidence)
- None.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — no new dependencies; all existing
- Architecture: HIGH — directly derived from reading source files
- Pitfalls: HIGH — identified from actual code structure (title not rendered, UrlRequest limitation, linkList pattern)

**Research date:** 2026-03-14
**Valid until:** 2026-04-14 (stable Elm codebase)

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| MODE-01 | User can enter test mode by navigating to `#test` URL route | `getApp` in View.elm handles fragment routes; add `"test" :: _ -> (Home, ActivateTestMode)` |
| MODE-02 | User can enter test mode by tapping the app title 5 times on mobile/PWA | Add tappable title element to View.elm nav area; `titleTapCount : Int` on Model; `TitleTap` Msg |
| MODE-03 | User sees a persistent TEST MODE badge while test mode is active | `viewStatusBar` already has right-aligned text; extend with conditional `[TEST MODE]` text |
| MODE-04 | All navigation items are visible in test mode regardless of tournament state | `linkList` in View.elm is gated on `model.token`; bypass gate when `model.testMode == True` |
</phase_requirements>
