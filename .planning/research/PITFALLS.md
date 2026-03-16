# Pitfalls Research

**Domain:** Bracket wizard redesign — bottom-up selection (R32 → Champion) in Elm 0.19.1 + elm-ui SPA
**Researched:** 2026-03-16
**Confidence:** HIGH (sourced from direct codebase analysis of the files being changed)

---

## Critical Pitfalls

### Pitfall 1: addTeamToRound upward cascade survives the direction flip

**What goes wrong:**
The current `addTeamToRound` in `Form.Bracket.Types` propagates upward — selecting `LastThirtyTwoRound` auto-adds the team to `lastSixteen`, `quarters`, `semis`, `finalists`, and `champion`. This was correct for top-down (picking the champion implied they won every prior round). For bottom-up flow, selecting a team in R32 must NOT pre-populate R16 or above — the user has not decided yet whether that team advances. If the propagation logic is not stripped, the `N/M geselecteerd` counters for all six rounds immediately jump to their max as soon as R32 is filled, and `isWizardComplete` returns True before the user has made any R16+ decisions.

**Why it happens:**
The cascade is baked into `addTeamToRound` as explicit field assignments (`{ sel | lastSixteen = addUnique team sel.lastSixteen, ... }`). After reversing the wizard direction, only the view and navigation logic visibly change; the state mutation function looks unchanged and still compiles, so its implicit side effect is easy to miss. The Elm compiler will not complain — all fields still have valid types.

**How to avoid:**
Rewrite `addTeamToRound` so each round only writes to its own field. `LastThirtyTwoRound` sets only `lastThirtyTwo`. `LastSixteenRound` sets only `lastSixteen`. No round propagates to any higher round. Verify by adding a single team to `LastThirtyTwoRound` on an empty `RoundSelections` and asserting that `lastSixteen`, `quarters`, `semis`, `finalists`, and `champion` are all unchanged.

**Warning signs:**
- `canSelectTeam round team sel` returns False for an R16 team the user just tapped because they are already in `lastSixteen` (from the cascade)
- All six minimap dots turn green immediately after R32 is filled

**Phase to address:**
Phase 1 — rewrite `Form.Bracket.Types`. Must be done before any view work, as the incorrect cascade will corrupt all downstream state.

---

### Pitfall 2: removeTeamFromAll must still cascade downward on deselection

**What goes wrong:**
In bottom-up flow, when the user deselects a team from R32, that team must also be removed from R16, QF, SF, Final, and Champion (if they were previously advanced through those rounds). The current `removeTeamFromAll` already does this correctly for top-down. The risk is that a refactor wanting to introduce a scoped `removeTeamFromRound` function forgets that higher rounds must also be cleaned. If a team is removed from R16 but stays in `quarters`, `rebuildBracket` will call `setRoundWinners` for QF with a team whose R16 slot is empty, producing a `MatchNode` with `Winner` set to a team that has no `qualifier` in the bracket tree.

**Why it happens:**
The new bottom-up `addTeamToRound` only writes to one field (the fix for Pitfall 1). It then feels natural to mirror that and make `removeTeamFromRound` remove from one field too. But the invariant is asymmetric: adding is scoped to one round, removing must cascade to all higher rounds.

**How to avoid:**
Keep `removeTeamFromAll` as a full cross-round removal. Do not introduce a `removeTeamFromRound` variant. Document the asymmetry with a comment: "add is scoped, remove always clears all higher rounds to maintain the subset invariant." Verify: select a team in R32, advance them to R16 and QF, then deselect them from R16; assert that `quarters`, `semis`, `finalists`, and `champion` are also cleared.

**Warning signs:**
- After deselecting a team from R16, their name still appears in the QF placed-badges row
- `rebuildBracket` sets a MatchNode winner to a team with no qualifier in the bracket tree (orphan winner)

**Phase to address:**
Phase 1 — rewrite `Form.Bracket.Types`. Validate before writing `rebuildBracket`.

---

### Pitfall 3: rebuildBracket assumes position-in-list encodes first/second/third-place role

