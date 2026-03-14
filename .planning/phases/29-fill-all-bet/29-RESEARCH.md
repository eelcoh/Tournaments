# Phase 29: Fill All Bet - Research

**Researched:** 2026-03-14
**Domain:** Elm SPA — test mode bet auto-fill, Form.Dashboard, Form.Bracket.rebuildBracket, Bets.Bet.setMatchScore
**Confidence:** HIGH

## Summary

Phase 29 adds a single "fill all" button on the Dashboard card that is only visible when `model.testMode == True`. Tapping it fires a new `Msg` variant (`FillAllBet`) that populates all 36 group-match scores, a complete WC2026 knockout bracket (via `rebuildBracket`), and a topscorer in one atomic `update` branch. No network calls, no new modules required: this is a pure model transformation.

The key architectural invariant (from issue #93 / STATE.md) is that the bracket fill path MUST go through `Form.Bracket.rebuildBracket` to keep `BracketCard`'s `WizardState.selections` in sync with `bet.answers.bracket`. Bypassing `rebuildBracket` and writing directly to `bet.answers.bracket` would leave the wizard state inconsistent and `isWizardComplete` would return wrong results.

After the update the Dashboard `sectionCard` rows derive their completion status from `Form.GroupMatches.isComplete`, `Form.Bracket.isCompleteQualifiers`, and `Form.Topscorer.isComplete` — all of which read from `model.bet`. No extra state fields are needed.

**Primary recommendation:** Add `FillAllBet` to `Msg`, handle it in `Main.update`, create `TestData.Bet` with a static `dummyRoundSelections : RoundSelections` value, call `rebuildBracket` from there, bulk-set group match scores via `List.foldl Bets.Bet.setMatchScore`, set topscorer via `Bets.Bet.setTopscorer`, update `BracketCard` state in `model.cards`, and render the button in `Form.Dashboard.view` behind `if model.testMode`.

## Standard Stack

### Core
| Library / Module | Version | Purpose | Why Standard |
|-----------------|---------|---------|--------------|
| `Form.Bracket.rebuildBracket` | existing | Build `Bracket` tree from `RoundSelections` | Required by #93 invariant — keeps WizardState in sync |
| `Bets.Bet.setMatchScore` | existing | Set a score on a `Bet` | Canonical single-match score setter |
| `Bets.Bet.setTopscorer` | existing | Set topscorer on a `Bet` | Canonical topscorer setter |
| `Form.Card.updateBracketCard` | existing | Update `BracketCard` inside `model.cards` | Already used by `BracketMsg` branch |
| `elm-ui` 1.1.8 | project dep | Button rendering in Dashboard | All UI is elm-ui |

### Supporting
| Module | Purpose | When to Use |
|--------|---------|-------------|
| `TestData.Bet` (new) | Static `RoundSelections` + score map for demo | Created once; consumed by `FillAllBet` handler |
| `Bets.Init.teamData` | Passed to `rebuildBracket` | Same pattern as every `SelectTeam` handler |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `rebuildBracket` via new `FillAllBet` Msg | Replaying many `BracketMsg SelectTeam` events | Replay approach works but is slower; single call is cleaner |
| Separate `TestData.Bet` module | Inline values in `Main.update` | Inline pollutes Main; TestData.* pattern is already established |

**No new packages needed.**

## Architecture Patterns

### Recommended Project Structure
```
src/
├── TestData/
│   ├── Activities.elm   -- exists
│   ├── MatchResults.elm -- exists
│   ├── Ranking.elm      -- exists
│   └── Bet.elm          -- NEW: dummyRoundSelections, dummyGroupScores, dummyTopscorer
├── Form/
│   └── Dashboard.elm    -- add fill-all button behind testMode guard
└── Main.elm             -- add FillAllBet Msg branch
```

### Pattern 1: testMode guard in update (established pattern)
**What:** Outermost `if model.testMode then <inject dummy data> else <normal path>`
**When to use:** All test-mode features; outermost ensures test data always injected
**Example (from existing code):**
```elm
-- src/Main.elm lines ~416, ~546, ~628, ~737, ~814, ~901
if model.testMode then
    ( { model | matchResults = ... dummyData ... }, Cmd.none )
else
    ( model, API.fetchMatchResults )
```

### Pattern 2: TestData.* static module
**What:** Plain Elm module exposing named static values; no dynamic generation
**When to use:** Whenever dummy data is needed in test mode
**Example (from TestData.Activities):**
```elm
module TestData.Activities exposing (dummyActivities)
dummyActivities : List Activity
dummyActivities = [ ... ]
```

### Pattern 3: BracketCard state update alongside bet update
**What:** When modifying bracket data, ALWAYS update both `model.bet` AND the `BracketCard` inside `model.cards`
**When to use:** Any path that changes `bet.answers.bracket`
**Example (from `BracketMsg` branch in Main.update):**
```elm
BracketMsg act ->
    Bracket.update act model.bet bracketState
        |> (\( newBet, newState, fx ) ->
            ( { model
                | bet = newBet
                , betState = Dirty
                , cards = Cards.updateBracketCard model.cards newState
              }
            , Cmd.map BracketMsg fx
            )
           )
```

### FillAllBet implementation pattern
```elm
-- Types.elm — add to Msg
| FillAllBet

-- Main.update
FillAllBet ->
    let
        newBet1 =
            List.foldl
                (\( matchID, score ) b -> Bets.Bet.setMatchScore b matchID score)
                model.bet
                TestData.Bet.dummyGroupScores

        newBracket =
            Form.Bracket.rebuildBracket TestData.Bet.dummyRoundSelections Bets.Init.teamData

        newBet2 =
            Form.Bracket.updateBracket newBet1 newBracket
            -- note: updateBracket is unexported from Form.Bracket, see below

        newBet3 =
            Bets.Bet.setTopscorer newBet2 TestData.Bet.dummyTopscorer

        newBracketState =
            Bracket.State model.screen
                (BracketWizard { selections = TestData.Bet.dummyRoundSelections, viewingRound = Nothing })

        newCards =
            Cards.updateBracketCard model.cards newBracketState
    in
    ( { model | bet = newBet3, betState = Dirty, cards = newCards }
    , Cmd.none
    )
```

**Important:** `Form.Bracket.updateBracket` is currently not exposed in `Form.Bracket`. The planner must either (a) expose it, or (b) inline the bracket update directly using `Bets.Bet`'s `answers` field update pattern. Inlining is fine since `bet.answers.bracket` is `Answer Bracket Points` and the update is `{ answers | bracket = Answer newBracket points }`.

### Dashboard button pattern
```elm
-- Form.Dashboard.view — inside let, before the final UI.Page.page call
fillAllButton =
    if model.testMode then
        Element.el
            [ Element.Events.onClick FillAllBet
            , Element.pointer
            , ...
            ]
            (Element.text "[  fill all  ]")
    else
        Element.none
```

### Anti-Patterns to Avoid
- **Writing directly to `bet.answers.bracket` without calling `rebuildBracket`:** leaves `BracketCard`'s `WizardState.selections` empty — `isWizardComplete` will return `False` even though the bracket is filled.
- **Using `Debug.log` in test helpers:** `--optimize` rejects it.
- **Storing `dummyRoundSelections` as a `let` binding inside `Main.update`:** puts WC2026-specific data in the wrong layer; put it in `TestData.Bet`.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Bracket tree construction | Custom tree walker | `Form.Bracket.rebuildBracket` | Already handles BestThird greedy assignment, winner propagation |
| Score bulk-set | New batch-set function | `List.foldl Bets.Bet.setMatchScore` | One-liner; `setMatchScore` is already atomic per match |
| BracketCard sync | Manual card-list traversal | `Form.Card.updateBracketCard` | Already used by `BracketMsg` branch |

**Key insight:** All the machinery for filling a bet already exists. Phase 29 is pure wiring: create static dummy data, add one `Msg`, write one `update` branch, add one button.

## Common Pitfalls

### Pitfall 1: Bracket/WizardState desync
**What goes wrong:** Dashboard shows `[x]` for bracket but BracketCard shows incorrect/empty state if user navigates to it after fill.
**Why it happens:** `bet.answers.bracket` and `BracketCard`'s `WizardState.selections` are separate; only `rebuildBracket` + `updateBracketCard` keeps both in sync.
**How to avoid:** After calling `rebuildBracket`, build a full `Bracket.State` with the same `RoundSelections` and pass to `Cards.updateBracketCard`.
**Warning signs:** `Form.Bracket.isCompleteQualifiers model.bet` returns `True` but wizard shows empty selections.

### Pitfall 2: Score type mismatch
**What goes wrong:** Compiler error when building score tuples.
**Why it happens:** `Score = ( Maybe Int, Maybe Int )` — both halves are `Maybe Int`, not `Int`.
**How to avoid:** `dummyGroupScores` entries must be `( "m01", ( Just 2, Just 1 ) )` etc.

### Pitfall 3: Incomplete lastThirtyTwo selection
**What goes wrong:** `rebuildBracket` produces a bracket where some slots are `Nothing`; `isCompleteQualifiers` returns `False`.
**Why it happens:** `RoundSelections.lastThirtyTwo` must have exactly 32 teams with no group contributing more than 3 (and BestThird groups respected).
**How to avoid:** In `dummyRoundSelections`, pick top-2 from each group plus 8 "best third" teams that satisfy the T1–T8 slot constraints. Verify with `Form.Bracket.Types.isWizardComplete dummyRoundSelections` = `True` before shipping.

### Pitfall 4: Topscorer completeness
**What goes wrong:** Dashboard topscorer row stays `[ ]` after fill.
**Why it happens:** `Topscorer = ( Maybe String, Maybe Team )` — `Form.Topscorer.isComplete` checks both `fst` and `snd` are `Just`.
**How to avoid:** `dummyTopscorer` must be `( Just "Kylian Mbappé", Just franceTeam )`.

### Pitfall 5: Card pattern match coverage
**What goes wrong:** Compiler error "missing branch" after adding `FillAllBet` to `Msg`.
**Why it happens:** `case msg of` in `Main.update` needs exhaustive coverage.
**How to avoid:** Check all `case msg of` blocks; only `Main.update` needs the new branch.

## Code Examples

### Score type
```elm
-- src/Bets/Types.elm line 149
type alias Score = ( Maybe Int, Maybe Int )
```

### Topscorer type
```elm
-- src/Bets/Types.elm line 114
type alias Topscorer = ( Maybe String, Maybe Team )
```

### RoundSelections type
```elm
-- src/Form/Bracket/Types.elm lines 35-42
type alias RoundSelections =
    { champion : Maybe Team
    , finalists : List Team  -- 2 teams
    , semis : List Team       -- 4 teams
    , quarters : List Team    -- 8 teams
    , lastSixteen : List Team -- 16 teams
    , lastThirtyTwo : List Team -- 32 teams
    }
```

### addTeamToRound cascade behaviour
```elm
-- addTeamToRound ChampionRound team sel  sets champion AND adds to finalists/semis/quarters/lastSixteen/lastThirtyTwo
-- addTeamToRound FinalistRound team sel  adds to finalists AND semis/quarters/lastSixteen/lastThirtyTwo
-- etc. — see Form/Bracket/Types.elm lines 142-193
```

### WC2026 group-to-team mapping (confirmed from Draw.elm)
```
A: mexico, south_africa, south_korea, team_a4
B: canada, team_b2, qatar, switzerland
C: brazil, morocco, haiti, scotland
D: usa, paraguay, australia, team_d4
E: germany, curacao, ivory_coast, ecuador
F: netherlands, japan, team_f3, tunisia
G: belgium, egypt, iran, new_zealand
H: spain, cape_verde, saudi_arabia, uruguay
I: france, senegal, team_i3, norway
J: argentina, algeria, austria, jordan
K: portugal, team_k2, uzbekistan, colombia
L: england, croatia, ghana, panama
```

### WC2026 selectedMatches (group phase, confirmed from Tournament.elm)
```
A: m01, m28, m53
B: m03, m26, m51
C: m07, m30, m49
D: m04, m32, m60
E: m10, m33, m55
F: m11, m35, m58
G: m16, m40, m64
H: m14, m37, m66
I: m17, m41, m61
J: m19, m44, m70
K: m24, m47, m71
L: m21, m45, m68
```
Total: 36 matches — exactly what BET-01 requires.

### BestThird slot constraints (confirmed from Tournament.elm)
```
T1: [C,E,F,H,I]
T2: [E,F,G,I,J]
T3: [D,E,I,J,L]
T4: [B,E,F,I,H]
T5: [A,E,H,I,J]
T6: [E,H,I,J,K]
T7: [A,B,C,D,F]
T8: [C,D,F,G,H]
```
The 8 "best third" teams must come from 8 different groups; greedy assignment with most-constrained-first (as in `assignBestThirds`) must succeed. Suggested: pick one third-place team per group A-H (8 groups), satisfying all T slots. Verify offline before coding.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Manual bracket writes | `rebuildBracket` from `RoundSelections` | Issue #93 | Bracket and WizardState stay in sync |
| `Bracket.isComplete` for completeness | `Bracket.isCompleteQualifiers` | Issue #93 | Checks qualifiers (set by setBulk), not match winners (never set by wizard) |

## Open Questions

1. **`updateBracket` in `Form.Bracket` is not exported**
   - What we know: `updateBracket : Bet -> Bracket -> Bet` exists at line 94 of `Form/Bracket.elm` but is not in the `exposing` list.
   - What's unclear: Whether to expose it or inline the update in `Main.update`.
   - Recommendation: Expose it — it is a useful utility that belongs in `Form.Bracket`'s public API. Alternatively inline the one-liner `{ bet | answers = { answers | bracket = Answer newBracket points } }` directly in `Main.update`.

2. **Exact `dummyRoundSelections` that satisfies all constraints**
   - What we know: 32 teams needed; max 3 per group in lastThirtyTwo; BestThird T1-T8 slot constraints must be met by exactly 8 groups.
   - What's unclear: The exact combination of groups A-H (or any 8) for best-third before coding.
   - Recommendation: Planner should enumerate the selections explicitly (e.g. top-2 from every group, third from groups A–H) and verify `isWizardComplete` returns `True` in the task description.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None — `elm-test` is not configured (per CLAUDE.md) |
| Config file | None |
| Quick run command | `make debug` (compilation check only) |
| Full suite command | `make build` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| BET-01 | FillAllBet button visible only in testMode | manual-only | n/a | N/A |
| BET-01 | Tapping fills 36 scores, full bracket, topscorer | manual-only | n/a | N/A |
| BET-01 | Dashboard shows all [x] after fill | manual-only | n/a | N/A |
| BET-01 | Elm compilation succeeds with no errors | smoke | `make debug` | ✅ Makefile exists |

Manual-only justified: no automated test suite exists per CLAUDE.md ("No test suite — elm-test is not configured").

### Sampling Rate
- **Per task commit:** `make debug` (compilation succeeds)
- **Per wave merge:** `make build` (optimized build succeeds — catches `Debug.log` usage)
- **Phase gate:** `make build` green + manual browser verification before `/gsd:verify-work`

### Wave 0 Gaps
None — existing build infrastructure covers all phase requirements. No test files to create.

## Sources

### Primary (HIGH confidence)
- `src/Form/Bracket/Types.elm` — `RoundSelections`, `WizardState`, `addTeamToRound`, `isWizardComplete`
- `src/Form/Bracket.elm` — `rebuildBracket`, `updateBracket`, `setRoundWinners`, `assignBestThirds`
- `src/Bets/Bet.elm` — `setMatchScore`, `setTopscorer`, `getBracket`
- `src/Bets/Types.elm` — `Score`, `Topscorer`, `Bet`, `Answers`
- `src/Bets/Init/WorldCup2026/Tournament.elm` — `selectedMatches`, bracket structure, BestThird slot definitions
- `src/Bets/Init/WorldCup2026/Tournament/Draw.elm` — group assignments (a1-l4)
- `src/Types.elm` — `Msg`, `Card`, `Model`, `testMode : Bool`
- `src/Main.elm` — `ActivateTestMode` handler, testMode guard pattern, `BracketMsg` handler (cards sync)
- `src/Form/Dashboard.elm` — full view; where button will be added
- `src/Form/Card.elm` — `updateBracketCard`
- `.planning/STATE.md` — Accumulated decisions: rebuildBracket invariant, testMode guard placement

### Secondary (MEDIUM confidence)
- `src/TestData/Activities.elm` — confirms TestData.* pattern for static dummy data

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all relevant modules read directly from source
- Architecture: HIGH — established patterns from prior phases + direct source inspection
- Pitfalls: HIGH — two (#1, #3) directly from issue #93 and STATE.md decisions; others from type inspection

**Research date:** 2026-03-14
**Valid until:** Until Tournament.elm or Form/Bracket.elm is changed (stable; no external dependencies)

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| BET-01 | User can fill the entire bet (36 group match scores, full knockout bracket, topscorer) with one button tap on the Dashboard card in test mode | `rebuildBracket` handles bracket; `List.foldl setMatchScore` handles scores; `setTopscorer` handles topscorer; `model.testMode` gate handles visibility |
</phase_requirements>
