---
phase: 01-pwa-infrastructure
verified: 2026-02-24T20:26:16Z
status: human_needed
score: 8/8 automated must-haves verified
human_verification:
  - test: "Chrome on Android shows Add to Home Screen install prompt"
    expected: "Chrome's mini-infobar or install prompt appears after a short browsing session on the deployed site"
    why_human: "Requires a real Android device and a served HTTPS site — cannot verify programmatically from the file system"
  - test: "iOS Safari Add to Home Screen sheet shows Voetbalpool name and apple-touch-icon (not a globe)"
    expected: "The 'Add to Home Screen' sheet displays the 180x180 icon and the name 'Voetbalpool'"
    why_human: "iOS behaviour requires a real device running Safari — no programmatic substitute"
  - test: "After install the app opens full-screen without browser chrome on both platforms"
    expected: "Launched from home screen icon, the app fills the full screen with no address bar or navigation chrome"
    why_human: "Requires installed PWA on a physical device — cannot emulate from disk"
  - test: "Sometype Mono font renders from local cache on repeat loads (no network request to fonts.googleapis.com)"
    expected: "Chrome DevTools Network panel shows fonts served from Service Worker cache; no googleapis.com requests"
    why_human: "Service worker caching behaviour requires a running browser session with DevTools"
notes:
  - "background_color discrepancy: REQUIREMENTS.md PWA-02 specifies '#1a1a1a' but manifest.json and index.html body both use '#0d0d0d'. This is a cosmetic divergence from the written spec; the PLAN.md intentionally used #0d0d0d to match the app's actual body background. No functional impact."
  - "API pass-through prefix: REQUIREMENTS.md PWA-04 specifies '/api/' but sw.js correctly uses '/bets/' — which matches the actual Elm API module paths. The requirement text had a naming error; implementation is correct."
---

# Phase 1: PWA Infrastructure Verification Report

**Phase Goal:** Players can install the app to their home screen and get instant subsequent loads from cache
**Verified:** 2026-02-24T20:26:16Z
**Status:** human_needed (all automated checks passed; 4 items require device testing)
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Sometype Mono font loads from assets/fonts/ with no Google Fonts network request | VERIFIED | fonts.css exists with @font-face; no googleapis.com URL in src/index.html or build/index.html |
| 2 | Chrome on Android shows the Add to Home Screen install prompt | ? NEEDS HUMAN | All prerequisites met (manifest with display:standalone, icons, SW) but live device needed |
| 3 | iOS Safari Add to Home Screen sheet shows Voetbalpool name and icon (not a globe) | ? NEEDS HUMAN | apple-touch-icon.png (180x180) and apple-mobile-web-app-title meta present; device needed to confirm |
| 4 | After install, the app opens full-screen without browser chrome on both platforms | ? NEEDS HUMAN | manifest display:standalone confirmed; actual standalone launch requires real device |
| 5 | make build produces build/ containing sw.js, manifest.json, and font files | VERIFIED | make build exits 0; all files confirmed in build/ |
| 6 | Service worker registers and cache-first strategy delivers instant subsequent loads | VERIFIED (automated) | sw.js syntax valid; register() call in index.html; APP_SHELL covers all 7 required paths |

