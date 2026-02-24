# Phase 1: PWA Infrastructure - Research

**Researched:** 2026-02-24
**Domain:** Progressive Web App infrastructure — web app manifest, service worker, self-hosted fonts, Makefile wiring
**Confidence:** HIGH

---

## Summary

This phase adds the static-file layer that turns the existing Elm SPA into a PWA: a self-hosted font, a `manifest.json`, app icons, a vanilla service worker, and the Makefile targets to copy everything into `build/`. No Elm code changes are required except one line in `index.html` (the SW registration script) and the meta/link tags for PWA hints. All work is in `src/`, `assets/`, and `Makefile`.

The current `index.html` loads Sometype Mono from Google Fonts via two `<link>` preconnect tags and one `<link href="https://fonts.googleapis.com/...">` stylesheet. Those three lines must be replaced with a local `@font-face` `<style>` block or a `<link rel="stylesheet" href="fonts.css">` pointing at files in `assets/fonts/`. Removing the cross-origin font request unblocks the service worker's ability to cache the complete app shell in a single install pass — if any precached URL throws a network error at install time, the whole install fails and the SW is discarded.

The service worker for this app is intentionally simple: cache-first for a small whitelist of app-shell assets (index.html, main.js, fonts), network-only pass-through for all `/bets/` API requests. No Workbox, no build-step asset injection. The cache list is hand-maintained and versioned via a string constant (`CACHE_NAME`). Bumping that string is the only mechanism needed to invalidate old caches and re-fetch assets.

**Primary recommendation:** Hand-write a single `src/sw.js` (~60 lines), download the Sometype Mono variable woff2 files from the official Google Fonts GitHub repository, and add `manifest.json` and icons to `assets/`. No npm dependencies are introduced.

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| PWA-01 | Sometype Mono font self-hosted in `assets/fonts/` with local `@font-face` — eliminates cross-origin font dependency that blocks app-shell caching | Font files confirmed available as woff2 from `googlefonts/sometype-mono`; variable font `SometypeMono[wght].woff2` covers 400–700 in one file |
| PWA-02 | `src/manifest.json` with required fields (`name`, `short_name`, `start_url`, `display`, `background_color`, `theme_color`, icons array) | All required manifest fields verified against MDN and web.dev; exact JSON structure documented in Code Examples |
| PWA-03 | PNG icons: 192×192 (any), 512×512 (any), 512×512 (maskable); plus `apple-touch-icon.png` at 180×180 | Icon size requirements verified via MDN and Chrome Lighthouse docs; apple-touch-icon still required separately for iOS |
| PWA-04 | `src/sw.js` vanilla service worker: cache-first for app shell, network-only for `/bets/` requests, versioned CACHE_NAME, old cache cleanup | Pattern verified against MDN service worker API docs; hash-routing means no navigation-fallback complexity |
| PWA-05 | `src/index.html` updated: manifest link, theme-color meta, apple PWA metas, SW registration script | Exact meta tags verified; `navigator.standalone` pattern documented for future iOS install-tip use |
| PWA-06 | Makefile `build` target copies `src/manifest.json` and `src/sw.js` to `build/` | Existing Makefile pattern is `cp src/index.html build/index.html`; same pattern applies |
</phase_requirements>

---

## Standard Stack

### Core

| Item | Version/Source | Purpose | Why Standard |
|------|---------------|---------|--------------|
| Web App Manifest (`manifest.json`) | W3C spec, all modern browsers | Tells browsers the app is installable, provides name/icons/colors | Required by Chrome/Android install criteria; Safari 16.4+ reads it for iOS |
| Vanilla Service Worker (`sw.js`) | Browser API, no library | Intercepts fetch, caches app shell, enables offline load | No Workbox needed for a small static whitelist; zero build-step dependencies |
| Sometype Mono woff2 (variable) | `googlefonts/sometype-mono` repo | Self-hosted web font | OFL license, single variable file covers all weights 400–700 |
| PNG icons (192, 512, 512-maskable) | Hand-crafted or tool-generated | Android home screen, splash screen, adaptive icon | Chrome requires exactly these two sizes for installability |
| `apple-touch-icon.png` (180×180) | Hand-crafted | iOS Safari "Add to Home Screen" icon | Manifest icons are not used by iOS; this tag is still required |

