# Coding Conventions

**Analysis Date:** 2025-02-23

## Naming Patterns

**Files:**
- PascalCase for all modules: `Types.elm`, `Main.elm`, `Authentication.elm`
- Descriptive module hierarchies: `Bets/Types.elm`, `Form/Bracket.elm`, `UI/Button.elm`
- Type-specific subdirectories: `Bets/Types/Answer/`, `Bets/Init/WorldCup2026/Tournament/`
- No file naming conventions for private vs public—controlled via `exposing` clause

**Functions:**
- camelCase for all function names: `isComplete`, `updateBracket`, `setMatchScore`, `findGroupMatchAnswers`
- Verb-first pattern for state modifiers: `setWinner`, `setQualifier`, `setTopscorer`, `cleanThirds`
- Query functions start with `is` or `find`: `isComplete`, `isWizardComplete`, `findGroupMatchAnswers`, `findAllGroupMatchAnswers`
- Getter functions use direct name: `getTopscorer`, `getBracket`, `getApp`
- Helper functions with trailing underscore: `teamButton_`, `extract`, `teamsInGroup`

**Variables:**
- camelCase for all local bindings and parameters: `newBet`, `newState`, `betState`, `matchID`, `homeTeam`
- Abbreviations in scope: `msg` (message), `sz` (size), `grp` (group), `mCard` (maybe card), `mStr` (maybe string), `mInt` (maybe int)
- Record field names in camelCase: `teamID`, `teamName`, `dateString`, `activeField`, `touchStartY`
- Destructuring preferred in function parameters and let bindings

**Types:**
- PascalCase for all type names and type aliases: `Bet`, `Card`, `Model`, `Msg`, `TeamData`, `DateString`
- Union types (custom types) in PascalCase: `Group` (A|B|C...), `Round` (R1|R2...), `Card` (IntroCard|GroupMatchesCard...)
- Type aliases for domain concepts: `AnswerGroupMatches`, `WebData`, `ButtonSemantics`
- Generic type parameters for extensible records: `TeamWithPlayers a`, `TeamsWithPlayers a`
- Result/Maybe used extensively; never unwrapped with partial functions

## Code Style

**Formatting:**
- Standard Elm formatting conventions followed (implied; no auto-formatter configured)
- Function definitions on separate lines with type annotations
- Multi-line let...in blocks indent consistently
- Element.ui layout helpers compose naturally with piping

**Linting:**
- No linting tool configured (no `.eslintrc`, `elm-review`, or similar)
- Follows standard Elm style conventions implicitly
- Comments indicate sections but not overly documented

## Import Organization

**Order:**
1. Domain modules (API, Bets, Form, Results, Activities, Authentication)
2. Framework modules (Browser, Browser.Navigation, Element, Html)
3. Core library modules (Time, RemoteData, Types)
4. UI modules (UI.Button, UI.Color, UI.Style, UI.Text)
5. Specialized imports from dependencies (Json.Encode, Json.Decode, List.Extra)

**Example from `Main.elm`:**
```elm
import API.Bets
import Activities
import Authentication
import Bets.Init
import Browser
import Browser.Events as Events
import Browser.Navigation as Navigation
import Form.Bracket as Bracket
import Form.Card as Cards
import Form.GroupMatches as GroupMatches
import Form.Info
import Form.Participant as Participant
import Form.Topscorer as Topscorer
import Http
import RemoteData exposing (RemoteData(..), WebData)
import Results.Bets
import Task
import Time
import Types exposing (App(..), Card(..), ...)
import View exposing (getApp, view)
```

**Path Aliases:**
- None configured; uses nested module paths directly
- Destructuring from imports used to flatten namespaces: `exposing (...)` patterns common
- Module aliases applied to long paths: `import Form.GroupMatches.Types as GroupMatches`

## Error Handling

**Patterns:**
- RemoteData (`NotAsked | Loading | Success a | Failure Http.Error`) for all async states
- WebData type alias: `type alias WebData a = RemoteData Http.Error a`
- DataStatus wrapper for cache control: `Fresh a | Filthy a | Stale a`
- Explicit pattern matching on failure states—no silent unwraps
- Maybe used for optional fields: `uuid : Maybe String`, `activeField : Maybe FieldTag`
- Result not used extensively; preference for RemoteData and Maybe

**Example from `Main.elm`:**
```elm
case msg of
    FetchedBet result ->
        case result of
            Success bet -> ...
            Failure err -> ...
            Loading -> ...
            NotAsked -> ...
```

## Logging

**Framework:** `Debug.log` and `Debug.todo` forbidden in production builds (`--optimize`)

**Patterns:**
- No logging infrastructure in place (no logger library)
- Debug output must be removed before release
- Activities feed used for user-facing notifications (comments, posts, bet events)
- HTTP errors flow through RemoteData Failure state

## Comments

**When to Comment:**
- Section headers with dashes: `-- Activities`, `-- Logging`, `-- Results`
- Explanation of non-obvious logic (rare)
- Temporary notes marked with `-- TODO`, `-- FIXME`
- Disabled code commented out (common in older branches)

