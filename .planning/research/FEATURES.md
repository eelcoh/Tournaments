# Feature Research

**Domain:** Bottom-up bracket selection wizard — multi-round knockout prediction, WC2026 (48 teams, 12 groups, R32 first)
**Researched:** 2026-03-16
**Confidence:** HIGH (based on direct codebase inspection of existing wizard implementation)

## Feature Landscape

### Table Stakes (Users Expect These)

Features the bottom-up wizard is expected to provide. Missing these makes the redesign feel broken or incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| R32-first round order (R32 → R16 → QF → SF → Final → Champion) | Matches natural tournament reasoning: "who qualifies?" before "who wins?" | MEDIUM | `currentActiveRound` currently traverses Champion→R32; must be inverted to R32→Champion. Single function change but load-bearing. |
| Team pool scoped to previous round | Users expect they can only advance teams they actually picked; selecting from the full 48 on R16 would feel wrong | MEDIUM | `viewFlatGrid` already derives the correct pool (e.g. `sel.lastThirtyTwo` for R16). The mapping is: R16 pool = lastThirtyTwo, QF pool = lastSixteen, SF pool = quarters, Final pool = semis, Champion pool = finalists. All already expressed in `viewFlatGrid`. |
| Downstream invalidation when deselecting | Removing a team from R32 must remove them from R16/QF/SF/Final/Champion automatically | LOW | `removeTeamFromAll` already removes a team from all rounds simultaneously. This is already correct for bottom-up; no changes needed. |
| "Max reached" dimming on non-active badges | When a round is full (16/16 in R16), remaining unselected teams must visually dim to show no more picks are allowed | LOW | `canSelectTeam` already returns `False` when round is at capacity. The three-state badge render (selected / selectable / disabled) is already in `viewSelectableTeam`. Only the color treatment needs updating. |
| Green outline for selected badges | Green = "advancing"; orange = "active/highlight" — spec requires green for selections | LOW | `viewSelectableTeam` currently uses `Color.orange` for selected state. Change to `Color.green` with matching tinted background. Change applies to all 3 badge render functions. |
| R32 page: teams grouped by group letter with header | 48 teams is unnavigable without group organization; users look for their national team by group | MEDIUM | `viewR32Grid` already renders group sections with `-- X --` separator text. Group letter header needs style update: 12px, amber color (not grey `--` text). |
| R16 page: flat grid of 32 selected teams | Once R32 is done, users expect to see only their 32 picks, not the full 48 | LOW | `viewFlatGrid` already derives this correctly when `round = LastSixteenRound`. |
| Code-only badges for R32 and R16 | Dense grid for 32-48 teams; full names overflow at mobile width | LOW | Remove `flagImg` and full-name column from badge for these rounds. Show only `T.display team` (3-letter code) at 11px. Badge needs a fixed width so the grid columns align. |
| Full name + code badges for QF through Champion | 8 teams or fewer; richer display is readable and expected at this scale | LOW | Current `viewSelectableTeam` already shows flag + name + code. Apply this layout only for rounds with 8 or fewer picks. The conditional dispatch is new in the view. |
| Fixed-grid layout with consistent column widths | Variable-width shrink badges cause misaligned columns; tapping the right badge on mobile requires predictable hit targets | LOW | Replace `Element.shrink` width with a fixed pixel width on all badges. Column count: 4 on Phone, up to 6 on Computer. Badge width = (available width - spacing) / columns. |
| Minimap dot rail and round jumping | Users need to navigate back to a completed round to change a pick | LOW | Existing `viewBracketMinimap` and `JumpToRound` msg are unchanged. The minimap list already orders R32→Champion. Only the dot color logic (active vs complete) needs to reflect the new active round calculation. |
| "Ga verder" button when wizard is complete | Explicit forward navigation after all 6 rounds filled | LOW | `isWizardComplete` checks `champion /= Nothing && length lastThirtyTwo == 32`. This remains correct. Button renders in `inFront` at bottom of card. |

