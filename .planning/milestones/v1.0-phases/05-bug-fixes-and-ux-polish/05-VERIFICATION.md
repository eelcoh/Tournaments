---
phase: 05-bug-fixes-and-ux-polish
verified: 2026-02-28T15:00:00Z
status: human_needed
score: 5/5 must-haves verified
human_verification:
  - test: "Flag images appear in bracket wizard computer-layout team cells"
    expected: "Each team cell in the group-row grid shows a 16px flag icon to the left of the 3-char team code"
    why_human: "Visual rendering — cannot confirm pixel output from source code alone"
  - test: "Sticky 'Ga verder' button appears when R32 is complete, absent on other pages"
    expected: "After filling all 32 R32 slots the button pins to the bottom of the bracket page; navigating to group matches or topscorer it does not appear"
    why_human: "Interactive/stateful behavior; inFront overlay visibility depends on isWizardComplete runtime value"
  - test: "Completed rounds in the ASCII stepper show checkmark (U+2713) instead of 'x'"
    expected: "Full stepper shows '✓' dot; compact stepper shows '[✓]' prefix for completed non-active rounds"
    why_human: "Unicode character rendering in browser — source code has the right codepoints but visual confirmation required"
  - test: "Topscorer page shows vertical terminal text rows"
    expected: "Teams appear as one-per-line rows (flag + code), not badge buttons; selected team shows '> ' prefix in orange; section headers use '--- TITLE ---' format"
    why_human: "Visual layout change — requires browser inspection to confirm no badge buttons remain"
  - test: "Home page comment input has terminal styling with '>' prompt prefix"
    expected: "Comment input fields have underline-only border, dark background, orange border on focus, and static '>' character to the left"
    why_human: "Visual styling and focus-state behavior requires browser interaction to verify"
  - test: "GroupBoundary rows have same height as match rows (no vertical jump)"
    expected: "Scrolling past a group boundary does not change the total height of the scroll wheel column"
    why_human: "Layout jump is only observable in the running app — cannot be verified from attribute inspection alone"
---

# Phase 5: Bug Fixes and UX Polish Verification Report

**Phase Goal:** Fix regressions and UX inconsistencies identified after Phase 3 execution
**Verified:** 2026-02-28T15:00:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Flag images appear in the computer-layout bracket grid alongside team codes | VERIFIED | `viewTeamBadge` (lines 526–578) contains `flagImg` let-binding using `Element.image` and `T.flagUrl (Just team)`; both selectable and non-selectable branches render `Element.row [spacing 4] [flagImg, teamCodeEl]` |
| 2 | Completed rounds in the ASCII stepper show checkmark instead of 'x' | VERIFIED | `viewRoundStepperFull` line 128: `dotChar` returns `"\u{2713}"` for complete rounds; `viewRoundStepperCompact` line 197: `prefix` returns `"[\u{2713}] "` for complete non-active rounds |
| 3 | Sticky "Ga verder" button appears pinned to the bottom of the bracket page when R32 is complete | VERIFIED | `view` (lines 73–91) builds `stickyButton` conditional on `isWizardComplete sel`; outer `Element.el [Element.inFront stickyButton, Element.width Element.fill]` wraps only the `page "bracket"` call — not the global layout |
| 4 | Sticky button is absent on other pages (group matches, topscorer) | VERIFIED | `Element.inFront` appears exactly once in `src/Form/Bracket/View.elm` (line 86); absent from `src/Form/GroupMatches.elm`, `src/Form/Topscorer.elm`, `src/View.elm` global layout |
| 5 | Topscorer team list is a vertical column of text rows, not a horizontal wrapped row of badge buttons | VERIFIED | `forGroup` uses `Element.column [spacing 4]` mapping `viewTeamRow`; `mkTeamButton` and `mkPlayerButton` are absent from file; `UI.Button` import removed |
| 6 | Selected team gets '> ' prefix in orange; unselected teams are plain text | VERIFIED | `viewTeamRow` (lines 143–185): `prefix = "> "` and `textColor = Color.orange` when `Selected`; `"  "` and `Color.primaryText` when `NotSelected` |
| 7 | Flag images appear alongside team codes in the topscorer team list | VERIFIED | `viewTeamRow` lines 165–172: `flagImg` uses `Element.image` with `T.flagUrl (Just team)` |
| 8 | Player list is a vertical column with '> ' prefix for selected player | VERIFIED | `viewPlayerRow` (lines 188–217) mirrors `viewTeamRow`; `viewPlayers` uses `Element.column` |
| 9 | When a topscorer is already selected, current pick is shown prominently at top | VERIFIED | `viewSelectedTopscorer` (lines 122–141): renders `"> " ++ T.display team ++ " (" ++ T.displayFull team ++ ")"` in orange when team is set |
| 10 | Section headers use '--- TITLE ---' displayHeader format | VERIFIED | `UI.Text.displayHeader "Kies een land"` (line 98), `UI.Text.displayHeader "Kies een speler"` (line 257), `UI.Text.displayHeader "Wie wordt de topscorer?"` (line 92) |
| 11 | Comment input on activities page uses terminal styling with '>' prompt | VERIFIED | All three inputs (`commentInput`, `commentInputTrap`, `authorInput`) use `UI.Style.terminalInput False` (lines 171, 191, 212); each wrapped in `Element.row [spacing 8] [Element.el [...] (Element.text ">"), Input.{text,multiline} ...]` |
| 12 | GroupBoundary rows in scroll wheel have fixed 44px height | VERIFIED | `viewScrollItem` GroupBoundary branch (lines 260–268): `Element.height (Element.px 44)` and `centerY` present, matching `viewScrollLine`'s `height (px 44)` |

