# Phase 3: Bracket Wizard Mobile Layout - Research

**Researched:** 2026-02-25
**Domain:** Elm 0.19.1 / elm-ui 1.1.8 — bracket wizard responsive layout for 375px phones
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Stepper compact format:**
- Use a 3-step context window: `[x] Prev — > Current — [ ] Next` (only adjacent steps shown)
- Ellipsis hidden at boundaries: at step 1 show `> Winnaar — [ ] Finalist`; at step 6 show `[x] R16 — > R32`
- Steps in the stepper are tappable, but **only if completed** (filled by user) — prevents skipping ahead
- Active step marked with `>` prefix; completed steps marked with `[x]` prefix; pending steps with `[ ]`

**Team grid density:**
- Badge content: 3-letter code **plus a small flag** (e.g., flag emoji + NED)
- Column count: **always 4 columns on Phone** regardless of how many teams are in the round
- R32 grid: group label separators between groups (`-- A --` then 4 teams, `-- B --` then 4 teams, etc.)
- Grid shows **only plausible teams** for each round — only teams the user has advanced to that stage

**Current step emphasis:**
- Active step marked with `>` prefix in the 3-step stepper
- Completed steps marked with `[x]` in the stepper
- Round name appears as a **standalone header above the team grid**: `-- Kwartfinale --`
- When returning to a previously completed step, already-selected teams are **highlighted** so the user can see and change their pick

**Placed team visibility:**
- Placed teams **stay in the selection grid** — they do not disappear
- Visual treatment for placed teams: `[x] NED` in orange color (consistent with terminal style)
- Tapping a placed team **un-picks it** (removes from its slot, returns to available)
- Teams eliminated in earlier rounds are **hidden** from later round grids — only plausible teams shown

### Claude's Discretion
- Exact flag representation (emoji, icon, or asset) and its size within a 4-column cell
- Exact pixel spacing and font sizes within grid cells
- Whether step navigation animates or cuts immediately

### Deferred Ideas (OUT OF SCOPE)
- None — discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| BRK-01 | Bracket step indicator (ASCII pipeline stepper) does not overflow horizontally at 375px — use compact format (3-step window) on `Phone` device type | `Screen.device` already in `State.screen`; view doesn't use it yet; 3-item stepper = 192px vs 432px full-width; fits in 359px available |
| BRK-02 | Team selection grid in `Form/Bracket/View.elm` uses ≤4 columns on `Phone` device type so teams are large enough to tap | `List.Extra.greedyGroupsOf 4` replaces current 8-per-row badges section; active grid redesigned to 4-column layout with group separators for R32 |
| BRK-03 | Round header text and instructions in the bracket wizard are readable (≥14px effective) on 375px-wide screens | `UI.Text.displayHeader` uses `Style.header2` which sets `Font.size (scaled 2)` = 25px; already satisfies ≥14px; verify no override is needed |
</phase_requirements>

---

## Summary

Phase 3 is entirely within `Form/Bracket/View.elm` and `Form/Bracket/Types.elm`. No new Elm packages are needed. The `Screen.Size` value is already threaded into `State` (and kept in sync via `updateScreenCard` in `Form.Card`), but the current `view` function ignores `state.screen` completely. The fix is to pass `state.screen` down into `viewRoundStepper` and `viewRoundSection` so they can branch on `Screen.device`.

The stepper overflow is the most critical issue. The full 6-step stepper is 432px wide (6 step columns at 32px + 5 connectors at ~48px each), which overflows a 375px phone screen. A 3-step context window collapses this to 192px, well within the 359px of available space after 8px page padding on each side. The window logic: show the completed step immediately before the active round, the active round itself, and the next incomplete step. Boundary cases: at step 1 (R32 is active) show only active + next; at step 6 (Champion) show only prev + active.

