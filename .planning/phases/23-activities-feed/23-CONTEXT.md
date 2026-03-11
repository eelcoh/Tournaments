# Phase 23: Activities Feed - Context

**Gathered:** 2026-03-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Apply the v1.4 card aesthetic and prototype typography to the activities feed in `src/Activities.elm`. This covers comment entries, blog post entries, system notifications (ANewBet, ANewRanking), and the comment/post input form. No new activity types or feed behaviours — purely visual restyling.

</domain>

<decisions>
## Implementation Decisions

### Card treatment

- Comment entries: full `resultCard` treatment (`#353535` bg + `#4a4a4a` border on all 4 sides), `paddingXY 12 8` inside the card
- Blog post entries: same `resultCard` base + an **orange/amber left border accent** (`Border.widthEach { left = 3, others = 1 }`) to visually distinguish posts from comments
- `ANewBet` and `ANewRanking` notifications: **no card** — render as a single styled inline text line (minimal weight, does not clutter the feed)
- Cards are separated by `spacing 12` in the outer activities column (consistent with results pages)

### Timestamp / author typography (ACT-02)

- Timestamp `[HH:MM]`: `Font.color Color.grey` + `Font.size 12` (smaller than default — clearly secondary)
- Author label (`eelco:`) and blog title (`## Speeldag 1`): `Font.color Color.orange` + default size (unchanged — already implemented, keep)
- Body text (comment/blog content): `Font.color Color.text` (cream `#DCDCCC`) at default size — readable, warm
- Blog post date footer (`-- eelco, 10 mrt`): keep `alignRight` + `Font.color Color.grey` + `Font.size 12`

### Notification entries (ANewBet, ANewRanking)

- No card wrapper — render as a plain styled line
- Format: grey timestamp `[HH:MM]` + cream text (e.g. `naam doet mee` / `De stand is bijgewerkt`)
- Uses `UI.Text.timeText tz activityMeta.date` for the timestamp
- Low visual weight — informational only

### Comment & post input form

- Switch input container from `normalBox` to `darkBox` (which already has `#353535` bg + full border + `padding 20`) — consistent with v1.4 card aesthetic
- Save buttons (`prik!`, `post!`) keep existing pill style — no change

### Claude's Discretion

- Exact `Border.color` value for the blog post left accent (use `Color.activeNav` or `Color.orange` — pick whichever reads cleaner against `#353535` bg)
- Spacing between timestamp/author row and body content within each card
- Whether the `ANewBet` notification includes the player name or is just a generic system message (use best judgment from existing code)

</decisions>

<specifics>
## Specific Ideas

- Blog post card mockup confirmed: left amber border accent (3px) on the left side of the standard resultCard
- Notification lines should feel like terminal system messages — not prominent, just informational

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets

- `UI.Style.resultCard` — established v1.4 card helper (`#353535` bg, `#4a4a4a` border, `paddingXY 0 0`). Used by all five results pages. Use directly for comment cards.
- `UI.Style.darkBox` — `#353535` bg + full border + `padding 20`. Use for the comment/post input wrapper.
- `UI.Text.timeText tz dt` — already returns `[HH:MM]` format. Already used in `commentBox` and `blogBox`.
- `Color.grey`, `Color.orange`, `Color.text`, `Color.activeNav`, `Color.terminalBorder` — all established in `UI.Color`.

### Established Patterns

- `resultCard` rows handle their own `paddingXY 12 8` — same pattern here
- `Font.size 12` for metadata (timestamps, date footer) — consistent with MEMORY note on `UI.Text.timeText`
- Notification entries styled as plain `Element.text` in a `row` with `paddingXY 12 8` — matches the low-weight system message pattern

### Integration Points

- `src/Activities.elm` — `commentBox`, `blogBox`, `viewActivity` for `ANewBet`/`ANewRanking`, `viewCommentInput`, `viewPostInput`
- No changes to `Types.elm`, JSON decoders, or API — purely view layer

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 23-activities-feed*
*Context gathered: 2026-03-11*