### No npm packages introduced

This phase adds zero JavaScript dependencies. Everything is hand-written files copied by Makefile.

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Vanilla `sw.js` | Workbox | Workbox provides auto-precache manifest injection via build tool. This project uses a plain Makefile with no Node build step, making Workbox setup disproportionately complex. Vanilla is correct here. |
| Variable woff2 (one file) | Static weight files (Regular, Bold, Italic…) | Variable font `SometypeMono[wght].woff2` is ~70 KB and covers all weights 400–700. Six static woff2 files would total more bytes. Use the variable font. |
| `<style>` block in index.html | Separate `fonts.css` file | Either works. Inline `<style>` means one fewer cacheable resource; a separate `fonts.css` is cleaner and can be listed in the SW cache list independently. Separate file is recommended. |

---

## Architecture Patterns

### Resulting File Layout

```
src/
  index.html          # updated: manifest link, meta tags, font link, SW registration
  manifest.json       # NEW: web app manifest
  sw.js               # NEW: service worker
assets/
  fonts/
    SometypeMono[wght].woff2          # NEW: upright variable font (400–700)
    SometypeMono-Italic[wght].woff2   # NEW: italic variable font (400–700)
    fonts.css                         # NEW: @font-face declarations
  icon-192.png         # NEW: 192×192 icon (purpose: any)
  icon-512.png         # NEW: 512×512 icon (purpose: any)
  icon-512-maskable.png # NEW: 512×512 icon (purpose: maskable)
  apple-touch-icon.png  # NEW: 180×180 for iOS Safari
  gradient.png         # existing
  svg/                 # existing
build/                 # generated by make build
  manifest.json        # copied from src/
  sw.js                # copied from src/
  assets/              # copied from assets/ (includes fonts/)
  index.html           # copied from src/
  main.js              # compiled from src/Main.elm
```

### Pattern 1: Versioned Cache-First Service Worker

**What:** The SW maintains a named cache (`voetbalpool-v1`). On `install`, it opens the cache and fetches the entire whitelist. On `activate`, it deletes any cache whose name differs from the current `CACHE_NAME`. On `fetch`, it checks the cache first; on a miss (or for `/bets/` URLs), it goes to the network.

**When to use:** Any SPA with a small, known set of static assets and a backend API that must never be cached.

**Example:**
```javascript
// src/sw.js
// Source: MDN Service Worker API (https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers)

const CACHE_NAME = 'voetbalpool-v1';

const APP_SHELL = [
  '/',
  '/index.html',
  '/main.js',
  '/assets/fonts/fonts.css',
  '/assets/fonts/SometypeMono[wght].woff2',
  '/assets/fonts/SometypeMono-Italic[wght].woff2',
  '/manifest.json',
];

// INSTALL: pre-cache the app shell atomically.
// If any URL fails, the whole install fails and this SW is discarded.
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
  );
});

// ACTIVATE: delete all caches that are not the current CACHE_NAME.
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((key) => key !== CACHE_NAME)
          .map((key) => caches.delete(key))
      )
    )
  );
});

// FETCH: network-only for /bets/ API; cache-first for everything else.
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // API pass-through: never cache /bets/ requests
  if (url.pathname.startsWith('/bets/')) {
    return; // let browser handle normally
  }

  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;
      return fetch(event.request).then((response) => {
        // Only cache successful same-origin responses
        if (
          response.ok &&
          response.type === 'basic' &&
          event.request.method === 'GET'
        ) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone));
        }
        return response;
      });
    })
  );
});
```

**Hash-routing note:** This Elm app uses fragment-based routing (`#home`, `#formulier`, `#stand`, etc.). Fragment changes never trigger a network navigation request — the browser never sends a new HTTP request when only the hash changes. This means the service worker does **not** need a navigation-fallback pattern. The SW only sees the initial `GET /` (or `GET /index.html`) request; all routing is handled client-side by Elm after that single HTML fetch.

### Pattern 2: Self-Hosted Variable Font via @font-face

