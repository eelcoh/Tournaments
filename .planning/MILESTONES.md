# Milestones

## v1.0 Mobile UX (Shipped: 2026-02-28)

**Phases:** 1–5 (5 phases, 16 plans)
**Files changed:** 76 files, +8,758 / −231 lines
**Elm LOC:** ~19,400
**Timeline:** 2026-02-24 → 2026-02-28 (4 days)
**Git range:** ca7d8b8 → 541cd48

**Key accomplishments:**
1. PWA installable — self-hosted Sometype Mono fonts, manifest.json, cache-first service worker; app installs from Chrome (Android) and Safari (iOS)
2. Touch-friendly form — 44px tap zones on all interactive elements (nav letters, score buttons, bracket badges, step indicators); numeric keyboard for score inputs
3. iPhone SE fit — responsive 8px padding on Phone screens gives 296px content width on 320px viewport
4. Bracket wizard mobile — compact 3-step stepper on Phone (no horizontal overflow at 375px), 4-column team grid for comfortable tapping
5. UI consistency — UI.Page.container, UI.Button.dataRow, terminal input styling across all pages; all 5 Results pages width-constrained on desktop
6. UX polish — bracket team flags restored, sticky "Ga verder" button on R32 complete, checkmark stepper, topscorer terminal list, GroupBoundary height fix

**Archive:** `.planning/milestones/v1.0-ROADMAP.md`, `.planning/milestones/v1.0-REQUIREMENTS.md`

---

## v1.1 UX Polish (Shipped: 2026-03-01)

**Phases:** 6–9 (4 phases, 7 plans)
**Elm LOC:** ~19,800
**Timeline:** 2026-02-28 → 2026-03-01 (2 days)

**Key accomplishments:**
1. Scroll wheel stability — 7-line fixed-window with active match locked at line 4, group label anchored at line 1, WLPadding eliminating all height jumps, END marker confined to lines 5-7
2. iOS install prompt — terminal-styled banner from `navigator.standalone` flag, dismiss-persistent via localStorage, hidden when already installed
3. Android install prompt — JS-Elm port bridge capturing `BeforeInstallPrompt`, triggers native install dialog, dismissable
4. Fixed 48px bottom nav bar — vorige/volgende greyed at boundaries, per-card incomplete count, scroll-to-top on every card transition
5. Tap feedback — "verzenden..." loading state on submit; nav buttons flash white on tap via elm-ui mouseOver
6. Keyboard-primary score input — flag header always visible, keyboard as default, "andere score" overlay for text input
7. Touch polish — `user-select: none` on score buttons prevents mobile text-selection highlight on tap

**Archive:** `.planning/milestones/v1.1-ROADMAP.md`, `.planning/milestones/v1.1-REQUIREMENTS.md`

---

