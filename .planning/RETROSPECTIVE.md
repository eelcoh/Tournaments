# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

---

## Milestone: v1.5 — Test/Demo Mode

**Shipped:** 2026-03-15
**Phases:** 4 (26–29) | **Plans:** 4

### What Was Built

- Test mode activation via `#test` URL and 5-tap title gesture — `testMode : Bool` on Model
- `[TEST MODE]` status bar badge + full 9-item nav bypass regardless of auth token or tournament state
- `TestData.Activities` — 5 dummy entries; offline comment/post submission prepends locally
- `TestData.MatchResults` + `TestData.Ranking` — dummy data for all 4 results pages with no backend
- `TestData.Bet` — one-tap Dashboard fill: all 36 group scores, WC2026 bracket (France champion), Mbappé topscorer

### What Worked

- **Orthogonal boolean flag** — `testMode : Bool` on Model avoided all routing/exhaustive case changes; every guard was a 3-line if/else
- **TestData.* namespace pattern** — deriving dummy data from `Bets.Init` (real tournament data) meant zero hand-writing of team IDs or counts
- **One guard per Refresh handler** — wrapping the outermost branch meant test data always took priority; no interaction with existing cache logic
- **Phase speed** — 4 plans executed in ~23 min total; Phase 28 completed in ~1 min (the pattern was fully established by then)

### What Was Inefficient

- **Audit flagged INT-01 too late** — `RefreshTopscorerResults` missing testMode guard was caught at audit, not during Phase 28 execution; a checklist of all Refresh* handlers in Phase 28 plan would have caught it
- **MILESTONES.md accomplishments not auto-extracted** — gsd-tools CLI returned empty accomplishments; required manual update post-archival

### Patterns Established

- `testMode : Bool` on Model — orthogonal boolean for feature modes; avoids new App variants and routing exhaustiveness
- `TestData.*` modules derive from `Bets.Init` — authoritative tournament data, never duplicated as strings
- testMode guard as outermost check in update branch — test injection before cache checks; clean and predictable
- `Fresh(RemoteData.Success ...)` wrapper for `DataStatus(WebData T)` injection — matches exact type shape for results data

### Key Lessons

- **Pre-list all peer handlers before writing a plan** — INT-01 would have been caught if Phase 28 plan had listed all 4 `Refresh*` handlers (Ranking, Results, KnockoutsResults, TopscorerResults) and verified each needed a guard
- **Static dummy data > dynamic generation** — WC2026 tournament data is stable; static values are predictable, debuggable, and fit in one module
- **Short milestones ship fast** — 4 phases, 1 plan each, all under 15 min; milestone was conceived and shipped in under 2 hours

### Cost Observations

- Sessions: 1 day, ~2 hours total
- 4 plans executed in ~23 min (2–15 min range; Phase 29 took longest due to bracket wiring complexity)
- Notable: Elm's type system made the `FillAllBet` atomic update reliable — compiler enforced exhaustive handling

---

## Milestone: v1.2 — Visual Polish

**Shipped:** 2026-03-07
**Phases:** 4 (10–13) | **Plans:** 6

### What Was Built

