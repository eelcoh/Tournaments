# Phase 28: Dummy Results - Research

**Researched:** 2026-03-14
**Domain:** Elm test-mode dummy data injection for results pages
**Confidence:** HIGH

## Summary

Phase 28 injects dummy data into four results pages (`#stand`, `#uitslagen`, `#groepsstand`, `#knock-out`) when `model.testMode` is true. The pattern is identical to Phase 27: add testMode guards in `Main.elm` before the `Cmd.none`/HTTP-dispatch call site, and create static dummy values in new `TestData.*.elm` modules.

Three of the four pages share a single data source (`model.matchResults : WebData MatchResults`) — `#uitslagen` and `#groepsstand` both render from it, and `RefreshResults` feeds both. The `#stand` page reads `model.ranking : WebData RankingSummary` via `RefreshRanking`. The `#knock-out` page reads `model.knockoutsResults : DataStatus (WebData KnockoutsResults)` via `RefreshKnockoutsResults`.

The key insight is that dummy MatchResults can be derived mechanically from `Bets.Init.matches` (the 48 group matches already defined in the project) using the existing `Results.Matches.initialMatchesToResults` helper, then scores are patched on top. This avoids hand-writing team IDs. KnockoutsResults requires enumerating all 48 teams with per-team round status lists, which is the most complex piece. RankingSummary is the simplest — a flat list of RankingGroup records with made-up names and points.

**Primary recommendation:** Create two new modules (`TestData.MatchResults` and `TestData.Ranking`) for the simpler data. For KnockoutsResults, add the dummy value directly in `TestData.MatchResults` or a dedicated `TestData.KnockoutsResults` module. Guard `RefreshRanking`, `RefreshResults`, and `RefreshKnockoutsResults` in Main.elm — three branches, same testMode guard pattern as Phase 27.

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| RES-01 | User sees dummy bettors rankings on #stand page in test mode | `model.ranking : WebData RankingSummary`; guard `RefreshRanking` in Main.update; inject `Success dummyRankingSummary` |
| RES-02 | User sees dummy match results on #uitslagen page in test mode | `model.matchResults : WebData MatchResults`; guard `RefreshResults` in Main.update; inject `Success dummyMatchResults` |
| RES-03 | User sees dummy group standings on #groepsstand page in test mode | Same `model.matchResults` as RES-02 — `#groepsstand` derives standings by computing from matchResults; no separate data needed |
| RES-04 | User sees dummy knockout bracket results on #knock-out page in test mode | `model.knockoutsResults : DataStatus (WebData KnockoutsResults)`; guard `RefreshKnockoutsResults`; inject `Fresh (Success dummyKnockoutsResults)` |
</phase_requirements>

## Standard Stack

### Core (no new dependencies)

| Module | Version | Purpose | Why Standard |
|--------|---------|---------|--------------|
| `TestData.MatchResults` | new | Static `MatchResults` and `KnockoutsResults` dummy values | Follows TestData.Activities pattern from Phase 27 |
| `TestData.Ranking` | new | Static `RankingSummary` dummy value | Same pattern |
| `src/Main.elm` | existing | Three testMode guards added | All HTTP bypass happens in Main.update |

No new elm.json dependencies. All types already exist in `src/Types.elm` and `src/Bets/Types.elm`.

### Installation

None — no new packages.

## Architecture Patterns

### Recommended Project Structure

New files:
```
src/TestData/
├── Activities.elm     (Phase 27, exists)
├── MatchResults.elm   (Phase 28, new — MatchResults + KnockoutsResults)
└── Ranking.elm        (Phase 28, new — RankingSummary)
```

### Pattern 1: testMode guard in Main.update (same as Phase 27)

**What:** Before the `else` HTTP dispatch, check `model.testMode` and inject `RemoteData.Success dummyValue`.
**When to use:** Every Refresh* branch in Main.update that corresponds to a results page.

```elm
-- RefreshRanking (currently):
RefreshRanking ->
    case model.ranking of
        Success _ ->
            ( model, Cmd.none )

        _ ->
            ( model, Ranking.fetchRanking )

-- After change:
RefreshRanking ->
    if model.testMode then
        ( { model | ranking = RemoteData.Success TestData.Ranking.dummyRankingSummary }, Cmd.none )

    else
        case model.ranking of
            Success _ ->
                ( model, Cmd.none )

            _ ->
                ( model, Ranking.fetchRanking )
```

```elm
-- RefreshResults (currently):
RefreshResults ->
    case model.matchResults of
        Success _ ->
            ( model, Cmd.none )

        _ ->
            ( model, Matches.fetchMatchResults )

-- After change:
RefreshResults ->
    if model.testMode then
        ( { model | matchResults = RemoteData.Success TestData.MatchResults.dummyMatchResults }, Cmd.none )

    else
        case model.matchResults of
            Success _ ->
                ( model, Cmd.none )

            _ ->
                ( model, Matches.fetchMatchResults )
```

