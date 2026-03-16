# Stack Research: Bracket Wizard Redesign (v1.7)

**Domain:** elm-ui layout patterns for fixed-width badge grids, text clipping, and group-organized display in Elm 0.19.1 SPA
**Researched:** 2026-03-16
**Confidence:** HIGH — all patterns verified against existing codebase and official elm-ui 1.1.8 source

---

## Executive Recommendation

**Zero new packages required.** Every capability needed for the bottom-up bracket wizard redesign is already in `elm.json`. The implementation is a pure Elm + elm-ui layout exercise using three specific patterns: fixed-width containers via `Element.width (Element.px N)`, text clipping via `Element.paragraph` + `Element.clipX`, and group-organized layout via `Element.column` + `List.Extra.greedyGroupsOf`.

---

## Recommended Stack

### Core Technologies (unchanged)

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Elm 0.19.1 | 0.19.1 | SPA runtime | Already in use; all layout patterns achievable without changes |
| mdgriffith/elm-ui | 1.1.8 | Layout and styling | `Element.width (px N)`, `Element.clip`, `Element.clipX`, `Element.wrappedRow` all available in this version |
| elm-community/list-extra | 8.2.4 | Grid row slicing | `List.Extra.greedyGroupsOf N` already used in `Form/Bracket/View.elm` for badge rows |

### Supporting Libraries (no new additions)

All libraries already in `elm.json`. No additions needed.

---

## Pattern 1: Fixed-Width Badge Cell

**Problem:** Current `viewSelectableTeam` and `viewPlacedBadge` use `Element.width Element.shrink`. With 4 badges per row and 12 groups, cells with "NED" (3 chars) and "KSA" (3 chars but wide flag + "Saoedi Arabië" as full name) will produce misaligned columns that break the grid aesthetic.

**Solution:** Replace `Element.width Element.shrink` on each badge container with `Element.width (Element.px N)` where N is a fixed pixel width chosen to fit the widest content at the target font size.

**Width calculation for R32/R16 (code-only, no full name):**
- Badge content: 3-letter code at Font.size 11 in Martian Mono
- Martian Mono is a fixed-width font — each character is the same width
- At 11px, each character is approximately 7-8px wide
- 3 chars × 8px = 24px content + 2×paddingXY 8 = 40px minimum
- Recommend **`Element.px 48`** for code-only badges — sufficient for 3 chars with 12px horizontal padding, comfortable touch target at 44px height

**Width calculation for QF–Champion (full name clipped + code):**
- Full names range from "Iran" (4 chars) to "Saoedi Arabië" (13 chars)
- At 11px full name clipped, the text will clip to the container width
- Recommend **`Element.px 72`** — fits "Frank.." nicely, leaves code row at 9px legible below
- Alternative: **`Element.px 80`** if the design needs more breathing room (matches the "80×44 bordered cards" spec from v1.4)

**Implementation:**

```elm
-- Badge container — replace Element.width Element.shrink with fixed width
Element.el
    [ Element.width (Element.px 48)   -- R32/R16: code-only
    , Element.height (Element.px 44)
    , Border.width 1
    , Border.color Color.terminalBorder
    , ...
    ]
    content
```

**Why not `Element.fill` with `fillPortion`:** `fillPortion` inside a `greedyGroupsOf` row works only if every row has the same number of items. The last row of a group may have fewer items (e.g., 1 or 2 teams), causing those cells to stretch and break the grid. Fixed `px` width is correct here.

**Why not `Element.wrappedRow` + `fill`:** `wrappedRow` distributes available space across all children on a line. With `fill`, cells on a partial last row stretch to fill the line width, producing uneven badge sizes. `greedyGroupsOf` into `Element.row` + `px` widths avoids this entirely.

**Confidence:** HIGH — `Element.width (Element.px N)` is the canonical elm-ui fixed-width pattern; verified in `UI.Button.Score` at line 91 (`height (px 44), width (px 46)`) and in `viewRoundBadge` patterns throughout the codebase.

---

## Pattern 2: Text Clipping (Full Name in Fixed-Width Badge)

**Problem:** elm-ui has no native `text-overflow: ellipsis` support. `Element.text` does not wrap and will overflow a fixed-width container. Long names like "Saoedi Arabië" (13 chars) at 11px in a 72px-wide badge will overflow visibly.

