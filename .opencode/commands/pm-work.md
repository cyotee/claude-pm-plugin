---
description: Start working on a task in the current session (no worktree)
---

# Start In-Session Task

Start working on a task directly in the current session without creating a worktree. Ideal for quick, simple tasks that don't need worktree isolation.

**Arguments:** $ARGUMENTS

## Instructions

### Step 1: Parse Arguments

1. Extract task ID from arguments (e.g., "MKT-007").
2. If no task ID provided, show usage: `/pm-work <task-id>`

### Step 2: Validate Task

1. Find task directory: `tasks/{TASK_ID}-*/`
2. Check status in INDEX.md:
   - "Complete" -- abort
   - "In Review" -- abort
   - "Blocked" -- abort
   - "In Progress" -- check for conflicts
   - "Ready" -- proceed

### Step 3: Check for Conflicts

1. Check if task has an active worktree (abort if so, suggest using the worktree).
2. Check for existing PROMPT.md from another task (abort if conflict).

### Step 4: Branch Handling

If on main branch, note that simple tasks can work directly on main. For complex tasks, a feature branch can be created on completion if needed.

### Step 5: Create PROMPT.md

Generate PROMPT.md in current directory with task context, required reading (TASK.md, PROGRESS.md), instructions, context compaction recovery, and completion protocol. Include forbidden commands warning -- the agent must NOT invoke `/pm-complete` or `/pm-review`.

### Step 6: Update INDEX.md

Update task status to "In Progress".

### Step 7: Create State File

Create `.claude/backlog-agent.local.md` with iteration tracking (gates the stop hook).

### Step 8: Initialize PROGRESS.md

Add session log entry marking in-session work started.

### Step 9: Output Instructions

```
TASK STARTED: {TASK_ID} - {TITLE}

Working in-session (no worktree).
PROMPT.md created with task context.

Required Reading:
1. tasks/{TASK_NAME}/TASK.md - Requirements
2. tasks/{TASK_NAME}/PROGRESS.md - Progress log

Workflow:
1. Read the task requirements
2. Implement the changes
3. Update PROGRESS.md as you work
4. When done: output <promise>PHASE_DONE</promise>
5. Wait for user to decide next step

Do NOT invoke /pm-complete or /pm-review yourself.
```

## Error Handling

- **No task ID provided:** "Usage: /pm-work <task-id>"
- **Task not found:** Show available task IDs
- **Task has worktree:** Abort with worktree location
- **Another task in progress:** Abort with current task info

## Related Commands

- `/pm-launch <ID>` - Create worktree for isolated work
- `/pm-complete <ID>` - Complete in-session task
- `/pm-read <ID>` - Read task details
- `/pm` - View all tasks
