# Phase 19: Group Matches & Bracket Tiles - Context

**Gathered:** 2026-03-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Style the group matches scroll wheel and bracket wizard to display prototype-quality tiles. Changes are purely visual — no navigation logic, routing, or game logic changes. Scope:

1. Score input boxes: full 4-side border, focus state, brighter text on focus
2. Scroll wheel match rows: bordered tile per row, larger SVG flags, active vs inactive states
3. Bracket team tiles: bordered card shape, orange selected state, hover feedback, grey disabled state
4. Bracket round header: title + counter on one line, static instruction description below, "N/M geselecteerd" counter format

</domain>

<decisions>
## Implementation Decisions

### Score Input Border
- Change from bottom-border-only to full 4-side border
- Unfocused state: dim grey border (`Color.terminalBorder`), black background (unchanged)
- Focused state: orange border (`Color.orange`) — use `Element.focused [Border.color Color.orange]`
- Text gets brighter/bolder orange on focus (not just border)
- The surrounding `activeMatch` row container does NOT get a border — only the individual input fields are bordered

### Match Row Box Layout
- Each scroll wheel match row gets a full surrounding border (becomes a tile)
- Active row: orange border, bright text
- Inactive rows: grey border (`Color.terminalBorder`), dimmer text
- Tiles stretch full width of the scroll wheel container
- Flag images increase from 16x16 to approximately 24x24 or 32x20 (slightly larger, still inline)

### Bracket Team Card Shape
- Fixed-width compact rectangle (approx 80px wide × 44px tall), flag on left, team code on right
- Default state: grey border, white/primary text
- Selected state: orange border + very subtle orange-tinted background (~15% opacity amber/orange tint)
- Hover state: border color shifts from grey to dim orange (use `Element.mouseOver [Border.color Color.orange]` or similar)
- Non-selectable/disabled teams: same card shape, all grey border + grey text, no pointer cursor

### Bracket Round Header
- Layout: title + "N/M geselecteerd" counter on the same line (or "N/M geselecteerd ✓" when complete)
- Below the title line: a smaller, grey static instruction text (subtitle) per round
- Static descriptions per round:
  - Ronde van 32 (LastThirtyTwoRound): "Kies 2 landen per groep die doorgaan naar de tweede ronde"
  - Ronde van 16 (LastSixteenRound): "Kies 16 landen voor de achtste finale"
  - Kwartfinale (QuarterRound): "Kies 8 kwartfinalisten"
  - Halve finale (SemiRound): "Kies 4 halvefinalisten"
  - Finalisten (FinalistRound): "Kies de 2 finalisten"
  - Kampioen (ChampionRound): "Kies de wereldkampioen"
- Counter format: "N/M geselecteerd" (replacing the current "(N/M)" short form)
- Description text: smaller font size, grey color — visually secondary to the title

### Claude's Discretion
- Exact pixel dimensions of bracket team cards (around 80×44 but exact sizing is flexible)
- The exact orange tint implementation for selected state (e.g. `rgba(240, 223, 175, 0.15)` or similar)
- Whether to use `Element.mouseOver` attributes directly or add a hover style to `UI.Style`
- Exact flag dimensions (24x24 or 32x20 — whichever looks better in the boxed row)
- Whether `scoreInput` style function in `UI.Style` is updated in-place or a new variant added

</decisions>

<specifics>
## Specific Ideas

- The scroll wheel bordered rows should feel like a "slot machine" column — each match is a distinct card, the active one glows orange
- Bracket team cards should feel like badge-style tiles, similar to the existing `teamBadgeVerySmall` (32×38px) but with a border
- Round header subtitle gives the user a clear instruction at a glance without them needing to guess how many to pick

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `UI.Style.scoreInput` — existing style function to modify (add full border + focused state)
- `UI.Style.activeMatch` — currently empty attrs list; can add border/row styling here
- `UI.Style.terminalInput` — reference for the pattern of `Element.focused [Border.color Color.orange]`
- `UI.Button.teamBadgeVerySmall` — existing badge (32×38px, no click handler); bracket cards should follow this visual language but with a border
- `T.flagUrl (Just team)` + `Element.image` — existing pattern for flag rendering in both GroupMatches.elm and Bracket/View.elm

### Established Patterns
- `Element.focused [...]` — standard elm-ui pattern for focus state styling (used in `terminalInput`)
- `Element.mouseOver [...]` — elm-ui pattern for hover states (not yet used for team tiles, but available)
- `Font.color Color.orange` / `Font.color Color.grey` — used throughout for active/inactive distinction
- `Border.width 1` + `Border.color Color.terminalBorder` — existing terminal-style border pattern
- `Color.orange`, `Color.terminalBorder`, `Color.black`, `Color.panel` — the four colors most relevant to this phase

### Integration Points
- `viewMatchLine` in `Form/GroupMatches.elm` — the function rendering each scroll wheel row; this is where border and flag sizing changes go
- `viewSelectableTeam` and `viewTeamBadge` in `Form/Bracket/View.elm` — team card styling lives here
- `viewRoundSection` in `Form/Bracket/View.elm` — round header (title + counter + new description) is assembled here
- `UI.Style.scoreInput` in `src/UI/Style.elm` — score input styles to update
- `roundTitle` in `Form/Bracket/View.elm` — one place to add a paired `roundDescription` helper function

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 19-group-matches-bracket-tiles*
*Context gathered: 2026-03-09*