The team grid needs two separate changes: (a) the "placed badges" summary rows (non-active rounds) currently use `greedyGroupsOf 8`; on Phone this should be `greedyGroupsOf 4`; (b) the active round selection grid needs a complete redesign from "one row per group with label" to a 4-column layout with `-- A --` separators for R32 and a flat 4-column grid for higher rounds. Additionally, the CONTEXT decisions change the treatment of placed teams inside the grid: currently placed teams show grey `---`; instead they must show orange `[x] NED` and remain tappable (deselect on tap). Teams from groups not yet represented in prior rounds should be hidden from higher-round grids.

BRK-03 (round header readability) is trivially satisfied: `UI.Text.displayHeader` already uses `Font.size (scaled 2)` = 25px. No code change is required for that requirement — it is already met.

**Primary recommendation:** Pass `state.screen` into `viewRoundStepper` and `viewRoundSection`; gate compact stepper and 4-column grid behind `Screen.device screen == Phone`; implement 3-step window logic and `greedyGroupsOf 4` layout; rework placed-team rendering in the active selection grid.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mdgriffith/elm-ui | 1.1.8 | Layout and all styling — no CSS files | Already in use; all changes are attribute/layout changes |
| elm-community/list-extra | (in elm.json) | `List.Extra.greedyGroupsOf N` for grid chunking | Already imported in `Form/Bracket/View.elm` |
| UI.Screen | project module | `Screen.device : Size -> Device` returns `Phone` or `Computer` | Already in `State.screen`; just not used in view yet |

### No New Dependencies
This phase requires no new Elm packages. All needed APIs exist in the current dependency set.

### Existing API Reference (verified by source inspection)

**Screen device detection** (HIGH confidence — read from `src/UI/Screen.elm`):
```elm
-- UI.Screen
type Device = Phone | Computer
device : Size -> Device
device screen =
    if screen.width < 500 then Phone else Computer
```

**State already has screen** (HIGH confidence — read from `src/Form/Bracket/Types.elm`):
```elm
type alias State =
    { screen : Screen.Size
    , bracketState : BracketState
    }
```

**Screen kept in sync** (HIGH confidence — read from `src/Form/Card.elm`):
```elm
updateScreenCard : Screen.Size -> Card -> Card
updateScreenCard sz card =
    case card of
        BracketCard { bracketState } ->
            BracketCard <| Bracket.State sz bracketState
        _ ->
            card
```

**greedyGroupsOf already imported** (HIGH confidence — line 10 and 185 of `View.elm`):
```elm
import List.Extra
List.Extra.greedyGroupsOf 8 items  -- current; change to 4 on Phone
```

**Flag SVG assets available** (HIGH confidence — verified `assets/svg/` directory):
```elm
-- T.flagUrl (Just team) returns e.g. "assets/svg/237-netherlands.svg"
-- T.display team returns e.g. "NED"
```

---

## Architecture Patterns

### Current Flow (view does NOT use state.screen)

```
Form/Card.elm: updateScreenCard → State { screen = sz, bracketState = ... }
Form/Bracket/View.elm: view _ state → ignores state.screen completely
```

### Target Flow

```
Form/Bracket/View.elm: view _ state →
    let device = Screen.device state.screen
    viewRoundStepper activeRound sel device
    viewRoundSection activeRound sel allGroups teamData_ round device
```

### Pattern 1: 3-Step Compact Stepper (BRK-01)

**What:** Derive a 3-item sliding window from `allRounds` based on `activeRound`. Show only `[prevCompleted, active, nextIncomplete]`.

**When to use:** `Screen.device screen == Phone` — all bracket views on Phone.

