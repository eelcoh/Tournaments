# Architecture Research

**Domain:** Bottom-up bracket wizard redesign — Elm 0.19.1 SPA (v1.7)
**Researched:** 2026-03-16
**Confidence:** HIGH — all findings derived from direct inspection of all relevant source files

## Overview

The v1.7 milestone inverts the bracket wizard entry order from top-down (champion-first) to
bottom-up (R32-first). The user selects 32 qualifiers first, then narrows to 16, 8, 4, 2, 1.

The central finding: `rebuildBracket` in `Form/Bracket.elm` is already bottom-up in its internal
logic. It reads `lastThirtyTwo` to fill TeamNode qualifiers, then propagates winners upward via
`setRoundWinners`. No changes are needed there. Only the wizard entry layer needs to change: four
helper functions in `Form/Bracket/Types.elm` and two routing decisions in `Form/Bracket/View.elm`.

## System Overview

```
User tap: SelectTeam / DeselectTeam
    |
    v
Form.Bracket.update                            -- UNCHANGED structure
    |
    +-- addTeamToRound (bottom-up semantics)    -- MODIFIED: no cascade-up
    |       Adds team to the selected round only.
    |       Does NOT propagate into higher rounds.
    |
    +-- removeTeamFromAll                       -- UNCHANGED
    |       Still removes from ALL rounds on deselect.
    |       Correct for bottom-up: removing from R32
    |       must cascade-clear R16, QF, SF, Final, Champion.
    |
    +-- rebuildBracket                          -- UNCHANGED
    |       Reads lastThirtyTwo, partitions by group,
    |       assigns WA/RA slots and best-third T slots via setBulk,
    |       then setRoundWinners r1 lastSixteen,
    |            setRoundWinners r2 quarters, ...
    |       Already bottom-up in logic.
    |
    +-- updateBracket                           -- UNCHANGED
            Writes Bracket into bet.answers.bracket via Answer wrapper.

Form.Bracket.View.view
    |
    +-- viewBracketMinimap                      -- UNCHANGED
    |       Already lists [R32, R16, KF, HF, F, Champion].
    |
    +-- allRounds list                          -- MODIFIED: reversed
    |       Was [ChampionRound, ..., LastThirtyTwoRound].
    |       Becomes [LastThirtyTwoRound, ..., ChampionRound].
    |       Controls section rendering order on the page.
    |
    +-- viewRoundSection (per round)
            |
            +-- viewActiveGrid                  -- MODIFIED: routing
                    R32 active -> viewR32Grid   -- UNCHANGED (48 teams by group)
                    R16+ active -> viewFlatGrid -- UNCHANGED (pool from prev round)
                    Note: viewFlatGrid already exists and is correct;
                    it was unused on Phone in the old top-down flow.

Bets.Types.Bracket (setBulk, proceed, winner)  -- UNCHANGED
Bets.Bet.isComplete                             -- UNCHANGED
```

## Component Responsibilities