- Zenburn warm palette (#3f3f3f bg, #dcdccc text, #f0dfaf amber) applied app-wide via named constants
- Terminal nav aesthetic: plain monospace links, saturated active color (Color.activeNav), fillPortion centering
- Consistent 600px outer page column (nav + content + footer aligned)
- Activities loading copy, input label hiding, terminalInput dark background
- Distinct SVG placeholders for unknown vs TBD team slots

### What Worked

- **Named color constants** — changing 9 constants in UI/Color.elm propagated everywhere automatically; zero per-page edits needed
- **Minimal scope** — each plan targeted one concern; no plan needed revision
- **UAT catching visual gaps** — phase 11 UAT caught active nav indistinguishability (pale amber ≈ cream body text); the fix was a 1-file, 1-line change
- **Fixed constant over formula** — `maxWidth` returning `600` unconditionally was simpler and more predictable than 80%-of-viewport; no edge cases

### What Was Inefficient

- **Phase 13 requirements not pre-planned** — UX-POLISH-01 through 04 were added during execution rather than during milestone planning; caused a stale traceability table in REQUIREMENTS.md
- **v1.2-ROADMAP archive incomplete** — gsd-tools CLI snapshot didn't include Phase 13 (added after initial roadmap), required manual correction post-archival

### Patterns Established

- `Input.labelHidden` when a `>` prompt acts as visual label — avoids elm-ui's `labelAbove` contradicting terminal style
- Separate semantic color for UI states: `Color.activeNav` vs `Color.orange` keeps visual hierarchy explicit
- `inFront` overlay column intentionally exempt from width constraints — always full-width for banners, nav bar, status bar
- SVG placeholders: square `viewBox 0 0 100 100`, no fixed width/height — scale with containing `img` element

### Key Lessons

- **Audit milestone scope before execution** — Phase 13 emerged organically; including it in ROADMAP.md at milestone start would have kept REQUIREMENTS.md accurate
- **UAT is fast and catches real issues** — 3 phases × ~3 tests each; takes minutes and caught one real visual regression
- **Terminal aesthetic constraints are now stable** — color, spacing, input, nav patterns all established; future milestones can build on these without re-litigating aesthetics

### Cost Observations

- Sessions: 1 day, multiple short sessions
- All 6 plans executed in ~15 min total (1–5 min each)
- Notable: Elm's named export system made the color migration essentially free

---

## Milestone: v1.3 — Form Flow Redesign

**Shipped:** 2026-03-09
**Phases:** 4 | **Plans:** 4 | **Files changed:** 25 | **Code delta:** +2221/−205

### What Was Built

1. DashboardCard at form index 0 — styled section rows with [x]/[.]/[ ] indicators, progress counts, tap-to-jump navigation, all-done banner
2. 36-match group stage — pre-wired Tournament.elm filter activated; only display string needed updating
3. Bracket dot rail minimap — single `viewBracketMinimap` replaces 3 stepper variants; green/amber/dim dot states; all 6 rounds tappable
4. Topscorer live search — prefix filter on name + country; card state at top level; empty-state message

### What Worked

- **Design-first prototype** (`design-prototype.html`) made every phase decision straightforward — no ambiguity about what to build
- **Pre-wired data layer** for group reduction (selectedMatches already filtered to 36) made Phase 15 a 10-minute task — good planning from earlier phases paid off
- **Single function replaces 3** in bracket minimap — recognising that device branching was unnecessary simplified the implementation significantly
- **Top-level card state pattern** (UpdateSearch at top-level, consistent with ParticipantCard) keeps state mutation predictable

### What Was Inefficient

- MILESTONES.md got a duplicate stale "In Planning" entry that needed cleanup at archive time — the CLI should clear prior in-planning entries when archiving
- Browser verification items in the audit couldn't be auto-confirmed — 6 of 13 requirements show as `human_needed` pending runtime checks

### Patterns Established

- Dashboard-as-home: form entry point shows all sections; non-linear navigation is natural from here
- `Html.input via Element.html` as terminal input alternative when elm-ui `Input.text` styling is too constraining
- `findCardIndex` helper enables tap-to-jump from any overview to any card without card-specific knowledge in the dashboard

### Key Lessons

- If a data filter is already in place, the "reduction" phase only needs the display string updated — check the data layer before assuming a feature requires code
- Dot rail > ASCII stepper for round navigation: visually clear, device-independent, simpler code
- Card state mutations belong at the top-level update boundary, not inside component `update` functions — consistent with Elm's unidirectional data flow

---

## Milestone: v1.4 — Visual Design Adoption

**Shipped:** 2026-03-14
**Phases:** 8 (18–25) | **Plans:** 12 | **Files changed:** 62 | **Code delta:** +7,348/−673

### What Was Built

1. Martian Mono self-hosted variable font + CRT scanline overlay via CSS `body::before`
2. Segmented progress rail header + fixed bottom nav with amber `[!]` indicator and boundary disabled states
3. Score inputs (dark bg, orange text, full border) + scroll wheel tile rows with SVG flags
4. Bracket team tile cards (80×44, bordered, selected + hover states) + round header with N/M counter
5. Topscorer flat player cards + bordered search bar with focus state
6. Participant field rows with uppercase labels + focus border; submit summary box with green/red per-section
7. `resultCard` style helper applied to all 5 results pages with amber score coloring
8. Activities feed restyled with card treatment + prototype typography
9. Group standings view (`#groepsstand`) with positionColor semantic rows

### What Worked

- **`resultCard` as shared style helper** — adding to any container as `attrs` is idiomatic elm-ui; once defined in UI.Style, applying to 6+ modules was a search-and-add exercise, not a design problem
- **Gap closure phases (24, 25)** — when the audit found RESULTS-03 unsatisfied and Phase 22 VERIFICATION.md missing, creating dedicated closure phases with their own PLANs and VERIFICATIONs kept the audit model honest without bending it
- **Focus state via explicit Msg pattern** — `SearchFocused Bool` and `activeField` for participant: clean elm-ui workaround for missing focus/blur events; consistent across both Topscorer and Participant cards
- **Dict accumulation for standings** — `Dict.get teamID standings |> Maybe.withDefault emptyStanding |> updateWith match` pattern was simple and correct for incremental stats

### What Was Inefficient

- **Phase 22 VERIFICATION.md skipped at execution time** — caused a blocker in the audit that required a whole Phase 24 just for documentation. Verification must happen during execute-phase, not after.
- **SUMMARY.md `provides:` vs `requirements_completed:`** — 4 plans (18-02, 19-01, 23-01, 25-01) used the wrong frontmatter key, causing silent extraction failures. Should be caught at plan review time.
- **Nyquist validation skipped for all 8 phases** — no VALIDATION.md files generated. The Elm app has no test suite, so validation is manual; but the files should still be created to record what was checked.
- **6-element tuple in initial standings design** — Elm's max tuple size is 3; had to inline win/draw/loss logic into update functions. Caught during execution, not planning.

### Patterns Established

- `resultCard` as a reusable `List (Attribute msg)` in UI.Style — apply to any container; `attrs ++ resultCard` pattern for overrides
- `positionColor pos` returning `Font.color` attribute applied to the row element — uniform row coloring without per-cell markup
- Focus state via `Bool` Msg pair (FocusedTrue/False from Html onFocus/onBlur) — works around elm-ui Input.text focus event limitation
- Gap closure phases: when audit finds missed requirements, create a numbered phase (not a re-execution) — maintains clean phase history

### Key Lessons

- **Always create VERIFICATION.md during execute-phase** — skipping it causes downstream audit failures. The tooling enforces this for future phases.
- **SUMMARY.md frontmatter: use `requirements_completed:` not `provides:`** — `provides:` is for dependency graph exports; `requirements_completed:` is for automated traceability extraction
- **Tuple size limit (3) in Elm** — inline logic into update functions rather than passing state as tuples; `let` bindings are the idiomatic alternative
- **Gap closure phases keep audit model honest** — don't mark requirements as complete in REQUIREMENTS.md until a phase plan verifies them

---

## Cross-Milestone Trends

| Milestone | Phases | Plans | Timeline | LOC    | Key Theme |
|-----------|--------|-------|----------|--------|-----------|
| v1.0      | 5      | 16    | 4 days   | 19,400 | PWA + mobile UX foundation |
| v1.1      | 4      | 7     | 2 days   | 19,800 | UX refinement + install prompts |
| v1.2      | 4      | 6     | 1 day    | 19,880 | Visual polish + terminal aesthetic |
| v1.3      | 4      | 4     | 1 day    | 20,196 | Form flow redesign — dashboard, minimap, search |
| v1.4      | 8      | 12    | 4 days   | 20,847 | Visual design adoption — font, cards, styled inputs, results aesthetic |

**Observation:** v1.4 was the largest milestone since v1.0 by phase count (8 phases) and code delta (+7,348 LOC), but two of those phases were gap closure phases triggered by the audit. The audit process is working correctly — it caught real gaps and the closure phases addressed them. The two-phase gap closure pattern (verify-phase + implement-phase) should be a standard tool for future milestones.
