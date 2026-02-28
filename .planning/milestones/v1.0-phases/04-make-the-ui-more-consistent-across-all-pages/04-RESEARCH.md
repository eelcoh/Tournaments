# Phase 4: Make the UI More Consistent Across All Pages - Research

**Researched:** 2026-02-27
**Domain:** Elm 0.19.1 / elm-ui styling audit and normalization
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Responsive width constraints**
- All pages — both Results pages AND Form pages — must use `Screen.maxWidth model.screen` for their top-level content width
- Single source of truth: every page calls `Screen.maxWidth`, not ad-hoc `px` values
- Form pages (GroupMatches, Bracket, Participant, Topscorer, Submit) should be audited and aligned to this standard even though they received Phase 2/3 mobile work
- Pages currently missing constraints: Results/Matches, Results/Knockouts, Results/Topscorers — these are the primary targets

**Spacing and padding rhythm**
- Claude defines a consistent rhythm (values chosen to complement the existing terminal aesthetic)
- Inner content relies on the outer page padding (8px Phone / 24px Computer from View.elm) — no extra horizontal padding added inside page content
- Vertical spacing between sections should follow the rhythm Claude establishes, replacing the current mix of 0/5/10/20/24px values

**Terminal aesthetic coverage**
- **Home page:** Both the activity feed items AND the comment/post input boxes need terminal treatment
  - Activity feed: log-line style `[HH:MM] author:` (already defined in UI.Text.timeText)
  - Input boxes: use `terminalInput` style (underline-only, dark bg, orange focused border) matching Participant form
- **Results pages (Matches, Knockouts, Topscorers, Ranking):** Both terminal border separators AND button styles need fixing
  - Apply `terminalBorder` separators between sections
  - Replace any non-terminal button styles with correct `UI.Style.ButtonSemantics` variants

**Component usage uniformity**
- **Team names:** Always use `T.display` (3-char short codes) everywhere — both Form and Results pages. No full team names.
- **Clickable elements:** All interactive elements use `UI.Button` — no raw `Element.el` with `onClick`. If a pattern doesn't map to an existing UI.Button variant, add a new one rather than bypassing the component.
- **Page wrapper:** Extract a shared `UI.Page.container` helper that applies consistent max-width (`Screen.maxWidth`), vertical spacing rhythm, and Screen constraints. Every page (Home, Form cards, Results pages) uses this helper as its outer wrapper.

### Claude's Discretion
- Exact spacing rhythm values (multiples of 4 or 8 that look right with Sometype Mono)
- Which existing UI.Button variant maps to which clickable data element (e.g. ranking rows)
- Whether `UI.Page.container` takes screen as a parameter or a width argument

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope.
</user_constraints>

---

## Summary

Phase 4 is a pure normalization pass: no new features, no new pages. The codebase has accumulated styling drift across five areas — Results pages (Matches, Knockouts, Topscorers, Ranking, Bets), Home/Activities inputs, Authentication inputs, and Form cards — after three phases of incremental mobile work focused on touch targets and bracket layout. The primary technical work is (1) extending `UI.Page.elm` with a `container` function that accepts a `Screen.Size` and applies `Screen.maxWidth`, (2) wiring every page `view` function through that container, (3) replacing bare `Input.text`/`Input.multiline` calls with `UI.Style.terminalInput`-styled inputs, and (4) adding a `UI.Button.dataRow` or equivalent variant to replace raw `Element.el [onClick]` patterns for clickable data rows.

The codebase audit shows clean separation of concerns: `UI.Style.elm` holds all atomic styles, `UI.Button.elm` holds all interactive components, `UI.Screen.elm` provides `maxWidth` and `device`. The pattern is already correct in Form/View.elm (`Screen.maxWidth model.screen`) and Results/Ranking.elm (`px <| Screen.maxWidth model.screen`). The three Results pages missing width constraints (Matches, Knockouts, Topscorers) do not pass `model.screen` to their top-level layout columns at all — the fix is purely additive. The `UI.Page.elm` file already exists but has a `page` function that uses `width fill` with no max-width; it needs a new `container` function or a replacement.

The vertical spacing rhythm in the project currently mixes: `spacing 14`, `spacing 20`, `spacing 24`, `spacing 30`, `spacingXY 0 14`, `spacingXY 0 20`, `spacingXY 0 40`. The recommendation is a 3-tier rhythm (section/card: 24px, item rows: 12px, tight elements: 8px) which fits the Sometype Mono terminal aesthetic without feeling too loose or compressed.

