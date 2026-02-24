// Voetbalpool Service Worker
// Strategy: cache-first for app shell, network-only pass-through for /bets/ API requests.
// To update cached assets: bump CACHE_NAME (e.g. voetbalpool-v2).
// Do NOT add self.skipWaiting() — bumping CACHE_NAME is the correct update mechanism.
// WARNING: sw.js must be served with Cache-Control: no-cache in production so browsers
// detect updates. python3 -m http.server (local dev) sends no explicit cache headers — OK.

const CACHE_NAME = 'voetbalpool-v1';

// App shell: all same-origin static assets required for the app to load.
// MUST be same-origin paths only — cross-origin URLs cause cache.addAll() to fail atomically.
// List both '/' and '/index.html' to handle both navigation patterns.
const APP_SHELL = [
  '/',
  '/index.html',
  '/main.js',
  '/manifest.json',
  '/assets/fonts/fonts.css',
  '/assets/fonts/SometypeMono[wght].woff2',
  '/assets/fonts/SometypeMono-Italic[wght].woff2',
];

// INSTALL: pre-cache the app shell atomically.
// If any URL fails, the entire install fails and this SW is discarded — not activated.
self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      return cache.addAll(APP_SHELL);
    })
  );
});

// ACTIVATE: delete all caches that are not the current CACHE_NAME.
// event.waitUntil prevents the SW from activating until cleanup is complete.
self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheNames) {
      return Promise.all(
        cacheNames
          .filter(function (name) { return name !== CACHE_NAME; })
          .map(function (name) { return caches.delete(name); })
      );
    })
  );
});

// FETCH: network-only for /bets/ API; cache-first for everything else.
// Hash routing (#home, #formulier, etc.) never triggers a network fetch in the SW —
// fragment changes are handled entirely client-side by Elm after the initial HTML load.
self.addEventListener('fetch', function (event) {
  var url = new URL(event.request.url);

  // API pass-through: never cache /bets/ requests (dynamic data, auth tokens)
  if (url.pathname.startsWith('/bets/')) {
    return;
  }

  event.respondWith(
    caches.match(event.request).then(function (cached) {
      if (cached) {
        return cached;
      }
      return fetch(event.request).then(function (response) {
        // Only cache successful same-origin (basic) GET responses.
        // Do NOT cache opaque responses (type !== 'basic') — they may be errors
        // and inflate cache storage quota unpredictably.
        if (
          response.ok &&
          response.type === 'basic' &&
          event.request.method === 'GET'
        ) {
          var clone = response.clone();
          caches.open(CACHE_NAME).then(function (cache) {
            cache.put(event.request, clone);
          });
        }
        return response;
      });
    })
  );
});
