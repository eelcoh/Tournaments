---
phase: 08-form-mobile-polish
verified: 2026-03-01T09:30:00Z
status: human_needed
score: 10/10 must-haves verified
re_verification: false
human_verification:
  - test: "Open #formulier on a 375px phone screen (Chrome DevTools mobile emulation). Navigate between all 6 cards."
    expected: "Fixed 48px dark bar visible at bottom on all cards. At card 1, '< vorige' is grey and non-responsive. At card 6, 'volgende >' is grey and non-responsive. Middle cards show both in orange. Tapping orange buttons briefly flashes white before card changes."
    why_human: "mouseOver :hover as tap flash feedback and actual touch responsiveness on mobile cannot be verified programmatically."
  - test: "Fill in all 48 group matches. Observe nav bar center while filling."
    expected: "Center shows 'stap 2/6 · 48 wedstrijden open' initially, updating down to 'stap 2/6 [x]' when all 48 are complete."
    why_human: "Dynamic open-count update requires interactive form input to verify the live count changes correctly."
  - test: "Navigate between cards. Verify scroll behavior."
    expected: "Every card change scrolls the viewport to the top, regardless of how far down you had scrolled."
    why_human: "Browser.Dom.setViewport behavior depends on actual browser DOM scroll state."
  - test: "When an iOS or Android install banner is showing, navigate the form."
    expected: "Nav bar (vorige/volgende) sits above the install banner — the banner never covers the nav buttons."
    why_human: "Stacking order in inFront overlay and real device rendering cannot be confirmed from code alone."
  - test: "Trigger or simulate a bet submission in-flight (Loading state) on the submit card."
    expected: "Submit button shows 'verzenden...' text and is non-interactive while in-flight."
    why_human: "Loading state requires an actual HTTP call to be in-flight to observe."
---

# Phase 8: Form Mobile Polish — Verification Report

**Phase Goal:** The bet form feels smooth and clear to fill in on a phone — navigation works reliably, incomplete state is obvious, and actions feel acknowledged.
**Verified:** 2026-03-01T09:30:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | A fixed 48px nav bar is always visible at the bottom of the screen while filling in the form | VERIFIED | `viewFormNavBar` in `src/View.elm` lines 332–422: renders `Element.row` with `Element.height (Element.px 48)`, `Background.color Color.black`, gated by `case model.app of Form -> ... _ -> Element.none` |
| 2 | Vorige and volgende buttons are clearly tappable on a 375px phone screen | VERIFIED | Both active and disabled button variants set `Element.height (Element.px 48)`. Active buttons additionally have `Element.pointer`. 48px height matches Phase 2 touch target convention. |
| 3 | At card 1, vorige is greyed out (not hidden); at last card, volgende is greyed out | VERIFIED | `isFirst = model.idx == 0` and `isLast = model.idx == List.length model.cards - 1` select `prevButton`/`nextButton` (grey, NoOp) vs orange NavigateTo elements. Neither is hidden — both render in all positions. |
| 4 | The nav bar center shows stap N/M and the incomplete count for the current card | VERIFIED | `cardCenterInfo` in `src/View.elm` lines 261–329 computes per-card type: GroupMatchesCard shows `· N wedstrijden open`, BracketCard shows `· N ronden open`, TopscorerCard and ParticipantCard show `· 1 open` / `· gegevens open` |
| 5 | When a card is complete, no open-count is shown in the nav center | VERIFIED | `cardCenterInfo` returns `stepStr ++ " [x]"` for all card types when their completion condition is met (openCount == 0, openRounds == 0, isComplete functions return True) |
| 6 | Navigating between cards always scrolls the viewport to the top | VERIFIED | `NavigateTo page` branch in `src/Main.elm` lines 105–108: `Task.attempt (\_ -> ScrollToTop) (Browser.Dom.setViewport 0 0)`. `ScrollToTop` Msg defined in `src/Types.elm` line 258. |
| 7 | The nav bar sits above the install banner when the banner is visible | VERIFIED | `src/View.elm` lines 189–196: `inFront` column order is `[viewFormNavBar model, viewInstallBanner model, viewStatusBar model]`. In an `alignBottom` column, the last child anchors at the bottom — so statusBar is lowest, banner above it, nav bar is highest (closest to page content, not covered by banner). |
| 8 | Tapping vorige or volgende shows a brief color response confirming the tap registered | VERIFIED (code) / NEEDS HUMAN (device) | Active vorige/volgende buttons in `src/View.elm` lines 394 and 416: `Element.mouseOver [Font.color Color.white]`. Disabled buttons do not have mouseOver. |
| 9 | The submit button shows 'verzenden...' text and is non-interactive while in-flight | VERIFIED | `src/Form/Submit.elm` line 33: `( _, Loading, _ ) -> ( introSubmitting, submit Inactive NoOp "verzenden..." )` |
| 10 | Nav buttons are visually distinct between active (orange) and disabled (grey) states | VERIFIED | Active buttons: `Font.color Color.orange` + `Element.mouseOver [Font.color Color.white]`. Disabled buttons: `Font.color Color.grey` (via `navButton` helper). |

