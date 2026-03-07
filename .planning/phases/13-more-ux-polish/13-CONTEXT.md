# Phase 13: more-ux-polish - Context

**Gathered:** 2026-03-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Fix the most noticeable remaining UX rough edges in the app: loading state copy, input field discoverability and label style, and placeholder flag SVGs for missing/TBD teams. These are all self-contained polish items that do not add new features.

</domain>

<decisions>
## Implementation Decisions

### Loading states
- Replace "Aan het ophalen." / "Aan het ophalen..." with `[ ophalen... ]` — matches the terminal bracket aesthetic used throughout (`[x]`, `[ ]`)
- Apply to all RemoteData loading cases in the activities feed (NotAsked and Loading)
- Empty activities feed (Success []): show nothing — omit the empty state entirely

### Input label style (home page)
- Home page comment input currently shows `ZEG WAT` / `NAAM` label headers above fields
- Replace with `>` prompt prefix style to match the participant form (the `>` is placed inline left of the input field, no separate label element above)
- This applies to: comment message input, comment author input on the home page

### Input field visibility
- All `terminalInput` fields app-wide are too subtle — users miss that they're interactive
- Fix: use a slightly lighter background (`primaryDark` #353535) instead of `black` (#3F3F3F) for the input background
- Applies to the `terminalInput` style in `UI.Style` — this covers home page inputs, participant form, blog post input
- Score inputs (`scoreInput` style) are separate — leave those as-is

### Placeholder flag SVGs
- Two SVG files must be created in `assets/svg/`:
  - `404-not-found.svg` — for unknown/unrecognised teamIDs (grey square with `?` symbol)
  - `999-to-be-decided.svg` — for empty bracket slots / TBD teams (grey square with `...` or similar pending symbol)
  - Both use a square viewBox (e.g., `0 0 100 100`) so they scale correctly at 15x15, 30x30, and 40x40 render sizes
- Code changes in `Bets.Types.Team`:
  - `flagUrlRound` default case: return `assets/svg/404-not-found.svg` (renamed from `404.svg`)
  - `flagUrl Nothing` case: return `assets/svg/999-to-be-decided.svg` (currently falls through to the unknown teamID path — needs its own branch)

### Claude's Discretion
- Exact SVG design details (stroke weight, symbol sizing within the viewBox)
- Whether `flagUrl` is refactored to thread the Nothing/unknown distinction cleanly, or handled with a wrapper

</decisions>

<specifics>
## Specific Ideas

- The `>` prompt prefix style comes from the participant form — that's the reference for how home page inputs should look
- Input background: `primaryDark` (#353535) is the target — just enough lift to show contrast against the `black` (#3F3F3F) body background

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `UI.Style.terminalInput` — single function controlling input appearance; changing the background here fixes all inputs at once
- `UI.Style.introduction` / `UI.Style.text` — used in activity items; loading text element can reuse these styles
- `Activities.commentBox` / `commentView` — the specific function to update for `>` prefix style

### Established Patterns
- `[x]` / `[ ]` bracket format — used in `viewTopCheckboxes` and `cardCenterInfo`; `[ ophalen... ]` follows same pattern
- `>` prompt prefix — used in `Activities.viewCommentInput` (line 169) and participant form; replicate this for the label replacement
- `T.flagUrl` in `Bets.Types.Team` — currently `flagUrl Nothing` calls `uri (team "xyz" "")` which falls to the `_ ->` default in `flagUrlRound`; needs a dedicated `Nothing` branch

### Integration Points
- `src/Activities.elm` — `viewCommentInput`, `viewActivities` (loading/empty states)
- `src/Bets/Types/Team.elm` — `flagUrl`, `flagUrlRound`
- `src/UI/Style.elm` — `terminalInput` function (Background.color line)
- `assets/svg/` — new SVG files to be added

</code_context>

<deferred>
## Deferred Ideas

- Scroll wheel jumping (#94) — noted by user but not selected for this phase; keep open as a separate issue
- ANewBet activity display (missing space + no link to bet) — rough edge exists but not scoped here
- Submit card outdated URL/text — not addressed in this phase

</deferred>

---

*Phase: 13-more-ux-polish*
*Context gathered: 2026-03-07*