**What:** Serve the woff2 variable font files from `assets/fonts/` and declare them with `@font-face` in a local `fonts.css`. Remove the three Google Fonts `<link>` tags from `index.html`.

**Example:**
```css
/* assets/fonts/fonts.css */
/* Source: MDN Variable Fonts (https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Fonts/Variable_fonts) */

@font-face {
  font-family: 'Sometype Mono';
  src: url('SometypeMono[wght].woff2') format('woff2');
  font-weight: 400 700;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'Sometype Mono';
  src: url('SometypeMono-Italic[wght].woff2') format('woff2');
  font-weight: 400 700;
  font-style: italic;
  font-display: swap;
}
```

```html
<!-- src/index.html — replaces the three Google Fonts <link> tags -->
<link rel="stylesheet" href="assets/fonts/fonts.css" />
```

### Pattern 3: Web App Manifest

**What:** A JSON file linked from `<head>` that declares the app's identity for browser install prompts and home screen entries.

**Example:**
```json
// src/manifest.json
// Source: MDN Making PWAs installable (https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Making_PWAs_installable)
{
  "name": "Voetbalpool",
  "short_name": "Voetbalpool",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0d0d0d",
  "theme_color": "#ff8c00",
  "description": "Voorspel de uitslag van WK 2026 wedstrijden",
  "icons": [
    {
      "src": "assets/icon-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any"
    },
    {
      "src": "assets/icon-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any"
    },
    {
      "src": "assets/icon-512-maskable.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

Note: `background_color` should match the existing `body` style in `index.html` (`#0d0d0d`). The `theme_color` matches the existing orange accent (`#ff8c00` from `UI.Style`).

### Pattern 4: index.html Head Tags

**What:** The `<head>` of `index.html` needs a manifest link, theme-color meta, iOS-specific metas, and the SW registration script. The Google Fonts preconnect and stylesheet links are removed.

**Example:**
```html
<!-- src/index.html <head> — full updated head section -->
<head>
  <meta charset="UTF-8" />
  <title>Voetbalpool</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <!-- PWA manifest -->
  <link rel="manifest" href="manifest.json" />

  <!-- Theme color (Android Chrome toolbar, task switcher) -->
  <meta name="theme-color" content="#ff8c00" />

  <!-- iOS Safari PWA hints -->
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
  <meta name="apple-mobile-web-app-title" content="Voetbalpool" />
  <link rel="apple-touch-icon" href="assets/apple-touch-icon.png" />

  <!-- Self-hosted font (replaces Google Fonts links) -->
  <link rel="stylesheet" href="assets/fonts/fonts.css" />

  <!-- Elm app bundle -->
  <script type="text/javascript" src="main.js"></script>
</head>
```

### Pattern 5: Makefile Extension

**What:** Two extra `cp` commands in the existing `build` target, and declarations in `.PHONY`.

**Example:**
```makefile
# In Makefile — extend the existing build target and add pwa subtarget

build: build-directory html js assets pwa

pwa:
	echo "Copying PWA files..."
	cp $(SRC)/manifest.json $(BUILD)/manifest.json
	cp $(SRC)/sw.js $(BUILD)/sw.js
```

### Pattern 6: Service Worker Registration Script

**What:** Inline `<script>` at the bottom of `index.html` that registers `sw.js` after Elm initialises. Must come after the existing Elm init script.

**Example:**
```html
<!-- src/index.html — add after existing Elm init <script> block -->
<script>
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function () {
      navigator.serviceWorker.register('/sw.js', { scope: '/' })
        .catch(function (err) {
          console.warn('SW registration failed:', err);
        });
    });
  }
</script>
```

### Anti-Patterns to Avoid

