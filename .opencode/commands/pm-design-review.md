---
description: Audit task definitions for quality and completeness (not code review - see /pm:review for that)
---

# Task Definition Audit

Audit and refine task **definitions** (TASK.md files) for quality and completeness. This reviews the task specifications themselves, NOT the implementation code.

**For code review** of completed implementations, use `/pm-review` instead.

**Arguments received:** $ARGUMENTS

## Register Operation with Built-in Task Feature

**IMPORTANT:** Use the built-in Task feature to track this audit operation.

Call `TaskCreate` with:
- **subject**: `Review: {TASK_ID or "All Tasks"}`
- **description**: `Auditing task definitions for quality and completeness`
- **activeForm**: `Reviewing task definitions`

Then call `TaskUpdate` to set status to `in_progress`:
- **taskId**: The ID returned from TaskCreate
- **status**: `in_progress`

Store this task ID for later completion.

## Command Dispatch

### If no arguments: Review All Tasks

1. **Load configuration:**
   ```bash
   cat design.yaml
   ```

2. **Scan tasks/ directories** and analyze each task's TASK.md for:
   - Completeness (all required sections present)
   - Clarity (unambiguous requirements)
   - User story quality (testable acceptance criteria)
   - Dependencies (correctly identified and up-to-date)
   - Status accuracy (does status reflect actual state?)

3. **Generate a review report:**

```
═══════════════════════════════════════════════════════════════════
 TASK REVIEW REPORT
═══════════════════════════════════════════════════════════════════

## Summary

| Task | Title | Issues | Recommendation |
|------|-------|--------|----------------|
| {PREFIX}-001 | ... | None | Ready |
| {PREFIX}-002 | ... | Missing deps | Needs update |

## Detailed Findings

### {PREFIX}-{NNN}: {Title}

**Status:** {Current status}
**Location:** tasks/{PREFIX}-{NNN}-{kebab-name}/TASK.md

**Issues:**
- {Issue 1}
- {Issue 2}

**Recommendations:**
- {Action 1}
- {Action 2}

═══════════════════════════════════════════════════════════════════
```

4. **Ask user** which tasks they want to address, then update the relevant TASK.md files.

### If task ID provided: Review Specific Task

1. **Find task directory:**
   ```bash
   # Find task directory matching the ID
   ls -d tasks/${TASK_ID}-* 2>/dev/null
   ```

2. **Read task files:**
   - tasks/{ID}-{name}/TASK.md - Requirements
   - tasks/{ID}-{name}/PROGRESS.md - Implementation progress (if exists)
   - tasks/{ID}-{name}/REVIEW.md - Prior review notes (if exists)

3. **Analyze the task** for:
   - **Description clarity:** Is the purpose clear?
   - **User stories:** Are they complete and testable?
   - **Acceptance criteria:** Specific and measurable?
   - **Dependencies:** Still accurate? Any new blockers?
   - **Files to create/modify:** Complete list?
   - **Inventory checks:** All prerequisites listed?
   - **Completion criteria:** How do we know it's done?

4. **Interactive refinement:** Use AskUserQuestion to:
   - Clarify any ambiguous requirements
   - Identify missing user stories
   - Update outdated information
   - Add newly discovered dependencies

5. **Update TASK.md** with refinements.

6. **Output summary:**

```
═══════════════════════════════════════════════════════════════════
 TASK REVIEWED: {PREFIX}-{NNN}
═══════════════════════════════════════════════════════════════════

Title: {Title}
Status: {Status}

## Changes Made

- {Change 1}
- {Change 2}

## Remaining Issues

- {Issue or "None"}

## Next Steps

{Recommendations for the task}

═══════════════════════════════════════════════════════════════════
```

## Review Checklist

For each task, verify:

### Structure
- [ ] Has Description section
- [ ] Has Dependencies section (even if "None")
- [ ] Has User Stories (at least one)
- [ ] Has Files to Create/Modify section
- [ ] Has Inventory Check section
- [ ] Has Completion Criteria section

### Quality
- [ ] Description explains "what" and "why"
- [ ] Each user story follows "As a... I want... so that..." format
- [ ] Acceptance criteria are testable (not vague)
- [ ] Dependencies reference specific task IDs (e.g., "CRANE-001")
- [ ] File paths are accurate and complete
- [ ] Inventory checks are verifiable

### Consistency
- [ ] Task ID in header matches directory name
- [ ] Status reflects actual progress
- [ ] Repo name is correct
- [ ] Worktree branch name follows convention (feature/{kebab-name})
- [ ] INDEX.md entry matches TASK.md content

## Common Issues to Flag

1. **Vague acceptance criteria:** "Works correctly" → Should be specific and testable
2. **Missing error cases:** Only happy path covered
3. **Stale dependencies:** Completed tasks still listed as blockers
4. **Incomplete file lists:** Tests or interfaces missing
5. **No inventory checks:** Agent won't verify prerequisites
6. **Status mismatch:** Marked "Ready" but has unmet dependencies
7. **Missing user stories:** Just a description without formal stories
8. **Orphaned tasks:** Task directory exists but not in INDEX.md

## Index Validation

Also validate tasks/INDEX.md:

1. **All tasks listed:** Every tasks/{PREFIX}-{NNN}-*/ has INDEX.md entry
2. **No orphan entries:** Every INDEX.md entry has a directory
3. **Status accuracy:** INDEX.md status matches TASK.md status
4. **Dependencies valid:** All referenced task IDs exist

## Mark Built-in Task Completed

When the review is complete (either for all tasks or a specific task), call `TaskUpdate`:
- **taskId**: The ID from the TaskCreate call at the start
- **status**: `completed`

## Example Usage

```bash
# Review all tasks
/pm-design-review

# Review specific task
/pm-design-review CRANE-003

# Review specific task (alternate format)
/pm-design-review CRANE-003-uniswap-v4-utils
```
