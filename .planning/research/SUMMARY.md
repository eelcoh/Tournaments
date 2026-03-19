# Project Research Summary

**Project:** Bracket Wizard Redesign (v1.7)
**Domain:** Bottom-up knockout bracket prediction wizard — Elm 0.19.1 + elm-ui SPA
**Researched:** 2026-03-16
**Confidence:** HIGH

## Executive Summary

The v1.7 milestone inverts the bracket wizard from a top-down (champion-first) flow to a bottom-up (R32-first) flow. Research confirms this is achievable with surgical edits to four helper functions and two view concerns — no new packages, no new modules, no type changes. The core data model (`RoundSelections`, `SelectionRound`, `rebuildBracket`) is already correct for bottom-up; only the wizard entry helpers carry the top-down assumption. The most important finding: `rebuildBracket` already reads `lastThirtyTwo` first and propagates upward — it is already bottom-up in logic and stays completely unchanged.

The recommended approach is a strict two-phase execution. Phase 1 fixes all state-model helpers in `Form/Bracket/Types.elm` (four functions: `addTeamToRound`, `currentActiveRound`, `canSelectTeam`, and `isWizardComplete`). Phase 2 fixes the view layer in `Form/Bracket/View.elm` (two changes: `allRounds` list order and `viewActiveGrid` routing). This ordering is mandatory: the view depends on the data model being correct before a single round grid renders properly.

The key risk is the upward cascade in `addTeamToRound`. It is silent — it compiles cleanly after the direction flip and produces no immediate error, but it corrupts wizard state by pre-populating all six rounds as soon as R32 is filled. If not fixed in Phase 1, every subsequent test gives false confidence because `isWizardComplete` returns True before the user makes any R16+ decisions. A secondary risk is `isWizardComplete` itself, which currently only checks R32 and champion — it must be extended to check all six rounds, otherwise the "Ga verder" button fires too early.

## Key Findings

### Recommended Stack

Zero new packages are required. Every capability needed is already in `elm.json`. The implementation is a pure layout and logic exercise within the existing Elm 0.19.1 + elm-ui 1.1.8 + elm-community/list-extra 8.2.4 stack.

The only non-trivial layout decision is badge sizing: R32 and R16 use code-only badges at `Element.px 48` (3-char Martian Mono at 11px). QF through Champion use full-name+code badges at `Element.px 80` (clips long names like "Saoedi Arabië" via `Element.paragraph` + `Element.clipX` + `height (px 13)` + `overflow-wrap: anywhere`). Fixed `px` widths are required — `Element.shrink` breaks grid column alignment and `fill` stretches partial last rows.

**Core technologies:**
- Elm 0.19.1: SPA runtime — unchanged; all patterns achievable without additions
- mdgriffith/elm-ui 1.1.8: layout — `Element.px`, `Element.clipX`, `Element.paragraph` cover all badge needs
- elm-community/list-extra 8.2.4: grid row slicing — `greedyGroupsOf 4` already used in `Form/Bracket/View.elm`

### Expected Features

All v1.7 features are P1 (required for launch). The feature set is tightly scoped: invert the round order, fix the data helpers, update the grid routing, and adjust badge styles. Nothing is deferred to v2 except animated round transitions (high effort, low value in elm-ui).

**Must have (table stakes):**
- R32-first round order (R32 → R16 → QF → SF → Final → Champion) — matches how users reason about tournament qualification
- Team pool scoped to previous round on R16+ — users expect to pick from their own selections, not all 48 teams
- Downstream invalidation on deselect — `removeTeamFromAll` already correct; must not be scoped down
- Green outline for selected badges (not orange) — spec requirement from PROJECT.md
- R32 group-organised display with 12px amber group-letter headers — 48 teams are unnavigable without group structure
- Fixed-width badge grid (consistent column widths) — predictable mobile tap targets at 320px
- Code-only badges for R32/R16; full-name+code for QF–Champion — density appropriate to team count per round
- `isWizardComplete` checking all six rounds — prevents premature "Ga verder"

**Should have (competitive):**
- Per-round selection counter in section header ("8/16 geselecteerd") — already exists in `viewRoundSection`; keep it
- Group-letter amber header above each R32 group — scannable over plain grey `-- X --` separator
- Cascade invalidation silent and immediate — no lag; `removeTeamFromAll` is already atomic

**Defer (v2+):**
- Animated round transitions — elm-ui has no animation primitives; marginal UX gain for significant effort
- Per-group selection count in R32 header ("A — 2/4 geselecteerd") — low effort but not launch-critical

### Architecture Approach

The change is confined to two files: `src/Form/Bracket/Types.elm` (state model helpers) and `src/Form/Bracket/View.elm` (render order and grid routing). No new modules, no new types, no new Msg variants, no changes to `Form/Bracket.elm`, `Bets/Types/Bracket.elm`, or any module outside the `Form/Bracket/` directory. The architectural pattern is inversion of a single traversal order and removal of an upward cascade — both changes are local and non-viral.

