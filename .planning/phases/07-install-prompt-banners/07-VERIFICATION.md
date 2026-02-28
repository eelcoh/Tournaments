---
phase: 07-install-prompt-banners
verified: 2026-03-01T00:20:00Z
status: human_needed
score: 13/13 must-haves verified
human_verification:
  - test: "Dismiss [x] button contrast — Color.grey (rgb 45,45,45) on Color.black (rgb 13,13,13) background: confirm [x] text is visibly readable to users"
    expected: "The [x] dismiss button is clearly tappable and readable, not lost in the dark background"
    why_human: "Color.grey is rgb(45,45,45) and Color.black is rgb(13,13,13) — computed contrast ratio is ~1.2:1, which fails WCAG but may be acceptable for this terminal aesthetic. Cannot determine acceptability programmatically."
  - test: "iOS banner — build and serve, set isIOS:true in build/index.html flags, reload: confirm banner appears with exact text and terminal styling"
    expected: "Banner shows: '[ add to home screen ] -- tap -> then \"Add to Home Screen\" [x]' — monospace, dark bg, top border"
    why_human: "Visual rendering of elm-ui components cannot be verified without a browser"
  - test: "iOS dismiss persistence — tap [x] once (count becomes 1), reload: banner reappears; tap [x] again (count 2), reload: banner permanently hidden"
    expected: "Two-strike dismiss behavior working correctly via localStorage"
    why_human: "Browser localStorage interaction requires runtime verification"
  - test: "Android banner — after page load run app.ports.onBeforeInstallPrompt.send(null) in DevTools: confirm Android banner appears with orange CTA"
    expected: "Banner shows '[ Installeer App ] [x]' with orange CTA text; tapping CTA invokes triggerInstall port"
    why_human: "Port message flow and native install dialog require browser and DevTools verification"
  - test: "Standalone suppression — set isStandalone:true in flags, rebuild, reload: confirm no banner appears of any kind"
    expected: "No install banner rendered; status bar alone appears at bottom"
    why_human: "Visual suppression of banners requires browser verification"
---

# Phase 7: Install Prompt Banners — Verification Report