| Component | Responsibility | Change Status |
|-----------|----------------|---------------|
| `Form.Bracket.Types` — `RoundSelections` | Stores six team lists (lastThirtyTwo … champion) | UNCHANGED — field names already match bottom-up order |
| `Form.Bracket.Types` — `SelectionRound` | 6-variant discriminant for which round is active | UNCHANGED |
| `Form.Bracket.Types` — `addTeamToRound` | Append a team to one round's list | MODIFIED — remove cascade-up; each round writes only its own field |
| `Form.Bracket.Types` — `removeTeamFromAll` | Remove a team from all six lists | UNCHANGED — cascade-down on deselect is correct for bottom-up |
| `Form.Bracket.Types` — `currentActiveRound` | Derive which round the user is filling | MODIFIED — iterate R32→Champion; return first incomplete round |
| `Form.Bracket.Types` — `canSelectTeam` | Gate whether a team badge is tappable | MODIFIED — R32 keeps group constraint; R16+ uses pool restriction instead |
| `Form.Bracket.Types` — `isWizardComplete` | Check all rounds filled | UNCHANGED — `champion Just _` && `lastThirtyTwo==32` is still the correct terminal condition |
| `Form.Bracket.elm` — `rebuildBracket` | Rebuild Bracket tree from RoundSelections | UNCHANGED |
| `Form.Bracket.elm` — `assignBestThirds` | Greedy T1-T8 slot assignment for best-third teams | UNCHANGED |
| `Form.Bracket.elm` — `setRoundWinners` | Propagate per-round winners into Bracket | UNCHANGED |
| `Form.Bracket.elm` — `update` | Handle Msg, invoke helpers | UNCHANGED — benefits automatically from fixed helpers |
| `Form.Bracket.View` — `allRounds` list | Section render order | MODIFIED — reversed to R32-first |
| `Form.Bracket.View` — `viewActiveGrid` | Route Phone vs Computer grid per round | MODIFIED — Phone now uses viewFlatGrid for R16+; old workaround (always viewR32Grid) removed |
| `Form.Bracket.View` — `viewR32Grid` | 48-team grid grouped by group letter | UNCHANGED |
| `Form.Bracket.View` — `viewFlatGrid` | Grid built from previous-round pool | UNCHANGED — already correct; was dead code on Phone |
| `Form.Bracket.View` — `viewRoundSection` | Per-round section: header + placed-badges + grid | UNCHANGED — renders the same way regardless of direction |
| `Form.Bracket.View` — `viewBracketMinimap` | Dot rail navigator R32→Champion | UNCHANGED — order already correct |
| `Bets.Types.Bracket` | Bracket tree operations (set, setBulk, proceed, winner, get) | UNCHANGED |
| `Bets.Bet` — `isComplete` | Overall bet completeness via `isCompleteQualifiers` | UNCHANGED |
| `Form.Card.elm` | `BracketCard { bracketState }` pattern match in `updateScreenCard` | UNCHANGED |
| `src/Types.elm` | `BracketCard` Card variant, `BracketMsg` Msg | UNCHANGED |
| `TestData.filledBet` | Pre-built test bracket using `rebuildBracket` + `updateBracket` | UNCHANGED — both functions are stable |

## Recommended Project Structure

No new files are needed. All changes are in-place edits to existing modules:

```
src/
└── Form/
    └── Bracket/
        ├── Types.elm    -- MODIFIED: addTeamToRound, currentActiveRound, canSelectTeam
        └── View.elm     -- MODIFIED: allRounds order, viewActiveGrid routing
```

`Form/Bracket.elm` is unchanged. No new modules, no new types, no new Msg variants.

## Architectural Patterns

### Pattern 1: addTeamToRound — remove cascade-up

**What:** Currently selecting a team for `ChampionRound` also writes it into finalists, semis,
quarters, lastSixteen, and lastThirtyTwo simultaneously (cascade-up). This allowed the top-down
wizard to present a champion-first UX and still have a fully-populated `RoundSelections` for
`rebuildBracket`. Bottom-up removes this shortcut: each selection writes only its own field.

**Before (cascade-up):**
```elm
ChampionRound ->
    { champion = Just team
    , finalists = addUnique team sel.finalists
    , semis = addUnique team sel.semis
    , quarters = addUnique team sel.quarters
    , lastSixteen = addUnique team sel.lastSixteen
    , lastThirtyTwo = addUnique team sel.lastThirtyTwo
    }
```

**After (no cascade):**
```elm
ChampionRound ->
    { sel | champion = Just team }

FinalistRound ->
    { sel | finalists = addUnique team sel.finalists }

-- etc. for all rounds
```

**Impact on rebuildBracket:** None. `rebuildBracket` already reads each round's list
independently. With bottom-up data entry, higher-round lists remain empty until the user
explicitly fills them — which is the intended behaviour.

### Pattern 2: canSelectTeam — pool restriction for R16+

**What:** The existing `canSelectTeam` checks a group constraint (max 3 per group in
`lastThirtyTwo`) for all rounds. This is incorrect for bottom-up because: once R32 is complete,
every team that can appear in R16 already satisfied the group constraint at R32 entry time. The
correct gate for R16 and above is: the team must exist in the previous round's list.

**Before (group constraint applied to all rounds):**
```elm
canSelectTeam round team sel teamData =
    hasCapacity && notAlreadyInRound && groupConstraintOk
```

**After (pool restriction for R16+):**
```elm
canSelectTeam round team sel teamData =
    let
        isInPool =
            case round of
                LastThirtyTwoRound -> True  -- pool is all 48; group constraint gates instead
                LastSixteenRound   -> List.any (\t -> t.teamID == team.teamID) sel.lastThirtyTwo
                QuarterRound       -> List.any (\t -> t.teamID == team.teamID) sel.lastSixteen
                SemiRound          -> List.any (\t -> t.teamID == team.teamID) sel.quarters
                FinalistRound      -> List.any (\t -> t.teamID == team.teamID) sel.semis
                ChampionRound      -> List.any (\t -> t.teamID == team.teamID) sel.finalists
    in
    hasCapacity && notAlreadyInRound && isInPool && (round == LastThirtyTwoRound || groupConstraintSkipped)
```