```elm
-- RefreshKnockoutsResults (currently always fires HTTP):
RefreshKnockoutsResults ->
    let
        cmd =
            Knockouts.fetchKnockoutsResults
    in
    ( model, cmd )

-- After change:
RefreshKnockoutsResults ->
    if model.testMode then
        ( { model | knockoutsResults = Fresh (RemoteData.Success TestData.MatchResults.dummyKnockoutsResults) }, Cmd.none )

    else
        ( model, Knockouts.fetchKnockoutsResults )
```

### Pattern 2: Deriving MatchResults from Bets.Init.matches

**What:** `Results.Matches.initialMatchesToResults` already converts `List Match` → `MatchResults` with all scores as `Nothing`. Patch scores by creating a scoring helper.
**When to use:** For `dummyMatchResults` — do not hand-write 48 match records.

```elm
-- Source: Results/Matches.elm line 231
-- initialMatchesToResults : List Match -> MatchResults
-- Produces MatchResults { results = List MatchResult } with score = Nothing for all matches

import Bets.Init
import Results.Matches

dummyMatchResults : MatchResults
dummyMatchResults =
    let
        base =
            Results.Matches.initialMatchesToResults Bets.Init.matches

        patchScore matchId h a mr =
            if mr.match == matchId then
                { mr | score = Just ( Just h, Just a ) }
            else
                mr

        addScores mrs =
            List.map
                (\mr ->
                    case mr.match of
                        "m01" -> { mr | score = Just ( Just 2, Just 1 ) }
                        "m02" -> { mr | score = Just ( Just 1, Just 1 ) }
                        -- ... patch a representative subset, leave rest as Nothing
                        _ -> mr
                )
                mrs
    in
    { base | results = addScores base.results }
```

**Key insight for groepsstand (RES-03):** `Results.GroupStandings.view` calls `computeStandings results.results` internally — it derives standings from `model.matchResults` directly. No separate dummy data needed. Once `dummyMatchResults` is injected, the groepsstand page works automatically.

### Pattern 3: KnockoutsResults structure

**What:** `KnockoutsResults = { teams : List ( String, TeamRounds ) }` where each entry is `( teamID, { team : Team, roundsQualified : List ( Round, HasQualified ) } )`. For WC2026, each of the 48 teams needs 5 rounds (R1–R5 for knockouts; R6 = champion round).

The simplest approach: derive the team list from `Bets.Init.teamData` (which is `List TeamDatum` where each has `.team`). Map each team to a `TeamRounds` with all rounds set to `TBD` except for a few high-profile teams marked `In` for rounds they "won":

```elm
import Bets.Init
import Bets.Types exposing (HasQualified(..), Round(..))
import Types exposing (KnockoutsResults, TeamRounds)

dummyKnockoutsResults : KnockoutsResults
dummyKnockoutsResults =
    let
        allRounds =
            [ R1, R2, R3, R4, R5, R6 ]

        mkTeamRounds team =
            { team = team
            , roundsQualified =
                List.map (\r -> ( r, TBD )) allRounds
            }

        teamEntry td =
            ( td.team.teamID, mkTeamRounds td.team )
    in
    { teams = List.map teamEntry Bets.Init.teamData }
```

This produces a valid `KnockoutsResults` where all teams are TBD. The view renders each team with round toggle buttons. This is sufficient for RES-04 — it shows the knockout results page populated with team cards rather than the "..." placeholder.

### Anti-Patterns to Avoid

- **Don't import `Results.Matches` in TestData modules**: `initialMatchesToResults` is in `Results.Matches` but importing it from TestData creates a layering issue. Either copy the match-to-result conversion logic inline (it's 5 lines) or import `Bets.Types.Match` functions directly. Alternatively, add a helper to `Bets.Init` that exposes this conversion — but simplest is to inline the conversion.
- **Don't guard `FetchedMatchResults`**: Only guard the `Refresh*` branches (the ones that fire HTTP). The `Fetched*` branches must remain untouched since they handle real API responses.
- **Don't forget `RefreshResults` fires for both `#uitslagen` and `#groepsstand`**: View.elm routes both `"wedstrijden"` (Results) and `"groepsstand"` (GroupStandings) through `RefreshResults`. One guard covers both.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| 48 MatchResult records | Manual record construction | `initialMatchesToResults Bets.Init.matches` | The function already does this; team IDs are authoritative in Tournament.elm |
| 48 TeamRounds entries | Manual list | `List.map teamEntry Bets.Init.teamData` | teamData is the single source of truth for all 48 WC2026 teams |
| Group standings computation | Separate dummy standings | reuse existing `computeStandings` in GroupStandings.elm | The view already computes standings from matchResults — inject matchResults, get standings for free |

