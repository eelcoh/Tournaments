# Codebase Concerns

**Analysis Date:** 2026-02-23

## Tech Debt

**No Testing Framework:**
- Issue: Elm test suite not configured; no test files exist
- Files: `elm.json` (empty `test-dependencies`), no `*Tests.elm` or `*.test.elm` files found
- Impact: Critical changes (bracket wizard, completeness checks) lack test coverage; regressions go undetected until user reports
- Fix approach: Add `elm-test` to `elm.json`, create test files for core logic in `src/Tests/`, particularly `Form.Bracket`, `Form.GroupMatches`, and `Bets.Bet` completeness functions

**Hardcoded API Endpoints:**
- Issue: All API endpoints hardcoded as relative paths (e.g., `/bets/`, `/activities`, `/authentication/authentications`)
- Files: `src/API/Bets.elm`, `src/Activities.elm`, `src/Authentication.elm`, `src/Results/Bets.elm`, `src/Results/Knockouts.elm`, `src/Results/Matches.elm`, `src/Results/Ranking.elm`, `src/Results/Topscorers.elm`
- Impact: Backend URL cannot be configured without code changes; cross-origin requests in dev/staging require infrastructure workarounds
- Fix approach: Add API base URL to `Flags` in `src/Types.elm` and `index.html`, pass through all modules, use centralized URL builder function

**Commented-out Code:**
- Issue: Significant commented sections in `src/API/Bets.elm` (lines 14-39), `src/Authentication.elm` (test logic), partial implementations in tournament files
- Files: `src/API/Bets.elm` (commented JSON encode/decode fallback), `src/Bets/Init/Euro2024/Tournament.elm` (line 200: `Debug.todo`)
- Impact: Confusing for maintainers; unclear if dead code or planned features; violates code clarity principle
- Fix approach: Delete dead commented code; convert TODOs to issue trackers; clarify unfinished work with proper documentation

**No Error Logging/Reporting:**
- Issue: HTTP failures caught but not logged; only `RemoteData.Failure` state without contextual information about what failed
- Files: Throughout `src/API/` and `src/Results/` modules where `Failure` is handled but only displays generic messages
- Impact: Hard to debug API issues; users see "Oeps. Daar ging iets niet goed" without knowing what happened
- Fix approach: Add error message propagation to `Failure` states; log failures to console in development; consider error tracking service

## Known Bugs

**Bracket Slot Assignment Edge Cases:**
- Issue: `assignBestThirds` greedy algorithm can fail for specific 8-group combinations (e.g., A,B,C,D,E,F,K,L where L has only T3 but D claims it first) — PARTIALLY FIXED in Issue #93
- Files: `src/Form/Bracket.elm` (lines 213-243: `assignBestThirds` with sort fix), `src/Form/Bracket/View.elm` (line 245: completeness check for all groups)
- Trigger: User selects groups where third-place teams have very limited slot options
- Workaround: Manual reselection of bracket picks; limitation documented in code comments
- Note: Issue #93 added sorting by `countOptions` ascending but edge cases may still exist for WC2026's 12-group setup with T1-T8 slots

**GroupMatches Cursor Jump Bug Potential:**
- Issue: `updateCursor` with `Implicit` mode in scroll operations relies on match order in `bet.answers.matches`; if list mutation occurs before cursor update, cursor may point to wrong match
- Files: `src/Form/GroupMatches.elm` (lines 51-62: ScrollDown/ScrollUp), `src/Form/GroupMatches/Types.elm` (cursor state management)
- Trigger: Rapid scroll wheel interactions; async state updates
- Cause: Cursor is match ID string; if match list reordered, cursor validation not enforced
- Workaround: Slow interactions work fine; issue only manifests under high-frequency input
- Fix: Add validation that cursor exists in current match list before render; fallback to first match if invalid

**Form Navigation State Leak:**
- Issue: When navigating away from form then back, `model.cards` and `model.idx` persist; if Bracket or GroupMatches state differs from last session, card state may be stale
- Files: `src/Types.elm` (model initialization), `src/Main.elm` (no reset on route change to Form)
- Trigger: User goes to Home → Form → Home → Form (same tab); bracket selections preserved but form UI doesn't sync
- Impact: Visual inconsistency; card may show "next" as clickable when it shouldn't be
- Fix approach: On `UrlChange` to Form app, verify card states match current bet; reset if mismatch detected

