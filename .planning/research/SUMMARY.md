# Project Research Summary

**Project:** v1.5 Test/Demo Mode — Elm 0.19.1 Football Tournament Betting SPA
**Domain:** Cross-cutting runtime feature on an existing Elm TEA SPA
**Researched:** 2026-03-14
**Confidence:** HIGH

## Executive Summary

Adding a test/demo mode to this Elm 0.19.1 SPA is a well-understood TEA exercise: a `testMode : Bool` flag on `Model` propagates through the existing view and update machinery without any new packages, App variants, or build system changes. The recommended approach is a single `TestData.elm` module holding all dummy data as static Elm values, with `testMode` guards in `Main.update` that short-circuit HTTP commands and substitute `Success dummyData` model updates instead. Two independent activation paths — the `#test` URL route and a 5-tap title gesture — cover developer and mobile use cases respectively. No port changes, no service workers, no conditional compilation.

The key architectural decision that simplifies everything is treating test mode as orthogonal to navigation: `testMode` is a flat `Bool` on `Model`, not an `App` variant. This means every view and update handler already receives the flag through `model` without requiring new routing or exhaustive case matching across the codebase. The only files that need meaningful changes are `Types.elm`, `Main.elm`, `View.elm`, `Form/Dashboard.elm`, and the new `TestData.elm`. All HTTP API modules remain untouched.

The principal risks are: (1) "fill all" creating an invalid bracket by bypassing `rebuildBracket` and leaving `WizardState` out of sync with the `Bet`, and (2) dummy data referencing team IDs or match IDs that do not exist in `Bets.Init.teamData`, causing `?` placeholder SVGs in results views. Both risks are preventable by deriving dummy data from real init values rather than hand-writing literals, and by routing "fill all" through `rebuildBracket` rather than directly mutating `Bet.answers`.

## Key Findings

### Recommended Stack

Zero new packages are required. Every capability needed — tap event detection, model flags, static dummy data, URL routing — is available via Elm's standard library and the packages already locked in `elm.json`. The implementation is a pure Elm architecture exercise. All patterns are verified against the existing codebase; no speculative third-party dependencies.

**Core technologies:**
- `Elm 0.19.1`: SPA runtime — all test-mode features are achievable within existing constraints
- `mdgriffith/elm-ui 1.1.8`: UI layout — `Element.htmlAttribute` and `Element.Events.onClick` already used for touch events in `GroupMatches`; same patterns apply here
- `elm/html 1.0.0` + `elm/json 1.1.3`: event handling — `Html.Events.on` with `Json.Decode` decoders, already proven in the scroll wheel implementation

### Expected Features

**Must have (table stakes):**
- `isTestMode : Bool` in `Model` — root dependency; every other feature gates on this flag
- `#test` URL route activation — developer fast path; handled by extending `View.elm getApp`
- `[ TEST ]` badge in status bar — orientation anchor; prevents confusion about which mode is active
- All nav items visible regardless of auth token — unlocks all pages to exercise in one session
- Dummy activities (comments + blog posts) on home page — home functional offline
- Dummy data on all 4 results pages (ranking, matches, group standings, knockouts) — no blank pages in demo
- Offline comment/post submission (local append, no HTTP) — form interaction works without backend
- "Fill all" button on Dashboard card — eliminates 36-match manual entry for demos

**Should have (differentiators):**
- 5-tap title gesture activation — discoverable on mobile without URL editing; counter lives on `Model` to survive navigation
- Offline blog post submission — same pattern as comment; completes the submission UX
- Dummy topscorer results page — completes the full results page set

**Defer (v2+):**
- Seed-based randomized dummy data — only useful if the demo needs variety across multiple runs
- Test mode reset button — only if users request it; the existing `Restart` Msg already resets `model`

### Architecture Approach

The integration targets five files: `Types.elm` (add 2 Model fields and 3 Msg variants), `Main.elm` (testMode guards in 7 handlers), `View.elm` (route branch, nav override, badge, title click), `Form/Dashboard.elm` (conditional fill button), and a new `src/TestData.elm` (all dummy data constants). All HTTP modules — `Activities.elm`, `API/Bets.elm`, `Results/*.elm` — are intentionally unchanged; the HTTP bypass happens in `Main.update` before the call site, not inside the API modules themselves.

