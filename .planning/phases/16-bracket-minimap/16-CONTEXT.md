# Phase 16: Bracket Minimap - Context

**Gathered:** 2026-03-08
**Status:** Ready for planning

<domain>
## Phase Boundary

Replace the existing `viewRoundStepper` with a new minimap — a horizontal dot rail showing all 6 bracket rounds (R32 → R16 → KF → HF → F → ★) with done/current/pending states and full tap-to-jump navigation to any round.

</domain>

<decisions>
## Implementation Decisions

### Dot appearance
- Prototype circle style: 9×9px elm-ui box with `Border.rounded 50` (fully rounded = circle)
- Done: filled green (`Color.green`), amber glow when current (`Color.orange` fill + glow shadow), dim border-only when pending
- Label below each dot showing round abbreviation (R32, R16, KF, HF, F, ★) in matching state color
- Dots connected by thin 1px horizontal line elements (~12px wide, `border-dim` color)
- Container: dark background (`bg-dark`) with a `border-dim` border, padding 10×14px — visually separates minimap from round content below

### Tap behavior
- ALL dots are tappable regardless of state (done/current/pending)
- Tapping any dot fires `JumpToRound r` — reuses existing msg that sets `viewingRound`
- No restriction on pending rounds; user can scout ahead (empty team grid shown)

### Replacing the existing stepper
- `viewRoundStepperFull` and `viewRoundStepperCompact` are REMOVED
- New single `viewBracketMinimap` function replaces both — no device branching needed
- No compact/sliding-window variant; always show all 6 dots

### Layout
- All 6 dots always shown, regardless of screen size (estimated width ~252px fits on 375px phone)
- Minimap positioned ABOVE the round badge (round title header)
- Centered in the bracket wizard column
- No horizontal scroll needed (dots are small enough), but elm-ui's natural overflow handling is acceptable as fallback

</decisions>

<specifics>
## Specific Ideas

- Follow `design-prototype.html` (at `prototypes/design-prototype.html`) for visual reference: `.bracket-minimap`, `.mm-node`, `.mm-dot`, `.mm-lbl`, `.mm-line` CSS classes show the exact target look
- In the prototype: `mm-done` = green fill, `mm-cur` = amber fill + `box-shadow: 0 0 6px rgba(240,160,48,0.5)` glow, default = transparent with dim border
- Label is first word of round title (already matches: R32, R16, KF, HF, F — champion uses ★ symbol)

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `JumpToRound : SelectionRound -> Msg` — already implemented and handled in `Form/Bracket.elm`; sets `viewingRound = Just round`
- `roundTeams : SelectionRound -> RoundSelections -> List Team` and `roundRequired : SelectionRound -> Int` — already available in `Form/Bracket/Types.elm` for computing done/current/pending state
- `currentActiveRound : RoundSelections -> SelectionRound` — already computes which round to show
- `Color.green`, `Color.orange`, `Color.grey` — existing color values in `UI.Style`

### Established Patterns
- elm-ui box sizing: `Element.width (px 9)`, `Element.height (px 9)`, `Border.rounded 5` for circular element
- `Element.Events.onClick` + `Element.pointer` for tappable elements
- `List.intersperse connector (List.map viewDot allRounds)` — existing pattern in `viewRoundStepperFull` for intercalating connectors

### Integration Points
- `viewRoundStepper` call site in `Form/Bracket/View.elm` (`view` function, line ~52) — replace with `viewBracketMinimap`
- The minimap renders above `viewRoundSection` calls — position in the `view` function is already correct

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 16-bracket-minimap*
*Context gathered: 2026-03-08*