**Primary recommendation:** Upgrade `UI.Page.elm` with a `container` function accepting `Screen.Size`, apply it to all page views, replace bare `Input.*` calls with `terminalInput`-styled wrappers, and add a `clickableRow` variant to `UI.Button` for ranking/bet list rows.

---

## Standard Stack

### Core (already in project — no new packages needed)

| Module | Version | Purpose | Status |
|--------|---------|---------|--------|
| `mdgriffith/elm-ui` | 1.1.8 | All layout and styling | Already in use |
| `UI.Screen` | local | `maxWidth`, `device`, `width` | Already in use |
| `UI.Style` | local | All style attributes | Already in use |
| `UI.Button` | local | All interactive components | Already in use |
| `UI.Page` | local | Page wrapper (needs extending) | Exists, incomplete |
| `UI.Text` | local | Text components incl. `timeText` | Already in use |
| `UI.Color` | local | Color tokens | Already in use |

**No new packages needed.** This phase is entirely internal refactoring of existing modules.

### Key API Reference (elm-ui)

```elm
-- Width with max constraint (the correct pattern):
Element.width (Element.fill |> Element.maximum (Screen.maxWidth model.screen))

-- The Screen.maxWidth function:
-- maxWidth : Size -> Int
-- maxWidth screen = round <| (80 * screen.width) / 100

-- Screen.width returns this as an Attribute:
-- width : Size -> Element.Attribute msg
-- width screen = Element.width (Element.fill |> Element.maximum (maxWidth screen))
```

---

## Architecture Patterns

### Current State Audit

**What is CORRECT (reference implementations):**

| Location | Pattern | Status |
|----------|---------|--------|
| `Form/View.elm` `viewCardChrome` | `Element.fill \|> Element.maximum (Screen.maxWidth model.screen)` | Correct |
| `Results/Ranking.elm` `viewRankingGroups` | `px <| Screen.maxWidth model.screen` | Mostly correct (uses px, not fill+max) |
| `Activities.elm` `view` | `px <| Screen.maxWidth model.screen` | Mostly correct |
| `View.elm` `viewHome`/`viewBlog` | `Screen.width model.screen` | Correct |
| `Form/Participant.elm` inputs | `UI.Style.terminalInput hasError [width fill, ...]` | Correct — reference |
| `Activities.elm` `commentBox`/`blogBox` | `Border.widthEach { bottom=1, ... }`, `Color.terminalBorder` | Correct separators |

**What is BROKEN (primary targets):**

| Location | Problem | Fix |
|----------|---------|-----|
| `Results/Matches.elm` `view` | `paddingXY 0 20` only, no width constraint, no `model.screen` arg | Add `Screen.Size` param, apply `container` |
| `Results/Matches.elm` `displayMatches` | `padding 10, spacingXY 20 40, centerX` — ad-hoc spacing, no width | Normalize to rhythm |
| `Results/Matches.elm` `displayMatch` | `width (px 150), height (px 70)` card — not terminal-styled | Apply terminal border semantics |
| `Results/Knockouts.elm` `view` | No width constraint, `spacingXY 0 14` outer | Add `Screen.Size` param, apply `container` |
| `Results/Knockouts.elm` `viewKnockoutsPerTeam` | `padding 20, spacing 20` — ad-hoc | Normalize to rhythm |
| `Results/Topscorers.elm` `view` | No width constraint, `spacingXY 0 14` outer | Add `Screen.Size` param, apply `container` |
| `Results/Topscorers.elm` `viewTopscorer` | `spacing 20, padding 10, onClick msg` directly | Replace `onClick` with `UI.Button` variant |
| `Results/Ranking.elm` `view` | `Element.column []` — empty attrs, no width at top level | Apply `container` at top level |
| `Results/Ranking.elm` `viewRankingLine` | `Element.el [ click, pointer ]` — raw `onClick` | Replace with `UI.Button` clickable variant |
| `Results/Bets.elm` `view` | `paddingXY 0 20` only, no width constraint | Add `Screen.Size` param, apply `container` |
| `Activities.elm` `viewCommentInput` | `Input.multiline [ height (px 120), Border.rounded 0 ]` — no `terminalInput` | Apply `UI.Style.terminalInput False` |
| `Activities.elm` `viewCommentInput` (trap) | `Input.text [ Events.onFocus ..., height (px 48), Border.rounded 0 ]` | Apply `UI.Style.terminalInput False` |
| `Activities.elm` `viewCommentInput` (author) | `Input.text [ height (px 48), Border.rounded 0 ]` | Apply `UI.Style.terminalInput False` |
| `Activities.elm` `viewPostInput` inputs | All 4 `Input.text`/`multiline` calls — bare Border.rounded 0 only | Apply `UI.Style.terminalInput False` |
| `Authentication.elm` `view` | `Input.multiline [ height (px 36) ]` and `Input.text [ height (px 36) ]` — no terminal style | Apply `UI.Style.terminalInput False` |

