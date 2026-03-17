# Phase 36: Wizard View Layer - Context

**Gathered:** 2026-03-17
**Status:** Ready for planning

<domain>
## Phase Boundary

Implement the per-round badge layouts and grid structures for the bracket wizard view layer. R32 shows 48 teams grouped by group letter with flag+code badges; R16 shows the R32 pool as a flat grid with flag+code badges; QF through Champion show flag+name+code badges from their respective pools. Selected badges show green outline in placed sections; teams already selected (or max-reached) in the active grid are dimmed with a grey veil over the flag image.

</domain>

<decisions>
## Implementation Decisions

### Badge content — R32 and R16
- Flag image + 3-letter country code (11px) only — no team name
- Fixed width: `Element.px 48` (locked in STATE.md)
- Fixed height: `Element.px 44` for strict vertical grid alignment
- No text name in these badge cells

### Badge content — QF through Champion
- Flag image + full team name (11px, clipped at badge boundary) + code below (9px)
- Fixed width: `Element.px 80` (locked in STATE.md); use `Element.paragraph` + `Element.clipX` for name
- Fixed height: `Element.px 44` for consistent grid alignment across all rounds
- Layout mirrors existing `viewSelectableTeam` pattern but with fixed 80px width

### R32 group header format
- Just the single letter (e.g. `"A"`) in amber, 12px, inline before the badge grid for that group
- No `--- A ---` separator style — compact label only
- All 12 groups (A–L) always visible in R32 grid; teams already selected in this round are dimmed in place (not hidden, not `---`)

### Active grid dispatch
- R32 active grid: group-organized (viewR32Grid) — shows all 48 teams with group letter headers
- R16 active grid: flat grid (viewFlatGrid) — shows the 32 teams from sel.lastThirtyTwo
- QF active grid: flat grid — shows the 16 teams from sel.lastSixteen
- SF active grid: flat grid — shows the 8 teams from sel.quarters
- Final active grid: flat grid — shows the 4 teams from sel.semis
- Champion active grid: flat grid — shows the 2 teams from sel.finalists

### Badge states in active grid (three states)
- **Selected in this round** (already picked): dimmed in-place + tappable to deselect + grey veil over flag
  - Grey veil = `Element.el [Element.inFront (Element.el [Background.color (Element.rgba 0 0 0 0.45), Element.width Element.fill, Element.height Element.fill] Element.none)]`
  - Grey text, grey border — NOT green outline (green outline is for placed section, not active grid)
- **Can select**: normal badge — grey border, normal text, tappable
- **Cannot select** (round max reached): dimmed + grey veil over flag + NOT tappable
  - Same visual as "selected" but no onClick handler

### Placed badges (non-active round sections)
- Show selected teams ABOVE the active round with a **green border** (`Border.color Color.green`, `Border.width 1`)
- R32/R16 placed badges: flag + code (48px width, 44px height)
- QF+ placed badges: flag + name + code (80px width, 44px height)
- These placed badges are tappable to deselect (same as selected-in-round in active grid)

### Grid columns
- R32 and R16: 4 columns on Phone, 8 columns on Computer (unchanged from current code)
- QF through Champion on Phone:
  - `screen.width >= 360`: 3 columns
  - `screen.width < 360`: 2 columns
- QF through Champion on Computer: 4 columns

### No `---` placeholders
- Remove all `"---"` and `Element.none` patterns for placed/selected teams
- Selected teams in the active R32 grid stay in their group position, just dimmed
- Do NOT hide groups where all members are placed — keep them visible (all dimmed)

### Claude's Discretion
- Exact veil opacity value (suggested 0.45 — adjust for readability)
- Whether to extract a shared `viewBadgeVeil` helper or inline the overlay
- Spacing values between badge rows (current `spacing 8` and `spacing 12` are reasonable baselines)
- `viewActiveGrid` dispatch function signature — can take `SelectionRound` and branch on it

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### View implementation
- `src/Form/Bracket/View.elm` — ALL current badge view functions to modify: `viewSelectableTeam`, `viewPlacedBadge`, `viewR32Grid`, `viewFlatGrid`, `viewGroup`, `viewActiveGrid`, `viewRoundSection`

### State model (provides pool data for each round)
- `src/Form/Bracket/Types.elm` — `canSelectTeam`, `roundTeams`, `roundRequired`, `RoundSelections` fields (`lastThirtyTwo`, `lastSixteen`, `quarters`, `semis`, `finalists`, `champion`)

### Styling references
- `src/UI/Color.elm` — `Color.green`, `Color.orange`, `Color.grey`, `Color.terminalBorder`, `Color.activeNav` (badge state colors)
- `src/UI/Screen.elm` — `Screen.device`, `Size` type; also check `state.screen.width` for 360px column threshold

### Requirements
- `.planning/REQUIREMENTS.md` §v1.7 — R32-01, R32-02, R16-01, R16-02, LATE-01, LATE-02, BADGE-01, BADGE-02

### Locked decisions from prior phases
- `.planning/STATE.md` §"Decisions for v1.7" — `Element.px 48` for R32/R16; `Element.px 80` + `paragraph` + `clipX` for QF–Champion (locked)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `viewSelectableTeam` — current flag+name+code badge; becomes QF+ badge with px 80 fixed width and three visual states (selected/can/cannot)
- `viewBracketMinimap` — no changes needed in this phase
- `viewRoundBadge`, `roundTitle`, `roundDescription` — unchanged
- `viewFlatGrid` — exists but currently unused; needs to be wired into `viewActiveGrid` for R16+
- `List.Extra.greedyGroupsOf` — already used for badge row grouping

### Established Patterns
- `Element.inFront` overlay — used in `view` for sticky button; same technique for grey flag veil
- `spacing 8` / `spacing 12` — existing badge grid spacing conventions
- `Element.width Element.shrink` — current badge width (replace with `Element.px 48` or `px 80`)
- `Border.rounded 2` — existing badge border-radius; keep as-is

### Integration Points
- `viewRoundSection` calls `viewActiveGrid` and `viewPlacedBadge` — both need updating
- `viewActiveGrid` currently always calls `viewR32Grid` for Phone — needs round-based dispatch
- `viewR32Grid` hides groups where all placed (`if allPlaced then Element.none`) — change to show dimmed
- `viewGroup` uses `---` for placed teams — remove, replace with dimmed in-place badges

</code_context>

<specifics>
## Specific Ideas

- Grey veil over flag: `Element.el [Element.inFront (Element.el [Background.color (Element.rgba 0 0 0 0.45), Element.width Element.fill, Element.height Element.fill] Element.none)]` wrapping the flag image
- R32 group label: `Element.el [Font.color Color.amber, Font.size 12, UI.Font.mono] (Element.text (Group.toString grp))`
- QF+ column logic: `let cols = if dev == Screen.Phone then (if state.screen.width < 360 then 2 else 3) else 4`
- `viewActiveGrid` dispatch: `case round of LastThirtyTwoRound -> viewR32Grid ...; _ -> viewFlatGrid ...`

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 36-wizard-view-layer*
*Context gathered: 2026-03-17*