**What goes wrong:**
`rebuildBracket` reads `selections.lastThirtyTwo` as an ordered list where insertion position within a group determines bracket role: position 0 → `WX` (group winner), position 1 → `RX` (runner-up), position 2 → third-place candidate for `assignBestThirds`. With bottom-up flow and a group-organised R32 grid, there is no enforced tap order. The first team the user taps for a group becomes position 0 and is assigned `WX`. If the user taps a team they intended as third-place before the runner-up, `rebuildBracket` assigns them to `WX` instead of a `TX` slot. The bracket tree is silently corrupted: a group winner is a team the user never intended to win the group.

**Why it happens:**
`teamsInGroup` in `rebuildBracket` uses `List.filter (\t -> ...) selections.lastThirtyTwo`, which preserves the order of `lastThirtyTwo` (insertion order). There is no semantic distinction in the list between first/second/third — the position is the only signal.

**How to avoid:**
The cleanest fix is to separate first/second selections from third-place candidates structurally. Two options: (a) cap `lastThirtyTwo` at exactly 2 per group and introduce a separate `thirdPlaceCandidates : List Team` field in `RoundSelections`; or (b) present the R32 grid with explicit role assignment (e.g. tapping a team the third time marks them as "best-third candidate" with a visual distinction). Option (a) is the smaller change. Option (b) is the better UX. Choose before writing any `rebuildBracket` changes; the data model shape must be stable first.

**Warning signs:**
- A team that appears as position 0 in `lastThirtyTwo` for group G is assigned to `WG` even though the user intended them as the runner-up
- `assignBestThirds` receives an empty `thirdPlaceTeams` list even though some groups have 3 selections

**Phase to address:**
Phase 1 — define the new R32 selection model shape. This must be resolved before any `rebuildBracket` rewrite begins; an incorrect data shape invalidates all subsequent work.

---

### Pitfall 4: currentActiveRound returns ChampionRound on empty state, breaking initial render

**What goes wrong:**
`currentActiveRound` scans the round list in the order `[ ChampionRound, FinalistRound, SemiRound, QuarterRound, LastSixteenRound, LastThirtyTwoRound ]` and returns the first incomplete round. On empty `RoundSelections`, every round is incomplete, so the function returns `ChampionRound`. This is used in `Form.Bracket.View` as the fallback when `wizardState.viewingRound = Nothing`. On the very first render of the bracket wizard, the user is presented with the champion picker on an empty state — the exact opposite of bottom-up flow, which should open on `LastThirtyTwoRound`.

**Why it happens:**
The scan order was designed for top-down. The function is correct for top-down flow and is the first-render fallback, so it has never needed to change. After reversing the wizard direction, only the view layout changes are visible; the scan order inside a pure helper function is easy to overlook.

**How to avoid:**
Reverse the round scan list to `[ LastThirtyTwoRound, LastSixteenRound, QuarterRound, SemiRound, FinalistRound, ChampionRound ]`. Also update `viewBracketMinimap` in `View.elm` which renders dots left-to-right; the current order `[ R32, R16, KF, HF, F, Champion ]` is already left-to-right and correct for bottom-up display — verify it is not reversed accidentally. Test: `currentActiveRound emptyRoundSelections == LastThirtyTwoRound`.

**Warning signs:**
- Fresh bracket wizard opens on the champion picker
- `viewingRound = Nothing` on first render shows the champion grid

**Phase to address:**
Phase 1 — rewrite state logic in `Form.Bracket.Types`. This is a one-line list reversal but must be done in the first phase since it affects all subsequent UX testing.

---

### Pitfall 5: isWizardComplete does not validate intermediate rounds

**What goes wrong:**
Current `isWizardComplete` checks `champion /= Nothing && List.length lastThirtyTwo == 32`. For bottom-up flow, a user who fills all 32 R32 selections and immediately selects a champion (skipping R16, QF, SF, Final) satisfies this condition. The "Ga verder" button appears even though R16 through Final are empty. The submitted `Bet` will have a bracket with `TeamNode` qualifiers set (from `setBulk`) but all `MatchNode` winners left as `None` (since `setRoundWinners` found no teams in `lastSixteen` to propagate). `isCompleteQualifiers` returns False, blocking submission.

