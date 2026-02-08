---
description: Initialize task management directory structure in a repository
---

# Initialize Task Management Structure

Create the tasks/ directory structure with template files for a new repository.

## Instructions

### Step 1: Detect or Create Configuration

1. Check for existing `design.yaml` in repo root.
2. If not found, ask user for:
   - Repo prefix (2-6 uppercase chars, e.g., CRANE, DAO, IDX)
   - Repo name (human-readable name)
3. Create `design.yaml` with `repo_prefix` and `repo_name` fields.

### Step 2: Create Directory Structure

```
tasks/
  TEMPLATE.md          # Task template
  INDEX.md             # Task index/status overview
  archive/             # Completed tasks moved here
```

### Step 3: Create Template Files

**tasks/TEMPLATE.md:** Standard task template with sections for Description, Dependencies, User Stories (with acceptance criteria), Technical Details, Files to Create/Modify, Inventory Check, Completion Criteria, and promise protocol tags.

**tasks/INDEX.md:** Task registry table with parser format comment header explaining the ID format, valid statuses (Ready, In Progress, In Review, Changes Requested, Complete, Blocked), dependencies format, and worktree format. Include the table header and status legend.

### Step 4: Confirm Creation

Output confirmation showing all created files (design.yaml, tasks/INDEX.md, tasks/TEMPLATE.md, tasks/archive/) and next steps:
1. Run `/pm-prd` to create the project's PRD.md (optional)
2. Run `/pm-design` to create your first task
3. Or run `/pm-digest <file>` to import tasks from an existing design document

## Error Handling

- **tasks/ already exists:** Ask user if they want to reinitialize (will not overwrite existing tasks)
- **design.yaml already exists:** Show current config, ask if user wants to update it
- **Not in a git repo:** Warn but continue

## Related Commands

- `/pm-prd` - Create project PRD
- `/pm-design` - Create a new task
- `/pm-digest <file>` - Import tasks from document
