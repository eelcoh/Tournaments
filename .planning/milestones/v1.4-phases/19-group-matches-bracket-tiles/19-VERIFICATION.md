---
phase: 19-group-matches-bracket-tiles
verified: 2026-03-09T18:00:00Z
status: human_needed
score: 4/4 must-haves verified
human_verification:
  - test: "Focus a score input field"
    expected: "Border turns orange; text brightens to the warmer activeNav orange (#F0A030)"
    why_human: "Element.focused state cannot be verified programmatically from source code alone"
  - test: "Scroll through the group match wheel and observe active vs inactive rows"
    expected: "Active match row glows with an orange border; all other rows show a grey border; all rows fill the full container width flush with no gaps"
    why_human: "Visual tile border rendering and fill-width layout require browser rendering to confirm"
  - test: "Hover over a selectable bracket tile on a desktop/computer layout"
    expected: "Border shifts from grey to orange on hover; cursor shows pointer"
    why_human: "Element.mouseOver hover state requires real browser interaction to verify"
  - test: "Select a team in the bracket wizard"
    expected: "Selected tile shows orange border plus a subtle orange-tinted background (~15% opacity amber)"
    why_human: "The rgba tinted background (rgba 0.94 0.87 0.69 0.15) needs visual inspection to confirm it is perceptible but subtle"
---

# Phase 19: Group Matches & Bracket Tiles Verification Report

**Phase Goal:** The group matches scroll wheel and bracket wizard display prototype-style tiles — styled score inputs, SVG flag rows, bordered bracket team cards, and a round header with selection counter.
**Verified:** 2026-03-09T18:00:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Score input boxes have a dark background, orange text, and a visible border that changes on focus | ✓ VERIFIED | `scoreInput` in `src/UI/Style.elm` line 615–626: `Border.width 1`, `Border.color Color.terminalBorder`, `Background.color Color.primaryDark`, `Font.color Color.orange`, `Element.focused [ Border.color Color.orange, Font.color Color.activeNav ]` |
| 2 | Scroll wheel match rows show SVG team flags alongside team names in a consistent boxed row layout | ✓ VERIFIED | `viewScrollLine` in `src/Form/GroupMatches.elm` line 419–436 uses `UI.Style.matchRowTile isActive [...]` as outer container with `Element.width Element.fill`; flags are 24x24 px (lines 368–369); `viewScrollWheel` uses `spacing 0` (line 312) |
| 3 | Bracket team tiles are bordered cards with a distinct selected state (orange border + tinted background) and visible hover feedback | ✓ VERIFIED | `viewSelectableTeam` in `src/Form/Bracket/View.elm`: placed state (lines 391–405) uses `Border.color Color.orange` + `Background.color (rgba 0.94 0.87 0.69 0.15)`; selectable state (lines 407–421) uses `Border.color Color.terminalBorder` + `Element.mouseOver [ Border.color Color.orange ]`; `viewTeamBadge` (lines 516–579) same pattern; both functions use 80x44 px cards |
| 4 | The bracket round header displays the round title, a description, and a `N/M geselecteerd` counter that updates as teams are picked | ✓ VERIFIED | `viewRoundSection` in `src/Form/Bracket/View.elm` lines 199–221: `counterText` uses `"N/M geselecteerd"` format with Unicode checkmark on completion; `roundDescription` helper at line 459 covers all six `SelectionRound` values; `description` element uses grey 12px text below the title row |

