---
description: Audit task definitions for quality and completeness
---

# Task Definition Audit

Audit and refine task definitions (TASK.md files) for quality and completeness. This reviews the task specifications themselves, NOT the implementation code.

**For code review** of completed implementations, use `/pm-review` instead.

**Arguments:** $ARGUMENTS

## Instructions

### If No Arguments: Review All Tasks

1. Read `design.yaml` for configuration.
2. Scan all task directories and analyze each TASK.md for:
   - Completeness (all required sections present)
   - Clarity (unambiguous requirements)
   - User story quality (testable acceptance criteria)
   - Dependencies (correctly identified, up-to-date)
   - Status accuracy
3. Generate review report table: Task, Title, Issues, Recommendation.
4. Ask user which tasks to address, then update relevant TASK.md files.

### If Task ID Provided: Review Specific Task

1. Find and read task files (TASK.md, PROGRESS.md, REVIEW.md).
2. Analyze for: description clarity, user story completeness, acceptance criteria specificity, dependency accuracy, file list completeness, inventory checks, completion criteria.
3. Interactively refine with user: clarify ambiguous requirements, identify missing stories, update outdated info, add new dependencies.
4. Update TASK.md with refinements.
5. Output summary of changes made and remaining issues.

## Review Checklist

### Structure
- Has Description, Dependencies, User Stories, Files to Create/Modify, Inventory Check, Completion Criteria sections

### Quality
- Description explains "what" and "why"
- User stories follow "As a... I want... so that..." format
- Acceptance criteria are testable (not vague)
- Dependencies reference specific task IDs
- File paths are accurate and complete

### Consistency
- Task ID in header matches directory name
- Status reflects actual progress
- INDEX.md entry matches TASK.md content
- Worktree branch name follows convention

## Common Issues to Flag

1. Vague acceptance criteria ("Works correctly" -- should be specific)
2. Missing error cases (only happy path)
3. Stale dependencies (completed tasks still listed as blockers)
4. Incomplete file lists
5. No inventory checks
6. Status mismatch
7. Orphaned tasks (directory exists but not in INDEX.md)

## Related Commands

- `/pm-design <feature>` - Create new task
- `/pm-review <ID>` - Code review (not definition review)
- `/pm` - View all tasks