**Score:** 12/12 truths verified (automated)

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/Form/Bracket/View.elm` | Flag images in viewTeamBadge; checkmark stepper; sticky inFront button | VERIFIED | All three changes confirmed at lines 526–578 (flags), 127–131 (checkmark full), 196–198 (checkmark compact), 73–91 (sticky button) |
| `src/Form/Topscorer.elm` | Terminal-aesthetic topscorer view with flat text rows | VERIFIED | `viewTeamRow`, `viewPlayerRow`, `viewSelectedTopscorer` all present; `mkTeamButton`/`mkPlayerButton` absent |
| `src/Activities.elm` | Terminal-styled comment input with > prompt prefix | VERIFIED | `terminalInput False` applied to all three inputs; `>` prompt elements present |
| `src/Form/GroupMatches.elm` | Fixed GroupBoundary height in viewScrollItem | VERIFIED | `Element.height (Element.px 44)` at line 265 in GroupBoundary branch |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/Form/Bracket/View.elm` | `T.flagUrl` | `Element.image` in `viewTeamBadge` | WIRED | Pattern `flagUrl.*Just team` found at lines 422, 534, 599 |
| `src/Form/Bracket/View.elm` | `Element.inFront` | outer el wrapper on `page "bracket"` call | WIRED | `Element.inFront stickyButton` at line 86; `isWizardComplete sel` guards the button at line 74 |
| `src/Form/Topscorer.elm` | `UI.Text.displayHeader` | section headers for team and player sections | WIRED | Called at lines 92, 98, 257 |
| `src/Form/Topscorer.elm` | `T.flagUrl` | `Element.image` in `viewTeamRow` | WIRED | `T.flagUrl (Just team)` at line 170 |
| `src/Activities.elm` | `UI.Style.terminalInput` | applied to all three comment input fields | WIRED | `terminalInput False` at lines 171, 191, 212 |
| `src/Form/GroupMatches.elm` | `GroupBoundary` branch with `height (px 44)` | `viewScrollItem` | WIRED | `Element.height (Element.px 44)` at line 265 |

### Requirements Coverage

Phase 5 uses internal issue identifiers (ISSUE-1 through ISSUE-5) that are not tracked in `REQUIREMENTS.md`. The REQUIREMENTS.md traceability table covers phases 1–4 only; Phase 5 is a separate backlog of five targeted regressions defined in ROADMAP.md and CONTEXT.md. No REQUIREMENTS.md IDs are assigned to Phase 5, and no REQUIREMENTS.md IDs are declared in any Phase 5 plan frontmatter as orphaned.

| Issue | Description | Plans | Status |
|-------|-------------|-------|--------|
| ISSUE-1 | Flags missing from bracket wizard computer-layout grid | 05-01 | SATISFIED — `viewTeamBadge` now renders flag images |
| ISSUE-2 | Home page comment input not terminal-styled | 05-03 | SATISFIED — `terminalInput False` + `>` prompt on all three inputs |
| ISSUE-3 | No completion feedback when R32 is filled | 05-01 | SATISFIED — sticky `inFront` button + checkmark stepper |
| ISSUE-4 | Topscorer page visually inconsistent with terminal aesthetic | 05-02 | SATISFIED — `viewTeamRow`/`viewPlayerRow` vertical columns with `>` prefix |
| ISSUE-5 | Group matches: vertical jump at group boundary labels | 05-03 | SATISFIED — `Element.height (Element.px 44)` on GroupBoundary rows |

**Orphaned requirements check:** REQUIREMENTS.md assigns no IDs to Phase 5. No orphaned requirements.