Alternatively: keep `groupConstraintOk` (it passes when `alreadyInL32` is True), and the
pool restriction above makes `isInPool` the primary filter. The two constraints compose cleanly:
a team already in `lastThirtyTwo` will pass `groupConstraintOk` for any higher round since
`alreadyInL32 = True` short-circuits to `True`.

The simpler fix is to check `isInPool` as a prerequisite, and only evaluate `groupConstraintOk`
for `LastThirtyTwoRound`. For all higher rounds: `hasCapacity && notAlreadyInRound && isInPool`.

### Pattern 3: currentActiveRound — iterate bottom-up

**What:** Inverting the iteration order causes the wizard to surface `LastThirtyTwoRound` as the
first active round (it starts empty with 0 of 32) rather than `ChampionRound` (0 of 1).

**Before:**
```elm
rounds =
    [ ( ChampionRound, championTeams, 1 )
    , ( FinalistRound, sel.finalists, 2 )
    , ( SemiRound, sel.semis, 4 )
    , ( QuarterRound, sel.quarters, 8 )
    , ( LastSixteenRound, sel.lastSixteen, 16 )
    , ( LastThirtyTwoRound, sel.lastThirtyTwo, 32 )
    ]
```

**After:**
```elm
rounds =
    [ ( LastThirtyTwoRound, sel.lastThirtyTwo, 32 )
    , ( LastSixteenRound, sel.lastSixteen, 16 )
    , ( QuarterRound, sel.quarters, 8 )
    , ( SemiRound, sel.semis, 4 )
    , ( FinalistRound, sel.finalists, 2 )
    , ( ChampionRound, championTeams, 1 )
    ]
```

`isIncomplete` and the `Maybe.withDefault LastThirtyTwoRound` fallback remain unchanged.

### Pattern 4: viewActiveGrid — route by round, not by device

**What:** The Phone branch of `viewActiveGrid` always called `viewR32Grid` (all 48 teams). This
was a workaround: in the top-down flow, when `ChampionRound` is active, `sel.finalists` is still
empty so `viewFlatGrid` would show an empty grid. With bottom-up, the previous round's pool is
always populated before a higher round becomes active. The workaround is no longer needed.

**Before:**
```elm
viewActiveGrid round sel allGroups teamData_ dev =
    case dev of
        Screen.Phone ->
            viewR32Grid round sel allGroups teamData_  -- always 48 teams regardless of round

        Screen.Computer ->
            Element.column [...] (List.map (viewGroup ...) allGroups)
```

**After:**
```elm
viewActiveGrid round sel allGroups teamData_ dev =
    case round of
        LastThirtyTwoRound ->
            viewR32Grid round sel allGroups teamData_

        _ ->
            viewFlatGrid round sel teamData_
```

The `dev` parameter can be dropped from the signature if `Screen.Computer` is unified into the
same `viewFlatGrid` path. If the existing per-row `viewGroup` layout on Computer is worth
keeping, retain the `dev` branch only inside `LastThirtyTwoRound`.

### Pattern 5: allRounds list order in view

**What:** `Form.Bracket.View.view` maps `viewRoundSection` over `allRounds` to produce page
sections. Reversing the list puts R32 at the top of the page (the entry point) and Champion at
the bottom (the result). `viewBracketMinimap` already uses the correct order (R32 → Champion)
and does not change.

**Before:**
```elm
allRounds =
    [ ChampionRound, FinalistRound, SemiRound, QuarterRound, LastSixteenRound, LastThirtyTwoRound ]
```

**After:**
```elm
allRounds =
    [ LastThirtyTwoRound, LastSixteenRound, QuarterRound, SemiRound, FinalistRound, ChampionRound ]
```

## Data Flow

### Bottom-up selection: R32 phase

