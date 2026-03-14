---
phase: 15-group-matches-reduction
verified: 2026-03-08T17:00:00Z
status: human_needed
score: 3/4 must-haves verified
human_verification:
  - test: "Scroll wheel shows exactly 36 matches (3 per group across 12 groups)"
    expected: "Navigating from Group A through Group L shows 3 match entries per group, 36 total; no extra matches appear"
    why_human: "The data layer filter is verified correct in code, but the scroll wheel rendering depends on runtime iteration of bet.answers.matches — only a browser run confirms the exact count displayed to the user"
  - test: "Group completion triggers after filling 3 matches, not 6"
    expected: "After entering scores for 3 Group A matches, the Group A nav letter turns green/complete"
    why_human: "isCompleteGroup delegates to isComplete which iterates answers.matches — the logic is correct in code, but the threshold (3 vs 6) can only be confirmed by filling matches in the running app"
---

# Phase 15: Group Matches Reduction Verification Report

**Phase Goal:** Activate the 36-match group stage in the WC2026 betting form — users can fill in 36 matches (3 per group x 12 groups) instead of 72, with correct group completion tracking.
**Verified:** 2026-03-08
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | The scroll wheel shows exactly 36 matches (3 per group across 12 groups) | ? HUMAN | `selectedMatches` has 36 IDs; scroll wheel reads from `bet.answers.matches` which is built from `Tournament.matches` filtered by `selectedMatches`; count is correct in code but browser run required to confirm rendered output |
| 2 | Group completion triggers after filling 3 matches, not 6 | ? HUMAN | `isCompleteGroup` delegates to `isComplete` which calls `List.all GroupMatch.isComplete` over `findGroupMatchAnswers grp matches`; with 3 matches per group in `answers.matches` this triggers at 3/3 — logic is structurally correct but runtime confirmation needed |
| 3 | The dashboard description reads "36 wedstrijden in 12 groepen" | VERIFIED | `src/Form/Dashboard.elm` line 245 contains exactly `"36 wedstrijden in 12 groepen"`; old string `"48 wedstrijden"` not found anywhere in `src/` |
| 4 | The build compiles without errors | VERIFIED | `make build` ran successfully, producing `build/main.js` without errors |

**Score:** 2/4 automated (2 require human confirmation); all automated checks pass

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/Form/Dashboard.elm` | "36 wedstrijden in 12 groepen" string | VERIFIED | Line 245 contains exact string; commit `6120508` changed "48" to "36"; no other occurrences of "48 wedstrijden" in src/ |
| `src/Bets/Init/WorldCup2026/Tournament.elm` | `selectedMatches` list with 36 IDs | VERIFIED | `selectedMatches : List String` defined at line 288; contains exactly 36 match IDs (3 per group, groups A-L); `matches` function filters `allMatches` via `List.filter (selectMatch onMatchId)` |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/Bets/Init/WorldCup2026/Tournament.elm` | `answers.matches` | `Bets.Init` uses `Tournament.matches` | WIRED | `Bets.Init.elm` line 32: `List.map mkMatchAnswer Tournament.matches`; `Tournament.matches` applies the `selectedMatches` filter |
| `answers.matches` | scroll wheel List MatchID | `groupsAndFirstMatch` + `bet.answers.matches` | WIRED | `groupsAndFirstMatch` at `Bets.Init.elm` line 66 uses `Init.groupFirstMatches [] answers.matches`; scroll wheel `viewScrollWheel` reads `bet.answers.matches` directly at line 290; `isComplete` iterates `bet.answers.matches` |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| GROUPS-01 | 15-01-PLAN.md | Only 1 match per matchday is shown per group (3 x 12 = 36 total) | SATISFIED | `selectedMatches` contains exactly 36 IDs, 3 per group; `Tournament.matches` filters `allMatches` to this set; `answers.matches` is built from `Tournament.matches` |
| GROUPS-02 | 15-01-PLAN.md | The scroll wheel and keyboard-first score input are preserved unchanged | SATISFIED (code) / HUMAN (UX) | No changes made to `Form/GroupMatches.elm`; scroll wheel reads `bet.answers.matches`; keyboard input logic unchanged; visual confirmation requires browser run |
| GROUPS-03 | 15-01-PLAN.md | Group completion tracking reflects the reduced match set (3 per group = done) | SATISFIED (code) / HUMAN (UX) | `isComplete`/`isCompleteGroup` in `Bets.Types.Answer.GroupMatches` iterate over whatever is in `answers.matches`; with 36 matches (3 per group), a group completes when 3/3 are filled; no hardcoded threshold |

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| — | — | None found | — | — |

No TODO/FIXME comments, empty implementations, or stub patterns detected in the modified file (`src/Form/Dashboard.elm`).

### Human Verification Required

#### 1. Scroll wheel shows 36 matches

**Test:** Run `make build && python3 -m http.server --directory build`, open `http://localhost:8000/#formulier`, navigate to the Groepsfase card, scroll through all groups A-L counting match entries.
**Expected:** Exactly 3 match entries per group, 36 total across all groups; no group has 4, 5, or 6 entries.
**Why human:** The data filter is verified correct in static analysis. The scroll wheel reads `bet.answers.matches` at runtime. Only a browser run confirms the rendered match count.

#### 2. Group completion at 3/3 filled matches

**Test:** In the running app, enter scores for all 3 Group A matches. Observe the Group A navigation letter.
**Expected:** After the 3rd Group A match is filled, the Group A indicator shows as complete (colored/checked). The "Ga verder" button or progress indicator reflects completion.
**Why human:** `isCompleteGroup` logic is structurally correct in code (no hardcoded threshold; uses list length implicitly). Only runtime use confirms it fires at 3, not at some stale cached state.

### Gaps Summary

No gaps found in automated verification. The two human verification items are confirmations of correct code behavior, not suspected defects. The structural evidence is strong:

- `selectedMatches` has exactly 36 entries (verified by code count)
- `Tournament.matches` applies the filter correctly (verified by reading the function)
- `answers.matches` is built from `Tournament.matches` (verified in `Bets.Init.elm`)
- `isComplete` iterates whatever is in `answers.matches` with no hardcoded threshold
- Dashboard text updated correctly in the only location it appeared
- Build passes clean

Human verification is flagged as a precaution for the UX-observable behaviors (scroll wheel count, completion trigger), not because code analysis indicates a defect.

---

_Verified: 2026-03-08_
_Verifier: Claude (gsd-verifier)_
