---
phase: 29
slug: fill-all-bet
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-14
---

# Phase 29 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Elm compiler (no elm-test configured) |
| **Config file** | none — project has no test suite |
| **Quick run command** | `make debug` |
| **Full suite command** | `make build` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `make debug`
- **After every plan wave:** Run `make build`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 29-01-01 | 01 | 1 | BET-01 | compile | `make debug` | ✅ | ⬜ pending |
| 29-01-02 | 01 | 1 | BET-01 | compile | `make debug` | ✅ | ⬜ pending |
| 29-01-03 | 01 | 1 | BET-01 | compile | `make debug` | ✅ | ⬜ pending |
| 29-01-04 | 01 | 1 | BET-01 | compile | `make build` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements — Elm compiler is the test framework.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| "Fill all" button visible only in test mode | BET-01 | No automated UI test | Load app without `#test` — button must be absent; load with `#test` — button must appear |
| Tapping fill button populates all scores | BET-01 | No automated UI test | Tap button; verify all 36 group matches show scores |
| Bracket fully populated after fill | BET-01 | No automated UI test | Tap button; navigate to bracket card — all rounds should show selected teams |
| Dashboard shows all [x] after fill | BET-01 | No automated UI test | Tap button; return to Dashboard — all three sections must show [x] and Submit must be enabled |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
