# Testing Patterns

**Analysis Date:** 2025-02-23

## Test Framework

**Status:** No automated test suite configured

**elm.json Configuration:**
```json
"test-dependencies": {
    "direct": {},
    "indirect": {}
}
```

- No test runner installed (`elm-test` not in dependencies)
- No test configuration file (`elm-test.json` does not exist)
- CLAUDE.md explicitly states: "No test suite -- `elm-test` is not configured"

**Assertion Library:**
- Not applicable; no test framework in place

**Run Commands:**
- No test commands available
- Development workflow relies on manual testing via `make build` and browser testing

## Test File Organization

**Location:**
- Single utility module: `src/Bets/Test.elm`
- Not an automated test file; rather a utility module for specific use case
- File contains helper functions for list manipulation, not test cases

**Naming:**
- `src/Bets/Test.elm` — utilities for cleaning integer lists
- No test-specific file naming conventions (`*.test.elm`, `*.spec.elm`) observed
- No tests directory present

**Structure:**
```
src/
├── Bets/
│   ├── Test.elm          # Utility module, not test suite
│   ├── Types.elm
│   ├── Bet.elm
│   └── ...
└── ...
```

## Test-Like Utility Module

**Location:** `src/Bets/Test.elm`

**Content:**
```elm
module Bets.Test exposing (clean)

cleanInt : Int -> Int -> Maybe Int
cleanInt i n =
    if i == n then Nothing else Just n

cleanInts : List (Maybe Int) -> Int -> List (Maybe Int)
cleanInts l i =
    List.map (Maybe.andThen (cleanInt i)) l

clean : List (Maybe Int) -> List Int -> List (Maybe Int)
clean l1 f =
    case f of
        h :: rest ->
            let
                l2 = cleanInts l1 h
            in
            clean l2 rest
        [] -> l1
```

**Purpose:**
- Provides list manipulation utilities
- Exposed via `clean` function for filtering integer values from lists
- Used in domain logic, not for testing
- Follows standard Elm pure function patterns

## Manual Testing Approach

**Development Workflow:**
1. Compile with `make build` or `make debug` (unoptimized)
2. Serve locally: `python3 -m http.server --directory build`
3. Manual browser testing through UI interactions
4. URL-based fragment routing tests: `#home`, `#formulier`, `#stand`

**Built-in Compiler Guarantees:**
- Type system prevents entire classes of runtime errors
- Pattern matching enforced as exhaustive (compiler error if incomplete)
- No null pointers, no undefined values
- Immutability prevents accidental state mutations

## Error Handling Patterns (Testing Adjacent)

**RemoteData States for Async Testing:**
```elm
case result of
    NotAsked -> ...        -- Initial state
    Loading -> ...         -- Loading indicator
    Success data -> ...    -- Success case
    Failure error -> ...   -- Error case
```

**Validation through Type System:**
- Model type ensures all required state present
- Msg type constrains all possible actions
- Data type definitions enforce valid states at compile time

**Example: Bet Completeness Check**
- `Bets.Bet.isComplete : Bet -> Bool` validates all sections filled
- `Form.GroupMatches.isComplete : Bet -> Bool` validates group matches
- `Form.Bracket.isCompleteQualifiers : Bet -> Bool` validates bracket qualifiers
- Called before form submission to prevent invalid state submission

## Code Coverage

**Requirements:** Not applicable—no test framework

**View Coverage:** None enforced

**Compile-Time Coverage:**
- Elm compiler enforces exhaustive pattern matching
- Type system ensures valid program states
- Unused code detected by compiler warnings

## Property-Based Testing (Not Used)

- No QuickCheck or similar property-based testing library in dependencies
- Manual testing of bracket assignment logic (greedy algorithm in `Form/Bracket.elm`)
- Edge cases in `Issue #93` fixed by reasoning about tournament constraints rather than automated testing

## Integration Testing Approach

**Manual:**
- Manual flow testing through UI forms: Intro → GroupMatches → Bracket → Topscorer → Participant → Submit
- API integration tested by sending requests to backend: `API.Bets.placeBet`, `API.Bets.fetchBet`
- RemoteData states manually verified in browser DevTools

