# Phase 38: Group Matches Polish - Research

**Researched:** 2026-03-18
**Domain:** Elm 0.19.1 / elm-ui — responsive layout, team badge design, typography consistency
**Confidence:** HIGH

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| GMATCH-01 | Wide badges (150px) shown when screen >=400px; small badges (85px) when <400px | Screen.Size.width available in Model; conditional badge fn based on width threshold |
| GMATCH-02 | Wide home badge: flag then full name (left-to-right, same as QF-Champion bracket style) | `viewWideBadge` in Form/Bracket/View.elm shows exact pattern: flagImg + T.displayFull |
| GMATCH-03 | Wide away badge: full name then flag (mirrored) | Reverse of wide home: T.displayFull + flagImg |
| GMATCH-04 | Small home badge: flag then code (same as R32/R16 bracket style) | `viewCompactBadge` / `viewTeamBadge` in Form/Bracket/View.elm: flagImg + T.display |
| GMATCH-05 | Small away badge: code then flag (mirrored) | Reverse of compact: T.display + flagImg |
| GMATCH-06 | Match rows vertically centered with consistent column alignment | Fixed-width badge elements (px 150 or px 85) + fixed-width score col + centerY on all elements |
| GMATCH-07 | Group label separators use same size and style as R32 bracket group code headers | R32 group label: Font.size 12, Color.terminalAccentDim, UI.Font.mono, width px 24, height px 44, allCenteredText |
| GMATCH-08 | Group nav progress line uses same size and style as R32 bracket group code headers | Same token set as R32 group label (Font.size 12, Color.terminalAccentDim, UI.Font.mono) |
| GMATCH-09 | "Andere score" displayed as a styled clickable button at max 12px font size | Currently uses UI.Style.link (no explicit font size). Add Font.size 12 |
| GMATCH-10 | Match counter (0/36) displayed at 12px font size | Currently has no explicit Font.size; add Font.size 12 |
</phase_requirements>

---

## Summary

Phase 38 is a pure view-layer polish pass on `src/Form/GroupMatches.elm`. No new types, no state changes, no new messages — only the rendering functions change. The work divides into five independent concerns: (1) responsive badge rendering with two width tiers, (2) mirrored home/away badge layout, (3) column alignment in the scroll wheel, (4) typography consistency between group labels/nav and the bracket R32 section, and (5) small font fixes for "Andere score" and the match counter.

All reference patterns already exist in the codebase. The bracket view (`Form/Bracket/View.elm`) provides `viewWideBadge` (150px, flag + full name) and `viewCompactBadge`/`viewTeamBadge` (85px, flag + code) as canonical models to copy and adapt. The R32 group code header style — `Font.size 12`, `Color.terminalAccentDim`, `UI.Font.mono`, `Element.height (px 44)`, `allCenteredText` — is the exact token set GMATCH-07 and GMATCH-08 need. Screen width is already in `Model.screen.width` (a `Float`) and flows into the form via `Form.View.viewCard`, but `Form.GroupMatches.view` currently only receives `Bet` and `State`. The screen size must be threaded through.

**Primary recommendation:** Thread `Screen.Size` (or just `model.screen.width`) into `Form.GroupMatches.view`, then render responsive home/away badge pairs using width-conditional helper functions modelled directly on the bracket's badge functions.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mdgriffith/elm-ui | 1.1.8 | All layout and styling | Project convention; no CSS files |
| elm/core | 1.0.5 | Language primitives | Built-in |

No new dependencies are needed. All required primitives (`Element.px`, `Element.width`, `Element.row`, `Font.size`, `Font.color`, `Element.centerY`) are already in scope.

---

## Architecture Patterns

### Key Insight: Screen Width Threading

`Form.GroupMatches.view` currently has signature:
```elm
view : Bet -> State -> Element.Element Msg
```

It is called from `Form.View.viewCard` which has access to `model.screen` (a `Screen.Size`). To implement GMATCH-01 through GMATCH-05, the screen width must reach the view function. Two options:

**Option A — Pass `Screen.Size` directly (preferred)**
```elm
view : Screen.Size -> Bet -> State -> Element.Element Msg
```
Call site in `Form.View`:
```elm
GroupMatchesCard groupMatchesState ->
    Element.map GroupMatchMsg (Form.GroupMatches.view model.screen model.bet groupMatchesState)
```