### Differentiators (Competitive Advantage)

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Group-letter headers styled in amber (12px) | Makes the R32 grid immediately scannable; user can jump to "Group C" at a glance | LOW | Styled `Element.el` at 12px amber replacing the current grey `-- X --` separator. Same data, better visual hierarchy. |
| Per-round badge header with live counter | "8/16 geselecteerd" tells users exactly where they are without counting manually | LOW | Already exists as `counterText` in `viewRoundSection`. Keep it. Ensure it updates reactively on every pick. |
| Cascade invalidation is silent and immediate | When you remove a team from R32, their downstream appearances vanish in the same render cycle. The constraint model is transparent. | LOW | `removeTeamFromAll` already does atomic cascade. No extra state or animation needed. |
| One active round at a time | Keeps focus; prevents trying to fill QF before R16 is done | LOW | `viewActiveGrid` only renders for `activeRound`. Non-active rounds show their placed badges summary only. This pattern already exists; active round detection just needs inversion. |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Auto-advance to next round when a round is full | "Save the user a tap" | Removes review opportunity; user may want to check picks before moving on; "Ga verder" button is explicit and fast | Keep explicit "Ga verder" button; do not auto-navigate |
| Flag images in R32 / R16 dense grid | "Looks nicer" | 28×20px flag at code-only badge size doubles badge width and destroys the dense grid; 48 flags on one page is visual noise | Code-only for R32/R16; flags already appear in QF–Champion where tiles are bigger and fewer |
| Drag-to-reorder within a round | "Feels interactive" | Round selections are unordered sets; ordering semantics would be misleading; elm-ui has no drag-and-drop without custom ports | Tap-to-toggle select/deselect; deselect and reselect to "change" a pick |
| Show the full bracket tree diagram | "Looks like a real bracket" | A 48-team bracket tree is illegible at 375px; implementing a tree layout in elm-ui requires significant custom layout work | Minimap dot rail communicates structure; `rebuildBracket` handles the actual data representation |
| Animate round transitions | "Polish" | elm-ui has no animation primitives; `htmlAttribute` CSS workarounds are fragile; wrong priority for this milestone | Static sections; minimap jump provides instant navigation |
| Per-round "undo last pick" button | "Easy correction" | Tapping a selected badge to deselect already handles this; a separate button duplicates functionality | Tap selected badge to deselect — same gesture, zero extra UI |
| Remove auto-downstream fill but keep auto-downstream add for higher rounds | "Picking a semifinalist should auto-select them for R32" | In bottom-up, the user owns each round explicitly. Auto-fill breaks the mental model: "I picked R16 already, why did R32 change?" | Bottom-up means each round is filled independently. The only cascade is removal (downstream deselect on upstream remove), which preserves consistency. |

## Feature Dependencies

```
Inverted currentActiveRound (R32 → Champion)
    required by --> All round pages rendering correctly as bottom-up
    conflicts with --> existing addTeamToRound auto-downstream fill

Simplified addTeamToRound (no auto-downstream fill)
    required by --> Bottom-up semantics (each round filled independently)
    replaces --> existing addTeamToRound behavior for ChampionRound/FinalistRound/SemiRound/QuarterRound/LastSixteenRound

Pool scoping per round
    required by --> R16, QF, SF, Final, Champion pages
    already correct in --> viewFlatGrid (pool derived from previous round selections)

Fixed-width code-only badge (R32/R16)
    required by --> Dense grid layout
    requires --> Fixed pixel width on Element.el (not Element.shrink)
    shared between --> R32 grouped view and R16 flat view

Full-name+code badge (QF–Champion)
    required by --> QF, SF, Final, Champion pages
    already present in --> viewSelectableTeam (flag + name + code)
    conditional on --> round being QF or above

Green selected state
    required by --> All badge states across all rounds
    replaces --> Color.orange in viewSelectableTeam selected branch

removeTeamFromAll cascade
    already correct --> No changes needed
    ensures --> downstream round consistency on any deselection

R32 group header styling (12px amber)
    enhances --> Group-organized R32 display
    replaces --> grey "-- X --" separator in viewR32Grid
```

