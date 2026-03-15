# Pitfalls Research

**Domain:** Adding test/demo mode to existing Elm 0.19.1 SPA (football tournament betting app, v1.5 milestone)
**Researched:** 2026-03-14
**Confidence:** HIGH

---

## Critical Pitfalls

### Pitfall 1: Test Mode Flag Bleeding into Production Bundle

**What goes wrong:**
Test-mode logic (dummy data generators, "fill all" routines, lorem ipsum content) gets compiled into the production `main.js` even when test mode is not active. Production bundle size grows; worse, a user who discovers `#test` in the source or guesses the route can activate the feature unintentionally on the live app. Fake activity posts or pre-filled bets could be submitted to the real backend.

**Why it happens:**
Elm compiles a single bundle from all reachable modules. There is no tree-shaking by feature flag — if `DummyData.elm` is imported anywhere in the module graph, all its definitions are included. Adding a `testMode : Bool` field to `Model` and branching on it at runtime does not remove the code from the bundle; it only controls which branch executes. Developers add dummy data modules, import them at the top level, and forget they are always compiled in.

**How to avoid:**
- Accept that test-mode code will be in the production bundle (this is the Elm reality). Mitigate the risk differently:
  - Ensure the "fill all" button's `update` branch never calls `API.Bets.placeBet` or any HTTP command. All test-mode actions should be pure model transformations.
  - Gate offline activity submission explicitly: when `model.testMode` is `True`, the `SaveComment` / `SavePost` update branches should produce `Cmd.none` and append locally instead of calling the API.
  - Add a clear comment block at the top of every dummy-data-producing function: `-- TEST MODE ONLY: never called from real submit paths`.
- Keep all dummy data in a single module (e.g. `TestMode.Dummy`) so the blast radius of accidental leakage is contained and easy to audit.

**Warning signs:**
- Network tab shows a POST to `/activities` or `/bets` after clicking a test-mode action.
- `API.Bets.placeBet` appears in a code path reachable from the "fill all" `update` branch.
- `elm-analyse` or a grep for `HTTP` calls shows test modules producing `Cmd Msg` values that aren't `Cmd.none`.

**Phase to address:** Phase 1 — test mode flag + routing. Decide the "no API calls in test mode" invariant before writing any dummy data.

---

### Pitfall 2: Dummy Data Not Matching Real Data Shapes (Type Mismatches)

**What goes wrong:**
Dummy `MatchResult`, `KnockoutsResults`, `TopscorerResults`, or `Activity` values are hand-written and omit fields, use wrong `Group` constructors, or reference non-existent team IDs. The Elm compiler catches structural mismatches but not semantic ones: a dummy `MatchResult` can have `group = A` while referring to a match ID that belongs to group G in the real data. The results views render garbage — wrong group labels, broken score coloring, missing flag SVGs (`?` placeholder instead of a real flag).

**Why it happens:**
Elm's type system guarantees the dummy record matches the alias shape. It cannot guarantee that `homeTeam.teamID = "USA"` corresponds to a team registered in `teamData`, or that the match ID `"m01"` belongs to the group the result claims. The gap between structural validity and semantic validity is large for this domain.

**How to avoid:**
- Build dummy data by calling the same initialisation functions the real bet uses. For group match results: iterate `Bets.Init.groupsAndFirstMatch` and generate a `MatchResult` per real match ID. This guarantees match IDs and group assignments are consistent with `Tournament.elm`.
- For bracket dummy data: run `rebuildBracket` with a deterministic set of selections rather than hand-constructing a `Bracket`. This guarantees the bracket tree structure is valid.
- For dummy `Activity` values: use the real `AComment`, `APost`, `ANewBet` constructors with plausible `ActivityMeta` (a fixed `Time.Posix` value like `Time.millisToPosix 0` is fine for display purposes).
- For `KnockoutsResults`: pull team objects from `Bets.Init.teamData` by `teamID` lookup rather than inventing `Team` record literals. This ensures the `flag` and `code` fields are real values.