### Pattern 1: UI.Page.container (New Function)

**What:** A page wrapper that enforces max-width via `Screen.maxWidth`, applies the vertical spacing rhythm, and centers content.
**When to use:** Every top-level page `view` function.

The existing `UI.Page.page` function uses `width fill` with no max — it is used by Form/GroupMatches, Form/Participant, Form/Bracket already via `UI.Page.page`. The new `container` function should accept a `Screen.Size`:

```elm
-- Source: UI.Page (to be added)
container : UI.Screen.Size -> String -> List (Element.Element msg) -> Element.Element msg
container screen name elements =
    Element.column
        (UI.Style.page
            [ Element.centerX
            , Element.spacing 24
            , UI.Screen.className name
            , Element.width
                (Element.fill |> Element.maximum (UI.Screen.maxWidth screen))
            ]
        )
        elements
```

Note: `UI.Style.page` currently returns `attrs ++ []` — it is a no-op passthrough. The function exists as a hook; the real attributes come from the caller.

### Pattern 2: Vertical Spacing Rhythm

**Recommended values (multiples of 4, terminal aesthetic):**

| Tier | Value | Use Case |
|------|-------|---------|
| Section gap | `spacing 24` | Between major sections on a page |
| Item gap | `spacing 12` | Between list items (ranking rows, topscorer items) |
| Tight | `spacing 8` | Within a single item (label + value) |
| Paragraph | `paddingXY 0 16` | Vertical breathing room around text blocks |

**Replaces:** the current mix of `spacingXY 0 14`, `spacingXY 0 20`, `spacing 20`, `spacing 30`, `padding 20`.

### Pattern 3: Terminal Input Style

**Reference:** `Form/Participant.elm` (lines 156-157 in source) — uses `UI.Style.terminalInput hasError [width fill, height (px 48), ...]`.

**The pattern:**
```elm
-- Source: UI.Style.terminalInput (already exists)
-- terminalInput : Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg)
-- Applies: underline-only border, black bg, white text, orange on focus

Element.Input.text
    (UI.Style.terminalInput False [ width fill, height (px 48) ])
    { onChange = SetCommentAuthor
    , text = v
    , label = UI.Text.labelText "NAAM"
    , placeholder = Nothing
    }
```

**Applies to:** All `Input.text` and `Input.multiline` calls in `Activities.elm` (5 instances) and `Authentication.elm` (2 instances).

### Pattern 4: UI.Button for Clickable Data Rows

**Current anti-pattern (in Ranking and Topscorers):**
```elm
-- BAD: raw onClick on Element.el
Element.el [ Events.onClick (ViewRankingDetails line.uuid), Element.pointer ]
    (UI.Text.simpleText line.name)

-- BAD: raw onClick on Element.row
Element.row
    [ spacing 20, padding 10, Font.color UI.Color.primaryText, onClick msg ]
    [ teamBadge, Element.text name ]
```

**The fix:** Add a `clickableRow` variant to `UI.Button` or use `UI.Button.pill UI.Style.Potential` for data rows that need click handling. Based on the CONTEXT, if no existing variant maps cleanly, add a new one:

```elm
-- To add to UI.Button:
dataRow : ButtonSemantics -> msg -> List (Element.Element msg) -> Element.Element msg
dataRow semantics msg children =
    Element.row
        (UI.Style.button semantics [ Element.padding 8, Element.width Element.fill, Element.Events.onClick msg, Element.pointer ])
        children
```

### Anti-Patterns to Avoid

