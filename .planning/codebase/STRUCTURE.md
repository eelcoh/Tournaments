# Codebase Structure

**Analysis Date:** 2025-02-23

## Directory Layout

```
Tournaments/
├── src/                          # Elm source code
│   ├── Main.elm                  # Entry point: Browser.application
│   ├── Types.elm                 # Top-level Model, Msg, App, Card types
│   ├── View.elm                  # Root view dispatcher by App
│   ├── Activities.elm            # Activity feed (comments, blog posts)
│   ├── Authentication.elm        # Login UI and token fetching
│   ├── index.html                # HTML shell for Elm app
│   ├── API/                      # HTTP communication
│   │   ├── Bets.elm              # Bet CRUD endpoints
│   │   └── Date.elm              # Date-related API
│   ├── Bets/                     # Domain model: tournaments, matches, brackets
│   │   ├── Bet.elm               # Bet operations (get, set, isComplete)
│   │   ├── Types.elm             # Core types: Bet, Match, Group, Round, etc.
│   │   ├── Init.elm              # Bet initialization per tournament
│   │   ├── Json/
│   │   │   └── Encode.elm        # JSON encoding for Bet
│   │   ├── Types/                # Granular type definitions
│   │   │   ├── Answer/           # Answer wrapper types
│   │   │   │   ├── Bracket.elm
│   │   │   │   ├── GroupMatch.elm
│   │   │   │   ├── GroupMatches.elm
│   │   │   │   └── Topscorer.elm
│   │   │   ├── Answers.elm       # Aggregated answers type
│   │   │   ├── Bracket.elm       # Bracket tree structure and operations
│   │   │   ├── Candidate.elm
│   │   │   ├── DateTime.elm
│   │   │   ├── Draw.elm
│   │   │   ├── Group.elm         # Group utilities
│   │   │   ├── HasQualified.elm
│   │   │   ├── Match.elm         # Match utilities and ID handling
│   │   │   ├── Participant.elm   # Bettor data (name, email, etc.)
│   │   │   ├── Points.elm
│   │   │   ├── Round.elm         # Round type (R1, R2, R3, etc.)
│   │   │   ├── Score.elm         # Score type (home/away)
│   │   │   ├── Team.elm          # Team utilities
│   │   │   └── Topscorer.elm     # Top scorer answer type
│   │   ├── Init/                 # Tournament initialization modules
│   │   │   ├── Lib.elm           # Shared init logic
│   │   │   ├── Euro2020/
│   │   │   │   └── Tournament.elm
│   │   │   ├── Euro2024/
│   │   │   │   └── Tournament.elm
│   │   │   ├── WorldCup2022/
│   │   │   │   └── Tournament.elm
│   │   │   └── WorldCup2026/      # Currently active tournament
│   │   │       ├── Tournament.elm  # Bracket, teams, matches
│   │   │       └── Tournament/
│   │   │           ├── Draw.elm   # Match schedule
│   │   │           └── Teams.elm  # Team roster
│   │   ├── View/                 # Bracket visualization (results view)
│   │   │   └── Bracket.elm
│   │   └── Test.elm              # Test utilities (not test suite)
│   ├── Form/                     # Bet placement form (6-card wizard)
│   │   ├── View.elm              # Card dispatcher and chrome
│   │   ├── Card.elm              # Card state helpers (getters, updaters)
│   │   ├── Info.elm              # IntroCard view
│   │   ├── Submit.elm            # SubmitCard view
│   │   ├── GroupMatches.elm       # Single group matches card (scroll wheel UI)
│   │   ├── GroupMatches/
│   │   │   └── Types.elm         # GroupMatches state (cursor, touch)
│   │   ├── Bracket.elm           # Bracket wizard card logic
│   │   ├── Bracket/
│   │   │   ├── Types.elm         # Bracket state (wizard, selections)
│   │   │   └── View.elm          # Bracket wizard UI
│   │   ├── Topscorer.elm         # Top scorer selection card
│   │   ├── Topscorer/
│   │   │   └── Types.elm         # Topscorer form state
│   │   └── Participant/
│   │       ├── Participant.elm   # Bettor info card
│   │       └── Types.elm         # Participant focus state
│   ├── Results/                  # Results views (rankings, matches, knockouts)
│   │   ├── Bets.elm              # Bet list and activation toggle
│   │   ├── Ranking.elm           # Ranking view and details
│   │   ├── Matches.elm           # Match result entry/editing
│   │   ├── Knockouts.elm         # Knockout qualifier tracking
│   │   └── Topscorers.elm        # Top scorer results
│   ├── UI/                       # Reusable components and styling
│   │   ├── Style.elm             # Comprehensive style system (colors, fonts, buttons)
│   │   ├── Color.elm             # Color palette (terminal theme)
│   │   ├── Font.elm              # Font definitions and sizing
│   │   ├── Screen.elm            # Responsive breakpoint logic
│   │   ├── Page.elm              # Page layout component
│   │   ├── Text.elm              # Text style helpers
│   │   ├── Button.elm            # Button components
│   │   ├── Button/
│   │   │   └── Score.elm         # Score input buttons
│   │   └── Color/
│   │       └── [color files]
│   └── Helpers/
│       └── List.elm              # List utility functions
├── assets/                       # Static files (SVG flags, etc.)
├── build/                        # Compiled output (generated)
├── Makefile                      # Build targets
├── elm.json                      # Elm package manifest
└── .planning/
    └── codebase/                 # GSD planning documents
```

