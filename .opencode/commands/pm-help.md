---
description: Show all available PM commands, flags, agents, and skills
---

# PM Plugin Help

Display a static reference of all available commands, agents, and skills in the PM plugin.

## Instructions

Output the following reference guide exactly as shown:

```
═══════════════════════════════════════════════════════════════════
 PM - Unified Project Management Plugin v1.0.0
═══════════════════════════════════════════════════════════════════

## Overview Commands

  /pm                          Task status dashboard with dependency graph
    --graph                    ASCII dependency visualization
    --critical-path            Longest dependency chain
    --order                    Topological sort / recommended order

  /pm-list                     Simple task inventory table
    --worktrees-only           Show only active worktrees

  /pm-read <task-id>           View full task details (TASK.md + PROGRESS.md + REVIEW.md)

  /pm-help                     This help reference

## Planning Commands

  /pm-init                     Initialize tasks/ directory and design.yaml in a repo
  /pm-prd                      Interactively create project-level PRD.md
  /pm-design <feature>         Interactive 4-round Q&A to create a new task
  /pm-digest <file>            Parse existing document into individual tasks

## Execution Commands

  /pm-launch <task-id>         Create isolated git worktree + PROMPT.md for agent
    --max-iterations N         Set stop hook safety cap (default: 10)
    --force                    Launch even if dependencies incomplete

  /pm-work <task-id>           Start working on task in current session (no worktree)

## Review Commands

  /pm-review <task-id>         Transition task to code review mode
  /pm-design-review [task-id]  Audit task definitions for quality (not code review)
  /pm-from-review <task-id>    Create follow-up tasks from review suggestions

## Completion & Maintenance Commands

  /pm-complete <task-id>       Finalize task (merge worktree, archive, update deps)
    --push                     Push to remote after completion

  /pm-prune                    Archive all completed tasks to tasks/archive/
  /pm-stop [reason]            Emergency exit from stop hook loop
  /pm-migrate                  Rename worktree branches to include task ID prefix
    --dry-run                  Preview changes without applying

## Agents

  pm:task-auditor              Comprehensive audit of ALL tasks (runs in isolated context)
  pm:dependency-analyzer       Dependency graph analysis across repos and submodules
  pm:code-auditor              Full automated code review populating REVIEW.md
  pm:code-reviewer             Code review for individual task implementations

## Skills

  pm:task-reviewer             Quick inline review for specific tasks
  pm:code-reviewer             Quick inline code quality feedback

## Task Lifecycle

  1. /pm-init          → Set up task management in repo
  2. /pm-prd           → Document project requirements (optional)
  3. /pm-design        → Create task with user stories
  4. /pm-launch        → Create worktree and start agent
     or /pm-work       → Work in current session
  5. /pm-review        → Transition to code review
  6. /pm-complete      → Merge, archive, unblock dependents
  7. /pm-prune         → Clean up completed tasks

## Promise Protocol

  Agents signal completion with promise tags:
  <promise>PHASE_DONE</promise>       Agent finished assigned work
  <promise>BLOCKED: reason</promise>  Agent cannot proceed

## File Format

  design.yaml                  Repo configuration (prefix, name)
  tasks/INDEX.md               Task registry table
  tasks/{ID}-{name}/TASK.md    Requirements and acceptance criteria
  tasks/{ID}-{name}/PROGRESS.md Progress log with checkpoints
  tasks/{ID}-{name}/REVIEW.md  Code review findings
  .claude/backlog-agent.local.md  Agent state (iteration count)
  .claude/backlog-exit         Exit flag for stop hook

═══════════════════════════════════════════════════════════════════
```
