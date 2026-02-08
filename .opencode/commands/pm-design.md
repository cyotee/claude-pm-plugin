---
description: Interactive design session to create a new task with user stories and acceptance criteria
---

# Create New Task

You are a systems architect conducting an interactive design session. Your goal is to gather requirements through questions and produce a well-defined task in the tasks/ directory.

**Feature to Design:** $ARGUMENTS

## Instructions

### Step 1: Load Configuration

Read `design.yaml` (and `.claude/design.local.md` for overrides) to extract `repo_prefix` and `repo_name`. If no design.yaml exists, inform user to run `/pm-init` first.

### Step 2: Get Next Task Number

Scan existing task directories to find the highest number, then increment. Start at 001 if none exist.

### Step 3: Research Context

Before asking questions, gather context:
1. Read PRD.md if it exists
2. Read CLAUDE.md if it exists
3. Read tasks/INDEX.md to see existing tasks
4. Explore relevant code if the feature involves existing files
5. Check for dependencies on other tasks

### Step 4: Interactive Requirements Gathering

Ask 2-4 focused questions per round:

- **Round 1 - Scope & Purpose:** What problem? Key outcomes? Existing patterns?
- **Round 2 - Dependencies & Constraints:** Task dependencies? External systems? Limitations?
- **Round 3 - Acceptance Criteria:** Required behaviors? Tests? Edge cases?
- **Round 4 - Implementation Details:** Files to create/modify? Design decisions? Performance requirements?

Continue until you have enough for complete user stories.

### Step 5: Generate Task ID and Directory

```
Task ID: {PREFIX}-{NNN}
Directory: tasks/{PREFIX}-{NNN}-{kebab-case-title}/
Worktree: feature/{PREFIX}-{NNN}-{kebab-case-title}
```

### Step 6: Create Task Files

Create the task directory with:
- `TASK.md` - Requirements, user stories, acceptance criteria, files to modify, completion criteria
- `PROGRESS.md` - Agent progress log (initialized as "Not started")
- `REVIEW.md` - Review findings template (empty)

### Step 7: Update INDEX.md

Add the new task row to `tasks/INDEX.md`:
```
| {PREFIX}-{NNN} | {Title} | Ready | {Dependencies or "-"} | - |
```

**INDEX.md format rules:**
- Header: `| ID | Title | Status | Dependencies | Worktree |`
- Task ID pattern: `PREFIX-NNN`
- Valid statuses: Ready, In Progress, In Review, Complete, Blocked, Changes Requested
- Dependencies: comma-separated task IDs, or `-` for none

### Step 8: Validate Dependencies

For each listed dependency:
1. Validate it exists in the task index
2. Check for circular dependencies
3. Determine initial status (Ready if all deps complete, Blocked otherwise)

### Step 9: Output Summary

Show task created confirmation with: Title, Status, Dependencies, Files created, and launch command (`/pm-launch {PREFIX}-{NNN}`).

## Error Handling

- **No tasks/ directory:** Inform user to run `/pm-init` first
- **Circular dependency detected:** Show cycle path and abort
- **Task number collision:** Auto-increment to next available

## Related Commands

- `/pm-launch <ID>` - Launch agent worktree
- `/pm-design-review` - Review task definitions
- `/pm` - View all tasks
