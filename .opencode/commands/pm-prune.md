---
description: Archive completed tasks to tasks/archive/
---

# Prune Completed Tasks

Move completed task directories to tasks/archive/ and update INDEX.md.

## Instructions

### Step 1: Identify Completed Tasks

Read tasks/INDEX.md and find all tasks with "Complete" status.

If no completed tasks:
```
No completed tasks to archive.

Tasks are marked Complete after:
1. Implementation finished (PHASE_DONE promise)
2. Code review passed (PHASE_DONE promise)
3. /pm-complete merges to main

Use /pm to see task statuses.
```

### Step 2: Archive Each Task

For each completed task:
1. Move task directory to `tasks/archive/`
2. Remove from "Active Tasks" table in INDEX.md
3. Add to "Archived Tasks" section in INDEX.md (create section if missing)

### Step 3: Commit Changes

Stage tasks/ and commit: "chore: archive completed tasks"

### Step 4: Output Summary

Show archived tasks table (Task, Title, Completed date), archive location, remaining active tasks, and commit message.

## Archive Structure

```
tasks/
  INDEX.md                    # Active tasks only
  TEMPLATE.md
  {PREFIX}-003-active-task/   # Still active
  archive/
    {PREFIX}-001-completed/   # Archived
    {PREFIX}-002-completed/   # Archived
```

## Notes

- Task IDs are never renumbered after archival
- Archived tasks retain all files (TASK.md, PROGRESS.md, REVIEW.md)
- Archive can be deleted manually if not needed

## Error Handling

- **No completed tasks:** Inform user, no changes made
- **No tasks/ directory:** "Run /pm-init to set up task management"
- **Archive directory missing:** Create automatically

## Related Commands

- `/pm` - See all task statuses
- `/pm-complete <ID>` - Mark task as complete
- `/pm-from-review <ID>` - Create new tasks from review findings