**Key insight:** Three of the four requirements are served by two data injections (RankingSummary + MatchResults). KnockoutsResults is independent but can be derived from `Bets.Init.teamData` with a one-liner map.

## Common Pitfalls

### Pitfall 1: RefreshKnockoutsResults always fires HTTP (no caching guard)
**What goes wrong:** Unlike `RefreshRanking` and `RefreshResults` which check for existing `Success _` before fetching, `RefreshKnockoutsResults` unconditionally fires `Knockouts.fetchKnockoutsResults`. Adding a testMode guard must be the outermost check.
**Why it happens:** The knockouts results use `DataStatus` wrapper and the branch is simpler.
**How to avoid:** Wrap the entire branch body: `if model.testMode then ... else ( model, Knockouts.fetchKnockoutsResults )`.

### Pitfall 2: KnockoutsResults uses DataStatus wrapper
**What goes wrong:** `model.knockoutsResults` is `DataStatus (WebData KnockoutsResults)`, not `WebData KnockoutsResults`. Injecting just `RemoteData.Success` without the `Fresh` wrapper will cause a type mismatch.
**How to avoid:** Inject `Fresh (RemoteData.Success dummyKnockoutsResults)`.

### Pitfall 3: RankingSummary.time field requires Time.Posix
**What goes wrong:** `RankingSummary = { summary : List RankingGroup, time : Time.Posix }`. The `time` field is used to display "bijgewerkt op ..." in the ranking view. Using `Time.millisToPosix 0` gives epoch date — readable but ugly. Use a plausible 2026 tournament timestamp.
**How to avoid:** Use `Time.millisToPosix 1750000000000` (approx June 2026) for all dummy timestamps.

### Pitfall 4: initialMatchesToResults is not exported from a public module
**What goes wrong:** `Results.Matches.initialMatchesToResults` exists at line 231 but is used only internally (it appears in the `initialise` function and the `module Results.Matches exposing (..)` exposes all). Since the module uses `exposing (..)`, it IS accessible from TestData.MatchResults. However, importing `Results.*` from `TestData.*` creates a circular dependency risk if TestData is ever used in Results.
**How to avoid:** Inline the 5-line conversion in TestData.MatchResults rather than importing from Results.Matches. It is:
```elm
matchToResult m =
    { match = M.id m
    , group = M.group m
    , homeTeam = M.homeTeam m
    , awayTeam = M.awayTeam m
    , score = Nothing
    }
```
Then apply `List.map matchToResult Bets.Init.matches`.

### Pitfall 5: testMode guard position for RefreshRanking
**What goes wrong:** `RefreshRanking` has an inner `case model.ranking of Success _ -> ( model, Cmd.none )` caching guard. If testMode guard is placed inside the `_ ->` branch instead of at the top, navigating to `#stand` twice (where first navigation already set ranking to `NotAsked`) would work, but revisiting after test mode activation with existing `Success` data would NOT re-inject dummy data. Since test mode is only active in test sessions and ranking starts as `NotAsked`, this is low risk — but wrap the entire branch for correctness.
**How to avoid:** Put `if model.testMode then` as the outermost check in `RefreshRanking`, identical to how `RefreshResults` and `RefreshKnockoutsResults` are guarded.

## Code Examples

### dummyRankingSummary structure
```elm
-- Types: RankingSummary = { summary : List RankingGroup, time : Time.Posix }
-- Types: RankingGroup = { pos : Int, bets : List RankingSummaryLine, total : Int }
-- Types: RankingSummaryLine = { name : String, rounds : List RoundScore, topscorer : Int, total : Int, uuid : String }
-- Types: RoundScore = { round : String, points : Int }

dummyRankingSummary : RankingSummary
dummyRankingSummary =
    { summary =
        [ { pos = 1
          , bets =
              [ { name = "Jan", rounds = [ { round = "group", points = 18 } ], topscorer = 5, total = 23, uuid = "dummy-jan" }
              ]
          , total = 23
          }
        , { pos = 2
          , bets =
              [ { name = "Pieter", rounds = [ { round = "group", points = 15 } ], topscorer = 0, total = 15, uuid = "dummy-pieter" }
              , { name = "Sophie", rounds = [ { round = "group", points = 15 } ], topscorer = 0, total = 15, uuid = "dummy-sophie" }
              ]
          , total = 15
          }
        , { pos = 3
          , bets =
              [ { name = "Eelco", rounds = [ { round = "group", points = 12 } ], topscorer = 0, total = 12, uuid = "dummy-eelco" }
              ]
          , total = 12
          }
        ]
    , time = Time.millisToPosix 1750000000000
    }
```

