---
phase: 13-more-ux-polish
verified: 2026-03-07T20:30:00Z
status: passed
score: 7/7 must-haves verified
re_verification: false
human_verification:
  - test: "Navigate to #home in browser, observe input field backgrounds"
    expected: "Comment and author input fields are visually distinct from the page body — slightly darker (#353535 vs #3F3F3F)"
    why_human: "Color contrast between #353535 and #3F3F3F is subtle; requires visual inspection to confirm discoverability"
  - test: "Open #home while activities are loading, observe loading indicator"
    expected: "Loading state shows `[ ophalen... ]` in terminal bracket notation, not `Aan het ophalen...`"
    why_human: "Timing-dependent — only visible during the brief network fetch window"
  - test: "View bracket or group match with an empty TBD slot, then attempt to view an unknown team ID"
    expected: "TBD slot shows `···` on darker grey square; unknown team shows `?` on lighter grey square — visually distinguishable"
    why_human: "SVG rendering at small sizes (15x15, 30x30) requires browser inspection"
---

# Phase 13: More UX Polish Verification Report

**Phase Goal:** Fix the most noticeable remaining UX rough edges: loading state copy matches terminal aesthetic, input fields are visually discoverable, home page comment inputs use `>` prompt style, and placeholder SVGs distinguish unknown teams from TBD bracket slots.
**Verified:** 2026-03-07T20:30:00Z
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| #   | Truth                                                                                               | Status     | Evidence                                                                                            |
| --- | --------------------------------------------------------------------------------------------------- | ---------- | --------------------------------------------------------------------------------------------------- |
| 1   | Activities loading/not-asked state shows `[ ophalen... ]`                                           | VERIFIED   | `src/Activities.elm` lines 69, 72 — both NotAsked and Loading branches return `Element.text "[ ophalen... ]"` |
| 2   | Activities success with empty list shows nothing                                                    | VERIFIED   | `src/Activities.elm` lines 78-79 — `if List.isEmpty activities then Element.none`                   |
| 3   | Comment and author inputs have no visible label above them                                          | VERIFIED   | `src/Activities.elm` lines 168, 187, 209 — all three inputs use `Input.labelHidden`; no `labelAbove` call present in `viewCommentInput` |
| 4   | All terminalInput fields have `#353535` background (Color.primaryDark)                             | VERIFIED   | `src/UI/Style.elm` line 641 — `Background.color Color.primaryDark`                                 |
| 5   | Unknown team IDs show `404-not-found.svg` placeholder                                              | VERIFIED   | `src/Bets/Types/Team.elm` line 294 — `_ ->` branch returns `"assets/svg/404-not-found.svg"`        |
| 6   | Nothing team shows `999-to-be-decided.svg`                                                         | VERIFIED   | `src/Bets/Types/Team.elm` lines 300-301 — `Nothing ->` branch returns `"assets/svg/999-to-be-decided.svg"` directly |
| 7   | Both placeholder SVGs exist with square viewBox and are substantive files                           | VERIFIED   | `assets/svg/404-not-found.svg` — viewBox="0 0 100 100", `?` symbol, `#5A5A5A` bg; `assets/svg/999-to-be-decided.svg` — viewBox="0 0 100 100", `···` symbol, `#4A4A4A` bg |

**Score:** 7/7 truths verified

### Required Artifacts

| Artifact                          | Expected                                             | Status     | Details                                                               |
| --------------------------------- | ---------------------------------------------------- | ---------- | --------------------------------------------------------------------- |
| `src/Activities.elm`              | Loading copy, empty guard, hidden labels             | VERIFIED   | All three changes present and substantive                             |
| `src/UI/Style.elm`                | terminalInput background = Color.primaryDark         | VERIFIED   | Line 641 confirmed `Background.color Color.primaryDark`              |
| `assets/svg/404-not-found.svg`    | Grey square with `?` for unknown teamIDs             | VERIFIED   | 5-line inline SVG, viewBox 0 0 100 100, `#5A5A5A` fill, `?` text    |
| `assets/svg/999-to-be-decided.svg`| Darker grey square with `···` for TBD slots         | VERIFIED   | 5-line inline SVG, viewBox 0 0 100 100, `#4A4A4A` fill, `···` text  |
| `src/Bets/Types/Team.elm`         | Correct routing: Nothing->999, unknown->404-not-found| VERIFIED   | `flagUrl` Nothing branch direct return; `flagUrlRound` default updated|

### Key Link Verification