- **Listing Google Fonts URL in the SW cache:** The cross-origin `fonts.googleapis.com` stylesheet cannot be precached during `install` because it requires an opaque response. The whole install will fail. Remove the Google Fonts links entirely; this is why self-hosting is required first.
- **Using `self.skipWaiting()` carelessly:** For this app, bumping `CACHE_NAME` is the correct update mechanism. The new SW installs and waits until all tabs close. Adding `skipWaiting()` + `clients.claim()` activates the new SW mid-session, potentially serving `main.js` from a new cache while `index.html` is still loaded from a stale tab — mismatched asset versions. Omit `skipWaiting()` for this simple case.
- **Caching opaque responses:** Responses from cross-origin requests without CORS headers have `type: 'opaque'` and cannot be inspected. Only cache `response.type === 'basic'` (same-origin) responses.
- **Not calling `event.waitUntil` in activate:** Without `event.waitUntil`, the old cache deletion may be interrupted mid-way. Always wrap cache cleanup in `event.waitUntil`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Icon generation at multiple sizes | Manual pixel editing of every icon | Use a vector source (SVG) and a tool like `maskable.app` or ImageMagick `convert` to export all sizes at once | Consistent rendering at 192, 512, and 180 from one source |
| Font subsetting | Re-encoding the woff2 to reduce size | The variable woff2 from Google Fonts GitHub is already optimally compressed for Latin | Latin subset is the only one needed; the file is already small |
| SW update notification UI | Custom polling or timer | Simply bump `CACHE_NAME` string — the browser handles SW update detection automatically | Browser polls the SW file every 24h and on navigation; no custom logic needed |

**Key insight:** PWA infrastructure for a static Elm SPA is almost entirely declarative (JSON, HTML attributes, a short JS file). The complexity lives in the browser, not in code you write.

---

## Common Pitfalls

### Pitfall 1: Cross-Origin Font Blocks SW Install

**What goes wrong:** `sw.js` lists `https://fonts.googleapis.com/...` in `APP_SHELL`. The `cache.addAll()` call during `install` attempts to fetch it. Google Fonts returns an opaque response (no CORS on the CSS endpoint for credentialed requests); `cache.addAll()` rejects and the entire SW install fails silently. The app never becomes installable.

**Why it happens:** `cache.addAll()` is atomic — one failure aborts all caching and discards the SW. Cross-origin URLs without CORS cannot be stored in the cache from `addAll()`.

**How to avoid:** Complete PWA-01 (self-hosted fonts) before writing the SW cache list. The SW must only list same-origin paths.

**Warning signs:** Chrome DevTools Application > Service Workers shows "Install failed"; cache storage is empty after a page load.

### Pitfall 2: SW Served with Wrong MIME Type or Long Cache

**What goes wrong:** The web server (e.g. `python3 -m http.server`) may serve `sw.js` with a very long `Cache-Control: max-age`. The browser then fails to detect SW updates because it always serves the cached version.

**Why it happens:** `sw.js` must always be fetched fresh from the network so the browser can detect byte-level changes and trigger a new install cycle.

**How to avoid:** Serve `sw.js` with `Cache-Control: no-cache` or `max-age=0`. For local development `python3 -m http.server` serves no explicit cache headers, so this is fine locally. Verify on the real host.

**Warning signs:** Updating `CACHE_NAME` in `sw.js` and deploying does not trigger a new SW install.

### Pitfall 3: SW Scope Does Not Cover the App

**What goes wrong:** The `register('/sw.js', { scope: '/' })` call fails with a scope error if `sw.js` is not at the root of the origin. Alternatively, registering from a subdirectory without explicit scope means the SW only controls that subdirectory.

**Why it happens:** A SW can only control pages within its own scope. If `sw.js` is at `/app/sw.js`, its default scope is `/app/` not `/`.

**How to avoid:** Keep `sw.js` at `src/sw.js` (copied to `build/sw.js` = served at `/sw.js`). Register with explicit `scope: '/'`.

**Warning signs:** SW registers but fetch events for `/index.html` are not intercepted.

### Pitfall 4: iOS Ignores Manifest Icons — Shows Globe

**What goes wrong:** An `apple-touch-icon` tag is missing. iOS Safari generates a screenshot-based icon (blurry, dark, shows page content) instead of the crisp icon.

**Why it happens:** iOS does not use the `icons` array from `manifest.json` for the home screen icon. It only reads `<link rel="apple-touch-icon">`.

**How to avoid:** Add `<link rel="apple-touch-icon" href="assets/apple-touch-icon.png" />` and a 180×180 PNG to `assets/`.

