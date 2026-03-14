# Phase 20: Topscorer - Context

**Gathered:** 2026-03-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Style the topscorer card to match the prototype: player items become bordered cards (flag, name, team code, `[x]` selected marker) and the search bar gets a bordered container with `>` prompt and orange focus border. This phase also changes the UX flow from 2-step (pick team → pick player) to a flat searchable player list. No navigation logic, routing, or game logic changes.

</domain>

<decisions>
## Implementation Decisions

### UX Flow
- Switch from 2-step (team → player) to a **flat list of all players**, searchable directly
- Default state (no search query, no selection): show empty list with search prompt only — do not pre-load all ~1100 players
- When user re-opens the topscorer card with a player already selected: show the selected player's card (visible/at top), search field empty

### Search Behavior
- Search matches: **player name** (substring) AND **team code** (substring), case-insensitive
- Uses `String.contains` / `includes` semantics — not prefix-only
- Placeholder text: `"zoek op naam of land..."`
- Empty state message when no results: "Geen spelers gevonden voor '[query]'"

### Player Card Layout
- Two-line text block: player name (larger/primary) on top line, team code (smaller/dimmed) on second line
- Flag on the left, `[x]` marker on the right (only visible when selected)
- Transparent border when unselected (1px transparent — border only appears on hover/selected)
- Card height ~44px, padding ~10px vertical / 12px horizontal (matches prototype `.player-item`)
- Flag size: 24×16 or 32×20 (larger than current 16×16 — consistent with Phase 19 group match rows)

### Selected State
- Remove the `viewSelectedTopscorer` summary line at top — rely solely on the card's selected state
- Selected player card: orange border + `rgba(240,160,48,0.08)` amber background tint + `[x]` marker on right
- Hover state: dim amber border (`Color.amber` or similar) — matches prototype `.player-item:hover`
- Toggle deselect: clicking the selected player again clears the selection (sets topscorer to Nothing)

### Search Bar
- Bordered container (1px `Color.terminalBorder`) wrapping `>` prompt + input field
- Focus state: border turns orange (`Color.orange`) via focus-within equivalent — container border, not just input border
- Input: transparent background, no individual border, inherits font
- Styled similarly to the participant field rows (Phase 21 predecessor pattern)

### Claude's Discretion
- Exact flag pixel dimensions (24×16 vs 32×20 — whichever looks better with the 2-line card)
- How to implement focus-within in elm-ui (may need Html wrapper around the search container, or use `Element.focused` on the input and propagate border via parent)
- Whether `viewTeamRow` and `viewPlayerRow` are fully replaced or refactored into a new `viewPlayerCard`
- Whether to show the selected player card at the top of an empty list, or require typing to see it

</decisions>

<specifics>
## Specific Ideas

- The prototype renders players as `{ name, team, em (flag emoji) }` — Elm uses `TeamDatum.players` (list of strings) + `T.flagUrl`. The flat player list should be built by flatMapping `teamData` → each player name paired with its `TeamDatum`.
- The selected player card should look exactly like the prototype `.p-sel` style: orange border + very subtle amber tint — same aesthetic as Phase 19's bracket selected tiles.

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `Form.Topscorer.elm` — existing module; `viewTeamRow` and `viewPlayerRow` will be replaced with `viewPlayerCard`
- `Bets.Types.Topscorer` — `TS.getPlayer`, `TS.setPlayer`, `TS.getTeam`, `TS.setTeam` — existing setters; flat list approach only uses `setPlayer` (with team embedded in player record or via lookup)
- `Bets.Init.teamData` — `List TeamDatum` with `.players : List String` and `.team : Team` — source for building flat player list
- `T.flagUrl (Just team)` + `Element.image` — existing flag rendering pattern
- `T.display team` — team code string (e.g. "BEL")
- `UI.Style.terminalInput` — reference for `Element.focused [Border.color Color.orange]` pattern (used in participant fields)
- `UI.Style.introduction` — existing paragraph style for intro/warning text

### Established Patterns
- `Element.focused [Border.color Color.orange]` — elm-ui focus state pattern (from terminalInput)
- `Element.mouseOver [Border.color Color.amber]` — elm-ui hover pattern (used in Phase 19 bracket tiles)
- `Border.width 1`, `Border.color Color.terminalBorder` — terminal border pattern
- `Color.orange`, `Color.terminalBorder`, `Color.black`, `Color.panel` — primary color palette
- `Html.input` with `Html.Attributes.style` — used for raw HTML input elements when elm-ui wrapping is needed
- `Background.color (Element.rgba 0.94 0.63 0.19 0.08)` — approximate amber tint for selected state

### Integration Points
- `Form.Topscorer.update` — `SelectPlayer` msg will change: instead of `String` player name, may need team+player pair; or keep player name only and derive team from lookup
- `Form.Topscorer.view` — `searchQuery` param stays; inner `viewTopscorer` function fully rewritten for flat list
- `Form.Topscorer.Types.Msg` — `SelectTeam` msg likely removed or repurposed; `SelectPlayer` may need new type
- `Form.Card.elm` — passes `searchQuery` from `TopscorerCard` state into `Form.Topscorer.view`; no changes needed if signature stays the same

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 20-topscorer*
*Context gathered: 2026-03-09*
