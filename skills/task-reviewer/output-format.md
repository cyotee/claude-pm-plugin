# Task Review Output Format

Use this template when reporting task review findings.

## Report Template

```markdown
## Task Review Report

**Repository:** {Repo Name from design.yaml}
**Tasks Scanned:** {count}
**Issues Found:** {count by severity}

### Summary Table

| Task | Title | Status | Issues |
|------|-------|--------|--------|
| {PREFIX}-001 | {Title} | {Status} | {count or "None"} |
| {PREFIX}-002 | {Title} | {Status} | {count or "None"} |

### Detailed Findings

#### {PREFIX}-{NNN}: {Title}

**Status:** {Current status}
**File:** tasks/{PREFIX}-{NNN}-{kebab-name}/TASK.md

**Critical Issues:**
- {Issue description} - {Impact}

**Warnings:**
- {Issue description} - {Recommendation}

**Suggestions:**
- {Improvement idea}

---

### INDEX.md Validation

**Orphan Directories:**
- {List directories without INDEX.md entries, or "None"}

**Missing Directories:**
- {List INDEX.md entries without directories, or "None"}

**Status Mismatches:**
- {Task}: INDEX.md says "{status1}", TASK.md says "{status2}"

**Invalid Dependencies:**
- {Task}: References non-existent "{dep-id}"

### Overall Assessment

{1-2 sentence summary of task quality}

**Priority Actions:**
1. {Most critical fix needed}
2. {Second priority}
3. {Third priority}
```

## Severity Guidelines

### Critical (Must Fix)
- Missing required sections
- Invalid dependency references
- Orphaned tasks not tracked
- Status preventing work from starting

### Warning (Should Fix)
- Vague acceptance criteria
- Missing error case coverage
- Stale dependencies
- Incomplete file lists

### Suggestion (Nice to Have)
- Better wording
- More detailed examples
- Additional acceptance criteria
- Documentation improvements

## Example Output

```markdown
## Task Review Report

**Repository:** Cyotee Claude Plugins
**Tasks Scanned:** 8
**Issues Found:** 2 Critical, 5 Warnings, 3 Suggestions

### Summary Table

| Task | Title | Status | Issues |
|------|-------|--------|--------|
| MKT-001 | Task Reviewer Agent | Complete | None |
| MKT-002 | Code Reviewer Agent | Ready | 2 Warnings |
| MKT-003 | Dependency Analyzer Agent | Ready | 1 Critical, 1 Warning |

### Detailed Findings

#### MKT-003: Dependency Analyzer Agent

**Status:** Ready
**File:** tasks/MKT-003-dependency-analyzer-agent/TASK.md

**Critical Issues:**
- Missing `## Inventory Check` section - Agent won't verify prerequisites

**Warnings:**
- Acceptance criteria "works correctly" is vague - Specify expected behavior

**Suggestions:**
- Add error handling user story for invalid dependency formats

---

### INDEX.md Validation

**Orphan Directories:** None
**Missing Directories:** None
**Status Mismatches:** None
**Invalid Dependencies:** None

### Overall Assessment

Task quality is generally good. 1 task needs structural fixes before implementation.

**Priority Actions:**
1. Add Inventory Check section to MKT-003
2. Clarify acceptance criteria in MKT-002 and MKT-003
3. Consider adding error handling stories
```
