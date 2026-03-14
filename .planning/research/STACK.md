# Stack Research: Test/Demo Mode for Elm 0.19.1 SPA

**Domain:** Adding test/demo mode to an existing Elm 0.19.1 football betting SPA
**Researched:** 2026-03-14
**Confidence:** HIGH — all patterns verified against existing codebase + Elm core docs

---

## Executive Recommendation

**Zero new packages required.** Every capability needed for test/demo mode is already available via Elm's standard library (`elm/html`, `elm/json`, `elm/core`) and the existing `Html.Events` / `Element.Events` machinery already used in this codebase. The implementation is purely an Elm architecture exercise.

---

## Recommended Stack

### Core Technologies (unchanged)

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Elm 0.19.1 | 0.19.1 | SPA runtime | Already in use; all test-mode features achievable within it |
| elm/html | 1.0.0 | Event handling | `Html.Events.on` with custom JSON decoders handles tap-N detection |
| mdgriffith/elm-ui | 1.1.8 | UI layout | `Element.htmlAttribute` bridges elm-ui to raw HTML events; already used for touch in GroupMatches |
| elm/json | 1.1.3 | Event decoders | `Json.Decode.succeed` / `Json.Decode.andThen` used for custom event payloads |

### Supporting Libraries (no new additions)

All libraries already in `elm.json`. No additions needed.

---

## Pattern 1: Test Mode Flag in Model

**Approach:** Add `testMode : Bool` to `Types.Model`.

**Why this and not a separate `App` variant:** Test mode is a cross-cutting concern — it affects the nav visibility, the activities feed, the results pages, and the dashboard's "Fill all" button simultaneously. A `Bool` flag propagated through the existing `model` parameter (which every view function already receives) is the minimal-impact change. A separate `App` variant would only route to one view at a time.

**Integration point:** `Types.elm` — add field to `Model` and initialize to `False` in `init`.

```elm
-- Types.elm
type alias Model msg =
    { ...
    , testMode : Bool
    }

-- init
init formId sz navKey =
    { ...
    , testMode = False
    }
```

**Activation paths:** Two separate triggers both dispatch the same `ActivateTestMode` Msg:
1. URL hash `#test` detected in `getApp` (View.elm)
2. Tap-title-5× gesture (see Pattern 2)

**Confidence:** HIGH — established TEA pattern, zero risk.

---

## Pattern 2: Tap-N-Times Detection (5 taps on title element)

**Approach:** Track tap count in `Model` with a counter field; send a `Msg` on each tap; activate test mode when counter reaches N.

**No external package needed.** This is pure Elm state management.

**Key insight from existing codebase:** The project already uses `Element.el [Element.Events.onClick msg, Element.pointer]` (documented in MEMORY.md) to add click handlers to non-interactive elements. The same pattern applies here.

**Counter field in Model:**

```elm
-- Types.elm
type alias Model msg =
    { ...
    , testMode : Bool
    , titleTapCount : Int   -- resets to 0 on activation or after N seconds (optional)
    }
```

**Msg variants:**

```elm
-- Types.elm
type Msg
    = ...
    | TitleTapped           -- increments counter; activates test mode at 5
    | ActivateTestMode
```

**Update logic:**

```elm
TitleTapped ->
    let
        newCount = model.titleTapCount + 1
    in
    if newCount >= 5 then
        ( { model | titleTapCount = 0, testMode = True }, Cmd.none )
    else
        ( { model | titleTapCount = newCount }, Cmd.none )

ActivateTestMode ->
    ( { model | testMode = True, titleTapCount = 0 }, Cmd.none )
```

**View — wrapping the title element:**

```elm
-- In the nav/header view, wrap existing title text
Element.el
    [ Element.Events.onClick TitleTapped
    , Element.pointer
    , Element.padding 8   -- grow tap target
    ]
    (UI.Text.displayHeader "Voetbalpool")
```

**Confidence:** HIGH — `Element.Events.onClick` and counter-in-model are canonical Elm patterns with no edge cases in this context.

