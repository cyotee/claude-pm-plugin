---
description: Launch agent worktree for a specific task
---

# Launch Agent Worktree

Create a git worktree and PROMPT.md for a task, ready for agent execution.

**Arguments:** $ARGUMENTS

## Instructions

### Step 1: Parse Arguments

1. Extract task ID from arguments (e.g., "CRANE-003").
2. Extract optional flags:
   - `--max-iterations N` - Safety limit for agent iterations (default: 0 = unlimited)
   - `--force` - Launch even if dependencies are incomplete

### Step 2: Validate Task

1. Find task directory: `tasks/{TASK_ID}-*/`
2. If not found, show available tasks and abort.
3. Read TASK.md and PROGRESS.md.
4. Check status: warn if "Complete" or already "In Progress".

### Step 3: Dependency Check

Build dependency graph and verify all dependencies are Complete.

If blocked (without `--force`): Show incomplete dependencies, recommend completing them first, suggest `--force` as escape hatch.

### Step 4: Prepare Task Files

1. Initialize PROGRESS.md if empty (mark as "Task Launched").
2. Commit task files so the worktree will have them.

### Step 5: Create Worktree

1. Determine branch name: `feature/{TASK_DIR_NAME}` (includes task ID prefix).
2. Create worktree at `{REPO_ROOT}-wt/{BRANCH}`.
3. Initialize submodules in the worktree.
4. If submodule init fails, stop and report failure.

### Step 6: Setup Agent Environment

1. Create `PROMPT.md` in worktree root pointing to task files (TASK.md, PROGRESS.md). Include dependency status table, instructions for reading task files, updating PROGRESS.md, and outputting promise tags on completion.
2. Create state file `.claude/backlog-agent.local.md` with iteration tracking.
3. Update tasks/INDEX.md status to "In Progress" with worktree branch name.

### Step 7: Output Launch Instructions

```
AGENT READY: {PREFIX}-{NNN} - {Title}

Step 1: cd {ABSOLUTE_WORKTREE_PATH}
Step 2: claude --dangerously-skip-permissions
Step 3: /up:prompt

The stop hook gates exit until:
- Agent outputs <promise>PHASE_DONE</promise>
- Agent outputs <promise>BLOCKED: [reason]</promise>
- Max iterations reached
```

### Step 8: Create Exit Flag and Promise

Create `.claude/backlog-exit` flag file, then output:
```
<promise>BLOCKED: worktree_launched_start_new_session</promise>
```

Do not output anything after the promise tag.

## After Implementation

When the agent outputs `<promise>PHASE_DONE</promise>` and exits:

1. **Go to review:** `/pm-review {TASK_ID}`
2. **Complete directly:** `/pm-complete {TASK_ID}`

## Arguments Reference

| Argument | Description |
|----------|-------------|
| `<task-id>` | Task ID to launch (e.g., CRANE-003) |
| `--max-iterations N` | Optional safety limit (default: 0 = unlimited) |
| `--force` | Launch even if dependencies are incomplete |

## Related Commands

- `/pm` - View all tasks
- `/pm-work <ID>` - Start task in current session
- `/pm-complete <ID>` - Complete and cleanup worktree
- `/pm-review <ID>` - Transition to review mode