## Security Considerations

**No CSRF Protection:**
- Risk: Bearer token in POST/PUT requests but no CSRF token validation
- Files: `src/Activities.elm` (line 51: Authorization header), `src/Results/*.elm` (token-based API calls)
- Current mitigation: Relies on browser SOP; token not stored in localStorage (only in model/memory)
- Recommendations: Add CSRF token to Flags; include X-CSRF-Token header in modifying requests; validate origin on backend

**Password Transmission:**
- Risk: Authentication form sends credentials in plain HTTP POST
- Files: `src/Authentication.elm` (lines 16-22: `authenticate` function), `index.html` must use HTTPS
- Current mitigation: Must deploy over HTTPS
- Recommendations: Ensure strict HTTPS enforcement in deployment; add CSP headers; consider OAuth/OIDC alternative

**Token Storage:**
- Risk: Auth token held only in Elm model (memory); lost on page refresh; requires re-login
- Files: `src/Main.elm` (line 484: `FetchedToken`), `src/Types.elm` (token in Model)
- Current mitigation: No localStorage/sessionStorage usage (intentional — prevents XSS theft)
- Impact: Poor UX but more secure than localStorage storage
- Recommendations: Consider sessionStorage with clear() on logout; accept UX tradeoff for security

**Email Validation Client-Only:**
- Risk: Email format validated only on client via `Email.isValid` package
- Files: `src/Form/Participant.elm` (line 36: `toStringEmailField`)
- Current mitigation: Backend presumably validates again
- Recommendations: Ensure backend email validation is strict; consider sending confirmation email

## Performance Bottlenecks

**Large Bracket Encoding/Decoding:**
- Problem: WC2026 bracket with 48 teams, complex BestThird slot structure, match tree traversal on every update
- Files: `src/Bets/Types/Bracket.elm` (recursive `Bracket` type), `src/Form/Bracket.elm` (line 98-197: `rebuildBracket` rebuilds entire tree)
- Cause: Every team selection triggers full bracket tree rebuild via `B.setBulk`; tree traversal is O(n) per operation
- Impact: Noticeable lag during bracket fill-out on slower devices (mobile)
- Improvement path: Memoize `rebuildBracket` results; implement incremental updates instead of full rebuild; consider flattening Bracket structure to Dict for O(1) lookups

**TeamData Traversal in Bracket Logic:**
- Problem: `teamsInGroup` helper (line 106-109) filters entire `teamData` list for every group
- Files: `src/Form/Bracket.elm` (line 105-109)
- Cause: O(n*m) traversal where n=groups, m=teamData size
- Impact: 12 groups × ~200+ teams = 2400 comparisons per rebuild
- Improvement: Build a group-indexed lookup map once; reuse for all slot assignments

**Activities View List Rendering:**
- Problem: All activities rendered without virtualization; potentially hundreds of posts/comments
- Files: `src/Activities.elm` (lines 78-79: `List.map (viewActivity tz) activities`)
- Impact: Slow initial render and scroll on activity-heavy tournaments
- Improvement: Implement virtual scrolling; load activities paginated; show only recent 50

**Match List Filtering in GroupMatches:**
- Problem: `viewScrollWheel` and navigation recompute match grouping on every frame
- Files: `src/Form/GroupMatches.elm` (lines 195+: view implementation)
- Cause: Functional recreation of filtered lists; no memoization
- Impact: Smooth scrolling on low-end devices may stutter
- Improvement: Cache grouped matches in state; compute once on initialization

## Fragile Areas

**Bracket Wizard State Synchronization:**
- Files: `src/Form/Bracket.elm`, `src/Form/Bracket/Types.elm`, `src/Form/Bracket/View.elm`
- Why fragile: Complex round-based selection state (`SelectionRound` enum) must stay in sync with actual bracket tree; `rebuildBracket` is single point of truth but logic is intricate
- Safe modification: Always verify:
  1. `RoundSelections` accurately reflects user picks (test with 48-team + best-third combos)
  2. `rebuildBracket` produces valid bracket (all slots filled, no dangling matches)
  3. Slot definitions in tournament files match hardcoded slot IDs in rebuild (m73-m88, m89-m96, etc.)
