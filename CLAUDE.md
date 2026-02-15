# CLAUDE.md

## Project Overview

Football tournament betting SPA built with Elm 0.19.1 and elm-ui. Users predict match results, knockout brackets, and top scorers for World Cups and European Championships.

## Build & Run

```bash
make build          # Production build (optimized) -> build/main.js
make debug          # Development build (no optimization)
make clean          # Remove build/ and elm-stuff/
python3 -m http.server --directory build   # Serve locally on :8000
```

The build compiles `src/Main.elm` to `build/main.js` and copies `src/index.html` and `assets/` to `build/`.

## Elm Language Essentials

When working with Elm code, keep these fundamentals in mind:

- **Pure functional language** -- no side effects, no null, no runtime exceptions
- **The Elm Architecture (TEA)**: `init`, `update`, `view`, `subscriptions` -- all state changes flow through `update` via `Msg` types
- **Immutable data** -- records are updated with `{ record | field = newValue }` syntax
- **Type system** -- every function has a type annotation; custom types (union types) are used extensively instead of stringly-typed values
- **Pattern matching** -- `case ... of` is used everywhere; the compiler enforces exhaustive matching
- **No typeclasses** -- Elm does not have typeclasses; polymorphism is achieved through function parameters
- **Module system** -- each file is a module; `exposing` controls what is public
- **Elm packages are immutable** -- versions are enforced by the compiler via `elm.json`
- **JSON decoding is explicit** -- there is no automatic serialization; decoders/encoders are written manually (see `Bets.Json`)
- **Commands and Subscriptions** -- side effects (HTTP, time, browser events) return `Cmd Msg` values from `update`; incoming events use `Sub Msg`

### Common Mistakes to Avoid

- Do not use `Debug.log` or `Debug.todo` in production builds (`--optimize` will reject them)
- Elm has no `if` without `else` -- every `if` expression must have both branches
- Record update syntax requires the record to already exist; you cannot add fields
- Pipe operators (`|>` and `<|`) are idiomatic; prefer `|>` for readability
- `Maybe` and `Result` must be handled explicitly -- there is no implicit unwrapping
- Elm uses `let ... in` blocks for local bindings, not variable assignment
- Lists are linked lists; use `Array` if you need indexed access
- String concatenation uses `++`, not `+`
- Elm has no `return` keyword; the last expression in a function is its return value

## Architecture

### Entry Point

`src/Main.elm` -- `Browser.application` with URL-based fragment routing (`#home`, `#formulier`, `#stand`, etc.). URL parsing is handled in `src/View.elm` (`getApp`).

### Core Modules

| Directory | Purpose |
|---|---|
| `src/Types.elm` | Centralized `Model`, `Msg`, and top-level type definitions |
| `src/View.elm` | URL routing and top-level view dispatch |
| `src/Bets/` | Domain model -- bet types, initialization, JSON encoding/decoding |
| `src/Bets/Init/` | Tournament-specific data (teams, matches, bracket structure) |
| `src/Form/` | Bet placement UI -- card-based progression |
| `src/Results/` | Results display -- rankings, match results, knockouts |
| `src/API/` | HTTP communication with backend |
| `src/UI/` | Reusable UI components and styling (elm-ui based) |
| `src/Activities.elm` | Activity feed, comments, posts |
| `src/Authentication.elm` | User login with bearer token auth |

### Type Organization

- `src/Types.elm` -- top-level app types (`Model`, `Msg`, `App`, `Card`, etc.)
- `src/Bets/Types.elm` -- domain types (`Bet`, `Match`, `Group`, `Round`, etc.)
- `src/Bets/Types/` -- granular type modules (`Answer`, `Bracket`, `Team`, `Score`, etc.)
- `src/Form/*/Types.elm` -- form-specific state types (`Bracket.Types`, `GroupMatches.Types`, etc.)

### Key Patterns

- **RemoteData** (`WebData`) for all async data -- states are `NotAsked`, `Loading`, `Success`, `Failure`
- **DataStatus** wrapper (`Fresh | Filthy | Stale`) tracks staleness of fetched data
- **InputState** (`Clean | Dirty`) tracks form field modification state
- **Card-based forms** -- progression through `IntroCard` -> `GroupMatchesCard` -> `BracketCard` -> `TopscorerCard` -> `ParticipantCard` -> `SubmitCard`
- **Cursor-based selection** for navigating group matches in the form

### UI

All styling is done through `elm-ui` (`mdgriffith/elm-ui`) -- there are no CSS files. Key UI modules:
- `UI.Style` -- comprehensive styling system (colors, fonts, layout)
- `UI.Button` -- semantic button components
- `UI.Screen` -- responsive screen size handling
- `UI.Team`, `UI.Match`, `UI.Text` -- domain-specific components

## Adding a New Tournament

1. Create `src/Bets/Init/<TournamentName>/Tournament.elm`
2. Expose three functions:
   - `bracket : List Bets.Types.Bracket`
   - `initTeamData : Bets.Types.TeamData`
   - `matches : List Bets.Types.Match`
3. Import the new module in `src/Bets/Init.elm` (only one tournament active at a time)

Reference implementations: `Euro2020`, `WorldCup2022`, `Euro2024`, `WorldCup2026` in `src/Bets/Init/`.

## Key Dependencies

- `mdgriffith/elm-ui` 1.1.8 -- UI framework (replaces HTML/CSS)
- `krisajenkins/remotedata` 6.0.1 -- async data modeling
- `NoRedInk/elm-json-decode-pipeline` 1.0.0 -- JSON decoder pipelines
- `elm-community/list-extra`, `maybe-extra`, `dict-extra` -- standard library extensions
- `justinmimbs/date` + `justinmimbs/timezone-data` -- date/timezone handling

## Conventions

- Types are separated into dedicated `Types.elm` modules when complex
- Functions follow Elm naming: `update`, `view`, `isComplete`, `encode`, `decode`
- Explicit type annotations on all exposed functions
- `let ... in` for local bindings
- Destructuring imports from core modules (`RemoteData exposing (RemoteData(..), WebData)`)
- No test suite -- `elm-test` is not configured
- No `elm-format` or `elm-review` config present (but follow standard Elm formatting)