**Warning signs:**
- Results pages show `?` SVG placeholders (unknown team ID) for teams that should be known.
- Group standings view groups matches into the wrong group column.
- Score coloring (amber for actual score) applies to cells that should be unstyled.
- Any `Maybe.withDefault` in a view fires unexpectedly often during test-mode page visits.

**Phase to address:** Phase 2 — dummy data construction. Write dummy data derivation from real init data, not as freestanding literals.

---

### Pitfall 3: "Fill All" Creating an Invalid Bracket State

**What goes wrong:**
The "fill all" action pre-fills the bracket by directly manipulating `Bet.answers.bracket`. If this bypasses `rebuildBracket` and `assignBestThirds`, the resulting bracket can violate the BestThird constraint: T1–T8 slots require specific group combinations (T3 must come from D/E/I/J/L, etc.). An invalid assignment means `isCompleteQualifiers` returns `False` even though the bracket appears full, and the submit card shows the bracket as incomplete.

Additionally, the wizard's `WizardState` (the `BracketWizard { selections, viewingRound }` in `BracketCard`) is separate from `Bet.answers.bracket`. If "fill all" writes to the `Bet` directly without updating `WizardState.selections`, the wizard UI shows empty round grids while the `Bet` is already filled. The user then sees the bracket card as incomplete in the form progress rail even though `isCompleteQualifiers` returns `True` — or vice versa.

**Why it happens:**
`rebuildBracket` is the canonical path for converting wizard selections into a valid `Bracket`. It knows the BestThird slot definitions (T1–T8 group constraints) and applies the constrained greedy algorithm. Bypassing it means re-implementing that logic, which is error-prone. Keeping `WizardState` in sync with a direct `Bet` mutation requires updating both the `bracketState` payload inside `BracketCard` and `bet.answers.bracket`.

**How to avoid:**
- Implement "fill all" by constructing a complete `RoundSelections` record (one team per group for `lastThirtyTwo`, etc.) and calling `rebuildBracket selections Bets.Init.teamData`. Store the result via `updateBracket`.
- Also update the `BracketCard`'s `bracketState` so `WizardState.selections` mirrors the filled values. Use `addTeamToRound` in a fold over all teams to produce the `RoundSelections`.
- After filling, verify `isCompleteQualifiers model.bet` returns `True` before showing the "filled" success indicator.

**Warning signs:**
- After "fill all", the bracket card progress indicator shows `[.]` (incomplete) instead of `[x]`.
- Navigating to the bracket card shows an empty wizard despite the Bet being filled.
- The submit summary shows "bracket: incomplete" even though every round has selections.
- `isCompleteQualifiers` returns `False` after programmatic fill.

**Phase to address:** Phase 3 — "fill all" implementation. Test `isCompleteQualifiers` explicitly after the fill action as a correctness gate.

---

### Pitfall 4: Tap-Gesture to Activate Test Mode Conflicts with Existing Touch Handlers

**What goes wrong:**
The 5-tap-on-title gesture to activate test mode uses `onClick` or a counter in the model. On the home page, the title element is inside the same DOM subtree that handles `touchstart`/`touchend` for the group matches scroll wheel. If the scroll wheel's `preventDefaultOn "touchend"` has leaked to a parent element (see existing Pitfall 9 from v1.1 research), rapid taps on the title may be consumed by the touch handler and not reach the Elm `onClick` listener, making the gesture non-functional on iOS.

