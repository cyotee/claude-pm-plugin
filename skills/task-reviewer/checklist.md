# Task Review Checklist

Detailed quality checklist for reviewing task definitions.

## Structure Checklist

For each TASK.md, verify:

- [ ] `# Task {PREFIX}-{NNN}: {Title}` header exists and matches directory
- [ ] `## Description` section explains what and why
- [ ] `## Dependencies` section exists (even if "None")
- [ ] `## User Stories` section has at least one story
- [ ] `## Files to Create/Modify` section lists specific paths
- [ ] `## Inventory Check` section has verifiable prerequisites
- [ ] `## Completion Criteria` section defines "done"

## User Story Quality

Each user story should:

### Format
- Follow: "As a [role], I want [feature] so that [benefit]"
- Have clear role identification
- State the desired outcome
- Explain the value/benefit

### Acceptance Criteria
- [ ] Specific (not vague like "works correctly")
- [ ] Testable (can verify pass/fail objectively)
- [ ] Complete (cover happy path AND error cases)
- [ ] Independent (can be tested in isolation)

### Anti-patterns to Flag
- "Works as expected" - What is expected?
- "Handles errors properly" - Which errors? How?
- "Is performant" - What metrics? What thresholds?
- "Is user-friendly" - What specific behaviors?

## INDEX.md Validation

Compare tasks/INDEX.md against filesystem:

### Orphan Directories
Task directories that exist but aren't in INDEX.md:
```bash
# Find all task directories
ls -d tasks/*-*/ 2>/dev/null | grep -v archive

# Compare against INDEX.md entries
```

### Missing Directories
INDEX.md entries without corresponding directories.

### Status Accuracy
- Does INDEX.md status match TASK.md status?
- Are "Blocked" tasks actually blocked by incomplete dependencies?
- Are "Ready" tasks actually ready (all deps complete)?

### Dependency Validation
- Do all referenced task IDs exist?
- Are there circular dependencies?
- Are completed dependencies still listed as blockers?

## Files to Create/Modify Section

Verify:
- [ ] Paths are specific (not vague like "relevant files")
- [ ] New files are clearly marked
- [ ] Modified files exist in codebase
- [ ] Test files are included if needed
- [ ] Documentation updates are noted

## Inventory Check Section

Verify prerequisites are:
- [ ] Verifiable (can check with ls, cat, grep)
- [ ] Specific (exact paths or patterns)
- [ ] Complete (all dependencies listed)

## Completion Criteria Section

Verify:
- [ ] Clear definition of "done"
- [ ] Testable conditions
- [ ] Includes testing requirements
- [ ] Includes documentation requirements (if applicable)
