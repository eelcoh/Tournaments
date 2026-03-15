---
phase: 28
slug: dummy-results
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-14
---

# Phase 28 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — `elm-test` not configured |
| **Config file** | None |
| **Quick run command** | `make build` |
| **Full suite command** | `make build` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `make build`
- **After every plan wave:** Run `make build`
- **Before `/gsd:verify-work`:** `make build` must be green
- **Max feedback latency:** ~5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 28-01-01 | 01 | 1 | RES-01 | manual + compiler | `make build` | N/A | ⬜ pending |
| 28-01-02 | 01 | 1 | RES-02 | manual + compiler | `make build` | N/A | ⬜ pending |
| 28-01-03 | 01 | 1 | RES-03 | manual + compiler | `make build` | N/A | ⬜ pending |
| 28-01-04 | 01 | 1 | RES-04 | manual + compiler | `make build` | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

None — existing infrastructure (Makefile, elm compiler) covers all phase validation.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| #stand shows dummy ranking in test mode | RES-01 | No elm-test configured | Navigate to #test, then #stand; verify dummy bettor ranking table renders |
| #uitslagen shows dummy match results | RES-02 | No elm-test configured | Navigate to #test, then #uitslagen; verify match results list renders |
| #groepsstand shows dummy group standings | RES-03 | No elm-test configured | Navigate to #test, then #groepsstand; verify group standings table renders |
| #knock-out shows dummy bracket | RES-04 | No elm-test configured | Navigate to #test, then #knock-out; verify knockout bracket renders |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