**Solution:** Use `Element.paragraph` (not `Element.text`) for the full name line, combined with `Element.clipX` and a fixed height matching the font size. This forces the text to flow onto the next line at the container boundary, then clips the second line out of view.

```elm
-- Full name line — clipped to single line
Element.paragraph
    [ Element.width Element.fill   -- fill the badge container width
    , Element.height (Element.px 13)  -- font size 11 + 2px for descenders
    , Element.clipX
    , Element.htmlAttribute (Html.Attributes.style "overflow-wrap" "anywhere")
    , UI.Font.mono
    , Font.size 11
    , Font.color cellColor
    ]
    [ Element.text (T.displayFull team) ]
```

**Why `paragraph` and not `text`:** `Element.text` in elm-ui does not wrap — it renders as a single inline span that ignores container width constraints. `Element.paragraph` participates in the flex layout and wraps at the container boundary, which combined with `height (px N)` and `clipX` produces a single visible line.

**Why `overflow-wrap: anywhere`:** Elm team names do not always contain spaces (e.g., "Saoedi Arabië" has a space, but a hypothetical single-word 13-char name would not). `overflow-wrap: anywhere` allows the browser to break at any character, ensuring the clip always fires at the container edge rather than only at word boundaries.

**What you do NOT get:** No ellipsis (...) — the text simply cuts off. This is acceptable for the badge design where the 3-letter code below confirms identity. If ellipsis were required, the only option in elm-ui 1.1.8 is `Element.htmlAttribute (Html.Attributes.style "text-overflow" "ellipsis")` combined with `white-space: nowrap; overflow: hidden` — but `white-space: nowrap` on a paragraph in elm-ui conflicts with the flex layout and may not produce reliable results across browsers. Clip-without-ellipsis is the reliable approach.

**Confidence:** MEDIUM-HIGH — community-verified workaround from Elm Discourse (discourse.elm-lang.org/t/elm-ui-clip-text-on-a-single-line/10576); `Element.clip`/`clipX` are official elm-ui 1.1.8 attributes; the `overflow-wrap: anywhere` htmlAttribute is standard CSS backed by all modern mobile browsers (iOS Safari 15.4+, Chrome Android 88+).

---

## Pattern 3: Group-Organized Layout (R32 Page)

**Problem:** R32 must show 48 teams in 12 groups of 4, with a group letter header above each group, all in a vertically scrolling column. The current `viewR32Grid` already implements this but uses `Element.width Element.shrink` badges (variable width).

**Solution:** Keep the existing `Element.column [ spacing 16 ]` + group separator + `greedyGroupsOf 4` structure. The only change is badge width (Pattern 1) and removing flags (code-only for R32).

**Current structure (correct, keep as-is):**

```elm
-- Each group section:
Element.column [ spacing 8 ]
    [ groupHeader  -- "-- A --" separator
    , Element.row [ spacing 8 ] [ badge, badge, badge, badge ]  -- row of 4
    ]
```

**Group header style (existing, keep):**
```elm
Element.el
    [ Font.color Color.grey
    , UI.Font.mono
    , Font.size 11
    ]
    (Element.text ("-- " ++ Group.toString grp ++ " --"))
```

**Why 4 columns for R32:** WC2026 groups have 4 teams exactly. Four columns at `px 48` = 192px content + 3×8px spacing = 216px — fits well within the 320px minimum phone width (content area is 296px from v1.0 design constraints). No responsive column count needed for R32.

**Why 4 columns for R16 (flat grid):** 32 teams / 4 cols = 8 rows. Flat grid without group headers because R16 teams come from mixed groups (promoted teams). The existing `viewFlatGrid` structure handles this — just apply fixed-width badges.

**Why the group-organized vs flat split matters:** R32 needs group headers because the user is making 2-picks-per-group decisions. R16 onward is a flat pick from previously selected teams — group identity is no longer the organizing principle.

**Confidence:** HIGH — existing `viewR32Grid` and `viewFlatGrid` in `Form/Bracket/View.elm` already implement this split; change is purely badge sizing.

---

## Pattern 4: Badge State Rendering

