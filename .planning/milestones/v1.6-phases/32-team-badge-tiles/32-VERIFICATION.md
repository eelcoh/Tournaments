---
phase: 32-team-badge-tiles
verified: 2026-03-15T18:45:00Z
status: passed
score: 11/11 must-haves verified
re_verification: false
---

# Phase 32: Team Badge Tiles Verification Report

**Phase Goal:** Update team badge tile layouts in group match scroll wheel, bracket wizard, and topscorer form to match prototype specifications for SVG flag sizes, typography, padding, and home/away orientation.
**Verified:** 2026-03-15T18:45:00Z
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| #  | Truth | Status | Evidence |
|----|-------|--------|----------|
| 1  | Group match scroll wheel rows show SVG flags at 22x16px | VERIFIED | `GroupMatches.elm` line 368-369: `Element.px 16` height, `Element.px 22` width |
| 2  | Home team abbreviation appears to the left of the flag (row-reverse, text then flag); away team abbreviation appears to the right of its flag | VERIFIED | Line 427: `[ mkEl textColor home, flagImg homeTeam ]`; line 431: `[ flagImg awayTeam, mkEl textColor away ]` |
| 3  | Team abbreviation text renders at 11px in monospace | VERIFIED | Line 426: `Font.size 11` on parent row; `mkEl` uses `UI.Font.mono` |
| 4  | Flag and abbreviation are separated correctly with spacing matching prototype | VERIFIED | Inner sub-rows use `spacing 4`, outer row `spacing 4` |
| 5  | Bracket team tiles show a 28x20px SVG flag | VERIFIED | `Bracket/View.elm` lines 397-398, 558-559, 644-645: `Element.px 20` height, `Element.px 28` width in all three functions |
| 6  | Bracket tiles show 11px 500-weight team name and 9px dim 3-letter code below | VERIFIED | Lines 415-416, 570-571, 654-655: `Font.size 11, Font.medium`; lines 422, 577, 661: `Font.size 9` |
| 7  | Bracket tiles use 10px vertical / 12px horizontal padding | VERIFIED | `paddingXY 12 10` present in all three tile states across `viewSelectableTeam`, `viewTeamBadge`, `viewPlacedBadge` |
| 8  | Flag and text column are separated by 8px gap | VERIFIED | Inner rows use `spacing 8` in all bracket tile functions |
| 9  | Placed bracket tiles (viewPlacedBadge) also use 28x20px flag and name+code column | VERIFIED | Lines 644-645 confirm 28x20px; lines 650-664 confirm name (green, 11px medium) + code (grey, 9px) column |
| 10 | Topscorer player tiles show a 24x18px SVG flag, 12px medium player name, and 10px dim team code | VERIFIED | `Topscorer.elm` lines 204-205: `Element.px 18` height, `Element.px 24` width; line 213: `Font.size 12, Font.medium`; line 215: `Font.size 10` |
| 11 | Topscorer flag and text column have 10px spacing | VERIFIED | Line 230: `Element.spacing 10` on the inner row |