### Dependency Notes

- **Inverted `currentActiveRound` conflicts with `addTeamToRound` auto-fill:** The current `addTeamToRound` for `ChampionRound` auto-adds the team to finalists, semis, quarters, lastSixteen, and lastThirtyTwo. This made sense for top-down. In bottom-up, picking the champion should NOT auto-fill R32. The simplest fix is to strip out all downstream cascade from `addTeamToRound`; each round only adds to its own field. The removal cascade in `removeTeamFromAll` is unchanged and remains correct.

- **Pool scoping is already implemented:** `viewFlatGrid` already uses `sel.lastThirtyTwo` as the pool for R16, `sel.lastSixteen` for QF, etc. This code needs no changes; the routing to it just needs to apply to the new active-round logic.

- **Fixed-width badges are a new layout contract:** Current badges use `Element.shrink`. For a dense grid to be scannable, all cells in a column must be the same width. The width value depends on column count and available space. On Phone with 4 columns and ~320px usable width: `(320 - 3*12) / 4 = 71px`. This is the only non-trivial layout calculation in the redesign.

- **Green vs orange selected state:** The spec (PROJECT.md active milestone) states green outline for selected. `Color.green` exists in `UI.Color`. This is a surgical change in `viewSelectableTeam` (one line per selected branch) but must be applied consistently in `viewTeamBadge` and `viewPlacedBadge` as well.

## MVP Definition

### Launch With (v1.7)

All items are required per PROJECT.md active milestone scope.

- [ ] Inverted `currentActiveRound` traversal (R32 checked first) — makes the wizard flow bottom-up
- [ ] Simplified `addTeamToRound` (no auto-downstream fill) — correct bottom-up semantics
- [ ] R32 grouped display with 12px amber group-letter headers — scannable 48-team grid
- [ ] R16 flat grid (pool = lastThirtyTwo selections) — code-only, fixed-width badges
- [ ] QF through Champion pages (pool = previous round) — full-name+code badges
- [ ] Green outline selected state, dimmed max-reached state — spec-correct visuals
- [ ] Fixed-grid badge layout (consistent column widths) — predictable mobile tap targets

### Add After Validation (v1.x)

- [ ] Per-group selection count in R32 header (e.g. "A — 2/4 geselecteerd") — low effort, adds clarity near completion

### Future Consideration (v2+)

- [ ] Animated round transitions — deferred; elm-ui animation requires significant effort for marginal UX gain

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Inverted round traversal (bottom-up flow) | HIGH | LOW | P1 |
| Remove auto-downstream fill from addTeamToRound | HIGH | LOW | P1 |
| R32 group-organized display with amber headers | HIGH | LOW | P1 |
| Pool scoping per round (R16 from R32, etc.) | HIGH | LOW (viewFlatGrid already correct) | P1 |
| Code-only badges for R32 / R16 | MEDIUM | LOW | P1 |
| Full name+code badges for QF–Champion | MEDIUM | LOW | P1 |
| Fixed-width grid layout | MEDIUM | LOW | P1 |
| Green selected / dimmed max-reached badge states | MEDIUM | LOW | P1 |
| Per-group selection count in R32 header | LOW | LOW | P2 |
| Animated round transitions | LOW | HIGH | P3 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## UX Navigation Patterns

### Navigation: Bottom-Up Wizard

The standard multi-step selection wizard pattern:
1. User sees R32 as the initial active round (48 teams, grouped by group A–L)
2. User selects 32 teams (max 3 per group, exactly 2 from each group that qualifies normally, BestThird slots for the 8 extras)
3. When R32 is full (32/32), "Ga verder" button appears in the active round header OR user taps minimap
4. R16 becomes active: shows the 32 R32 selections as the selectable pool
5. User selects 16 teams; when done, advance to QF
6. Continue through QF (8), SF (4), Final (2), Champion (1)