**Option B — Pass `Int` badge width**
```elm
view : Int -> Bet -> State -> Element.Element Msg
```
Less flexible but avoids the `Screen` import in `Form.GroupMatches`.

Option A is preferred because it keeps the same pattern used by `Form.Bracket.View` (which also receives screen info).

The width threshold for GMATCH-01 is **400px** (per requirements). Current `UI.Screen.device` uses 500px as the Phone/Computer boundary — do NOT use that. Compute locally:
```elm
isWide : Screen.Size -> Bool
isWide screen = screen.width >= 400
```

### Badge Width Values (from bracket, confirmed)
- Wide badge: `Element.px 150` (matches `viewWideBadge` baseAttrs)
- Compact badge: `Element.px 85` (matches `viewCompactBadge` baseAttrs and `viewTeamBadge`)

### Home/Away Mirrored Badge Layout

Wide home (flag left, name right):
```elm
Element.row [ spacing 8, Element.centerX, Element.centerY, Element.clipX, Element.width Element.fill ]
    [ flagImg                        -- flag on left
    , Element.el [ UI.Font.mono, Font.color textColor, Font.size 11 ]
        (Element.text (T.displayFull team))   -- full name on right
    ]
```

Wide away (name left, flag right) — mirrored:
```elm
Element.row [ spacing 8, Element.centerX, Element.centerY, Element.clipX, Element.width Element.fill ]
    [ Element.el [ UI.Font.mono, Font.color textColor, Font.size 11 ]
        (Element.text (T.displayFull team))   -- name on left
    , flagImg                        -- flag on right
    ]
```

Small home (flag left, code right):
```elm
Element.row [ spacing 8, Element.centerX, Element.centerY ]
    [ flagImg
    , Element.el [ UI.Font.mono, Font.color textColor, Font.size 11 ]
        (Element.text (T.display team))
    ]
```

Small away (code left, flag right) — mirrored:
```elm
Element.row [ spacing 8, Element.centerX, Element.centerY ]
    [ Element.el [ UI.Font.mono, Font.color textColor, Font.size 11 ]
        (Element.text (T.display team))
    , flagImg
    ]
```

### Flag Image Dimensions (from bracket)
```elm
flagImg team =
    Element.image
        [ Element.height (Element.px 20)
        , Element.width (Element.px 28)
        ]
        { src = T.flagUrl (Just team)
        , description = T.display team
        }
```

### Current Match Row Structure vs. Target

**Current `viewScrollLine`** renders a single `Element.row` with no fixed widths on the team side — text width varies by team name length, causing ragged alignment. The score column floats freely.

**Target structure for GMATCH-06** (consistent column alignment):
```elm
Element.row [ spacing 4, centerY, Element.width Element.fill ]
    [ homeBadgeEl   -- fixed width: px 150 or px 85
    , scoreEl       -- fixed width, centerX
    , awayBadgeEl   -- fixed width: px 150 or px 85, mirror layout
    ]
```

Each badge element must have an explicit `Element.width (Element.px N)` constraint so all rows align identically regardless of team name length. This is the same technique used in `viewCompactBadge` and `viewWideBadge`.

### R32 Group Code Header Style (GMATCH-07, GMATCH-08)

From `viewR32Grid` and `viewGroup` in `Form/Bracket/View.elm`:
```elm
-- Group label in R32
Element.el
    [ Font.color Color.terminalAccentDim
    , UI.Font.mono
    , Font.size 12
    , Element.width (Element.px 24)
    , Element.height (Element.px 44)
    ]
    (UI.Text.allCenteredText (Group.toString grp))
```

**GMATCH-07 — Group label separators in scroll wheel** should use this same token set. Currently:
```elm
-- WLGroupLabel in viewWindowLine
Element.el
    [ centerX, Font.color Color.grey, UI.Font.mono
    , Element.height (Element.px 44), centerY
    ]
    (Element.text ("-- " ++ G.toString grp ++ " --"))
```
Change: use `Color.terminalAccentDim` instead of `Color.grey`, `Font.size 12`.