**Phase Goal:** Install prompt banners — show platform-appropriate install prompt banners (iOS instructions, Android native prompt) to non-installed users, with persistent dismiss and standalone suppression.
**Verified:** 2026-03-01T00:20:00Z
**Status:** human_needed (all automated checks pass; 5 items require browser/runtime confirmation)
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Elm receives `isStandalone : Bool` from JS at init | VERIFIED | `index.html` line 42: `isStandalone: window.navigator.standalone === true \|\| window.matchMedia('(display-mode: standalone)').matches`; `Types.elm` Flags has `isStandalone : Bool`; `Main.elm` init reads `flags.isStandalone` |
| 2 | Elm receives `isIOS : Bool` from JS at init | VERIFIED | `index.html` line 43: `isIOS: /iPad\|iPhone\|iPod/.test(navigator.userAgent) && !window.MSStream`; `Types.elm` Flags has `isIOS : Bool`; `Main.elm` init reads `flags.isIOS` |
| 3 | Elm receives `installBannerDismissCount : Int` from JS at init | VERIFIED | `index.html` line 35: localStorage read into `installBannerDismissCount`; passed in flags line 44; `Types.elm` Flags has `installBannerDismissCount : Int`; `Main.elm` patches `model.installBannerDismissCount` from flags |
| 4 | Elm can send `TriggerInstall` port to JS to call `deferredPrompt.prompt()` | VERIFIED | `Ports.elm`: `port triggerInstall : () -> Cmd msg`; `index.html` lines 49-56: `app.ports.triggerInstall.subscribe(...)` with `deferredPrompt.prompt()` call; `Main.elm` `TriggerAndroidInstall` handler calls `Ports.triggerInstall ()` |
| 5 | Elm can send `PersistDismiss` port to JS to write dismiss count to localStorage | VERIFIED | `Ports.elm`: `port persistDismiss : Int -> Cmd msg`; `index.html` lines 59-61: `app.ports.persistDismiss.subscribe(...)` with `localStorage.setItem` call; `Main.elm` `DismissInstallBanner` handler calls `Ports.persistDismiss newCount` |
| 6 | `Model.installBanner` holds platform-specific banner state | VERIFIED | `Types.elm`: `InstallBannerState = BannerHidden \| BannerShowingIOS \| BannerShowingAndroid`; Model has `installBanner : InstallBannerState`; init sets `installBanner = BannerHidden`; `Main.elm` patches it via `initialBannerState` derivation |
| 7 | iOS banner renders at bottom with exact text and dismiss button | VERIFIED (code path) | `View.elm` `viewInstallBanner` `BannerShowingIOS` case: renders text `"[ add to home screen ] -- tap \u{2197} then \"Add to Home Screen\""` + `dismissButton`; needs human visual confirmation |
| 8 | Android banner renders with orange CTA and dismiss button | VERIFIED (code path) | `View.elm` `viewInstallBanner` `BannerShowingAndroid` case: renders `"[ Installeer App ]"` with `Font.color Color.orange` + `TriggerAndroidInstall` onClick + `dismissButton`; needs human visual confirmation |
| 9 | Both banners appear above status bar using inFront layering | VERIFIED | `View.elm` body: single `inFront` column with `[ viewInstallBanner model, viewStatusBar model ]` — banner stacked above status bar; `BannerHidden` returns `Element.none` (no layout shift) |
| 10 | Both banners use terminal aesthetic (monospace, dark bg, border) | VERIFIED (code) | `bannerRow`: `Background.color Color.black`, `Border.widthEach { top = 1 ... }`, `Border.color Color.terminalBorder`; text elements use `UI.Font.mono` and `Font.size (UI.Font.scaled 0)` |
| 11 | Dismiss increments count and persists to localStorage | VERIFIED | `Main.elm` `DismissInstallBanner`: `newCount = model.installBannerDismissCount + 1`; returns `Ports.persistDismiss newCount`; `index.html` port subscriber writes to localStorage |
| 12 | Standalone mode suppresses all banners | VERIFIED | `Main.elm` init: `if flags.isStandalone then BannerHidden else ...`; when standalone, `initialBannerState = BannerHidden`; `BannerHidden` returns `Element.none` in view |
| 13 | `make build` compiles without errors or warnings | VERIFIED | `elm make src/Main.elm --optimize --output build/main.js` exits: `Compiling ... Success!` |

