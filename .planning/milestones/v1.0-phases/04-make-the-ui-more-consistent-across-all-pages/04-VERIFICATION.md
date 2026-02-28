---
phase: 04-make-the-ui-more-consistent-across-all-pages
verified: 2026-02-28T16:30:07Z
status: passed
score: 10/10 must-haves verified
re_verification: false
gaps: []
human_verification:
  - test: "Open Results pages (Stand, Uitslagen, Topscorers, Knockouts, Inzendingen) at 1280px desktop viewport"
    expected: "All pages are width-constrained (not full-width); thin terminal border separators visible between sections"
    why_human: "Visual layout verification — cannot confirm pixel-accurate width capping or border rendering programmatically"
  - test: "Click a ranking row and a topscorer row"
    expected: "Row highlights orange on hover; click navigates or triggers state change"
    why_human: "Hover color and click affordance require a live browser to verify"
  - test: "Open Authentication form and focus username/password fields"
    expected: "Both inputs show underline-only border, dark background, orange focused border (terminal style)"
    why_human: "Visual styling of focused state requires browser interaction"
  - test: "Open Home page and click comment input to expand; type in comment and author fields"
    expected: "All expanded inputs show terminal styling (underline border, dark bg); post form inputs match"
    why_human: "Input focus/expand interaction and visual style require a live browser"
---

# Phase 4: Make the UI More Consistent Across All Pages — Verification Report

**Phase Goal:** All pages (Home, Form, Results) share a consistent visual language: uniform width constraints via UI.Page.container, terminal aesthetic inputs on all forms, UI.Button for all interactive data rows, and a 3-tier spacing rhythm (24/16/8px)
**Verified:** 2026-02-28T16:30:07Z
**Status:** passed
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | `UI.Page.container` exists and accepts `Screen.Size`, returns width-constrained column | VERIFIED | `src/UI/Page.elm` lines 15-26: function present, exported, uses `UI.Screen.maxWidth screen` |
| 2 | `UI.Button.dataRow` exists and routes clicks through the button component system | VERIFIED | `src/UI/Button.elm` lines 78-88: function present, exported, uses `Style.button semantics` |
| 3 | All 5 Results pages are wrapped with `UI.Page.container model.screen` | VERIFIED | Matches:109, Bets:86, Knockouts:183, Ranking:68, Topscorers:148 — all confirmed |
| 4 | All `Input.text` / `Input.multiline` in Activities.elm use `UI.Style.terminalInput` | VERIFIED | 8 occurrences in Activities.elm (lines 171, 191, 212, 259, 271, 282, 293, 304) |
| 5 | Both inputs in Authentication.elm use `UI.Style.terminalInput` | VERIFIED | lines 38 and 49 — both confirmed with height 48px |
| 6 | Ranking rows use `UI.Button.dataRow` instead of raw `Element.el` with onClick | VERIFIED | `Results/Ranking.elm:158`: `UI.Button.dataRow UI.Style.Potential (ViewRankingDetails line.uuid)` — no `Events.onClick` import remains |
| 7 | Topscorer rows use `UI.Button.dataRow` instead of raw `Element.row` with onClick | VERIFIED | `Results/Topscorers.elm:205`: `UI.Button.dataRow semantics msg` — `Element.Events` import removed |
| 8 | `terminalBorder` section separators appear between sections on all 5 Results pages | VERIFIED | `Border.color UI.Color.terminalBorder` found in Ranking:133, Topscorers:163, Knockouts:198, Bets:91, Matches:114 |
| 9 | Spacing on Results pages follows the 3-tier rhythm (24/16/8px) for sections and items | VERIFIED | Matches: `spacing 24` (sections); Knockouts/Topscorers/Ranking: `spacing 16` (items); per-team/topscorer padding `paddingXY 0 8` (tight) |
| 10 | Form pages are width-constrained without regression (CON-01 via viewCardChrome) | VERIFIED | `Form/View.elm:288-291`: `viewCardChrome` applies `fill |> Element.maximum (Screen.maxWidth model.screen)` to all card content |

