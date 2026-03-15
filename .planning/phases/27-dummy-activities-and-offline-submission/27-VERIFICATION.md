---
phase: 27-dummy-activities-and-offline-submission
verified: 2026-03-14T22:35:00Z
status: passed
score: 3/3 must-haves verified
re_verification: false
---

# Phase 27: Dummy Activities and Offline Submission Verification Report

**Phase Goal:** Inject pre-populated dummy activities in test mode and make comment/post submission work fully offline.
**Verified:** 2026-03-14T22:35:00Z
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Navigating to #test then #home shows pre-populated dummy comments and blog posts in the activity list | VERIFIED | `RefreshActivities` branch in Main.elm injects `RemoteData.Success TestData.Activities.dummyActivities` when `model.testMode` is true; no HTTP command issued |
| 2 | Submitting a comment on #home in test mode prepends it to the activity list without any network request | VERIFIED | `SaveComment` branch has `if model.testMode then` guard; constructs `AComment`, prepends with `newActivity :: existingList`, resets form via `initComment`, returns `Cmd.none` |
| 3 | Submitting a blog post on #blog in test mode prepends it to the activity list without any network request | VERIFIED | `SavePost` branch has `if model.testMode then` guard; constructs `APost`, prepends with `newActivity :: existingList`, resets form via `initPost`, returns `Cmd.none` |

**Score:** 3/3 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/TestData/Activities.elm` | Static list of 5 dummy Activity values (APost, AComment, AComment, ANewBet, AComment) | VERIFIED | File exists, 31 lines, exports `dummyActivities : List Activity`, contains exactly 5 entries in correct order: APost + 3x AComment + ANewBet, mixed variants match spec |
| `src/Main.elm` | testMode guards in RefreshActivities, SaveComment, SavePost branches | VERIFIED | All 3 guards present; `import TestData.Activities` added at line 29; `Activity(..)`, `initComment`, `initPost` added to Types import at line 30 |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/Main.elm (RefreshActivities)` | `TestData.Activities.dummyActivities` | `RemoteData.Success TestData.Activities.dummyActivities` injected into `model.activities.activities` | WIRED | Line 632: `{ oldActivities | activities = RemoteData.Success TestData.Activities.dummyActivities }` |
| `src/Main.elm (SaveComment)` | `model.activities.activities` | `newActivity :: existingList` with NotAsked fallback to dummyActivities | WIRED | Lines 422-428: `case model.activities.activities of RemoteData.Success acts -> acts; _ -> TestData.Activities.dummyActivities`; line 435: `RemoteData.Success (newActivity :: existingList)` |
| `src/Main.elm (SavePost)` | `model.activities.activities` | `newActivity :: existingList` with NotAsked fallback to dummyActivities | WIRED | Lines 553-559: same pattern as SaveComment; line 566: `RemoteData.Success (newActivity :: existingList)` |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| ACT-01 | 27-01-PLAN.md | User sees dummy lorem ipsum comments and blog posts on the activities page in test mode | SATISFIED | RefreshActivities guard injects 5-entry dummyActivities list; no HTTP call in testMode |
| ACT-02 | 27-01-PLAN.md | User can add a comment in test mode; it appends to the list locally without a network call | SATISFIED | SaveComment guard prepends AComment to existingList, returns Cmd.none |
| ACT-03 | 27-01-PLAN.md | User can add a blog post in test mode; it appends to the list locally without a network call | SATISFIED | SavePost guard prepends APost to existingList, returns Cmd.none |

No orphaned requirements — only ACT-01, ACT-02, ACT-03 are mapped to Phase 27 in REQUIREMENTS.md, and all three are claimed by plan 27-01.

### Anti-Patterns Found

None. No TODO/FIXME/HACK comments, no Debug.log calls, no empty implementations, no stub handlers in either modified file.

### Human Verification Required

The following behaviors require manual browser testing to confirm fully:

#### 1. Dummy activity display on #home in test mode

**Test:** Navigate to `#test`, then navigate to `#home`. Observe the activity list.
**Expected:** 5 entries appear immediately: one WK 2026 blog post and 4 comments (3 by name + 1 ANewBet entry for Jan), with no spinner.
**Why human:** Visual rendering and absence of a network request cannot be confirmed by static analysis alone.

#### 2. Comment submission — offline prepend

**Test:** In test mode on `#home`, fill the comment form with any author and message, then submit.
**Expected:** New comment appears at the top of the activity list. DevTools Network panel shows no outbound HTTP request. Comment form resets to empty.
**Why human:** Network activity and DOM mutation must be observed in a running browser.

#### 3. Blog post submission — offline prepend

**Test:** In test mode on `#blog`, fill the post form (author, title, message) and submit.
**Expected:** New post appears at the top of the activity list. DevTools Network panel shows no outbound HTTP request. Post form resets to empty.
**Why human:** Same reason as above.

#### 4. NotAsked fallback

**Test:** Enter test mode via `#test`. Without visiting `#home` first (so activities remain NotAsked), submit a comment.
**Expected:** List shows all 5 dummyActivities plus the new comment at the top (6 entries total).
**Why human:** Requires controlling navigation order and observing state in a running app.

### Gaps Summary

No gaps. All automated checks pass:
- `src/TestData/Activities.elm` exists, is substantive (5 entries, correct types), and is imported and used in `src/Main.elm`.
- All three `if model.testMode then` guards are present in the correct branches.
- All three key links are wired — dummyActivities is referenced in RefreshActivities (direct injection) and as the `_ ->` fallback in both SaveComment and SavePost.
- `make build` compiles with zero errors or warnings.
- Commits bc0bcce and bbd7af3 exist in git history.
- Requirements ACT-01, ACT-02, ACT-03 are all satisfied with no orphans.

---

_Verified: 2026-03-14T22:35:00Z_
_Verifier: Claude (gsd-verifier)_
