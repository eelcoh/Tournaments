# Phase 5: Bug Fixes and UX Polish - Context

**Gathered:** 2026-02-28
**Status:** Ready for planning

<domain>
## Phase Boundary

Fix 5 specific regressions and UX inconsistencies identified after Phase 3 execution:
1. Flags missing from selectable team cells in bracket wizard grid (regression)
2. Home page comment input field not styled to match terminal-style participant form
3. No completion feedback when R32 is filled and bracket wizard is ready
4. Topscorer page visually inconsistent with terminal aesthetic
5. Group matches: score inputs and keyboard jump vertically at group boundary labels

All fixes must be within existing scope — no new capabilities.

</domain>

<decisions>
## Implementation Decisions

### Topscorer terminal aesthetic (issue #4)
- Keep flag badges alongside text — not text-only
- Selected team/player gets `>` prefix; others are plain (same as nav active state pattern)
- Section headers use `--- TITLE ---` format (displayHeader) to match rest of terminal UI
- When topscorer already selected: show current pick prominently at top as `> NAME (TEAM)`, then full selectable list below

### Completion feedback (issue #3)
- "Ga verder" button activates/highlights when R32 is complete — this is the primary signal
- Completed rounds in the ASCII stepper get a `✓` mark
- No inline status message needed — button + checkmark is sufficient
- **Key fix:** "Ga verder" button must be sticky at the bottom of the screen when R32 is complete, because the button is currently buried below the grid and not visible without scrolling

### Group boundary behavior (issue #5)
- Boundary labels (`-- B --`) are visual-only — cursor/focus skips them entirely, they are never focusable
- Keyboard arrow navigation also skips boundary labels (same rule as scroll)
- Labels still appear in the 5-match scroll window for visual group orientation
- When scrolling past last match in a group, cursor lands on first match of the next group

### Home page comment input (issue #2)
- Apply `UI.Style.terminalInput` styling: underline-only border, orange text/border on focus, dark background
- Always-visible static `>` prefix (not focus-dependent) — reads as a terminal command line prompt
- The input is the comment submission field on the chat/activity home page
- Display list of comments already has terminal styling from Phase 3 — only the input field needs updating

### Claude's Discretion
- Exact sticky button implementation approach (elm-ui `inFront` + `alignBottom` or similar)
- Whether flags regression (issue #1) is a one-line fix or requires deeper investigation
- Exact checkmark placement in the ASCII stepper

</decisions>

<specifics>
## Specific Ideas

- The `>` prompt pattern from the participant form ("wie ben jij" section) is the direct reference for both home page input and topscorer selection
- `UI.Style.terminalInput` is the existing style to reuse for home page input
- Sticky "Ga verder" is the key UX insight: users complete R32 by interacting with the grid at the top, but the continue button is far below — it must float into view when complete

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 05-bug-fixes-and-ux-polish*
*Context gathered: 2026-02-28*
