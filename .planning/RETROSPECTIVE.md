# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

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

## Cross-Milestone Trends

| Milestone | Phases | Plans | Timeline | LOC   | Key Theme |
|-----------|--------|-------|----------|-------|-----------|
| v1.0      | 5      | 16    | 4 days   | 19,400 | PWA + mobile UX foundation |
| v1.1      | 4      | 7     | 2 days   | 19,800 | UX refinement + install prompts |
| v1.2      | 4      | 6     | 1 day    | 19,880 | Visual polish + terminal aesthetic |

**Observation:** Milestones are getting faster and smaller as the foundation stabilises. v1.2 touched only 8 files with net +28 LOC — cosmetic completeness, not feature growth.
