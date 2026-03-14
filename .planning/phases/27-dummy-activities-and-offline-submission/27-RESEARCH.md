# Phase 27: Dummy Activities and Offline Submission - Research

**Researched:** 2026-03-14
**Domain:** Elm activities feed, offline test-mode branching, dummy data injection
**Confidence:** HIGH

## Summary

Phase 27 adds two behaviours that only activate when `model.testMode == True`:

1. **Pre-populated feed** — when the activities page loads in test mode, the `model.activities.activities` WebData is set to `Success [list of dummy Activity values]` instead of `NotAsked`. No HTTP request is made.
2. **Offline append** — when the user submits a comment (`SaveComment`) or a blog post (`SavePost`) in test mode, the new activity is prepended to the in-memory list and the WebData field is updated to `Success newList`. No HTTP request is made.

The implementation is straightforward because the existing codebase already has all the necessary types (`Activity`, `ActivityMeta`, `AComment`, `APost`), the testMode flag on Model, and the exact Msg variants (`SaveComment`, `SavePost`, `FetchedActivities`) that the planner can branch on.

The only new Elm file needed is a `TestData.Activities` (or `TestData.elm` at top level) module that exposes a `List Activity` literal. All existing modules (`Main.elm`, `Types.elm`, `View.elm`, `Activities.elm`) receive only small, surgical changes.

**Primary recommendation:** Add testMode guards at the two call sites in `Main.elm` (`SaveComment` and `SavePost` branches) and one init-time injection point (`RefreshActivities` / `FetchedActivities`), backed by a `src/TestData/Activities.elm` module with static dummy data.

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| ACT-01 | User sees dummy lorem ipsum comments and blog posts on the activities page in test mode | Inject `Success dummyActivities` into `model.activities.activities` at page load time when testMode is True; dummy data defined in TestData.Activities |
| ACT-02 | User can add a comment in test mode; it appends to the list locally without a network call | Guard `SaveComment` branch in Main.update: if testMode, prepend new AComment to existing list; no Cmd |
| ACT-03 | User can add a blog post in test mode; it appends to the list locally without a network call | Guard `SavePost` branch in Main.update: if testMode, prepend new APost to existing list; no Cmd |
</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `elm` | 0.19.1 | Language runtime | Project standard |
| `krisajenkins/remotedata` | 6.0.1 | `WebData` / `Success` / `NotAsked` | Already used for `activities.activities` |
| `Time` (elm/core) | — | `Time.Posix` for `ActivityMeta.date` | Required by `Activity` type |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `elm/core` `Time.millisToPosix` | — | Build fake Posix timestamps for dummy ActivityMeta | Needed for every dummy Activity record |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Static `List Activity` in Elm | JSON fixture file decoded at runtime | Static is simpler, predictable, no decoder risk; JSON overkill for test data |
| Injecting at `RefreshActivities` | Injecting at `UrlChange` / `getApp` | Injecting at `RefreshActivities` keeps logic in one place (Main.update) without touching View/routing |

**Installation:** No new packages required.

## Architecture Patterns

### Recommended Project Structure
```
src/
├── TestData/
│   └── Activities.elm    # new: exposes dummyActivities : List Activity
├── Main.elm              # modified: testMode guards in SaveComment, SavePost, RefreshActivities
├── Types.elm             # no change needed
├── Activities.elm        # no change needed
└── View.elm              # no change needed
```

### Pattern 1: testMode Guard Before HTTP Call