**GMATCH-08 — Group nav letters** in `viewGroupNav` currently have no explicit font size (inherits from parent). The active/done color logic is fine but should be consistent with bracket group headers in size (`Font.size 12`). Note: only the *non-active, non-complete* grey state maps to GMATCH-08; the requirement is about "same size and style as R32 bracket group code headers", meaning `Font.size 12` and monospace. Active group uses `Color.orange`, complete uses `Color.green` — these can stay.

### "Andere score" Button Styling (GMATCH-09)

Currently:
```elm
andereScoreLink =
    Element.el
        (UI.Style.link [ centerX, UI.Font.mono, Element.Events.onClick ShowManualInput ])
        (Element.text "andere score")
```

`UI.Style.link` sets `Font.color Color.orange` and `Element.pointer`. It does NOT set a font size. The requirement says "styled button at max 12px". Add `Font.size 12`.

### Match Counter Font Size (GMATCH-10)

Currently in `viewProgress`:
```elm
Element.el [ centerX, Font.color Color.grey, UI.Font.mono ]
    (Element.text (String.fromInt completed ++ "/" ++ String.fromInt total))
```

No explicit font size. Add `Font.size 12`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Responsive badge sizing | Custom CSS class / viewport queries | `if screen.width >= 400 then ... else ...` conditional in Elm | Elm-ui has no CSS; all responsiveness through Elm logic |
| Flag images | SVG inline / canvas | `T.flagUrl` + `Element.image` | Already implemented; all flags in assets/svg/ |
| Full team name | Custom team name field | `T.displayFull team` | Already returns teamName from Team record |
| 3-letter code | String.left 3 | `T.display team` | Returns teamID which is the 3-letter code |

---

## Common Pitfalls

### Pitfall 1: Screen.device threshold is 500px, not 400px
**What goes wrong:** Using `Screen.device model.screen == Phone` for the badge size switch gives the wrong breakpoint (500px vs 400px required).
**How to avoid:** Write a local `isWide screen = screen.width >= 400` function. Do not delegate to `Screen.device`.

### Pitfall 2: Fixed-width badge + `Element.width fill` on the row
**What goes wrong:** If the outer `Element.row` does not have `Element.width Element.fill`, the fixed-width badge cells can be clipped or the row may not stretch to full card width.
**How to avoid:** Outer match row should have `Element.width Element.fill` or `matchRowTile` already adds this (it does: `Element.width Element.fill`).

### Pitfall 3: `clipX` on wide badge breaks flag visibility
**What goes wrong:** `viewWideBadge` in the bracket uses `Element.clipX` on the content row and the badge container. On very narrow screens the flag can be clipped.
**How to avoid:** Wide badges are only shown at >=400px. At 400px with two 150px badges + a score column, total width is ~330–360px — this fits within the minimum 400px screen. Add `Element.clipX` to the text element only, not the flag image.

### Pitfall 4: `T.displayFull` vs `T.display` confusion
**What goes wrong:** Using `T.display` (teamID = 3-letter code) for the wide badge shows codes instead of full names.
**How to avoid:** Wide badge uses `T.displayFull` (teamName = "Netherlands"). Compact badge uses `T.display` (teamID = "NED").

### Pitfall 5: viewScrollLine signature change breaks module boundary
**What goes wrong:** `viewScrollLine` is a private helper inside `Form/GroupMatches.elm`. Changing its signature to accept screen width is fine — but `view` must receive and thread the screen size down.
**How to avoid:** Extend `view` signature and the call site in `Form.View` simultaneously in the same task.

### Pitfall 6: Away badge mirroring on small screens looks wrong
**What goes wrong:** On small screens with 85px badges, the away team's text is on the left (correct for mirroring), but the layout can appear asymmetric because the score column is not perfectly centered.
**How to avoid:** Give the score column a fixed width (e.g., `Element.width (Element.px 48)`) with `Font.center` and `Element.centerY` so it acts as a stable center anchor.

---

## Code Examples

Verified from `src/Form/Bracket/View.elm`:

### Wide badge (150px) — home side layout pattern
```elm
-- Source: src/Form/Bracket/View.elm, viewWideBadge
baseAttrs =
    [ Element.width (Element.px 150)
    , Element.height (Element.px 44)
    , Background.color Color.primaryDark
    , Border.width 1
    , Border.rounded 2
    , Border.color borderColor
    , paddingXY 8 4
    , Element.clipX
    ]

content =
    Element.row
        [ spacing 8, Element.centerX, Element.centerY, Element.clipX, Element.width Element.fill ]
        [ flagImg
        , Element.paragraph
            [ UI.Font.mono, Font.color nameColor, Font.size 11, Font.medium, Element.clipX, Element.width Element.fill ]
            [ Element.text (T.displayFull team) ]
        ]
```

