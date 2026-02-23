# Technology Stack

**Analysis Date:** 2026-02-23

## Languages

**Primary:**
- Elm 0.19.1 - Single Page Application (SPA) for tournament betting interface

**Secondary:**
- HTML - Entry point document (`src/index.html`)
- JavaScript - Elm compiled to JavaScript, minimal custom JS (Elm app initialization)

## Runtime

**Environment:**
- Browser-based execution (Elm compiles to JavaScript)
- Target browsers: modern standards-compliant browsers with ES5+ support

**Package Manager:**
- Elm Package Manager (built-in to elm)
- Lockfile: `elm.json` (immutable package versioning)

## Frameworks

**Core:**
- mdgriffith/elm-ui 1.1.8 - UI framework replacing HTML/CSS with pure Elm

**HTTP & Async:**
- ohanhi/remotedata-http 4.0.0 - HTTP client with RemoteData integration
- krisajenkins/remotedata 6.0.1 - Async data modeling (NotAsked, Loading, Success, Failure states)

**JSON Processing:**
- elm/json 1.1.3 - JSON encoding/decoding
- NoRedInk/elm-json-decode-pipeline 1.0.0 - Pipeline-style JSON decoders

**Date & Time:**
- justinmimbs/date 3.1.2 - Date manipulation
- justinmimbs/time-extra 1.1.0 - Time utilities
- justinmimbs/timezone-data 2.1.4 - Timezone information database

**Utilities:**
- elm-community/list-extra 8.2.4 - List utilities (findIndex, getAt, removeAt)
- elm-community/dict-extra 2.4.0 - Dictionary utilities
- elm-community/maybe-extra 5.0.0 - Maybe utilities
- elm-community/basics-extra 4.0.0 - Core language extensions
- elm-community/json-extra 4.3.0 - JSON helpers
- Chadtech/elm-bool-extra 2.4.2 - Boolean utilities

**Content & Parsing:**
- elm-explorations/markdown 1.0.0 - Markdown rendering for activity feed
- panthershark/email-parser 1.0.2 - Email validation/parsing for participant form

**Utilities:**
- danyx23/elm-uuid 2.1.2 - UUID generation
- Spaxe/svg-pathd 3.0.1 - SVG path data manipulation
- rtfeldman/elm-hex 1.0.0 - Hexadecimal encoding/decoding

**Browser APIs:**
- elm/browser 1.0.2 - Browser application framework (Browser.application for URL routing)
- elm/url 1.0.0 - URL parsing
- elm/http 2.0.0 - HTTP module (used via RemoteData.Http wrapper)

## Configuration

**Build System:**
- Makefile - Project build orchestration
  - `make build` - Production build with `--optimize` flag
  - `make debug` - Development build without optimization
  - `make clean` - Remove build artifacts

**Elm Compiler:**
- elm make - Compiles `src/Main.elm` to `build/main.js`
- Production: `elm make --optimize` (enables dead code elimination, minification)
- Debug: standard compilation (full error messages, Debug.log enabled)

**Entry Point:**
- `src/index.html` - Single HTML file that loads compiled `main.js`
- Initialization flags passed to Elm app:
  - `formId: Maybe String` - Tournament/form identifier
  - `width: Int` - Viewport width (for responsive design)
  - `height: Int` - Viewport height

**External Assets:**
- Google Fonts: Sometype Mono (variable font, weights 400-700, italic)
  - CDN: `https://fonts.googleapis.com/css2?family=Sometype+Mono:ital,wght@0,400..700;1,400..700&display=swap`
- Local assets in `/assets` directory (copied to `build/assets` on build)

## Platform Requirements

**Development:**
- Elm 0.19.1 compiler
- Python 3 (for local HTTP serving: `python3 -m http.server --directory build`)
- Make (for build automation)

**Production:**
- Static file hosting (HTTP server serving files from `build/` directory)
- No backend framework required (Elm handles all frontend logic)
- HTTPS recommended for API communication

## Build Output

**Artifacts:**
- `build/main.js` - Compiled Elm application (production: ~30KB gzipped, development: ~100KB+)
- `build/index.html` - Copied from source
- `build/assets/` - Copied from source assets directory

## Key Characteristics

- **Pure Functional:** Elm's type system eliminates null references, runtime exceptions
- **Immutable by Default:** Data structures are immutable; updates use record syntax
- **Explicit Side Effects:** All HTTP, time, navigation via Cmd Msg types
- **No Transpilation:** Elm compiles directly to JavaScript
- **No CSS:** All styling via elm-ui, no separate CSS files

---

*Stack analysis: 2026-02-23*