### dummyMatchResults derivation (inline approach)
```elm
-- In src/TestData/MatchResults.elm
import Bets.Init
import Bets.Types.Match as M
import Types exposing (MatchResult, MatchResults)

dummyMatchResults : MatchResults
dummyMatchResults =
    let
        matchToResult m =
            { match = M.id m
            , group = M.group m
            , homeTeam = M.homeTeam m
            , awayTeam = M.awayTeam m
            , score = Nothing
            }

        patchScore matchId h a mr =
            if mr.match == matchId then
                { mr | score = Just ( Just h, Just a ) }
            else
                mr

        withScores =
            List.map matchToResult Bets.Init.matches
                |> List.map (patchScore "m01" 3 1)
                |> List.map (patchScore "m02" 1 1)
                |> List.map (patchScore "m03" 2 0)
                -- patch a representative set — 12+ matches across different groups
    in
    { results = withScores }
```

### dummyKnockoutsResults derivation
```elm
-- In src/TestData/MatchResults.elm
import Bets.Init
import Bets.Types exposing (HasQualified(..), Round(..))
import Types exposing (KnockoutsResults, TeamRounds)

dummyKnockoutsResults : KnockoutsResults
dummyKnockoutsResults =
    let
        knockoutRounds =
            [ R1, R2, R3, R4, R5, R6 ]

        mkTeamRounds t =
            { team = t
            , roundsQualified = List.map (\r -> ( r, TBD )) knockoutRounds
            }

        teamEntry td =
            ( td.team.teamID, mkTeamRounds td.team )
    in
    { teams = List.map teamEntry Bets.Init.teamData }
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Direct HTTP fetch on navigation | testMode guard before fetch call | Phase 26/27 established pattern | No API call in test mode |
| No offline support | testMode flag on Model | Phase 26 | All phases build on this flag |

## Open Questions

None — all data types are fully defined in Types.elm, all fetch branches are located in Main.elm, and the pattern is established from Phase 27.

## Validation Architecture

The config.json does not have `workflow.nyquist_validation` set to `false` (key is absent). However, the project has no test suite (`elm-test` is not configured per CLAUDE.md). Validation is manual only.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None — `elm-test` not configured |
| Config file | None |
| Quick run command | `make build` (compiler validation only) |
| Full suite command | `make build` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| RES-01 | #stand shows dummy ranking in test mode | manual | `make build` (compiler) | N/A |
| RES-02 | #uitslagen shows dummy match results in test mode | manual | `make build` (compiler) | N/A |
| RES-03 | #groepsstand shows dummy group standings in test mode | manual | `make build` (compiler) | N/A |
| RES-04 | #knock-out shows dummy knockout bracket in test mode | manual | `make build` (compiler) | N/A |

### Sampling Rate

- **Per task commit:** `make build`
- **Per wave merge:** `make build`
- **Phase gate:** `make build` green before `/gsd:verify-work`

### Wave 0 Gaps

None — existing infrastructure (Makefile, elm compiler) covers all phase validation.

## Sources

### Primary (HIGH confidence)

- `src/Types.elm` — RankingSummary, RankingGroup, RankingSummaryLine, RoundScore, MatchResults, MatchResult, KnockoutsResults, TeamRounds, DataStatus type definitions (read directly)
- `src/Main.elm` — RefreshRanking (line 734), RefreshResults (line 807), RefreshKnockoutsResults (line 890) branches (read directly)
- `src/Results/Ranking.elm` — view renders from `model.ranking : WebData RankingSummary` (read directly)
- `src/Results/Matches.elm` — `initialMatchesToResults` helper, view renders from `model.matchResults` (read directly)
- `src/Results/GroupStandings.elm` — derives standings from `model.matchResults` via `computeStandings` (read directly)
- `src/Results/Knockouts.elm` — view renders from `model.knockoutsResults : DataStatus (WebData KnockoutsResults)` (read directly)
- `src/TestData/Activities.elm` — Phase 27 pattern (read directly)
- `src/View.elm` — route-to-Msg mapping for all four pages (read directly)
- `src/Bets/Init.elm` — `matches` and `teamData` exports (read directly)
- `src/Bets/Init/WorldCup2026/Tournament/Teams.elm` — team IDs and groups (read directly)
- `.planning/phases/27-dummy-activities-and-offline-submission/27-01-PLAN.md` — established testMode guard pattern (read directly)

### Secondary (MEDIUM confidence)

None needed — all findings sourced directly from codebase.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — no new dependencies; pattern is established
- Architecture: HIGH — all data types and fetch branches verified in source
- Pitfalls: HIGH — identified from direct code inspection (DataStatus wrapper, caching guard structure, initialMatchesToResults layering)

**Research date:** 2026-03-14
**Valid until:** 2026-04-14 (stable Elm project, no external dependencies changing)