**Tap decay (optional but recommended):** A time-based reset (clear counter after ~2 seconds between taps) prevents accidental slow clicks accumulating. Implementation: store `lastTapTime : Maybe Time.Posix` in Model and check in `TitleTapped` via `Time.now` Task. Keep this out of MVP if complexity is unwanted — the 5-tap requirement is already an unlikely accidental trigger.

---

## Pattern 3: URL Hash Route Detection (#test)

**Approach:** Extend the existing `getApp` function in `View.elm`.

The current routing uses `String.split "/" hash` and pattern matches on the head. Adding `#test` is one extra case:

```elm
-- View.elm, inside inspect function
"test" :: _ ->
    ( Home, ActivateTestMode )
```

`ActivateTestMode` is a new `Msg` that sets `model.testMode = True`.

**Why this works cleanly:** `getApp` already returns `( App, Cmd Msg )`. The `Msg` value is dispatched in `Main.update` via the existing `UrlChange` handler. No new infrastructure needed.

**Confidence:** HIGH — mirrors the exact pattern used for every other route in the codebase.

---

## Pattern 4: Dummy Data Injection

**Approach:** Static Elm values in a new `TestData` module, conditionally substituted at the view layer.

**Where to inject:** At the `view` dispatch in `View.elm` and `Activities.elm` — the outermost boundary before data reaches the UI. The Model's `WebData` fields remain untouched (no mutation of `model.matchResults` etc.) to avoid polluting the real state machine.

**Recommended structure:**

```
src/TestData.elm          -- static dummy Activity list, MatchResults, KnockoutsResults, etc.
```

**Substitution pattern (in view functions):**

```elm
-- Instead of: Results.Ranking.view model
-- Use:
let
    effectiveModel =
        if model.testMode then
            { model | ranking = Success TestData.dummyRanking }
        else
            model
in
Results.Ranking.view effectiveModel
```

This keeps the substitution entirely in the view layer. `update` never sees dummy data. The real `WebData` fields are untouched if the user deactivates test mode.

**Alternative — pass `testMode` down and branch inside each view:** More verbose, more coupling. Rejected in favour of model-substitution at the dispatch boundary.

**For Activities specifically:** The existing `SaveComment` Msg dispatches `Activities.saveComment model.activities` which issues an HTTP `Cmd`. In test mode, intercept in `update`:

```elm
SaveComment ->
    if model.testMode then
        -- Append locally, no HTTP
        let
            newActivity = CommentActivity (buildActivityFromComment model.activities.comment)
            oldActivities = model.activities
            newActivities = { oldActivities
                | activities = RemoteData.map (\acts -> acts ++ [newActivity]) oldActivities.activities
                , comment = Types.initComment
                , showComment = False
                }
        in
        ( { model | activities = newActivities }, Cmd.none )
    else
        ( model, Activities.saveComment model.activities )
```

**"Fill all" button on DashboardCard:** Dispatch a new `FillAllAnswers` Msg that runs a pure Elm function over `model.bet` to fill every match score, set every qualifier, and set a topscorer — all returning a new `Bet` value with no Cmds. This is the standard Elm pattern for batch state mutation.

**Confidence:** HIGH for the structural pattern. MEDIUM for the exact `FillAllAnswers` implementation detail (depends on Bracket API surface — verify `Bracket.setBulk` signature before writing).

---

## Pattern 5: Persistent Test Mode Badge

**Approach:** Conditional `Element.inFront` overlay in the existing status bar column.

The codebase already uses `inFront` for the install banner and status bar (documented in PROJECT.md: "Single inFront column for banner+statusbar"). Add a `[ TEST MODE ]` badge to that same column when `model.testMode == True`.

```elm
-- View.elm, in the inFront overlay column
if model.testMode then
    Element.el
        [ Element.alignTop
        , Element.alignRight
        , Font.color Color.activeNav
        , Font.family [ Font.monospace ]
        , Element.padding 4
        ]
        (Element.text "[ TEST ]")
else
    Element.none
```