**Window derivation logic:**
```elm
-- All rounds in display order (left = lowest round, right = champion)
allRounds = [ LastThirtyTwoRound, LastSixteenRound, QuarterRound
            , SemiRound, FinalistRound, ChampionRound ]

-- Current full stepper already renders with this list
-- For compact: find activeRound index, take window of up to 3

compactWindow : SelectionRound -> List SelectionRound -> List SelectionRound
compactWindow active rounds =
    let
        idx = List.Extra.findIndex (\r -> r == active) rounds
              |> Maybe.withDefault 0
        start = Basics.max 0 (idx - 1)
    in
    List.Extra.slice start (start + 3) rounds
    -- At boundary (idx=0): slice 0..2 = [active, next, next+1]? No --
    -- User wants EXACTLY: prev, active, next
    -- So: at idx=0, show [active, next]; at idx=5, show [prev, active]
    -- Otherwise show [rounds[idx-1], rounds[idx], rounds[idx+1]]
```

**Boundary rules (from CONTEXT.md):**
- Step 1 active (R32): show `> R32 — [ ] R16` (2 items)
- Step 6 active (Champion): show `[x] F — > Winnaar` (2 items)
- All others: 3 items

**Clickable completed steps:**
```elm
-- Steps are tappable only if isComplete (prevents skipping forward)
-- Add SelectRound msg to Msg type if needed, or use the existing
-- currentActiveRound logic to navigate back

-- New Msg variant needed:
type Msg
    = SelectTeam SelectionRound Team
    | DeselectTeam Team
    | GoNext
    | JumpToRound SelectionRound  -- NEW: navigate stepper (completed steps only)
```

**Note on JumpToRound:** `currentActiveRound` always returns the FIRST incomplete round. If the user wants to revisit a completed step, the view needs to allow overriding the active display round separately from the "first incomplete" round. This requires a new field in `WizardState`:

```elm
type alias WizardState =
    { selections : RoundSelections
    , viewingRound : Maybe SelectionRound  -- NEW: Nothing = follow currentActiveRound
    }
```

When `viewingRound = Just r`, the view shows round `r` as active. When user completes/deselects in that round, viewingRound stays unless the user taps another step. `JumpToRound r` sets `viewingRound = Just r`. Any `SelectTeam`/`DeselectTeam` that fills the viewed round clears `viewingRound` (falls back to currentActiveRound).

### Pattern 2: 4-Column Team Grid (BRK-02)

**What:** Redesign the active round team selection grid from "one row per group" to a 4-column grid with separators.

**For R32 (LastThirtyTwoRound) — group-labeled layout:**
```elm
viewR32Grid : RoundSelections -> List Group -> TeamData -> Element Msg
viewR32Grid sel allGroups teamData_ =
    let
        viewGroupSection grp =
            let
                members = Bets.Init.groupMembers grp
                separator = Element.el [Font.color Color.grey, UI.Font.mono]
                                (Element.text ("-- " ++ Group.toString grp ++ " --"))
                teamCells = List.map (viewSelectableTeam LastThirtyTwoRound sel teamData_) members
                rows = List.Extra.greedyGroupsOf 4 teamCells
                       |> List.map (Element.row [spacing 8])
            in
            Element.column [spacing 4] (separator :: rows)
    in
    Element.column [spacing 12] (List.map viewGroupSection allGroups)
```

**For R16 and above — flat 4-column grid of plausible teams:**
```elm
viewFlatGrid : SelectionRound -> RoundSelections -> TeamData -> Element Msg
viewFlatGrid round sel teamData_ =
    let
        plausible = plausibleTeams round sel
        cells = List.map (viewSelectableTeam round sel teamData_) plausible
        rows = List.Extra.greedyGroupsOf 4 cells
               |> List.map (Element.row [spacing 8])
    in
    Element.column [spacing 8] rows

plausibleTeams : SelectionRound -> RoundSelections -> List Team
plausibleTeams round sel =
    case round of
        LastThirtyTwoRound -> []  -- handled by R32 group layout above
        LastSixteenRound   -> sel.lastThirtyTwo
        QuarterRound       -> sel.lastSixteen
        SemiRound          -> sel.quarters
        FinalistRound      -> sel.semis
        ChampionRound      -> sel.finalists
```

