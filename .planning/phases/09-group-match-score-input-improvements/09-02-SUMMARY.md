---
phase: 09-group-match-score-input-improvements
plan: "02"
subsystem: Form.GroupMatches
tags: [elm, mobile, ux, keyboard, score-input, flags]
dependency_graph:
  requires: []
  provides: [keyboard-primary-score-input, flag-header, andere-score-overlay]
  affects: [src/Form/GroupMatches.elm, src/Form/GroupMatches/Types.elm]
tech_stack:
  added: []
  patterns: [overlay-toggle, always-visible-header, keyboard-first-ux]
key_files:
  created: []
  modified:
    - src/Form/GroupMatches/Types.elm
    - src/Form/GroupMatches.elm
decisions:
  - "Split viewInput into viewMatchHeader (always-rendered) + viewScoreInputs (overlay-only) to enforce flags always visible"
  - "Reset manualInputVisible in updateCursor so any cursor change (scroll, jump, auto-advance) collapses overlay"
  - "UI.Style.link already appends Element.pointer — no duplicate attribute passed"
metrics:
  duration: ~15 minutes
  completed: 2026-03-01
  tasks_completed: 2
  tasks_total: 2
  files_modified: 2
---

# Phase 9 Plan 02: Keyboard-Primary Score Input with Always-Visible Flags Summary

**One-liner:** Restructured group match score input to show flags always in a permanent header, keyboard as default, with text inputs accessible via "andere score" overlay toggle.

## Tasks Completed

| # | Name | Commit | Files |
|---|------|--------|-------|
| 1 | Extend State and Msg in Form.GroupMatches.Types | 965739b | src/Form/GroupMatches/Types.elm |
| 2 | Restructure GroupMatches.elm — split viewInput, always-visible flags, andere score overlay | 5fb07bb | src/Form/GroupMatches.elm |

## What Was Built

### Task 1 — Types extension

Added two new `Msg` variants to `Form.GroupMatches.Types`:
- `ShowManualInput` — triggers overlay display
- `HideManualInput` — collapses overlay back to keyboard

Extended `State` with:
- `manualInputVisible : Bool` — defaults to `False` in `init`

Updated `updateCursor` to reset `manualInputVisible = False` whenever the cursor moves (whether by `Explicit`, `Implicit`, or `Dont`). This ensures any navigation event (group jump, scroll, auto-advance) collapses the overlay.

### Task 2 — GroupMatches.elm restructuring

**Update handlers added:**
- `ShowManualInput -> ( bet, { state | manualInputVisible = True }, Cmd.none )`
- `HideManualInput -> ( bet, { state | manualInputVisible = False }, Cmd.none )`
- `Update matchID h a` now resets `manualInputVisible = False` before calling `updateCursor` so keyboard tap auto-advances and collapses any open overlay

**New functions:**

`viewMatchHeader : Team -> Team -> Element.Element Msg`
- Always rendered above whichever input body is active
- Shows 24px flag images for home and away teams via `T.flagUrl (Just team)`
- Shows team display names in white monospace font
- Horizontal row: [flag] [name] [-] [name] [flag]

`viewScoreInputs : MatchID -> Maybe Score -> Element.Element Msg`
- Only rendered when `state.manualInputVisible == True`
- Contains two text input fields (home/away) with `inputmode="numeric"`
- Uses existing `UI.Style.scoreInput` and `UI.Style.wrapper` styles

**View composition rewritten:**
- `viewMatchHeader homeTeam awayTeam` always rendered at top
- `body` below it is conditional:
  - `manualInputVisible == False`: keyboard + "andere score" link
  - `manualInputVisible == True`: text inputs + "<- terug" link
- Links use `UI.Style.link` (orange color + pointer)

**Old `viewInput` removed** — replaced entirely by the two new functions.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Tasks 1 and 2 committed separately despite Elm requiring both for compilation**

- **Found during:** Task 1 commit verification
- **Issue:** Adding `ShowManualInput`/`HideManualInput` to `Msg` in Types.elm causes `GroupMatches.elm` to fail compilation with MISSING PATTERNS until the update handlers are added in Task 2
- **Fix:** Both tasks were implemented before the first build verification was run; Tasks 1 and 2 were committed as separate git commits but both needed to be in place before the build passed
- **Files modified:** Both already listed above
- **Impact:** Zero — final state is exactly as planned; the commit ordering is the only difference

None - plan executed exactly as written from a code correctness perspective.

## Verification Results

```
grep "manualInputVisible" src/Form/GroupMatches/Types.elm
    , manualInputVisible : Bool
    , manualInputVisible = False
    { model | cursor = newCursor, manualInputVisible = False }

grep "andere score" src/Form/GroupMatches.elm
    (Element.text "andere score")

grep "flagUrl" src/Form/GroupMatches.elm
    { src = T.flagUrl (Just team)

grep "viewMatchHeader" src/Form/GroupMatches.elm
    [ viewMatchHeader homeTeam awayTeam
viewMatchHeader : Team -> Team -> Element.Element Msg
viewMatchHeader homeTeam awayTeam =

grep "ShowManualInput|HideManualInput" src/Form/GroupMatches.elm
    ShowManualInput ->
    HideManualInput ->
    (UI.Style.link [ centerX, UI.Font.mono, Element.Events.onClick ShowManualInput ])
    (UI.Style.link [ centerX, UI.Font.mono, Element.Events.onClick HideManualInput ])

make debug: Success! Compiled 1 module.
```

## Self-Check: PASSED

- src/Form/GroupMatches/Types.elm: FOUND
- src/Form/GroupMatches.elm: FOUND
- Commit 965739b: FOUND
- Commit 5fb07bb: FOUND
- Build: Success
