---
name: task-reviewer
description: Review a specific task or few tasks for quality before implementation. Use when the user says "review this task", "check task quality", "is this task ready", "validate task MKT-003", or is working on a task and wants inline quality feedback. For comprehensive backlog audits, use the task-auditor agent instead.
---

# Task Reviewer

Review task definitions for quality and INDEX.md consistency. This skill helps ensure tasks are well-defined before implementation begins.

## When to Use

- Before starting implementation of a task
- After creating new tasks with `/pm:design`
- When auditing task backlog quality
- To find orphaned or mismatched tasks

## Quick Review Process

1. **Load configuration** from `design.yaml` to get repo prefix
2. **Scan tasks/** using `Glob` pattern: `tasks/*-*/TASK.md` (exclude `archive/`)
3. **Read each task's files**: TASK.md, PROGRESS.md, REVIEW.md
4. **Check against quality checklist** (see [checklist.md](checklist.md))
5. **Validate INDEX.md** against actual directories
6. **Report findings** with severity levels

## Required Sections in TASK.md

Every task must have:
- `# Task {PREFIX}-{NNN}: {Title}` header
- `## Description` section
- `## Dependencies` section (even if "None")
- `## User Stories` section (at least one)
- `## Files to Create/Modify` section
- `## Inventory Check` section
- `## Completion Criteria` section

## Severity Levels

- **Critical**: Task cannot be implemented (missing sections, invalid refs)
- **Warning**: Quality issues (vague criteria, incomplete coverage)
- **Suggestion**: Improvements recommended (better wording, more detail)

## Common Issues

1. Vague acceptance criteria ("works correctly")
2. Missing error case coverage
3. Stale dependencies (completed tasks still blocking)
4. Incomplete file lists
5. Status mismatches between INDEX.md and TASK.md
6. Orphaned tasks (directory exists, not in INDEX.md)

For detailed checklist, see [checklist.md](checklist.md).
For output format template, see [output-format.md](output-format.md).
