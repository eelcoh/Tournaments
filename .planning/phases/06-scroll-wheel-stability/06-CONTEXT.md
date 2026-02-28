# Phase 6: Scroll Wheel Stability - Context

**Gathered:** 2026-02-28
**Status:** Ready for planning

<domain>
## Phase Boundary

Fix the group matches scroll wheel so it displays reliably: active match pinned at line 4 of a 7-line window, group label always visible in lines 1–3, `-- END --` never scrolls above line 4, and no height jumps at any scroll position. This phase only changes rendering/windowing logic — no new features, no new interactions.

</domain>

<decisions>
## Implementation Decisions

### Lines 1–3 content (label anchoring)
- Line 1 always shows the group label for the active match's group (e.g. `-- A --`)
- Lines 2–3 show the matches immediately preceding the active one (from any group), or empty padding if fewer than 2 matches exist above in the natural window
- When the label "anchors" (the natural window would not show it), line 1 is pinned to the group label; lines 2–3 shift to show the 2 matches just above the active match
- Lines 2–3 are never replaced by additional group labels — exactly one label in lines 1–3

### In-scroll group separators
- `-- X --` group separator lines remain as content lines in the 7-line window — they are the same line that becomes the pinned label when they scroll above line 1
- When transitioning from group A to group B: the `-- B --` separator naturally enters the window from below; once it scrolls above line 1, it pins there as the anchored label
- No duplicate label: when the separator is already visible in lines 2–3 naturally, it does not also appear as a pinned line 1

### Padding line appearance
- Empty padding lines are completely blank — same elm-ui height as a match row, but no visible content
- No dots, dashes, underscores, or other filler characters
- Height must be pixel-identical to match rows to prevent layout shifts

### END marker
- `-- END --` appears only after the last match (match 48), as a single content line below it
- It occupies one line in the window (like a group separator)
- When the active match is match 48, `-- END --` appears at line 5; lines 6–7 are empty padding
- `-- END --` never appears above line 4 (SCRW-03) — it is treated as a below-active-only marker

### Claude's Discretion
- Exact windowing algorithm implementation (offset calculation vs. list slicing)
- How to handle the very first match of all (match 1 of group A): line 1 = `-- A --`, lines 2–3 = empty padding
- Whether to use a dedicated `PaddingLine` variant or empty strings for blank rows
- elm-ui element choice for fixed-height blank rows (`Element.none` with explicit height, or `Element.text ""`)

</decisions>

<specifics>
## Specific Ideas

No specific references from discussion — user delegated all decisions to Claude.

The phase requirements are precise (SCRW-01, SCRW-02, SCRW-03) and serve as the implementation spec. The decisions above interpret those requirements into concrete behavior.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 06-scroll-wheel-stability*
*Context gathered: 2026-02-28*
