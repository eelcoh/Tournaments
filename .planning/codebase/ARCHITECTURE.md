# Architecture

**Analysis Date:** 2025-02-23

## Pattern Overview

**Overall:** The Elm Architecture (TEA) with Browser.application fragment-based routing

**Key Characteristics:**
- Single-page application (SPA) with URL fragment routing (`#home`, `#formulier`, `#stand`, etc.)
- Model-View-Update pattern with centralized state in `Model`
- All side effects (HTTP, time, browser events) handled via `Cmd Msg` from `update`
- Immutable data structures with explicit type annotations
- Card-based form progression for bet placement (6-card wizard)
- RemoteData pattern for all async operations (`NotAsked | Loading | Success | Failure`)
- DataStatus wrapper (`Fresh | Filthy | Stale`) for tracking data staleness
- InputState tracking (`Clean | Dirty`) for form modification

## Layers

**View Layer:**
- Purpose: Render UI and capture user events
- Location: `src/View.elm` (root dispatcher), `src/Form/View.elm`, `src/Results/*.elm`, `src/Activities.elm`, `src/Authentication.elm`
- Contains: elm-ui components, conditional rendering based on `App` type
- Depends on: `Types.elm` (Model, Msg), domain modules (`Bets`, `Form`, `Results`)
- Used by: `Main.elm` (via Browser.application)
- Pattern: App-based dispatch (`case model.app of Home -> ... | Form -> ... | Results -> ...`)

**Update Layer:**
- Purpose: Process messages and update model state
- Location: `src/Main.elm` (main update dispatcher), `src/Form/*.elm` (card-specific logic), `src/Results/*.elm` (results views)
- Contains: Message handlers, state transformations
- Depends on: `Types.elm`, domain modules, API modules
- Used by: `Main.elm` (Browser.application update callback)
- Pattern: Nested updates per card type; card updates return `(Bet, State, Cmd Msg)` tuple for model, local state, and effects

**Model Layer:**
- Purpose: Define and manage application state
- Location: `src/Types.elm` (top-level model), `src/Bets/Types.elm` (domain model), `src/Bets/Types/*.elm` (granular types)
- Contains: Type definitions (`Model`, `Msg`, `App`, `Card`, domain records)
- Depends on: Bets module, Form card types, RemoteData, Browser.Navigation
- Used by: All modules

**Form/Interaction Layer:**
- Purpose: Card-based form progression for bet placement
- Location: `src/Form/` directory
- Contains: 6 card types - `IntroCard`, `GroupMatchesCard`, `BracketCard`, `TopscorerCard`, `ParticipantCard`, `SubmitCard`
- Depends on: Bet model, UI components, validation logic
- Pattern: Each card has optional `Types.elm` for local state; `update` returns modified `Bet` + local state + `Cmd`

**Domain Layer:**
- Purpose: Tournament structure, match/bracket definitions, bet logic
- Location: `src/Bets/` directory
- Contains: Core types (`Bet`, `Match`, `Bracket`, `Group`, `Round`), initialization per tournament, JSON encode/decode
- Depends on: None (bottom of dependency graph)
- Used by: Form layer, Results layer, API layer

**API/Integration Layer:**
- Purpose: HTTP communication with backend
- Location: `src/API/` directory
- Contains: Endpoints for bets, dates, results data fetching
- Depends on: RemoteData.Http, Bets types, Types.Msg
- Used by: Main.elm update handlers, Results modules

**Results/Analytics Layer:**
- Purpose: Display and edit tournament results (rankings, matches, knockouts, topscorers)
- Location: `src/Results/` directory
- Contains: Views for rankings, match results, knockout qualifiers, topscorer updates
- Depends on: Bets types, Types.Model, UI components, API modules
- Pattern: Stateless display + mutation handlers (e.g., `Qualify`, `ChangeQualify`)

**UI/Presentation Layer:**
- Purpose: Reusable components and styling system
- Location: `src/UI/` directory
- Contains: Button variants, color definitions, responsive screen sizing, semantic styles (`scoreButton`, `terminalInput`, etc.)
- Depends on: elm-ui, no domain logic
- Used by: All view modules

## Data Flow

**Bet Placement (Form Flow):**

