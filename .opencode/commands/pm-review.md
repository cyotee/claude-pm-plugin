---
description: Transition task to code review mode in worktree
---

# Transition Task to Code Review Mode

Update PROMPT.md in an existing worktree to switch from implementation to code review mode. This reviews the implementation code, NOT the task definition.

**For task definition audits** (checking TASK.md quality), use `/pm-design-review` instead.

**Task to review:** $ARGUMENTS

## Instructions

### Step 1: Validate Task

1. Extract task ID from arguments (e.g., "CRANE-003").
2. Find task directory and verify it exists.
3. Check task status in INDEX.md:
   - "Complete" -- abort, nothing to review
   - "In Review" -- abort, already in review mode
   - "In Progress" or "Ready" -- proceed
4. Find existing worktree. Must have a worktree to transition.

### Step 2: Initialize Review Files

Create/update `REVIEW.md` in the task directory with sections for: Clarifying Questions, Review Findings (with severity and status per finding), Suggestions (with priority and user response tracking), and Review Summary.

### Step 3: Update PROMPT.md

Update PROMPT.md in the worktree to review mode. Include required reading (TASK.md, PRD.md, PROGRESS.md, REVIEW.md), review instructions (verify acceptance criteria, check tests, look for bugs/security issues, document findings, write suggestions), and promise protocol.

### Step 4: Update State and INDEX

1. Update state file mode to "review".
2. Update INDEX.md status to "In Review".

### Step 5: Output Instructions

```
REVIEW MODE: {PREFIX}-{NNN} - {Title}

PROMPT.md updated to review mode in existing worktree.

Step 1: Exit current Claude session (if any)
Step 2: cd {ABSOLUTE_WORKTREE_PATH}
        claude --dangerously-skip-permissions
Step 3: /up:prompt

After Review:
- If review passed: /pm-complete {TASK_ID}
- If changes needed: Work on changes, then review again

TIP: Use a different model for review for a fresh perspective.
```

### Step 6: Create Exit Flag and Promise

Create `.claude/backlog-exit` flag, then output:
```
<promise>BLOCKED: review_mode_configured_start_new_session</promise>
```

Do not output anything after the promise tag.

## Error Handling

- **No task ID:** "Usage: /pm-review <task-id>"
- **Task not found:** Show available task IDs
- **No worktree exists:** "Use /pm-launch first"
- **Already in review:** "Task is already in review mode"

## Related Commands

- `/pm-launch <ID>` - Launch agent for implementation
- `/pm-complete <ID>` - Complete and merge task
- `/pm-from-review <ID>` - Create tasks from review suggestions
