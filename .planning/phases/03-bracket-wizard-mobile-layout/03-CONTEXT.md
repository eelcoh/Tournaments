# Phase 3: Bracket Wizard Mobile Layout - Context

**Gathered:** 2026-02-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Make the bracket wizard navigable on 375px-wide phones without zooming or horizontal scrolling. This covers: the round stepper, the team selection grid, and round header presentation. Creating posts/interactions and bracket data structure are out of scope.

</domain>

<decisions>
## Implementation Decisions

### Stepper compact format
- Use a 3-step context window: `[x] Prev — > Current — [ ] Next` (only adjacent steps shown)
- Ellipsis hidden at boundaries: at step 1 show `> Winnaar — [ ] Finalist`; at step 6 show `[x] R16 — > R32`
- Steps in the stepper are tappable, but **only if completed** (filled by user) — prevents skipping ahead
- Active step marked with `>` prefix; completed steps marked with `[x]` prefix; pending steps with `[ ]`

### Team grid density
- Badge content: 3-letter code **plus a small flag** (e.g., flag emoji + NED)
- Column count: **always 4 columns on Phone** regardless of how many teams are in the round
- R32 grid: group label separators between groups (`-- A --` then 4 teams, `-- B --` then 4 teams, etc.)
- Grid shows **only plausible teams** for each round — only teams the user has advanced to that stage

### Current step emphasis
- Active step marked with `>` prefix in the 3-step stepper
- Completed steps marked with `[x]` in the stepper
- Round name appears as a **standalone header above the team grid**: `-- Kwartfinale --`
- When returning to a previously completed step, already-selected teams are **highlighted** so the user can see and change their pick

### Placed team visibility
- Placed teams **stay in the selection grid** — they do not disappear
- Visual treatment for placed teams: `[x] NED` in orange color (consistent with terminal style)
- Tapping a placed team **un-picks it** (removes from its slot, returns to available)
- Teams eliminated in earlier rounds are **hidden** from later round grids — only plausible teams shown

### Claude's Discretion
- Exact flag representation (emoji, icon, or asset) and its size within a 4-column cell
- Exact pixel spacing and font sizes within grid cells
- Whether step navigation animates or cuts immediately

</decisions>

<specifics>
## Specific Ideas

- Stepper pattern mirrors the terminal UX already in place: `>` for active, `[x]` for done — keep visual language consistent across the whole app
- Group label separators in the team grid (`-- A --`) mirror the group boundary separators already used in the GroupMatches scroll wheel

</specifics>

<deferred>
## Deferred Ideas

- None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-bracket-wizard-mobile-layout*
*Context gathered: 2026-02-25*
