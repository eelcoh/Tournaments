# Phase 37: Test Mode Validation - Context

**Gathered:** 2026-03-18
**Status:** Ready for planning

<domain>
## Phase Boundary

Verify and fix the fill-all test button so it correctly populates all 6 wizard rounds (R32 → R16 → QF → SF → Final → Champion) in bottom-up order, leaving `isWizardComplete` truthy, the bracket minimap showing all dots green, and forward navigation to TopscorerCard working. This is a verification + fixup phase — not a feature build.

</domain>

<decisions>
## Implementation Decisions

### Post-fill wizard display state
- After fill-all, set `viewingRound = Nothing` (current behaviour — correct as-is)
- `currentActiveRound` falls through to `ChampionRound` when all rounds are complete → champion view shows as active
- All 5 earlier rounds render as placed sections above ChampionRound with green borders — full summary visible
- User can scroll up to review all selections immediately after tapping fill-all

### FillAllBet handler approach
- Existing `FillAllBet` handler in `Main.elm` is the right structure — verify, don't rewrite from scratch
- `dummyRoundSelections` in `TestData.Bet.elm` already has valid bottom-up data (32+16+8+4+2+1 teams)
- `viewingRound = Nothing` is the correct value — no change needed there
- Phase 37 = read the code carefully, confirm all 6 rounds are at capacity, fix any gaps found

### Completeness chain to verify
1. `isWizardComplete sel` returns `True` (all unique team counts at capacity)
2. `Bets.Bet.isComplete bet` returns `True` (`Bracket.isCompleteQualifiers` passes after `rebuildBracket`)
3. "Ga verder →" button in `viewCompletionButton` is enabled (guarded by `isWizardComplete`)
4. Advancing from BracketCard navigates to TopscorerCard

### Claude's Discretion
- Whether `dummyRoundSelections` needs minor team substitutions (verify pool membership holds for all R16+ rounds)
- Whether to add `Just ChampionRound` explicitly instead of `Nothing` (either works; `Nothing` is fine)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### FillAllBet handler
- `src/Main.elm` — `FillAllBet` branch (~line 1053): group scores + bracket rebuild + topscorer + card state update
- `src/TestData/Bet.elm` — `dummyRoundSelections`, `dummyGroupScores`, `dummyTopscorer`

### Wizard state and completeness
- `src/Form/Bracket/Types.elm` — `isWizardComplete`, `currentActiveRound`, `addTeamToRound`, `RoundSelections`
- `src/Form/Bracket/View.elm` — `viewCompletionButton` (guards "Ga verder" on `isWizardComplete`)
- `src/Bets/Bet.elm` — `isComplete` (uses `Bracket.isCompleteQualifiers`)

### Requirements
- `.planning/REQUIREMENTS.md` §v1.7 — TEST-01 is the sole requirement for this phase

No external ADRs — requirements fully captured in decisions above and REQUIREMENTS.md.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `Form.Bracket.rebuildBracket` + `Form.Bracket.updateBracket`: already used in FillAllBet; no changes expected
- `TestData.Bet.dummyRoundSelections`: existing bottom-up data; verify pool membership holds
- `Cards.updateBracketCard`: sets `BracketWizard { selections, viewingRound }` on the card state

### Established Patterns
- `viewingRound = Nothing` → display round determined by `currentActiveRound sel` (returns `ChampionRound` when all complete)
- `isWizardComplete` uses `List.Extra.uniqueBy .teamID` for de-duplication — robust against accidental duplicates in `dummyRoundSelections`

### Integration Points
- `FillAllBet` → updates `model.bet`, `model.betState`, `model.cards`
- `BracketCard` advances to `TopscorerCard` when `isComplete` (via `Form.Card` navigation logic)

</code_context>

<specifics>
## Specific Ideas

- No specific references beyond the code — straightforward verification and fixup

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 37-test-mode-validation*
*Context gathered: 2026-03-18*
