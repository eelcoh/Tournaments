---
phase: 04-make-the-ui-more-consistent-across-all-pages
plan: "03"
subsystem: ui

tags: [elm, elm-ui, UI.Page, UI.Button, results-pages, layout, consistency, terminal-aesthetic]

# Dependency graph
requires:
  - "04-01"
provides:
  - "All 5 Results pages width-constrained via UI.Page.container"
  - "terminalBorder section separators on all 5 Results pages"
  - "UI.Button.dataRow replaces raw onClick in Ranking and Topscorers"
affects:
  - 04-04-PLAN.md

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Results pages use UI.Page.container for width-constrained column with max-width cap"
    - "terminalBorder separator: Element.column with Border.widthEach bottom=1 + Border.color UI.Color.terminalBorder"
    - "viewRankingLine and viewTopscorer use UI.Button.dataRow for consistent click affordance"

key-files:
  created: []
  modified:
    - src/Results/Matches.elm
    - src/Results/Bets.elm
    - src/Results/Knockouts.elm
    - src/Results/Topscorers.elm
    - src/Results/Ranking.elm

key-decisions:
  - "Matches.elm displayMatches uses wrappedRow (not column) — match tiles remain in a wrapped grid; spacing normalized to 24 (section-gap tier)"
  - "Topscorers.elm view changed from wrappedRow to column of separator-wrapped rows — separators require column layout"
  - "Ranking.elm terminalBorder wrapper placed around viewRankingGroup (the per-rank-position block) rather than individual lines — groups are the logical sections"
  - "Removed Element.Events import from Ranking.elm and Element.Events/Font imports from Topscorers.elm after replacing raw onClick with dataRow"

patterns-established:
  - "Results pages use UI.Page.container for consistent max-width cap (no raw Element.column [])"
  - "Section separators: Element.column [ paddingXY 0 8, width fill, Border.widthEach { bottom=1, top=0, left=0, right=0 }, Border.color terminalBorder ]"

requirements-completed: [CON-02, CON-05]

# Metrics
duration: 4min
completed: 2026-02-28
---

# Phase 4 Plan 03: Results Pages Consistency Summary

**All 5 Results pages wired through UI.Page.container for consistent max-width, terminalBorder section separators added, and raw onClick patterns in Ranking and Topscorers replaced with UI.Button.dataRow**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-28T16:17:30Z
- **Completed:** 2026-02-28T16:22:00Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments

### Task 1: Results/Matches and Results/Bets (commit 0bcfc28)

- `Results/Matches.elm`: `view` now uses `UI.Page.container model.screen "matches"`; `edit` also uses container; header wrapped with terminalBorder bottom-border separator column; `displayMatches` spacing changed from `padding 10, spacingXY 20 40` to `Element.spacing 24` (section-gap rhythm); added `import UI.Page`
- `Results/Bets.elm`: `view` now uses `UI.Page.container model.screen "bets"`; header wrapped with terminalBorder bottom-border separator column; items `paddingXY 0 20` normalized to `paddingXY 0 16` (item rhythm); added `import UI.Page`, `Element.Border as Border`, `UI.Color`

### Task 2: Results/Knockouts, Topscorers, and Ranking (commit 7311aca)

- `Results/Knockouts.elm`: `view` uses `UI.Page.container model.screen "knockouts"`; `viewKnockoutsResults` wraps each team block with terminalBorder separator column; spacing changed to `Element.spacing 16`; `viewKnockoutsPerTeam` normalized to `paddingXY 0 8, spacing 12`; added `import UI.Page`, `Element.Border as Border`, `UI.Color`
- `Results/Topscorers.elm`: `view` uses `UI.Page.container model.screen "topscorers"`; `viewTopscorerResults` changed from `wrappedRow` to column with each topscorer wrapped in terminalBorder separator; `viewTopscorer` uses `UI.Button.dataRow semantics msg` replacing raw `Element.row [ onClick, Font.color, spacing, padding ]`; removed `Element.Events exposing (onClick)` and `Element.Font as Font` imports; added `import UI.Page`, `Element.Border as Border`
- `Results/Ranking.elm`: `view` uses `UI.Page.container model.screen "ranking"`; `viewRankingLine` uses `UI.Button.dataRow UI.Style.Potential` replacing raw `Element.el [Events.onClick, pointer]`; `viewRankingGroup` wrapped with terminalBorder separator column; `viewRankingLines` spacing normalized to `Element.spacing 16`; removed `Element.Events as Events` import and `pointer` from Element exposing list; added `import UI.Page`, `Element.Border as Border`, `UI.Color`

## Task Commits

1. **Task 1: Wire Results/Matches and Results/Bets** - `0bcfc28`
2. **Task 2: Wire Results/Knockouts, Topscorers, and Ranking** - `7311aca`

## Files Created/Modified

- `src/Results/Matches.elm` - container, terminalBorder header separator, spacing normalized
- `src/Results/Bets.elm` - container, terminalBorder header separator, padding normalized
- `src/Results/Knockouts.elm` - container, terminalBorder per-team separators, spacing normalized
- `src/Results/Topscorers.elm` - container, terminalBorder per-topscorer separators, viewTopscorer uses dataRow, imports cleaned
- `src/Results/Ranking.elm` - container, terminalBorder per-group separators, viewRankingLine uses dataRow, imports cleaned

## Verification Results

- `grep -rn "UI.Page.container" src/Results/` — appears in all 5 files (Matches: 2x including edit, Bets: 1x, Knockouts: 1x, Topscorers: 1x, Ranking: 1x)
- `grep -rn "UI.Button.dataRow" src/Results/` — appears in Topscorers.elm and Ranking.elm
- `grep -rn "terminalBorder" src/Results/` — appears in all 5 files
- `grep -rn "Events.onClick|Element.pointer" src/Results/Ranking.elm` — no results (cleaned up)
- Full project compile: `elm make src/Main.elm` exits 0

## Decisions Made

- `displayMatches` in Matches.elm kept as `wrappedRow` — match tiles are small cards that naturally wrap; container provides the outer width cap
- Topscorers `viewTopscorerResults` changed from `wrappedRow` to column so each topscorer can have a full-width separator row
- terminalBorder separator placed at `viewRankingGroup` level (one per rank-position group) rather than per-line — groups are the logical section boundaries matching Activities.elm commentBox pattern
- Removed unused imports (Element.Events, Element.Font) after replacing raw onClick with dataRow — kept codebase clean

## Deviations from Plan

None - plan executed exactly as written. All spacing values follow the 3-tier rhythm (24px sections in displayMatches, 16px items in viewRankingLines/viewKnockoutsResults, 8px tight in per-team/per-topscorer padding).

---
*Phase: 04-make-the-ui-more-consistent-across-all-pages*
*Completed: 2026-02-28*