**Major components and change status:**
1. `Form.Bracket.Types` — `addTeamToRound`, `currentActiveRound`, `canSelectTeam`, `isWizardComplete`: MODIFIED (Phase 1)
2. `Form.Bracket.View` — `allRounds` list, `viewActiveGrid` routing, badge styles: MODIFIED (Phase 2)
3. `Form.Bracket.elm` — `rebuildBracket`, `assignBestThirds`, `update`: UNCHANGED
4. `Bets.Types.Bracket` — `setBulk`, `proceed`, `winner`, `isCompleteQualifiers`: UNCHANGED
5. All other modules (`Types.elm`, `Form/Card.elm`, `View.elm`, etc.): UNCHANGED

### Critical Pitfalls

1. **`addTeamToRound` upward cascade survives the direction flip** — Strip all cascade from each round branch; each round writes only its own field. This is the highest-priority fix because it silently corrupts all six counters and `isWizardComplete` on the first R32 selection. Verify: add one team to R32 on empty state; assert `lastSixteen` is still `[]`.

2. **`isWizardComplete` only checks R32 + champion** — Extend to check all six round capacities: `length lastThirtyTwo == 32 && length lastSixteen == 16 && length quarters == 8 && length semis == 4 && length finalists == 2 && champion /= Nothing`. Without this, "Ga verder" fires after filling only R32 and picking a champion.

3. **`currentActiveRound` returns `ChampionRound` on empty state** — Reverse the round scan list. One-line fix but load-bearing: the wizard opens on the champion picker instead of R32 if missed. Verify: `currentActiveRound emptyRoundSelections == LastThirtyTwoRound`.

4. **`canSelectTeam` does not enforce previous-round membership** — Add pool membership check for R16+: a team must exist in `sel.lastThirtyTwo` before they can be added to `lastSixteen`, and so on up the chain. Without this, users can add arbitrary teams to R16 via `JumpToRound`, producing orphan winners in the bracket tree.

5. **`viewActiveGrid` uses full 48-team R32 grid for all rounds on Phone** — Route `LastThirtyTwoRound` to `viewR32Grid` and all other rounds to `viewFlatGrid`. The `viewFlatGrid` function already exists and correctly derives pools per round; it was dead code on Phone in the top-down flow.

## Implications for Roadmap

Based on research, the build order has a strict logical dependency: state model correctness is a prerequisite for view correctness, and test-mode validation is a prerequisite for sign-off. Three phases are suggested.

### Phase 1: State Model — Rewrite wizard helpers in Form/Bracket/Types.elm

**Rationale:** All four modified functions are pure helpers with no view dependencies. Fixing them first means every subsequent manual test reflects correct state. The cascade bug in `addTeamToRound` corrupts Phase 2 testing if not resolved here.
**Delivers:** Correct bottom-up state semantics — round progression, pool scoping, deselect cascade, wizard completion gating
**Addresses:** R32-first round order, team pool scoped to previous round, `isWizardComplete` all-rounds check, `canSelectTeam` pool restriction
**Avoids:** Pitfalls 1 (cascade), 3 (currentActiveRound), 4 (canSelectTeam), 5 (isWizardComplete), 9 (previous-round membership)