- **Raw `onClick` on `Element.el` or `Element.row`:** Always go through `UI.Button`.
- **Hardcoded `px NNN` width without `Screen.maxWidth`:** Results pages were doing `width (px 300)` in `Results/Bets.elm viewAdminRow` — this is only an inner row constraint and is acceptable, but outer wrappers must use `Screen.maxWidth`.
- **`padding N` inside pages that already have the outer 8px/24px padding from View.elm:** The outer `contentPadding` in `View.elm` applies `Element.padding 8` (Phone) or `Element.padding 24` (Computer). Inner pages should use `paddingXY 0 N` (vertical only) to avoid double horizontal padding.
- **`spacingXY 0 N` vs `spacing N`:** Use `Element.spacing N` for column children with equal vertical rhythm; reserve `spacingXY` only when horizontal and vertical spacing differ.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Max-width page container | Custom column with hardcoded `px` width | `UI.Page.container screen name items` | Already exists as pattern; `Screen.maxWidth` is the single source of truth |
| Terminal input styling | Ad-hoc `Border.widthEach` + `Background.color` per input | `UI.Style.terminalInput hasError attrs` | Already defined; avoids drift |
| Clickable data rows | Raw `Element.el [onClick]` | `UI.Button.dataRow` (new variant) | Keeps all interactive elements in UI.Button |
| Color constants | Inline `rgb255` values | `UI.Color.*` tokens | All colors centralized in UI.Color |

**Key insight:** Every styling token is already defined in `UI.Style`, `UI.Color`, or `UI.Font`. This phase is about routing all call sites through those definitions — not creating new ones.

---

## Common Pitfalls

### Pitfall 1: Double Horizontal Padding

**What goes wrong:** Adding `paddingXY 16 0` or `padding 20` inside a page column that is already inside the `View.elm` outer padding wrapper (`Element.el [ contentPadding ]`).
**Why it happens:** Each page used to be standalone; the outer padding was added in View.elm (Phase 2) but not all inner pages removed their own horizontal padding.
**How to avoid:** Inner page containers use `paddingXY 0 N` (vertical only). The `UI.Page.container` function should enforce `paddingXY 0 0` as default and only add vertical spacing.
**Warning signs:** Content appears indented on both sides more than expected on narrow screens.

### Pitfall 2: Screen Not Threaded to Results Pages

**What goes wrong:** `Results/Matches.elm`, `Results/Knockouts.elm`, `Results/Topscorers.elm` currently take `Model Msg -> Element.Element Msg` — they have access to `model.screen` but do not use it. The fix is to read `model.screen` in each `view` function and pass it to the container.
**Why it happens:** These pages were written before the mobile work phases.
**How to avoid:** In each `view model =`, bind `screen = model.screen` and pass to `UI.Page.container screen "pageName"`.
**Warning signs:** Content stretches full width on wide screens even after the fix — means the container was not used at the outermost level.

### Pitfall 3: `UI.Style.page` Is Currently a No-Op

**What goes wrong:** Assuming `UI.Style.page attrs` adds meaningful styles — it currently returns `attrs ++ []`.
**Why it happens:** It was written as a hook. The styles come from whatever is passed in `attrs`.
**How to avoid:** When writing `UI.Page.container`, pass all meaningful attributes to `Element.column` directly, using `UI.Style.page` as the convention wrapper (it will remain a no-op until the team decides to add global page styles).

### Pitfall 4: Pattern-Matching on Card Variants

**What goes wrong:** When modifying `UI.Page` or `Form/View.elm`, a pattern match on `Card` variants elsewhere will fail to compile if new variants were added.
**Why it happens:** Per MEMORY.md — "When adding state to a Card variant, search all files for bare `PatternCard ->` patterns — `View.elm` and `Form/View.elm` had extra matches to fix."
**How to avoid:** Phase 4 does not add Card variants. Only risk is if `viewCardChrome` or `Form/View.elm` is modified — check that pattern matches on `IntroCard`, `GroupMatchesCard`, `BracketCard`, `TopscorerCard`, `ParticipantCard`, `SubmitCard` remain exhaustive.

### Pitfall 5: `viewHome` Uses `Screen.width` Not `Screen.maxWidth`