### Compact badge (85px) — home side layout pattern
```elm
-- Source: src/Form/Bracket/View.elm, viewCompactBadge
baseAttrs =
    [ Element.width (Element.px 85)
    , Element.height (Element.px 44)
    , Background.color Color.primaryDark
    , Border.width 1
    , Border.rounded 2
    , Border.color borderColor
    , paddingXY 12 10
    ]

content =
    Element.row
        [ spacing 8, Element.centerX, Element.centerY ]
        [ flagImg
        , Element.el [ UI.Font.mono, Font.color textColor, Font.size 11 ] (Element.text (T.display team))
        ]
```

### R32 group code header token set
```elm
-- Source: src/Form/Bracket/View.elm, viewR32Grid > viewGroupSection > groupLabel
Element.el
    [ Font.color Color.terminalAccentDim
    , UI.Font.mono
    , Font.size 12
    , Element.width (Element.px 24)
    , Element.height (Element.px 44)
    ]
    (UI.Text.allCenteredText (Group.toString grp))
```

### Screen width threshold (local function, not Screen.device)
```elm
-- Use this pattern, NOT Screen.device (which uses 500px threshold)
isWide : Screen.Size -> Bool
isWide screen =
    screen.width >= 400
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| 12 separate group cards | Single GroupMatchesCard with scroll wheel | Issue #91 (v1.1) | All 48 matches in one scroll UI |
| Text-only match rows (T.display) | Still text-only with flag images | Current | GMATCH-01–05 add responsive badges |
| Inherited font sizes | Implicit sizes | Current | GMATCH-09/10 add explicit 12px |

---

## Open Questions

1. **Score column width for alignment**
   - What we know: The current score column (`h ++ "-" ++ a`) is at most 5 chars wide (e.g., "10-10")
   - What's unclear: Exact pixel width that looks balanced between two 150px or two 85px badges
   - Recommendation: Use `Element.width (Element.px 48)` with `Font.center` as a reasonable fixed width; adjust if it looks off

2. **Away badge color for active/completed state**
   - What we know: Current `textColor` uses `isActive`/`isCompleted` — both home and away share the same color
   - What's unclear: Requirements don't specify separate colors for home vs away in the badge
   - Recommendation: Use the same `textColor` logic for both — no change needed

---

## Files to Change

| File | Changes |
|------|---------|
| `src/Form/GroupMatches.elm` | Main target: extend `view` signature, rewrite `viewScrollLine`, update `viewWindowLine` (WLGroupLabel), update `viewGroupNav`, update `viewProgress`, update andereScoreLink styling |
| `src/Form/View.elm` | Update `GroupMatchesCard` branch to pass `model.screen` to `Form.GroupMatches.view` |

No changes needed to:
- `src/Form/GroupMatches/Types.elm` (no new state)
- `src/UI/Style.elm` (no new styles needed; existing tokens suffice)
- `src/UI/Color.elm` (all needed colors exist)

---

## Sources

### Primary (HIGH confidence)
- `src/Form/Bracket/View.elm` — canonical source for 150px wide badge, 85px compact badge, R32 group label style
- `src/Form/GroupMatches.elm` — current implementation being changed
- `src/UI/Screen.elm` — Screen.Size type and device threshold (500px)
- `src/UI/Style.elm` — matchRowTile, link styles
- `src/UI/Color.elm` — terminalAccentDim, grey, orange, green tokens
- `.planning/REQUIREMENTS.md` — authoritative requirement definitions

### Secondary (MEDIUM confidence)
- `prototypes/design-prototype.html` — design intent for group tabs and match rows (CSS prototype, not Elm)

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — no new dependencies; all elm-ui patterns are established in this codebase
- Architecture: HIGH — all patterns copied directly from existing bracket view code
- Pitfalls: HIGH — screen threshold and badge sizing pitfalls verified by reading actual source

**Research date:** 2026-03-18
**Valid until:** 2026-04-18 (stable codebase, no external dependencies changing)
