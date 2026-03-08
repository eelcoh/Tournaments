# Phase 17: Topscorer Search - Context

**Gathered:** 2026-03-08
**Status:** Ready for planning

<domain>
## Phase Boundary

Add a live search/filter input at the top of `TopscorerCard` so players can quickly find a team by name or country code. Filtering affects the team list only. Player search across all teams is out of scope.

</domain>

<decisions>
## Implementation Decisions

### Filtered view layout
- Empty search (no input): show the full grouped layout (A–L headers) exactly as today
- Active search (any input): switch to a flat list with no group headers
- Flat filtered list shows team rows in the same style as today: flag image + team code (e.g. NED) — no group letter added

### Search scope
- Match against both `T.display team` (3-letter code, e.g. NED) and `T.displayFull team` (full name, e.g. Nederland)
- Case-insensitive: `String.toLower` on both query and candidate
- Prefix match only: `String.startsWith` — "ned" matches "NED"/"Nederland", but "land" does NOT match "Nederland"

### Interaction with team selection
- After selecting a team from the filtered list: clear the search query, return to the full grouped view
- Player list (`Kies een speler`) appears in the same position as today — below the current selection display, above the team list
- Search input is always visible, regardless of whether a team is selected

### Empty state
- When the search term matches no teams, show terminal-style message: `geen landen gevonden voor "xyz"` (echoes the search term)

### Input appearance & clearing
- Input prefix/prompt: `> zoeken:` (Dutch, matches `>` prompt pattern used throughout the UI)
- Clearing: backspace only — no dedicated clear button, no Escape key handling
- Uses `UI.Style.terminalInput` style (existing: underline-only border, dark bg, orange focused border)

### Claude's Discretion
- Exact placeholder text inside the input field (if any)
- Whether `> zoeken:` label is rendered as a static `Element.text` prefix or as part of the input value
- Exact spacing between search input and team list

</decisions>

<specifics>
## Specific Ideas

- The `> zoeken:` prompt prefix follows the same convention as score inputs (`>` before home badge) and participant fields
- The flat filtered list reuses the existing `viewTeamRow` function unchanged — only the wrapping changes (no group headers)
- Empty-state message should be monospace, muted color (not orange), consistent with other informational text

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `viewTeamRow` in `Form/Topscorer.elm`: renders a single team row with flag + code + selection indicator — reuse as-is in flat filtered list
- `UI.Style.terminalInput`: existing input style (underline-only, dark bg, orange focused border) — use for the search input
- `UI.Text.displayHeader`: existing section header renderer — used for "Kies een land" header above team list

### Established Patterns
- Card state: `ParticipantCard Participant.State` shows the pattern — `TopscorerCard` needs to become `TopscorerCard { searchQuery : String }` (currently `TopscorerCard` has no fields)
- When adding state to a Card variant, search all files for bare `TopscorerCard ->` patterns — `View.elm`, `Form/View.elm`, `Form/Card.elm`, `Types.elm` all need updating (lesson from memory)
- Msg type: add `UpdateSearch String` to `Form.Topscorer.Types.Msg`
- `update` in `Form/Topscorer.elm` handles `UpdateSearch` by updating the card state (not the Bet)
- Input events: `Html.Events.onInput` via `Element.htmlAttribute` for text input

### Integration Points
- `src/Types.elm` line 92: `TopscorerCard` variant — needs `TopscorerCard { searchQuery : String }`
- `src/Types.elm` line 280: `initCards` initializes `TopscorerCard` — needs `TopscorerCard { searchQuery = "" }`
- `src/Form/Topscorer.elm`: `view` signature changes to accept search state; `update` handles `UpdateSearch`
- `src/Form/Card.elm`: `updateScreenCard` destructures `TopscorerCard` — needs updating
- `src/Form/View.elm`: passes state to `Form.Topscorer.view`

</code_context>

<deferred>
## Deferred Ideas

- None — discussion stayed within phase scope

</deferred>

---

*Phase: 17-topscorer-search*
*Context gathered: 2026-03-08*