**States required by PROJECT.md:**
- Selected: green outline (Border.color Color.right = Color.green in this codebase)
- Max reached (capacity full, not yet selected): dimmed text + grey border, no pointer
- Available: grey border, orange hover, pointer
- Dimmed deselected (after being removed): treat as available

**Implementation — three variants as in current `viewSelectableTeam`:**

```elm
-- Selected state
Border.color Color.right      -- green border
Font.color Color.green        -- green text (or orange per existing convention)
Background.color (rgba 0.94 0.87 0.69 0.15)   -- amber tint

-- Available state
Border.color Color.terminalBorder
Font.color Color.primaryText
Element.mouseOver [ Border.color Color.orange ]
Element.pointer

-- Dimmed state (max reached, not selected)
Border.color Color.terminalBorder
Font.color Color.grey
-- no pointer, no mouseOver
```

**Confidence:** HIGH — directly mirrors existing `viewSelectableTeam` logic in `Form/Bracket/View.elm` lines 428-471.

---

## Pattern 5: Bottom-Up Wizard Flow (Type Changes)

**Problem:** The current `currentActiveRound` walks rounds top-down (Champion → R32) to find the first incomplete. Bottom-up flow (R32 → Champion) requires inverting this order.

**Solution:** Reverse the `rounds` list in `currentActiveRound` in `Form/Bracket/Types.elm`. No type changes needed — `SelectionRound`, `RoundSelections`, and `WizardState` are all valid for bottom-up flow.

**The `addTeamToRound` cascade must also be reversed:** Currently selecting a team for `LastThirtyTwoRound` automatically adds it to `lastSixteen`, `quarters`, etc. (upward cascade). Bottom-up means selecting for R32 should NOT pre-populate higher rounds — users pick each round independently. The cascade must be removed or restricted to only the selected round.

**Revised `addTeamToRound` for bottom-up:**
- `LastThirtyTwoRound`: add to `lastThirtyTwo` only
- `LastSixteenRound`: add to `lastSixteen` only (team must already be in `lastThirtyTwo`)
- Each higher round: add to that round only (team must be in pool from prior round)
- No upward cascade

**Pool constraint for higher rounds:** `canSelectTeam` must check that the team was selected in the immediately preceding round (not just any round). This replaces the current `alreadyInL32 || countGroupInList` check.

**Confidence:** HIGH for structural approach. MEDIUM for exact `canSelectTeam` constraint logic — verify `groupConstraintOk` semantics during implementation; the group-per-round constraint (max 3 per group in L32) only applies to R32 in the bottom-up flow.

---

## What NOT to Add

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| New package for grid layout (`vladimirlogachev/elm-modular-grid`) | Adds dependency for a problem solvable with `greedyGroupsOf` + `px` widths | `List.Extra.greedyGroupsOf N` + `Element.width (Element.px N)` |
| `text-overflow: ellipsis` via htmlAttribute | Requires `white-space: nowrap` which conflicts with elm-ui paragraph flex behavior; unreliable cross-browser | `Element.paragraph` + `height (px N)` + `Element.clipX` |
| `Element.fill` for badge cell width | Last partial row stretches, producing uneven badge widths | `Element.width (Element.px N)` |
| `Element.wrappedRow` for badge grid | Wraps at container boundary, not at N-column boundary — produces ragged right edge | `greedyGroupsOf N` into `Element.row` instances |
| Flag images in R32/R16 badges | At `px 48` badge width, flag (28×20px) + code text leaves no horizontal breathing room | Code-only badges for R32/R16; flags only for QF–Champion where badge is `px 72–80` |
| `Element.shrink` on badge width | Breaks grid alignment when team names/codes have different character counts | Fixed `Element.px` width |
| Top-down cascade in `addTeamToRound` | Pre-populates higher rounds from R32 selections, defeating the bottom-up UX | Add to one round only; validate pool membership via `canSelectTeam` |

---

## Alternatives Considered