### Navigation: Minimap Dot Rail

- All 6 rounds are always visible as dots in the minimap
- Dot states: green (complete), amber (active/current), grey (not yet reachable or empty)
- Tapping any dot jumps to that round via `JumpToRound`
- A completed round can be revisited to change picks (deselect + reselect)
- Changing a pick in an earlier round cascades: downstream rounds lose the deselected team

### Validation Behavior

| Action | Behavior |
|--------|----------|
| Tap unselected team (round not full) | Team added to round; badge turns green; counter increments |
| Tap unselected team (round is full) | Nothing happens (badge is dimmed/disabled) |
| Tap selected team | Team removed from this round AND all downstream rounds (`removeTeamFromAll`); badge reverts to selectable state |
| Try to pick same team twice | Deduplicated by `addUnique` — no effect |
| R32 group constraint (3 per group max) | 4th pick from same group is disabled via `canSelectTeam` group constraint |
| Jump to R16 before R32 is full | Allowed (minimap jump); R16 grid shows the partial R32 pool |
| "Ga verder" button appears | Only when `isWizardComplete` (champion set AND 32 in lastThirtyTwo) |

### State Cascade Rules

Removing a team propagates down only (never up):
- Remove from R32 → remove from R16, QF, SF, Final, Champion if present
- Remove from R16 → remove from QF, SF, Final, Champion if present
- Remove from QF → remove from SF, Final, Champion if present
- Remove from SF → remove from Final, Champion if present
- Remove from Final → remove from Champion if present
- All of this is already implemented in `removeTeamFromAll`

Adding a team propagates to no other rounds (bottom-up: you explicitly pick each round).

## Competitor Feature Analysis

This is a private betting pool; no direct competitors. Reference UX patterns:

| Pattern | Source | Our Approach |
|---------|--------|--------------|
| Bottom-up bracket (R32 first) | Standard bracket prediction apps (e.g. ESPN bracket challenge for March Madness) | Wizard enforces round order; minimap for non-linear navigation |
| Group-organized large team pool | UEFA Champions League fantasy picks, bracket challenges with large fields | Group letter headers at 12px; 4-column grid; group constraint enforced live |
| Badge state: selected / selectable / dimmed | Mobile selection UIs (e.g. ticket seat selection, food delivery option grids) | Three-state badge render already in place; green selected / grey disabled |
| Dense code-only grid for large pools | Tournament bracket apps on mobile | 11px code-only badges, fixed width, 4 columns on Phone |
| Round counter in section header | Step-wizard patterns (e.g. "2 of 5 selected") | Already in `viewRoundSection` as `counterText`; keep it |

## Sources

- `/home/eelco/Source/elm/Tournaments/src/Form/Bracket/Types.elm` — type model for WizardState, RoundSelections, canSelectTeam, addTeamToRound, removeTeamFromAll (HIGH confidence, direct code inspection)
- `/home/eelco/Source/elm/Tournaments/src/Form/Bracket/View.elm` — existing view: viewRoundSection, viewR32Grid, viewFlatGrid, viewSelectableTeam, viewBracketMinimap (HIGH confidence, direct code inspection)
- `/home/eelco/Source/elm/Tournaments/src/Form/Bracket.elm` — update loop and rebuildBracket (HIGH confidence, direct code inspection)
- `/home/eelco/Source/elm/Tournaments/.planning/PROJECT.md` — v1.7 milestone requirements and constraints (HIGH confidence, authoritative spec)
- `/home/eelco/Source/elm/Tournaments/src/Bets/Init/WorldCup2026/Tournament.elm` — group structure, 12 groups A–L, 48 teams, BestThird slot definitions (HIGH confidence, direct code inspection)

---
*Feature research for: Bottom-up bracket wizard redesign — WC2026 betting SPA (v1.7 milestone)*
*Researched: 2026-03-16*