**Score:** 4/4 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/UI/Style.elm` | `scoreInput` with full 4-side border + focused state; `matchRowTile` exported | ✓ VERIFIED | `scoreInput` at line 615 — `Border.width 1`, grey unfocused, `Element.focused` with orange + `activeNav`. `matchRowTile` at line 735, exported at line 33. Build passes. |
| `src/Form/GroupMatches.elm` | `viewScrollLine` uses `matchRowTile`; 24px flags; spacing 0 in wheel | ✓ VERIFIED | `matchRowTile isActive` called at line 420; flags 24x24 at lines 368–369; `spacing 0` at line 312; ASCII prefix/suffix arrows absent |
| `src/Form/Bracket/View.elm` | `viewTeamBadge` and `viewSelectableTeam` as 80x44 bordered cards; `roundDescription` helper; counter format updated | ✓ VERIFIED | Both functions produce 80x44 cards with `Border.width 1`, `Border.rounded 2`, `Background.color Color.primaryDark`; `roundDescription` at line 459; counter at lines 200–204 |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/Form/GroupMatches.elm` | `src/UI/Style.elm` | `UI.Style.scoreInput` called in `viewScoreInputs` | ✓ WIRED | Line 534: `Input.text (UI.Style.scoreInput [...])` |
| `src/Form/GroupMatches.elm` | `src/UI/Style.elm` | `UI.Style.matchRowTile` called in `viewScrollLine` | ✓ WIRED | Line 420: `UI.Style.matchRowTile isActive [...]` |
| `src/Form/Bracket/View.elm` | `UI.Color` | `Color.terminalBorder`, `Color.orange`, `Color.primaryDark` used for tile borders | ✓ WIRED | Lines 163, 172, 399, 402, 417–419, 431, 537, 564 — all three color tokens present |
| `viewRoundSection` | `roundDescription` | Called inline to produce subtitle Element | ✓ WIRED | Line 212: `Element.text (roundDescription round)` |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| FORM-01 | 19-01-PLAN.md | Score input boxes have dark background, orange text, visible border, focus state | ✓ SATISFIED | `scoreInput` updated: `Border.width 1`, `Color.terminalBorder` unfocused, `Color.primaryDark` bg, `Element.focused` with orange border + `activeNav` text |
| FORM-02 | 19-01-PLAN.md | Scroll wheel rows display SVG flags + team names in boxed prototype-style layout | ✓ SATISFIED | `matchRowTile` applied to each row; 24px flags; `width fill`; `spacing 0` |
| FORM-03 | 19-02-PLAN.md | Bracket team tiles are bordered cards with selected (orange border + tinted bg) and hover states | ✓ SATISFIED | Both `viewTeamBadge` and `viewSelectableTeam` produce 80x44 cards with the three states as specified |
| FORM-04 | 19-02-PLAN.md | Bracket round header shows round title, description, and `N/M geselecteerd` counter | ✓ SATISFIED | `viewRoundSection` updated with `roundDescription`, new counter format, and grey 12px subtitle element |

No orphaned requirements — REQUIREMENTS.md traceability table maps FORM-01 through FORM-04 to Phase 19, and both plans claim these four IDs exactly. All four are marked `[x]` (complete) in REQUIREMENTS.md.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `src/Form/GroupMatches.elm` | 543 | `Input.placeholder` | ℹ️ Info | Elm `Input.placeholder` API usage — not a placeholder stub |

No blockers or warnings found. The one hit on `placeholder` is a legitimate `elm-ui` API call.

### Build Status

`make debug` compiles cleanly with `Success!` — confirmed at verification time. All four commits referenced in SUMMARYs exist in git history (083f7c1, 4048d12, 26df3f1, b37e43d).

### Human Verification Required

#### 1. Score Input Focus State

**Test:** Click or tab into a score input field in the group matches form
**Expected:** Border turns orange; text brightens visibly to the warmer `activeNav` shade (`#F0A030`) compared to the resting orange (`#F0DFAF`)
**Why human:** `Element.focused` CSS pseudo-state cannot be exercised by static grep

#### 2. Scroll Wheel Tile Layout

**Test:** Navigate to the group matches card and observe the scroll wheel
**Expected:** Each match row renders as a distinct bordered tile spanning the full container width; active row glows with orange border; inactive rows show a grey border; no gap between tiles (border serves as separator)
**Why human:** Visual tile border rendering and CSS fill-width layout require browser rendering

#### 3. Bracket Tile Hover State

**Test:** On a desktop/computer screen, hover the mouse over a selectable bracket team tile
**Expected:** Border colour transitions from grey to orange; cursor shows pointer
**Why human:** `Element.mouseOver` hover requires real browser interaction

#### 4. Bracket Selected Tile Background Tint

**Test:** Select a team in the bracket wizard on phone layout
**Expected:** The tile shows an orange border and a subtle amber-tinted background (~15% opacity) that distinguishes it from the unselected default dark background without overwhelming the text
**Why human:** The `rgba 0.94 0.87 0.69 0.15` tint requires visual inspection to confirm it is perceptible but not garish

### Summary

All four success criteria from ROADMAP.md are backed by substantive, wired code. The build compiles cleanly. Requirements FORM-01 through FORM-04 are fully implemented with no stubs or missing wiring. Four items require human browser testing to confirm the interactive states (focus, hover, tile layout, rgba tint) that cannot be verified from source inspection alone.

---

_Verified: 2026-03-09T18:00:00Z_
_Verifier: Claude (gsd-verifier)_