**Score:** 13/13 truths verified (5 require human browser confirmation for visual/runtime behavior)

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/Ports.elm` | Elm port declarations for JS bridge | VERIFIED | Exists; 21 lines; `port module Ports exposing (onBeforeInstallPrompt, persistDismiss, triggerInstall)`; all three ports declared with correct types |
| `src/index.html` | JS-side BeforeInstallPrompt capture, standalone detection, localStorage, port wiring | VERIFIED | `deferredPrompt` declared in `<head>`; three new flags (`isStandalone`, `isIOS`, `installBannerDismissCount`); `triggerInstall`, `persistDismiss`, `onBeforeInstallPrompt` port subscribers present |
| `src/Types.elm` | Extended Flags, InstallBannerState type, updated Model and Msg | VERIFIED | `InstallBannerState` type declared and exported; Flags has `isStandalone`, `isIOS`, `installBannerDismissCount`; Model has `installBanner : InstallBannerState` and `installBannerDismissCount : Int`; Msg has `BeforeInstallPromptReceived`, `DismissInstallBanner`, `TriggerAndroidInstall` |
| `src/Main.elm` | Port subscription wiring, init-time InstallBannerState derivation | VERIFIED | `import Ports`; `subscriptions` includes `Ports.onBeforeInstallPrompt (\_ -> BeforeInstallPromptReceived)`; `init` derives `initialBannerState` from flags; all three Msg variants handled in `update` |
| `src/View.elm` | viewInstallBanner function, updated body inFront overlay | VERIFIED | `viewInstallBanner`, `bannerRow`, `dismissButton` functions present and substantive; `body` uses single `inFront` column stacking banner above status bar |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/index.html` | `src/Ports.elm` | `app.ports.triggerInstall.subscribe` | WIRED | Lines 49-56 in index.html: `app.ports.triggerInstall.subscribe(function() { if (deferredPrompt) { deferredPrompt.prompt(); ... } })` |
| `src/index.html` | `src/Ports.elm` | `app.ports.persistDismiss.subscribe` | WIRED | Lines 59-61 in index.html: `app.ports.persistDismiss.subscribe(function(count) { localStorage.setItem(...) })` |
| `src/index.html` | `src/Ports.elm` | `app.ports.onBeforeInstallPrompt.send` | WIRED | Lines 64-73 in index.html: both immediate (if deferredPrompt already captured) and future firings forwarded |
| `src/Main.elm` | `src/Ports.elm` | port subscription in subscriptions | WIRED | `Ports.onBeforeInstallPrompt (\_ -> BeforeInstallPromptReceived)` in subscriptions function |
| `src/Main.elm` | `src/Ports.elm` | outgoing port commands in update | WIRED | `Ports.triggerInstall ()` in `TriggerAndroidInstall`; `Ports.persistDismiss newCount` in both `DismissInstallBanner` and `TriggerAndroidInstall` |
| `src/Types.elm` | `src/Main.elm` | isStandalone flag used in init | WIRED | `Main.elm` line 48: `if flags.isStandalone then BannerHidden` |
| `src/View.elm` | `src/Types.elm` | pattern match on model.installBanner | WIRED | `View.elm` line 225-251: `case model.installBanner of BannerHidden -> ... BannerShowingIOS -> ... BannerShowingAndroid -> ...` |
| `src/View.elm` | `src/Main.elm` | DismissInstallBanner and TriggerAndroidInstall Msg variants | WIRED | `dismissButton` uses `onClick DismissInstallBanner`; Android CTA uses `onClick TriggerAndroidInstall`; both handled in Main.elm update |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| INST-01 | 07-01, 07-02 | iOS Safari non-installed: dismissable banner at bottom explaining Add to Home Screen | SATISFIED | `isIOS` flag triggers `BannerShowingIOS` in init; `viewInstallBanner` renders iOS text with dismiss; `DismissInstallBanner` handler persists count |
| INST-02 | 07-01, 07-02 | Android Chrome BeforeInstallPrompt: dismissable banner; tapping triggers native dialog | SATISFIED | `onBeforeInstallPrompt` port sends `BeforeInstallPromptReceived`; sets `BannerShowingAndroid`; `TriggerAndroidInstall` calls `Ports.triggerInstall ()` which calls `deferredPrompt.prompt()` |
| INST-03 | 07-02 | Both banners match terminal aesthetic (monospace, dark background) | SATISFIED (code) | `bannerRow`: `Background.color Color.black`, `Border.color Color.terminalBorder`, `UI.Font.mono`, `Font.size (UI.Font.scaled 0)` — needs human visual confirmation |
| INST-04 | 07-01, 07-02 | Dismissed state persists; banner doesn't reappear on every visit | SATISFIED | `persistDismiss` port writes to `localStorage`; init reads `installBannerDismissCount` from flags; `>= 2` threshold in both init and `BeforeInstallPromptReceived` handler |

No orphaned requirements — all four INST IDs claimed in plans and tracked in REQUIREMENTS.md.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `src/UI/Color.elm` | 87-88 | `grey = rgb255 45 45 45` | Info | `dismissButton` uses `Color.grey` on `Color.black` (rgb 13,13,13) background — contrast ratio ~1.2:1. The `[x]` may be hard to see. Not a code bug; terminal-aesthetic design choice. |