**Note on UI.Page.elm:** Plan 04 committed a `container` function and module signature update to `src/UI/Page.elm` (commit b6db886). This is noted as a "stray change from plan 01 work" — it adds infrastructure for Phase 4 (CON-01/CON-02). It does not affect any Phase 5 truth and compiles cleanly.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `src/Activities.elm` | 240 | Dead comment block (`-- Element.column UI.Style.CommentInputBox`) | Info | Harmless leftover comment; does not affect behavior |

No stubs, empty implementations, or TODO/FIXME markers found in any Phase 5 modified file.

### Build Verification

`elm make src/Main.elm --optimize` executed with result: **Success** — `Main ───> build/main.js`

All four modified modules (`Form/Bracket/View.elm`, `Form/Topscorer.elm`, `Activities.elm`, `Form/GroupMatches.elm`) compiled without errors.

### Commit Verification

All task commits confirmed present in git log:

| Commit | Plan | Description |
|--------|------|-------------|
| `8504287` | 05-01 Task 1 | feat: add flag images to viewTeamBadge in computer layout bracket |
| `9cb6f75` | 05-01 Task 2 | feat: checkmark stepper + sticky Ga verder button in bracket wizard |
| `4c66c57` | 05-02 Tasks 1+2 | feat: replace mkTeamButton and forGroup with terminal-style viewTeamRow |
| `9a9d78f` | 05-03 Task 1 | feat: terminal input styling for Activities comment input |
| `2b0dc7b` | 05-03 Task 2 | fix: fix GroupBoundary height to prevent scroll wheel layout jumps |
| `b6db886` | 05-04 Task 1 | chore: commit stray UI.Page.elm change from prior plan work |

### Human Verification Required

All 12 automated truths pass. The following require browser confirmation because they involve visual rendering, interactive state, and focus-state behavior that cannot be verified from source code alone.

#### 1. Flag images in bracket computer-layout cells

**Test:** Open the bracket wizard on a desktop viewport (>500px wide). Observe any round's group-row grid.
**Expected:** Each team cell shows a small 16px flag icon to the left of the 3-char team code (e.g., a Dutch flag next to "NED").
**Why human:** Pixel rendering of `Element.image` with `T.flagUrl` — source confirms the call is correct but image load success requires visual check.

#### 2. Sticky "Ga verder" button

**Test:** Navigate to the bracket wizard and complete the R32 round (fill all 32 slots). Observe the bottom of the screen.
**Expected:** A "Ga verder ->" button appears pinned to the bottom of the viewport while on the bracket page. Navigate to group matches — the button is absent.
**Why human:** `inFront` + `alignBottom` overlay behavior and `isWizardComplete` runtime condition require live state.

#### 3. Checkmark characters in stepper

**Test:** Complete one or more rounds in the bracket wizard. Observe the ASCII stepper at the top.
**Expected:** Full stepper shows '✓' dot under completed round labels. Compact stepper (Phone layout) shows '[✓]' prefix.
**Why human:** Unicode U+2713 rendering in the user's browser/font must be confirmed visually.

#### 4. Topscorer terminal layout

**Test:** Navigate to the topscorer page.
**Expected:** Teams appear as a vertical list of text rows (one team per line), each showing flag + 3-char code. No bordered badge buttons. Click a team: it gets '> ' prefix in orange, others remain plain. A player list appears below "--- KIES EEN SPELER ---".
**Why human:** Confirms badge buttons are gone and vertical layout renders correctly across viewport sizes.

#### 5. Home page comment input terminal styling

**Test:** Navigate to the home page. Observe and interact with the comment input field.
**Expected:** Input has underline-only border, dark background, static '>' to the left. When focused, border/underline turns orange.
**Why human:** `UI.Style.terminalInput` CSS-level styling (border-bottom, background, focus color) requires browser rendering to confirm.

#### 6. GroupBoundary no vertical jump

**Test:** In the group matches scroll wheel, use scroll/keyboard/swipe to advance the cursor past the last match of a group.
**Expected:** When the boundary label "-- B --" appears in the 5-match window, the overall column height does not change (no vertical jump). The boundary row occupies the same vertical space as a match row.
**Why human:** Layout stability under scroll state changes is only observable in the running app.

### Gaps Summary

No gaps. All automated checks pass. Phase goal is achievable pending human visual confirmation of the 6 browser tests above.

Human approval was already recorded in 05-04-SUMMARY.md ("approved") — this verification independently confirms the code evidence supports that approval.

---

_Verified: 2026-02-28T15:00:00Z_
_Verifier: Claude (gsd-verifier)_
