# Phase 15: Group Matches Reduction - Context

**Gathered:** 2026-03-08
**Status:** Ready for planning

<domain>
## Phase Boundary

Reduce group stage betting from 72 matches (6 per group × 12 groups) to 36 matches (1 per matchday × 3 matchdays × 12 groups). Preserve the scroll wheel, keyboard-first score input, and group nav unchanged. This phase is data + logic only — visual restyling of match rows is a separate future phase.

</domain>

<decisions>
## Implementation Decisions

### Which matches to keep
- Keep exactly the 36 matches defined in `src/Bets/Init/WorldCup2026/GroupMatches.md` — the specific match IDs per group are already decided; researcher should identify the 1-per-matchday selection from that file
- Remove the other 36 matches from `Tournament.elm`

### Match ID strategy
- Keep existing match IDs (e.g. m01, m25, m53 for Group A) — do NOT renumber to m01–m36
- No changes needed to JSON encoding/decoding

### Scroll wheel ordering
- Group-by-group, matchday order: all 3 matches for Group A, then all 3 for Group B, … through Group L
- Group nav (A B C … L) jumps to the first match of each group — unchanged behavior
- No matchday label per match line (no "MD1" prefix or date prefix)
- Group boundary separators (`-- A --`) unchanged in format

### Completion tracking
- Group complete = 3/3 matches filled (was 6/6); `isCompleteGroup` works automatically once data is reduced
- Group nav completion dot logic unchanged
- Dashboard module description: `"36 wedstrijden in 12 groepen"` (was `"48 wedstrijden in 12 groepen"`)
- Dashboard progress counter reflects the new total (36 matches)

### Visual styling
- No visual changes to match row appearance in this phase
- Scroll wheel layout, colors, and font unchanged

</decisions>

<specifics>
## Specific Ideas

- There is a design prototype at `prototypes/design-prototype.html` showing a future visual direction for the group matches screen. Restyling to match it is explicitly deferred — not part of this phase.

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `src/Bets/Init/WorldCup2026/Tournament.elm` — `matches` function: remove 36 of 72 match definitions (keep one per matchday per group)
- `src/Bets/Init/WorldCup2026/GroupMatches.md` — reference for which matches exist; researcher should identify the 36 to keep
- `src/Bets/Init/Lib.elm` — `groupFirstMatches`: finds first match ID per group from `answers.matches`; works automatically once data is reduced
- `src/Bets/Types/Answer/GroupMatches.elm` — `isComplete` and `isCompleteGroup`: iterate over all matches in the answer; work automatically with fewer matches
- `src/Form/GroupMatches.elm` — `isComplete`: delegates to `GroupMatches.isComplete`; no change needed

### Established Patterns
- `answers.matches` is built from `Tournament.matches` via `Bets.Init.Lib.answerGroupMatch` at init time — reducing matches in `Tournament.elm` is the single source of truth change
- `groupsAndFirstMatch` in `Bets.Init` is computed from `answers.matches` → no change needed, auto-adapts
- Dashboard description text is in `Form/Dashboard.elm` — update the static string for the group stage module

### Integration Points
- `Tournament.elm` `matches` list → `Bets.Init` `answers` → scroll wheel `List MatchID` — reducing the list is the only required data change
- `Form/Dashboard.elm` — update module description string from `"48 wedstrijden in 12 groepen"` to `"36 wedstrijden in 12 groepen"`

</code_context>

<deferred>
## Deferred Ideas

- Visual restyling of group match rows to match the prototype (boxes, colors, emoji flags, modern score inputs) — future phase
- Matchday labels (MD1/MD2/MD3) or date display per match line — not needed for this phase, could be added with the visual restyle

</deferred>

---

*Phase: 15-group-matches-reduction*
*Context gathered: 2026-03-08*