```
User taps team badge in R32 grid
    |
    v
SelectTeam LastThirtyTwoRound team
    |
    v
addTeamToRound LastThirtyTwoRound team sel
    -> sel.lastThirtyTwo grows by one
    -> all other lists unchanged

rebuildBracket newSelections teamData
    -> teamsInGroup: partitions lastThirtyTwo (0..32) by group
    -> firstSecondAssignments: WA/RA filled once group has 2 picks
    -> thirdPlaceTeams: T slots filled once group has 3 picks
    -> setBulk: writes TeamNode qualifiers
    -> setRoundWinners r1Slots lastSixteen  (empty -> no R1 winners yet)
    -> higher rounds: all empty -> no propagation yet

updateBracket: writes new Bracket into bet
```

### Bottom-up selection: R16 phase (R32 complete)

```
sel.lastThirtyTwo has 32 teams
currentActiveRound returns LastSixteenRound

User taps team badge in viewFlatGrid (pool = sel.lastThirtyTwo)
    |
    v
SelectTeam LastSixteenRound team
    |
    v
addTeamToRound LastSixteenRound team sel
    -> sel.lastSixteen grows by one

rebuildBracket newSelections teamData
    -> setBulk: all 32 TeamNode qualifiers set (R32 already complete)
    -> setRoundWinners r1Slots lastSixteen
         for each m73-m88: if home or away team is in lastSixteen, proceed
    -> setRoundWinners r2Slots quarters  (quarters empty -> no propagation)
```

### Deselect cascade

```
User taps any placed team badge (DeselectTeam team)
    |
    v
removeTeamFromAll team sel
    -> removes from all six lists in one pass
    -> if team was in lastThirtyTwo, also gone from lastSixteen, quarters, etc.

rebuildBracket (cleaned selections) teamData
    -> affected TeamNode slots become Nothing
    -> affected MatchNode winners revert to None
```

### Completeness check (unchanged)

```
Bets.Bet.isComplete
    -> Bracket.isCompleteQualifiers bet.answers.bracket
        -> every TeamNode: qual = Just _
        -> set by setBulk in rebuildBracket
        -> true only when all 32 R32 teams are assigned to slots

isWizardComplete (Form.Bracket.Types)
    -> champion = Just _ AND lastThirtyTwo length == 32
    -> enables "Ga verder" button
```

## Build Order

The four changes are independent at the Elm compiler level but have a logical testing dependency:

1. **`currentActiveRound` — reverse iteration order**
   Change the `rounds` list in `Form.Bracket.Types`. Verifies: on fresh wizard, minimap shows
   R32 as the active dot; R32 grid appears at top. No data flow changes yet.

2. **`addTeamToRound` — remove cascade-up**
   Remove the propagation lines. Verifies: selecting a team for R32 only fills `lastThirtyTwo`;
   `canSelectTeam` for R16 returns False for all teams (none in pool yet). Must follow step 1
   so R32 is the first round displayed.

3. **`canSelectTeam` — pool restriction for R16+**
   Add `isInPool` check per round; remove group constraint for non-R32 rounds. Verifies: after
   R32 has 32 teams, R16 grid shows exactly those 32 teams as selectable. Must follow step 2
   so `sel.lastThirtyTwo` is populated before R16 becomes active.

4. **`viewActiveGrid` routing + `allRounds` order in View**
   Pure view change. Route R32 to `viewR32Grid`, all others to `viewFlatGrid`. Reverse
   `allRounds`. Verifies: R32 section appears first; R16 section shows previous-round pool.
   Can technically be done at any point since it is a rendering concern, but makes most sense
   after step 3 so the displayed grid correctly reflects the data model.

## Integration Points

### Internal Boundaries

| Boundary | Communication | Change Required |
|----------|---------------|-----------------|
| `Form.Bracket.Types` -> `Form.Bracket.elm` | `addTeamToRound`, `currentActiveRound`, `canSelectTeam`, `removeTeamFromAll` exported | Only the first three change; `update` in `Form.Bracket.elm` calls them without structural change |
| `Form.Bracket.elm` -> `Form.Bracket.View` | `view bet state` passes `State` | UNCHANGED |
| `Form.Bracket.View` -> `Form.Bracket.Types` | `canSelectTeam`, `currentActiveRound`, `isWizardComplete`, `roundTeams`, `roundRequired` | `currentActiveRound` behavior changes; view code needs only `allRounds` order + `viewActiveGrid` routing |
| `Form.Bracket.elm` -> `Bets.Types.Bracket` | `setBulk`, `proceed`, `winner`, `get` | UNCHANGED |
| `Form.Bracket.elm` -> `Bets.Init` | `Bets.Init.bet` (empty bracket seed), `Bets.Init.teamData` | UNCHANGED |
| `Form.Card.elm` | `BracketCard { bracketState }` pattern in `updateScreenCard` | UNCHANGED |
| `src/Types.elm` / `Form/View.elm` | Route `BracketMsg` -> `Form.Bracket.update` | UNCHANGED |
| `TestData.filledBet` | Calls `rebuildBracket` + `updateBracket` from `Form.Bracket` | UNCHANGED — both stable |