| Recommended | Alternative | Why Not |
|-------------|-------------|---------|
| `Element.paragraph` + `clipX` + `height px` | `Element.text` truncated by JS | Elm does not expose string truncation to a pixel width (font metrics unavailable at compile time) |
| `Element.width (Element.px N)` on badge | CSS grid via `htmlAttribute` | elm-ui layout and CSS grid fight each other; htmlAttribute CSS grid requires understanding elm-ui's generated div structure, which is undocumented and changes between versions |
| `greedyGroupsOf 4` into `Element.row` | `Element.wrappedRow` | `wrappedRow` does not guarantee N per row; partial last rows stretch if children use `fill` |
| Explicit group sections with `column` | Flat list with group letter as inline separator | Group header as a separator element in a flat list shares a `row` with adjacent badges if `wrappedRow` is used — layout becomes unpredictable. Separate column per group is unambiguous |
| Remove upward cascade for bottom-up flow | Keep cascade, add "forward propagation" to higher rounds | Forward propagation (R32 selection auto-selects R16) defeats the point of bottom-up picking — user intent is to pick independently per round |

---

## Installation

No new packages. No `elm install` commands needed.

---

## Version Compatibility

All patterns use existing locked versions. No compatibility concerns.

| Capability | API | Version |
|------------|-----|---------|
| Fixed-width badge | `Element.width (Element.px N)` | mdgriffith/elm-ui 1.1.8 |
| Text clipping | `Element.clipX`, `Element.paragraph` | mdgriffith/elm-ui 1.1.8 |
| overflow-wrap CSS | `Element.htmlAttribute (Html.Attributes.style "overflow-wrap" "anywhere")` | elm/html 1.0.0 |
| Grid row slicing | `List.Extra.greedyGroupsOf N` | elm-community/list-extra 8.2.4 |
| Wrapped fallback | `Element.wrappedRow` | mdgriffith/elm-ui 1.1.8 (confirmed in codebase: `Form/GroupMatches.elm:492`, `Bets/View.elm:101`) |

---

## Key Data Points for Sizing Decisions

| Name | Length | At 11px Martian Mono (est. ~6.5px/char) |
|------|--------|-----------------------------------------|
| "Iran" | 4 chars | ~26px |
| "Japan" | 5 chars | ~33px |
| "Canada" | 6 chars | ~39px |
| "Marokko" | 7 chars | ~46px |
| "Argentina" | 9 chars | ~59px |
| "Saoedi Arabië" | 13 chars | ~85px |
| "Amerika" (USA) | 7 chars | ~46px |
| "Frankrijk" (FRA) | 9 chars | ~59px |

**Conclusion for badge widths:**
- R32/R16 (code-only, 3 chars, Font.size 11): `Element.px 48` — code "KSA" at ~20px leaves ample padding
- QF–Champion (name clipped + code, Font.size 11/9): `Element.px 80` — shows ~12 chars before clip; "Argentini..." readable; "Frank..." readable; "Iran" shows fully

---

## Sources

- Existing codebase — `src/Form/Bracket/View.elm`: `viewSelectableTeam` (lines 383-471), `viewR32Grid` (lines 314-347), `viewFlatGrid` (lines 350-380), `greedyGroupsOf 4` badge rows (lines 245, 342, 377) — HIGH confidence
- Existing codebase — `src/UI/Button/Score.elm:91`: `height (px 44), width (px 46)` — confirms fixed `px` sizing pattern — HIGH confidence
- Existing codebase — `src/Form/GroupMatches.elm:492`: `Element.wrappedRow` confirmed available in elm-ui 1.1.8 — HIGH confidence
- Existing codebase — `src/Bets/Types/Team.elm`: `display` returns `teamID` (3-char code), `displayFull` returns `teamName` (full name) — HIGH confidence
- Existing codebase — `src/Bets/Init/WorldCup2026/Tournament/Teams.elm`: full name lengths sampled (Nederland=9, "Saoedi Arabië"=13, Amerika=7, Japan=5) — HIGH confidence
- [Elm Discourse — clip text on a single line](https://discourse.elm-lang.org/t/elm-ui-clip-text-on-a-single-line/10576) — `paragraph` + `clipX` + `height px` + `overflow-wrap: anywhere` workaround — MEDIUM confidence (community, consistent with official elm-ui behavior)
- [elm-ui GitHub issue #112](https://github.com/mdgriffith/elm-ui/issues/112) — confirms no native `text-overflow: ellipsis` in elm-ui 1.1.8 — MEDIUM confidence (issue thread)

---

*Stack research for: Bracket Wizard Redesign — Elm 0.19.1 + elm-ui 1.1.8 (v1.7 milestone)*
*Researched: 2026-03-16*
