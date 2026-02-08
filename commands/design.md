---
description: Interactive design session to create a new task
argument-hint: <feature-description>
allowed-tools: Read, Write, Edit, Grep, Glob, AskUserQuestion, Bash, TodoWrite
---

# Create New Task

You are a systems architect conducting an interactive design session. Your goal is to gather requirements through questions and produce a well-defined task in the tasks/ directory.

**Feature to Design**: $ARGUMENTS

## Process

### Step 1: Load Configuration

Read repo configuration from design.yaml (or .claude/design.local.md for overrides):

```bash
# Get repo root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

# Check for config files
if [ -f "$REPO_ROOT/design.yaml" ]; then
  cat "$REPO_ROOT/design.yaml"
fi
if [ -f "$REPO_ROOT/.claude/design.local.md" ]; then
  cat "$REPO_ROOT/.claude/design.local.md"
fi
```

Extract:
- `repo_prefix` - The prefix for task IDs (e.g., CRANE, DAO, IDX)
- `repo_name` - Human-readable repo name

If no design.yaml exists, inform user to run `/pm:init` first.

### Step 2: Get Next Task Number

Scan existing task directories to find the next available number:

```bash
# List existing task directories and find highest number
ls -d tasks/${PREFIX}-* 2>/dev/null | \
  sed "s/.*${PREFIX}-\([0-9]*\).*/\1/" | \
  sort -n | \
  tail -1

# Next task number = highest + 1 (or 001 if none exist)
```

### Step 3: Research Context

Before asking questions, gather context:

1. Read PRD.md if it exists (project-level requirements)
2. Read CLAUDE.md if it exists (technical conventions)
3. Read tasks/INDEX.md to see existing tasks
4. If the feature involves existing code, explore relevant files
5. Check for dependencies on other tasks

### Step 4: Interactive Requirements Gathering

Use AskUserQuestion to ask 2-4 focused questions at a time.

**Round 1 - Scope & Purpose:**
- What problem does this task solve?
- What are the key user actions or outcomes?
- What existing patterns should this follow?

**Round 2 - Dependencies & Constraints:**
- What other tasks must complete first? (e.g., "CRANE-001")
- What external protocols/systems does this interact with?
- What are the key constraints or limitations?

**Round 3 - Acceptance Criteria:**
- What specific behaviors must be implemented?
- What tests are required?
- What are the edge cases to handle?

**Round 4 - Implementation Details:**
- What files need to be created or modified?
- What key design decisions need to be made?
- Any performance or gas requirements?

Continue until you have enough information for complete user stories.

### Step 5: Generate Task ID and Directory Name

```
Task ID: {PREFIX}-{NNN}
Directory: tasks/{PREFIX}-{NNN}-{kebab-case-title}/
Worktree: feature/{kebab-case-title}
```

Example:
- Task: "Add Uniswap V4 utils library"
- ID: CRANE-003
- Directory: tasks/CRANE-003-uniswap-v4-utils/
- Worktree: feature/uniswap-v4-utils

### Step 6: Create Task Directory

Create the task directory with all files:

```
tasks/{PREFIX}-{NNN}-{kebab-name}/
├── TASK.md       # Requirements and acceptance criteria
├── PROGRESS.md   # Agent progress log
└── REVIEW.md     # Review findings (empty template)
```

### Step 7: Write TASK.md

Use the template from tasks/TEMPLATE.md (if exists), filling in all gathered information:

```markdown
# Task {PREFIX}-{NNN}: {Title}

**Repo:** {REPO_NAME}
**Status:** Ready
**Created:** {TODAY}
**Dependencies:** {List or "None"}
**Worktree:** `feature/{kebab-name}`

---

## Description

{2-3 sentences from discussion}

## Dependencies

{From discussion - list task IDs and titles, or "None"}

## User Stories

### US-{PREFIX}-{NNN}.1: {Story Title}

As a {role}, I want to {action} so that {benefit}.

**Acceptance Criteria:**
- [ ] {Criterion from discussion}
- [ ] {Criterion from discussion}

{Additional user stories...}

## Technical Details

{From discussion - architecture, interfaces, etc.}

## Files to Create/Modify

**New Files:**
- {path} - {description}

**Modified Files:**
- {path} - {what changes}

**Tests:**
- {test path} - {description}

## Inventory Check

Before starting, verify:
- [ ] {Prerequisites to verify}

## Completion Criteria

- [ ] All acceptance criteria met
- [ ] Tests pass
- [ ] Build succeeds
- [ ] Documentation updated (if applicable)

---

**When complete, output:** `<promise>PHASE_DONE</promise>`

**If blocked, output:** `<promise>BLOCKED: [reason]</promise>`
```

### Step 8: Initialize PROGRESS.md

```markdown
# Progress Log: {PREFIX}-{NNN}

## Current Checkpoint

**Last checkpoint:** Not started
**Next step:** Read TASK.md and begin implementation
**Build status:** ⏳ Not checked
**Test status:** ⏳ Not checked

---

## Session Log

### {TODAY} - Task Created

- Task designed via /pm:design
- TASK.md populated with requirements
- Ready for agent assignment via /pm:launch
```

### Step 9: Initialize REVIEW.md

```markdown
# Code Review: {PREFIX}-{NNN}

**Reviewer:** (pending)
**Review Started:** (pending)
**Status:** Pending

---

## Clarifying Questions

(Questions asked during review will be recorded here)

---

## Review Findings

(Findings will be documented here during code review)

---

## Suggestions

(Actionable suggestions for follow-up tasks)

---

## Review Summary

**Findings:** (pending)
**Suggestions:** (pending)
**Recommendation:** (pending)

---

**When review complete, output:** `<promise>PHASE_DONE</promise>`
```