**What:** In `Main.update`, check `model.testMode` before issuing an HTTP `Cmd`. If true, produce a pure state update instead.
**When to use:** Every place a network call would otherwise happen.
**Example:**
```elm
-- In Main.update, SaveComment branch:
SaveComment ->
    if model.testMode then
        let
            newActivity =
                AComment
                    { date = model.timeZone |> always (Time.millisToPosix 0)  -- see Note below
                    , active = True
                    , uuid = "test-comment"
                    }
                    model.activities.comment.author
                    model.activities.comment.msg

            existingList =
                case model.activities.activities of
                    RemoteData.Success acts ->
                        acts

                    _ ->
                        TestData.Activities.dummyActivities

            newList =
                newActivity :: existingList

            oldActivities =
                model.activities

            newActivities =
                { oldActivities
                    | activities = RemoteData.Success newList
                    , comment = Types.initComment
                    , showComment = False
                }
        in
        ( { model | activities = newActivities }, Cmd.none )

    else
        ( model, Activities.saveComment model.activities )
```

**Note on timestamp:** `model.timeZone` is `Time.Zone`, not `Time.Posix`. To get the current time you would need a `Time.now` `Task`. For offline test mode, a fixed fake timestamp (e.g. `Time.millisToPosix 1750000000000`) is sufficient and avoids a round-trip through `Cmd`.

### Pattern 2: Inject Dummy Data at RefreshActivities

**What:** When `RefreshActivities` fires and `model.testMode` is true, immediately set `activities.activities` to `Success dummyActivities` with `Cmd.none`.
**When to use:** This satisfies ACT-01 — the page loads populated without a network round-trip.
**Example:**
```elm
RefreshActivities ->
    if model.testMode then
        let
            oldActivities =
                model.activities

            newActivities =
                { oldActivities | activities = RemoteData.Success TestData.Activities.dummyActivities }
        in
        ( { model | activities = newActivities }, Cmd.none )

    else
        ( model, Activities.fetchActivities model.activities )
```

### Pattern 3: TestData.Activities Module

**What:** A dedicated module with one exported value.
**Example:**
```elm
module TestData.Activities exposing (dummyActivities)

import Time
import Types exposing (Activity(..), ActivityMeta)

dummyActivities : List Activity
dummyActivities =
    [ APost
        { date = Time.millisToPosix 1750000000000, active = True, uuid = "post-1" }
        "Admin"
        "WK 2026 begint!"
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore."
    , AComment
        { date = Time.millisToPosix 1749900000000, active = True, uuid = "comment-1" }
        "Eelco"
        "Ik ga voor Nederland natuurlijk."
    , AComment
        { date = Time.millisToPosix 1749800000000, active = True, uuid = "comment-2" }
        "Pieter"
        "Nederland gaat het niet redden hoor."
    , ANewBet
        { date = Time.millisToPosix 1749700000000, active = True, uuid = "bet-1" }
        "Jan"
        "test-uuid-jan"
    , AComment
        { date = Time.millisToPosix 1749600000000, active = True, uuid = "comment-3" }
        "Sophie"
        "Dit wordt het beste WK ooit!"
    ]
```

### Anti-Patterns to Avoid

- **Modifying `Activities.elm` functions** — `saveComment` and `savePost` in `Activities.elm` should stay unchanged. Branching belongs in `Main.update` only.
- **Adding a new `Msg` variant for test-mode submission** — unnecessary; existing `SaveComment` / `SavePost` Msg variants are reused with an `if model.testMode then` guard.
- **Using `NotAsked` as the sentinel** — STATE.md already documents the decision: "Offline append to activities must handle NotAsked state — set to Success [newActivity] rather than prepend to empty." Use `dummyActivities` as the base list when `NotAsked`.
- **Randomised or time-fetched dummy data** — REQUIREMENTS.md Out of Scope: "Randomized dummy data — Static data is predictable and easier to debug." Use static fixed Posix values.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Fake timestamps | Custom time generation | `Time.millisToPosix <fixed_int>` | Static constant is sufficient; avoids `Task.perform` overhead |
| In-memory list prepend | Custom diffing/deduplication | `newActivity :: existingList` | The existing list is already a plain `List Activity`; `::` is correct and idiomatic |

**Key insight:** The entire offline submission story requires zero new types and zero new Msg variants. It is purely a branching concern in `Main.update`.

