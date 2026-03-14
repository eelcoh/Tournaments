# Phase 18: Foundation - Context

**Gathered:** 2026-03-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Global visual foundation for v1.4: self-host Martian Mono and replace Sometype Mono everywhere, add a CRT scanline texture overlay over the full app, and build form navigation chrome (progress rail header + fixed bottom nav with prev/next buttons and step label).

Font swap, scanline overlay, and form chrome only. Individual card visual redesigns (score inputs, bracket tiles, etc.) are Phase 19+.

</domain>

<decisions>
## Implementation Decisions

### Font swap
- Replace "Sometype Mono" with "Martian Mono" in `UI/Font.elm` — the `mono` attribute is used everywhere, so one change propagates globally
- Self-hosted via `assets/fonts/fonts.css` (infrastructure already in place from previous phase)
- Weights needed: 300, 400, 500 (as per FONT-01 requirement)
- No network font requests — the existing Google Fonts link must be fully removed if any remnant exists

### Scanline overlay
- Inline `<style>` block inside `index.html` (no separate CSS file)
- Implemented as `body::before` pseudo-element: `position: fixed`, full viewport coverage, `pointer-events: none`, high `z-index` so it overlays the entire Elm-rendered app
- Spec: repeating horizontal lines at 4px intervals, ~3.5% opacity — use as-is, no adjustment
- Color: semi-transparent black lines over the dark background (standard CRT scanline)

### Progress rail (form header)
- Thin horizontal line, 2–4px tall — minimal, fits the terminal aesthetic
- Colored blocks only, no text labels on the rail itself
- One segment per form step: orange = active step, green = completed, dimmed (low-opacity grey) = pending
- Clickable: clicking a segment navigates to that step (same behavior as current `[x]/[.]/[ ]` row)
- Replaces the existing `viewTopCheckboxes` entirely — no coexistence with the old checkbox row
- Full width of the content area, segments fill proportionally with small gaps between

### Bottom nav
- Fixed to the bottom of the viewport (not scrolling with content)
- Three-zone layout: `< vorige` (left) | current step label + `[N]` count (center) | `volgende >` (right)
- Center: shows the current card's name (e.g. "groepen") with an amber `[N]` incomplete count when items remain; count disappears when the card is complete
- Prev/next at form boundaries: reduced opacity (0.3–0.4), `cursor: not-allowed`, not clickable — visually disabled, not hidden
- `viewCardChrome` already has `paddingEach { bottom = 64 }` reserving space — bottom nav slots into this

### Claude's Discretion
- Exact segment width calculation (equal segments vs proportional fill)
- Gap size between rail segments
- Exact opacity value for disabled nav buttons (anywhere in 0.3–0.4 range)
- Font size of the bottom nav center label
- Whether the `stap N/M` counter is removed or moved (user said center shows step label + [N] count — `stap N/M` may be retired)

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `UI.Font.mono` — the single attribute that sets "Sometype Mono" everywhere; rename the typeface string here to propagate Martian Mono globally
- `UI.Color` — existing color palette (orange, green, grey, terminalBorder) maps directly to rail segment states
- `viewCardChrome` in `Form/View.elm` — existing chrome wrapper; progress rail and bottom nav both attach here
- `Element.inFront` + `Element.alignBottom` — elm-ui pattern for fixed overlays (used in `viewStatusBar` previously); bottom nav uses this

### Established Patterns
- elm-ui only — no CSS files; scanline is the exception (pure CSS in HTML, not elm-ui)
- `Element.pointer` + `Element.mouseOver` — standard hover pattern for interactive elements
- `Element.htmlAttribute (Html.Attributes.style "cursor" "not-allowed")` — existing pattern for disabled cursor (used in `buttonInactive`)
- `Element.alpha` — elm-ui attribute for opacity; use for disabled nav button states

### Integration Points
- `src/index.html` — scanline CSS goes here as inline `<style>` in `<head>`
- `src/UI/Font.elm` — `mono` function: change `Font.typeface "Sometype Mono"` to `"Martian Mono"`
- `assets/fonts/fonts.css` — add Martian Mono `@font-face` declarations; add font files to `assets/fonts/`
- `src/Form/View.elm` `viewTopCheckboxes` — replace with `viewProgressRail`
- `src/Form/View.elm` `viewCardChrome` — add bottom nav via `Element.inFront` or as a child with fixed positioning

</code_context>

<specifics>
## Specific Ideas

- The bottom nav should use the `< vorige` / `volgende >` text style (terminal arrow prefix/suffix) consistent with the existing terminal aesthetic
- The progress rail is purely visual signaling — the section names (overzicht, groepen, schema, topscorer, inzenden) should still be accessible via the rail clicks even without visible labels

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 18-foundation*
*Context gathered: 2026-03-09*
