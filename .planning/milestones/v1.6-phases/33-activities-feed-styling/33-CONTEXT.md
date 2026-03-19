# Phase 33: Activities Feed Styling - Context

**Gathered:** 2026-03-15
**Status:** Ready for planning

<domain>
## Phase Boundary

Restyle `commentBox` and `blogBox` in `Activities.elm` so each activity entry displays with a distinct colored left border and subtle tinted background: amber for comments, green for blog posts. No new interactivity or layout changes — pure visual styling.

</domain>

<decisions>
## Implementation Decisions

### Left border placement
- Colored left border + tinted background go on the **outer card container** (commentBox/blogBox), not on the inner text paragraph
- The whole entry (timestamp/author header row + text body) gets the tinted bg treatment
- Activities.elm stops using `UI.Style.introduction` for the text body — inner text uses plain font/color attrs instead
- Border width: **2px** on the left, 1px on other sides (matches spec)

### Comment styling (ACTIVITIES-01)
- Left border color: `Color.orange` = `#F0DFAF` (amber — exact spec match)
- Background tint: `Element.rgba255 0xF0 0xDF 0xAF 0.04` (subtle amber)
- Text: dim (`Color.grey`), monospace, 11px

### Blog post styling (ACTIVITIES-02)
- Left border color: **new constant** `Color.zenGreen = rgb255 0x7F 0x9F 0x7F` (`#7f9f7f` — muted Zenburn sage green, distinct from existing `Color.green = #429F59`)
- Background tint: `Element.rgba255 0x7F 0x9F 0x7F 0.04` (subtle green)
- Text: dim (`Color.grey`), monospace, 11px
- Visually distinct from comments at a glance

### UI.Style.introduction — unchanged
- Leave `introduction` style as-is (used for CHROME-02 card intro texts elsewhere)
- Do NOT update introduction's `Border.color` — it stays `Color.activeNav` for its existing uses
- Activities.elm will no longer use `introduction` for its text bodies

### Claude's Discretion
- Exact name for the new green constant (`zenGreen`, `softGreen`, `muted` — choose readable name)
- Whether to factor shared outer card attrs into a helper or inline per box
- Line-height / spacing on inner text paragraphs

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements are fully captured in decisions above.

### Requirements
- `ACTIVITIES-01`, `ACTIVITIES-02` in `.planning/REQUIREMENTS.md` — full spec for each entry type

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `UI.Style.resultCard` — base card style (`primaryDark` bg, `terminalBorder` 1px border); commentBox/blogBox use this today; extend with `Border.widthEach` + `Border.color` override
- `Color.orange` (`#F0DFAF`) — exact amber color for comment border
- `Color.grey` — dim text color for body text
- `UI.Text.timeText`, `UI.Text.dateText` — timestamp formatters already in use

### Established Patterns
- `resultCard attrs` takes a list of override attrs — add `Border.widthEach { left = 2, right = 1, top = 1, bottom = 1 }` and `Border.color` + `Background.color` as overrides (same pattern as CHROME-02's `blogBox` uses `Border.widthEach`)
- `rgba255 R G B 0.04` for subtle tinted bg — matches CHROME-02 intro bg pattern

### Integration Points
- **`src/Activities.elm`** — `commentBox` (line ~127) and `blogBox` (line ~108): change outer card attrs, strip inner `introduction` usage
- **`src/UI/Color.elm`** — add `zenGreen` constant; expose from module

### Current state before this phase
- `blogBox`: `resultCard` + 3px `Color.activeNav` left border + inner `introduction` paragraph (double border today)
- `commentBox`: plain `resultCard` + inner `introduction` paragraph (single inner border today)
- Both need to be updated to the outer-card-only approach with correct colors

</code_context>

<specifics>
## Specific Ideas

No specific references — the requirements and decisions above fully specify the visual target.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 33-activities-feed-styling*
*Context gathered: 2026-03-15*