## Common Pitfalls

### Pitfall 1: Forgetting NotAsked on First Append
**What goes wrong:** User navigates directly to #home without triggering `RefreshActivities`, so `activities.activities` stays `NotAsked`. Then they submit a comment. `newActivity :: []` works if you handle `NotAsked` → `Success [newActivity]`.
**Why it happens:** `RefreshActivities` fires from `getApp` on normal navigation, but the testMode guard above short-circuits it only if the route triggers `RefreshActivities`. If testMode was just activated via `#test` route (which fires `ActivateTestMode`, not `RefreshActivities`), the list may be `NotAsked` when the user comments.
**How to avoid:** In the `SaveComment` / `SavePost` guards, always extract the existing list with:
```elm
existingList =
    case model.activities.activities of
        RemoteData.Success acts -> acts
        _ -> TestData.Activities.dummyActivities
```
This also ensures a rich list even if the user jumps straight to submitting.

### Pitfall 2: Missing `TestData.Activities` Import in Main.elm
**What goes wrong:** Elm compiler error — module not found.
**Why it happens:** New module in `src/TestData/` must be listed in `elm.json` source-directories or be within the existing `src/` directory (which it is). No elm.json change needed as long as the file is under `src/`.
**How to avoid:** Place the file at `src/TestData/Activities.elm` with module declaration `module TestData.Activities exposing (dummyActivities)`. Import in `Main.elm` as `import TestData.Activities`.

### Pitfall 3: timeZone vs Time.Posix Confusion
**What goes wrong:** Using `model.timeZone` (which is `Time.Zone`) where `Time.Posix` is needed for `ActivityMeta.date`.
**Why it happens:** `Time.Zone` and `Time.Posix` are separate concepts in Elm's Time API.
**How to avoid:** Use `Time.millisToPosix <constant>` for all dummy activity dates. No timezone or clock access needed.

### Pitfall 4: Exhaustive Pattern Match Failures
**What goes wrong:** Adding new branches to existing `case` in `Main.update` accidentally shadowing or missing cases.
**Why it happens:** Elm enforces exhaustive matching; the `SaveComment` and `SavePost` branches already exist and just need `if model.testMode then ... else ...` wrapping their body.
**How to avoid:** Keep existing branch structure; only wrap the existing `cmd =` / return expression inside an `if model.testMode then` guard.

## Code Examples

### ActivityMeta with Fixed Timestamp
```elm
-- Source: Types.elm ActivityMeta definition
{ date = Time.millisToPosix 1750000000000
, active = True
, uuid = "dummy-uuid-1"
}
```

### Prepend Pattern for SaveComment in Test Mode
```elm
-- In Main.update SaveComment:
SaveComment ->
    if model.testMode then
        let
            newActivity =
                AComment
                    { date = Time.millisToPosix 1750000000000, active = True, uuid = "test-submit" }
                    model.activities.comment.author
                    model.activities.comment.msg

            existingList =
                case model.activities.activities of
                    RemoteData.Success acts -> acts
                    _ -> TestData.Activities.dummyActivities

            oldActivities = model.activities

            newActivities =
                { oldActivities
                    | activities = RemoteData.Success (newActivity :: existingList)
                    , comment = Types.initComment
                    , showComment = False
                }
        in
        ( { model | activities = newActivities }, Cmd.none )
    else
        let
            cmd = Activities.saveComment model.activities
        in
        ( model, cmd )
```

