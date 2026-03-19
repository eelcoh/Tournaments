# Phase 32: Team Badge Tiles - Context

**Gathered:** 2026-03-15
**Status:** Ready for planning

<domain>
## Phase Boundary

Align team badge tile layouts on the group matches page, bracket wizard, and topscorer page with the prototype's typography, flag sizes, and spacing. SVG flag files are kept (no emoji switch). The goal is layout/sizing alignment — not new interactivity.

</domain>

<decisions>
## Implementation Decisions

### SVG flag dimensions
Match the emoji font-size from the prototype as the flag height, with standard flag aspect ratio (~3:2) for width:
- Group match tiles: **22×16px** (prototype `.team-em` font-size: 16px)
- Bracket wizard tiles: **28×20px** (prototype `.tile-em` font-size: 20px)
- Topscorer player tiles: **24×18px** (prototype `.p-flag` font-size: 18px)

### Group match orientation
- Home side: **row-reverse** — flag appears to the right of the team abbreviation, facing the score center (matches prototype `.team-side.home { flex-direction: row-reverse }`)
- Away side: normal row — flag left, team abbreviation right
- Score separator: keep **`-`** (terminal style, consistent with scroll wheel lines)
- Team abbreviation font: **11px** (matches prototype `.team-abbr`)

### Bracket tile content
- Layout: flag on left, then a **column** with name on top + dim 3-letter code below
- `tile-name`: `T.display team` (3-letter code, e.g. `NED`) at **11px, Font.weight 500**
- `tile-code`: `String.toLower (T.display team)` (e.g. `ned`) at **9px, dim color**
- Padding: **10px vertical, 12px horizontal** (matches prototype `.team-tile { padding: 10px 12px }`)
- Selected state: orange border + tinted bg + `tile-name` in activeNav color — existing behavior kept
- Gap between flag and text column: **8px** (matches prototype `gap: 8px`)

### Topscorer player tiles
- Fully align to prototype `.player-item`:
  - Player name: **12px, Font.weight 500**
  - Team code: **10px, dim color**
  - Row gap: **10px** (between flag and text column)
  - Padding: **10px vertical, 12px horizontal**
- `[x]` check marker for selected player: **keep as-is** (already implemented)
- Flag size: 24×18px (see above)

### Claude's Discretion
- Exact `Font.weight 500` mapping in elm-ui (use `Font.medium` or `Font.weight 500` — whichever compiles)
- Spacing and centering tweaks within each tile variant to avoid overflow

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `T.flagUrl (Just team)` — generates SVG flag URL; already used in all three locations
- `T.display team` — 3-letter uppercase code (e.g. `NED`)
- `T.displayFull team` — full name (not needed here)
- `UI.Color.grey` / `Color.terminalBorder` — existing dim color for inactive text
- `Color.activeNav` / `Color.orange` — existing selected-state colors
- `UI.Font.mono` — monospace font attribute

### Established Patterns
- `Element.row [ spacing X ] [ flagImg, textEl ]` — current badge pattern; extend to column for bracket
- `Border.width 1`, `Border.color`, `Background.color` — existing tile border pattern in `Form/Bracket/View.elm` (lines 418–448)
- `paddingXY 6 0` current bracket padding → change to `paddingXY 12 10`

### Integration Points
- **Group matches**: `viewInput` in `Form/GroupMatches.elm` (~line 360) builds the match row — home/away team display via `flagImg` + `T.display` text
- **Bracket**: `viewTeamBadge` and `viewPlacedBadge` in `Form/Bracket/View.elm` (~lines 543, 609) — both need updated flag size, padding, and name+code column
- **Topscorer**: `viewPlayerCard` in `Form/Topscorer.elm` (~line 167) — `flagImg` dimensions + `textBlock` font sizes

</code_context>

<specifics>
## Specific Ideas

- Flag size guideline: "similar to the size of emoji flags in the prototype" — use prototype emoji font-size as the target height

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 32-team-badge-tiles*
*Context gathered: 2026-03-15*
