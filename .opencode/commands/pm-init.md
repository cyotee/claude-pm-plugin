---
description: Initialize task management directory structure in a repository
---

# Initialize Task Management Structure

Create the tasks/ directory structure with template files for a new repository.

## Instructions

### Step 1: Detect or Create Configuration

1. **Check for existing configuration:**
   ```bash
   # Check for design.yaml in repo root
   if [ -f "design.yaml" ]; then
     echo "Found design.yaml"
     cat design.yaml
   fi

   # Check for local overrides
   if [ -f ".claude/design.local.md" ]; then
     echo "Found local overrides"
   fi
   ```

2. **If no design.yaml exists**, ask user for configuration:
   - Use AskUserQuestion to get:
     - Repo prefix (2-6 uppercase chars, e.g., CRANE, DAO, IDX)
     - Repo name (human-readable name for the repo)

3. **Create design.yaml** in repo root:
   ```yaml
   # design.yaml - Task management configuration
   # This file is shared with the team (checked into git)

   repo_prefix: <PREFIX>
   repo_name: <REPO_NAME>

   # Optional: define submodules for root repos
   # submodules:
   #   - prefix: DAO
   #     path: lib/daosys
   #     name: DAOsys
   ```

4. **Note about local overrides** (optional, user can create later):
   - `.claude/design.local.md` - gitignored, per-developer overrides
   - Can override any setting from design.yaml

### Step 2: Create Directory Structure

Create the following structure:

```
tasks/
├── TEMPLATE.md          # Task template
├── INDEX.md             # Task index/status overview
└── archive/             # Completed tasks moved here
```

### Step 3: Create Template Files

**tasks/TEMPLATE.md:**

```markdown
# Task {PREFIX}-{NNN}: {Title}

**Repo:** {REPO_NAME}
**Status:** Ready
**Created:** {DATE}
**Dependencies:** None
**Worktree:** `feature/{kebab-name}`

---

## Description

[2-3 sentences explaining the feature and its purpose]

## Dependencies

- [List prerequisite tasks: e.g., "{PREFIX}-001: Task Name"]
- Or "None" if no dependencies

## User Stories

### US-{PREFIX}-{NNN}.1: [Story Title]

As a [role], I want to [action] so that [benefit].

**Acceptance Criteria:**
- [ ] [Specific, testable criterion]
- [ ] [Specific, testable criterion]

### US-{PREFIX}-{NNN}.2: [Story Title]

...

## Technical Details

[Architecture diagrams, interface definitions, implementation notes]

## Files to Create/Modify

**New Files:**
- `path/to/NewFile.sol` - Description

**Modified Files:**
- `path/to/ExistingFile.sol` - What changes

**Tests:**
- `test/path/TestFile.t.sol` - Description

## Inventory Check

Before starting, verify:
- [ ] [Prerequisite exists/works]
- [ ] [Dependency is accessible]

## Completion Criteria

- [ ] All acceptance criteria met
- [ ] Tests pass
- [ ] Build succeeds
- [ ] No new compiler warnings

---

**When complete, output:** `<promise>PHASE_DONE</promise>`

**If blocked, output:** `<promise>BLOCKED: [reason]</promise>`
```

**tasks/INDEX.md:**

```markdown
# Task Index: {REPO_NAME}

**Repo:** {PREFIX}
**Last Updated:** {DATE}

<!-- TASK INDEX - Parser Format Specification
     =========================================
     This table is parsed by the pm plugin's task management scripts.
     Follow these rules to ensure compatibility:

     REQUIRED HEADER (do not modify):
     | ID | Title | Status | Dependencies | Worktree |

     TASK ID FORMAT:
     - Pattern: PREFIX-NNN (e.g., MKT-001, CRANE-042)
     - PREFIX: 2-6 uppercase letters
     - NNN: 3+ digit number

     VALID STATUS VALUES:
     - Ready           : All dependencies met, can start
     - In Progress     : Agent actively working
     - In Review       : Implementation complete, code review pending
     - Changes Requested: Review feedback to address
     - Complete        : Done, ready to archive
     - Blocked         : Waiting on dependencies

     DEPENDENCIES:
     - Use "-" for no dependencies
     - Comma-separated task IDs for multiple (e.g., "MKT-001, MKT-002")

     WORKTREE:
     - Use "-" if no worktree assigned
     - Use branch name if assigned (e.g., "feature/my-task")

     VALIDATION:
     Run: /pm-list --json to validate parsing
     Run: scripts/validate-index.sh to check format
-->

## Active Tasks

| ID | Title | Status | Dependencies | Worktree |
|----|-------|--------|--------------|----------|

## Status Legend

- **Ready** - All dependencies met, can be launched with `/pm-launch`
- **In Progress** - Implementation agent working (has worktree)
- **In Review** - Implementation complete, awaiting code review
- **Changes Requested** - Review found issues, needs fixes
- **Complete** - Review passed, ready to archive with `/pm-prune`
- **Blocked** - Waiting on dependencies
```

### Step 4: Confirm Creation

After creating all files, output:

```
✅ Task management structure initialized

Created:
- design.yaml (repo configuration)
- tasks/INDEX.md (task index)
- tasks/TEMPLATE.md (task template)
- tasks/archive/ (archive directory)

Configuration:
- Repo Prefix: {PREFIX}
- Repo Name: {REPO_NAME}

Next steps:
1. Run /pm-prd to create the project's PRD.md (optional)
2. Run /pm-design to create your first task
3. Or run /pm-digest <file> to import tasks from an existing design document
```

## Error Handling

- **tasks/ already exists:** Ask user if they want to reinitialize (will not overwrite existing tasks)
- **design.yaml already exists:** Show current config, ask if user wants to update it
- **Not in a git repo:** Warn but continue (some features may not work)