### SavePost Test Mode Branch
```elm
SavePost ->
    if model.testMode then
        let
            newActivity =
                APost
                    { date = Time.millisToPosix 1750000000000, active = True, uuid = "test-post" }
                    model.activities.post.author
                    model.activities.post.title
                    model.activities.post.msg

            existingList =
                case model.activities.activities of
                    RemoteData.Success acts -> acts
                    _ -> TestData.Activities.dummyActivities

            oldActivities = model.activities

            newActivities =
                { oldActivities
                    | activities = RemoteData.Success (newActivity :: existingList)
                    , post = Types.initPost
                    , showPost = False
                }
        in
        ( { model | activities = newActivities }, Cmd.none )
    else
        let
            cmd =
                case model.token of
                    RemoteData.Success (Token token) ->
                        Activities.savePost model.activities token
                    _ ->
                        Cmd.none
        in
        ( model, cmd )
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Always call HTTP for activities | testMode guard before HTTP call | Phase 27 (now) | Activities work fully offline in test mode |
| Activities start at `NotAsked` | In test mode, start at `Success dummyActivities` | Phase 27 (now) | Page shows content immediately without network |

## Open Questions

1. **Timestamp for newly submitted test comment/post**
   - What we know: A fixed `Time.millisToPosix` value works and is simplest.
   - What's unclear: Whether the UI shows the timestamp in a way that makes a static value confusing (e.g. showing "1970" or wrong date).
   - Recommendation: Use a WC2026-era millisecond value (e.g. `1750000000000` = approximately June 2025) so dates look plausible. The planner can pick any value in the 2026 tournament window.

2. **Activities page triggered by #home vs #blog**
   - What we know: `viewHome` shows `viewCommentInput + Activities.view`. `viewBlog` shows `viewPostInput + Activities.view`. Both call `Activities.view model` which reads `model.activities.activities`.
   - What's unclear: Should both #home and #blog show the same dummy list? Yes — they both read the same `model.activities.activities`.
   - Recommendation: A single `RefreshActivities` guard injection covers both pages.

## Validation Architecture

No test suite exists and `workflow.nyquist_validation` is not set to false — however CLAUDE.md explicitly states "No test suite — elm-test is not configured." This phase has no automated test infrastructure to leverage.

Manual validation steps:
1. Navigate to `#test`, then `#home` — dummy activities list appears.
2. Navigate to `#test`, then `#home`, fill comment form, click "prik!" — new comment appears at top of list, no network request (check browser DevTools Network tab).
3. Navigate to `#test`, then `#blog`, fill post form, click "post!" — new post appears at top of list, no network request.

### Wave 0 Gaps
None — no test infrastructure exists and none is being added this phase.

## Sources

### Primary (HIGH confidence)
- `src/Main.elm` — `SaveComment`, `SavePost`, `RefreshActivities` branches examined directly; exact pattern confirmed
- `src/Types.elm` — `Activity`, `ActivityMeta`, `Comment`, `Post`, `ActivitiesModel` types confirmed; `testMode : Bool` confirmed on `Model`
- `src/Activities.elm` — `saveComment`, `savePost`, `fetchActivities`, `decode` functions confirmed; view rendering confirmed
- `src/View.elm` — `getApp` routing, `RefreshActivities` fired on `#home`/`#blog`, `viewHome`/`viewBlog` reading `model.activities` confirmed
- `.planning/STATE.md` — "Offline append to activities must handle NotAsked state" decision confirmed; "HTTP bypass via testMode guards in Main.update" pattern confirmed
- `.planning/REQUIREMENTS.md` — ACT-01/ACT-02/ACT-03 requirements confirmed; "Randomized dummy data" out of scope confirmed

### Secondary (MEDIUM confidence)
- `.planning/ROADMAP.md` — Phase 27 success criteria cross-checked

### Tertiary (LOW confidence)
- None

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all types and modules read directly from source
- Architecture: HIGH — branching pattern is straightforward Elm; pattern confirmed against existing testMode implementation in Phase 26
- Pitfalls: HIGH — NotAsked edge case identified from STATE.md decision log; Posix/Zone distinction is a known Elm gotcha

**Research date:** 2026-03-14
**Valid until:** Stable — Elm types do not change unless Model is refactored; valid until next major architecture change