## Directory Purposes

**src/Main.elm:**
- Purpose: Application entry point and root update dispatcher
- Contains: `init`, `update`, `view`, `subscriptions` functions for `Browser.application`
- Routes all top-level messages to appropriate handler

**src/Types.elm:**
- Purpose: Centralized type definitions for entire application
- Contains: `Model`, `Msg` (all message types), `App` (view selector), `Card` (form cards)
- Defines: InputState, DataStatus wrappers, top-level type aliases

**src/View.elm:**
- Purpose: Root view renderer and URL routing
- Contains: `view : Model Msg -> Browser.Document Msg` dispatcher, `getApp : Url -> (App, Cmd Msg)` router
- Renders based on `model.app` type

**src/API/:**
- Purpose: HTTP API communication
- Contains: Request builders using RemoteData.Http (POST, PUT, GET)
- Pattern: Each endpoint returns a `Cmd Msg` with response handler

**src/Bets/:**
- Purpose: Domain model for tournament betting
- Sub-modules:
  - `Types.elm` — Core Bet, Match, Bracket, Group types
  - `Bet.elm` — Operations on Bet (setWinner, setScore, isComplete)
  - `Init.elm` — Initialize Bet with tournament data
  - `Init/<Tournament>/` — Tournament-specific bracket, teams, matches
  - `Types/Answer/` — Answer wrapper types (Bracket, GroupMatch, Topscorer)
  - `Types/` — Granular type definitions (Team, Score, Participant, etc.)

**src/Form/:**
- Purpose: Multi-step bet placement form (6-card wizard)
- Cards (in order): Intro → GroupMatches → Bracket → Topscorer → Participant → Submit
- Pattern: Each card may have local `Types.elm` for state; `update` returns `(Bet, State, Cmd Msg)`
- `Card.elm` — Helpers for getting/updating cards in list

**src/Results/:**
- Purpose: Display and edit tournament results
- Contains: Ranking, match results, knockout qualifiers, topscorer views
- Pattern: Stateless display with mutation handlers triggering re-fetch

**src/UI/:**
- Purpose: Reusable UI components and styling system
- No domain logic — purely presentational
- Uses: elm-ui exclusively (no CSS files)
- Themes: Terminal-style dark UI (monospace fonts, underlines, ASCII aesthetics)

**src/Helpers/:**
- Purpose: Utility functions shared across modules
- Contains: List operations not in standard library

## Key File Locations

**Entry Points:**
- `src/Main.elm` — Browser.application startup, init/update/view/subscriptions
- `src/View.elm` — Root view dispatcher and URL fragment router
- `src/index.html` — HTML shell, loads compiled main.js, initializes Elm with flags

**Configuration:**
- `elm.json` — Package versions, exposing, source-directories
- `Makefile` — Build commands (debug, build, clean)

**Core Logic:**
- `src/Types.elm` — Model, Msg, App, Card type definitions
- `src/Bets/Types.elm` — Bet domain type definitions
- `src/Bets/Bet.elm` — Bet manipulation functions

**Form Logic:**
- `src/Form/View.elm` — Card dispatcher and chrome (navigation buttons, progress indicator)
- `src/Form/Card.elm` — Card state management (extract, update specific card type)
- `src/Form/Bracket.elm` — Bracket wizard logic (rebuild tree from selections)
- `src/Form/GroupMatches.elm` — Group matches scroll-wheel UI