**Score:** 10/10 truths verified

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/UI/Page.elm` | `container : UI.Screen.Size -> String -> List (Element msg) -> Element msg` alongside existing `page` | VERIFIED | Module exposes `(container, page)`; `container` uses `UI.Screen.maxWidth`; `page` unchanged at line 8 |
| `src/UI/Button.elm` | `dataRow : ButtonSemantics -> msg -> List (Element msg) -> Element msg` | VERIFIED | Exported at line 4; defined at lines 78-88; uses `Style.button semantics` |
| `src/Activities.elm` | All `Input.text`/`Input.multiline` calls use `UI.Style.terminalInput` | VERIFIED | 8 `terminalInput` occurrences covering viewCommentInput (3) and viewPostInput (5) |
| `src/Authentication.elm` | Username and password inputs use `UI.Style.terminalInput` with height 48px | VERIFIED | Lines 38 and 49 confirmed; heights set to `px 48` |
| `src/Results/Matches.elm` | `UI.Page.container` at top-level view + `terminalBorder` separator | VERIFIED | `UI.Page.container model.screen "matches"` at line 109; `Border.color UI.Color.terminalBorder` at line 114 |
| `src/Results/Knockouts.elm` | `UI.Page.container` at top-level view + `terminalBorder` separators | VERIFIED | `UI.Page.container model.screen "knockouts"` at line 183; separator at line 198 |
| `src/Results/Topscorers.elm` | `UI.Page.container` + `UI.Button.dataRow` + `terminalBorder` separators | VERIFIED | container:148, dataRow:205, terminalBorder:163 |
| `src/Results/Ranking.elm` | `UI.Page.container` + `UI.Button.dataRow` + `terminalBorder` separators | VERIFIED | container:68, dataRow:158, terminalBorder:133 |
| `src/Results/Bets.elm` | `UI.Page.container` + `terminalBorder` header separator | VERIFIED | container:86, terminalBorder:91 |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/UI/Page.elm` | `src/UI/Screen.elm` | `Screen.maxWidth` call inside `container` | WIRED | Line 23: `Element.fill \|> Element.maximum (UI.Screen.maxWidth screen)` |
| `src/UI/Button.elm` | `src/UI/Style.elm` | `Style.button semantics` call in `dataRow` | WIRED | Line 81: `Style.button semantics [...]` |
| `src/Results/Ranking.elm` | `src/UI/Button.elm` | `UI.Button.dataRow` in `viewRankingLine` | WIRED | Line 158: `UI.Button.dataRow UI.Style.Potential (ViewRankingDetails line.uuid)` |
| `src/Results/Topscorers.elm` | `src/UI/Button.elm` | `UI.Button.dataRow` in `viewTopscorer` | WIRED | Line 205: `UI.Button.dataRow semantics msg` |
| `src/Results/Matches.elm` | `src/UI/Page.elm` | `UI.Page.container model.screen` | WIRED | Line 109: `UI.Page.container model.screen "matches"` |
| `src/Results/Ranking.elm` | `src/UI/Color.elm` | `Border.color Color.terminalBorder` | WIRED | Line 133: `Border.color UI.Color.terminalBorder` |
| `src/Activities.elm` | `src/UI/Style.elm` | `UI.Style.terminalInput` call | WIRED | 8 calls confirmed across viewCommentInput and viewPostInput |
| `src/Authentication.elm` | `src/UI/Style.elm` | `UI.Style.terminalInput` call | WIRED | Lines 38 and 49 confirmed |

---

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| CON-01 | 04-01, 04-04 | All pages use `Screen.maxWidth model.screen` for top-level content width — via `UI.Page.container` on Results/Home, via `viewCardChrome` on Form cards | SATISFIED | Results pages: `UI.Page.container` in all 5; Form pages: `viewCardChrome` at `fill \|> maximum (Screen.maxWidth)` confirmed |
| CON-02 | 04-03 | All 5 Results pages wrapped with `UI.Page.container model.screen` as outermost element | SATISFIED | Confirmed in Matches:109, Bets:86, Knockouts:183, Ranking:68, Topscorers:148 |
| CON-03 | 04-02 | All `Input.text` and `Input.multiline` in Activities.elm and Authentication.elm use `UI.Style.terminalInput` | SATISFIED | 8 calls in Activities.elm, 2 in Authentication.elm — all confirmed |
| CON-04 | 04-01, 04-03 | Clickable data rows in Results pages use `UI.Button.dataRow` instead of raw `Element.el`/`Element.row` with inline `onClick` | SATISFIED | `viewRankingLine` (Ranking:158) and `viewTopscorer` (Topscorers:205) both use `UI.Button.dataRow`; no `Events.onClick` or `Element.pointer` remains in either file |
| CON-05 | 04-03 | Vertical spacing follows 3-tier rhythm: 24px sections, 16px items, 8px tight | SATISFIED | Matches uses `spacing 24`; Knockouts/Topscorers/Ranking use `spacing 16` for item lists; per-item padding uses `paddingXY 0 8` (tight rhythm). Two non-rhythm values remain: `spacing 20` in `viewRankingGroups` inner column and `spacing 20` in Knockouts `viewRoundButtons` column — these are inner sub-components not section/item boundaries; acceptable per plan's "inner card dimension" allowance |

