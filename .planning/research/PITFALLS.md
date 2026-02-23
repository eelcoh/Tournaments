# Pitfalls Research

**Domain:** PWA integration + mobile layout for Elm 0.19.1 SPA (elm-ui, static hosting, iOS Safari)
**Researched:** 2026-02-23
**Confidence:** HIGH

---

## Critical Pitfalls

### Pitfall 1: Service Worker Serves Stale `main.js` After Deployment

**What goes wrong:**
After deploying a new build, users who previously installed the PWA continue to see the old version of `main.js`. The service worker intercepts the request and returns the cached copy. The Elm app is never updated. This is especially acute on iOS Safari where hard-refresh does not bypass the service worker cache.

**Why it happens:**
`main.js` is a fixed filename — the Makefile always outputs `build/main.js`. If the service worker uses a cache-first strategy with no version key in the cache name, the old `main.js` is served forever. The service worker file itself (`sw.js`) can also get stuck in the HTTP cache if the server sends a long `Cache-Control` max-age on it.

**How to avoid:**
- Embed a build version (e.g. git commit hash or `Date.now()` at build time) as a constant inside `sw.js`. When the service worker is re-fetched and the constant differs, the browser installs the new worker.
- Name caches with the version: `const CACHE = 'app-shell-v' + VERSION`. On `activate`, delete all caches whose name does not match the current version.
- The server must serve `sw.js` with `Cache-Control: no-cache, max-age=0` so the browser re-fetches it on every page load and can detect changes.
- Use `skipWaiting()` + `clients.claim()` in the service worker so new versions take effect immediately without requiring the user to close all tabs.

**Warning signs:**
- Testing a deployment and finding the old Elm UI renders.
- `chrome://serviceworker-internals` shows an old script URL or install date.
- iOS testers never see updates even after quitting and reopening the app.

**Phase to address:** PWA phase (Phase 1 — service worker implementation). Version strategy must be decided before caching any asset.

---

### Pitfall 2: `sw.js` URL Must Be at Build Root, Not `src/`

**What goes wrong:**
`sw.js` is placed in `src/` but the Makefile only copies `src/index.html` and `assets/` to `build/`. The service worker registration in `index.html` points to `/sw.js` which resolves to `build/sw.js`, but the file was never copied there. Registration silently fails; no caching, no install prompt.

**Why it happens:**
The build step in `Makefile` has no `cp sw.js build/sw.js` target. It is easy to forget because `main.js` is built directly into `build/` by `elm make`, but `sw.js` is a hand-written file that needs explicit copying.

**How to avoid:**
- Store `sw.js` in `src/` (alongside `index.html`) and add a `cp src/sw.js $(BUILD)/sw.js` step to the Makefile `build` and `debug` targets.
- Verify at build time: after `make build`, check that `build/sw.js` exists before testing.

**Warning signs:**
- Browser DevTools → Application → Service Workers shows "no service worker" despite registration code in `index.html`.
- No install prompt appears on mobile.

**Phase to address:** PWA phase (Phase 1 — infrastructure). Makefile change is required before any service worker code is useful.

---

### Pitfall 3: iOS Safari Does Not Show PWA Install Prompt Automatically

**What goes wrong:**
On Android, a PWA install banner appears automatically once the browser deems the criteria met. On iOS Safari there is no automatic prompt — ever. Users must manually tap Share → "Add to Home Screen". If the app does not instruct them to do this, most will never install it.

**Why it happens:**
Apple has not implemented the `beforeinstallprompt` event and provides no programmatic install API. iOS relies entirely on the user-initiated Share Sheet flow.

**How to avoid:**
- Add a one-time dismissable in-app banner on iOS (detect via `navigator.standalone === false` in JS flags, pass as Elm flag) that explains the "Add to Home Screen" flow with text: "Tap the Share button then 'Add to Home Screen'."
- Link to the banner only on iOS Safari (User-Agent detection in JS is acceptable for this case since it is purely informational).
- Do not use `apple-mobile-web-app-capable` meta tag without also providing `apple-touch-icon` — without the icon the home screen shortcut looks broken.

**Warning signs:**
- App works as PWA on Android but nobody installs it on iPhone.
- `apple-touch-icon` link element missing from `index.html`.

**Phase to address:** PWA phase (Phase 1 — manifest + iOS meta tags).

---

### Pitfall 4: iOS Storage Cleared After ~7 Days of Inactivity