**Major components:**
1. `Types.elm` — adds `testMode : Bool` and `titleTapCount : Int` to `Model`; adds `ActivateTestMode`, `FillAll`, `TapTitle` to `Msg`
2. `Main.elm` — testMode guards in `RefreshActivities`, `RefreshRanking`, `RefreshResults`, `RefreshKnockoutsResults`, `RefreshTopscorerResults`, `SaveComment`, `SavePost`; handlers for the 3 new Msgs
3. `View.elm` — `"test" :: _` branch in `getApp`; `linkList` override when testMode; `[TEST]` badge in `viewStatusBar`; `onClick TapTitle` on title element
4. `TestData.elm` (new) — `dummyActivities`, `filledBet`, `dummyRanking`, `dummyMatchResults`, `dummyKnockoutsResults`, `dummyTopscorerResults`
5. `Form/Dashboard.elm` — conditional `[[ fill all ]]` button rendered only when `model.testMode`

### Critical Pitfalls

1. **"Fill all" bypassing `rebuildBracket` creates an invalid bracket** — implement fill-all by constructing `RoundSelections` and calling `rebuildBracket`, then also update `BracketCard`'s `WizardState.selections`; verify `isCompleteQualifiers` returns `True` after fill
2. **Dummy data with semantic mismatches (wrong team IDs, wrong match IDs)** — derive all dummy data from `Bets.Init.groupsAndFirstMatch`, `Bets.Init.teamData`, and `Bets.Init.matches` rather than hand-writing literals; never invent team IDs
3. **Test mode triggering real API calls** — every `update` branch that emits an HTTP `Cmd` must have a `model.testMode` guard returning `Cmd.none`; verify with DevTools Network tab showing zero requests
4. **Offline append on empty feed (activities `NotAsked`)** — check whether `activities` is `Success list` before prepending; if `NotAsked`, set to `Success [ newActivity ]` rather than crashing or silently dropping the item
5. **Tap gesture counter stored in card state and reset on navigation** — store `titleTapCount : Int` directly on `Model`, not inside any `Card` variant; `Element.Events.onClick TapTitle` on the title element in `viewHome`

## Implications for Roadmap

Based on combined research, all four researchers independently converged on the same 4-phase build order driven by hard data dependencies.

### Phase 1: Model Foundation, Routing, Nav, Badge

**Rationale:** `testMode : Bool` on `Model` is the root dependency of every other feature. Nothing else can be built until the flag exists, both activation paths work, and the nav and badge respond to it. This phase has no external dependencies and establishes the scaffolding all subsequent phases extend.
**Delivers:** `#test` URL activates test mode; 5-tap title gesture activates test mode; `[ TEST ]` badge appears in status bar; full nav visible in test mode. No dummy data yet — pages still show Loading state.
**Addresses:** `isTestMode flag`, `#test route`, `TEST MODE badge`, `all nav items visible`, `5-tap gesture`
**Avoids:** Pitfall 4 (tap counter in wrong scope), Pitfall 5 (testMode in localStorage), Pitfall 6 (nav overflow at 320px)
**Verification:** Navigate to `#test`; badge appears. Tap title 5 times; badge appears. DevTools 320px; no overflow.

### Phase 2: Dummy Activities and Offline Submission

**Rationale:** The home page is the first page users see; making it functional offline is high-value and low-risk. This phase creates `TestData.elm` with its first consumers — activities. The offline submit guards in `Main.update` follow the same pattern as the route guards from Phase 1.
**Delivers:** Home page shows lorem ipsum feed (comments + blog posts) in test mode. Submitting a comment or post appends locally without HTTP.
**Addresses:** `Dummy activities`, `offline comment submission`, `offline blog post submission`
**Avoids:** Pitfall 7 (offline append on empty feed — handle `NotAsked` case explicitly)
**Note:** Independent of Phase 3; can be developed in parallel if desired.

### Phase 3: Dummy Results Data

**Rationale:** All 4 results pages need content to be useful in demo mode. This is mechanically repetitive: one dummy constant per page plus one testMode guard per `Refresh*` handler. Building Phase 3 after Phase 2 reuses the `TestData.elm` module structure already established.
**Delivers:** `#stand`, `#wedstrijden`, `#groepsstand`, `#knockouts`, `#topscorer` all render without network in test mode.
**Addresses:** `Dummy data for all 4 results pages`
**Avoids:** Pitfall 2 (dummy data semantic mismatch — derive from `Bets.Init` data rather than hand-written literals)
**Note:** The guard pattern is identical for all 4 handlers; this phase is largely mechanical once the pattern is established.

### Phase 4: Fill All

**Rationale:** "Fill all" is the highest-complexity task because `filledBet` must satisfy `isCompleteQualifiers`, `GroupMatches.isComplete`, and `BracketCard` `WizardState` consistency simultaneously. Building this last means Phases 1-3 infrastructure is already proven before tackling the hard part.
**Delivers:** Tapping `[fill all]` on the Dashboard instantly populates all 36 group matches, the full WC2026 bracket (including best-third T1-T8 assignments), a topscorer selection, and participant fields. Dashboard shows all `[x]`.
**Addresses:** `"Fill all" button on DashboardCard`
**Avoids:** Pitfall 3 (invalid bracket via rebuildBracket bypass), integration gotcha (WizardState vs Bet.answers.bracket sync)
**Key constraint:** `filledBet` must route through `rebuildBracket` or hardcode a deterministic pre-assigned bracket using known T1-T8 slot constraints — never directly mutate `Bet.answers.bracket` without also updating `WizardState.selections`.

