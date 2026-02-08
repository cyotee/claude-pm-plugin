---
description: Create new tasks from code review suggestions
---

# Create Tasks from Review Suggestions

Parse a task's REVIEW.md file and create new tasks from accepted suggestions. This closes the review loop by turning actionable feedback into tracked work items.

**Task to process:** $ARGUMENTS

## Instructions

### Step 1: Validate Input

1. Check argument provided. If empty: "Usage: /pm-from-review <task-id>"
2. Find task directory: `tasks/{TASK_ID}-*/`
3. Check for REVIEW.md. If not found: "Run code review first."

### Step 2: Load Configuration

Read `design.yaml` to extract `repo_prefix` and `repo_name`.

### Step 3: Parse REVIEW.md

Extract the Suggestions section. For each suggestion, identify:
- Title, Priority, Description, Affected Files, User Response

Categorize:
- **Accepted** -- create new task
- **Modified** -- create task with user's modifications
- **Rejected** -- skip

### Step 4: Interactive Confirmation

For each accepted/modified suggestion, confirm with user:
- Create as new task?
- Modify description first?
- Skip?

### Step 5: Create New Tasks

For each confirmed suggestion:
1. Generate task ID and directory.
2. Create TASK.md with origin reference to the original task, dependency on original task, user stories from suggestion, and affected files.
3. Create PROGRESS.md and REVIEW.md templates.

### Step 6: Update INDEX.md

Add new task rows to tasks/INDEX.md.

### Step 7: Update Original REVIEW.md

Mark processed suggestions as "Converted to task {PREFIX}-{NNN}".

### Step 8: Output Summary

Show: tasks created (with IDs, titles, priorities), skipped suggestions, updated files, and next steps (`/pm-design-review`, `/pm-launch`).

## Error Handling

- **No task ID:** "Usage: /pm-from-review <task-id>"
- **No REVIEW.md:** "Run code review first"
- **No suggestions:** "No suggestions found in REVIEW.md"
- **No accepted suggestions:** "Mark suggestions as Accepted first"

## Related Commands

- `/pm-review <ID>` - Run code review
- `/pm-design-review <ID>` - Review task definitions
- `/pm-launch <ID>` - Launch agent worktree
- `/pm` - View all tasks
