---
phase: 34-input-auto-focus
plan: "01"
subsystem: activities-and-participant-form
tags: [focus, ux, elm, browser-dom]
dependency_graph:
  requires: []
  provides: [FOCUS-01, FOCUS-02, FOCUS-03]
  affects: [src/Activities.elm, src/Form/Participant.elm, src/Main.elm]
tech_stack:
  added: []
  patterns: [Browser.Dom.focus, Html.Attributes.id, Task.attempt]
key_files:
  created: []
  modified:
    - src/Activities.elm
    - src/Form/Participant.elm
    - src/Main.elm
decisions:
  - "Used Html.Attributes.id (not Element.htmlAttribute directly) for elm-ui compatibility"
  - "Participant name ID applied conditionally only when tag == NameTag"
  - "NavigateTo uses Cmd.batch to combine scroll-to-top with optional focus cmd"
metrics:
  duration: "~2 minutes"
  completed: "2026-03-15"
  tasks_completed: 2
  files_modified: 3
---

# Phase 34 Plan 01: Input Auto-Focus Summary

Wire up automatic keyboard focus for comment input, blog post textarea, and participant name field using `Browser.Dom.focus` + HTML element IDs.

## What Was Implemented

Three auto-focus targets wired up end-to-end:

1. **Comment input (FOCUS-01):** `Html.Attributes.id "comment-input"` added to the `Input.multiline` in `commentInput` local function inside `viewCommentInput`. `ShowCommentInput` handler now emits `Task.attempt (\_ -> NoOp) (Browser.Dom.focus "comment-input")` instead of `Cmd.none`.

2. **Participant name field (FOCUS-02):** `Html.Attributes.id "participant-name"` added conditionally when `tag == NameTag` in `inputField` in `Form/Participant.elm`. `NavigateTo` handler now uses `Cmd.batch` combining the existing `setViewport` scroll command with a conditional `Browser.Dom.focus "participant-name"` when the target card is `ParticipantCard _`.

3. **Blog post textarea (FOCUS-03):** `Html.Attributes.id "post-input"` added to the `Input.multiline` in `postInput` local function inside `viewPostInput`. `ShowPostInput` handler now emits `Task.attempt (\_ -> NoOp) (Browser.Dom.focus "post-input")` instead of `Cmd.none`.

## Files Modified

| File | Change |
|---|---|
| `src/Activities.elm` | Added `import Html.Attributes`; `id "comment-input"` on commentInput multiline; `id "post-input"` on postInput multiline |
| `src/Form/Participant.elm` | Added `import Html.Attributes`; `id "participant-name"` on NameTag Input.text (conditional) |
| `src/Main.elm` | `ShowCommentInput` → focus "comment-input"; `ShowPostInput` → focus "post-input"; `NavigateTo` → Cmd.batch with conditional focus on ParticipantCard |

## Decisions Made

- `Html.Attributes.id` passed via `Element.htmlAttribute` — standard elm-ui pattern for native HTML attributes
- The participant name ID is applied only on `NameTag` (not all fields) to avoid unintended focus when other fields have the same ID
- `Task.attempt (\_ -> NoOp)` used to discard the `Result` from `Browser.Dom.focus` (element not found is silently ignored — acceptable since focus errors are non-fatal)
- `NavigateTo` uses `Cmd.batch` to preserve existing scroll-to-top behavior alongside new focus behavior

## Deviations from Plan

None - plan executed exactly as written.

## Commits

- `26f1373` feat(34-01): add HTML element IDs to comment, post, and participant-name inputs
- `e9656c4` feat(34-01): emit Browser.Dom.focus commands from ShowCommentInput, ShowPostInput, NavigateTo

## Self-Check: PASSED
