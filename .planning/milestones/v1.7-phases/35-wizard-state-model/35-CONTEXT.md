# Phase 35: Wizard State Model - Context

**Gathered:** 2026-03-16
**Status:** Ready for planning

<domain>
## Phase Boundary

Fix the state-model helpers in `Form/Bracket/Types.elm` so they encode bottom-up round progression — R32 opens first, each round locks to its own field, pool membership is enforced for R16+, and completion requires all six rounds at capacity. `rebuildBracket` in `Form/Bracket.elm` is not touched (already correct).

</domain>

<decisions>
## Implementation Decisions

### addTeamToRound — cascade stripping
- **Strict single-round add**: each `addTeamToRound` call modifies only that round's field, nothing else
- No upward cascade (R32 add does not touch R16+)
- No downward cascade (Champion add does not touch Finalist/Semi/etc.)
- User must explicitly select in each subsequent round

### canSelectTeam — pool membership enforcement
- **Enforce in state helper** (single source of truth for view and update)
- R32: keep existing max-3-per-group constraint (`countGroupInList grp sel.lastThirtyTwo teamData < 3`) — locked by STATE.md
- R16: team must appear in `lastThirtyTwo`
- QF: team must appear in `lastSixteen`
- SF: team must appear in `quarters`
- Final: team must appear in `semis`
- Champion: team must appear in `finalists`
- All rounds still check capacity and not-already-in-round as before

### currentActiveRound — bottom-up scan
- Scan order reversed: R32 → R16 → QF → SF → Final → Champion (find first incomplete)
- Fallback when all rounds complete: return `ChampionRound` (shows champion selection as the final completed state)

### GoNext behavior
- `GoNext` advances `viewingRound` to the next round in bottom-up order (R32→R16→QF→SF→Final→Champion)
- Guard at **view level only**: "Ga verder" button disabled when current round isn't at capacity (WIZ-04)
- `update` always processes `GoNext` — no capacity check in update

### isWizardComplete conditions
- Check all 6 rounds using **unique team count** per round:
  - `List.Extra.uniqueBy .teamID sel.lastThirtyTwo |> List.length == 32`
  - Same pattern for lastSixteen (16), quarters (8), semis (4), finalists (2), champion (Just _)
- No cross-round subset validation — pool membership is enforced at selection time by `canSelectTeam`

### Claude's Discretion
- Helper to get unique teams per round (inline or extracted)
- Whether to define a `nextRound : SelectionRound -> Maybe SelectionRound` helper for GoNext

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Wizard state model
- `src/Form/Bracket/Types.elm` — current implementation; all helpers to be modified are here
- `src/Form/Bracket.elm` — `update` and `rebuildBracket`; update handles SelectTeam/DeselectTeam/GoNext/JumpToRound

### Requirements
- `.planning/REQUIREMENTS.md` §v1.7 — WIZ-01, WIZ-02, WIZ-03, WIZ-04 define the bottom-up flow requirements

### Prior state decisions
- `.planning/STATE.md` §"Decisions for v1.7" — third-place cap = 3 per group locked; `rebuildBracket` unchanged locked

No external ADRs — requirements fully captured in decisions above and REQUIREMENTS.md.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `Form.Bracket.Types.removeTeamFromAll`: already correct for bottom-up — removes team from ALL rounds; satisfies WIZ-03
- `Form.Bracket.Types.roundTeams`: correct as-is — maps SelectionRound to the right field
- `Form.Bracket.Types.roundRequired`: correct as-is — capacity counts per round
- `List.Extra.uniqueBy`: available via `elm-community/list-extra` for unique-count checks

### Established Patterns
- `addUnique` local helper in `addTeamToRound` already prevents duplicates at insertion time — `isWizardComplete` unique check is a belt-and-suspenders defensive pattern
- `Maybe.map List.singleton sel.champion |> Maybe.withDefault []` — existing pattern for normalising `Maybe Team` to `List Team` for champion

### Integration Points
- `Form.Bracket.update` (`SelectTeam` branch) calls `addTeamToRound` — cascade strip is transparent to the caller
- `Form.Bracket.View` calls `currentActiveRound` to decide which round to render — order reversal is transparent to the caller
- `Form.Bracket.View.viewCompletionButton` calls `isWizardComplete` — new all-rounds check is transparent to the caller

</code_context>

<specifics>
## Specific Ideas

- `isWizardComplete` unique check: `List.Extra.uniqueBy .teamID sel.lastThirtyTwo |> List.length == 32` (and same pattern for other rounds)
- `nextRound` helper could map R32→R16→QF→SF→Final→Champion→Champion (no-op at end) — used by GoNext in update

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 35-wizard-state-model*
*Context gathered: 2026-03-16*
