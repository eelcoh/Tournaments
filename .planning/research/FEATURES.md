# Feature Research

**Domain:** Offline test/demo mode for Elm 0.19.1 tournament betting SPA
**Researched:** 2026-03-14
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features a test/demo mode is expected to provide. Missing these makes the mode feel incomplete or broken.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Persistent mode indicator | Without a visible badge, testers lose track of which mode they are in; debugging becomes confusing | LOW | A fixed status bar label `[ TEST MODE ]` in the existing `viewStatusBar` or `inFront` overlay. Model needs `isTestMode : Bool` flag. Already have `installBanner` as a reference pattern. |
| All nav items visible in test mode | Test mode is for seeing the full app; gating nav behind `RemoteData.Success (Token _)` hides results pages that need testing | LOW | `linkList` in `View.elm` currently forks on `model.token`. Add a second condition: `model.isTestMode == True` → show full list regardless of token. |
| Dummy data on all results pages | Results pages (#stand, #wedstrijden, #groepsstand, #knockouts) show `Loading` or `Failure` without a backend; demo is useless if pages are blank | MEDIUM | Static Elm records matching the `RankingSummary`, `MatchResults`, `KnockoutsResults`, `TopscorerResults` types. Set `model.ranking = Success dummyRanking` etc. on test mode activation. No HTTP involved. |
| Lorem ipsum activities on home page | Home page shows `[ ophalen... ]` or empty when backend is unreachable; demo needs something to show | LOW | Static `List Activity` constant in a `Demo.elm` module. On test mode activation, set `model.activities.activities = Success dummyActivities`. No fetch needed. |
| Offline activity submission | Demo submitter clicking `Opslaan` should not silently fail with a network error; local append gives immediate feedback | LOW | In test mode, `SaveComment` and `SavePost` dispatch `SavedComment`/`SavedPost` with a `Success` payload that prepends the new item to the existing list. No HTTP call made. |
| "Fill all" button on Dashboard | Manual form fill for a 36-match + bracket + topscorer bet is the biggest friction in demo and testing | MEDIUM | New `Msg` variant `FillAll`. Handler calls the same setters used by the existing form cards. Requires generating plausible scores (e.g. always 2-1) and picking the first available team at each bracket slot. Must not break existing `Bet` invariants. |

### Differentiators (Competitive Advantage)

Features that make this test/demo mode notably useful beyond the minimum.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Two activation paths: `#test` route + 5-tap title gesture | `#test` is fast for developers; 5-tap is discoverable on mobile without URL editing | LOW | `#test` route: add `TestMode` to `App` type and handle in `getApp` in `View.elm`. 5-tap: `titleTapCount : Int` field in Model; `TitleTapped` Msg; when count reaches 5, set `isTestMode = True`. Standard Android easter-egg pattern. |
| Test mode survives navigation | If navigating to `#stand` exits test mode, the demo breaks | LOW | `isTestMode` lives in Model (not URL). URL routing sets `model.app` only; never clears `isTestMode`. The `#test` route sets both `isTestMode = True` and `app = Home` so the badge appears immediately. |
| Dummy bracket covers all 32 R1 slots | A partial bracket with `TBD` placeholders breaks knockout display; full dummy data shows the real UI | MEDIUM | Use actual WC2026 teams from `initTeamData` to fill bracket slots. The R1 slots are m73-m88. Pick one team per match deterministically (e.g. the team with the alphabetically first country code wins). |
| Blog posts in dummy activities | Showing only comments undersells the activities feature; lorem ipsum blogs demonstrate the richer format | LOW | Include 2-3 `Post` entries alongside 3-4 `Comment` entries in `dummyActivities`. Use recognizable WC2026 country names in content to make the demo feel relevant. |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| localStorage persistence of test mode | "Test mode should survive page reload" | Adds port/flag plumbing for one rarely-needed feature; URL `#test` already re-activates on reload | Use `#test` bookmark or `#test` in the URL; that IS the persistent activation |
| Network interception / service worker mock | Full isolation from backend | Service worker is already in play for caching; intercepting API calls there risks breaking production caching logic | Elm-side branching on `isTestMode` flag is simpler and fully contained in Elm |
| Separate demo build / feature flags at compile time | "Don't ship test code to production" | Elm's `--optimize` tree-shaking is not reliable for removing test code; managing two builds doubles CI surface | Test mode code is harmless at runtime (behind a flag); the activation gesture requires deliberate action; not a security concern for a private betting pool |
| Randomized dummy data on every activation | "More realistic demo" | Random values require `Random` module + `Cmd Msg` on activation; complicates testing since data changes every run | Fixed deterministic dummy data is reproducible, easier to describe in docs, no `Cmd` needed |
| Full fake HTTP layer (intercept all requests) | Mirrors how mock server tools work | Requires JS service worker changes or Ports for every API call; fragile, hard to maintain | Elm-side `isTestMode` guard before every `Cmd` emit; cleaner and contained |
| Reset bet on test mode exit | "Clean up after demo" | Unexpected state destruction; user may have been building a real bet before activating test mode | Never destroy bet on mode change; "Fill all" is additive. Restart button already exists for explicit reset. |

## Feature Dependencies

```
[isTestMode flag in Model]
    required by --> [Persistent mode indicator badge]
    required by --> [All nav items visible]
    required by --> [Dummy data injection on activation]
    required by --> [Offline activity submission]
    required by --> ["Fill all" button renders]

[#test route (TestMode App variant)]
    sets --> [isTestMode = True]
    sets --> [model.app = Home]
    requires --> [isTestMode flag in Model]

[5-tap title gesture]
    sets --> [isTestMode = True]
    requires --> [titleTapCount : Int in Model]
    requires --> [TitleTapped Msg]
    independent of --> [#test route]

[Dummy data constants (Demo.elm)]
    required by --> [Dummy activities on home page]
    required by --> [Dummy data on results pages]
    required by --> [Lorem ipsum blogs]
    independent of --> [HTTP/API modules]

[Offline activity submission]
    requires --> [isTestMode flag]
    modifies --> [SaveComment / SavePost handlers in Main.elm update]
    conflicts --> [real HTTP saveComment / savePost] (branch, not both)

["Fill all" button]
    requires --> [isTestMode flag] (only renders in test mode)
    requires --> [existing Bet setters: GroupMatch.set, Bracket.setBulk, setTopscorer]
    depends on --> [initTeamData to pick realistic teams for bracket]
    must not conflict --> [existing form card state] (state stays in sync after fill)
```

### Dependency Notes

- **isTestMode is the root dependency:** Every feature in this milestone gates on this single boolean. Add it to `Model` and `init` first.
- **Dummy data is read-only Elm constants:** No HTTP, no Ports, no Tasks. They are just `List Activity`, `RankingSummary`, etc. values defined in a new `Demo.elm` module. Zero runtime cost.
- **"Fill all" requires Bet setters to be correct:** The same setters used by the wizard and group match form are used here. If those work (they do, per v1.3 issue #93 fix), "Fill all" works by calling them in sequence.
- **Offline submission is a conditional branch, not a mock layer:** In `Main.elm` update, where `SaveComment` currently emits `Activities.saveComment model.activities`, add: `if model.isTestMode then SavedComment (Success (newComment :: existingList)) else Activities.saveComment ...`.
- **5-tap gesture and #test route are independent activators:** Either path sets `isTestMode = True`. The flag does not distinguish how it was activated.

## MVP Definition

### Launch With (v1.5)

Minimum viable to call this "test/demo mode."

- [ ] `isTestMode : Bool` in Model + `init` sets it False — the root of everything else
- [ ] `#test` route sets `isTestMode = True` — developer activation path
- [ ] `[ TEST MODE ]` badge visible in status bar when `isTestMode == True` — orientation anchor
- [ ] All nav items shown when `isTestMode == True` — unlocks the pages to test
- [ ] `Demo.elm` with dummy activities (3-4 comments + 2 blogs) injected on activation — home page functional offline
- [ ] Dummy data for all 4 results pages (ranking, matches, group standings, knockouts) — all pages show something
- [ ] Offline comment submission in test mode (prepend to list, no HTTP) — form interaction works
- [ ] "Fill all" button on DashboardCard in test mode — fills 36 group matches + bracket + topscorer in one tap

### Add After Validation (v1.x)

- [ ] 5-tap title gesture activation — discoverable on mobile without URL access; low complexity, add immediately after core works
- [ ] Offline blog post submission in test mode — same pattern as comment; add alongside comment
- [ ] Dummy topscorer results page — complete the set; same pattern as other results pages

### Future Consideration (v2+)

- [ ] Seed-based randomized dummy data — reproducible yet varied; only needed if demo is shown to many different people
- [ ] Test mode reset button — clears dummy data and exits mode; only if users request it

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| isTestMode flag in Model | HIGH | LOW | P1 |
| #test route activation | HIGH | LOW | P1 |
| TEST MODE badge in status bar | HIGH | LOW | P1 |
| All nav items in test mode | HIGH | LOW | P1 |
| Dummy activities (comments + blogs) | HIGH | LOW | P1 |
| Dummy data for ranking page | HIGH | LOW | P1 |
| Dummy data for match results page | HIGH | MEDIUM | P1 |
| Dummy data for group standings page | HIGH | MEDIUM | P1 |
| Dummy data for knockouts page | HIGH | MEDIUM | P1 |
| "Fill all" button on Dashboard | HIGH | MEDIUM | P1 |
| Offline comment submission | MEDIUM | LOW | P1 |
| 5-tap title gesture | MEDIUM | LOW | P2 |
| Offline blog post submission | MEDIUM | LOW | P2 |
| Dummy topscorer results | LOW | LOW | P2 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Implementation Notes Per Feature

### Test Mode Activation

Two patterns are industry-standard for hidden demo modes:

1. **URL route:** Navigate to `#test`. This is the simplest Elm-native approach. Add `TestMode` to the `App` type (or handle the route without adding to `App`), set `isTestMode = True` in the `UrlChange` handler. Redirect `app` to `Home` after setting the flag so the user lands somewhere visible.

2. **N-tap easter egg:** The Android easter egg pattern (tap version number N times in Settings) is the reference implementation. In this codebase: add `titleTapCount : Int` to `Model`; add `TitleTapped` to `Msg`; wire an `onClick` to the page title text in `View.elm`; when `titleTapCount >= 5`, set `isTestMode = True`. Reset count on deactivation. This is the exact same pattern used in Android Settings for unlocking Developer Options.

Both patterns are additive (no existing code removed) and reversible (a `Msg` to exit test mode suffices).

### Dummy Data Construction

The dummy data types are already defined in `Types.elm`:
- `RankingSummary` = `List RankingGroup` where `RankingGroup` has participant name, points, round scores
- `MatchResults` = `List MatchResult` (group, home team, away team, home score, away score, datetime)
- `KnockoutsResults` = the bracket tree with actual teams filled in at each node
- `TopscorerResults` = `List (Topscorer, Points)`

The dummy data can reuse the existing `initTeamData` team records (Netherlands, Germany, Brazil, etc.) and invent plausible scores. No external data needed. Placing this in a dedicated `Demo.elm` module keeps production code untouched.

### "Fill All" Implementation

The fill order must respect dependencies:
1. Fill group match scores first (36 matches, always 2-1 home wins for simplicity)
2. Compute qualifiers from those scores (top 2 per group + best 8 thirds)
3. Use the same `assignBestThirds` logic already in `Form.Bracket` (issue #93 fix)
4. Fill bracket by walking R32 → R16 → QF → SF → F → Champion (same direction as wizard, using first team in each slot)
5. Fill topscorer with the first player from `initTeamData`

This is a pure Elm transformation: `Bet -> Bet`. No `Cmd`, no `Task`. The result replaces `model.bet`.

### Offline Submission

The `Activities.saveComment` and `Activities.savePost` functions return `Cmd Msg`. In test mode, instead of emitting those commands, generate the `SavedComment`/`SavedPost` message directly with a constructed `Success` value. The existing `FetchedActivities` decoder path and the view are unchanged — the only difference is how the new list is produced.

## Sources

- Android Easter Egg activation pattern (tap N times): standard OS UX pattern since Android 2.3; reference implementation in Android Settings "About phone" screen
- Elm `Browser.application` URL routing: fragment routing via `Url.fragment` in `UrlChange` handler (existing pattern in `View.elm` `getApp` function)
- Codebase analysis: `View.elm` `linkList` forks on `model.token` — same fork point for `isTestMode`
- Codebase analysis: `Types.elm` `Model` already has `installBannerDismissCount : Int` as precedent for tap-count state
- Codebase analysis: `Activities.elm` `saveComment` returns `Cmd Msg` — can be conditionally bypassed
- Codebase analysis: `Form.Bracket` `assignBestThirds` is the correct function to call when filling bracket (issue #93)
- Issue #93 fix: `Bets.Bet.isComplete` uses `Bracket.isCompleteQualifiers` — fill-all must set qualifiers via `setBulk`, not match winners

---
*Feature research for: Offline test/demo mode — Elm 0.19.1 tournament betting SPA*
*Researched: 2026-03-14*