1. User navigates `#formulier` → `View.getApp` sets `model.app = Form`
2. `Form.View.view` renders current card via `viewCard model.idx card`
3. User inputs on card (e.g., match score) → `update` processes `GroupMatchMsg`, `BracketMsg`, etc.
4. Each card's `update` modifies `model.bet` via pure functions (`setMatchScore`, `setBulk`, etc.)
5. Form state updated via `Cards.updateBracketCard` / `Cards.updateGroupMatchesCard` / etc.
6. User clicks "Ga verder" → `NavigateTo (idx + 1)` → display next card
7. On last card (SubmitCard), `isComplete model.bet` checked via `Bets.Bet.isComplete`
8. Submit → `SubmitMsg` → `API.Bets.placeBet` (HTTP POST/PUT)
9. Response → `SubmittedBet` → `model.savedBet` set to `Success bet`, `model.betState = Clean`

**Results/Edit Flow:**

1. User navigates `#wedstrijden` or `#stand` → `model.app = Results | EditMatchResult | KOResults | TSResults`
2. View fetches data on mount (e.g., `RefreshRanking`, `RefreshResults`)
3. API returns wrapped in RemoteData: `model.ranking = Success ...`, `model.matchResults = Success ...`
4. User edits (e.g., `UpdateMatchResult`, `ChangeQualify`) → mutation → `Filthy` status
5. User saves → API update → `Refresh*` → re-fetch latest data
6. Model.token (`WebData Token`) used for Authorization header on protected endpoints

**State Management:**

- `model.bet` (singular) — active bet being filled or edited
- `model.savedBet` (WebData Bet) — last saved/fetched bet
- `model.cards` (List Card) — form card progression; mutated by `Cards.updateBracketCard` etc.
- `model.idx` (Int) — current card index (0-5)
- `model.app` (App) — current app view (Home, Form, Results, etc.)
- `model.activities` (ActivitiesModel) — comments and blog posts
- `model.token` (WebData Token) — auth token for protected endpoints
- `model.betState` (InputState) — Clean/Dirty flag for unsaved changes
- Results data: `model.ranking`, `model.bets`, `model.matchResults`, `model.knockoutsResults`, `model.topscorerResults` — all wrapped in RemoteData or DataStatus

## Key Abstractions

**Bracket (Tournament Bracket Structure):**
- Purpose: Represent knockout round matches and team qualifications
- Examples: `src/Bets/Types/Bracket.elm`, `src/Bets/Types.Bracket` functions
- Pattern: Recursive binary tree — `MatchNode` (match with home/away brackets) | `TeamNode` (direct team placement)
- Slots: m73-m88 (R1), m89-m96 (R2), m97-m100 (R3), m101-m102 (R4), m104 (final)
- Operations: `get`, `set`, `winner`, `setBulk`, `proceed` for winner propagation
- Wizard Form: `Form.Bracket.Types.RoundSelections` (champion → finalists → semis → ... → lastThirtyTwo top-down)
- Rebuild: `rebuildBracket` reconstructs full tree from wizard selections on each change

**Card-Based Form:**
- Purpose: Multi-step bet placement with progressive disclosure
- Type: `Card = IntroCard | GroupMatchesCard | BracketCard | TopscorerCard | ParticipantCard | SubmitCard`
- State: `model.cards : List Card`, `model.idx : Int` for current position
- Card extractors: `Cards.getBracketCard`, `Cards.getGroupMatchesCard`, `Cards.getParticipantCard`
- Card updates: `Cards.updateBracketCard`, etc. replace card in list while preserving order

**Answer Types:**
- Purpose: User predictions across all domains
- Examples: `AnswerGroupMatch`, `AnswerBracket`, `AnswerTopscorer`
- Pattern: Each answer type wraps predictions; aggregated in `Answers` record
- Encoding: Explicit JSON encoders/decoders (no automatic serialization)

**Tournament Data:**
- Purpose: Tournament-specific initialization (teams, groups, matches, bracket structure)
- Location: `src/Bets/Init/<TournamentName>/Tournament.elm`
- Exposes: `bracket : List Bracket`, `initTeamData : TeamData`, `matches : List Match`
- Currently active: `WorldCup2026` (imported in `src/Bets/Init.elm`)
- Extensible: Add new tournament by creating new module + importing in `Init.elm`