**Example:**
```elm
placeBet : Bet -> Cmd Msg
placeBet bet =
    case bet.uuid of
        Just uuid -> updateBet bet uuid      -- HTTP PUT
        Nothing -> createBet bet             -- HTTP POST
```

**HTTP Error Handling:**
- `Failure Http.Error` captured in RemoteData
- Error display in UI (Activities feed)
- No automated error recovery testing

## UI Component Testing (Manual)

**Group Matches Card (Issue #91):**
- Scroll wheel with 5-match window
- Touch swipe detection (30px threshold)
- Group navigation jumps
- Tested manually in browser with various group combinations

**Bracket Wizard (Issue #81):**
- Champion selection → Finalists → Semis → Quarters → Last16 → Last32
- Team slot assignment and winner propagation
- BestThird slot allocation (greedy algorithm)
- Tested with different group combinations to verify assignment correctness

**Issue #93 (Completeness Check):**
- Bracket completeness now checks `isCompleteQualifiers` (not `isComplete`)
- All 12 groups must have ≥2 teams in last32 before proceeding
- Manual testing with edge cases (8 groups with T3 options)

## Debugging and Development

**Debug Utilities:**
- `Debug.log` available but forbidden in production builds (`--optimize` flag rejects them)
- Browser DevTools for inspecting model state and UI
- `make debug` produces unoptimized build with better error messages

**Testing Mental Model:**
- Pure functions enable local reasoning about behavior
- Type system makes illegal states unrepresentable
- Immutable data structures prevent hidden side effects
- Elm's strong guarantees reduce need for unit tests

**Known Testing Gaps:**
- No automated regression tests for bracket assignment algorithm (Issue #93)
- No parameterized testing of tournament variations (4 tournaments supported)
- BestThird slot greedy algorithm tested manually only
- No E2E test automation for form flows

## Testing Best Practices (By Convention)

**Data Validation:**
- Explicit completeness checks before submission: `isComplete`, `isCompleteQualifiers`
- Validation functions colocated with domain logic: `Bets.Bet.isComplete`, `Form.GroupMatches.isComplete`

**Immutable Testing:**
- Pure functions easily testable in theory (no actual test suite exists)
- Example: `setWinner : Bet -> Slot -> Winner -> Bet` returns new Bet without side effects

**Type-Driven Testing:**
- Union types enforce valid states: `Card` type restricts which form states are possible
- Group type (`A | B | C ... L`) prevents invalid group references

## Hypothetical Test Structure (If elm-test Were Added)

Based on codebase patterns, tests would likely follow this structure:

```elm
module Bets.Tests exposing (..)

import Expect
import Fuzz exposing (Fuzzer, int, list)
import Test exposing (Test, describe, fuzz, test)
import Bets.Bet as Bet
import Bets.Types exposing (..)

suite : Test
suite =
    describe "Bets.Bet"
        [ describe "setWinner"
            [ test "sets winner in bracket" <|
                \_ ->
                    let
                        bet = Bets.Init.bet
                        newBet = Bet.setWinner bet "m101" (Winner teamer)
                    in
                    Expect.equal ... (Bet.getBracket newBet)
            ]
        , describe "isComplete"
            [ fuzz (list int) "validates completion state" <|
                \_ -> ...
            ]
        ]
```

## Test Data and Fixtures

**Tournament Data:**
- Tournament structure defined in `src/Bets/Init/<Tournament>/Tournament.elm`
- Teams, matches, bracket structure hardcoded
- Same data used for both app and manual testing

**Available Tournaments:**
- `Euro2020` — 24 teams, 6 groups
- `WorldCup2022` — 32 teams, 8 groups
- `Euro2024` — 24 teams, 6 groups
- `WorldCup2026` — 48 teams, 12 groups (A-L)

**Test Initialization:**
- `Bets.Init.bet` provides empty Bet template
- `Bets.Init.teamData` provides tournament teams
- `Bets.Init.groupMembers` provides group structure
- No factory functions or test-specific fixtures beyond these

## Continuous Integration

**CI System:** Not configured

- No `.github/workflows`, `.gitlab-ci.yml`, or similar
- No automated builds or test runs on commit
- Manual testing required before merge to main

---

*Testing analysis: 2025-02-23*