**Why it happens:**
The old top-down `addTeamToRound` cascade guaranteed that selecting the champion implicitly filled all rounds above. The `isWizardComplete` shortcut was correct in that world. In bottom-up, with no cascade, each round is independent and must be checked individually.

**How to avoid:**
`isWizardComplete` must check all six rounds: `List.length lastThirtyTwo == 32 && List.length lastSixteen == 16 && List.length quarters == 8 && List.length semis == 4 && List.length finalists == 2 && champion /= Nothing`. The per-group constraint (min 2 per group in `lastThirtyTwo`, which was the Issue #93 fix) must remain and applies only to R32. Test the edge case: R32 full, champion selected, all other rounds empty — `isWizardComplete` must return False.

**Warning signs:**
- "Ga verder" button appears after filling only R32 and champion
- `isCompleteQualifiers` returns False on the submitted Bet even though "Ga verder" was accessible

**Phase to address:**
Phase 1 — rewrite state logic in `Form.Bracket.Types`, same function as Pitfall 4.

---

### Pitfall 6: viewActiveGrid uses the full 48-team R32 grid for all rounds on Phone

**What goes wrong:**
`viewActiveGrid` in `Form.Bracket.View` checks `dev` (Phone vs Computer) and always routes Phone to `viewR32Grid` — the group-organised grid showing all 48 teams. This was intentional for top-down flow (comment: "no pre-filtered pool available for higher rounds"). For bottom-up, R16 must show only the 32 teams the user selected in R32; QF must show only the 16 R16 selections; and so on. If `viewR32Grid` continues to be used for all rounds on Phone, users selecting R16 teams see all 48 groups and must hunt for teams they previously selected. Teams they did not select for R32 remain tappable via `canSelectTeam` (which would allow adding a team to R16 that is not in R32 — a logical impossibility).

**Why it happens:**
The comment in `viewActiveGrid` is explicit about the limitation but frames it as acceptable for top-down. The `viewFlatGrid` function already exists and correctly shows the filtered pool from the previous round. It is just not wired for Phone in `viewActiveGrid`.

**How to avoid:**
For bottom-up: `LastThirtyTwoRound` uses `viewR32Grid` (full 48 teams). All higher rounds (`LastSixteenRound` through `ChampionRound`) use `viewFlatGrid` regardless of device. Remove the `dev` branch in `viewActiveGrid` or rewrite it to only apply `viewR32Grid` for `LastThirtyTwoRound`. Also update `canSelectTeam` to enforce that a team must be in the previous round's selection before they can be added to the current round.

**Warning signs:**
- On R16 page, all 48 teams are shown grouped by group letter instead of the 32 R32 selections
- User can select a team for R16 who is not in their R32 list

**Phase to address:**
Phase 2 — view layer rewrite. The data model (Phase 1) must be stable before the grid routing is changed.

---

### Pitfall 7: elm-ui has no native text clip — badge text overflows at 320px

**What goes wrong:**
The new R32 and R16 pages use code-only badges (3-char team codes at 11px) in a 4-column grid. QF through Champion pages show full team names (clipped at 11px) plus code. elm-ui has no direct `overflow: hidden` or text-clip attribute on `Element.el`. When a full name like "Saudi Arabia" (12 chars at 11px Martian Mono) is placed in a fixed-width badge at 320px (roughly 75px per column), the text overflows its container and overlaps adjacent badges.

**Why it happens:**
elm-ui renders using `display: flex`. Text clipping requires `overflow: hidden; white-space: nowrap` on the container, which elm-ui does not expose as a first-class attribute. `Element.width (Element.px N)` constrains the layout box but does not clip text content. Developers assume `width fill` or `width px N` will prevent overflow — they constrain layout but not text rendering.

**How to avoid:**
Use `Element.clip` (available in elm-ui, maps to `overflow: hidden`) combined with `Element.width (Element.px N)` on the text element for full-name badges. For code-only badges, use `Element.shrink` — 3 Martian Mono chars at 11px are narrow enough that overflow is not a concern. Test the full-name grid specifically at 320px viewport width (the minimum for WC2026 target devices) before declaring the view phase done. The existing `viewSelectableTeam` uses `Element.width Element.shrink` on the tile, which allows tiles to grow — fix the inner text width, not the outer tile width.

**Warning signs:**
- Team name text visually overlaps the adjacent tile at 320–375px
- Grid looks correct at 768px but broken at 375px
- `Element.clip` is missing from the text element attribute list

**Phase to address:**
Phase 2 — view layer, R32/R16 badge grid. Must include a 320px viewport manual check before phase sign-off.

---

### Pitfall 8: FillAllBet (test mode) constructs RoundSelections in top-down order

**What goes wrong:**
`FillAllBet` in the test-mode update branch constructs a `RoundSelections` record and calls `rebuildBracket`. After the bottom-up rewrite, `rebuildBracket` may enforce new invariants (e.g. R16 teams must be a subset of R32 teams). If `FillAllBet` still constructs selections using the old top-down propagation pattern (setting `champion` first and deriving down), and if the new `addTeamToRound` no longer cascades, the programmatic construction will leave intermediate rounds empty. `isWizardComplete` returns False, the minimap shows amber/grey dots, and the bracket card shows `[.]` incomplete.

**Why it happens:**
`FillAllBet` is a test-mode helper written once and rarely touched. It relies on the implementation details of `addTeamToRound` propagation. When that changes, test mode is silently broken.

**How to avoid:**
After rewriting the wizard, update `FillAllBet` to construct `RoundSelections` bottom-up: populate `lastThirtyTwo` first (32 teams, 2-3 per group), then `lastSixteen` (16 from that pool), then `quarters`, `semis`, `finalists`, and `champion`. Do not use `addTeamToRound` in a loop for `FillAllBet` — construct the `RoundSelections` record directly with all fields set. Verify by running test mode fill-all and checking that all minimap dots are green and `isCompleteQualifiers model.bet` returns True.

**Warning signs:**
- After "fill all" in test mode, bracket card shows `[.]` instead of `[x]`
- Some minimap dots are amber or grey after fill-all
- `isWizardComplete` returns False after programmatic fill

**Phase to address:**
Final phase — after all logic and views are stable. Test mode is a validation mechanism; update it last.

---

### Pitfall 9: canSelectTeam does not enforce the previous-round membership invariant

**What goes wrong:**
`canSelectTeam` currently checks: (a) round capacity not exceeded, (b) team not already in round, (c) group quota ≤ 3 for R32. It does not check that a team being added to R16 is already in `lastThirtyTwo`. In bottom-up flow, this means a user on the R16 page (via `JumpToRound LastSixteenRound`) can select a team that was never chosen in R32. `rebuildBracket` then processes `lastSixteen` containing a team whose group slot (`WX`/`RX`) has `qualifier = Nothing`, causing `setRoundWinners` to silently skip that match. The bracket appears to have an R16 selection that produces no winner in the tree.

**Why it happens:**
`canSelectTeam` was written for top-down, where the pool was always the same 48 teams and the group quota was the only meaningful constraint. For bottom-up, pool membership in the previous round is a new logical constraint that did not previously exist.

**How to avoid:**
Add a fourth check to `canSelectTeam` for all rounds above R32: the team must be present in the previous round's selection list. Specifically: for `LastSixteenRound`, check `List.any (\t -> t.teamID == team.teamID) sel.lastThirtyTwo`; for `QuarterRound`, check `sel.lastSixteen`; and so on. This makes out-of-pool teams non-interactive (grey, non-tappable) in the grid, matching the "dimmed when round max reached" badge spec from `PROJECT.md`.

**Warning signs:**
- A team appears as selectable in R16 that is not shown in any placed-badge row for R32
- After selecting an out-of-pool team in R16, `rebuildBracket` produces a bracket where that team's MatchNode never gets a winner set

**Phase to address:**
Phase 1 — rewrite `canSelectTeam` in `Form.Bracket.Types`. This is a prerequisite for correct `viewFlatGrid` behavior.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Keeping `viewR32Grid` for all rounds on Phone | No per-round view routing needed | R16+ rounds show 48 teams instead of the 32-team filtered pool; users must find their R32 selections manually | Never acceptable in the final design |
| Leaving `GoNext` as a no-op in `update` | No navigation wiring needed during wizard development | "Ga verder" button does nothing; user cannot advance | Acceptable only during wizard development; must be wired before shipping |
| Hardcoded `r1Slots` through `r5Slots` string lists in `rebuildBracket` | Simple and readable | If slot IDs change (new tournament), must update manually | Acceptable for WC2026; add a comment pointing to Tournament.elm slot origin |
| Using insertion order in `lastThirtyTwo` to encode first/second/third role | No extra model field needed | Tap order determines bracket role — user cannot correct a wrong order without full deselect/reselect | Never acceptable; separate the third-place candidates structurally |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| `rebuildBracket` + `updateBracket` called from `FillAllBet` | Constructing `RoundSelections` with old top-down cascade assumptions after `addTeamToRound` no longer cascades | Build the `RoundSelections` record directly with all six fields populated in bottom-up order |
| `BracketCard` pattern match in `Form/Card.elm` and `View.elm` | Bare `BracketCard ->` pattern fails to compile if the `BracketCard` payload record gains a new field | Search all files for `BracketCard` pattern matches before changing the Card variant — MEMORY.md notes `View.elm` and `Form/View.elm` both had extra matches in past issues (#81, #93) |
| `Bets.Init.teamData` passed to `rebuildBracket` | Caching it in Model and passing a stale copy after a tournament data change | Always call `Bets.Init.teamData` at the call site; it is a pure constant |
| `canSelectTeam` group constraint | For bottom-up with 2-per-group cap (if third-place candidates are moved to a separate field), the constraint `countGroupInList grp sel.lastThirtyTwo < 3` allows one more than the UI permits | Align the constraint threshold with the actual cap chosen for `lastThirtyTwo`: 2 if third-place candidates are in a separate field, 3 if still in `lastThirtyTwo` |

---

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| `List.filter` over 48 teams × 12 groups on every `view` call | Sluggish re-render when tapping rapidly | `Bets.Init.groupMembers grp` is a pure function over a small list; not worth optimising | Never a real problem at 48 teams |
| `extractBestThirdSlots` traversing the full bracket tree on every `rebuildBracket` call | Slightly slower rebuild | Extract the 8 best-third slot definitions once at init time as a constant | Never a real problem for a 32-match tree |
| All 6 round sections rendered as `Element.column` even when 5 are inactive | Full DOM for all sections even if only header + placed badges are shown | Already handled: inactive rounds render `grid = Element.none`; active round renders the full grid | No scaling issue |

---

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| R16 grid shows 48 teams (not 32 R32 selections) | User must find their own earlier picks in a sea of all teams | Filter R16 grid to `sel.lastThirtyTwo`; use `viewFlatGrid` for all rounds above R32 |
| No dimming when a round's max capacity is reached | User taps a team, nothing happens; they cannot tell if the round is full | `canSelectTeam` already returns False at capacity; ensure the grey non-pointer tile state is visually obvious against the orange selected state |
| "Ga verder" sticky button obscures last badge row | User cannot see or tap the last badge tile | Apply `Element.paddingEach { bottom = 72 }` to the page column when `isWizardComplete = True`, or ensure the inFront button does not overlap scrollable content |
| Deselecting the champion requires knowing to tap the placed badge | Users do not know the placed badge is tappable | Show the deselect affordance consistently: the placed badge's `onClick DeselectTeam team` is already there; ensure the cursor is `pointer` and there is hover feedback |

---

## "Looks Done But Isn't" Checklist

- [ ] **Direction fix:** `currentActiveRound emptyRoundSelections == LastThirtyTwoRound` — not `ChampionRound`
- [ ] **No upward cascade on add:** Select one team in R32 on an empty state; `sel.lastSixteen` is still `[]`
- [ ] **Downward cascade on remove:** Select a team in R32, advance them to R16 and QF, then deselect from R16; verify QF, SF, Final, and Champion are also cleared
- [ ] **Previous-round membership enforced:** On R16 page, only the 32 R32 selections are tappable; teams not in R32 are grey and non-interactive
- [ ] **isWizardComplete all-rounds check:** With R32 full and champion selected but R16 empty, `isWizardComplete` returns False
- [ ] **rebuildBracket partial state:** With R32 complete and R16 partially filled, `isCompleteQualifiers` returns False
- [ ] **BestThird ordering regression not reintroduced:** With 8 groups supplying third candidates, all T1–T8 slots are assigned; the most-constrained-first sort is still present in `assignBestThirds`
- [ ] **elm-ui overflow at 320px:** Render the QF+ full-name grid at 320px; no badge text overflows its tile boundary
- [ ] **FillAllBet in test mode:** Fill-all shows all minimap dots green; `isCompleteQualifiers model.bet == True`
- [ ] **GoNext wired:** Tapping "Ga verder" advances to TopscorerCard

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| addTeamToRound still cascades upward | LOW | Strip cascade from each round branch; leave only the single-field write; verify with empty-state test |
| removeTeamFromAll scoped to one round | LOW | Restore the cross-all-rounds removal; test champion deselection via R32 removal |
| rebuildBracket BestThird ordering regression | MEDIUM | Re-add the `List.sortBy (\(grp, _) -> countOptions grp)` before the greedy loop; test with combo A,B,C,D,E,F,K,L |
| currentActiveRound returns wrong round | LOW | Reverse the round scan list; one-line fix |
| elm-ui text overflow | LOW | Add `Element.clip` + `Element.width (Element.px N)` on the text element; test at 320px |
| FillAllBet broken after rewrite | LOW | Reconstruct `RoundSelections` with all six fields populated in bottom-up order; verify via test mode |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| addTeamToRound upward cascade | Phase 1: Rewrite state model | Add to R32; assert R16+ unchanged |
| removeTeamFromAll scoped incorrectly | Phase 1: Rewrite state model | Remove from R16; assert QF+ cleared |
| rebuildBracket BestThird role encoding | Phase 1: Define R32 selection model shape | `assignBestThirds` receives correct third-place team list |
| currentActiveRound inverted direction | Phase 1: Rewrite state logic | `currentActiveRound emptyRoundSelections == LastThirtyTwoRound` |
| isWizardComplete insufficient validation | Phase 1: Rewrite state logic | Returns False when any intermediate round is under capacity |
| canSelectTeam missing previous-round check | Phase 1: Rewrite canSelectTeam | Out-of-pool teams are grey and non-tappable in R16+ |
| viewActiveGrid uses full grid for all rounds | Phase 2: Rewrite view layer | R16 grid shows 32 teams, not 48 |
| elm-ui text overflow at 320px | Phase 2: Build badge grid | Manual 320px viewport check |
| FillAllBet broken after rewrite | Final phase: Test mode validation | Fill-all; all dots green; isCompleteQualifiers True |

---

## Sources

- Direct analysis of `src/Form/Bracket/Types.elm` (addTeamToRound, removeTeamFromAll, currentActiveRound, isWizardComplete, canSelectTeam)
- Direct analysis of `src/Form/Bracket.elm` (rebuildBracket, assignBestThirds, setRoundWinners)
- Direct analysis of `src/Form/Bracket/View.elm` (viewR32Grid, viewFlatGrid, viewActiveGrid, viewSelectableTeam)
- Direct analysis of `src/Bets/Types/Bracket.elm` (isComplete, isCompleteQualifiers, setBulk, winner)
- `.planning/PROJECT.md` — v1.7 milestone requirements, Key Decisions log
- Project MEMORY.md — Issue #93 bug history (isComplete vs isCompleteQualifiers, assignBestThirds most-constrained-first fix, viewCompletionButton group count check), Issue #81 bracket wizard history
- elm-ui 1.1.8: `Element.clip` is available and maps to `overflow: hidden` on the container element

---

*Pitfalls research for: WC2026 bracket wizard bottom-up redesign (v1.7 milestone)*
*Researched: 2026-03-16*
