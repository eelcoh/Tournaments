# Phase 5: Bug Fixes and UX Polish - Research

**Researched:** 2026-02-28
**Domain:** Elm/elm-ui bug fixes, UX regressions, terminal aesthetic consistency
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Topscorer terminal aesthetic (issue #4)
- Keep flag badges alongside text — not text-only
- Selected team/player gets `>` prefix; others are plain (same as nav active state pattern)
- Section headers use `--- TITLE ---` format (displayHeader) to match rest of terminal UI
- When topscorer already selected: show current pick prominently at top as `> NAME (TEAM)`, then full selectable list below

#### Completion feedback (issue #3)
- "Ga verder" button activates/highlights when R32 is complete — this is the primary signal
- Completed rounds in the ASCII stepper get a `✓` mark
- No inline status message needed — button + checkmark is sufficient
- **Key fix:** "Ga verder" button must be sticky at the bottom of the screen when R32 is complete, because the button is currently buried below the grid and not visible without scrolling

#### Group boundary behavior (issue #5)
- Boundary labels (`-- B --`) are visual-only — cursor/focus skips them entirely, they are never focusable
- Keyboard arrow navigation also skips boundary labels (same rule as scroll)
- Labels still appear in the 5-match scroll window for visual group orientation
- When scrolling past last match in a group, cursor lands on first match of the next group

#### Home page comment input (issue #2)
- Apply `UI.Style.terminalInput` styling: underline-only border, orange text/border on focus, dark background
- Always-visible static `>` prefix (not focus-dependent) — reads as a terminal command line prompt
- The input is the comment submission field on the chat/activity home page
- Display list of comments already has terminal styling from Phase 3 — only the input field needs updating

### Claude's Discretion
- Exact sticky button implementation approach (elm-ui `inFront` + `alignBottom` or similar)
- Whether flags regression (issue #1) is a one-line fix or requires deeper investigation
- Exact checkmark placement in the ASCII stepper

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope.
</user_constraints>

## Summary

Phase 5 addresses five targeted regressions and UX inconsistencies. All five issues are isolated to specific Elm modules with clear, localized fixes. No new modules, no architectural changes, no new dependencies — this is purely surgical editing within the existing codebase.

The most complex issue is #3 (sticky completion button), which requires elm-ui's `inFront` + `alignBottom` overlay pattern — the same pattern already used in `View.elm`'s `viewStatusBar`. The flags regression (#1) is a rendering gap in `viewTeamBadge` in `Form/Bracket/View.elm`: that function uses `T.display` (text only) while `viewSelectableTeam` already has the correct `Element.image` flag — the computer layout's `viewTeamBadge` simply never got the flag added. Issue #2 (home page input) is a straightforward style substitution in `Activities.elm`. Issue #4 (topscorer) requires a mild view rewrite in `Form/Topscorer.elm` to apply terminal list patterns. Issue #5 (group boundary jump) is a cursor-navigation fix in `Form/GroupMatches/Types.elm`.

**Primary recommendation:** Fix each issue independently in its own task; none depend on the others. Tackle the sticky button (#3) last since it requires understanding of the page layout context.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mdgriffith/elm-ui | 1.1.8 | All layout and styling | Project-wide; no CSS |
| elm/core | 1.0.5 | Language fundamentals | Elm built-in |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| elm-community/list-extra | 8.2.4 | List utilities | cursor navigation, findIndex |

### Alternatives Considered
None — all fixes use patterns already present in the codebase.

**Installation:** No new packages required.

## Architecture Patterns

### Recommended Project Structure
No structural changes needed. All fixes are within existing files:

```
src/
├── Form/Bracket/View.elm        # Issue #1: flags regression, #3: sticky button + checkmark
├── Form/GroupMatches/Types.elm  # Issue #5: cursor skip over boundaries
├── Form/GroupMatches.elm        # Issue #5: boundary-aware scroll items
├── Form/Topscorer.elm           # Issue #4: terminal aesthetic rewrite
├── Activities.elm               # Issue #2: home page input styling
└── UI/Style.elm                 # (read-only reference — no changes needed)
```

### Pattern 1: elm-ui inFront Overlay (Issue #3 — Sticky Button)

**What:** `Element.inFront` places an element in front of the layout, overlapping content. Combined with `Element.alignBottom`, it produces a sticky bottom bar — the same technique used for `viewStatusBar` in `View.elm`.

**When to use:** When a UI element must be visible regardless of scroll position.

**Current viewStatusBar pattern (View.elm lines 179–189):**
```elm
body =
    Element.layout
        (UI.Style.body
            [ Element.inFront
                (Element.el
                    [ Element.alignBottom, Element.width Element.fill ]
                    (viewStatusBar model)
                )
            ]
        )
        page
```

**For the bracket completion button**, the `inFront` must be applied to the `page` function's wrapper column, not at the layout root (which is in View.elm). The correct approach is to make `Form.Bracket.View.view` return the page with `inFront` on its column when the wizard is complete:

```elm
-- In Form.Bracket.View.view, when isWizardComplete sel:
page "bracket"
    ([ stepper ] ++ sections ++ [ extroduction ])
-- with Element.inFront added to the column's attribute list for the sticky button
```

The `page` function in `UI/Page.elm` currently returns:
```elm
Element.column
    (UI.Style.page [ centerX, spacing 20, paddingXY 20 0, UI.Screen.className name, width fill ])
    elements
```

The sticky button should be added as `Element.inFront` on this column. This requires either:
- (a) Adding an optional `attrs` parameter to `page` — but that changes the `page` signature used everywhere
- (b) Wrapping the `page "bracket" ...` call in an outer `Element.el` with `inFront`
- (c) Passing the sticky button via the existing `completionButton` element (current approach) but changing `viewCompletionButton` to only render as sticky when complete

**Recommended approach (Claude's discretion):** Wrap the top-level `page "bracket" ...` in `Element.el [ Element.inFront stickyButton ]`. The `UI.Page.page` signature stays unchanged. The sticky button is rendered as `inFront` + `alignBottom` on that wrapper `el`.

```elm
-- Form.Bracket.View.view
let
    stickyButton =
        if isWizardComplete sel then
            Element.el
                [ Element.alignBottom
                , Element.width Element.fill
                , Element.padding 16
                , Background.color Color.black
                ]
                (UI.Button.pill UI.Style.Focus GoNext "Ga verder →")
        else
            Element.none
in
Element.el [ Element.inFront stickyButton, Element.width Element.fill ]
    (page "bracket" ([ stepper ] ++ sections ++ [ extroduction ]))
```

**Confidence:** HIGH — this is the same elm-ui pattern used in the existing codebase.

### Pattern 2: Checkmark in ASCII Stepper (Issue #3)

**What:** Replace the dot character for completed rounds with `✓` in both `viewRoundStepperFull` and `viewRoundStepperCompact`.

**Current code (Form/Bracket/View.elm lines 112–118):**
```elm
dotChar r =
    if isComplete r then
        "x"
    else
        "."
```

**Decision:** Change `"x"` to `"✓"` (U+2713). For `viewRoundStepperCompact`, the `prefix` function already shows `"[x] "` for complete rounds — replace with `"[✓] "`.

### Pattern 3: Flags Regression in Computer Layout (Issue #1)

**What:** `viewTeamBadge` in `Form/Bracket/View.elm` (lines 525–557) renders only `T.display` text — no flag image. This is the computer layout's selectable team cell. `viewSelectableTeam` (lines 391–452) already renders `flagImg` correctly for the phone layout.

**Root cause (confirmed in source):**
- `viewSelectableTeam` (phone/R32 grid): correctly renders `Element.image` flag + text code
- `viewTeamBadge` (computer layout `viewGroup`): only renders `T.display` text, no flag image

**Fix:** Add `flagImg` to `viewTeamBadge`, matching the pattern from `viewSelectableTeam`:
```elm
viewTeamBadge round selections teamData_ team =
    let
        flagImg =
            Element.image
                [ Element.height (Element.px 16)
                , Element.width (Element.px 16)
                ]
                { src = T.flagUrl (Just team)
                , description = T.display team
                }
        -- ... rest of the function
    in
    -- wrap Element.column with flagImg + text el
```

**Confidence:** HIGH — the fix mirrors the existing `viewSelectableTeam` pattern exactly.

### Pattern 4: Terminal Input Styling (Issue #2)

**What:** `Activities.viewCommentInput` uses bare `Input.multiline` and `Input.text` with `Border.rounded 0` only. Replace with `UI.Style.terminalInput False [...]` and add a static `>` prefix element.

**Current code (Activities.elm lines 155–225):**
```elm
commentInputTrap =
    Input.text
        [ Events.onFocus ShowCommentInput
        , height (px 48)
        , Border.rounded 0
        ]
        area

authorInput v =
    Input.text
        [ height (px 48)
        , Border.rounded 0
        ]
        area
```

**`UI.Style.terminalInput` signature (UI/Style.elm lines 627–646):**
```elm
terminalInput : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)
terminalInput hasError attrs =
    attrs ++
        [ Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
        , Border.color borderColor
        , Border.rounded 0
        , Background.color Color.black
        , Font.color Color.white
        , UI.Font.input
        , Element.paddingXY 4 8
        , Element.focused [ Border.color Color.orange ]
        ]
```

**Fix pattern:**
```elm
-- Replace bare attrs with terminalInput False [...]
Input.text
    (UI.Style.terminalInput False
        [ height (px 48)
        , Events.onFocus ShowCommentInput
        ]
    )
    area
```

**For the `>` prefix:** Per the decision, always-visible static `>` prefix. Wrap the input in an `Element.row`:
```elm
Element.row [ Element.spacing 8 ]
    [ Element.el [ Font.color Color.orange, UI.Font.mono, Element.centerY ] (Element.text ">")
    , Input.text (UI.Style.terminalInput False [...]) area
    ]
```

Note: The same terminal styling should be applied to `authorInput`, `commentInput` (multiline), and `commentInputTrap`. The `showComment` expansion path (full comment form) and trap (collapsed) both need it.

### Pattern 5: Topscorer Terminal Aesthetic (Issue #4)

**What:** `Form/Topscorer.elm` uses `UI.Button.teamButton` (which calls `UI.Style.teamBadge` — a bordered panel button) and `UI.Button.pill` for player selection. The terminal aesthetic requires flat text rows with `>` prefix for selected items.

**Current rendering:**
- Teams: bordered badge buttons via `UI.Button.teamButton`
- Players: bordered pill buttons via `UI.Button.pill`
- No section headers

**Target rendering (per decisions):**
- Section header: `UI.Text.displayHeader "Wie wordt de topscorer?"` (already there) and `UI.Text.displayHeader "Kies een speler"` for player section
- Teams: flat text rows — selected team gets `> NEL` prefix, others plain `  NEL`. Flag badge retained.
- Players: same pattern — selected gets `>`, others plain
- When team already selected: `> NEL (Nederland)` shown prominently at top before full list

**Key rewrite in `Form/Topscorer.elm`:**
```elm
-- Replace mkTeamButton
viewTeamRow : (Team -> Msg) -> ( TeamDatum, IsSelected ) -> Element.Element Msg
viewTeamRow act ( teamDatum, sel ) =
    let
        team = .team teamDatum
        prefix = case sel of
            Selected -> "> "
            NotSelected -> "  "
        textColor = case sel of
            Selected -> Color.orange
            NotSelected -> Color.primaryText
        flagImg =
            Element.image
                [ Element.height (Element.px 16), Element.width (Element.px 16) ]
                { src = T.flagUrl (Just team), description = T.display team }
    in
    Element.el
        [ Element.Events.onClick (act team)
        , Element.pointer
        , Element.width Element.fill
        , Element.height (Element.px 44)
        ]
        (Element.row [ Element.spacing 4, Element.centerY ]
            [ Element.el [ Font.color Color.orange, UI.Font.mono ] (Element.text prefix)
            , flagImg
            , Element.el [ Font.color textColor, UI.Font.mono ] (Element.text (T.display team))
            ])
```

**`forGroup` becomes a column, not a row:**
```elm
forGroup teams =
    Element.column [ Element.spacing 4, Element.width Element.fill ]
        (List.map (viewTeamRow SelectTeam) teams)
```

### Pattern 6: Group Boundary Cursor Skip (Issue #5)

**What:** `updateCursor` in `Form/GroupMatches/Types.elm` calls `nextMatch` which uses the flat `allMatchIDs` list. When cursor is at the last match of a group, `nextMatch` correctly moves to the first match of the next group — no boundary label is in `allMatchIDs` since that list only contains `MatchID` strings.

**Investigation result:** `allMatchIDs` is built from `List.map Tuple.first bet.answers.matches` — pure `MatchID` list with no boundary items. Boundary labels (`GroupBoundary`) are in the `ScrollItem` type used only for display in `viewScrollWheel`. The `updateCursor` function already works correctly at the data level.

**The actual issue** is likely that when the cursor advances from the last match of group A to the first match of group B, a `GroupBoundary B` item appears in the scroll window and causes a visual height jump: the scroll window suddenly shows a boundary label row that was not there before. The `GroupBoundary` rows have no fixed height — they are just `Element.el [ centerX, Font.color Color.grey, UI.Font.mono ]` — while `viewScrollLine` rows have `height (px 44)`. Mixed heights in the scroll window cause vertical displacement.

**Fix:** Give `GroupBoundary` rows the same `height (px 44)` as match rows in `viewScrollItem`:
```elm
viewScrollItem cursor item =
    case item of
        MatchRow matchData ->
            viewScrollLine cursor matchData

        GroupBoundary grp ->
            Element.el
                [ centerX
                , Font.color Color.grey
                , UI.Font.mono
                , Element.height (Element.px 44)   -- <-- add this
                , Element.centerY
                ]
                (Element.text ("-- " ++ G.toString grp ++ " --"))
```

**Keyboard navigation:** The `ScrollDown` and `ScrollUp` messages use `updateCursor` which operates on `allMatchIDs`. Since `allMatchIDs` never includes boundary labels, keyboard navigation already skips them — no fix needed there.

**Touch swipe:** Same — swipe triggers `ScrollDown`/`ScrollUp` on `allMatchIDs`, never touches boundaries.

**Confidence:** MEDIUM — the height-jump root cause is inferred from reading the code. Visual confirmation post-fix is needed.

### Anti-Patterns to Avoid

- **Changing `UI.Page.page` signature:** Adding an `attrs` parameter would require updating every call site (`Form/GroupMatches.elm`, `Form/Topscorer.elm`, `Form/Bracket/View.elm`, `Activities.elm`). Use the wrapper `el` approach instead.
- **Replacing `viewScrollWheel` entirely:** The scroll wheel logic is well-tested. Only add `height (px 44)` to the boundary row.
- **Using `Debug.log` or `Debug.todo`:** Build uses `--optimize` which rejects these.
- **Changing `Msg` types:** All 5 fixes are view-only or cursor-logic changes; no new `Msg` variants needed.
- **Pattern match omissions:** When pattern-matching on `Card` types (e.g., in `View.elm` `viewStatusBar`), the existing patterns are exhaustive. No card variants are changing in this phase.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Sticky button | Custom JS/CSS overlay | `Element.inFront` + `Element.alignBottom` | Already used for status bar |
| Terminal input style | Inline style list | `UI.Style.terminalInput False [...]` | Already defined; handles error state |
| Section header | Custom header element | `UI.Text.displayHeader "..."` | Already handles `--- TITLE ---` format |
| Flag images | New flag component | `Element.image [...] { src = T.flagUrl (Just team), ... }` | Already in `viewSelectableTeam` |

## Common Pitfalls

### Pitfall 1: `inFront` on wrong element
**What goes wrong:** Placing `inFront` on the `Element.layout` root (in View.elm) for the bracket-specific button — it would appear on all pages.
**Why it happens:** Status bar uses `inFront` at the layout level because it IS page-wide. The completion button is bracket-specific.
**How to avoid:** Wrap only the bracket `page "bracket" ...` call in an outer `el` with `inFront`.
**Warning signs:** Button appears on group matches or topscorer pages.

### Pitfall 2: `terminalInput` takes `Bool` first arg
**What goes wrong:** Calling `UI.Style.terminalInput [...]` without the `hasError` Bool.
**Why it happens:** The signature is `terminalInput : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)`.
**How to avoid:** Always pass `False` as first arg for non-error state: `UI.Style.terminalInput False [height (px 48)]`.

### Pitfall 3: `viewTeamBadge` computer layout called from `viewGroup`
**What goes wrong:** Fixing `viewSelectableTeam` (phone path) thinking that fixes the computer layout too.
**Why it happens:** `viewActiveGrid` dispatches to `viewR32Grid` (phone) vs `viewGroup`/`viewTeamBadge` (computer). They are separate functions.
**How to avoid:** Fix `viewTeamBadge` (lines 525–557) in `Form/Bracket/View.elm`. `viewSelectableTeam` already works.

### Pitfall 4: `forGroup` in Topscorer uses `Element.row`
**What goes wrong:** Leaving `Element.row` for the group display — flag + code renders horizontally which is the current non-terminal layout.
**Why it happens:** The current `forGroup` is `Element.row (UI.Style.none [spacing 20, padding 10])`.
**How to avoid:** Change to `Element.column [spacing 4, width fill]` to stack team rows vertically.

### Pitfall 5: `viewPlayers` uses `Element.wrappedRow`
**What goes wrong:** Player list stays as a pill-button wrapped row instead of a vertical terminal list.
**Why it happens:** `viewPlayers` returns `Element.wrappedRow [...] (List.map (mkPlayerButton ...) ...)`.
**How to avoid:** Replace `mkPlayerButton` with `viewPlayerRow` following the same `>` prefix pattern.

### Pitfall 6: Boundary height mismatch causes double-jump appearance
**What goes wrong:** Adding height to the boundary row causes the 5-item window to show 4 matches + 1 boundary rather than 5 matches, creating a layout shift.
**Why it happens:** The window always shows 5 `ScrollItem`s but not 5 matches — boundary items reduce visible match count.
**How to avoid:** This is expected behavior. The boundary item always occupies a slot when visible. The fix (same height) prevents vertical jump; showing 4 matches + boundary is correct.

## Code Examples

Verified patterns from existing codebase:

### inFront sticky overlay
```elm
-- Source: src/View.elm lines 179-189
Element.layout
    (UI.Style.body
        [ Element.inFront
            (Element.el
                [ Element.alignBottom, Element.width Element.fill ]
                (viewStatusBar model)
            )
        ]
    )
    page
```

### terminalInput usage (existing in Form/GroupMatches.elm)
```elm
-- Source: src/Form/GroupMatches.elm lines 463-468
Input.text
    (UI.Style.scoreInput
        [ width (px 60)
        , Border.rounded 0
        , Element.htmlAttribute (Html.Attributes.attribute "inputmode" "numeric")
        ]
    )
    inp
-- terminalInput is used in Form/Participant — same calling pattern
```

### Flag image in viewSelectableTeam (existing, working)
```elm
-- Source: src/Form/Bracket/View.elm lines 403-410
flagImg =
    Element.image
        [ Element.height (Element.px 16)
        , Element.width (Element.px 16)
        ]
        { src = T.flagUrl (Just team)
        , description = T.display team
        }
```

### displayHeader (existing)
```elm
-- Source: src/UI/Text.elm lines 32-35
displayHeader : String -> Element.Element msg
displayHeader txt =
    Element.el (Style.header2 [ width Element.fill ])
        (Element.text ("--- " ++ String.toUpper txt ++ " ---"))
```

### Cursor nav skips boundaries (existing — no change needed)
```elm
-- Source: src/Form/GroupMatches/Types.elm lines 45-55
nextMatch : MatchID -> List MatchID -> MatchID
nextMatch matchID matches =
    let
        isNotCurrentMatch mId = mId /= matchID
        findNext =
            dropWhile isNotCurrentMatch matches
                |> List.tail
    in
    Maybe.withDefault matchID (findNext |> Maybe.andThen List.head)
```

## State of the Art

| Old Approach | Current Approach | Notes |
|--------------|------------------|-------|
| Bordered badge buttons for team selection | Terminal `>` prefix text rows | Issue #4 target state |
| Bare `Input.text` in Activities | `UI.Style.terminalInput` | Issue #2 target state |
| `"x"` dot for completed stepper rounds | `"✓"` character | Issue #3 refinement |
| No sticky button | `inFront` + `alignBottom` | Issue #3 sticky pattern |

## Open Questions

1. **Issue #5 — exact root cause of vertical jump**
   - What we know: `GroupBoundary` rows have no explicit height; `viewScrollLine` rows have `height (px 44)`
   - What's unclear: Is the jump caused by height mismatch, or by the scroll window recalculating its position offset?
   - Recommendation: Apply the height fix and verify visually. If jump persists, investigate whether `spacing 2` on the column accumulates differently with boundary rows.

2. **Issue #3 — sticky button bottom inset on mobile**
   - What we know: The status bar is at the very bottom via `alignBottom` on layout; the completion button is above the status bar visually
   - What's unclear: Whether `inFront` on the bracket `el` wrapper places the button above the status bar or potentially behind it
   - Recommendation: Add `Element.paddingEach { bottom = 40, ... }` to the sticky button container to clear the 34px status bar. Verify on phone viewport.

3. **Issue #4 — selected topscorer display location**
   - What we know: Decision says "show current pick prominently at top as `> NAME (TEAM)`"
   - What's unclear: Whether this is a separate section above the group list, or if the group list scrolls to show the selected item at top
   - Recommendation: Add a `viewSelectedTopscorer` section between the header and the group list. Show only when topscorer is partially or fully selected. This is additive to the existing list.

## Sources

### Primary (HIGH confidence)
- Direct source code inspection of `src/Form/Bracket/View.elm` — viewTeamBadge (lines 525–557), viewSelectableTeam (lines 391–452), viewCompletionButton (lines 455–465), viewRoundStepperFull/Compact
- Direct source code inspection of `src/View.elm` — inFront/alignBottom pattern (lines 179–189)
- Direct source code inspection of `src/UI/Style.elm` — terminalInput signature and implementation (lines 627–646)
- Direct source code inspection of `src/Activities.elm` — viewCommentInput (lines 155–225)
- Direct source code inspection of `src/Form/GroupMatches.elm` — viewScrollItem (lines 254–263), viewScrollLine height (lines 338–339)
- Direct source code inspection of `src/Form/GroupMatches/Types.elm` — nextMatch, updateCursor (lines 45–72)
- Direct source code inspection of `src/Form/Topscorer.elm` — full view and mkTeamButton functions
- Direct source code inspection of `src/UI/Page.elm` — page function signature

### Secondary (MEDIUM confidence)
- CLAUDE.md project documentation — elm-ui patterns, architecture
- MEMORY.md project memory — bracket wizard implementation details, issue #86 terminal redesign context

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all libraries already in use; no new dependencies
- Architecture: HIGH — all patterns verified directly from existing source code
- Pitfalls: HIGH — pitfalls derived from direct code reading, not assumption

**Research date:** 2026-02-28
**Valid until:** 2026-03-30 (stable Elm codebase; no external dependencies changing)