Additionally, if the title tap counter is stored in a transient part of the model (e.g. inside a `Card` variant's state), navigating away from the home page resets it. Users who partially tap (3 out of 5) and then navigate away must start over.

**Why it happens:**
`onClick` on elm-ui elements is an `Element.Events.onClick` which maps to a DOM `click` event. On iOS, `click` events fire reliably on tappable elements but can be delayed by ~300ms if `touch-action: none` or `preventDefault` is being called on touch events higher in the tree. The scroll wheel's `preventDefaultOn "touchend"` is scoped to the `GroupMatchesCard` column, but if Home view renders any shared parent that also has touch attributes, the conflict appears.

**How to avoid:**
- Store the tap counter at the top `Model` level (e.g. `titleTapCount : Int`) rather than inside any card variant's state. This survives navigation.
- Use `Element.Events.onClick` on the title element; do not use `onMouseDown` or `onTouchStart` — `click` is safe on the home page since the scroll wheel's `preventDefaultOn` only applies when the GroupMatchesCard is rendered.
- Add a comment explaining the gesture intent so future developers don't remove the click handler thinking it is dead code.
- Test on a real iOS device: tap the title 5 times quickly. Verify the `TestMode` badge appears.

**Warning signs:**
- Tap count resets to 0 after navigating away from home and returning.
- Rapid tapping on the title on iPhone does nothing (no `TestMode` badge appears after 5 taps).
- `model.testMode` stays `False` despite clicking the title multiple times in DevTools element inspector.

**Phase to address:** Phase 1 — test mode activation. Decide where to store `titleTapCount` before implementing the gesture.

---

### Pitfall 5: Test Mode Persisting Unexpectedly Across Reloads via localStorage

**What goes wrong:**
If test mode state is persisted to `localStorage` (e.g. to survive a refresh during development), a developer or user who activates test mode will find it still active after closing and reopening the app. If dummy data is shown in the `#stand` ranking view or `#wedstrijden` results view, users will see fake results as if they were real. Test mode must be session-scoped only.

Conversely, if test mode is stored only in the Elm model (ephemeral), the `#test` URL route can still be bookmarked or shared. Navigating directly to `#test` from a bookmark should activate test mode correctly. If the `SetApp` / `UrlChange` handler does not set `model.testMode = True` when the `#test` fragment is seen, the route activates the wrong app view.

**Why it happens:**
The `Flags` record is read once at `init` from `localStorage` values. The existing `installBannerDismissCount` precedent shows the pattern of persisting small state to `localStorage` via a JS port. It is tempting to add `testMode` to the same mechanism. The problem is intentionality: `installBannerDismissCount` is meant to persist; test mode is not.

**How to avoid:**
- Store `testMode : Bool` in the Elm `Model` only — never write it to `localStorage` or any port.
- The `#test` route handler in `getApp` (in `View.elm`) should emit a `SetTestMode True` `Msg` which the `update` function handles by setting `model.testMode = True` and navigating to `Home`. This means navigating away from `#test` clears the URL fragment but the model flag persists for the session.
- On `Restart` (which resets the model to `init`), `testMode` resets to `False` automatically since `init` does not read it from any persistent source.
- Do NOT add `testMode` to the `Flags` type.

**Warning signs:**
- After activating test mode, closing the browser tab, reopening the app: dummy data still visible on results pages.
- `localStorage.getItem('testMode')` returns a non-null value in the browser console.
- `#test` fragment in the URL bar after navigating away from the activation route.

**Phase to address:** Phase 1 — test mode flag and routing. The `Model` field and its initialisation must be established first.

---

### Pitfall 6: Nav Item Visibility Changes Breaking Layout on Narrow Screens

**What goes wrong:**
In production, the nav `linkList` in `View.elm` shows only `[ Home, Ranking, Form ]` for unauthenticated users. In test mode, all nav items (`Home, Ranking, Form, Results, GroupStandings, KOResults, TSResults, Blog, Bets`) must be visible regardless of auth state. On a 320px phone, 9 nav items in a `wrappedRow` with `spacing 4` requires at least two rows. If the nav container's height is not flexible (fixed pixel height or `height fill` inside an `inFront` overlay), the second row overflows or is clipped.

**Why it happens:**
The nav links are rendered in an `Element.wrappedRow` which does wrap, but the outer `inFront` overlay column (used for the install banner and status bar) may constrain vertical space. If the nav height changes unexpectedly, the `inFront` content below the nav (status bar, install banner) shifts or overlaps with page content. The transition from 3-item nav to 9-item nav is a 3x height jump that was never tested.

**How to avoid:**
- Test the 9-item nav at 320px and 375px in DevTools responsive mode before shipping. Verify `wrappedRow` produces two rows without overflow, and that the content area below is not obscured.
- Consider abbreviating nav labels in test mode to their shortest form (`home`, `form`, `stand`, `uitslagen`, `groep`, `ko`, `ts`, `blog`, `bets`) — they are already short, but verify character width at 320px monospace.
- If the nav wraps to two rows, ensure `Element.column` containing the nav links uses `Element.height Element.shrink` (not `fill`) so the main content reflows naturally below it.

**Warning signs:**
- Page content is obscured behind the nav in test mode on a 375px screen.
- Nav items on the second wrap row are visually cut off.
- The horizontal separator below the nav (`Border.widthEach { bottom = 1, ... }`) appears mid-screen instead of directly below the last nav row.

**Phase to address:** Phase 1 — test mode activation (nav visibility change). Verify layout at narrow widths before declaring the phase complete.

---

### Pitfall 7: Offline Activity Submission Creating Inconsistent UI State

**What goes wrong:**
In test mode, submitting a comment or post appends locally (no HTTP call). The locally appended `Activity` value needs a plausible `ActivityMeta` with a `Time.Posix` timestamp and a UUID. If the timestamp is always `Time.millisToPosix 0`, all local activities show `[00:00]` — obviously fake but harmless. If the UUID is always the empty string `""` or a hardcoded constant, toggling `active` flags (admin feature) might accidentally match a real UUID in the list.

The more serious issue: `model.activities.activities` is `WebData (List Activity)`. When the user submits in test mode, the new local activity must be prepended to the current `Success` list. But if `activities` is still `NotAsked` (user has not yet fetched activities in this session), the prepend has nothing to attach to. The result is the new activity list is `Success [ localActivity ]` with no real activities below it — which looks correct but resets the entire activity feed to one item.

**Why it happens:**
`SaveComment` and `SavePost` normally fire an HTTP command and await `SavedComment (WebData (List Activity))` which replaces the full activity list from the server response. In test mode the replacement must be performed immediately and locally. The logic for building the new list is: `Success (localActivity :: existingList)`. If `existingList` is derived from `RemoteData.withDefault [] model.activities.activities`, the `NotAsked` case produces `[]` silently.

**How to avoid:**
- In test mode, before appending, check whether `model.activities.activities` is `Success list`. If so, prepend the new activity and set the result to `Success (newActivity :: list)`. If it is `NotAsked` or `Loading`, first set the activities to `Success [ newActivity ]` — this is acceptable since test mode does not require real feed data.
- Generate test activity UUIDs using a counter field on the model (e.g. `testActivityCounter : Int`) rather than a fixed string, to avoid UUID collisions.
- Generate timestamps using a fixed offset from a known epoch rather than `Time.millisToPosix 0`. The `Time.Zone` is already in `model.timeZone` so `UI.Text.timeText` will format it. A fake timestamp 1 minute in the past per submission (subtract `testActivityCounter * 60000`) keeps them ordered correctly.

**Warning signs:**
- After submitting a test comment, the activities feed shows only 1 item instead of the local addition plus prior content.
- All local test activities show `[00:00]` in the timestamp column even when submitted at different times.
- The activity list shows a `Loading` spinner indefinitely after a test comment submit.

**Phase to address:** Phase 4 — offline activity submission. Implement and test both the "activities already fetched" and "activities not yet fetched" code paths explicitly.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Hard-code dummy `MatchResult` values as literals | Quick to write | Dummy team IDs diverge from real `teamData`; results views show `?` placeholders | Never; derive from `Bets.Init` data instead |
| Store `testMode` in `localStorage` for convenience during development | Survives hot-reload | Persists to real user sessions; fake data shown as real results | Never in committed code; use session model only |
| Implement "fill all" by directly setting `Bet.answers` fields without updating `WizardState` | Simpler — one record update | Wizard UI is out of sync; bracket card shows empty despite being filled; `isCompleteQualifiers` may still fail | Never; always go through `rebuildBracket` |
| Apply test-mode badge globally via `inFront` at the outermost layout without measuring height impact | Straightforward placement | Badge may overlap form nav bar or submit button on 375px screens | Acceptable if tested at 375px before shipping |
| Use a single hardcoded UUID for all test activity entries | No UUID dependency | If admin toggle-active logic uses UUID matching, it may accidentally match a real bet UUID | Avoid; use a counter or a clearly fake prefix like `"test-"` |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| `GroupMatchMsg` in test mode "fill all" | Dispatching 36 `GroupMatchMsg (Update matchID h a)` messages individually from `update` | Use `Bets.Bet.setMatchScore` in a `List.foldl` directly on the `Bet` in a single update step; do not dispatch side-effecting Msgs |
| `BracketCard` state vs `Bet.answers.bracket` | Updating `Bet.answers.bracket` without updating `BracketCard`'s `WizardState.selections` | Rebuild both: call `rebuildBracket` for the Bet, and reconstruct `RoundSelections` for `WizardState` in the same update |
| Dummy `KnockoutsResults` team references | Hand-writing `Team { teamID = "NED", ... }` literals | Lookup teams from `Bets.Init.teamData` by `teamID` so `flag`, `code`, and `name` fields are real |
| Test mode nav + `model.token` gating | `linkList` in `View.elm` gates on `model.token == Success _`; adding test mode requires a separate check | Add `model.testMode` as an additional condition: `if model.testMode then allNavItems else if token... then adminItems else basicItems` |
| Offline `SaveComment` in test mode | Calling `Activities.update SaveComment state` which fires an HTTP command | Branch in the top-level `update` on `model.testMode` before delegating to the Activities update; short-circuit to a pure local append |

---

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| "Fill all" triggering 36 re-renders via individual Msgs | UI flickers or is slow on low-end phones | Single `update` step that sets all 36 match scores in one `List.foldl` on the `Bet` | Any phone with < 2GB RAM if individual Msgs are used |
| Dummy results data re-computed on every `view` call | Slight jank when navigating results pages in test mode | Derive dummy data once in `update` when test mode activates; store as `WebData` in model fields (`matchResults`, etc.) | Every view recomposition if dummy data is a `view`-layer computation |

---

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| Test mode "fill all" calling `API.Bets.placeBet` | Dummy bet submitted to real backend; pollutes real ranking data | All test-mode update branches must produce `Cmd.none`; add a `Debug.todo` or assertion comment at branch boundaries |
| Test route (`#test`) activating test mode with no confirmation | Any user who discovers the route activates it; confused by fake data | The route is acceptable (non-destructive); but ensure a visible "TEST MODE" badge is always shown so users know they are in test mode |
| Fake activity posts submitted to real backend | Spam in the activities feed visible to all users | `SaveComment`/`SavePost` in test mode must never call `API.*` endpoints; branch on `model.testMode` before any HTTP command |

---

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| No persistent test mode indicator | User activates test mode, navigates pages, forgets they are in test mode, confused by fake results | Show a small, always-visible badge (e.g. `[ TEST ]` in amber) in the nav or as a status bar overlay while `model.testMode` is `True` |
| "Fill all" leaves form on the DashboardCard | User clicks "fill all" but has to navigate manually to see that all sections are complete | After "fill all", update `model.idx` to show the DashboardCard (index 0) so the `[x][x][x][x]` completion state is immediately visible |
| Test mode reachable via `#test` URL fragment on production | Non-technical users who receive a shared link with `#test` fragment are confused by fake data | Acceptable for this app size (small friend group); document the route but do not advertise it |
| Dummy activities look identical to real ones | Users cannot distinguish test-mode data from real activity | Prefix all test activity authors with `[TEST]` or add a `--- test mode ---` separator at the top of the feed |

---

## "Looks Done But Isn't" Checklist

- [ ] **Test mode flag is session-only:** `localStorage` has no `testMode` key after activating test mode and reloading. `Flags` type in `Types.elm` has no `testMode` field.
- [ ] **No API calls in test mode:** Open DevTools Network tab, activate test mode, click "fill all" and submit a comment. Zero POST/PUT requests appear.
- [ ] **"Fill all" passes completeness check:** After "fill all", `model.bet` satisfies `isCompleteQualifiers` for the bracket and `GroupMatches.isComplete` for group matches. Dashboard shows all `[x]`.
- [ ] **Bracket wizard UI reflects filled state:** Navigate to BracketCard after "fill all". The wizard shows each round's selections, not empty grids.
- [ ] **9-item nav renders at 320px:** Test at 320px width in DevTools responsive mode. No overflow, no hidden items, content below nav is not obscured.
- [ ] **Dummy data uses real team IDs:** All dummy `MatchResult`, `TeamRounds`, and `TopscorerResults` values reference team IDs present in `Bets.Init.teamData`. No `?` placeholder SVGs appear on results pages.
- [ ] **Offline comment append works when feed is empty:** In a fresh session (activities `NotAsked`), submit a test comment. One item appears in the feed; no loading spinner.
- [ ] **Test mode badge always visible:** Navigate through all 5 views (`home`, `stand`, `wedstrijden`, `groepsstand`, `knock-out`, `topscorer`) in test mode. The `[ TEST ]` badge is visible on every page.
- [ ] **5-tap gesture works on real iOS:** Tap the title 5 times quickly on an iPhone. `[ TEST ]` badge appears. Tap counter survives navigating away and back to home.

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Test mode accidentally writes to backend | HIGH | Identify which update branch is missing the `testMode` guard; add the guard; redeploy. On the backend, delete the dummy bet/activity if it reached the API. |
| "Fill all" produces incomplete bracket | LOW | Replace the direct `Bet` mutation with a call to `rebuildBracket`. One-function fix. |
| Dummy data diverges from real team IDs | MEDIUM | Replace literal `Team` records with lookups from `Bets.Init.teamData`; test all 4 results pages in test mode. |
| Nav overflow at 320px in test mode | LOW | Reduce `paddingXY 0 8` on the nav row or abbreviate one nav label by 1–2 characters. One-line fix in `View.elm`. |
| Test mode persisting via localStorage | LOW | Remove the `port persistTestMode` call or the `localStorage.setItem('testMode', ...)` line in `index.html`; clear `localStorage` on existing devices via browser console. |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Test mode code calling real API | Phase 1 — test mode flag + routing | Network tab shows zero HTTP calls during test-mode actions |
| Dummy data type/semantic mismatch | Phase 2 — dummy data construction | Results pages render with no `?` SVG placeholders in test mode |
| "Fill all" invalid bracket state | Phase 3 — fill all implementation | `isCompleteQualifiers` returns `True`; bracket card shows `[x]` |
| Tap gesture + touch handler conflict | Phase 1 — test mode activation | 5-tap gesture works on real iOS device |
| Test mode persisting across reloads | Phase 1 — test mode flag | `localStorage` empty after reload; `Flags` has no testMode field |
| Nav overflow at narrow screens | Phase 1 — test mode activation | DevTools at 320px shows no overflow |
| Offline append on empty feed | Phase 4 — offline activity submission | Submit comment in fresh session; one item in feed, no spinner |

---

## Sources

- Codebase analysis: `src/Types.elm`, `src/View.elm`, `src/Form/Bracket.elm`, `src/Form/GroupMatches/Types.elm`, `src/API/Bets.elm`, `src/index.html`, `src/Bets/Init/WorldCup2026/Tournament.elm`
- Project memory: WC2026 BestThird slot constraints (T1–T8 group assignments), Issue #93 `isCompleteQualifiers` fix, Issue #91 scroll wheel touch handling
- `.planning/PROJECT.md` v1.5 milestone feature list
- Elm 0.19.1 compiler behaviour: all reachable modules included in bundle regardless of runtime branching (no tree-shaking by flag)
- Known iOS Safari `click` event delay on elements with adjacent `preventDefault` touch handlers

---

*Pitfalls research for: adding test/demo mode to Elm 0.19.1 SPA (v1.5 milestone)*
*Researched: 2026-03-14*
