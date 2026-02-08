---
description: Complete a task - supports worktree and in-session workflows
---

# Complete Task

Finalize a task and mark it as complete. This is a manual operation -- run by the user after implementation and optionally review.

**IMPORTANT:** This command does NOT run automatically. The agent exiting with `<promise>PHASE_DONE</promise>` does NOT trigger this. The user must explicitly run `/pm-complete` when ready.

**Arguments:** $ARGUMENTS

## Mode Detection

Automatically detect workflow mode:

| Condition | Mode |
|-----------|------|
| In worktree, not on main | Worktree Phase 1 |
| On main, task has worktree | Worktree Phase 2 |
| PROMPT.md exists, NOT in worktree | In-Session Mode |

---

## In-Session Mode

For tasks started with `/pm-work`.

1. **Detect task ID** from arguments or PROMPT.md.
2. **Commit changes** (stage all except PROMPT.md).
3. **Handle branch** -- if on feature branch, rebase onto main, fast-forward merge, delete feature branch.
4. **Cleanup** -- remove PROMPT.md and `.claude/backlog-agent.local.md`.
5. **Update INDEX.md** status to "Complete".
6. **Push** if `--push` flag provided.
7. **Output summary** with completion details and next steps.

---

## Worktree Phase 1: Prepare (from task worktree)

Run from the task's worktree branch (NOT main).

1. **Verify** you are NOT on main.
2. **Commit** remaining changes (exclude PROMPT.md).
3. **Rebase** onto local main. If conflicts, show resolution steps and abort.
4. **Mark** task as "Pending Merge" in INDEX.md.
5. **Output instructions** for Phase 2 (switch to main worktree).
6. **Create exit flag** and output promise:
   ```
   <promise>BLOCKED: phase1_complete_switch_to_main_worktree</promise>
   ```

---

## Worktree Phase 2: Finalize (from main worktree)

Run from main branch.

1. **Verify** you are on main.
2. **Find worktree branch** for the task.
3. **Check task status** from worktree branch (not main) -- must be "Pending Merge".
4. **Verify fast-forward** is possible.
5. **Fast-forward merge** the branch into main.
6. **Push** if `--push` flag provided.
7. **Mark** task as "Complete" in INDEX.md.
8. **Cascade dependencies** -- update dependent tasks from "Blocked" to "Ready" if all their deps are now complete.
9. **Archive** task files to `tasks/archive/`.
10. **Remove** worktree and delete branch.
11. **Output summary** with merge details, unblocked tasks, cleanup confirmation, and next steps.

## Arguments Reference

| Argument | Description |
|----------|-------------|
| `<task-id>` | Task ID being completed (e.g., CRANE-003) |
| `--push` | Push main to origin after merge |

## Important Notes

- **Two-phase design:** Phase 1 (worktree) prepares, Phase 2 (main) finalizes
- **PROMPT.md never committed:** Automatically excluded
- **Fast-forward only:** Ensures clean linear history
- **Automatic archival:** Task files moved to tasks/archive/
- **Automatic cleanup:** Worktree and branch removed in Phase 2

## Related Commands

- `/pm-launch <ID>` - Launch agent worktree
- `/pm-review <ID>` - Transition to review mode
- `/pm-prune` - Archive completed tasks
- `/pm` - View all tasks