### Step 10: Update INDEX.md

Add the new task to tasks/INDEX.md.

**IMPORTANT: INDEX.md Format Requirements**

The INDEX.md file must follow a strict format for the task parser to work correctly:

```markdown
<!-- TASK INDEX - Do not modify this header structure -->
<!-- Format: | ID | Title | Status | Dependencies | Worktree | -->
<!-- Valid statuses: Ready, In Progress, In Review, Complete, Blocked, Changes Requested -->
<!-- Task IDs must match pattern: PREFIX-NNN (e.g., MKT-001, CRANE-042) -->

| ID | Title | Status | Dependencies | Worktree |
|----|-------|--------|--------------|----------|
| {PREFIX}-001 | Existing task | Complete | - | - |
| {PREFIX}-{NNN} | {New Task Title} | Ready | {Dependencies or "-"} | - |
```

**Format rules:**
1. **Header row required:** `| ID | Title | Status | Dependencies | Worktree |`
2. **Task ID pattern:** Must match `PREFIX-NNN` (uppercase letters, hyphen, numbers)
3. **Valid statuses:** `Ready`, `In Progress`, `In Review`, `Complete`, `Blocked`, `Changes Requested`
4. **Dependencies:** Comma-separated task IDs, or `-` for none
5. **Worktree:** Branch name or `-` if not assigned

**Add the new row:**
```markdown
| {PREFIX}-{NNN} | {Title} | Ready | {Dependencies or "-"} | - |
```

**After editing INDEX.md**, the pm plugin's PostToolUse hook will automatically validate the format and warn you if there are any issues.

### Step 11: Validate and Check Dependencies

**Build dependency graph and validate:**

```bash
source "${CLAUDE_PLUGIN_ROOT}/scripts/deps.sh"
deps_build_graph 2>/dev/null
```

**For each listed dependency:**

1. **Validate existence:**
   ```bash
   if ! deps_validate "${DEP_ID}"; then
     echo "WARNING: Dependency ${DEP_ID} not found in task index"
     # Ask user: Create anyway? Skip this dep? Abort?
   fi
   ```

2. **Check for circular dependencies:**
   - Temporarily add new task to graph
   - Run cycle detection
   ```bash
   # Simulate adding this task
   DEPS_GRAPH["${NEW_TASK_ID}"]="${DEPENDENCY_LIST}"
   DEPS_ALL_TASKS+=("${NEW_TASK_ID}")

   if ! deps_check_cycles; then
     echo "ERROR: Adding this task would create a circular dependency!"
     echo "Please remove or change the problematic dependency."
     # Show the cycle path
     # Abort task creation
   fi
   ```

3. **Determine initial status:**
   ```bash
   # Check if all dependencies are complete
   all_complete=true
   for dep in ${DEPENDENCY_LIST}; do
     dep_status="${DEPS_STATUS[$dep]:-}"
     if [[ "$dep_status" != "Complete" ]]; then
       all_complete=false
       break
     fi
   done

   if [[ "$all_complete" == "true" ]]; then
     initial_status="Ready"
   else
     initial_status="Blocked"
   fi
   ```

**Dependency validation output:**

```
## Dependency Validation

| Dependency | Status | Valid |
|------------|--------|-------|
| CRANE-001 | Complete | ✓ |
| CRANE-002 | In Progress | ✓ |
| CRANE-999 | Not Found | ✗ |

{If invalid dependencies}
WARNING: The following dependencies were not found:
- CRANE-999

Options:
1. Continue anyway (task will be blocked on non-existent dep)
2. Remove invalid dependencies
3. Abort task creation

{If circular dependency detected}
ERROR: Circular dependency detected!

Adding this task would create a cycle:
  CRANE-003 -> CRANE-001 -> CRANE-002 -> CRANE-003

Please modify the dependencies to break the cycle.

{If all valid}
All dependencies validated.
Initial status: {Ready | Blocked}

{If Blocked, show what's blocking}
Task will be Blocked until:
- CRANE-002 is Complete (currently In Progress)
```

### Step 12: Output Summary

```
═══════════════════════════════════════════════════════════════════
 TASK CREATED: {PREFIX}-{NNN}
═══════════════════════════════════════════════════════════════════

Title: {Title}
Repo: {REPO_NAME}
Status: {Ready | Blocked}
Dependencies: {List or "None"}

## Files Created

- tasks/{PREFIX}-{NNN}-{kebab-name}/TASK.md
- tasks/{PREFIX}-{NNN}-{kebab-name}/PROGRESS.md
- tasks/{PREFIX}-{NNN}-{kebab-name}/REVIEW.md
- Updated tasks/INDEX.md

## Launch Agent

To start working on this task:

/pm:launch {PREFIX}-{NNN}

Or manually:

1. Create worktree:
   git worktree add -b feature/{kebab-name} ../repo-wt/feature/{kebab-name}

2. Launch Claude in worktree:
   cd ../repo-wt/feature/{kebab-name}
   claude --dangerously-skip-permissions

3. Start task:
   /up:prompt

═══════════════════════════════════════════════════════════════════
```

## Error Handling

- **No tasks/ directory:** Inform user to run `/pm:init` first
- **No design.yaml:** Inform user to run `/pm:init` first
- **Dependency task doesn't exist:** Warn user, offer options (continue/remove dep/abort)
- **Dependency task is blocked/not complete:** Auto-mark this task as "Blocked"
- **Circular dependency detected:** Show cycle path and abort (cannot create task)
- **Task number collision:** Auto-increment to next available number
- **Cross-repo dependency not found:** Warn but allow (may be in unscanned submodule)