**What goes wrong:** `View.elm viewHome` uses `Screen.width model.screen` which returns `Element.width (fill |> maximum (maxWidth screen))` — this IS the correct pattern. Do not change it. The distinction is: `Screen.width` returns an `Element.Attribute`, while `Screen.maxWidth` returns an `Int` (for use in `px` or in `fill |> maximum`).
**Why it happens:** Two functions exist: `Screen.width : Size -> Attribute` (convenience) and `Screen.maxWidth : Size -> Int` (the raw value). Both compute 80% of screen width.
**How to avoid:** Use `Screen.width model.screen` when setting it as a direct attribute; use `Screen.maxWidth model.screen` when constructing `fill |> maximum N` inside a column/container function.

### Pitfall 6: `UI.Page.page` Already Used by Form Pages

**What goes wrong:** `Form/GroupMatches.elm`, `Form/Participant.elm`, and `Form/Bracket/View.elm` all import `UI.Page exposing (page)` and call `page "name" [...]`. The existing `page` function uses `width fill` with no max — if you rename or change the existing `page` function signature, these three call sites break.
**How to avoid:** Add the NEW function as `container` alongside the existing `page`. Do not remove or modify `page`. Existing form pages can be migrated to `container` as a separate step.

---

## Code Examples

### Correct Page Container Usage

```elm
-- Source: Form/View.elm viewCardChrome (existing correct pattern)
Element.column
    [ padding 0
    , spacing 30
    , Element.centerX
    , Element.width
        (Element.fill
            |> Element.maximum (Screen.maxWidth model.screen)
        )
    ]
    [ checkboxArea, nav, card ]

-- Target: UI.Page.container (new function)
-- Usage in Results/Matches.elm:
view : Model Msg -> Element.Element Msg
view model =
    UI.Page.container model.screen "matches"
        [ UI.Text.displayHeader "Resultaten Wedstrijden"
        , displayMatches access results.results
        ]
```

### Correct Terminal Input Usage

```elm
-- Source: Form/Participant.elm (reference implementation)
Element.Input.text
    (UI.Style.terminalInput hasError
        [ Element.width Element.fill
        , Element.height (Element.px 48)
        , Element.htmlAttribute (Html.Events.onFocus (FocusField tag))
        , Element.htmlAttribute (Html.Events.onBlur BlurField)
        ]
    )
    { onChange = Set << attr
    , text = current
    , label = UI.Text.labelText labelStr
    , placeholder = Nothing
    }

-- Target: Activities.elm viewCommentInput authorInput
authorInput v =
    Element.Input.text
        (UI.Style.terminalInput False
            [ Element.height (Element.px 48)
            , Element.width Element.fill
            ]
        )
        { onChange = SetCommentAuthor
        , text = v
        , label = UI.Text.labelText "NAAM"
        , placeholder = Nothing
        }
```

### Correct Section Separator

```elm
-- Source: Activities.elm commentBox (reference)
Element.column
    [ Element.paddingXY 0 8
    , Element.width Element.fill
    , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
    , Border.color Color.terminalBorder
    ]
    [ ... ]

-- Use the same pattern in Results pages between groups/sections
```

---

## State of the Art

| Old Approach | Current Approach | Status | Impact |
|--------------|-----------------|--------|--------|
| `px N` hardcoded width per page | `Screen.maxWidth model.screen` via `UI.Page.container` | Target for this phase | Responsive width on all pages |
| Bare `Input.text [ Border.rounded 0 ]` | `UI.Style.terminalInput False [...]` | Target for this phase | Consistent terminal aesthetic |
| Raw `Element.el [onClick]` for data rows | `UI.Button.dataRow` | Target for this phase | All interactivity through UI.Button |
| Ad-hoc spacing (0/5/10/14/20/24/30px mix) | 3-tier rhythm: 8/12/24px | Target for this phase | Visual consistency |
| `UI.Page.page` with `width fill` | `UI.Page.container` with `Screen.maxWidth` | New function to add | Width-constrained pages everywhere |

**Existing correct implementations (do not change):**
- `View.elm` outer page padding: 8px Phone / 24px Computer — correct, leave as-is
- `UI.Style.terminalInput`: correct definition — reference only
- `Activities.elm` `commentBox`/`blogBox` terminal separators — already correct
- `Form/Participant.elm` terminal inputs — already correct
- `Form/View.elm` `viewCardChrome` width constraint — already correct

---

## Page-by-Page Change Inventory