### Badge layout by round: old vs new

| Round | Old grid (Phone) | New grid |
|-------|-----------------|----------|
| LastThirtyTwoRound | `viewR32Grid` (48 teams, 12 groups) | `viewR32Grid` — unchanged |
| LastSixteenRound | `viewR32Grid` (all 48) | `viewFlatGrid` (pool = lastThirtyTwo, 32 teams) |
| QuarterRound | `viewR32Grid` (all 48) | `viewFlatGrid` (pool = lastSixteen, 16 teams) |
| SemiRound | `viewR32Grid` (all 48) | `viewFlatGrid` (pool = quarters, 8 teams) |
| FinalistRound | `viewR32Grid` (all 48) | `viewFlatGrid` (pool = semis, 4 teams) |
| ChampionRound | `viewR32Grid` (all 48) | `viewFlatGrid` (pool = finalists, 2 teams) |

`viewFlatGrid` returns an empty column for `LastThirtyTwoRound` by design (the `LastThirtyTwoRound -> []` branch). This is correct: `LastThirtyTwoRound` must always use `viewR32Grid`.

## Anti-Patterns

### Anti-Pattern 1: Rewriting rebuildBracket

**What people do:** Assume the direction change requires a new rebuild function.
**Why it's wrong:** `rebuildBracket` reads `lastThirtyTwo` first and propagates upward via
`setRoundWinners`. It is already bottom-up in logic. The wizard entry helpers (not the rebuild
function) were the locus of the top-down assumption.
**Do this instead:** Leave `rebuildBracket` entirely unchanged.

### Anti-Pattern 2: Removing cascade-remove from removeTeamFromAll

**What people do:** Change `removeTeamFromAll` to only clear the selected round.
**Why it's wrong:** A team deselected from R32 must disappear from R16, QF, SF, Final, and
Champion too. If it does not, `rebuildBracket` will still place it in higher-round MatchNodes
even though it is no longer a valid qualifier.
**Do this instead:** Keep `removeTeamFromAll` unchanged. It filters all six lists in one pass.

### Anti-Pattern 3: Using viewFlatGrid for LastThirtyTwoRound

**What people do:** Apply the unified "pool from previous round" rule to R32 as well, calling
`viewFlatGrid LastThirtyTwoRound`.
**Why it's wrong:** `viewFlatGrid` has a `LastThirtyTwoRound -> []` special case — it renders
an empty grid because R32 has no "previous round" pool. The result would be a blank screen for
the first wizard step.
**Do this instead:** Explicitly route `LastThirtyTwoRound` to `viewR32Grid` and all others to
`viewFlatGrid`.

### Anti-Pattern 4: Keeping group constraint active for R16+

**What people do:** Leave `canSelectTeam` unchanged, relying on `alreadyInL32` to short-circuit
the group constraint.
**Why it's subtle:** `alreadyInL32` does short-circuit to `True` for teams in `lastThirtyTwo`,
which means teams already in R32 pass `groupConstraintOk`. However, the function signature
implies "group constraint" which is misleading, and the function mixes two unrelated
responsibilities. The correct intent for R16+ is pool membership, not group membership.
**Do this instead:** Explicitly compute `isInPool` per round. Remove `groupConstraintOk` from
the R16+ path. This makes the intent clear and avoids subtle bugs if the group constraint
logic is ever modified for R32.

## Sources

- `src/Form/Bracket/Types.elm` — direct code reading (2026-03-16)
- `src/Form/Bracket.elm` — direct code reading (2026-03-16)
- `src/Form/Bracket/View.elm` — direct code reading (2026-03-16)
- `src/Bets/Types/Bracket.elm` — direct code reading (2026-03-16)
- `src/Bets/Bet.elm` — direct code reading (2026-03-16)
- `.planning/PROJECT.md` — v1.7 milestone context (2026-03-16)
- `CLAUDE.md` and `MEMORY.md` — project architecture and bracket slot documentation

---
*Architecture research for: v1.7 bottom-up bracket wizard redesign*
*Researched: 2026-03-16*