**viewSelectableTeam — placed teams stay visible:**
```elm
viewSelectableTeam : SelectionRound -> RoundSelections -> TeamData -> Team -> Element Msg
viewSelectableTeam round sel teamData_ team =
    let
        isPlaced = List.any (\t -> t.teamID == team.teamID) (roundTeams round sel)
        canSelect = canSelectTeam round team sel teamData_
    in
    if isPlaced then
        -- Orange [x] NED, tappable to deselect
        Element.el
            [ Element.Events.onClick (DeselectTeam team)
            , Element.pointer
            , Element.width (Element.px 44)
            , Element.height (Element.px 44)
            , Element.centerY
            ]
            (Element.el [Font.color Color.orange, UI.Font.mono, Element.centerX, Element.centerY]
                (Element.text ("[x] " ++ T.display team)))
    else if canSelect then
        -- Primary text, tappable to select
        viewTeamBadge round sel teamData_ team  -- existing selectable badge
    else
        -- Grey, not tappable (capacity full but team wasn't placed)
        Element.el
            [ Element.width (Element.px 44)
            , Element.height (Element.px 44)
            ]
            (Element.el [Font.color Color.grey, UI.Font.mono, Element.centerX, Element.centerY]
                (Element.text (T.display team)))
```

### Pattern 3: Flag Representation (Claude's Discretion)

**Recommendation:** Use SVG flag image via `Element.image` (existing `T.flagUrl`), sized 16x16px, inline before the 3-letter code. This matches the existing `UI.Team.viewTeamVerySmall` pattern but within a 44px cell.

**Rationale:** Emoji flags are unreliable across Android WebViews (many show as letter pairs "NL" instead of the flag). The project already has `assets/svg/` with full flag library. A 16x16px image + 3-char text fits in a 44px wide cell comfortably.

```elm
-- Within the 44px grid cell:
Element.row [spacing 4, Element.centerX, Element.centerY]
    [ Element.image [Element.height (Element.px 16), Element.width (Element.px 16)]
        { src = T.flagUrl (Just team), description = T.display team }
    , Element.el [UI.Font.mono, Font.color cellColor]
        (Element.text (T.display team))
    ]
```

**Note:** Total cell content width: 16px flag + 4px spacing + 3-char text (~3 * 9.6px mono = 29px) = ~49px. But the cell is `px 44`. Either shrink flag to 12px, or use `Element.shrink` on the row. Safer approach: use `fill` width on the row, `Element.centerX` — elm-ui will not overflow if content is smaller. If 44px is too tight, cells can be `px 54` or use `Element.shrink` instead of `px 44`.

**Alternative (simpler):** Skip flag, keep `[x] NED` style for placed teams and just `NED` for unselected — consistent with existing terminal aesthetic. Only add flag if discretion leads to it looking better.

### Pattern 4: Badges Section — Responsive Column Count (BRK-02)

The "badges" section (summary of placed teams shown for ALL rounds, not just active) uses `greedyGroupsOf 8`. On Phone this must be 4:

```elm
columns =
    case Screen.device screen of
        Screen.Phone -> 4
        Screen.Computer -> 8

rows =
    List.Extra.greedyGroupsOf columns items
        |> List.map (\chunk -> Element.row [ spacing 8 ] chunk)
```

### Pattern 5: Desktop Passthrough (No Change on Computer)

All existing behavior is preserved on `Computer`. The `case Screen.device screen of` branch simply falls through to the existing code:

```elm
viewRoundStepper activeRound sel screen =
    case Screen.device screen of
        Screen.Phone ->
            viewRoundStepperCompact activeRound sel
        Screen.Computer ->
            viewRoundStepperFull activeRound sel  -- existing logic unchanged
```

### Anti-Patterns to Avoid

