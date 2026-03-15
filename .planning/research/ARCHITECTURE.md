# Architecture Research

**Domain:** Test/Demo Mode integration into existing Elm 0.19.1 TEA SPA
**Researched:** 2026-03-14
**Confidence:** HIGH — based on direct inspection of all relevant source files

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Browser.application                       │
│              Main.elm (init / update / view)                 │
├───────────────────────┬─────────────────────────────────────┤
│     View.elm          │      URL fragment routing (getApp)   │
│  (top-level dispatch) │  #home #formulier #stand etc.        │
├───────────┬───────────┴──────────────────┬──────────────────┤
│  Form/*   │       Results/*              │  Activities.elm  │
│ Dashboard │  Ranking / Matches /         │  (activities +   │
│ GroupMatch│  Knockouts / Topscorers /    │   comments feed) │
│ Bracket   │  GroupStandings / Bets       │                  │
├───────────┴──────────────────────────────┴──────────────────┤
│                    src/Types.elm                             │
│    Model | Msg | Card | App | WebData fields                 │
├─────────────────────────────────────────────────────────────┤
│   API.Bets   │  Activities (HTTP)  │  Results.* (HTTP)       │
│  /bets/ POST │ /activities/ GET/   │  /bets/results/* GET    │
│              │   POST              │                         │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | File(s) |
|-----------|----------------|---------|
| `Types.elm` | Centralized `Model`, `Msg`, `Card`, `App`, `DataStatus`, `WebData` fields | `src/Types.elm` |
| `Main.elm` | `init`, `update`, `subscriptions` — all app state transitions | `src/Main.elm` |
| `View.elm` | Top-level `view`, URL routing (`getApp`), nav rendering | `src/View.elm` |
| `Form/Dashboard.elm` | Dashboard card view; reads full `Model Msg` directly | `src/Form/Dashboard.elm` |
| `Activities.elm` | Activity feed view + HTTP fetch/save + JSON encode/decode | `src/Activities.elm` |
| `API/Bets.elm` | Bet placement HTTP (POST/PUT `/bets/`) | `src/API/Bets.elm` |
| `Results/*` | Per-page results views + their own HTTP fetch functions | `src/Results/` |
| `Bets/Bet.elm` | `isComplete`, `setMatchScore`, `setQualifier`, `setWinner`, `setTopscorer` | `src/Bets/Bet.elm` |
| `Bets/Init.elm` | Static `bet`, `teamData`, `groupsAndFirstMatch` values | `src/Bets/Init.elm` |
| `Ports.elm` | JS interop: `onBeforeInstallPrompt`, `persistDismiss`, `triggerInstall` | `src/Ports.elm` |

## Integration Points for Test/Demo Mode

The following maps each v1.5 feature to the exact components that require change.

### Feature 1: testMode Flag in Model

**Where it lives:** `src/Types.elm` — add `testMode : Bool` to the `Model` alias and `init` function.

**Why here:** Every downstream component receives `model` and can branch on `model.testMode`. No new type is needed — a plain `Bool` suffices. The existing flat Model pattern (`installBannerDismissCount`, `betState`, `idx`) establishes this precedent.

**Modified:** `src/Types.elm` (Model alias, init function)

---

### Feature 2: #test Route Activation

**Where it lives:** `src/View.elm` — `getApp` parses URL fragments via `case fragment of`.

**Current pattern:**
```elm
"home" :: _ ->
    ( Home, RefreshActivities )
```

**Required change:** Add a `"test" :: _` branch returning `( Home, ActivateTestMode )`. `ActivateTestMode` is a new `Msg` variant in `Main.update` that sets `model.testMode = True` and dispatches `RefreshActivities`.

`App` type does NOT need a new variant. Test mode is a Model flag, not a distinct page. The `#test` route navigates to `Home` with test mode activated.

**Modified:** `src/Types.elm` (new `ActivateTestMode` Msg), `src/View.elm` (`getApp`), `src/Main.elm` (`update` handler)

---

### Feature 3: Test Mode Badge (persistent UI indicator)

**Where it lives:** `src/View.elm` — `viewStatusBar` renders the bottom status bar overlay.

**Recommended approach:** Add a `[TEST]` prefix to `statusText` when `model.testMode == True`. This reuses the existing bottom bar without a new overlay layer.

**Modified:** `src/View.elm` (`viewStatusBar`)

---

### Feature 4: All Nav Items Visible in Test Mode

**Where it lives:** `src/View.elm` — `linkList` is currently gated on `model.token`:
```elm
case model.token of
    RemoteData.Success (Token _) ->
        [ Home, Ranking, Results, GroupStandings, KOResults, TSResults, Blog, Bets ]
    _ ->
        [ Home, Ranking, Form ]
```

**Required change:** When `model.testMode == True`, always use the full nav list regardless of `model.token`.

**Modified:** `src/View.elm` (`linkList` computation in `view`)

---

### Feature 5: Dummy Activities (lorem ipsum feed)

**Where it lives:** `src/Main.elm` — `RefreshActivities` handler calls `Activities.fetchActivities` (HTTP GET).

**Required change:** Branch on `model.testMode` before issuing HTTP:

```elm
RefreshActivities ->
    if model.testMode then
        let
            oldActivities = model.activities
            newActivities = { oldActivities | activities = Success TestData.dummyActivities }
        in
        ( { model | activities = newActivities }, Cmd.none )
    else
        ( model, Activities.fetchActivities model.activities )
```

**Where dummy data lives:** New module `src/TestData.elm` exposing `dummyActivities : List Activity`. The `Activity` type constructors (`AComment`, `APost`) are already defined in `src/Types.elm`.

**New module:** `src/TestData.elm`
**Modified:** `src/Main.elm` (`RefreshActivities` handler)

---

### Feature 6: Offline Activity Submission

**Where it lives:** `src/Main.elm` — `SaveComment` dispatches `Activities.saveComment model.activities` (HTTP POST). `SavePost` similarly calls `Activities.savePost`.

**Required change:** Branch on `model.testMode`:

```elm
SaveComment ->
    if model.testMode then
        let
            meta = { date = Time.millisToPosix 0, active = True, uuid = "test-comment" }
            newActivity = AComment meta model.activities.comment.author model.activities.comment.msg
            oldActs = model.activities
            newActs =
                { oldActs
                | activities = RemoteData.map ((::) newActivity) oldActs.activities
                , comment = Types.initComment
                , showComment = False
                }
        in
        ( { model | activities = newActs }, Cmd.none )
    else
        ( model, Activities.saveComment model.activities )
```

**Timestamp note:** `Time.millisToPosix 0` (epoch) is used as the synthetic timestamp. The terminal display shows `[01:00]` (UTC+1 in NL timezone). This is visually distinct and signals a demo entry. Using actual current time would require `Task.perform GotTime Time.now` and an additional `Msg` — unnecessary complexity for demo use.

**Modified:** `src/Main.elm` (`SaveComment`, `SavePost` handlers)

---

### Feature 7: "Fill All" Button on Dashboard Card

**Where it lives:** `src/Form/Dashboard.elm` — pure view function reading `model`. `src/Main.elm` — handles the resulting `Msg`.

**Msg:** Add `FillAll` to `src/Types.elm`. Handle in `Main.update`:
```elm
FillAll ->
    if model.testMode then
        ( { model | bet = TestData.filledBet, betState = Dirty }, Cmd.none )
    else
        ( model, Cmd.none )
```

**Where fill logic lives:** `src/TestData.elm` — expose `filledBet : Bet`. This is a `Bet` with:
- All 36 group match scores set via `Bets.Bet.setMatchScore` applied across `Bets.Init.matches`
- Bracket qualifiers set via `Bets.Bet.setQualifier` (using known WC2026 first/second place slots)
- Topscorer set via `Bets.Bet.setTopscorer`
- Participant fields filled via `Bets.Bet.setParticipant`

**Key constraint on bracket:** `Form.Bracket.assignBestThirds` (greedy best-third assignment) lives in `src/Form/Bracket.elm`. Importing `Form/Bracket` from `TestData` would create a circular dependency if `Form/Bracket` imports `TestData`. The safest approach: hardcode a valid pre-assigned bracket `Bet` in `TestData.elm` using the known WC2026 slot structure, without calling wizard functions. The WC2026 best-third slots (T1-T8) and their valid group combos are deterministic and documented in project memory.

**View change:** `src/Form/Dashboard.elm` — add a `[[ fill all ]]` button at the bottom of the view, visible only when `model.testMode`. Button emits `FillAll`.

**New module:** `src/TestData.elm` (exposes `filledBet`)
**Modified:** `src/Types.elm` (new `FillAll` Msg), `src/Main.elm` (handler), `src/Form/Dashboard.elm` (conditional button)

---

### Feature 8: Dummy Results on All Results Pages

**Affected pages:** `#stand` (Ranking), `#wedstrijden` (Matches), `#groepsstand` (GroupStandings), `#knockouts` (KOResults), `#topscorer` (TSResults).

**Current flow:** Route handlers in `getApp` dispatch `Refresh*` Msgs. `Main.update` handles them and issues HTTP. `Model` stores results as `WebData` fields.

**Required change:** Branch on `model.testMode` in each handler:

| Handler | Model field | Dummy value |
|---------|-------------|-------------|
| `RefreshRanking` | `model.ranking` | `Success TestData.dummyRanking` |
| `RefreshResults` | `model.matchResults` | `Success TestData.dummyMatchResults` |
| `RefreshKnockoutsResults` | `model.knockoutsResults` | `Fresh (Success TestData.dummyKnockoutsResults)` |
| `RefreshTopscorerResults` | `model.topscorerResults` | `Fresh (Success TestData.dummyTopscorerResults)` |

Note: `knockoutsResults` and `topscorerResults` are wrapped in `DataStatus` (`Fresh | Filthy | Stale`). The dummy value uses `Fresh`.

**Where dummy data lives:** `src/TestData.elm` — one constant per results page.

**Modified:** `src/Main.elm` (4 `Refresh*` handlers), `src/TestData.elm` (new dummy data constants)

---

### Feature 9: Tap-Title-N-Times Gesture

**Precedent:** `GroupMatches` scroll wheel tracks `touchStartY : Maybe Float` in card state. The same "small counter in Model" pattern applies here.

**Where it lives:** `titleTapCount : Int` on `Model` in `src/Types.elm`. `TapTitle` added to `Msg`.

**Handler in Main.update:**
```elm
TapTitle ->
    let
        newCount = model.titleTapCount + 1
        shouldActivate = newCount >= 5
    in
    ( { model
        | titleTapCount = if shouldActivate then 0 else newCount
        , testMode = model.testMode || shouldActivate
      }
    , Cmd.none
    )
```

**View change:** Wrap the app title or a header element in `viewHome` in `src/View.elm` with `Element.Events.onClick TapTitle`. No new UI component needed — a plain `Element.el [Element.Events.onClick TapTitle, Element.pointer]` wrapper on the title text suffices.

**Modified:** `src/Types.elm` (`titleTapCount : Int` in Model + `TapTitle` Msg), `src/Main.elm` (handler), `src/View.elm` (onClick on title element)

## Recommended Project Structure

```
src/
├── Main.elm              -- update: testMode branches in Refresh*, Save*, SubmitMsg
├── Types.elm             -- Model: +testMode, +titleTapCount; Msg: +ActivateTestMode, +FillAll, +TapTitle
├── View.elm              -- getApp: +#test route; linkList: testMode override; viewStatusBar: badge; title onClick
├── Ports.elm             -- unchanged
├── Activities.elm        -- unchanged (HTTP bypass at Main.update callsite)
├── Form/
│   └── Dashboard.elm     -- add conditional [fill all] button when model.testMode
├── TestData.elm          -- NEW: dummyActivities, filledBet, dummyRanking, dummyMatchResults,
│                         --      dummyKnockoutsResults, dummyTopscorerResults
└── API/
    └── Bets.elm          -- unchanged (bet submission bypass at Main.update callsite)
```

### Structure Rationale

- **TestData.elm at src/ root:** All dummy data in one file, importable from `Main.elm` and `Form/Dashboard.elm`. Avoids scattered test fixtures. Co-located with other top-level modules.
- **No new API/ module:** HTTP bypass lives in `Main.update` branches, not in API modules. Preserves the existing pattern where API modules are pure call wrappers.
- **No new App variant:** Test mode is orthogonal to navigation. A `Bool` flag composes with any `App` state without requiring exhaustive pattern matching updates in `View.elm` and `viewStatusBar`.

## Architectural Patterns

### Pattern 1: testMode Guard in update

**What:** Every handler that would issue an HTTP `Cmd` checks `model.testMode` first and substitutes a `Success dummyData` model update with `Cmd.none`.

**When to use:** All `Refresh*` handlers, `SaveComment`, `SavePost`, `SubmitMsg`.

**Trade-offs:** Slightly verbose but maximally explicit. No new abstractions. The compiler enforces exhaustive case matching so nothing is accidentally missed when the Msg type grows.

**Example:**
```elm
RefreshRanking ->
    if model.testMode then
        ( { model | ranking = Success TestData.dummyRanking }, Cmd.none )
    else
        case model.ranking of
            Success _ -> ( model, Cmd.none )
            _ -> ( model, Ranking.fetchRanking )
```

---

### Pattern 2: Single TestData Module

**What:** All dummy data lives in one new `src/TestData.elm` module. No test data is inlined in production modules.

**When to use:** Whenever a dummy value is needed. Import `TestData` only from `Main.elm` and `Form/Dashboard.elm`.

**Trade-offs:** Dummy data is always compiled into the production binary (Elm has no conditional compilation). For this SPA at ~20K LOC, the increase is negligible. The alternative — separate test/production entry points — is out of scope and would require build system changes.

---

### Pattern 3: Model Flag for Cross-Cutting State

**What:** `testMode : Bool` and `titleTapCount : Int` added directly to `Model` (flat, not nested in a sub-record).

**When to use:** For boolean or small integer state that multiple views and update handlers need to read. Follows existing precedent: `installBannerDismissCount`, `betState`, `idx` are all flat fields.

**Trade-offs:** A `testState` sub-record would add noise without benefit for 2 fields. Flat model is idiomatic Elm.

## Data Flow

### Test Mode Activation Flow

```
User navigates to #test
    ↓
View.elm getApp: "test" :: _ -> ( Home, ActivateTestMode )
    ↓
Main.update ActivateTestMode:
    model.testMode = True
    dispatch RefreshActivities
    ↓
Main.update RefreshActivities (model.testMode = True):
    inject Success TestData.dummyActivities
    no HTTP
    ↓
Activities.view renders dummy feed
```

### Tap Gesture Activation Flow

```
User taps title 5 times
    ↓
View.elm: Element.Events.onClick TapTitle on title element
    ↓
Main.update TapTitle (count 1..4): increment titleTapCount
Main.update TapTitle (count 5): testMode = True, titleTapCount = 0
    ↓
View.elm viewStatusBar: shows [TEST] prefix
View.elm linkList: shows full nav
```

### Fill All Flow

```
User taps [fill all] on Dashboard (model.testMode = True)
    ↓
Form.Dashboard.view emits FillAll
    ↓
Main.update FillAll:
    model.bet = TestData.filledBet
    model.betState = Dirty
    no navigation, no HTTP
    ↓
Form.Dashboard.view re-renders:
    all sections show [x]
    allDoneBanner appears
```

### Results Dummy Data Flow

```
User navigates to #stand
    ↓
View.elm getApp: "stand" :: _ -> ( Ranking, RefreshRanking )
    ↓
Main.update RefreshRanking (model.testMode = True):
    model.ranking = Success TestData.dummyRanking
    no HTTP
    ↓
Results.Ranking.view model renders with dummy data
```

### Offline Comment Flow

```
User types comment, taps [prik!]
    ↓
SaveComment Msg
    ↓
Main.update SaveComment (model.testMode = True):
    construct AComment with epoch meta (posixToMillis 0)
    prepend to model.activities.activities via RemoteData.map
    clear comment fields
    no HTTP
```

## Anti-Patterns

### Anti-Pattern 1: New App Variant for TestMode

**What people do:** Add `TestMode` to the `App` type and add a case in `view`'s dispatch.

**Why it's wrong:** Test mode is not a page — it is a cross-cutting behavioral flag. Adding it as an `App` variant forces nav, `viewStatusBar`, and `view` dispatch to handle it everywhere. A Model `Bool` propagates automatically.

**Do this instead:** `testMode : Bool` in `Model`. Check it at the callsites that matter.

---

### Anti-Pattern 2: Intercepting HTTP at the API Layer

**What people do:** Modify `API.Bets`, `Activities.fetchActivities`, `Results.Ranking.fetchRanking` etc. to accept a `testMode` flag and return dummy `Cmd`.

**Why it's wrong:** API modules are intentionally thin call wrappers. Adding behavioral branching there mixes concerns and scatters test mode logic across 6+ files.

**Do this instead:** Branch in `Main.update` before calling the API function. API modules stay pure.

---

### Anti-Pattern 3: Storing titleTapCount Inside a Card's State

**What people do:** Put the tap counter in `DashboardCard` state (similar to `GroupMatchesCard GroupMatches.State`).

**Why it's wrong:** The title tap gesture must work from the Home page (`App = Home`), not from the Form card. `DashboardCard` is a Form card and is only rendered when `model.app == Form`. The gesture would be unreachable from `#home`.

**Do this instead:** `titleTapCount : Int` on `Model` directly, with `TapTitle` fired from a tap target in `viewHome` (or the nav header) in `View.elm`.

---

### Anti-Pattern 4: Circular Import via filledBet Calling Wizard Functions

**What people do:** Have `TestData.filledBet` call `Form.Bracket.assignBestThirds` or `Form.Bracket.rebuildBracket`.

**Why it's wrong:** `Form.Bracket` imports `Bets.Types` and `Bets.Bet`. If `TestData` imports `Form.Bracket`, and any future `Form.Bracket` imports `TestData`, a circular dependency exists. Elm does not allow circular module imports.

**Do this instead:** Hardcode a valid fully-assigned `Bet` in `TestData.elm` using the known WC2026 bracket structure and static team codes. The WC2026 slot assignments (T1-T8 best-third rules) are deterministic and documented. No wizard functions are needed.

## Integration Points

### Modified Files Summary

| File | Change | Scope |
|------|--------|-------|
| `src/Types.elm` | Add `testMode : Bool`, `titleTapCount : Int` to Model; add `ActivateTestMode`, `FillAll`, `TapTitle` to Msg; update `init` | Small |
| `src/Main.elm` | Handlers for `ActivateTestMode`, `FillAll`, `TapTitle`; testMode guards in `RefreshActivities`, `RefreshRanking`, `RefreshResults`, `RefreshKnockoutsResults`, `RefreshTopscorerResults`, `SaveComment`, `SavePost` | Medium |
| `src/View.elm` | `getApp` add `"test" :: _` branch; `linkList` testMode override; `viewStatusBar` badge; title element onClick | Small |
| `src/Form/Dashboard.elm` | Conditional `[fill all]` button when `model.testMode` | Small |

### New Files

| File | Contents |
|------|----------|
| `src/TestData.elm` | `dummyActivities : List Activity`, `filledBet : Bet`, `dummyRanking : RankingSummary`, `dummyMatchResults : MatchResults`, `dummyKnockoutsResults : KnockoutsResults`, `dummyTopscorerResults : TopscorerResults` |

### Unchanged Files

All of the following are intentionally NOT modified:

- `src/Activities.elm` — HTTP functions remain; bypassed at call site in `Main.update`
- `src/API/Bets.elm` — HTTP functions remain; bypassed at call site
- `src/Results/*.elm` — fetch functions remain; bypassed at call site
- `src/Ports.elm` — no new JS interop needed for test mode
- `src/index.html` — no JS changes needed (test mode is pure Elm state)

## Suggested Build Order

Phases respect data dependencies. Each phase produces a working increment.

### Phase 1: Model Foundation + Route + Nav + Badge

Add `testMode` and `titleTapCount` to `Model` in `src/Types.elm`. Add `ActivateTestMode` and `TapTitle` to `Msg`. Handle both in `Main.update`. Add `"test" :: _` branch in `getApp`. Add `TapTitle` onClick to the title element in `viewHome`. Add `[TEST]` badge to `viewStatusBar`. Fix `linkList` to show all nav items when `testMode`.

**Dependency:** Nothing — pure Model/Msg scaffolding.
**Deliverable:** `#test` URL activates test mode; 5 taps on title activates test mode; badge appears in status bar; nav shows all items. No dummy data yet.

---

### Phase 2: Dummy Activities + Offline Submission

Create `src/TestData.elm` with `dummyActivities`. Guard `RefreshActivities` in `Main.update`. Guard `SaveComment` and `SavePost`.

**Dependency:** Phase 1 (`model.testMode` must exist).
**Deliverable:** Home page shows lorem ipsum feed in test mode. Comment submission appends locally, no network.

---

### Phase 3: Dummy Results Data

Extend `TestData.elm` with `dummyRanking`, `dummyMatchResults`, `dummyKnockoutsResults`, `dummyTopscorerResults`. Guard the four `Refresh*` handlers in `Main.update`.

**Dependency:** Phase 1 (`model.testMode`). Phase 2 is not a prerequisite — phases 2 and 3 are independent.
**Deliverable:** All 4 results pages render without network in test mode.

---

### Phase 4: Fill All

Extend `TestData.elm` with `filledBet : Bet`. Add `FillAll` to `Msg` and handle in `Main.update`. Add conditional button to `Form/Dashboard.elm`.

**Dependency:** Phase 1 (`model.testMode`). Independent of phases 2 and 3.
**Key effort:** Constructing `filledBet` requires encoding all 36 group match scores, the complete WC2026 bracket with best-third assignments, a topscorer selection, and participant fields. This is the most data-intensive task — use `Bets.Init.bet` as the starting point and apply setters.
**Deliverable:** Tapping `[fill all]` on Dashboard instantly populates the entire bet form.

## Sources

- Direct inspection of `src/Types.elm`, `src/Main.elm`, `src/View.elm`, `src/Activities.elm`, `src/API/Bets.elm`, `src/Form/Dashboard.elm`, `src/Bets/Bet.elm`, `src/Bets/Init.elm`, `src/Ports.elm`, `src/index.html`, `src/Results/Ranking.elm`, `src/Results/Matches.elm`, `src/Results/Knockouts.elm`
- `.planning/PROJECT.md` v1.5 milestone specification
- `CLAUDE.md` project architecture documentation
- `MEMORY.md` for WC2026 bracket slot assignments (T1-T8)

---
*Architecture research for: v1.5 Test/Demo Mode integration into Elm 0.19.1 TEA SPA*
*Researched: 2026-03-14*
