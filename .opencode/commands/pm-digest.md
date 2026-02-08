---
description: Digest an existing design document into individual tasks
---

# Digest Design Document

Parse an existing design document (UNIFIED_PLAN.md, PRD.md, or any markdown file) into individual tasks in the tasks/ directory structure.

**Document to digest:** $ARGUMENTS

## Instructions

### Step 1: Validate Prerequisites

1. Check `design.yaml` exists (run `/pm-init` first if not)
2. Check `tasks/` directory exists
3. Check file argument is provided and file exists

### Step 2: Load Configuration

Read `design.yaml` to extract `repo_prefix`, `repo_name`, and optional `submodules` list.

### Step 3: Read and Analyze Document

Read the specified document. Identify sections that could be individual tasks. Look for existing task definitions, user stories, numbered sections. Find dependencies between sections and cross-repo references.

### Step 4: Identify Tasks

For each potential task, extract: Title, Description, Dependencies, User stories or acceptance criteria, Files to create/modify.

### Step 5: Interactive Clarification

For each identified task, ask clarifying questions about:
- **Repo assignment** (if submodules defined): Which repo should the task live in?
- **Missing information:** Any ambiguous or incomplete requirements?
- **Dependency validation:** Are referenced dependencies correct?
- **Acceptance criteria:** Any missing criteria to add?

### Step 6: Create Task Directories

For each confirmed task, create the full structure:
```
tasks/{PREFIX}-{NNN}-{kebab-name}/
  TASK.md
  PROGRESS.md
  REVIEW.md
```

### Step 7: Update INDEX.md

Add each new task row to tasks/INDEX.md in each affected repo.

### Step 8: Output Summary

Show digest results: tasks identified vs created vs skipped, dependency map, blocked tasks, and next steps (review with `/pm-design-review`, launch with `/pm-launch`).

## Error Handling

- **File not found:** Report path error
- **No tasks/ directory:** "Run `/pm-init` first"
- **Empty document:** "No identifiable tasks found"
- **Parse error:** "Consider using `/pm-design` manually"

## Related Commands

- `/pm-init` - Initialize task management
- `/pm-design` - Create task interactively
- `/pm-design-review` - Review task definitions
- `/pm-launch <ID>` - Launch agent worktree