**Group and Match Identification:**
- Purpose: Identify groups (A-L for WC2026) and matches
- Group type: `Group = A | B | C | ... | L` (union type, not string)
- Match ID: `MatchID` (String alias for match keys like "m1", "m73")
- Answers indexed by MatchID: `AnswerGroupMatches = List (MatchID, AnswerGroupMatch)`

**Participant Data:**
- Purpose: Collect bettor name and metadata
- Location: `src/Form/Participant.elm`
- State: `Form.Participant.Types.State { activeField : Maybe FieldTag }` for focus tracking
- Fields: Name, email, location, etc. (terminal UI with focus highlighting)

**RemoteData & DataStatus:**
- RemoteData: `NotAsked | Loading | Success a | Failure Http.Error` — models async HTTP state
- DataStatus: `Fresh | Filthy | Stale` — tracks whether data is fresh/modified/stale
- Used for: All backend-sourced data (`model.token`, `model.bets`, `model.ranking`, `model.matchResults`, `model.knockoutsResults`, `model.topscorerResults`)

## Entry Points

**Browser Application:**
- Location: `src/Main.elm`
- Triggers: Page load with `Browser.application`
- Responsibilities: Initialize model with flags (width, height, formId), set up subscriptions, dispatch to main update
- Init: Calls `getApp url` (from `View.elm`) to set initial app, loads timezone
- Update: Routes all messages through `case msg of` dispatcher
- Subscriptions: `Events.onResize ScreenResize` for responsive resizing

**URL Routing:**
- Location: `src/View.elm` function `getApp : Url -> (App, Cmd Msg)`
- Triggers: `onUrlChange`, `onUrlRequest` from `Browser.application`
- Maps: URL fragments to `App` types
  - `#home` → `Home`
  - `#formulier` → `Form`
  - `#stand`, `#stand/<uuid>` → `RankingDetailsView`
  - `#wedstrijden`, `#wedstrijden/wedstrijd/<id>` → `Results` / `EditMatchResult`
  - `#uitslag`, `#score` → `KOResults`, `TSResults`

**Form Card Renderer:**
- Location: `src/Form/View.elm` function `viewCard : Model Msg -> Int -> Card -> Element.Element Msg`
- Triggers: `model.app = Form` and `model.idx` changes
- Dispatches to: `Form.Info.view`, `Form.GroupMatches.view`, `Form.Bracket.view`, `Form.Topscorer.view`, `Form.Participant.view`, `Form.Submit.view`

## Error Handling

**Strategy:** RemoteData pattern for all async operations

**Patterns:**
- HTTP failures wrapped in `Failure Http.Error`
- View layer checks `case webData of Success x -> ... | Failure e -> UI.Text.error | ...`
- No exception handling (Elm has no runtime exceptions)
- Type system enforces handling of `Maybe` and `Result` types
- Invalid data structure: Compiler prevents access to unwrapped values

**Common Patterns:**
- `case model.token of Success (Token token) -> ... | _ -> Cmd.none` (guards against failed auth)
- `Maybe.withDefault` for nullable fields
- Pattern matching on `RemoteData` cases exhaustively

## Cross-Cutting Concerns

**Logging:** None configured (no elm-test, no Debug.log in production)

**Validation:**
- Completeness checks: `Bets.Bet.isComplete` aggregates checks across domains
- Per-domain: `GroupMatches.isComplete`, `Bracket.isCompleteQualifiers`, `Topscorer.isComplete`, `Participant.isComplete`
- Score validation: `Bets.Types.Score` (Maybe Int, implicitly nullable)

**Authentication:**
- Token fetched via `Authentication.authenticate uid pw` → `FetchedToken` message
- Token stored in `model.token : WebData Token`
- Bearer token passed in Authorization header: `"Bearer " ++ tokenString`
- Protected endpoints check `case model.token of Success _ -> allow | _ -> deny`

**Responsive Design:**
- `UI.Screen.size : Int -> Int -> Size` calculates breakpoints
- Screen size changes trigger `ScreenResize` message → `Cards.updateScreenCards` adjusts card layout
- Cards re-layout without data loss

---

*Architecture analysis: 2025-02-23*
