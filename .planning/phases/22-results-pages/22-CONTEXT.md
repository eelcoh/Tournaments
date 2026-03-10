# Phase 22: Results Pages - Context

**Gathered:** 2026-03-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Apply the v1.4 card aesthetic and semantic color coding to all five results pages (Matches, Ranking, Topscorers, Knockouts, Bets). Changes are purely visual — no routing, data model, or API changes.

Requirements in scope: RESULTS-01, RESULTS-02.
RESULTS-03 (group standings semantic colors) is deferred — no group standings table exists in the codebase and building one is out of scope for this phase.

</domain>

<decisions>
## Implementation Decisions

### Match result row layout
- Switch from current wrappedRow of 160×100px tiles to full-width horizontal list rows
- Row format: home team (flag + code) | score | away team (flag + code) — no date or group metadata shown
- Matches grouped under `--- GROEP A ---`, `--- GROEP B ---` etc. section headers (using existing `UI.Text.displayHeader` pattern), then knockout round headers
- Score color: `Color.amber` when result is entered; dimmed grey (`Color.grey`) for unplayed placeholder `_-_`
- Rows use bottom-border separator pattern (1px `Color.terminalBorder`), consistent with prototype `.match-row`
- Apply `#353535` bg + `#4a4a4a` border card container per group section (not per row)

### Page scope
- All 5 results pages get the `#353535` card background with `#4a4a4a` border treatment:
  - **Matches** — group sections as cards, match rows inside as separator-divided rows
  - **Ranking** — each position group as a card (see below)
  - **Topscorers** — each topscorer row as a bordered card item (consistent with form topscorer tiles from Phase 20)
  - **Knockouts** — each team row wrapped in card treatment (even though admin-only)
  - **Bets** — bet summary lines get card treatment

### Ranking card granularity
- Card unit = **position group** (one `RankingGroup` = one `#353535` card with `#4a4a4a` border)
- Inside the card: position (#N) as small dimmed left column, player names as clickable `dataRow` rows, total points as dimmed right column
- Position: inline left column, small, dimmed (`Color.grey`)
- Name: cream (`Color.cream` / default text), full-width, clickable
- Total points: right-aligned, amber (`Color.amber`)
- Multiple players at same position stack vertically inside the single card

### RESULTS-03 (group standings)
- **Deferred** — no group standings table in codebase; building one is a new feature beyond this phase's scope
- Semantic color coding for qualified/third-place/eliminated rows is captured for a future phase

### Claude's Discretion
- Exact grouping logic for match result sections (how to detect group vs knockout matches from `MatchResult.group` field)
- Whether match row uses `matchRowTile` (existing) or a new `matchResultRow` style function
- Exact padding/spacing for horizontal match rows
- How to handle the admin-only edit click handler in match rows (currently `Events.onClick (EditMatch match)`) within the new layout
- Whether Bets and Knockouts pages need display headers restyled or just the content rows

</decisions>

<specifics>
## Specific Ideas

- Match row visual: `NED  2-1  SEN` / `USA  0-0  ENG` — team code + flag inline, score center, clean and minimal
- Ranking card matches the Phase 21 summary box aesthetic — bordered container, dim labels, amber values
- Topscorer rows: apply same bordered tile pattern as Phase 20 form topscorer items (`#353535` bg, `#4a4a4a` border, selected state in green/amber)

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `UI.Style.matchRowTile` — existing `Bool isActive` bordered tile style from Phase 19; may be adapted for results rows (all inactive = same grey border)
- `UI.Style.darkBox` — existing `#353535` bg pattern already used in `Results/Ranking.elm`; Phase 22 makes this consistent across all pages
- `UI.Text.displayHeader` — `--- TITLE ---` format; use for group section headers (e.g., `--- GROEP A ---`)
- `UI.Button.dataRow` — existing clickable row button already used in `viewRankingLine`; keep it for player name rows
- `UI.Color.amber`, `UI.Color.grey`, `UI.Color.terminalBorder` — established color constants for score, dim, and border
- `UI.Team.viewTeam` — existing team display component used in both Matches and Knockouts

### Established Patterns
- `#353535` bg + `#4a4a4a` border = locked card tile pattern (established Phase 19, used in 19–21)
- `Border.widthEach { bottom = 1, ... }` + `Border.color Color.terminalBorder` — separator row pattern used throughout results pages already
- `Element.column [ paddingXY 0 8, width fill, Border.widthEach { bottom = 1 ... } ]` — the current "wrap with separator" pattern in Knockouts and Topscorers
- `Font.color Color.amber` for values, `Font.color Color.grey` for metadata — established semantic color pattern

### Integration Points
- `src/Results/Matches.elm` `displayMatches` / `displayMatch` — main change: switch wrappedRow grid to column list, add group section headers, apply new row style
- `src/Results/Ranking.elm` `viewRankingGroup` — currently uses `darkBox`; replace with explicit `#353535` bg + `#4a4a4a` border card; restyle position + points colors
- `src/Results/Topscorers.elm` `viewTopscorer` / `wrapWithSeparator` — replace separator-only with bordered card per item
- `src/Results/Knockouts.elm` `wrapWithSeparator` — same pattern as Topscorers
- `src/Results/Bets.elm` `viewRow` / `viewAdminRow` — add card treatment to bet summary lines
- `src/UI/Style.elm` — may need a new `resultCard` or `resultRow` style helper to avoid repeating the same attrs across 5 files

</code_context>

<deferred>
## Deferred Ideas

- **RESULTS-03 — Group standings semantic color coding**: Requires building a new group stage standings table view (team rows with W/D/L/Pts, colored by qualification position). This is a new feature, not a styling pass — belongs in its own phase.

</deferred>

---

*Phase: 22-results-pages*
*Context gathered: 2026-03-10*
