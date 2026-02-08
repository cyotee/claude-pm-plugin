---
description: Display task status summary from tasks/INDEX.md
---

# PM Status Dashboard

Display a summary table of all tasks from tasks/INDEX.md with dependency-aware status computation.

**Arguments:** $ARGUMENTS

## Instructions

### Step 1: Load Configuration

Read `design.yaml` to extract `repo_prefix` and `repo_name`.

If not found or empty, report:
```
No backlog defined.

To create a backlog:
1. Run /pm-init to create the tasks/ directory structure
2. Run /pm-design to create your first task
```

### Step 2: Build Dependency Graph

Parse tasks/INDEX.md and any submodule INDEX.md files. Build dependency and reverse-dependency graphs. Check for circular dependencies and warn if found.

### Step 3: Compute Effective Status

For each task, compute effective status:
- If stored status is "In Progress", "In Review", or "Complete" -- keep it
- If stored status is "Ready" or "Blocked":
  - Any dependency not "Complete" -- status is "Blocked"
  - All dependencies "Complete" -- status is "Ready"

### Step 4: Display Status Table

```
PM STATUS: {REPO_NAME}

| ID | Title | Status | Computed | Dependencies | Blockers |
|----|-------|--------|----------|--------------|----------|

Summary: Complete: N, In Progress: N, In Review: N, Ready: N, Blocked: N

Ready for Agent: (tasks with all deps met)
Blocked: (tasks waiting on deps)
Next Recommended: (best task to start)
```

### Step 5: Optional Views

- `--graph` - ASCII dependency graph visualization
- `--critical-path` - Longest dependency chain
- `--order` - Recommended task order (topological sort)

### Step 6: Status Corrections

If computed status differs from stored status, suggest corrections with a table showing stored vs. computed status and the reason.

## Arguments Reference

| Argument | Description |
|----------|-------------|
| `--graph` | Show ASCII dependency graph visualization |
| `--critical-path` | Show longest dependency chain |
| `--order` | Show recommended task execution order |

## Related Commands

- `/pm-read <ID>` - Read full task details
- `/pm-launch <ID>` - Launch agent worktree for a task
- `/pm-review <ID>` - Transition task to review mode
- `/pm-complete <ID>` - Complete and merge a task
- `/pm-prune` - Archive completed tasks
- `/pm-list` - Simple task list table
- `/pm-design` - Create a new task
- `/pm-design-review` - Review task definitions