- **Using `Element.wrappedRow` for the team grid:** `wrappedRow` doesn't enforce column count — 4 teams of different widths may wrap unpredictably. Use `greedyGroupsOf 4` + `List.map (row [spacing 8]) rows` for exact 4-column control.
- **Ignoring `viewingRound` in `currentActiveRound`:** The "return to a completed step" feature requires `viewingRound` state. Do not conflate "which step is shown" with "which step is first incomplete" — they are distinct concepts after Phase 3.
- **Putting `viewingRound` in `BracketState`:** It should live in `WizardState` (inside `BracketWizard`), not as a separate `BracketState` variant.
- **Emoji flags:** Unicode flag emoji rendering is inconsistent in Android WebViews. Use SVG assets from `assets/svg/` via `T.flagUrl`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| 4-column grid layout | Custom CSS grid or float logic | `List.Extra.greedyGroupsOf 4` + `Element.row` | elm-ui has no CSS grid; chunking + rows is idiomatic and already used in this file |
| Responsive breakpoint | New screen size module or port | `Screen.device state.screen` (existing) | Breakpoint already defined: < 500px = Phone |
| Flag rendering | New flag component or CSS background | `Element.image` with `T.flagUrl` | Pattern already exists in `UI.Team`; assets already on disk |
| Scroll-to-round | JavaScript scroll port | Remove all sections except active round from DOM | Elm's single-pass rendering; the wizard already only shows the active grid section |

**Key insight:** The entire phase is additive attribute/layout changes inside one file (`Form/Bracket/View.elm`) and a small state extension in `Form/Bracket/Types.elm` (`viewingRound : Maybe SelectionRound`). No new modules, no new ports, no new packages.

---

## Common Pitfalls

### Pitfall 1: Stepper Width Calculation
**What goes wrong:** Developer assumes mono text characters have browser-default width and underestimates connector element width.
**Why it happens:** The connector `" --- "` is 5 characters at 16px monospace (~48px). The full stepper has 5 connectors = 240px just for connectors, plus 6 step columns at 32px each = 192px. Total = 432px — 73px overflow on a 375px phone.
**How to avoid:** Calculate: `steps * stepWidth + (steps - 1) * connectorWidth` before coding. For 3-step window: `3*32 + 2*48 = 192px` — safe.
**Warning signs:** Horizontal scrollbar appears in browser DevTools at 375px.

### Pitfall 2: Ignoring viewingRound State
**What goes wrong:** Stepper taps do nothing or snap back to the first incomplete round immediately.
**Why it happens:** `currentActiveRound` always returns the first incomplete round regardless of user intent. Without `viewingRound`, there is no way to "stay" on a completed step the user tapped.
**How to avoid:** Add `viewingRound : Maybe SelectionRound` to `WizardState`. The rendered active round is `Maybe.withDefault (currentActiveRound sel) wizardState.viewingRound`.
**Warning signs:** Tapping a completed step label in the stepper has no visible effect, or immediately bounces back to the incomplete step.

### Pitfall 3: Breaking Existing updateScreenCard Pattern
**What goes wrong:** Adding `viewingRound` to `WizardState` breaks `Form.Card.updateScreenCard` because it pattern-matches on `BracketCard { bracketState }`.
**Why it happens:** The destructuring pattern only names `bracketState`; adding a field to `WizardState` (nested inside `BracketState`) doesn't break this. But if `State` type changes, `Bracket.State sz bracketState` construction must match the updated type.
**How to avoid:** `State` has `{ screen, bracketState }` — adding `viewingRound` to `WizardState` (inside `BracketState`) does NOT change `State`'s record fields. No change to `updateScreenCard` needed.
**Warning signs:** Compiler error on `BracketCard <| Bracket.State sz bracketState`.

### Pitfall 4: canSelectTeam Logic with plausibleTeams
**What goes wrong:** A team appears in the grid for a round but `canSelectTeam` returns False (greyed out) when it should be hidden.
**Why it happens:** `plausibleTeams` returns teams from the previous round's selections, but `canSelectTeam` additionally checks capacity. When the round is full, all remaining unplaced teams show as grey/disabled instead of hidden.
**How to avoid:** Hide teams where `not isPlaced && not canSelect` only when the round is already full. Better: once capacity is reached, hide non-placed teams entirely. The "placed teams stay visible" rule still applies.
**Warning signs:** Grey disabled team cells accumulate in the grid after filling the round.

