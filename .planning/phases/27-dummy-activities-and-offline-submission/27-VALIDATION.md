---
phase: 27
slug: dummy-activities-and-offline-submission
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-14
---

# Phase 27 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | none — elm-test is not configured (per CLAUDE.md) |
| **Config file** | none |
| **Quick run command** | `make build` |
| **Full suite command** | `make build` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `make build`
- **After every plan wave:** Run `make build` + manual browser smoke test
- **Before `/gsd:verify-work`:** Full manual verification must pass
- **Max feedback latency:** ~30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 27-01-01 | 01 | 1 | ACT-01 | manual | `make build` | ✅ | ⬜ pending |
| 27-01-02 | 01 | 1 | ACT-02 | manual | `make build` | ✅ | ⬜ pending |
| 27-01-03 | 01 | 1 | ACT-03 | manual | `make build` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements.

*No test framework exists; no test infrastructure is being added this phase.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Dummy activities appear on #home in test mode | ACT-01 | No elm-test; UI behaviour | Navigate to `#test`, then `#home` — dummy comments and blog posts appear in activity list |
| Comment submission in test mode prepends locally | ACT-02 | No elm-test; network check required | Navigate to `#test`, then `#home`, fill comment form, submit — new comment appears at top, DevTools Network shows no HTTP request |
| Blog post submission in test mode prepends locally | ACT-03 | No elm-test; network check required | Navigate to `#test`, then `#blog`, fill post form, submit — new post appears at top, DevTools Network shows no HTTP request |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