**Score:** 11/11 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/Form/GroupMatches.elm` | Updated viewScrollLine with 22x16 flags, 11px font, home/away orientation | VERIFIED | Contains `Element.px 22`, `Font.size 11`, correct child order for both sides |
| `src/Form/Bracket/View.elm` | Updated viewTeamBadge, viewSelectableTeam, viewPlacedBadge with 28x20px flags, name+code column, paddingXY 12 10 | VERIFIED | Contains `Element.px 28`, `Font.size 11`, `Font.medium`, `paddingXY 12 10`, `Element.shrink` in all three functions |
| `src/Form/Topscorer.elm` | Updated viewPlayerCard flagImg and textBlock with correct font sizes | VERIFIED | Contains `Element.px 24` (width), `Element.px 18` (height), `Font.size 12`, `Font.medium`, `Font.size 10`, `spacing 10` |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `GroupMatches.elm viewScrollLine` | flagImg function inside viewScrollLine | `Element.px 22` dimension | WIRED | Flag dimensions confirmed at lines 368-369 |
| `GroupMatches.elm viewScrollLine` | home team display | Child order `[mkEl textColor home, flagImg homeTeam]` | WIRED | Line 427 confirmed — text left, flag right |
| `Bracket/View.elm viewTeamBadge` | flagImg and nameCodeColumn | `Element.px 28` + `paddingXY 12 10` + name/code column | WIRED | Lines 558-624 — all three tile states covered |
| `Bracket/View.elm viewPlacedBadge` | flagImg and name+code column | 28x20px flag + green name + grey code | WIRED | Lines 643-664 confirmed |
| `Topscorer.elm viewPlayerCard` | flagImg and textBlock | `Element.px 24` + font sizes + spacing 10 | WIRED | Lines 202-230 confirmed |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|---------|
| BADGES-01 | 32-01-PLAN.md | Group match team display — 22x16px SVG flag, 11px abbreviation, proper spacing | SATISFIED | `viewScrollLine` in `GroupMatches.elm` — 22x16 flag, Font.size 11 on row, row-reverse home via child order |
| BADGES-02 | 32-02-PLAN.md | Bracket team tile — SVG flag + 11px 500-weight name + 9px dim code, bordered tile | SATISFIED | `viewSelectableTeam`, `viewTeamBadge`, `viewPlacedBadge` all updated — 28x20 flag, 11px medium + 9px column, paddingXY 12 10 |
| BADGES-03 | 32-02-PLAN.md | Topscorer player tile — SVG flag + 12px player name + 10px dim team name | SATISFIED | `viewPlayerCard` — 24x18 flag, Font.size 12 medium + Font.size 10, spacing 10 |

All three requirement IDs declared in PLAN frontmatter are mapped to Phase 32 in REQUIREMENTS.md and marked complete. No orphaned requirements found for this phase.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `GroupMatches.elm` | 540 | `placeholder` | Info | Legitimate Input.placeholder attribute on a search/score input field — not a code stub |
| `Topscorer.elm` | 261 | `placeholder` | Info | Legitimate Html.Attributes.placeholder on a search input — not a code stub |

No blocker or warning anti-patterns found. Both `placeholder` occurrences are valid elm-ui/HTML input placeholder attributes.

### Human Verification Required

#### 1. Visual flag orientation in group match scroll wheel

**Test:** Open the app at `#formulier`, navigate to the group matches scroll wheel. Observe a match row.
**Expected:** Home team abbreviation appears to the LEFT of the flag (text then flag), flag pointing inward toward the score. Away team abbreviation appears to the RIGHT of its flag (flag then text).
**Why human:** elm-ui child order achieves the visual row-reverse effect — automated grep confirms the child order is correct, but visual confirmation of "flag faces score" orientation benefits from a browser check.

#### 2. Bracket tile two-line column readability

**Test:** Open `#formulier`, navigate to the bracket wizard (BracketCard). View team tiles in any selection round.
**Expected:** Each tile shows a flag on the left, then a two-line text block: team abbreviation (11px, slightly brighter) above, same text lowercased (9px, dim grey) below. Padding creates comfortable tap targets.
**Why human:** Font.medium weight rendering and the visual distinction between 11px and 9px text sizes are subjective and depend on browser font rendering.

#### 3. Topscorer player tile spacing

**Test:** Open `#formulier`, navigate to the topscorer card. Observe the player list.
**Expected:** Each row shows a flag (24x18px, landscape ratio), then a two-column text block: player name at 12px medium, team code at 10px dim below it. The `[x]` selected marker still appears for the selected player.
**Why human:** Pixel-level spacing and font weight rendering need visual confirmation. The `[x]` marker correct alignment is a visual check.

### Gaps Summary

No gaps. All automated checks passed at all three levels (exists, substantive, wired). The build compiles clean with `Compiling ... Success!`. All three requirement IDs (BADGES-01, BADGES-02, BADGES-03) are satisfied by concrete implementation in the named files. The REQUIREMENTS.md traceability table already marks all three as complete.

---

_Verified: 2026-03-15T18:45:00Z_
_Verifier: Claude (gsd-verifier)_