**Confidence:** HIGH — direct reuse of existing overlay mechanism.

---

## What NOT to Add

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| `elm-explorations/test` (elm-test) | Only for automated unit tests; adds dev dependency, requires elm-test runner — irrelevant for runtime test mode | Counter-in-model + static TestData module |
| `avh4/elm-program-test` | Integration testing library, not a runtime feature | Not applicable |
| Workbox / service worker for offline dummy data | Complexity with no benefit; test mode is a UI concern, not a caching concern | Pure Elm model substitution |
| New port for tap-counting in JS | Unnecessary; Elm handles click events natively via `Element.Events.onClick` | Counter-in-model pattern |
| `elm/random` for dummy data | Deterministic dummy data is easier to reason about and debug | Hard-coded `TestData.elm` static values |
| Separate `TestApp` route/App variant | Would require duplicating all view dispatch; cross-cutting concern | `testMode : Bool` flag in Model |

---

## Alternatives Considered

| Recommended | Alternative | Why Not |
|-------------|-------------|---------|
| `testMode : Bool` in Model | Separate `TestMode` wrapper type around Model | Wrapper adds complexity to every pattern match; Bool is sufficient for a binary flag |
| Static `TestData.elm` module | JSON fixtures loaded via HTTP | HTTP adds async complexity and network dependency; static Elm values compile to zero runtime cost |
| Counter-in-model for tap detection | `Browser.Events.onClick` subscription | Global click subscription fires on every click everywhere; element-scoped onClick is more precise |
| Model substitution at view dispatch boundary | Injecting dummy data into real model fields in `update` | Pollutes update logic; makes deactivation harder; view-layer substitution is simpler |
| Intercept `SaveComment` in `update` with `testMode` guard | Port to JS for local storage | Overcomplicated; the Msg already passes through `update`, so guarding there is natural |

---

## Installation

No new packages. No `elm install` commands needed.

---

## Version Compatibility

All patterns use existing locked versions. No compatibility concerns.

| Capability | Uses | Version |
|------------|------|---------|
| Click event on elm-ui element | `Element.Events.onClick` | mdgriffith/elm-ui 1.1.8 |
| Custom touch decoder | `Html.Events.on`, `Json.Decode` | elm/html 1.0.0, elm/json 1.1.3 |
| Model flag | Elm core record syntax | elm/core 1.0.5 |
| Static dummy data | Elm list/record literals | elm/core 1.0.5 |

---

## Sources

- Existing codebase — `src/Form/GroupMatches.elm` lines 297-308: verified `Html.Events.on "touchstart"` + `preventDefaultOn "touchend"` pattern with `Json.Decode.at` decoder (HIGH confidence)
- Existing codebase — `src/View.elm` lines 576-634: verified hash-based routing via `String.split "/" hash` pattern matching (HIGH confidence)
- Existing codebase — `src/Ports.elm`: verified port pattern for JS-to-Elm communication (HIGH confidence)
- Existing codebase — `src/Main.elm` lines 412-417: verified `SaveComment` dispatches `Activities.saveComment` — interception point confirmed (HIGH confidence)
- MEMORY.md: `Element.el [Element.Events.onClick msg, Element.pointer]` for click on non-interactive badge — confirmed pattern (HIGH confidence)
- PROJECT.md key decisions: "Single inFront column for banner+statusbar", "DashboardCard has no payload (reads Model directly)" — confirmed overlay and model-read patterns (HIGH confidence)
- [Elm Discourse — click detection patterns](https://discourse.elm-lang.org/t/how-to-implement-onclick-listener-for-only-when-clicked-directly/1873) — WebSearch corroborates counter-in-model as standard approach (MEDIUM confidence, consistent with codebase evidence)
- [Flags guide — elm-lang.org](https://guide.elm-lang.org/interop/flags.html) — flags pattern for passing test mode at init if needed (MEDIUM confidence)

---

*Stack research for: Test/Demo Mode — Elm 0.19.1 SPA (v1.5 milestone)*
*Researched: 2026-03-14*
