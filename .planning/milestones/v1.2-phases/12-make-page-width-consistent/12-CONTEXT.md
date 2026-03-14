# Phase 12: make page width consistent - Context

**Gathered:** 2026-03-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Ensure all page sections — top nav, content, footer — share the same width constraint so nothing overflows or misaligns at any screen size. The problem: the outer page column in View.elm has no max width cap, while inner content views are already capped (via UI.Screen.maxWidth / UI.Page.container). Bottom overlay bars (form nav, status bar, install banner) are excluded from this fix.

</domain>

<decisions>
## Implementation Decisions

### Max width value
- Replace the current `80% of screen width` formula in `UI.Screen.maxWidth` with a fixed constant of **600px**
- All callers of `maxWidth` / `Screen.width` / `UI.Page.container` automatically pick up the new value
- 600px applies on desktop only — on phone (< 500px screen) the cap has no visual effect anyway since phones are narrower

### What gets capped
- The **top-level page column** in `View.elm` must also be constrained to 600px and centered — currently it's `Element.centerX` with no `Element.maximum`, so nav and footer stretch full viewport width
- The **top navigation bar** (nav links row) is inside the page column — it inherits the 600px constraint automatically once the outer column is capped
- **Bottom overlay bars** (form nav bar, status bar, install banner) stay **full-width** — standard mobile pattern, their content is already centered internally

### Phone vs desktop padding
- Phone (< 500px): 8px horizontal padding each side — preserve current behavior
- Desktop: 24px horizontal padding applied **inside** the 600px column (column edges align with nav edges, padding is interior)

### Claude's Discretion
- Whether to update `UI.Screen.maxWidth` in-place (changing the 80% formula to return 600) or add a new constant `maxWidthPx = 600` and update callers
- Exact approach to making the outer page column constrained (could be `Element.maximum 600` on the column, or wrapping in a `UI.Page.container`-style element)

</decisions>

<specifics>
## Specific Ideas

- The goal is a single unified 600px column where nav, content, and footer all align — feels like a phone layout even on desktop, appropriate for this terminal-aesthetic mobile-first app

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `UI.Screen.maxWidth : Size -> Int` — currently returns `round (80 * screen.width / 100)`. Change this to return `600` (ignoring screen argument, or keeping it for Phone/Computer distinction)
- `UI.Screen.width : Size -> Element.Attribute msg` — wraps `Element.fill |> Element.maximum (maxWidth screen)`. Used by `viewHome`, `viewBlog`
- `UI.Page.container` — already uses `Element.maximum (UI.Screen.maxWidth screen)`. Will auto-update if `maxWidth` changes
- `Form/View.elm` line 271-273 — inline `Element.fill |> Element.maximum (Screen.maxWidth model.screen)`. Will auto-update

### Established Patterns
- `Phone` vs `Computer` from `Screen.device` drives padding decisions (8px vs 24px)
- `Element.centerX` is used on the outer page column — needs `Element.maximum` added to cap it

### Integration Points
- `View.elm` `page` column (lines 177-185): add `Element.width (Element.fill |> Element.maximum 600)` to the column attributes
- `UI.Screen.maxWidth`: change return value from `round (80 * screen.width / 100)` to `600`
- All downstream callers (`UI.Page.container`, `Screen.width`, `Form/View.elm`) inherit the fix automatically

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 12-make-page-width-consistent*
*Context gathered: 2026-03-07*