**What goes wrong:**
iOS aggressively evicts PWA storage — including the Cache API used by the service worker — if the app is not opened for approximately 7 days. After eviction the app must re-fetch all assets from the network on next launch. If the network is unavailable, the app fails to load. This also means cached auth tokens or bet drafts (if ever stored in Cache/IndexedDB) are silently lost.

**Why it happens:**
Apple's ITP (Intelligent Tracking Prevention) and storage quota policies apply the 7-day cap to all script-writable storage for PWAs. The quota is also small (~50MB total), though for this app `main.js` is the only large asset.

**How to avoid:**
- For this app (app-shell only caching, no offline data sync), the only risk is the user loading the app on mobile data after the cache was cleared. The app still works — it just requires a network round-trip.
- Do not architect features that assume the service worker cache is persistent (no offline bet submission, no caching of API responses). The `PROJECT.md` out-of-scope list already forbids this.
- Document this behaviour for project owner so expectations are set correctly.

**Warning signs:**
- App loads but has no service worker cache after a week of no testing.
- Monitoring shows cache hit rate drops to 0% on Mondays (tournament inactivity over weekends).

**Phase to address:** PWA phase (Phase 1 — scoping). Awareness prevents over-engineering; just note the limit in comments in `sw.js`.

---

### Pitfall 5: iOS Safari Standalone Mode Loses Navigation History on App Restart

**What goes wrong:**
When the user closes the PWA from the iOS home screen (swipes it away from App Switcher) and reopens it, the Elm app restarts from `init`. URL fragment routing (`#formulier`, `#stand`) means the browser URL resets to root. The user loses their place in the form. Any in-flight Elm model state (e.g. which card they were on, their bracket draft) is gone unless it was persisted to the backend.

**Why it happens:**
iOS does not preserve JS heap state between PWA launches. The `History` API state is also cleared. This is a known iOS standalone mode constraint with no workaround short of explicit persistence.

**How to avoid:**
- Keep all significant state in backend API calls (bets are already submitted to the server; GET `/bet/:id` restores state on re-open).
- Do not rely on in-memory form draft state surviving across sessions.
- Consider `localStorage` or `sessionStorage` to persist the current `Card` index so the user returns to their last card, but note that `localStorage` is shared between Safari and standalone — not guaranteed to persist either.
- The form is short enough (6 cards) that restarting is not a critical problem.

**Warning signs:**
- User fills in group matches on phone, closes app, reopens and lands on intro card with empty form.
- Elm `init` receives `formId = null` flag, meaning no saved bet to restore.

**Phase to address:** Mobile UX phase (Phase 2 — navigation improvements). Note this in the PWA phase as a known constraint.

---

### Pitfall 6: elm-ui `Input.text` Does Not Surface `inputmode` or `pattern` Attributes

**What goes wrong:**
Score input fields in `Form/GroupMatches.elm` use Elm's `Element.Input.text` (which renders as `<input type="text">`). On iOS and Android, this shows the full QWERTY keyboard, not the numeric keypad. Players must switch keyboard layouts manually to type a score digit (0–9). This degrades the score entry UX significantly on mobile.

**Why it happens:**
`elm-ui`'s `Input.text` does not accept an `inputmode` prop natively. The `type="number"` input has its own problems (browser adds spinner arrows, iOS renders a decimal keyboard with a leading `.`, and `elm-ui` score fields store `Int` not `String` requiring parse handling). The `pattern="[0-9]*"` attribute on a `type="text"` input triggers the numeric keypad on iOS — but this must be applied via `Element.htmlAttribute`.

**How to avoid:**
- Apply numeric keyboard via `Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")` and `Element.htmlAttribute (Html.Attributes.pattern "[0-9]*")` on score input elements.
- Keep `type="text"` (not `type="number"`) to avoid the spinners and iOS decimal-comma issues.
- This is done at the `UI.Style.scoreInput` / `viewInput` level in `Form/GroupMatches.elm`.

**Warning signs:**
- Testing score entry on iPhone shows full QWERTY keyboard instead of number pad.
- No `inputmode` attribute present in the rendered `<input>` element in DevTools.

**Phase to address:** Mobile UX phase (Phase 2 — score input improvements). Low risk to implement, high impact on usability.

---

### Pitfall 7: elm-ui Monospace Text Rows Overflow on Narrow Screens