- Test coverage: No tests; manually verify with different group selections

**Form Card Navigation Flow:**
- Files: `src/Main.elm` (lines 88-128: card update dispatching), `src/Form/View.elm` (lines 26-46: card selection), `src/Types.elm` (Card union)
- Why fragile: 6 card types with different state requirements; pattern matches scattered across Main/Form/View; adding new card requires updates in 3+ locations
- Safe modification: Checklist for new card:
  1. Add variant to `Card` type in `src/Types.elm`
  2. Add `*Msg` type and update handler in `src/Main.elm`
  3. Add card retrieval function in `src/Form/Card.elm`
  4. Add case in `Form.View.viewCard`
  5. Update `Form.View.sectionOf` if new section
  6. Test navigation to/from new card; verify "next"/"prev" buttons work

**Group Match Cursor State:**
- Files: `src/Form/GroupMatches/Types.elm`, `src/Form/GroupMatches.elm`
- Why fragile: Cursor is string MatchID; if match order changes between updates, cursor validation fails silently; touch swipe delta calculation fragile to rapid fires
- Safe modification:
  - Always validate cursor exists after mutations
  - Use `Maybe MatchID` for cursor; handle Nothing case explicitly
  - Test scroll/swipe on touch devices; threshold 30px is tuned for specific viewport

**Topscorer Answer Validation:**
- Files: `src/Form/Topscorer.elm`, `src/Bets/Types/Answer/Topscorer.elm`
- Why fragile: No constraints on topscorer team selection; user could select non-qualified teams; completeness check only validates "at least 3 topscorersfilled", not validity
- Safe modification: Add pre-submission validation that selected topscorersmatch qualified teams list
- Test coverage: None; manual testing of qualified vs unqualified team picks

## Scaling Limits

**Tournament Configuration Coupling:**
- Current capacity: Single active tournament at a time (hardcoded in `src/Bets/Init.elm`)
- Limit: Adding 2+ simultaneous tournaments (e.g., World Cup + regional cup) breaks entire form flow
- Files: `src/Bets/Init.elm` (only one tournament active), `src/Types.elm` (single `Bet` type in model)
- Scaling path:
  1. Change model to `Dict TournamentID Bet`
  2. Add tournament selector card at form start
  3. Parameterize `bracket`, `matches`, `teams` by tournament
  4. Update all update/view functions to pass tournament context

**State Tree Depth with More Tournaments:**
- Problem: WC2026 has 48 teams, 64 matches; next tournament with 96 teams would double tree complexity
- Files: `src/Bets/Types/Bracket.elm`, `src/Form/Bracket.elm`
- Scaling: Flattening structure from tree to Dict would help; current recursion depth ~8 (fine for 64 matches, risky at 128+)

**Activity Feed Memory:**
- Current capacity: Loads all activities into memory (no pagination)
- Limit: ~500+ activities cause noticeable memory/render lag
- Scaling: Implement pagination; fetch 50 activities at a time; implement virtual scrolling in activities list

## Dependencies at Risk

**elm-uuid 2.1.2 (danyx23/elm-uuid):**
- Risk: Unmaintained package (last update 2019); no longer in Elm official registry
- Impact: UUID validation for ranking detail routes relies on external dependency
- Files: `src/View.elm` (line 26: `Uuid.Barebones`, used in lines 295, 305 for UUID validation)
- Migration plan: Replace with custom UUID validation regex `^[a-f0-9-]{36}$` in `src/View.elm` (5-line change); remove dependency

**elm-ui 1.1.8 (mdgriffith/elm-ui):**
- Risk: Stable but large architectural commitment; no major updates since 2020
- Impact: Heavy UI library; if bugs found or performance issues arise, difficult to refactor
- Files: Nearly all view files depend on elm-ui
- Mitigation: Codebase is well-structured around it; no immediate risk

