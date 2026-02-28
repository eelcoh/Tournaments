# Phase 2: Touch Targets and Score Input - Context

**Gathered:** 2026-02-24
**Status:** Ready for planning

<domain>
## Phase Boundary

Make every interactive element comfortably tappable on a phone (≥44×44px), ensure score entry raises the numeric keypad instead of the QWERTY keyboard, and make group match rows fully visible on a 320px-wide screen. No new features — purely mobile usability fixes.

</domain>

<decisions>
## Implementation Decisions

### Touch target expansion approach
- Use **invisible tap zones** throughout — add invisible padding/wrapper so the hit area reaches 44px without changing the visual appearance
- The terminal aesthetic (small text, ASCII style) must stay visually intact; only the tappable area grows
- This applies uniformly to: nav letters, score buttons, nav links, bracket badges, step indicators

### Touch target sizes
- **All interactive elements:** 44px minimum (both width and height)
- **Score buttons** (used intensively across 48 group matches): 44px minimum — consistent with everything else, not a special larger size
- **Bracket team badges:** 44px tap zones applied to ALL tappable badges — consistent rule, no exceptions for "probably large enough" elements

### Global nav link treatment
- Nav links stay **inline** (no full-width rows on mobile)
- Tap zone expanded to 44px height via invisible padding top/bottom
- Horizontal terminal nav layout is preserved

### Claude's Discretion
- Score input keyboard type (how to trigger numeric keypad on iOS/Android — `inputmode`, `type`, or elm-ui equivalent)
- Group match row layout at 320px (how to prevent horizontal overflow — truncation, layout change, or smaller elements)
- Group nav letters A–L at 320px (whether to wrap, scroll, or resize)
- Exact elm-ui implementation pattern for invisible tap zones (wrapping `el` with padding, or `Element.minimum`, etc.)

</decisions>

<specifics>
## Specific Ideas

No specific references or examples given — open to standard approaches as long as terminal aesthetic is not visually disrupted by the fixes.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 02-touch-targets-and-score-input*
*Context gathered: 2026-02-24*