---

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `src/Results/Ranking.elm` | 104 | `spacingXY 0 20` in `viewRankingGroups` inner column | Info | Not a regression — this is the inner column wrapping intro + rank groups + date; not a section/item boundary in the 3-tier sense; the outer per-group separator uses the correct `paddingXY 0 8` at the `viewRankingGroup` level |
| `src/Results/Knockouts.elm` | 256 | `spacing 20` in `viewRoundButtons` | Info | Per-column button stack within a single team row — an innermost sub-component, not a Results section or item boundary; consistent with the plan's intent |

No blockers or warnings found. Both flagged items are informational only — they are inner component spacings, not section or item boundaries targeted by CON-05.

---

### Human Verification Required

The following items require a live browser for confirmation. Automated checks all pass; these are confirmations of visual and interactive behavior only.

#### 1. Results Pages Width Constraint at Desktop

**Test:** Open the app at 1280px viewport width. Navigate to Stand (#stand), Uitslagen (#uitslagen), Topscorers, Knockouts, and Inzendingen.
**Expected:** All pages show content at ~80% of viewport width, horizontally centered, not stretched to full 1280px. Thin terminal border lines visible between section groups.
**Why human:** Width-capping and border rendering require a rendered browser viewport to verify.

#### 2. Ranking and Topscorer Row Interactivity

**Test:** Hover over a ranking row name and a topscorer row.
**Expected:** Row highlights in orange (Potential semantics); click navigates to the detail view or toggles state.
**Why human:** Hover color and click affordance require a live browser with mouse interaction.

#### 3. Authentication Form Terminal Styling

**Test:** Click the login link to show the authentication form. Focus both the username and password fields.
**Expected:** Both inputs show underline-only bottom border, dark background, orange focused border — matching the terminal aesthetic.
**Why human:** Focus state visual styling requires browser interaction.

#### 4. Home Page Comment/Post Input Terminal Styling

**Test:** Navigate to Home (#home). Click the comment input to expand it. Check both message and author fields. Expand the post input form and check all its inputs.
**Expected:** All inputs show terminal styling (underline border, dark background). The expanded state works correctly.
**Why human:** Input expand interaction and focus-state visual appearance require a live browser.

---

### Summary

Phase 4 goal is achieved. All automated checks pass at every level (existence, substantive implementation, wiring):

- `UI.Page.container` and `UI.Button.dataRow` are correctly implemented and exported as foundational helpers.
- All 5 Results pages (`Matches`, `Knockouts`, `Topscorers`, `Ranking`, `Bets`) have their top-level view wrapped with `UI.Page.container model.screen`, gaining consistent max-width capping via `UI.Screen.maxWidth`.
- All 5 Results pages have `terminalBorder` section separators (`Border.widthEach { bottom=1, ... }` + `Border.color UI.Color.terminalBorder`).
- `viewRankingLine` and `viewTopscorer` both use `UI.Button.dataRow` — no raw `Events.onClick` or `Element.pointer` patterns remain in either Results file.
- All `Input.text`/`Input.multiline` calls in Activities.elm (8 total, covering both viewCommentInput and viewPostInput) and Authentication.elm (2 total) use `UI.Style.terminalInput`.
- Form pages satisfy CON-01 through `viewCardChrome` in `Form/View.elm` which applies `fill |> Element.maximum (Screen.maxWidth model.screen)` as the outer width constraint.
- Spacing values follow the 3-tier rhythm: 24px section-gap in `displayMatches`, 16px item-gap in ranking/topscorer/knockout item lists, 8px tight in per-item padding wrappers.
- All 5 requirements (CON-01 through CON-05) are satisfied.
- All commits confirmed in git log (b6db886, b146468, 00a0e16, cdf00ba, 0bcfc28, 7311aca).

4 human verification items remain, all visual/interactive — none are blockers to phase completion.

---

_Verified: 2026-02-28T16:30:07Z_
_Verifier: Claude (gsd-verifier)_