| From                                        | To                          | Via                      | Status     | Details                                                      |
| ------------------------------------------- | --------------------------- | ------------------------ | ---------- | ------------------------------------------------------------ |
| `src/Activities.elm viewActivities`         | NotAsked/Loading branches   | `Element.text`           | WIRED      | Pattern `ophalen` confirmed at lines 69 and 72               |
| `src/UI/Style.elm terminalInput`            | Background.color            | `Color.primaryDark`      | WIRED      | Line 641 — `Background.color Color.primaryDark`             |
| `src/Bets/Types/Team.elm flagUrl`           | `999-to-be-decided.svg`     | Nothing branch string    | WIRED      | Line 301 — direct string return, no delegation               |
| `src/Bets/Types/Team.elm flagUrlRound`      | `404-not-found.svg`         | `_` default branch       | WIRED      | Line 294 — old `"assets/svg/404.svg"` reference gone         |

### Requirements Coverage

| Requirement  | Source Plan   | Description                                                    | Status        | Evidence                                                                   |
| ------------ | ------------- | -------------------------------------------------------------- | ------------- | -------------------------------------------------------------------------- |
| UX-POLISH-01 | 13-01-PLAN.md | Activities loading/not-asked uses terminal bracket notation    | SATISFIED     | Lines 69, 72 of Activities.elm                                             |
| UX-POLISH-02 | 13-01-PLAN.md | Home page inputs use `>` prompt with no above-field label      | SATISFIED     | `Input.labelHidden` at lines 168, 187, 209 of Activities.elm               |
| UX-POLISH-03 | 13-01-PLAN.md | terminalInput fields have #353535 background                   | SATISFIED     | `Background.color Color.primaryDark` at line 641 of UI/Style.elm           |
| UX-POLISH-04 | 13-02-PLAN.md | Placeholder SVGs distinguish unknown teams from TBD slots      | SATISFIED     | Both SVGs exist; routing confirmed in Team.elm lines 294, 301              |

**Note on REQUIREMENTS.md:** UX-POLISH-01 through UX-POLISH-04 are phase-internal requirement IDs defined in the ROADMAP.md for Phase 13. They do not appear in `.planning/REQUIREMENTS.md` which tracks v1.2 requirements (COL-xx, NAV-xx, WIDTH-xx). This is expected — UX-POLISH IDs are supplemental polish items scoped to Phase 13 and tracked only in ROADMAP. No orphaned requirements found.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
| ---- | ---- | ------- | -------- | ------ |

No anti-patterns found. No TODO/FIXME/placeholder comments, no stub implementations, no empty returns in changed code.

**Additional check:** Old `"assets/svg/404.svg"` reference is absent from `src/Bets/Types/Team.elm` — the catch-all default now correctly points to `404-not-found.svg`.

**Build status:** `make build` exits 0 — `Compiling... Success!` confirmed.

### Human Verification Required

### 1. Input Field Background Contrast

**Test:** Navigate to `#home` in a browser. Look at the comment input field (trap state) against the dark page body.
**Expected:** The input field background (#353535) is visibly lighter than the surrounding page body (#3F3F3F), making it discoverable as an interactive element.
**Why human:** The color difference is subtle (6 RGB units per channel). Programmatic verification can confirm the color value is set, but only visual inspection confirms discoverability for actual users.

### 2. Activities Loading State Timing

**Test:** Navigate to `#home` with a throttled connection (Chrome DevTools -> Slow 3G). Observe the activities area during fetch.
**Expected:** The area shows `[ ophalen... ]` in monospace terminal style instead of the old `Aan het ophalen...` copy.
**Why human:** Network-timing dependent state; not testable via static code analysis.

### 3. Placeholder SVG Rendering at Small Sizes

**Test:** View the bracket page — find an empty TBD slot and a team badge for a known team. If the codebase has any rendering path that hits an unknown teamID, compare the two placeholders.
**Expected:** TBD slot shows `···` on a medium grey square (#4A4A4A); unknown team shows `?` on a lighter grey square (#5A5A5A). Both readable at badge sizes (15x15 to 40x40 px).
**Why human:** SVG text rendering at very small sizes varies by browser/OS font rendering. The `···` character (U+00B7 middle dot x3) may not render at 15x15 without browser inspection.

### Gaps Summary

No gaps. All seven must-haves verified against the actual codebase. The build passes cleanly. All four requirement IDs are satisfied by substantive, wired implementations. Three visual/timing items are flagged for optional human confirmation but none block goal achievement.

---

_Verified: 2026-03-07T20:30:00Z_
_Verifier: Claude (gsd-verifier)_