### Pitfall 5: Cell Width for Flag + Code
**What goes wrong:** The 44px cell is too narrow to show a 16px flag + 3-char code, causing overflow or truncation.
**Why it happens:** 16px image + 4px gap + ~29px text = 49px total in a 44px cell.
**How to avoid:** Use `Element.shrink` on the cell container or bump cell to `px 54`. Alternatively, drop the flag on very small rounds (Champion/Finalist have just 1-2 teams; space is not the issue there). Or use 12px flag (saves 4px: 12+4+29=45px, still tight).
**Warning signs:** Text gets clipped or overflows beyond the cell boundary.

---

## Code Examples

Verified patterns from codebase inspection:

### Conditional Layout by Device
```elm
-- Source: src/View.elm lines 72-77 (Phase 2 pattern)
contentPadding =
    case Screen.device model.screen of
        Screen.Phone ->
            Element.padding 8
        Screen.Computer ->
            Element.padding 24
```

### greedyGroupsOf for Grid Rows
```elm
-- Source: src/Form/Bracket/View.elm line 185-192 (existing pattern)
let
    rows =
        List.Extra.greedyGroupsOf 8 items
            |> List.map (\chunk -> Element.row [ spacing 8 ] chunk)
in
Element.column [ spacing 4 ] rows
-- Change 8 → 4 on Phone
```

### Passing Screen to Sub-Views
```elm
-- Source: src/Form/Bracket/Types.elm State definition
-- State already has { screen : Screen.Size, bracketState : BracketState }
-- Pattern: extract device at the top of `view`, pass into helpers

view : Bet -> State -> Element Msg
view _ state =
    let
        (BracketWizard wizardState) = state.bracketState
        dev = Screen.device state.screen
        -- pass `dev` into viewRoundStepper, viewRoundSection
    in
    ...
```

### Flag Image in elm-ui
```elm
-- Source: src/UI/Team.elm lines 133-158 (existing viewTeamVerySmall pattern)
Element.image
    [ Element.height (Element.px 16)
    , Element.width (Element.px 16)
    ]
    { src = T.flagUrl (Just team)
    , description = T.display team
    }
```

### Deselect on Tap (Already Exists)
```elm
-- Source: src/Form/Bracket/View.elm lines 318-334 (viewPlacedBadge)
-- Currently used in badges section only; reuse in active grid
Element.el
    [ Element.Events.onClick (DeselectTeam team)
    , Element.pointer
    , Element.width (Element.px 44)
    , Element.height (Element.px 44)
    ]
    (Element.el
        [ Font.color Color.green  -- change to Color.orange per CONTEXT
        , UI.Font.mono
        , Element.centerY
        , Element.centerX
        ]
        (Element.text (T.display team)))
```

---

## Width Analysis

| Layout | Calculation | Total | 375px Available (8px padding each side = 359px) |
|--------|-------------|-------|------------------------------------------------|
| Full 6-step stepper | 6×32px + 5×48px | 432px | OVERFLOW by 73px |
| Compact 3-step stepper | 3×32px + 2×48px | 192px | Fits (167px margin) |
| 4-column team grid | 4×44px + 3×8px spacing | 200px | Fits (159px margin) |
| Group label `-- A --` | ~9 chars × 9.6px = 86px | 86px | Fits |
| Round header (displayHeader) | fills to Element.fill | fill | Always fits |

---

## File Change Map