**Warning signs:** After "Add to Home Screen" on iOS, icon shows a blurry screenshot or generic globe.

### Pitfall 5: Maskable Icon Content Outside Safe Zone

**What goes wrong:** The 512×512 maskable icon has its logo touching the edges. On Android, the OS clips the icon into a circle/squircle, cutting off the design.

**Why it happens:** Android applies a mask shape that removes the outer ~20% of the icon.

**How to avoid:** Keep all meaningful content within the inner circle whose diameter is 80% of the icon's width (i.e. within a centred 410×410 area on a 512×512 canvas). The background colour must fill the entire 512×512 square.

**Warning signs:** Home screen icon on Android looks cut off or has unexpected shapes.

### Pitfall 6: Cache List Path Mismatch

**What goes wrong:** The SW lists `/index.html` but the browser navigates to `/`. `caches.match(request)` returns `undefined` for `/` because the cache key is the full request URL including path.

**Why it happens:** `cache.addAll(['/index.html'])` stores with key `https://example.com/index.html`. A navigation fetch for `https://example.com/` is a different key.

**How to avoid:** List both `'/'` and `'/index.html'` in `APP_SHELL`. Alternatively, use `caches.match(event.request, { ignoreSearch: true })`. Listing both is simpler.

---

## Code Examples

### Service Worker Registration (index.html)

```html
<!-- Source: MDN Service Worker API https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers -->
<script>
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function () {
      navigator.serviceWorker.register('/sw.js', { scope: '/' })
        .catch(function (err) {
          console.warn('SW registration failed:', err);
        });
    });
  }
</script>
```

### Detecting iOS Standalone Mode (future use — STATE.md blocker)

```javascript
// Source: web.dev PWA Detection https://web.dev/learn/pwa/detection
// Pass as Elm flag: flags.isStandalone
var isStandalone = window.navigator.standalone === true;

var app = Elm.Main.init({
  flags: {
    formId: null,
    width: window.innerWidth,
    height: window.innerHeight,
    // isStandalone: isStandalone  // add if Elm Flag type is extended later
  },
});
```

Note: STATE.md records an open concern about showing an iOS install tip via `navigator.standalone`. The Elm `Flags` type currently has `{ formId, width, height }`. Adding `isStandalone` is out of scope for Phase 1 — document the detection pattern here for the planner to note.

### Old Cache Cleanup Pattern

```javascript
// Source: MDN Using Service Workers
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) =>
      Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      )
    )
  );
});
```

### ImageMagick: Generate Icons from a Source PNG

```bash
# Generate all required icon sizes from a high-res source (≥512px)
convert source-logo.png -resize 192x192 assets/icon-192.png
convert source-logo.png -resize 512x512 assets/icon-512.png
convert source-logo.png -resize 512x512 assets/icon-512-maskable.png  # then add background in an editor
convert source-logo.png -resize 180x180 assets/apple-touch-icon.png
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Service worker required for Chrome install prompt | Manifest alone is sufficient (Chrome 108+ mobile, 112+ desktop) | 2022–2023 | SW is still needed for caching/offline, but not for the install badge |
| Multiple `apple-touch-icon` sizes (57, 72, 114, 120, 144, 152, 180) | Single 180×180 is enough; iOS auto-scales | iOS 8+ | Eliminates icon size matrix |
| `purpose: "any maskable"` (combined purpose in one icon) | Separate icons with `purpose: "any"` and `purpose: "maskable"` | ~2021 | Better control; some tools still accept combined but separate is recommended |
| Google Fonts hosted fonts | Self-hosted woff2 for privacy, caching, and reliability | Ongoing best practice | Enables full offline app shell caching |

**Deprecated/outdated:**
- `apple-mobile-web-app-capable`: Still works as a fallback on iOS but Apple now prefers the manifest `display` field. Include it for backwards compat with iOS <16.4.
- Multiple `apple-touch-icon` size variants: Not needed; single 180×180 suffices.
- `cache.addAll()` with cross-origin URLs: Never worked reliably; self-host everything in the precache list.

---

## Open Questions

1. **Icon source artwork**
   - What we know: The project has `assets/gradient.png` and many SVG flag icons but no app-logo artwork.
   - What's unclear: What should the home screen icon look like? A football? Text "WC26"? The gradient?
   - Recommendation: The planner should treat icon creation as a task requiring a decision. A simple approach: use ImageMagick to place orange text "WC26" on the dark background (`#0d0d0d`). The planner can make this a concrete task.

