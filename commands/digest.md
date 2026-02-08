---
description: Digest an existing design document into individual tasks
argument-hint: <file-path>
allowed-tools: Read, Write, Edit, Grep, Glob, AskUserQuestion, Bash, TaskCreate, TaskUpdate, TaskList
---

# Digest Design Document

Parse an existing design document (UNIFIED_PLAN.md, PRD.md, or any markdown file) into individual tasks in the tasks/ directory structure.

**Document to digest:** $ARGUMENTS

## Process

### Step 0: Register Operation with Built-in Task Feature

**IMPORTANT:** Use the built-in Task feature to track this multi-step digest operation.

Call `TaskCreate` with:
- **subject**: `Digest: {filename}`
- **description**: `Digesting design document {filename} into individual tasks`
- **activeForm**: `Digesting {filename}`

Then call `TaskUpdate` to set status to `in_progress`:
- **taskId**: The ID returned from TaskCreate
- **status**: `in_progress`

Store this task ID for later completion.

### Step 1: Validate Prerequisites

1. **Check for design.yaml** - Required for repo prefix:
   ```bash
   if [ ! -f "design.yaml" ]; then
     echo "No design.yaml found - run /pm:init first"
   fi
   ```

2. **Check for tasks/ directory:**
   ```bash
   if [ ! -d "tasks" ]; then
     echo "No tasks/ directory found - run /pm:init first"
   fi
   ```

3. **Check file exists:**
   - If $ARGUMENTS is empty, inform user: "Usage: /pm:digest <file-path>"
   - If file doesn't exist, inform user and stop

### Step 2: Load Configuration

Read repo configuration:

```bash
# Get repo prefix and name from design.yaml
cat design.yaml
```

Extract:
- `repo_prefix` - The prefix for task IDs (e.g., CRANE, DAO, IDX)
- `repo_name` - Human-readable repo name
- `submodules` - List of submodule configs (if this is a root repo)

### Step 3: Read Document

Read the specified document and analyze its structure:

1. Identify sections that could be individual tasks
2. Look for existing task definitions (numbered sections, user stories)
3. Find dependencies between sections
4. Note any cross-repo references (if submodules are defined)

### Step 4: Analyze and Identify Tasks

For each potential task identified, extract:
- Title/summary
- Description
- Dependencies (within document and cross-repo)
- User stories or acceptance criteria
- Files to create/modify

### Step 5: Interactive Clarification

For each identified task, ask clarifying questions using AskUserQuestion:

**Question types:**

1. **Repo assignment** (if submodules defined):
   ```
   Task: "Implement fee collection system"

   This task appears to involve:
   - Core fee utilities (would go in CRANE)
   - Fee collector contract (would go in IDX)

   Should I:
   a) Split into two tasks in different repos
   b) Keep as one task in IDX (with CRANE dependency)
   c) Keep as one task in CRANE
   d) Skip this task
   ```

2. **Missing information:**
   ```
   Task: "Add configurable fees"

   The description mentions "configurable fees" but doesn't specify:
   - What fee types are supported?
   - Who can configure fees?
   - What are the fee limits?

   Please clarify or skip this task.
   ```

3. **Dependency validation:**
   ```
   Task: "Protocol DETF"

   This task references:
   - "Fee Collector" - Found as existing task CRANE-001 (Complete)
   - "Vault Registry" - Not found as existing task

   Should I:
   a) Create "Vault Registry" as a new task first
   b) Add dependency on non-existent task (will be blocked)
   c) Remove this dependency
   ```

4. **Acceptance criteria:**
   ```
   Task: "User Portfolio View"

   No acceptance criteria found in document. Please provide:
   - What should the user be able to see?
   - What actions should be available?
   - What data sources are needed?
   ```

### Step 6: Get Next Task Numbers

For each repo that will receive tasks:

```bash
# Get current highest task number for each prefix
for PREFIX in CRANE DAO IDX; do
  ls -d tasks/${PREFIX}-* 2>/dev/null | \
    sed "s/.*${PREFIX}-\([0-9]*\).*/\1/" | \
    sort -n | tail -1
done
```

### Step 7: Create Task Directories

For each confirmed task, create the full task structure:

```
tasks/{PREFIX}-{NNN}-{kebab-name}/
├── TASK.md
├── PROGRESS.md
└── REVIEW.md
```

If task belongs to a submodule, create in that submodule's tasks/ directory.

### Step 8: Update INDEX.md Files

Update tasks/INDEX.md in each affected repo with new task rows.

### Step 9: Mark Built-in Task Completed

Call `TaskUpdate` with the task ID from Step 0:
- **taskId**: The ID from the TaskCreate call
- **status**: `completed`

### Step 10: Output Summary

```
═══════════════════════════════════════════════════════════════════
 DIGEST COMPLETE: {filename}
═══════════════════════════════════════════════════════════════════

Analyzed: {filename}
Tasks identified: {N}
Tasks created: {M}
Tasks skipped: {K}

## Tasks Created

In {repo_name} (tasks/):
- {PREFIX}-{NNN}: {Title}
- {PREFIX}-{NNN}: {Title}

In {submodule_name} ({submodule_path}/tasks/):
- {SUB_PREFIX}-{NNN}: {Title}

## Dependencies Mapped

- {PREFIX}-{NNN} depends on {PREFIX}-{NNN}
- {PREFIX}-{NNN} depends on {SUB_PREFIX}-{NNN} (cross-repo)

## Blocked Tasks

Tasks that cannot start yet:
- {PREFIX}-{NNN}: Waiting on {PREFIX}-{NNN}

## Next Steps

1. Review created tasks for completeness
2. Use /pm:design-review to check task quality
3. Use /pm:launch to start work on Ready tasks

## Source Document

Consider archiving the source document now that tasks are extracted:
  mv {filename} docs/archive/

═══════════════════════════════════════════════════════════════════
```

## Example Usage

```bash
# Digest a unified plan document
/pm:digest UNIFIED_PLAN.md

# Digest a PRD
/pm:digest PRD.md

# Digest a feature spec
/pm:digest docs/feature-spec.md
```

## Example Output

```
Digested 5 tasks from UNIFIED_PLAN.md:

In Crane Framework (lib/daosys/lib/crane/tasks/):
- CRANE-004: Fee Utils Library
- CRANE-005: Oracle Integration Utils

In IndexedEx (tasks/):
- IDX-003: Fee Collector Contract
- IDX-004: Admin Dashboard
- IDX-005: User Portfolio View

Dependencies:
- IDX-003 depends on CRANE-004
- IDX-004 depends on IDX-003
- IDX-005 depends on IDX-003

Updated INDEX.md in 2 repos.
```

## Error Handling

- **File not found:** "File not found: {path}. Check the path and try again."
- **No tasks/ directory:** "Run /pm:init first to set up the tasks directory."
- **No design.yaml:** "Run /pm:init first to configure the repository."
- **Empty document:** "Document appears to be empty or contains no identifiable tasks."
- **Parse error:** "Could not parse document structure. Consider using /pm:design manually to create tasks."