**Score:** 10/10 truths verified (automated evidence), 5 require human testing for confirmation of runtime behavior

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/View.elm` | `viewFormNavBar`: fixed bottom nav bar rendered only when `model.app == Form` | VERIFIED | Function exists at line 332. Contains `viewFormNavBar` (line 332), `cardCenterInfo` (line 261). Wired into `inFront` column at line 192. |
| `src/Main.elm` | `ScrollToTop` Msg + `Browser.Dom.setViewport 0 0` on `NavigateTo` | VERIFIED | `Browser.Dom` imported at line 8. `NavigateTo` fires `Task.attempt` at line 107. `ScrollToTop` handler (no-op) at lines 110–111. |
| `src/Types.elm` | `ScrollToTop` Msg variant in union type | VERIFIED | Line 258: `\| ScrollToTop` in `Msg` union type. Included in `exposing` list. |
| `src/Form/View.elm` | Old nav pills removed; 64px bottom padding added | VERIFIED | `viewCardChrome` at line 259: no `prevPill`/`nextPill`/`nav` row. `columnAttrs` at line 275: `Element.paddingEach { top = 0, right = 0, bottom = 64, left = 0 }`. |
| `src/Form/Submit.elm` | Submit button shows 'verzenden...' text when Loading state | VERIFIED | Line 33: `submit Inactive NoOp "verzenden..."` in the `( _, Loading, _ )` branch. |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/View.elm` | `src/Main.elm` | `NavigateTo` msg triggers `ScrollToTop` cmd | VERIFIED | `NavigateTo page` in Main.elm update (line 105) fires `Task.attempt (\_ -> ScrollToTop) (Browser.Dom.setViewport 0 0)`. `ScrollToTop` handled at line 110. |
| `src/View.elm` (inFront column) | `viewFormNavBar`, `viewInstallBanner`, `viewStatusBar` | `Element.column [alignBottom]` in `Element.layout inFront` | VERIFIED | `src/View.elm` lines 189–197: all three functions composed in a single column, wired into `UI.Style.body` overlay. |
| `src/Form/Submit.elm` | `model.savedBet` Loading branch | `case (submittable, model.savedBet, model.betState) of` | VERIFIED | Pattern `( _, Loading, _ )` at line 32 yields `submit Inactive NoOp "verzenden..."` |
| `src/View.elm` (viewFormNavBar) | nav button element | `Element.mouseOver [Font.color Color.white]` | VERIFIED | Lines 394 and 416 in View.elm add `Element.mouseOver [ Font.color Color.white ]` to the active (non-greyed) vorige and volgende elements only. |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| FORM-01 | 08-01 | Mobile bet form navigation (vorige/volgende) is clear and works reliably on phone screens | SATISFIED | 48px fixed nav bar, boundary-aware disabled states, 48px touch targets, `ScrollToTop` on `NavigateTo` |
| FORM-02 | 08-01 | Incomplete or invalid card state is visually obvious — user knows what still needs filling in | SATISFIED | `cardCenterInfo` computes and displays per-card open count in nav bar center; top checkboxes (`viewTopCheckboxes`) retained for bird's-eye view |
| FORM-03 | 08-02 | Actions and transitions in the form feel acknowledged — no jarring jumps or silent failures on mobile | SATISFIED (code) / NEEDS HUMAN (device feel) | `mouseOver` white flash on nav tap; `"verzenden..."` in-flight label; `ScrollToTop` prevents abrupt viewport position; disabled buttons fire `NoOp` not hidden |