No placeholder/stub patterns, no `TODO`/`FIXME`, no empty implementations, no console.log-only handlers found in modified files.

### Human Verification Required

#### 1. Dismiss [x] button contrast check

**Test:** Load the app with `isIOS: true` in build/index.html flags. Observe the `[x]` dismiss button on the iOS banner.
**Expected:** The `[x]` text is legible and clearly tappable against the dark background — or if invisible, this is flagged as a bug.
**Why human:** `Color.grey` is `rgb(45,45,45)` on `Color.black` (`rgb(13,13,13)`) — near-identical dark tones. Computed contrast is too low for WCAG but the terminal aesthetic may intentionally use this for secondary UI. Only visual inspection can confirm acceptability.

#### 2. iOS banner visual and text verification

**Test:** Build and serve (`make build && python3 -m http.server --directory build`). Edit `build/index.html`, set `isIOS: true` in the Elm.Main.init flags object. Reload `http://localhost:8000`.
**Expected:** Banner appears at bottom above the status bar: `[ add to home screen ] -- tap -> then "Add to Home Screen" [x]` — monospace font, dark background, terminal border separator above.
**Why human:** elm-ui visual layout requires browser rendering.

#### 3. iOS dismiss persistence (two-strike logic)

**Test:** With iOS banner visible, tap `[x]`. Reload. Confirm banner reappears (count=1, < 2). Tap `[x]` again. Reload. Confirm banner is gone permanently (count=2, >= 2).
**Expected:** First dismiss retries; second dismiss permanently hides. `localStorage.getItem('installBannerDismissCount')` reads `"1"` then `"2"` at respective stages.
**Why human:** localStorage state machine requires browser interaction across reloads.

#### 4. Android banner with port trigger

**Test:** Revert index.html to non-iOS defaults. After page load, open DevTools console and run: `app.ports.onBeforeInstallPrompt.send(null)`. (Confirm `var app = Elm.Main.init(...)` makes `app` global in index.html — it does, on line 37.)
**Expected:** Android banner appears: `[ Installeer App ] [x]` — orange CTA text; tapping CTA calls `triggerInstall` port (no native dialog on desktop but port should fire; check `deferredPrompt` is null so nothing visible on desktop).
**Why human:** Port message flow and native install dialog require browser and DevTools.

#### 5. Standalone suppression

**Test:** Set `isStandalone: true` in build/index.html flags, rebuild and reload.
**Expected:** No install banner of any kind appears. Only the status bar is visible at the bottom.
**Why human:** Visual confirmation that `Element.none` correctly suppresses the banner layer.

### Gaps Summary

No gaps found. All automated checks pass:
- `src/Ports.elm` exists with all three port declarations (correct types, fully substantive)
- `src/index.html` has early `deferredPrompt` capture, all three new flags, all three port subscribers
- `src/Types.elm` has `InstallBannerState`, extended `Flags`, extended `Model`, three new `Msg` variants
- `src/Main.elm` imports `Ports`, has port subscription, derives `initialBannerState` from flags, handles all three Msg variants
- `src/View.elm` has `viewInstallBanner` with all three cases, `bannerRow`, `dismissButton`, updated body layout
- `make build` compiles with `Success!` — no errors, no warnings
- All four requirement IDs (INST-01 through INST-04) satisfied by implementation evidence

Remaining items are runtime/visual behaviors (banner rendering, localStorage interaction, port flow) that require a browser to confirm. The CONTEXT.md also specified a "short delay after page load" before banner appearance, but this was not implemented (banners appear immediately). This is a deviation from the original context spec but was apparently intentional per the plan execution (plans don't mention a delay). Flagged for awareness, not as a gap.

---

_Verified: 2026-03-01T00:20:00Z_
_Verifier: Claude (gsd-verifier)_
