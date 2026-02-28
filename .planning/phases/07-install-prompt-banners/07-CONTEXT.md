# Phase 7: Install Prompt Banners - Context

**Gathered:** 2026-02-28
**Status:** Ready for planning

<domain>
## Phase Boundary

Show platform-appropriate, dismissable install prompt banners to users who haven't added the app to their home screen. iOS gets a brief instruction nudge; Android triggers the native install dialog. Both match the terminal aesthetic. Banners disappear once the app is installed (standalone mode).

</domain>

<decisions>
## Implementation Decisions

### Banner content & messaging
- iOS banner text: `[ add to home screen ] -- tap ↗ then "Add to Home Screen"`
- Android CTA text: `Installeer App` (triggers native BeforeInstallPrompt dialog)
- Both use monospace font, dark background, terminal formatting — consistent with the rest of the app

### Trigger timing
- Banner appears after a short delay after page load (not immediately on render)

### Dismiss behavior
- Dismissed once → shown again once more after a short delay (single retry, not permanent)
- Second dismissal → permanently hidden (no more retries)
- Dismiss state stored in localStorage so it persists across page reloads and visits

### Dismiss trigger
- `[x]` at the end of the banner line triggers dismiss

### Banner placement
- Pinned at the bottom of the viewport
- Positioned above or alongside the existing status bar (does not replace it)

### Claude's Discretion
- Exact delay duration for initial trigger and retry
- Whether to use a single localStorage key or separate keys for iOS/Android dismiss state
- How the banner handles very small screen heights

</decisions>

<specifics>
## Specific Ideas

- The iOS nudge format `[ add to home screen ] -- tap ↗ then "Add to Home Screen"` should feel like a terminal prompt/hint, not a modal or card
- "Installeer App" is Dutch, consistent with the app's language

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 07-install-prompt-banners*
*Context gathered: 2026-02-28*
