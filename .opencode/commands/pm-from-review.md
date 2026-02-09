---
description: Create new tasks from code review suggestions
---

# Create Tasks from Review Suggestions

Parse a task's REVIEW.md file and create new tasks from accepted suggestions. This closes the review loop by turning actionable feedback into tracked work items.

**Task to process:** $ARGUMENTS

## Process

### Step 0: Register Operation with Built-in Task Feature

**IMPORTANT:** Use the built-in Task feature to track this multi-step operation.

Call `TaskCreate` with:
- **subject**: `From Review: {TASK_ID}`
- **description**: `Creating new tasks from code review suggestions in {TASK_ID}`
- **activeForm**: `Processing review suggestions`

Then call `TaskUpdate` to set status to `in_progress`:
- **taskId**: The ID returned from TaskCreate
- **status**: `in_progress`

Store this task ID for later completion.

### Step 1: Validate Input

1. **Check argument provided:**
   - If $ARGUMENTS is empty: "Usage: /pm-from-review <task-id>"

2. **Find task directory:**
   ```bash
   # Find task directory matching the ID
   ls -d tasks/${TASK_ID}-* 2>/dev/null
   ```
   - If not found: "Task {TASK_ID} not found in tasks/"

3. **Check for REVIEW.md:**
   - If not found: "No REVIEW.md found for task {TASK_ID}. Run code review first."

### Step 2: Load Configuration

```bash
cat design.yaml
```

Extract:
- `repo_prefix` - The prefix for new task IDs
- `repo_name` - Human-readable repo name

### Step 3: Parse REVIEW.md

Read the REVIEW.md file and extract:

1. **Suggestions section** - Look for suggestions with user responses:
   ```markdown
   ### Suggestion N: {Title}
   **Priority:** {High|Medium|Low}
   **Description:** {description}
   **Affected Files:**
   - {file list}
   **User Response:** {Accepted|Rejected|Modified}
   **Notes:** {optional notes}
   ```

2. **For each suggestion**, categorize:
   - **Accepted** - Will create a new task
   - **Modified** - Will create a new task with user's modifications
   - **Rejected** - Skip (note in output)

### Step 4: Interactive Confirmation

For each accepted/modified suggestion, use AskUserQuestion to confirm:

```
Found suggestion to create as task:

Title: Add Input Validation
Priority: High
Description: Add require statements for zero-value checks in all calculation functions
Affected Files:
- src/utils/UniswapV4Utils.sol

Create this as a new task?
a) Yes, create task
b) Yes, but modify description first
c) Skip this suggestion
```

### Step 5: Get Next Task Number

```bash
# Get current highest task number
ls -d tasks/${PREFIX}-* 2>/dev/null | \
  sed "s/.*${PREFIX}-\([0-9]*\).*/\1/" | \
  sort -n | tail -1
```

### Step 6: Create New Tasks

For each confirmed suggestion:

1. **Generate task ID and directory:**
   - ID: {PREFIX}-{NNN}
   - Directory: tasks/{PREFIX}-{NNN}-{kebab-name}/

2. **Create TASK.md:**
   ```markdown
   # Task {PREFIX}-{NNN}: {Suggestion Title}

   **Repo:** {REPO_NAME}
   **Status:** Ready
   **Created:** {TODAY}
   **Dependencies:** {ORIGINAL_TASK_ID}
   **Worktree:** `feature/{kebab-name}`
   **Origin:** Code review suggestion from {ORIGINAL_TASK_ID}

   ---

   ## Description

   {Suggestion description}

   (Created from code review of {ORIGINAL_TASK_ID})

   ## Dependencies

   - {ORIGINAL_TASK_ID}: {Original task title} (parent task)

   ## User Stories

   ### US-{PREFIX}-{NNN}.1: {From suggestion}

   As a developer, I want to {suggestion action} so that {benefit}.

   **Acceptance Criteria:**
   - [ ] {Criteria from suggestion}
   - [ ] Tests pass
   - [ ] Build succeeds

   ## Files to Create/Modify

   **Modified Files:**
   {Files from suggestion}

   ## Inventory Check

   Before starting, verify:
   - [ ] {ORIGINAL_TASK_ID} is complete or in progress
   - [ ] Affected files exist

   ## Completion Criteria

   - [ ] All acceptance criteria met
   - [ ] Tests pass
   - [ ] Build succeeds

   ---

   **When complete, output:** `<promise>PHASE_DONE</promise>`

   **If blocked, output:** `<promise>BLOCKED: [reason]</promise>`
   ```

3. **Create PROGRESS.md:**
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

   - Task created from code review suggestion
   - Origin: {ORIGINAL_TASK_ID} REVIEW.md
   - Ready for agent assignment via /pm-launch
   ```

4. **Create empty REVIEW.md template**

### Step 7: Update INDEX.md

Add each new task to tasks/INDEX.md:

```markdown
| {PREFIX}-{NNN} | {Title} | Ready | {ORIGINAL_TASK_ID} | - |
```

### Step 8: Update Original REVIEW.md

Mark suggestions as "Converted to task":

```markdown
### Suggestion N: {Title}
**Priority:** {Priority}
**Description:** {description}
**User Response:** Accepted
**Notes:** Converted to task {PREFIX}-{NNN}
```

### Step 9: Mark Built-in Task Completed

Call `TaskUpdate` with the task ID from Step 0:
- **taskId**: The ID from the TaskCreate call
- **status**: `completed`

### Step 10: Output Summary

```
═══════════════════════════════════════════════════════════════════
 TASKS CREATED FROM REVIEW: {ORIGINAL_TASK_ID}
═══════════════════════════════════════════════════════════════════

Source: tasks/{ORIGINAL_TASK_ID}-{name}/REVIEW.md

## Tasks Created

| New Task | Title | Priority | From |
|----------|-------|----------|------|
| {PREFIX}-{NNN} | Add Input Validation | High | Suggestion 1 |
| {PREFIX}-{NNN} | Expand Test Coverage | Medium | Suggestion 2 |

Total: {N} tasks created

## Skipped Suggestions

| Suggestion | Reason |
|------------|--------|
| Suggestion 3 | Rejected by user |

## Updated Files

- tasks/{ORIGINAL_TASK_ID}-{name}/REVIEW.md (marked suggestions as converted)
- tasks/INDEX.md (added {N} new entries)

## Next Steps

1. Review created tasks: /pm-design-review {PREFIX}-{NNN}
2. Launch agent for task: /pm-launch {PREFIX}-{NNN}

═══════════════════════════════════════════════════════════════════
```

## Example Usage

```bash
# Create tasks from CRANE-003's review suggestions
/pm-from-review CRANE-003
```

## Example Output

```
Created 2 tasks from CRANE-003 review suggestions:

- CRANE-004: Add Input Validation
  From: Suggestion 1 (Priority: High)

- CRANE-005: Expand Test Coverage
  From: Suggestion 2 (Priority: Medium)

Skipped 0 suggestions (rejected by user)
```

## Error Handling

- **No task ID provided:** "Usage: /pm-from-review <task-id>"
- **Task not found:** "Task {TASK_ID} not found in tasks/"
- **No REVIEW.md:** "No REVIEW.md found for task {TASK_ID}"
- **No suggestions:** "No suggestions found in REVIEW.md"
- **No accepted suggestions:** "No accepted suggestions found. Mark suggestions as 'Accepted' or 'Modified' first."
