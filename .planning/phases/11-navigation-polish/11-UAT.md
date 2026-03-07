---
status: resolved
phase: 11-navigation-polish
source: [11-01-SUMMARY.md]
started: 2026-03-07T13:00:00Z
updated: 2026-03-07T14:00:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Nav links — terminal style (no background/border)
expected: Nav links appear as plain monospace text — no background panel, no border, no pill/button shape around any link.
result: pass

### 2. Nav link — active item orange
expected: The currently active nav link is displayed in orange. Inactive links are in the primary text color (lighter/grey).
result: issue
reported: "it is not very orange, just a bit greyish yellow, and there is not much contrast with the inactive items (which are ok)"
severity: minor

### 3. Nav link — label centered in tap zone
expected: The text label of each nav link is centered both horizontally and vertically within its clickable area. No top/bottom alignment drift.
result: pass

### 4. Form bottom nav — center step info centered
expected: In the form (betting form), the bottom nav bar shows prev / step info / next. The center step info (e.g., "stap 1/6") is truly centered over the bar — it doesn't shift left or right based on how long the prev/next labels are.
result: pass

## Summary

total: 4
passed: 3
issues: 1
pending: 0
skipped: 0

## Gaps

- truth: "Active nav link is displayed in clear orange with visible contrast against inactive links"
  status: resolved
  reason: "User reported: it is not very orange, just a bit greyish yellow, and there is not much contrast with the inactive items (which are ok)"
  severity: minor
  test: 2
  root_cause: "Color.orange = rgb255 0xF0 0xDF 0xAF (pale cream-yellow, luminance ~0.72) vs Color.primaryText = rgb255 0xDC 0xDC 0xCC (warm grey, luminance ~0.68) — near-identical lightness on the dark background, near-zero saturation difference. Logic in navlink is correct; the colour values themselves are indistinguishable. Color.orange is Zenburn yellow-accent, not a vivid orange."
  artifacts:
    - path: "src/UI/Color.elm"
      issue: "Color.orange (line 112-114) is rgb255 0xF0 0xDF 0xAF — too close in luminance and hue to Color.primaryText (rgb255 0xDC 0xDC 0xCC) to serve as an active-state indicator"
  missing:
    - "Introduce a dedicated Color.activeNav (or similar) with a saturated orange e.g. rgb255 0xF0 0xA0 0x30 — high saturation, clearly distinct from warm-grey primaryText. Apply only in navlink Active branch in src/UI/Button.elm so existing Color.orange usage is unaffected."
  debug_session: ""