**Bracket System:**
- `src/Bets/Types/Bracket.elm` — Binary tree structure, operations (get, set, proceed, winner)
- `src/Bets/Init/WorldCup2026/Tournament.elm` — Bracket definition with slots and draw
- `src/Form/Bracket/Types.elm` — Wizard state (RoundSelections, SelectionRound)
- `src/Form/Bracket/View.elm` — Wizard UI rendering

**Testing:**
- No automated tests — no jest.config.js, vitest.config.js, or *.test.elm files
- `src/Bets/Test.elm` — Test utilities module (not a test suite runner)

## Naming Conventions

**Files:**
- Modules match file paths with CamelCase (e.g., `API.Bets` → `src/API/Bets.elm`)
- Directories use lowercase (src/, assets/, build/)
- Special: `Types.elm` files for type definitions in each module scope

**Directories:**
- Feature directories: lowercase (api, bets, form, results, ui)
- Tournament directories: PascalCase (Euro2020, WorldCup2026)

**Functions:**
- camelCase: `isComplete`, `setMatchScore`, `updateCursor`, `rebuildBracket`
- Predicates: `is*` prefix (isComplete, isWizardComplete, isAnswerGroupMatchComplete)
- Getters: `get*` prefix (getBracketCard, getGroupMatchesCard, getTopscorer)
- Setters: `set*` prefix (setMatchScore, setWinner, setQualifier)
- Updaters: `update*` prefix (updateBracket, updateCursor)
- View functions: `view*` prefix (viewHome, viewCard, viewActivity)

**Types:**
- Records: PascalCase (Model, Bet, Match, Card)
- Union types: PascalCase variants (Home, Form, Results, ChampionRound, MatchNode)
- Type aliases: PascalCase (Answers, Participant, TeamData)

**Messages:**
- Msg type variants: PascalCase (NavigateTo, BracketMsg, UpdateMatchResult, SetCommentMsg)
- Wrapper messages: `[Feature]Msg` (BracketMsg, GroupMatchMsg, TopscorerMsg)

## Where to Add New Code

**New Feature:**
- Primary code: `src/Features/<feature>/` directory
- If it's a new app page: Add variant to `App` type in `src/Types.elm`
- Add routing in `src/View.elm` function `getApp`
- Update type: Add `<Feature>Msg` wrapper to `Types.Msg`
- Update dispatcher: Add case in `Main.elm` update function
- View: Create `src/<Feature>/View.elm` and call from `View.elm`

**New Form Card:**
- Card type: Add variant to `Card` union in `src/Types.elm`
- State: Create `src/Form/<CardName>/Types.elm` with `State` alias
- Logic: Create `src/Form/<CardName>.elm` with `update` and `view` functions
- Dispatcher: Add case in `Form.View.viewCard`
- Card list: Update `Types.initCards` to include new card in progression
- Card helpers: Add getters/updaters to `Form.Card.elm`

**New Tournament:**
- Create: `src/Bets/Init/<TournamentName>/Tournament.elm`
- Expose: `bracket : List Bracket`, `initTeamData : TeamData`, `matches : List Match`
- Reference: Copy structure from `src/Bets/Init/WorldCup2026/`
- Activate: Change import in `src/Bets/Init.elm` to `import Bets.Init.<TournamentName>.Tournament as Tournament`

**New Component/Module:**
- Implementation: `src/UI/<ComponentName>.elm`
- Types (if complex): `src/UI/<ComponentName>/Types.elm`
- Pattern: Pure functions taking data and returning `Element.Element Msg`

**Utilities:**
- Shared helpers: `src/Helpers/<Domain>.elm`
- Re-export commonly used imports: Create barrel files (e.g., `UI.Button` re-exports button styles)

## Special Directories

**assets/:**
- Purpose: Static files (SVG flags, images)
- Generated: No
- Committed: Yes
- Copied to build/ on compilation

**build/:**
- Purpose: Compiled output and distribution
- Generated: Yes (by Makefile)
- Committed: No (in .gitignore)
- Contents: main.js (compiled Elm), index.html, assets/ copy

**src/Bets/Init/:**
- Purpose: Tournament-specific data injection points
- Extensible: Add new tournament by creating <TournamentName>/ subdirectory
- Current: WorldCup2026 is active (imported in Bets.Init)
- Archive: Euro2020, Euro2024, WorldCup2022 available as reference

---

*Structure analysis: 2025-02-23*