No orphaned requirements — all three FORM-0x IDs are accounted for across the two plans and confirmed complete in REQUIREMENTS.md.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `src/View.elm` | 352 | Disabled `navButton` helper has `Element.pointer` | Info | Cursor appears as pointer even over greyed-out boundary buttons. Fires `NoOp` so no functional issue, but cursor feedback is slightly misleading. Not a goal blocker. |
| `src/Bets/Init/Euro2024/Tournament.elm` | 200 | Commented-out `Debug.todo "TODO"` | Info | In a commented line (`--`), not compiled. No impact on Phase 8 deliverables. |

### Human Verification Required

#### 1. Fixed nav bar rendering on phone

**Test:** Open `http://localhost:8000/#formulier` in Chrome DevTools at 375px width (phone emulation). Step through all 6 cards.
**Expected:** Dark 48px bar pinned to viewport bottom on every card. "< vorige" grey on card 1, "volgende >" grey on card 6, both orange on middle cards. Tapping an orange button briefly flashes white before card content changes.
**Why human:** `mouseOver` :hover-as-tap-flash behavior and actual touch responsiveness require live browser/device rendering to confirm.

#### 2. Scroll-to-top on card navigation

**Test:** Scroll down on a card (e.g. group matches), then tap vorige or volgende.
**Expected:** Viewport immediately scrolls to top — new card content starts at the top of the screen.
**Why human:** `Browser.Dom.setViewport 0 0` is a Task; its runtime behavior (scroll happening before render, no flash) requires a real browser.

#### 3. Live incomplete count in nav center

**Test:** Start filling in group matches. Observe the nav bar center text after each match entry.
**Expected:** Count decrements from 48 downward as matches are filled. When all 48 complete, center shows "stap 2/6 [x]".
**Why human:** Dynamic open-count update depends on reactive rendering of `cardCenterInfo` as `model.bet` changes.

#### 4. Install banner clearance

**Test:** On an iOS device (or iOS emulation), trigger the install banner so it shows. Then use vorige/volgende in the form.
**Expected:** Nav bar buttons remain above the install banner and are fully tappable — banner does not overlap the nav buttons.
**Why human:** Stacking order in real device viewport with soft keyboard, safe area insets, and banner height requires physical device or accurate emulation.

#### 5. Submit in-flight feedback

**Test:** Complete the full form and submit. Observe the submit card button during the HTTP request.
**Expected:** Button text changes to "verzenden..." and is non-interactive. On success or error it returns to a final state.
**Why human:** Loading state requires an in-flight HTTP call to the backend; cannot be observed from static code analysis.

### Gaps Summary

No functional gaps found. All 10 must-haves have code-level evidence of implementation. The build compiles cleanly (`make debug` exits 0, all three commits `b1cae41`, `df7d2a9`, `bc828ee` confirmed in git log).

One minor code-level deviation from the plan: the disabled `navButton` helper retains `Element.pointer` (plan specified no pointer on disabled buttons). This is a cursor-appearance UX inconsistency only — the button fires `NoOp`, so navigation is not affected. It does not block the phase goal.

Human verification is required because the phase goal is explicitly about feel on a phone ("smooth and clear to fill in on a phone"), which cannot be confirmed from static code analysis alone.

---

_Verified: 2026-03-01T09:30:00Z_
_Verifier: Claude (gsd-verifier)_
