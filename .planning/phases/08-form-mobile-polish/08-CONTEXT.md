# Phase 8: Form Mobile Polish - Context

**Gathered:** 2026-03-01
**Status:** Ready for planning

<domain>
## Phase Boundary

Make the bet form smooth and clear to fill in on a phone: navigation reliability (vorige/volgende), incomplete state visibility (users know what's still missing), and action acknowledgment (no silent no-ops or jarring jumps). No new form capabilities or card content changes — this is a polish pass on the existing card-based form.

</domain>

<decisions>
## Implementation Decisions

### Navigation button layout
- Fixed bottom bar, always visible, pinned to viewport bottom
- Layout: left/right split with center info area — `< vorige  [stap 2/6]  volgende >`
- Bar height: 48px (consistent with Phase 2 touch target work)
- When the install banner (Phase 7) is visible, the nav bar sits above it — banner does not obscure navigation

### Incomplete state signals
- Incomplete count shown in the nav bar center alongside step info, e.g. `[stap 2/6 · 12 open]`
- Navigation always works — vorige/volgende are never blocked by incompleteness
- Top checkboxes (`viewTopCheckboxes`) are kept and complement the nav count: top row gives bird's-eye view across cards, nav center gives detail for the current card
- Count wording is card-specific:
  - GroupMatchesCard → "12 wedstrijden open"
  - BracketCard → "3 ronden open"
  - TopscorerCard → appropriate label
  - Other cards → Claude decides contextual wording
- When a card is complete, the count is hidden or replaced by a completion signal (Claude's discretion)

### Action feedback
- Navigation buttons (vorige/volgende): brief orange text highlight on tap — confirms tap registered, consistent with existing orange accent
- Submit button (SubmitCard): disables and changes text to "verzenden..." while submission is in-flight; re-enables on success or error. Prevents double-submit.
- Score inputs: make it visually clear when a score digit registers — the filled score (or cursor advancement) should acknowledge the input. Exact approach is Claude's discretion within the terminal aesthetic.

### Card transitions
- Instant swap — no animation
- Always scroll to top on card change, regardless of current scroll position
- No directionality signaled — vorige and volgende feel the same (only the content differs)
- At the first card: `vorige` is shown greyed out (disabled, not hidden)
- At the last card: `volgende` is shown greyed out (disabled, not hidden)
- Consistent layout at all positions — no layout shifts from hidden/shown buttons

### Claude's Discretion
- Exact completion signal when count reaches zero (e.g. checkmark, blank, "✓ klaar")
- Wording for card-specific incomplete counts on cards not listed above
- Score input acknowledgment implementation details
- Visual style of the greyed-out disabled button state

</decisions>

<specifics>
## Specific Ideas

- The nav bar center shows both step position and incomplete count together: `stap 2/6 · 12 open`
- The 48px height matches Phase 2 touch target conventions already in the codebase
- Install banner awareness: nav bar is a higher-priority fixed element than the install banner

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 08-form-mobile-polish*
*Context gathered: 2026-03-01*