### Phase Ordering Rationale

- Phase 1 must come first because `testMode : Bool` is the root dependency of every other feature; the FEATURES.md dependency graph makes this explicit
- Phases 2 and 3 are independent of each other; they share only the Phase 1 flag; their ordering is flexible but sequential construction of `TestData.elm` is cleaner
- Phase 4 last because `filledBet` is the most data-intensive task and risks breaking `isCompleteQualifiers` invariants established by issue #93; it should be validated after simpler features are proven
- This order matches the ARCHITECTURE.md suggested build order exactly and the PITFALLS.md pitfall-to-phase mapping

### Research Flags

Phases needing no additional research (well-documented patterns from codebase):
- **Phase 1:** Pure TEA scaffolding — model fields, Msg variants, URL routing, elm-ui onClick. All patterns verified in existing source. Skip research-phase.
- **Phase 2:** Same HTTP bypass pattern established in Phase 1 routing. `TestData.elm` structure is straightforward. Skip research-phase.
- **Phase 3:** Mechanically identical to Phase 2 for 4 additional handlers. Skip research-phase.
- **Phase 4:** The approach is fully specified (see ARCHITECTURE.md Phase 4 section). No unknowns in the pattern; the complexity is data construction, not architectural uncertainty. Skip research-phase but plan the `filledBet` construction sequence explicitly before coding.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All patterns verified against existing codebase source files; no new packages needed; zero speculation |
| Features | HIGH | Feature set derived from codebase analysis of all affected modules; dependency graph is explicit and complete |
| Architecture | HIGH | Based on direct inspection of `src/Types.elm`, `src/Main.elm`, `src/View.elm`, `src/Activities.elm`, `src/API/Bets.elm`, `src/Form/Dashboard.elm`, `src/Results/*.elm` |
| Pitfalls | HIGH | Pitfalls grounded in known Elm compiler behaviour (no tree-shaking by flag) and in previously fixed bugs in this codebase (issue #93 bracket invariants, issue #91 touch conflicts) |

**Overall confidence:** HIGH

### Gaps to Address

- **`filledBet` exact construction sequence:** The approach is clear (use `rebuildBracket`, derive from `Bets.Init.bet`) but the precise sequence of setter calls across 36 match IDs and all bracket slots needs to be enumerated during Phase 4 planning. The WC2026 match ID list (`m01`-`m48` for groups, `m73`-`m88` for R1) should be confirmed against `Tournament.elm` before writing `TestData.filledBet`.
- **`WizardState.selections` type shape:** ARCHITECTURE.md notes that `BracketCard` state (`bracketState`) must be updated alongside `Bet.answers.bracket` for "fill all". The exact `RoundSelections` field names need to be read from `src/Form/Bracket/Types.elm` before Phase 4 implementation to avoid the anti-pattern of direct bracket mutation.
- **iOS 5-tap gesture validation:** PITFALLS.md flags a potential conflict between the 5-tap gesture's `Element.Events.onClick` and the scroll wheel's `preventDefaultOn "touchend"`. The scroll wheel is scoped to `GroupMatchesCard` and the title tap is on `viewHome`, so in practice the conflict should not occur — but this must be verified on a real iOS device during Phase 1 testing.

## Sources

### Primary (HIGH confidence)
- Direct codebase inspection: `src/Types.elm`, `src/Main.elm`, `src/View.elm`, `src/Activities.elm`, `src/API/Bets.elm`, `src/Form/Dashboard.elm`, `src/Form/Bracket.elm`, `src/Bets/Bet.elm`, `src/Bets/Init.elm`, `src/Results/*.elm`
- `.planning/PROJECT.md` — v1.5 milestone specification
- `CLAUDE.md` — project architecture documentation
- `MEMORY.md` — WC2026 bracket slot assignments (T1-T8), issue #93 completeness fix, issue #91 touch handling

### Secondary (MEDIUM confidence)
- Elm Discourse — counter-in-model pattern for click detection (consistent with codebase evidence; corroborates the chosen approach)
- Elm guide flags documentation — flags pattern for init-time configuration

### Tertiary (LOW confidence)
- Android Easter Egg activation pattern (tap N times) — reference for 5-tap gesture UX convention; not Elm-specific

---
*Research completed: 2026-03-14*
*Ready for roadmap: yes*
