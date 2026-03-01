# Phase 9: Group Match Score Input Improvements - Context

**Gathered:** 2026-03-01
**Status:** Ready for planning

<domain>
## Phase Boundary

Improve the score input UX for the 48 group stage matches: add flag images to the score input row, make the keyboard the primary input method (with manual text entry as a hidden overlay), and prevent text selection on keyboard taps.

Navigation, scroll wheel behaviour, and group nav bar are out of scope for this phase.

</domain>

<decisions>
## Implementation Decisions

### Feature 1: Flags in score input line

- The active-match score input row (`viewInput`) should show flag images alongside team names
- Layout: `[flag] NED [input] - [input] SEN [flag]`
- Home side: flag on the left of the team name; away side: flag on the right of the team name
- Flag size: small (~24px) to fit comfortably in the row without making it too tall
- Use `Element.image` with `T.flagUrl (Just team)` — same pattern as `UI.Team.viewTeamSmallHorizontal`

### Feature 2: Keyboard-primary entry with "andere score" overlay

- **Default view**: show only the score keyboard (`viewKeyboard`), no text inputs visible
- **Below the keyboard**: a small text link labelled `andere score` (lowercase, terminal aesthetic)
- **On clicking "andere score"**: the text input fields appear as an overlay replacing the keyboard area (not a modal/popup over the whole screen — just within the card's input zone)
- **In the overlay**: show the existing text inputs (`viewInput` fields, minus the keyboard) plus a dismiss link labelled `← terug` (or similar) to go back to the keyboard
- **State**: add a `Bool` field (e.g. `manualInputVisible`) to `Form.GroupMatches.Types.State` to track which view is active; default `False`
- **New Msg variants**: `ShowManualInput` and `HideManualInput` (or a single `ToggleManualInput`)
- When a keyboard score button is tapped and `manualInputVisible` is `True`, close the overlay (reset to keyboard view) after setting the score — keeps the flow clean
- When the cursor advances to a new match (auto-advance via `Implicit`), reset `manualInputVisible` to `False`

### Enhancement 1: Prevent text selection on keyboard buttons

- Score keyboard buttons currently trigger browser text selection on tap instead of (or in addition to) the click handler — apply `user-select: none` CSS to fix this
- In elm-ui: `Element.htmlAttribute (Html.Attributes.style "user-select" "none")` on each score button element (or on the keyboard container column)
- Also add `-webkit-user-select: none` for Safari compatibility
- Apply in `UI.Button.Score.scoreButton_` or the keyboard container in `viewKeyboard`

### Claude's Discretion

- Exact pixel size of the flag images (something around 20–28px that fits the row height)
- Whether "andere score" link is styled with `Font.color Color.grey` or `Color.orange`
- Whether the overlay dismiss is "← terug" or "× sluiten" or similar terminal-style text
- Whether to combine `ShowManualInput`/`HideManualInput` into a single `ToggleManualInput`

</decisions>

<specifics>
## Specific Ideas

- User's exact wording: `flag team _-_ team flag` for the score input row layout
- User's exact wording for the link: `"andere score"` (Dutch, lowercase)
- The overlay replaces the keyboard in-place — not a full-screen modal

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets

- `UI.Team.viewTeamSmallHorizontal DLeft/DRight` — renders `[flag] [name]` or `[name] [flag]` in a 30px-high horizontal row. Too tall as-is but the pattern is reusable.
- `T.flagUrl (Just team)` — returns `"assets/svg/NNN-country.svg"` path; SVG flags are present in `assets/svg/`
- `UI.Style.scoreInput` — underline-only input style (orange border-bottom, dark bg); used by the existing text input fields
- `viewInput` in `Form/GroupMatches.elm` — existing score input row to be restructured (keep fields, remove from default view)
- `viewKeyboard` in `Form/GroupMatches.elm` — calls `UI.Button.Score.viewKeyboard NoOp (Update matchId)`; this becomes the default view

### Established Patterns

- `Element.htmlAttribute (Html.Attributes.style "..." "...")` — how CSS properties are injected in elm-ui
- State stored in `Form.GroupMatches.Types.State` (`{ cursor, touchStartY }`); add `manualInputVisible : Bool`
- `Msg` variants live in `Form.GroupMatches.Types`; `update` handles them in `Form/GroupMatches.elm`
- Terminal aesthetic: dark bg, monospace font, grey/orange colours — "andere score" link should match

### Integration Points

- `Form/GroupMatches.elm` → `view` function composes `viewInput` + `viewKeyboard`; restructure this composition
- `Form.GroupMatches.Types` → `State` and `Msg` need new fields/variants
- `UI.Button.Score` → `scoreButton_` or `viewKeyboard` needs `user-select: none` attributes

</code_context>

<deferred>
## Deferred Ideas

- None — discussion stayed within phase scope

</deferred>

---

*Phase: 09-group-match-score-input-improvements*
*Context gathered: 2026-03-01*