**What goes wrong:**
Match lines in the scroll wheel (`viewScrollLine`) are constructed as fixed-width monospace strings: `"  >  " ++ home(4) ++ "  " ++ score ++ "  " ++ away(4) ++ "  <"` — approximately 22 characters. On very narrow phones (~320px) the fixed-pitch monospace rendering causes horizontal overflow, creating an unwanted horizontal scrollbar or clipping the `<` cursor indicator.

**Why it happens:**
elm-ui rows with `width fill` clip or overflow when children have intrinsic fixed widths (text that doesn't wrap). Monospace fonts render wider per character than proportional fonts, and the codebase uses `Sometype Mono` loaded from Google Fonts. At 320px width with 24px padding (from `Element.padding 24` in `View.elm`), usable width is 272px.

**How to avoid:**
- Audit the widest match line at 320px. If it overflows, reduce `padRight 4` to `padRight 3`, or shrink font size for the scroll wheel only via a smaller `Font.size`.
- Consider `Element.clip` on the scroll wheel container rather than letting it push the layout.
- Test on `iPhone SE (1st gen)` which has 320px width — the smallest screen still in active use.

**Warning signs:**
- Horizontal scroll appears on the page during scroll wheel navigation.
- The `<` suffix on active match is cut off.
- `UI.Screen.device` returns `Phone` but elements still overflow.

**Phase to address:** Mobile UX phase (Phase 2 — group matches layout). Verify at 320px in browser DevTools before calling the feature complete.

---

### Pitfall 8: Google Fonts Load Fails When Offline (Or Under Slow Network)

**What goes wrong:**
`index.html` loads `Sometype Mono` from `fonts.googleapis.com`. The service worker does not intercept cross-origin requests from a different origin without explicit configuration. If the font CDN is unavailable (offline or slow), the page renders in the fallback system font — breaking the terminal aesthetic completely (proportional layout, wrong letter widths, monospace alignment collapses).

**Why it happens:**
Service workers only intercept same-origin requests by default unless CORS is handled. Google Fonts CSS is served from `fonts.googleapis.com` (a different origin) and the font files from `fonts.gstatic.com`. Even with CORS, the `Cache-Control` on the font CSS sets `max-age=86400` (1 day), and the `private` flag on the CSS may prevent cross-origin caching.

**How to avoid:**
- Self-host the `Sometype Mono` font files inside `assets/fonts/` and reference them with a local `@font-face` rule embedded in `index.html` via a `<style>` block.
- Remove the Google Fonts `<link>` preconnect and stylesheet from `index.html`.
- The service worker will then cache the font files as part of the app-shell cache alongside `main.js`.
- This also eliminates the network round-trip latency to Google on first load.

**Warning signs:**
- Disabling network in DevTools and reloading shows a sans-serif or monospace system font instead of Sometype Mono.
- The score lines and bracket stepper look misaligned (spacing assumes monospace width).

**Phase to address:** PWA phase (Phase 1 — app-shell definition). Font self-hosting must happen before the service worker cache list is finalised, since the font files must be listed explicitly.

---

### Pitfall 9: `preventDefaultOn "touchend"` Breaks iOS Scroll in Other Views

**What goes wrong:**
The scroll wheel in `Form/GroupMatches.elm` uses `Html.Events.preventDefaultOn "touchend"` to stop the browser from interpreting the swipe as a page scroll. If this attribute is attached to an element that is visible in other views or at a high DOM level, it can suppress all native scroll behaviour globally in the PWA — making the activities feed or results tables unscrollable on iOS.

**Why it happens:**
The `touchEndAttr` is applied to the `Element.column` wrapping the scroll items in `viewScrollWheel`. Currently this is scoped to the group matches card only. The risk arises if the attribute is accidentally promoted to a parent wrapper, or if the group matches column renders in a context where it shouldn't prevent default.

**How to avoid:**
- Keep `preventDefaultOn "touchend"` scoped to the specific scroll wheel column, not to any card wrapper or page wrapper.
- Only render the scroll wheel column when the `GroupMatchesCard` is active — it is already conditional in `Form/View.elm`.
- Add a comment in `viewScrollWheel` explaining why `preventDefault` is necessary (to prevent browser scroll conflict on the swipe gesture) so future maintainers don't remove or broaden it.

**Warning signs:**
- Activities feed cannot be scrolled by swipe on iOS after navigating through the form.
- `console.log` shows `touchend` events with `defaultPrevented: true` in contexts outside the group matches card.

**Phase to address:** Mobile UX phase (Phase 2 — existing touch handling). Audit during testing on a real iOS device.

---

### Pitfall 10: Bracket Stepper ASCII Pipeline Overflows on Narrow Phones

**What goes wrong:**
The bracket wizard stepper in `Form/Bracket/View.elm` renders 6 round labels (`R32 --- R16 --- QF --- SF --- F --- W`) as a horizontal row with ` --- ` connectors. At 320–375px screen width, this row exceeds the available width, causing overflow or wrapping that breaks the ASCII pipeline visual.

**Why it happens:**
`List.intersperse connector steps` produces a linear row. Each step is a text label (3–4 chars) plus connectors (5 chars each), totalling approximately 44 characters. At monospace rendering, this can exceed 320px. elm-ui rows do not wrap by default.

**How to avoid:**
- At `Phone` device size (< 500px per `UI.Screen.device`), abbreviate or omit the ` --- ` connectors and use a compact format: `R32>R16>QF>SF>F>W` with `>` as separator.
- Alternatively render the stepper as a two-row grid on phones.
- Use `UI.Screen.device model.screen` to branch the stepper layout — this is already the pattern used in the codebase for responsive adjustments.

**Warning signs:**
- Stepper wraps onto two lines with connector on its own line.
- Horizontal scroll appears when navigating the bracket wizard on a 375px iPhone.

**Phase to address:** Mobile UX phase (Phase 3 — bracket wizard layout). Test stepper at 320px and 375px in DevTools before marking done.

---

### Pitfall 11: Manifest `start_url` Mismatch with Fragment-Based Routing

**What goes wrong:**
The app uses fragment routing (`/#home`, `/#formulier`). If `manifest.json` sets `start_url: "/"`, the PWA launches to the root path, which the Elm app treats as `Home`. This is correct. But if `start_url` is set to something like `"/#formulier"`, some browsers (especially older Chrome) strip the fragment from `start_url`, causing the app to launch at `Home` anyway. iOS Safari historically had issues parsing the manifest file at all if the page was loaded before the manifest was available.

**Why it happens:**
The manifest file is fetched lazily on iOS (before iOS 15.4, it is only loaded when the Share Sheet opens, not on page load). If the manifest is not loaded in time, "Add to Home Screen" creates a plain bookmark with no PWA metadata. The `start_url` fragment stripping is a documented Chrome behaviour.

**How to avoid:**
- Set `start_url: "/"` with `"display": "standalone"` in the manifest. Do not rely on fragment to set initial route.
- Ensure the manifest `<link>` is in `<head>` before any scripts in `index.html`.
- Test "Add to Home Screen" on both iOS 15+ and iOS 16+ to verify standalone mode activates.

**Warning signs:**
- PWA launches in browser tab rather than standalone (no address bar hidden).
- App icon on iOS home screen opens Safari with URL bar visible.
- `window.navigator.standalone` returns `false` despite being launched from home screen.

**Phase to address:** PWA phase (Phase 1 — manifest). The `start_url` decision should be made and tested before the phase closes.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Hard-code cache list in `sw.js` without version hash | Simple to write | Every deployment requires manually updating the cache list; easy to forget assets, causing cache misses | Never; add a build step or inline the version constant |
| Skip self-hosting fonts, cache Google Fonts via SW | Saves work upfront | Font loads fail offline; cache eviction clears fonts; CDN blocking causes layout break | Never for an app requiring offline-ready feel |
| Use `window.innerWidth` flag only once at init | Already implemented | Screen orientation changes or keyboard-up resize not reflected in `model.screen` | Acceptable — `ScreenResize` subscription already handles this case |
| Apply `preventDefaultOn` to outermost view wrapper | Quick to implement | Breaks native scroll on all other pages on iOS | Never |
| Use `type=number` for score inputs | Shorter code | iOS shows decimal pad not integer pad; spinner UI on desktop; `Int` vs `String` parse errors | Never; use `type=text` with `inputmode=numeric` |
| Omit `apple-touch-icon` | Saves creating icon assets | Home screen icon falls back to a low-res screenshot on iOS | Never if PWA install UX matters |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Service Worker + Elm init flags | Registering SW after `Elm.Main.init()` — flags use `window.innerWidth` but SW may delay first paint | Register SW before Elm init is fine; SW does not block DOM. Keep `Elm.Main.init` inline in `<body>` script as-is |
| Google Fonts + Service Worker | Attempting to intercept `fonts.googleapis.com` in SW fetch handler without CORS mode | Self-host fonts to avoid cross-origin complexity entirely |
| Manifest + iOS Safari | Setting `background_color` in manifest expecting splash screen | iOS Safari ignores `background_color`; use `apple-touch-startup-image` link tags for splash, or accept no splash screen |
| Fragment routing + PWA scope | Setting `scope: "/"` in manifest but hosting app at a sub-path | Ensure `scope` and `start_url` match the actual hosting path; `scope: "/"` is correct for root deployment |
| Service Worker + API calls | Accidentally caching `POST /bets` responses in the SW fetch handler | Explicitly skip caching for non-GET requests or requests to the API origin |

---

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Caching `main.js` without version busting | Old Elm app served after deploy | Version-keyed cache name; delete old caches on `activate` | Every deployment |
| All 48 match DOM nodes rendered at once | Scroll wheel jank on low-end Android phones | Scroll wheel already renders only 5 visible items — maintain this; do not expand window | Low-end devices with < 2GB RAM |
| Google Fonts round-trip on every cold start | 200–400ms layout shift before font loads | Self-host fonts; cache in app-shell | Every cold start on slow mobile network |
| Elm `onResize` firing during virtual keyboard appearance | Form reflows on every character typed in name/email fields | `ScreenResize` only updates `model.screen`; this is fine. Avoid layout that changes drastically on height-only resize | Any phone with virtual keyboard |

---

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| Caching API responses (including auth tokens) in service worker Cache API | Token leakage if device is shared; stale auth state | Never cache API responses; SW should pass-through all requests to API origin |
| Serving SW with long `Cache-Control` from static host | SW update blocked for hours or days | Configure server/hosting to set `Cache-Control: no-cache` on `sw.js` specifically |
| Manifest `display: standalone` without `scope` restriction | External links within the app open in the PWA window instead of Safari | Set `scope: "/"` (root of app); links to external domains will open in Safari correctly |

---

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| No iOS install instruction | iPhone users never install the PWA; miss offline speed benefit | Show a one-time "Add to Home Screen" tip on iOS mobile, detected via `navigator.standalone` JS flag passed to Elm |
| Tap targets under 44px | Group nav letters (A B C…) and scroll wheel match lines are too small to tap accurately on phone | Add `Element.padding` to increase touch area; group letters especially need >= 44px height |
| Score input showing full QWERTY keyboard | Extra taps to switch to number pad for every score digit | Add `inputmode="numeric"` attribute to score inputs |
| Bracket stepper overflowing horizontally | Stepper wraps or causes scroll, confusing navigation feedback | Compact stepper layout for `Phone` device size |
| App restarts on iOS PWA reopen with lost card position | User must navigate back to their card every time they reopen | Accept as a known iOS limitation; form is short (6 cards), restarting is acceptable |

---

## "Looks Done But Isn't" Checklist

- [ ] **PWA Installability:** `manifest.json` linked in `<head>`, has `name`, `icons` (192px + 512px), `display: standalone`, `start_url: "/"`. Verify in Chrome DevTools → Application → Manifest — no warnings shown.
- [ ] **Service Worker Active:** DevTools → Application → Service Workers shows "activated and running". Test by disabling network and reloading — `main.js` loads from cache.
- [ ] **iOS Add to Home Screen:** Tested on real iOS device. Tap Share → Add to Home Screen. Verify app opens in standalone mode (no Safari address bar). Verify app icon appears (not a blurry screenshot).
- [ ] **Font Self-Hosted:** `build/assets/fonts/` contains `.woff2` files. `index.html` has `<style>` with `@font-face` pointing to local path. No `fonts.googleapis.com` link remains in `index.html`.
- [ ] **Cache Versioned:** `sw.js` has a `CACHE_VERSION` constant. Old caches deleted in `activate` handler. Incrementing the constant (simulating a deploy) causes the new SW to install and serve fresh assets.
- [ ] **SW Not Caching API Calls:** In SW `fetch` handler, requests to API origin pass through to network without caching. Confirmed with DevTools Network tab: API requests show no "(Service Worker)" annotation.
- [ ] **Score Inputs Show Number Pad:** Tapping a score field on a real iOS device shows a numeric keyboard (digits 0–9, not QWERTY). `inputmode="numeric"` attribute present in rendered HTML.
- [ ] **Tap Targets 44px+:** Group nav letters (A–L) and scroll wheel match lines have sufficient touch area. Tested on iPhone with no mis-taps on correct target.

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Stale main.js cached after bad deploy | MEDIUM | Increment `CACHE_VERSION` in `sw.js` and redeploy. Old SW will be replaced. iOS users may need to close and reopen app. |
| SW file itself cached by browser | HIGH | Set `Cache-Control: no-cache` on `sw.js` via server config. Cannot be fixed from Elm code alone — requires hosting config change. |
| Google Fonts blocked / missing | MEDIUM | Self-host the font (see Pitfall 8). Update `index.html` and `Makefile`. One-time fix. |
| iOS storage evicted, app fetches on cold start | LOW | No recovery needed — app still works, just requires network. Accept as known behaviour. |
| `preventDefaultOn` breaks scroll in other views | LOW | Scope the attribute back to the scroll wheel column only. One-line fix in `Form/GroupMatches.elm`. |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Stale `main.js` after deploy | Phase 1 — Service Worker | Deploy a change, reload in standalone mode, verify new UI appears |
| `sw.js` missing from build | Phase 1 — Makefile | `ls build/sw.js` after `make build` |
| No iOS install prompt guidance | Phase 1 — Manifest + Meta Tags | Test on real iPhone: no install banner, but in-app tip visible |
| iOS storage eviction (7-day limit) | Phase 1 — scoping | Document in `sw.js` comments; no code fix needed |
| iOS history lost on restart | Phase 2 — Mobile UX awareness | Note in UAT; accept or add `localStorage` card index |
| Score inputs missing `inputmode` | Phase 2 — Score Input UX | Inspect rendered HTML on iOS DevTools; keyboard type observed |
| Monospace overflow on 320px | Phase 2 — Group Matches Layout | DevTools responsive mode at 320px; no horizontal scroll |
| Google Fonts offline failure | Phase 1 — App Shell + Font Self-Hosting | Disable network in DevTools; Sometype Mono renders correctly |
| `preventDefaultOn` scope leak | Phase 2 — Touch Event Audit | Test activities feed scroll on iOS after navigating form |
| Bracket stepper overflow on phone | Phase 3 — Bracket Wizard Layout | DevTools at 375px; no overflow, stepper readable |
| Manifest `start_url` fragment issue | Phase 1 — Manifest | Add to iOS home screen; verify standalone launch goes to Home |

---

## Sources

- [Taming PWA Cache Behavior — Infinity Interactive](https://iinteractive.com/resources/blog/taming-pwa-cache-behavior)
- [iOS Safari PWA Limitations — Vinova SG](https://vinova.sg/navigating-safari-ios-pwa-limitations/)
- [PWA on iOS 2025 — Brainhub](https://brainhub.eu/library/pwa-on-ios)
- [PWA iOS Limitations and Safari Support — MagicBell](https://www.magicbell.com/blog/pwa-ios-limitations-safari-support-complete-guide)
- [The Service Worker Lifecycle — web.dev](https://web.dev/articles/service-worker-lifecycle)
- [Service Worker Update Strategies — web.dev](https://web.dev/learn/pwa/update)
- [Stuff I Wish I'd Known About Service Workers — Rich Harris (GitHub Gist)](https://gist.github.com/Rich-Harris/fd6c3c73e6e707e312d7c5d7d0f3b2f9)
- [finger-friendly numerical inputs with inputmode — CSS-Tricks](https://css-tricks.com/finger-friendly-numerical-inputs-with-inputmode/)
- [elm-ui overflow/scrolling issue #70 — mdgriffith/elm-ui](https://github.com/mdgriffith/elm-ui/issues/70)
- [iOS Safari history lost in standalone — remix-run/history #645](https://github.com/remix-run/history/issues/645)
- [PWA Bugs list — PWA-POLICE/pwa-bugs](https://github.com/PWA-POLICE/pwa-bugs)
- [iOS Safari 100vh address bar problem — DEV Community](https://dev.to/maciejtrzcinski/100vh-problem-with-ios-safari-3ge9)
- [Accessible tap target sizes — Smashing Magazine](https://www.smashingmagazine.com/2023/04/accessible-tap-target-sizes-rage-taps-clicks/)
- [Google Fonts caching with Service Workers — Go Make Things](https://gomakethings.com/improving-web-font-performance-with-service-workers/)
- [Making PWAs Installable — MDN](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Making_PWAs_installable)
- Codebase review: `src/index.html`, `src/Form/GroupMatches.elm`, `src/UI/Screen.elm`, `src/UI/Style.elm`, `Makefile`, `src/Form/Bracket/View.elm`

---

*Pitfalls research for: PWA + mobile UX on Elm 0.19.1 SPA with elm-ui, static hosting, iOS Safari*
*Researched: 2026-02-23*