Changes in scope:
- `currentActiveRound`: reverse round scan list to R32-first
- `addTeamToRound`: remove all upward cascade; each round writes only its own field
- `canSelectTeam`: add `isInPool` check for R16+ (team must be in previous round's list); keep group quota only for R32
- `isWizardComplete`: check all six rounds at capacity

### Phase 2: View Layer — Routing and badge grid in Form/Bracket/View.elm

**Rationale:** Depends on Phase 1 being complete so the active round and pool data are correct before the grids render. Two independent sub-changes (round order and grid routing) can be done together since both are in the same file.
**Delivers:** Correct visual presentation — R32 at the top of the wizard, correct pool displayed per round, consistent badge grid, green selected state
**Uses:** `Element.px 48` (R32/R16 code-only), `Element.px 80` + `Element.paragraph` + `clipX` (QF–Champion full-name)
**Implements:** viewActiveGrid routing; allRounds reversed; group-letter headers in amber at 12px; green selected badge state

Changes in scope:
- `allRounds`: reverse to `[LastThirtyTwoRound, LastSixteenRound, QuarterRound, SemiRound, FinalistRound, ChampionRound]`
- `viewActiveGrid`: route on round, not device — `LastThirtyTwoRound` → `viewR32Grid`, all others → `viewFlatGrid`
- Badge sizing: `Element.px 48` for R32/R16 badges; `Element.px 80` for QF–Champion
- Text clipping: `Element.paragraph` + `Element.clipX` + `height (px 13)` for full names in QF+ badges
- Selected badge color: change from `Color.orange` to `Color.green` in all three badge render functions
- R32 group header: style in 12px amber

**Avoids:** Pitfalls 6 (viewActiveGrid full grid for all rounds), 7 (elm-ui text overflow at 320px)

Manual check required before sign-off: render QF+ full-name grid at 320px viewport width; confirm no text overflow.

### Phase 3: Test Mode and Sign-off — Update FillAllBet and run verification checklist

**Rationale:** Test mode (`FillAllBet`) relied on the old upward cascade to construct a fully-populated `RoundSelections` in one pass. After Phase 1 strips that cascade, `FillAllBet` produces empty intermediate rounds and a broken bracket. Fix this last, after the model and view are stable, so the final validation path is trustworthy.
**Delivers:** Working test-mode fill-all; all minimap dots green; `isCompleteQualifiers` true; "Ga verder" wired to advance to TopscorerCard
**Avoids:** Pitfall 8 (FillAllBet broken after rewrite)

Changes in scope:
- Rewrite `FillAllBet` to construct `RoundSelections` directly with all six fields populated in bottom-up order (not via `addTeamToRound`)
- Verify `GoNext` from `BracketCard` advances to `TopscorerCard`
- Run full "Looks Done But Isn't" checklist from PITFALLS.md

### Phase Ordering Rationale

- Phase 1 before Phase 2: The cascade bug in `addTeamToRound` corrupts every manual test in Phase 2 if left in place. The active round fallback bug in `currentActiveRound` causes Phase 2 view tests to open on the wrong screen.
- Phase 2 after Phase 1: `viewFlatGrid` derives pools from `sel.lastThirtyTwo` — those lists are only populated correctly once Phase 1 helpers are fixed.
- Phase 3 last: `FillAllBet` is a validation mechanism. Updating it before the model and view are stable gives false validation signals.
- No Phase 4 needed: `rebuildBracket`, `Bets.Types.Bracket`, and all outer modules are stable and untouched.

### Research Flags

All phases have standard patterns — no additional research sprints needed:
- **Phase 1:** All four function changes have exact before/after code documented in ARCHITECTURE.md. Patterns are well-understood Elm record updates. Skip research-phase.
- **Phase 2:** Badge sizing and text-clip patterns are fully specified in STACK.md with verified pixel values. `viewR32Grid` and `viewFlatGrid` are unchanged; only routing changes. Skip research-phase.
- **Phase 3:** `FillAllBet` construction pattern is documented in PITFALLS.md. Skip research-phase.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All patterns verified against existing codebase at specific line numbers; no external API dependencies |
| Features | HIGH | Derived from direct code inspection of all modified files plus authoritative PROJECT.md spec |
| Architecture | HIGH | All four modified functions identified with exact before/after code; all unchanged components verified |
| Pitfalls | HIGH | Sourced from direct analysis of the same files being modified; each pitfall has a concrete warning sign and recovery strategy |

**Overall confidence:** HIGH

### Gaps to Address

- **`canSelectTeam` group constraint threshold for R32:** If the R32 selection model retains third-place candidates in `lastThirtyTwo` (current approach, cap = 3 per group), the existing `countGroupInList grp sel.lastThirtyTwo < 3` constraint is correct. If third-place candidates are moved to a separate field (the cleaner architectural option flagged in PITFALLS.md Pitfall 3), the threshold drops to 2. This should be decided explicitly at the start of Phase 1 since it affects both `canSelectTeam` and `RoundSelections` shape. Staying with cap = 3 (third-place teams in `lastThirtyTwo`) avoids any type changes and is the lower-risk path for v1.7.

- **`rebuildBracket` position-encoding of first/second/third role (Pitfall 3):** Tap order in `lastThirtyTwo` determines whether a team gets the `WX` or `RX` bracket slot. This is an existing limitation, not introduced by v1.7, and is left unchanged. If bracket role assignment matters for scoring accuracy, this is a v2 concern. For v1.7, document the limitation in a code comment.

## Sources

### Primary (HIGH confidence)
- `src/Form/Bracket/Types.elm` — direct code reading; `addTeamToRound`, `removeTeamFromAll`, `currentActiveRound`, `canSelectTeam`, `isWizardComplete`
- `src/Form/Bracket.elm` — direct code reading; `rebuildBracket`, `assignBestThirds`, `setRoundWinners`, `update`
- `src/Form/Bracket/View.elm` — direct code reading; `viewR32Grid`, `viewFlatGrid`, `viewActiveGrid`, `viewSelectableTeam`, `viewBracketMinimap`, `allRounds`
- `src/Bets/Types/Bracket.elm` — direct code reading; `isComplete`, `isCompleteQualifiers`, `setBulk`, `winner`
- `src/Bets/Bet.elm` — direct code reading; `isComplete`
- `src/UI/Button/Score.elm:91` — fixed `px` sizing pattern confirmed at line 91
- `.planning/PROJECT.md` — v1.7 milestone requirements and Key Decisions log (authoritative spec)
- `CLAUDE.md` and `MEMORY.md` — architecture and bracket slot documentation; Issues #81 and #93 history

### Secondary (MEDIUM confidence)
- Elm Discourse — `paragraph` + `clipX` + `height px` + `overflow-wrap: anywhere` text-clip workaround; community-verified, consistent with official elm-ui behavior
- elm-ui GitHub issue #112 — confirms no native `text-overflow: ellipsis` in elm-ui 1.1.8

---
*Research completed: 2026-03-16*
*Ready for roadmap: yes*
