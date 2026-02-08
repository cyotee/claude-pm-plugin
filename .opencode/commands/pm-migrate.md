---
description: Migrate worktree branch names to include task ID prefix
---

# Migrate Worktree Branch Names

Migrate existing worktrees from the old naming convention (`feature/{kebab-name}`) to the new convention (`feature/{TASK_ID}-{kebab-name}`). This ensures every worktree branch includes its task ID for easy matching.

**Arguments:** $ARGUMENTS

## Instructions

### Step 1: Detect Dry-Run Flag

If `--dry-run` is in arguments, run in preview mode (no changes applied).

### Step 2: Verify Prerequisites

1. Check `tasks/INDEX.md` exists. If not: "Run /pm-init first."
2. Check migration script exists at `${CLAUDE_PLUGIN_ROOT}/scripts/wt-migrate-prefix.sh`.

### Step 3: Run Migration

Execute the migration script with the repo root path (and `--dry-run` flag if applicable).

The script will:
- Scan INDEX.md for tasks with active worktrees
- Skip branches that already have a task ID prefix
- For each branch needing migration:
  - Rename the git branch to include the task ID
  - Move the worktree directory to match the new branch name
  - Update the Worktree column in INDEX.md
- Commit INDEX.md changes (unless `--dry-run`)

### Step 4: Report Results

**If dry-run:** Show what would change, suggest re-running without `--dry-run`.

**If live run:** Show what changed (branches renamed, directories moved, INDEX.md updated), suggest running `git worktree list` to verify, and note that active worktree sessions will need restarting.

## Arguments Reference

| Argument | Description |
|----------|-------------|
| `--dry-run` | Preview changes without applying |

## Error Handling

- **No INDEX.md:** "Run /pm-init first"
- **No active worktrees:** "No worktrees to migrate" (not an error)
- **Branch already has task ID:** Skipped automatically
- **Branch rename fails:** Reported per-worktree, others continue

## Related Commands

- `/pm-launch <ID>` - Creates worktrees with new naming convention
- `/pm-complete <ID>` - Completes and removes worktrees
- `/pm` - View task status
