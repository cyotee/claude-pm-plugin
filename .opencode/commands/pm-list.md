---
description: List all unarchived tasks with status, dependencies, and worktree info
---

# List Tasks

Display all unarchived tasks with status, dependencies, and worktrees.

**Arguments:** $ARGUMENTS

## Instructions

### Step 1: Read Configuration

Read `design.yaml` to extract `repo_prefix` for task ID pattern matching.

### Step 2: Read INDEX.md

Parse `tasks/INDEX.md` table to extract for each task: ID, Title, Status, Dependencies, Worktree.

If tasks/INDEX.md not found:
```
No tasks defined.

To create tasks:
1. Run /pm-init to create the tasks/ directory structure
2. Run /pm-design to create your first task
```

### Step 3: Get Active Worktrees

Run `git worktree list`. For each worktree (except main), check if `PROMPT.md` exists and extract task ID.

### Step 4: Compute Status

For each task:
- If status is "Complete", "In Progress", or "In Review" -- use stored status
- If all dependencies are Complete -- status is "Ready"
- If any dependency is not Complete -- status is "Blocked"

### Step 5: Output Format

**If `--worktrees-only`:** Show only active worktrees table (Task, Branch, Path, Mode).

**Standard output:** Show full task table with ID, Title, Status, Dependencies, Worktree columns, plus a summary by status and next action recommendations.

## Status Icons Reference

| Status | Icon |
|--------|------|
| Complete | check |
| In Progress | rocket |
| In Review | clipboard |
| Changes Requested | refresh |
| Ready | new |
| Blocked | x |

## Related Commands

- `/pm` - Detailed status with dependency graph
- `/pm-read <ID>` - Read full task details
- `/pm-launch <ID>` - Launch agent worktree
- `/pm-complete <ID>` - Complete and cleanup
