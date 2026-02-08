---
description: Read and display a specific task's full details
---

# Read Task

Display the full content of a specific task from its task directory.

**Task to read:** $ARGUMENTS

## Instructions

### Step 1: Find Task

1. Extract task ID from arguments (e.g., "CRANE-003", "IDX-007").
2. Find task directory: `tasks/{TASK_ID}-*/`
3. If not found, show available task IDs from tasks/INDEX.md.

### Step 2: Read Task Files

- `tasks/{ID}-{name}/TASK.md` - Requirements
- `tasks/{ID}-{name}/PROGRESS.md` - Implementation progress (if exists)
- `tasks/{ID}-{name}/REVIEW.md` - Review notes (if exists)

### Step 3: Display Formatted Output

```
TASK: {PREFIX}-{NNN} - {Title}

Status: {Status}
Dependencies: {Dependencies or "None"}
Worktree: {Branch or "Not started"}
Directory: tasks/{PREFIX}-{NNN}-{kebab-name}/

## Requirements (TASK.md)
{Full content}

## Progress (PROGRESS.md)
Last checkpoint: {summary}
{Latest session log or "No progress recorded yet"}

## Review (REVIEW.md)
Status: {Review status or "Not yet reviewed"}
{Summary or "No review yet"}

## Actions
- To launch agent: /pm-launch {PREFIX}-{NNN}
- To review: /pm-review {PREFIX}-{NNN}
- To complete: /pm-complete {PREFIX}-{NNN}
```

## Error Handling

- **No task ID provided:** "Usage: /pm-read <task-id>"
- **Task not found:** Show available task IDs
- **No tasks/ directory:** "Run /pm-init to set up task management"
- **Missing TASK.md:** "Task directory exists but TASK.md is missing"

## Related Commands

- `/pm-launch <ID>` - Launch agent worktree
- `/pm-review <ID>` - Transition to review mode
- `/pm-complete <ID>` - Complete task
- `/pm` - View all tasks