**remotedata-http 4.0.0 (ohanhi/remotedata-http):**
- Risk: Thin wrapper around RemoteData; maintained but low activity
- Impact: All HTTP calls depend on it; loss of maintenance would require custom HTTP wrappers
- Files: `src/API/`, `src/Results/`, `src/Activities.elm`, `src/Authentication.elm`
- Mitigation: Package is simple; reimplementation would be straightforward if needed (1-2 days work)

**Markdown 1.0.0 (elm-explorations/markdown):**
- Risk: Experimental package (elm-explorations); may have security issues with unsafe HTML rendering
- Files: `src/Activities.elm` (Markdown rendering for blog posts)
- Impact: User-supplied blog content rendered as HTML; potential XSS if not sanitized
- Fix: Audit markdown rendering for HTML escaping; consider sanitization library

## Missing Critical Features

**No Offline Support:**
- Problem: SPA requires constant backend connection; tournament in progress with network loss = form loss
- Blocks: Mobile users in spotty coverage; local tournament without stable backend
- Fix: Implement localStorage persistence; sync on reconnect; detect offline state and warn user

**No Undo/Rollback:**
- Problem: User accidentally overrides bracket picks; no way to undo
- Blocks: Complex bracket selections (WC2026 best-third) with accidental overwrites lose work
- Fix: Maintain edit history in state; add Undo/Redo Msg variants

**No Form Draft Auto-save:**
- Problem: No periodic save to backend; form data lost on browser crash
- Blocks: Users lose 10+ minutes of bracket/topscorer work on accidental close
- Fix: Auto-save bet every 30 seconds if `betState == Dirty`

**No Multi-language Support:**
- Problem: All UI text hardcoded in Dutch
- Blocks: International tournaments cannot serve English/other language users
- Impact: UX poor for non-Dutch speakers
- Fix: Extract strings to translation module; add language selector

## Test Coverage Gaps

**Bracket Completeness Logic:**
- What's not tested: `isCompleteQualifiers` function in `src/Bets/Types/Answer/Bracket.elm`; all rounds must have winners set (handled by wizard `setBulk`)
- Files: `src/Bets/Types/Answer/Bracket.elm`, `src/Form/Bracket.elm`
- Risk: Issue #93 fixed one completeness bug; untested code likely has similar issues with edge cases (e.g., empty finalist round)
- Priority: High — blocks form submission

**GroupMatches to Bracket Qualification Flow:**
- What's not tested: Round-trip: user selects group match results → bracket shows qualified teams → user confirms bracket
- Files: `src/Form/GroupMatches.elm` (selection) → `src/Form/Bracket.elm` (propagation)
- Risk: Bug in qualification propagation (e.g., wrong group rank passed to bracket) goes undetected
- Priority: High — core feature

**Best-Third Assignment Algorithm:**
- What's not tested: `assignBestThirds` function with all valid WC2026 group combinations (12 groups, 8 T-slots)
- Files: `src/Form/Bracket.elm` (lines 213-243)
- Risk: Issue #93 partially fixed it; remaining edge cases for specific group combos not exhaustively tested
- Priority: High — blocking bug

**TouchEnd Swipe Threshold:**
- What's not tested: Touch swipe detection (30px threshold in GroupMatches)
- Files: `src/Form/GroupMatches.elm` (lines 86-117)
- Risk: Threshold may be wrong for different device pixel densities; accidental swipes trigger navigation
- Priority: Medium — usability issue

**API Error Handling:**
- What's not tested: All HTTP error scenarios (network timeout, 404, 500, invalid JSON)
- Files: `src/API/`, `src/Results/`, `src/Activities.elm`
- Risk: Specific error scenarios may leave model in inconsistent state (e.g., `FetchedBet` with partial data)
- Priority: Medium — error recovery

**Participant Form Validation:**
- What's not tested: Email validation edge cases; address max length; phone number format
- Files: `src/Form/Participant.elm`
- Risk: Invalid data submitted; backend validation may reject with confusing error
- Priority: Low — backend has validation too

---

*Concerns audit: 2026-02-23*
