# Architecture Research

**Domain:** PWA integration + mobile layout for Elm 0.19.1 SPA
**Researched:** 2026-02-23
**Confidence:** HIGH

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Browser (Client)                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  index.html  │  │    sw.js     │  │   manifest.json      │  │
│  │  (shell)     │  │ (SW, cached) │  │   (PWA metadata)     │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────────────────┘  │
│         │                  │                                      │
│  ┌──────▼───────────────────────────────────────────────────┐   │
│  │                   main.js (Elm app)                       │   │
│  │  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐ │   │
│  │  │ UI.Screen   │  │  Form.View   │  │  Form/*         │ │   │
│  │  │ Device Phone│  │  (chrome)    │  │  (card views)   │ │   │
│  │  │ /Computer   │  └──────────────┘  └─────────────────┘ │   │
│  │  └─────────────┘                                         │   │
│  └──────────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────────┤
│                     Service Worker Cache                         │
│  ┌────────────────┐  ┌───────────────┐  ┌──────────────────┐   │
│  │  main.js       │  │ index.html    │  │  assets/         │   │
│  │  (app shell)   │  │  (shell)      │  │  (SVG flags)     │   │
│  └────────────────┘  └───────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Implementation |
|-----------|----------------|----------------|
| `src/sw.js` | App-shell caching; cache-first for static assets; network-first for API | Plain JS service worker, copied to `build/sw.js` by Makefile |
| `src/manifest.json` | PWA metadata (name, icons, theme color, display mode) | Static JSON, copied to `build/manifest.json` by Makefile |
| `src/index.html` | Register service worker; link manifest; initialize Elm with flags | Existing file; add `<link rel="manifest">` and SW registration script |
| `UI.Screen` | Device detection (`Phone | Computer`) via viewport width breakpoint | Existing; breakpoint at 500px; `Phone` if `screen.width < 500` |
| `UI.Style` | All layout attributes (padding, sizing, font sizes) | Existing; mobile adjustments go here as new functions or extra params |
| `Form.GroupMatches` | Score input and scroll wheel — most touch-sensitive UI | Existing; score input `width (px 45)` and `paddingXY 4 16` may need larger touch targets |
| `Form.Bracket.View` | Bracket wizard — team selection and round stepper | Existing; grid rows wrap via `List.Extra.greedyGroupsOf 8`; may need fewer columns on phone |
| `Form.View` | Form chrome: nav buttons, top checkboxes | Existing; `< vorige`/`volgende >` buttons need min-height 44px on mobile |

## Recommended Project Structure

```
src/
├── sw.js                   # Service worker (new — copied to build/)
├── manifest.json           # Web app manifest (new — copied to build/)
├── index.html              # Modified: add manifest link + SW registration
├── UI/
│   ├── Screen.elm          # Existing; Device type used for conditional layout
│   ├── Style.elm           # Existing; add mobile-aware attribute helpers
│   └── Font.elm            # Existing; scaled sizes already relative (modular 16 1.25)
├── Form/
│   ├── View.elm            # Existing; nav buttons may need touch-target padding
│   ├── GroupMatches.elm    # Existing; score inputs may need wider touch areas
│   └── Bracket/
│       └── View.elm        # Existing; team grid may need narrower grouping on phone
└── View.elm                # Existing; global nav wraps fine on mobile via wrappedRow
```

### Structure Rationale

- **`src/sw.js` and `src/manifest.json`**: New source files live in `src/` alongside `index.html`. The Makefile's `html` and `assets` targets already copy from `src/` to `build/`; adding two `cp` rules is all that's needed.
- **`src/UI/`**: All mobile layout changes stay in the existing style system. No new modules required — `UI.Screen.device` already provides the `Phone | Computer` discriminator for conditional attributes.
- **`src/Form/`**: Card-specific layout changes are isolated to their own view functions. The `model.screen` value is available in `Form.View.viewCardChrome` and can be threaded to child views.

## Architectural Patterns

### Pattern 1: App-Shell Service Worker (Cache-First Static, Network-First API)

**What:** The service worker caches `index.html`, `main.js`, and `assets/` on install. On fetch, static assets are served from cache (cache-first); API requests to the backend always go to the network (network-first or network-only).

**When to use:** Static SPA with a separate backend API. This project has no backend serving HTML — all app files are static.

**Trade-offs:** Fast subsequent loads; requires cache busting (versioned cache name) on deploy; API calls always need network (acceptable per project constraints).

**Example:**
```javascript
// src/sw.js
const CACHE_NAME = 'voetbalpool-v2026-1';
const SHELL_ASSETS = ['/', '/index.html', '/main.js', '/assets/'];

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME).then(cache => cache.addAll(SHELL_ASSETS))
    );
});

self.addEventListener('fetch', event => {
    // API requests: network only
    if (event.request.url.includes('/api/')) {
        return;  // browser handles it directly
    }
    // Static assets: cache first, fallback to network
    event.respondWith(
        caches.match(event.request).then(cached => cached || fetch(event.request))
    );
});
```

### Pattern 2: Manifest-Linked PWA Install

**What:** `manifest.json` at the build root declares app name, theme color, icons, and `display: standalone`. Linked from `<head>` in `index.html`. No Elm changes required.

**When to use:** Any static SPA that should be installable on iOS/Android home screen.

**Trade-offs:** Requires at least one icon at 192x192 and one at 512x512 (PNG). The existing `assets/` directory should hold these icons.

**Example (manifest.json):**
```json
{
  "name": "Voetbalpool WK 2026",
  "short_name": "Voetbalpool",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#0d0d0d",
  "theme_color": "#ff8c00",
  "icons": [
    { "src": "/assets/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/assets/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

**index.html additions:**
```html
<link rel="manifest" href="manifest.json" />
<meta name="theme-color" content="#ff8c00" />
<!-- After Elm init: -->
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js');
  }
</script>
```

### Pattern 3: elm-ui Conditional Attributes via Device Discriminator

**What:** `UI.Screen.device : Size -> Device` returns `Phone | Computer`. View functions that need mobile-specific sizing receive the `model.screen` value and branch on `device screen`.

**When to use:** When a layout element needs different sizing on phones vs. desktops (e.g., taller touch targets, wider score inputs, narrower bracket columns).

**Trade-offs:** `model.screen` must be threaded into view functions that need it; currently `Form.View.viewCardChrome` already has `model` in scope, so child views can receive `model.screen` without a model change.

**Example:**
```elm
-- In UI.Screen (already exists):
device : Size -> Device
device screen =
    if screen.width < 500 then Phone else Computer

-- Usage in Form.GroupMatches.viewInput:
viewInput : Screen.Size -> MatchID -> Team -> Team -> Maybe Score -> Element Msg
viewInput screen matchID homeTeam awayTeam mScore =
    let
        inputWidth =
            case Screen.device screen of
                Screen.Phone -> px 60
                Screen.Computer -> px 45

        touchPadding =
            case Screen.device screen of
                Screen.Phone -> paddingXY 8 12
                Screen.Computer -> paddingXY 4 8
    in
    ...
```

## Data Flow

### Service Worker Registration Flow

```
Browser loads index.html
    ↓
<script> runs: navigator.serviceWorker.register('/sw.js')
    ↓
SW installs: caches index.html, main.js, assets/
    ↓
SW activates: old caches deleted
    ↓
Subsequent loads: SW intercepts fetch → returns cached shell
    ↓
Elm app boots from cached main.js → API calls go to network
```

### Mobile Layout Flow

```
Browser starts → window.innerWidth passed as flag to Elm init
    ↓
Main.init: model.screen = Screen.size flags.width flags.height
    ↓
View renders: model.screen threaded to viewCard, viewCardChrome
    ↓
Screen.device model.screen → Phone | Computer
    ↓
Conditional attrs applied (touch target sizes, input widths, column counts)
    ↓
Browser resize → ScreenResize msg → model.screen updated → view re-renders
```

### Key Data Flows

1. **PWA install flow:** manifest linked from `<head>` → browser checks icons/criteria → "Add to Home Screen" prompt shown automatically by browser when criteria met (https, SW, manifest with icons).
2. **Cache busting:** Change `CACHE_NAME` constant in `sw.js` on each deploy → old cache deleted during `activate` event → fresh assets fetched.
3. **Screen size to view:** `model.screen : Screen.Size` flows from `Main.init` through `model` → `Form.View.viewCardChrome model card i` already receives the full model; child view functions that need mobile variants receive `model.screen` as an additional argument.

## Build Order Implications

### Makefile Changes Required

The current `build` target is:

```makefile
build: build-directory html js assets
```

Two additions are needed:

```makefile
build: build-directory html js assets manifest sw

manifest:
    echo "Copying manifest..."
    cp src/manifest.json $(BUILD)/manifest.json

sw:
    echo "Copying service worker..."
    cp src/sw.js $(BUILD)/sw.js
```

**Order constraints:**
- `manifest` and `sw` have no dependency on `js` — they can run in any order relative to each other.
- Both must run before serving; the `build` target dependency list enforces this.
- `sw.js` must be at the **root** of the served directory (`build/sw.js`), not inside a subdirectory, so the service worker scope covers the entire app. This is already correct since `build/` is the served root.

### No Elm Compiler Changes Required

- Service worker and manifest are pure JS/JSON — the Elm compiler (`elm make`) is not involved.
- Mobile layout changes in Elm are attribute-level changes (`px 60` vs `px 45`) — no new modules, no new dependencies, no `elm.json` changes.
- The only Elm change needed is threading `model.screen` into view functions that currently don't receive it.

## Elm Module Change Surface

| File | Change Type | What Changes |
|------|-------------|--------------|
| `src/index.html` | Addition | `<link rel="manifest">`, `<meta name="theme-color">`, SW registration script |
| `src/Form/GroupMatches.elm` | Mobile layout | `viewInput` score field widths and padding; touch target height |
| `src/Form/Bracket/View.elm` | Mobile layout | `viewGroup` team grid columns (`greedyGroupsOf 8` → `greedyGroupsOf 4` on Phone); `viewRoundStepper` connector spacing |
| `src/Form/View.elm` | Mobile layout | `viewCardChrome` nav button padding; thread `model.screen` to child views that need it |
| `src/UI/Style.elm` | Mobile layout | New `buttonActiveTouch` or parameterize existing `buttonActive` with minimum height |
| `src/UI/Screen.elm` | No change needed | `Device` type and `device` function already exist and are correct |

**Files that do NOT change:**
- `src/Main.elm` — screen size already tracked via `ScreenResize` subscription
- `src/Types.elm` — `Model` already has `screen : Screen.Size`
- `src/Bets/` — domain logic is layout-agnostic
- `src/Results/` — results views are read-only; mobile improvements are out of scope for this milestone

## Anti-Patterns

### Anti-Pattern 1: Putting sw.js Inside a Subdirectory

**What people do:** Place `sw.js` at `build/assets/sw.js` or any non-root path.
**Why it's wrong:** A service worker's scope is limited to its path prefix. A worker at `/assets/sw.js` can only intercept requests under `/assets/` — it cannot cache `index.html` or `main.js` at the root.
**Do this instead:** Always place `sw.js` at `build/sw.js` (the root of the served directory).

### Anti-Pattern 2: Caching API Responses in the App-Shell Worker

**What people do:** Add the backend API base URL to the `SHELL_ASSETS` list or cache all fetch responses.
**Why it's wrong:** Tournament data (rankings, match results) changes during the tournament. Caching API responses causes stale data. The project explicitly keeps "offline data cache" out of scope.
**Do this instead:** Only cache static shell files. All API requests (`/api/...`) bypass the cache and go directly to the network.

### Anti-Pattern 3: Using CSS Media Queries Instead of elm-ui Device Branching

**What people do:** Add a `<style>` block or CSS file with `@media (max-width: 500px)` rules to override elm-ui generated styles.
**Why it's wrong:** elm-ui generates inline styles; CSS specificity fights are unpredictable. The project constraint is "elm-ui only — no CSS files."
**Do this instead:** Use `UI.Screen.device model.screen` inside Elm view functions to return different attribute lists for `Phone` vs. `Computer`.

### Anti-Pattern 4: Adding a New Breakpoint Module Instead of Using Existing Device Type

**What people do:** Create `UI.Breakpoints` with multiple size tiers (xs, sm, md, lg).
**Why it's wrong:** The existing `UI.Screen.Device = Phone | Computer` is sufficient for this app's needs; the terminal ASCII aesthetic doesn't require fine-grained responsive tiers. Adding complexity without benefit.
**Do this instead:** Use the existing `Phone | Computer` binary. If a specific view needs sub-breakpoints, derive them locally inside that view function using `screen.width` directly.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Google Fonts (Sometype Mono) | `<link>` preconnect in `<head>` | Already in `index.html`; cached by browser cache (not SW cache) — font files have long cache-control headers |
| Backend API | `RemoteData.Http` from Elm | SW bypasses these requests; no change needed |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| `index.html` ↔ `sw.js` | `navigator.serviceWorker.register()` call | One-way: HTML registers SW; SW runs independently in background |
| `index.html` ↔ `manifest.json` | `<link rel="manifest" href="manifest.json">` | Static link; browser reads manifest independently |
| `model.screen` ↔ Form view functions | Function argument threading | `Form.View.viewCardChrome` has `model` in scope; child views needing screen size receive it as an extra `Screen.Size` argument |
| `UI.Screen.device` ↔ `UI.Style` | Caller passes device-dependent attrs | Style functions remain device-agnostic; callers branch on `device screen` to pick appropriate attrs |

## Sources

- MDN Web Docs: Service Worker API — cache strategies (cache-first vs network-first)
- web.dev: Add a web app manifest (icon requirements for installability)
- elm-ui documentation: `Element.width`, `Element.padding`, attribute composition
- Existing codebase: `src/UI/Screen.elm` (Device type, 500px breakpoint), `src/index.html` (current HTML shell), `Makefile` (build targets)

---
*Architecture research for: PWA + mobile improvements on Elm 0.19.1 SPA*
*Researched: 2026-02-23*
