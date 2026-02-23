# Stack Research: PWA + Mobile UX for Elm 0.19.1 SPA

**Research date:** 2026-02-23
**Focus:** Adding PWA and mobile improvements to an existing Elm SPA

---

## Recommendation

**Vanilla service worker + static manifest.json** — no Workbox, no build tools.

The project uses a plain Makefile with `elm make`. There is no webpack, Vite, or npm pipeline. Workbox's CDN approach (`importScripts`) has documented limitations (can only be called during synchronous init or install handler). For a simple app-shell cache of 3 files (`index.html`, `main.js`, `assets/`), vanilla Cache API is simpler, more maintainable, and has zero external dependencies.

---

## Service Worker

**Approach:** Vanilla JS service worker at `src/sw.js`, copied to `build/sw.js` by Makefile.

**Cache strategy:** Cache-first for static assets. Network-only pass-through for API requests.

**Key implementation pattern:**

```javascript
const CACHE_NAME = 'tournaments-v1'; // Bump on each deploy
const PRECACHE_URLS = [
  '/',
  '/index.html',
  '/main.js',
  '/assets/fonts/SometypeMono.woff2', // self-hosted font (see pitfalls)
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(PRECACHE_URLS))
  );
  self.skipWaiting(); // Activate immediately
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  if (event.request.url.includes('/api/')) return; // Network-only for API
  event.respondWith(
    caches.match(event.request).then(cached => cached || fetch(event.request))
  );
});
```

**Registration in index.html:**

```html
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js');
  }
</script>
```

**CRITICAL:** `sw.js` must be at the root of the served directory. Service workers only control pages within their scope — a SW at `/build/sw.js` served from `/` is fine, but registration path must match scope.

---

## Web App Manifest

**File:** `src/manifest.json` → copied to `build/manifest.json`

**Required fields for installability (Android Chrome + iOS Safari):**

```json
{
  "name": "WK 2026",
  "short_name": "WK2026",
  "description": "Voorspel de uitslag van het WK 2026",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#1a1a1a",
  "theme_color": "#ff8c00",
  "icons": [
    { "src": "assets/icon-192.png", "sizes": "192x192", "type": "image/png", "purpose": "any" },
    { "src": "assets/icon-512.png", "sizes": "512x512", "type": "image/png", "purpose": "any" },
    { "src": "assets/icon-512-maskable.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ]
}
```

**Icon requirements:**
- 192×192 and 512×512 are the minimum for Chrome/Android installability
- Maskable icon: design with safe zone (central ~72% visible); use separate file, NOT `"purpose": "any maskable"` (discouraged)
- Non-transparent backgrounds required (transparent icons break on some OSes)
- PNG format, square aspect ratio

**HTML link tags in index.html:**

```html
<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#ff8c00">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
```

---

## Makefile Changes

Add two targets:

```makefile
build: build-directory html js assets manifest sw

manifest:
    cp src/manifest.json $(BUILD)/manifest.json

sw:
    cp src/sw.js $(BUILD)/sw.js
```

---

## iOS Safari Support

- Service workers supported since iOS 11.3 (2018), fully stable since iOS 16.4
- No automatic install prompt — users must use "Share → Add to Home Screen"
- Cache evicted after ~7 days of inactivity (iOS Safari limitation)
- HTTPS required for service worker registration (localhost exempted for dev)

---

## Font Self-Hosting (Critical)

The app currently loads Sometype Mono from `fonts.googleapis.com`. Service workers cannot cache cross-origin requests without CORS headers. The font must be self-hosted in `assets/fonts/` and referenced in `index.html` with a local `@font-face` or `<link>` tag for the app shell cache to work correctly.

**Confidence:** High — this is standard PWA practice, well-documented.

---

*Stack research: 2026-02-23 (written from researcher web search outputs)*
