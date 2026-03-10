# Phase 21: Participant & Submit - Context

**Gathered:** 2026-03-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Restyle the participant field rows and submit card to match the prototype visual language. No navigation logic, routing, or data model changes.

Scope:
1. **Participant card** — each field gets an uppercase label above a bordered row container holding `>` prompt + input inline
2. **Submit card** — add a bordered summary box (5 sections) above the submit button, restyle the submit button to full-width amber block

</domain>

<decisions>
## Implementation Decisions

### Field row layout
- Layout: uppercase label ABOVE the bordered container; `>` prompt + input are inline inside the container on one row
- Label style: 9px, dim grey (`Color.grey`), letter-spacing 0.14em — matches prototype `.field-lbl`
- Container border: 1px `Color.terminalBorder` (dim grey) by default
- Focus state: **full container border turns orange** (`Color.orange`) when the inner input is focused — same pattern as Phase 20 topscorer search bar (`SearchFocused` msg mechanism)
- Error state: container border turns red + `>` prompt becomes `!` in red — consistent with existing terminal aesthetic; no separate error message text below
- Placeholder text: each field gets a dimmed placeholder matching prototype (e.g. "jouw naam", "naam@voorbeeld.nl", "+31 6 ...", "adres", "woonplaats", "hoe ken je ons?")
- All 6 existing fields kept: Naam, Adres, Woonplaats, Email, Telefoonnummer, Hoe ken je ons — no fields removed

### Summary box (submit card)
- A bordered container (`bg-dark` bg, 1px `Color.terminalBorder` border) appears ABOVE the submit button on the submit card
- Shows 5 rows: Groepswedstrijden, Knock-out schema, Topscorer, Naam, E-mail
- Each row: label (left, dim) + value/count (right) + color coding: `Color.green` for complete, `Color.red` for incomplete
  - Groepswedstrijden: `36/36` count format (or current N filled)
  - Knock-out schema: `96/96` count format
  - Topscorer: player name if selected, `—` if not
  - Naam: name value if set, `—` if not
  - E-mail: email value if set, `—` if not
- Rows separated by 1px internal border (same terminalBorder color)
- Only Naam and E-mail appear in the summary (not Adres, Woonplaats, Tel, Hoe ken je ons)
- Summary box is visible on the submit card only — not a persistent widget

### Incomplete note
- A small dim grey note below the button when form is not yet complete: "Vul alle verplichte onderdelen in om te verzenden." (10px, `Color.grey`, centered)
- Disappears when all 5 summary sections are complete and the form is submittable

### Submit button
- Full-width `elm-ui` `Element.Input.button` — amber background (`Color.amber`), dark text (`Color.black`), fill width, 15px vertical padding, uppercase letter-spacing (0.14em)
- Active/submittable state: amber background, hover to brighter amber
- Disabled/incomplete state: grey background (`Color.terminalBorder`), dim text (`Color.grey`), `cursor: not-allowed`
- Post-submission success state: button turns green, label changes to `[ verzonden ]`; intro text thanks the user (existing `introSubmitted` copy)
- Implemented as elm-ui Element (not Html button)

### Claude's Discretion
- Exact mechanism for focus-within container border (whether to reuse SearchFocused pattern from Topscorer or introduce a FieldFocused state per field — likely same Bool state already on ParticipantCard)
- Exact amber color value for submit button (use existing `Color.amber` / `Color.activeNav` from palette)
- Whether `fieldLabel` and `fieldRow` become new helper functions in `UI.Style` or are defined inline in `Form.Participant`
- Exact letter-spacing attribute for button label (elm-ui `Font.letterSpacing` vs `htmlAttribute`)
- Exact placeholder strings for Adres, Woonplaats, Hoe ken je ons fields

</decisions>

<specifics>
## Specific Ideas

- The field container focus-within behavior (whole border turns orange) follows the exact same pattern as Phase 20's topscorer search bar — that already uses a `SearchFocused Bool` state on the card + `Html.Events.onFocus`/`onBlur` to drive container border color via parent state
- The summary box `sum-row` pattern from the prototype is clean: left label in dim, right value colored green/red. Row dividers are internal `border-bottom: 1px` on each row except the last
- Prototype's handleSubmit() changes button text to `[ verzonden ]` and turns it green — the existing Elm `introSubmitted` + `Success` state already handles this; just needs the visual treatment

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `Form.Participant.elm` — existing module with `inputField` helper; layout will change but update/isComplete logic is unchanged
- `Form.Participant.Types` — `State = { activeField : Maybe FieldTag }` already tracks focus per field; drives `>` / `!` / `-` prompt; same state field can drive container border color
- `UI.Style.terminalInput` — existing `Element.focused [Border.color Color.orange]` pattern; the new bordered container wraps around this and drives its own border via parent state
- `UI.Button.submit` — existing submit button with semantic states (Active/Inactive/Right); may be replaced entirely by new full-width amber button in `Form.Submit`
- `Form.Submit.elm` — currently has intro paragraphs + button; summary box and incomplete note get added here
- `Bets.Types.Participant.isComplete` — existing completeness check for participant data

### Established Patterns
- `SearchFocused Bool` + `Html.Events.onFocus/onBlur` → container border color via parent state — established in Phase 20 `Form.Topscorer`; replicate for participant field rows
- `Font.color Color.orange` / `Font.color Color.red` / `Font.color Color.grey` — prompt color pattern for active/error/inactive
- `Border.width 1` + `Border.color Color.terminalBorder` — terminal border pattern used throughout v1.4
- `Element.mouseOver [Border.color Color.orange]` — hover state pattern (Phase 19+)
- `Color.green`, `Color.red` — existing semantic colors for complete/incomplete states (used in group indicators, bracket minimap)

### Integration Points
- `src/Form/Participant.elm` `inputField` — restructure layout from `[prompt+label row] + [indented input]` to `[uppercase label] + [bordered container[prompt+input]]`
- `src/Form/Participant/Types.elm` `State` — `activeField : Maybe FieldTag` already available; drives border color on active field container
- `src/Form/Submit.elm` — add `viewSummaryBox : Model Msg -> Element Msg` using `Model` to compute completion counts, participant values; add incomplete note conditional
- `src/Types.elm` — `ParticipantCard { activeField : Maybe FieldTag }` already has state; no new state fields needed unless FieldFocused pattern needs expansion
- `UI.Color` — `Color.amber`/`Color.activeNav` for submit button background; `Color.green`/`Color.red` for summary row status colors

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 21-participant-submit*
*Context gathered: 2026-03-10*