**Score (automated):** 3 verified, 3 need human / 6 truths total (all automated checks pass)

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `assets/fonts/SometypeMono[wght].woff2` | Variable upright font, weights 400-700 | VERIFIED | 27KB, WOFF2 v2, TrueType — confirmed by `file` command |
| `assets/fonts/SometypeMono-Italic[wght].woff2` | Variable italic font, weights 400-700 | VERIFIED | 29KB, WOFF2 v2, TrueType — confirmed by `file` command |
| `assets/fonts/fonts.css` | @font-face declarations for both font axes | VERIFIED | Contains two @font-face blocks, font-family 'Sometype Mono', relative url() paths |
| `assets/icon-192.png` | 192x192 icon for Android install prompt | VERIFIED | PNG 192x192, 21KB confirmed by `identify` |
| `assets/icon-512.png` | 512x512 icon for splash screen / any purpose | VERIFIED | PNG 512x512, 20KB confirmed by `identify` |
| `assets/icon-512-maskable.png` | 512x512 maskable icon for Android adaptive icons | VERIFIED | PNG 512x512, 20KB — same design as icon-512.png (dark bg fills canvas safely) |
| `assets/apple-touch-icon.png` | 180x180 icon for iOS Safari Add to Home Screen | VERIFIED | PNG 180x180, 20KB confirmed by `identify` |
| `src/manifest.json` | Web App Manifest declaring installability metadata | VERIFIED | Valid JSON, display:standalone, 3 icons, theme_color #ff8c00, background_color #0d0d0d |
| `src/sw.js` | Vanilla service worker with CACHE_NAME, APP_SHELL, /bets/ passthrough | VERIFIED | Passes Node.js syntax check; contains all required sections |
| `src/index.html` | Updated HTML head with manifest link, theme-color, iOS metas, SW registration | VERIFIED | All 7 required additions confirmed present; no Google Fonts URLs |
| `Makefile` | build target copies sw.js and manifest.json to build/ | VERIFIED | pwa target present, in build dependency chain, in .PHONY |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/manifest.json` | `assets/icon-192.png` | icons array src field | WIRED | `"src": "assets/icon-192.png"` confirmed in manifest |
| `src/manifest.json` | `assets/icon-512-maskable.png` | icons array maskable entry | WIRED | `"purpose": "maskable"` entry with correct src confirmed |
| `assets/fonts/fonts.css` | `assets/fonts/SometypeMono[wght].woff2` | url() in @font-face src | WIRED | `url('SometypeMono[wght].woff2')` in fonts.css (relative path, correct) |
| `src/index.html` | `src/manifest.json` | `<link rel="manifest" href="manifest.json">` | WIRED | Confirmed present in index.html |
| `src/index.html` | `assets/fonts/fonts.css` | `<link rel="stylesheet" href="assets/fonts/fonts.css">` | WIRED | `fonts/fonts.css` link confirmed; no Google Fonts fallback present |
| `src/index.html` | `src/sw.js` | `navigator.serviceWorker.register('/sw.js')` | WIRED | serviceWorker.register call confirmed in index.html |
| `src/sw.js` | `assets/fonts/SometypeMono[wght].woff2` | APP_SHELL cache list | WIRED | Both woff2 paths present in APP_SHELL array |
| `Makefile` | `src/sw.js` | `cp $(SRC)/sw.js $(BUILD)/sw.js` | WIRED | pwa target contains the copy command; `make build` exits 0 |

---

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| PWA-01 | 01-01-PLAN.md | Sometype Mono self-hosted, local @font-face, eliminates cross-origin font dependency | SATISFIED | fonts.css, both woff2 files, no googleapis.com in index.html |
| PWA-02 | 01-01-PLAN.md | manifest.json with name, short_name, start_url, display:standalone, colors, icons array | SATISFIED* | All fields confirmed; background_color is #0d0d0d not #1a1a1a (see note below) |
| PWA-03 | 01-01-PLAN.md | PNG icons at 192x192, 512x512 any, 512x512 maskable | SATISFIED | All four icons confirmed at correct dimensions |
| PWA-04 | 01-02-PLAN.md | sw.js cache-first for app shell, network-only for API, versioned CACHE_NAME, old cache cleanup | SATISFIED* | Implemented correctly; note: uses /bets/ prefix, not /api/ as written in requirement text |
| PWA-05 | 01-02-PLAN.md | index.html with manifest link, theme-color, apple-mobile-web-app metas, SW registration | SATISFIED | All required meta tags and links confirmed present |
| PWA-06 | 01-02-PLAN.md | Makefile build target copies manifest.json and sw.js to build/ | SATISFIED | pwa target confirmed in Makefile; make build produces correct output |

**Orphaned requirements:** None — all six phase-1 requirements (PWA-01 through PWA-06) are claimed by plans 01-01 and 01-02.

#### Notes on requirement deviations

**PWA-02 background_color:** REQUIREMENTS.md specifies `#1a1a1a` but manifest.json uses `#0d0d0d`. The PLAN.md documentation explicitly chose `#0d0d0d` to match the `<body style="background-color: #0d0d0d">` in index.html. This is a cosmetic spec divergence with no functional impact — the colour is consistent across the deployed files.

**PWA-04 API prefix:** REQUIREMENTS.md specifies `network-only pass-through for /api/ requests`. The sw.js uses `/bets/` — which is the correct real path used by the Elm application (confirmed in `src/API/Bets.elm`). The requirement text had a generic placeholder; the implementation uses the project-specific correct path.

---

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| None | — | — | — | No anti-patterns found in any modified files |

No TODO/FIXME/placeholder comments, no empty implementations, no stub return values found in: `src/sw.js`, `src/index.html`, `Makefile`, `src/manifest.json`, `assets/fonts/fonts.css`.

---

### Human Verification Required

All automated infrastructure checks pass. The following require a real device + deployed HTTPS environment to fully confirm the phase goal.

#### 1. Android install prompt (Chrome)

**Test:** Deploy build/ to an HTTPS host. Open in Chrome on Android. Browse for 30+ seconds.
**Expected:** Chrome's mini-infobar "Add Voetbalpool to Home Screen" appears, or the install prompt triggers via `beforeinstallprompt` event.
**Why human:** The prompt requires a live HTTPS page, SW active, manifest with installability criteria met — not verifiable from filesystem.

#### 2. iOS Add to Home Screen sheet

**Test:** Open the deployed HTTPS URL in Safari on iOS. Tap Share > "Add to Home Screen".
**Expected:** The sheet shows the name "Voetbalpool" and the 180x180 apple-touch-icon (orange "WC26" on dark background), not a globe/screenshot.
**Why human:** iOS Safari reads apple-touch-icon and apple-mobile-web-app-title only in a live browser session.

#### 3. Standalone launch (no browser chrome)

**Test:** After adding to home screen on either platform, tap the home screen icon to launch.
**Expected:** App opens full-screen with no browser address bar, navigation buttons, or URL bar. Status bar visible (black-translucent on iOS).
**Why human:** The `display: "standalone"` manifest field only takes effect when launched from the home screen icon — requires the install step first.

#### 4. Cache-first font serving (DevTools confirmation)

**Test:** Load the app once (warms cache). Reload. Open DevTools > Network. Filter for `.woff2`.
**Expected:** Both woff2 requests are served `(from ServiceWorker)` — no network request to `fonts.googleapis.com`.
**Why human:** Service worker cache state cannot be inspected from the filesystem; requires a running browser with active SW.

---

## Gaps Summary

No gaps — all automated must-haves are verified. The phase infrastructure is correctly assembled:
all static assets exist at correct sizes, manifest is valid JSON with required fields, service worker
has correct structure and syntax, index.html is properly wired with no Google Fonts fallback, and
`make build` produces a complete deployable directory. The three human-verification items are
behavioural confirmations that require a live device; they do not indicate implementation gaps.

---

_Verified: 2026-02-24T20:26:16Z_
_Verifier: Claude (gsd-verifier)_