| File | Change | Requirement |
|------|--------|-------------|
| `src/Form/Bracket/Types.elm` | Add `viewingRound : Maybe SelectionRound` to `WizardState`; add `JumpToRound SelectionRound` to `Msg` | BRK-01 (stepper taps) |
| `src/Form/Bracket/View.elm` | Pass `state.screen`/device into helpers; implement compact stepper; 4-col grid; placed teams in grid | BRK-01, BRK-02 |
| `src/Form/Bracket.elm` | Handle `JumpToRound` in `update`; set `viewingRound` | BRK-01 |

No changes needed to: `Form/Card.elm`, `UI/Screen.elm`, `View.elm`, `Types.elm`.

---

## State of the Art

| Old Approach | Current Approach | Impact for Phase 3 |
|--------------|------------------|-------------------|
| Bracket with sub-cards (Issue #81 removed) | Single BracketCard + wizard state | Phase 3 only touches View.elm |
| BracketKnockoutsCard existed | Removed in Issue #81 | No BracketKnockoutsCard patterns to worry about |
| isComplete used Bracket.isComplete | Fixed in Issue #93 to use isCompleteQualifiers | Phase 3 does NOT change completeness logic |

---

## Open Questions

1. **Flag vs. text-only in badge cells**
   - What we know: 44px cell can fit a 12-16px flag + 3-char code (tight but feasible); emoji flags are unreliable on Android
   - What's unclear: Whether the user experience benefit of a flag outweighs the implementation complexity of sizing it correctly
   - Recommendation: Default to text-only `NED` (consistent with existing terminal UX); add flag only if CONTEXT.md discretion items are exercised. The `[x] NED` format for placed teams is clean and consistent.

2. **viewingRound initial value for "returning to completed step"**
   - What we know: `init` sets `BracketWizard { selections = emptyRoundSelections }`
   - What's unclear: Should `viewingRound` default to `Nothing` (follow currentActiveRound) or `Just LastThirtyTwoRound`
   - Recommendation: `Nothing` — `currentActiveRound emptyRoundSelections` correctly returns `LastThirtyTwoRound` as starting point.

3. **Non-active round sections (summary badges)**
   - What we know: Currently all rounds render header + placed badges + active grid; only active round shows grid
   - What's unclear: With "placed teams stay in selection grid", do the above-grid badges sections serve any purpose?
   - Recommendation: Keep summary badges for non-active rounds (shows progress overview); remove the "---" placeholder from the active grid and replace with the new placed-team-in-grid rendering.

---

## Sources

### Primary (HIGH confidence)
- Direct source inspection of `/src/Form/Bracket/View.elm` — full view logic, stepper implementation
- Direct source inspection of `/src/Form/Bracket/Types.elm` — State, WizardState, SelectionRound, Msg types
- Direct source inspection of `/src/Form/Bracket.elm` — update function, rebuildBracket
- Direct source inspection of `/src/Form/Card.elm` — updateScreenCard pattern
- Direct source inspection of `/src/UI/Screen.elm` — Device type, device function, breakpoint at 500px
- Direct source inspection of `/src/View.elm` — existing Screen.device usage pattern (Phase 2)
- Direct source inspection of `/src/UI/Team.elm` — flag image rendering pattern
- Direct source inspection of `/src/UI/Font.elm` — scaled function: `round(16 * 1.25^n)`
- Direct source inspection of `/src/UI/Text.elm` — displayHeader uses header2 = scaled(2) = 25px
- Arithmetic verification of stepper widths and grid dimensions

### Secondary (MEDIUM confidence)
- `.planning/phases/02-RESEARCH.md` — established Screen.device pattern, invisible tap zone pattern, Phase 2 established 8px Phone padding
- `.planning/phases/03-CONTEXT.md` — user decisions that lock implementation choices

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all libraries verified by source inspection, no new dependencies
- Architecture: HIGH — all types and functions verified by reading source code, width math verified
- Pitfalls: HIGH — stepper overflow is arithmetic fact; other pitfalls derived from code structure analysis

**Research date:** 2026-02-25
**Valid until:** 2026-03-25 (stable; Elm ecosystem does not change rapidly)
