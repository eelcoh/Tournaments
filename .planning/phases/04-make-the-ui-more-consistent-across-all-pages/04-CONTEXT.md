# Phase 4: make the UI more consistent across all pages - Context

**Gathered:** 2026-02-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Unify the visual treatment, responsive behavior, spacing patterns, and component usage across all app pages — Home (activities), Form (all cards), and Results (Ranking, Matches, Knockouts, Topscorers, Bets). No new features or pages added.

</domain>

<decisions>
## Implementation Decisions

### Responsive width constraints
- All pages — both Results pages AND Form pages — must use `Screen.maxWidth model.screen` for their top-level content width
- Single source of truth: every page calls `Screen.maxWidth`, not ad-hoc `px` values
- Form pages (GroupMatches, Bracket, Participant, Topscorer, Submit) should be audited and aligned to this standard even though they received Phase 2/3 mobile work
- Pages currently missing constraints: Results/Matches, Results/Knockouts, Results/Topscorers — these are the primary targets

### Spacing and padding rhythm
- Claude defines a consistent rhythm (values chosen to complement the existing terminal aesthetic)
- Inner content relies on the outer page padding (8px Phone / 24px Computer from View.elm) — no extra horizontal padding added inside page content
- Vertical spacing between sections should follow the rhythm Claude establishes, replacing the current mix of 0/5/10/20/24px values

### Terminal aesthetic coverage
- **Home page:** Both the activity feed items AND the comment/post input boxes need terminal treatment
  - Activity feed: log-line style `[HH:MM] author:` (already defined in UI.Text.timeText)
  - Input boxes: use `terminalInput` style (underline-only, dark bg, orange focused border) matching Participant form
- **Results pages (Matches, Knockouts, Topscorers, Ranking):** Both terminal border separators AND button styles need fixing
  - Apply `terminalBorder` separators between sections
  - Replace any non-terminal button styles with correct `UI.Style.ButtonSemantics` variants

### Component usage uniformity
- **Team names:** Always use `T.display` (3-char short codes) everywhere — both Form and Results pages. No full team names.
- **Clickable elements:** All interactive elements use `UI.Button` — no raw `Element.el` with `onClick`. If a pattern doesn't map to an existing UI.Button variant, add a new one rather than bypassing the component.
- **Page wrapper:** Extract a shared `UI.Page.container` helper that applies consistent max-width (`Screen.maxWidth`), vertical spacing rhythm, and Screen constraints. Every page (Home, Form cards, Results pages) uses this helper as its outer wrapper.

### Claude's Discretion
- Exact spacing rhythm values (multiples of 4 or 8 that look right with Sometype Mono)
- Which existing UI.Button variant maps to which clickable data element (e.g. ranking rows)
- Whether `UI.Page.container` takes screen as a parameter or a width argument

</decisions>

<specifics>
## Specific Ideas

- The Participant card form is the reference for correct terminal input style (`terminalInput`)
- The ranking row (darkBox) already uses correct terminal structure — use it as a reference for other Results data rows
- Activity log-line format: `[HH:MM] author: message` for comments, `[HH:MM] ## title` for blog posts (already implemented in timeText/displayHeader)

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 04-make-the-ui-more-consistent-across-all-pages*
*Context gathered: 2026-02-27*