### UI.Page.elm
- Add `container : UI.Screen.Size -> String -> List (Element.Element msg) -> Element.Element msg`
- Keep existing `page` unchanged (used by Form pages)

### Results/Matches.elm
- Thread `model.screen` into `view`'s local `container` call
- `displayMatches`: change `padding 10, spacingXY 20 40, centerX` to `spacing 24`
- Match cards: apply `UI.Style.darkBox` or equivalent terminal border instead of raw `Border.width 5` with ad-hoc color

### Results/Knockouts.elm
- Add `model.screen`-based width to outer `Element.column`
- `viewKnockoutsPerTeam`: normalize `padding 20, spacing 20` to rhythm (`spacing 12`)
- This is an admin-only page; terminal styling improvements are secondary to width constraint

### Results/Topscorers.elm
- Add `model.screen`-based width to outer `Element.column`
- `viewTopscorer`: replace raw `onClick msg` on `Element.row` with `UI.Button.dataRow` or `pill`

### Results/Ranking.elm
- Top-level `view` returns `Element.column []` with no width — apply `container` here
- `viewRankingLine`: replace raw `Events.onClick`+`Element.pointer` with a `UI.Button` variant

### Results/Bets.elm
- Apply `container` at top level; thread `model.screen`

### Activities.elm
- `viewCommentInput`: apply `UI.Style.terminalInput False` to all 3 `Input.text`/`multiline` calls
- `viewPostInput`: apply `UI.Style.terminalInput False` to all 4 `Input.*` calls

### Authentication.elm
- Apply `UI.Style.terminalInput False` to username `Input.multiline` and password `Input.text`

---

## Open Questions

1. **Should `UI.Button.dataRow` use `Potential` semantics by default?**
   - What we know: ranking rows and topscorer rows are read-only for non-admin users but navigate on click
   - What's unclear: whether the orange hover effect from `buttonPotential` is desirable on ranking rows
   - Recommendation: use `UI.Style.Potential` semantics for clickable data rows (orange on hover = clear interactive affordance)

2. **Should `UI.Page.container` replace the existing `page` function calls in Form pages?**
   - What we know: `Form/GroupMatches.elm`, `Form/Participant.elm`, `Form/Bracket/View.elm` call `UI.Page.page` which has `width fill` with no max-width
   - What's unclear: Form cards already have width constraint applied by `Form/View.elm viewCardChrome`; the inner `page` call adds a second `width fill` which is harmless but redundant
   - Recommendation: migrate Form pages to `container` in this phase for consistency; the outer `viewCardChrome` constraint wins anyway due to elm-ui specificity

3. **Spacing rhythm: 12px vs 16px for item rows?**
   - What we know: `spacingXY 0 20` is used for ranking group rows; `spacing 20` in activities list
   - What's unclear: 12px may feel tight with Sometype Mono at scaled 1 (16px base)
   - Recommendation: use `spacing 16` for item rows (one font-size unit) and `spacing 24` for section gaps (one-and-a-half units)

---

## Sources

### Primary (HIGH confidence)
- Direct codebase audit of all source files — actual current patterns verified by reading source
- `src/UI/Screen.elm` — `maxWidth`, `width`, `device` API confirmed
- `src/UI/Style.elm` — `terminalInput`, `darkBox`, `buttonPotential` confirmed
- `src/UI/Page.elm` — existing `page` function confirmed (no max-width, is a no-op wrapper)
- `src/UI/Button.elm` — available variants confirmed
- `src/Form/Participant.elm` — reference terminal input implementation confirmed
- `src/View.elm` — outer padding (8px Phone / 24px Computer) confirmed

### Secondary (MEDIUM confidence)
- Pattern recommendations for spacing rhythm based on `UI.Font.scaled` values (base 16px, modular scale 1.25)

### Tertiary (LOW confidence)
- None — this is a codebase audit, not an ecosystem research task

---

## Metadata

**Confidence breakdown:**
- Page-by-page change inventory: HIGH — derived directly from source code audit
- Spacing rhythm recommendations: MEDIUM — values chosen to fit Sometype Mono aesthetic, not derived from authoritative source
- UI.Page.container API design: HIGH — follows existing Screen.maxWidth patterns in codebase

**Research date:** 2026-02-27
**Valid until:** Stable (pure internal refactoring, no external dependencies)