**JSDoc/TSDoc:**
- Not used; Elm compiler enforces type annotations
- Type signatures serve as documentation: `isComplete : Bet -> Bool`
- Module-level documentation via comments at top of file (minimal)

**Example section header pattern:**
```elm
-- Activities


type alias ActivitiesModel msg =
    { activities : WebData (List Activity)
    ...
```

## Function Design

**Size:**
- Most functions < 50 lines
- Complex functions split into helper functions within same module or separate modules
- Example: `Form/Bracket.elm` separates `rebuildBracket` helper from main `update` function

**Parameters:**
- Functions take multiple parameters (no excessive currying)
- Related data grouped: `setQualifier : Bet -> Slot -> Group -> Qualifier -> Bet`
- State and action combined in update functions: `update : Msg -> State -> Bet -> ( Bet, State, Cmd Msg )`

**Return Values:**
- Update functions return tuples: `( Model, Cmd Msg )`
- View functions return `Element msg` or `Html msg`
- Decoders return `Decoder a`
- Setter functions return updated value: `setWinner : Bet -> Slot -> Winner -> Bet`

## Module Design

**Exports:**
- All public functions and types listed in `module` exposing clause
- Submodules expose only necessary functions: `Bets.Bet` exposes `isComplete`, `setWinner`, decoders/encoders
- Internal helpers not exposed; suffixed with underscore if used across functions

**Barrel Files:**
- `src/Bets/Init.elm` aggregates tournament data without exposing internal structure
- Exposes three core functions: `bet`, `teamData`, `groupMembers`, `groupsAndFirstMatch`
- Re-exports from tournament-specific modules (only one tournament active at a time)

**Module Hierarchy Examples:**
- `Bets/` — domain model and types
- `Bets/Types/` — granular type definitions (Answer, Bracket, Team, Score)
- `Bets/Types/Answer/` — answer-specific logic (GroupMatches, Bracket, Topscorer)
- `Bets/Init/` — tournament initialization layer
- `Bets/Init/WorldCup2026/Tournament/` — tournament-specific data
- `Form/` — form state and view logic
- `Form/Bracket/` — bracket wizard (Types, View modules)
- `Form/GroupMatches/` — group matches form (Types, View)
- `Results/` — results display and ranking calculations
- `UI/` — reusable components (Style, Button, Text, Color)

## Type Annotations

**Required:**
- All exposed functions must have explicit type annotations
- Local helper functions annotated (enforced by Elm compiler)
- Type annotations placed immediately before function definition
- Multi-line annotations keep parameter types distinct

**Example patterns:**
```elm
isComplete : Bet -> Bool
setWinner : Bet -> Slot -> Winner -> Bet
update : Msg -> Bet -> State -> ( Bet, State, Cmd Msg )
viewScrollWheel : Bet -> State -> Element Msg
```

## JSON Encoding/Decoding

**Explicit approach:**
- All JSON conversions written manually; no automatic serialization
- Decoders use `Json.Decode.Pipeline` for readable chaining: `required "field" decoder`
- Encoders construct `Json.Encode.object` with field lists
- Helper encoders for common patterns: `mStrEnc`, `mIntEnc` for Maybe values

**Example from `Bets/Types/Answers.elm`:**
```elm
decode : Decoder Answers
decode =
    Decode.succeed Answers
        |> required "matches" Gm.decode
        |> required "bracket" Br.decode
        |> required "topscorer" Ts.decode
```

## Immutability and Record Updates

**Record Updates:**
- Syntax: `{ record | field = newValue }`
- Cannot add fields to existing records; structure fixed at definition
- Updates chain with `|>` for readability: `{ model | bet = newBet, betState = Dirty }`

**Lists and Collections:**
- Prefer `List` for sequences; use `Array` only if indexed access critical (not used in this codebase)
- `List.Extra` used for operations like `takeWhile`, `last`, `findIndex`, `removeAt`
- Immutable by default; transformations return new lists

## Pattern Matching

**Case Expressions:**
- Exhaustive pattern matching enforced by compiler
- Structure follows data type definition order
- Nested patterns for extracting values: `case msg of SelectTeam round team -> ...`
- Wildcard `_` used for unused branches

**Example from `Form/Bracket.elm`:**
```elm
case msg of
    SelectTeam round team ->
        let newSelections = ... in
        (newBet, newState, Cmd.none)
    DeselectTeam team ->
        let newSelections = ... in
        (newBet, newState, Cmd.none)
    GoNext ->
        (bet, state, Cmd.none)
```

## Piping and Function Composition

**Forward pipe (`|>`):**
- Idiomatic and preferred for readability
- Chains transformations left-to-right
- Common in view and data transformation functions

**Example:**
```elm
List.filterMap forGroup groups
    |> List.drop 2
    |> List.head
    |> Maybe.map (\t -> (grp, t))
```

**Backward pipe (`<|`):**
- Used rarely; mainly for grouping operations without parentheses
- More common in view DSL: `Element.column layout [ Element.el [] (text value) ]`

---

*Convention analysis: 2025-02-23*