2. **`navigator.standalone` as Elm flag**
   - What we know: STATE.md notes that an in-app install tip for iOS is a known concern; `navigator.standalone` is the detection mechanism.
   - What's unclear: Whether Phase 1 should extend the `Flags` type to include `isStandalone : Bool`.
   - Recommendation: Out of scope for Phase 1 per REQUIREMENTS.md (Out of Scope list excludes advanced iOS integration). The SW registration script can read `navigator.standalone` in plain JS without Elm involvement. Leave `Flags` unchanged.

3. **Production server Cache-Control for sw.js**
   - What we know: The build output is served by `python3 -m http.server` for local dev; production host is unknown.
   - What's unclear: Whether the production host sets long `Cache-Control` on `.js` files, which would prevent SW updates from propagating.
   - Recommendation: Add a note in the task that `sw.js` must be served with `Cache-Control: no-cache` in production. This is a hosting concern, not a code concern — flag it as a post-deploy check.

---

## Sources

### Primary (HIGH confidence)

- MDN Service Worker API / Using Service Workers — https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers — install/activate/fetch lifecycle, `cache.addAll`, cache cleanup pattern
- MDN Making PWAs Installable — https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Making_PWAs_installable — exact required manifest fields, HTTPS requirement, service worker not required for install since Chrome 108
- web.dev Add Manifest — https://web.dev/articles/add-manifest — manifest JSON structure, background_color, theme_color, icon requirements
- web.dev Install Criteria — https://web.dev/articles/install-criteria — user engagement heuristics, `prefer_related_applications`, exact icon sizes
- web.dev Handling Navigation Requests — https://web.dev/articles/handling-navigation-requests — app shell pattern, hash routing not intercepted by SW fetch
- MDN Variable Fonts — https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Fonts/Variable_fonts — `@font-face` with `font-weight: 400 700` range syntax
- Google Fonts GitHub `googlefonts/sometype-mono` — exact file names confirmed: `SometypeMono[wght].woff2`, `SometypeMono-Italic[wght].woff2`; OFL license
- Chrome Lighthouse apple-touch-icon — https://developer.chrome.com/docs/lighthouse/pwa/apple-touch-icon — 180×180 requirement, separate from manifest

### Secondary (MEDIUM confidence)

- web.dev PWA Detection — https://web.dev/learn/pwa/detection — `window.navigator.standalone` for iOS standalone detection (verified by multiple sources)
- browserux.com Web Icons 2025 — https://browserux.com/blog/guides/web-icons/touch-adaptive-icons-manifest.html — iOS does not read manifest icons, apple-touch-icon still required
- MDN Maskable Icons / Progressier Maskable Editor — 80% safe-zone rule (inner 410×410 on 512×512); verified by multiple icon guides
- Chrome Developers blog: Revisiting installability criteria — https://developer.chrome.com/blog/update-install-criteria — confirms SW with fetch handler no longer required for install prompt

### Tertiary (LOW confidence)

- Apple Developer Archive (Configuring Web Applications) — https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html — referenced but archive doc may lag current iOS behavior; cross-verified with multiple 2025 sources

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all required technologies (manifest, SW, woff2) are stable browser APIs verified against MDN and official docs
- Architecture: HIGH — cache list, font @font-face, and Makefile patterns are straightforward; confirmed against MDN and official GitHub
- Pitfalls: HIGH — cross-origin cache blockage and iOS icon fallback are well-documented, verified across multiple authoritative sources
- Icon creation: MEDIUM — exact artwork is a project-specific decision; technical requirements (sizes, safe zone) are HIGH confidence

**Research date:** 2026-02-24
**Valid until:** 2026-03-24 (PWA specs are stable; manifest and SW APIs change slowly)
