---
phase: 26
slug: mode-foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-14
---

# Phase 26 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — `elm-test` is not configured (per CLAUDE.md) |
| **Config file** | None |
| **Quick run command** | `make build` |
| **Full suite command** | `make build` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `make build`
- **After every plan wave:** Run `make build`
- **Before `/gsd:verify-work`:** Full suite must be green + manual browser verification
- **Max feedback latency:** ~5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 26-01-01 | 01 | 1 | MODE-01 | manual-smoke | `make build` | N/A | ⬜ pending |
| 26-01-02 | 01 | 1 | MODE-02 | manual-smoke | `make build` | N/A | ⬜ pending |
| 26-01-03 | 01 | 1 | MODE-03 | manual-smoke | `make build` | N/A | ⬜ pending |
| 26-01-04 | 01 | 1 | MODE-04 | manual-smoke | `make build` | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements.* No `elm-test` suite exists; the only gate is `make build`.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| `#test` URL activates test mode | MODE-01 | No elm-test suite | Open browser, navigate to `#test`, verify testMode activates |
| 5 title taps activates test mode | MODE-02 | No elm-test suite | Tap app title 5 times, verify testMode activates |
| TEST MODE badge visible in status bar | MODE-03 | No elm-test suite | Activate test mode, verify badge appears in status bar |
| All nav items visible in test mode | MODE-04 | No elm-test suite | Activate test mode, verify all 6 nav items are visible |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
