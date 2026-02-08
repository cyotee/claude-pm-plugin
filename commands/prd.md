---
description: Interactively create the global project PRD.md
allowed-tools: Read, Write, Edit, AskUserQuestion, Glob
---

# Create Project PRD (Product Requirements Document)

Use interactive Q&A to gather project requirements and generate the global PRD.md at the repository root.

## Instructions

### Step 1: Check for Existing PRD

Look for existing PRD.md at the repository root. If it exists, ask user if they want to:
- Update/replace it
- Cancel

### Step 2: Interactive Requirements Gathering

Use AskUserQuestion to gather requirements in rounds. Ask 2-4 questions per round.

**Round 1 - Vision & Purpose:**
- What is the name of this project?
- In one sentence, what does this project do?
- What problem does it solve?
- Who are the target users?

**Round 2 - Scope & Goals:**
- What are the 3-5 key features or capabilities?
- What is explicitly OUT of scope (non-goals)?
- What are the success metrics?
- What is the timeline or milestone structure?

**Round 3 - Technical Context:**
- What are the key technical constraints?
- What external systems/protocols does this integrate with?
- What are the security requirements?
- What chains/networks will this deploy to?

**Round 4 - Development Approach:**
- What is the repository structure (monorepo, multi-layer)?
- What are the key dependencies or frameworks?
- What testing requirements exist?
- What documentation standards apply?

### Step 3: Generate PRD.md

Create PRD.md at the repository root with the gathered information:

```markdown
---
project: [Project Name]
version: 1.0
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
---

# [Project Name] - Product Requirements Document

## Vision

[One paragraph describing what the project is and why it exists]

## Problem Statement

[What problem does this solve? For whom?]

## Target Users

| User Type | Description | Primary Needs |
|-----------|-------------|---------------|
| [User 1] | [Description] | [Needs] |
| [User 2] | [Description] | [Needs] |

## Goals

### Primary Goals

1. [Goal 1]
2. [Goal 2]
3. [Goal 3]

### Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| [Metric 1] | [Target] | [How measured] |

## Non-Goals (Out of Scope)

- [Explicitly not doing X]
- [Explicitly not doing Y]

## Key Features

### Feature 1: [Name]

[Description of feature and its value]

### Feature 2: [Name]

[Description of feature and its value]

## Technical Requirements

### Architecture

[High-level architecture description]

### Integrations

| System | Purpose | Type |
|--------|---------|------|
| [System 1] | [Why] | [Read/Write/Both] |

### Chains & Networks

| Network | Purpose | Priority |
|---------|---------|----------|
| [Network 1] | [Primary/Secondary] | [P0/P1/P2] |

### Security Requirements

- [Security requirement 1]
- [Security requirement 2]

### Constraints

- [Technical constraint 1]
- [Technical constraint 2]

## Development Approach

### Repository Structure

```
[Directory structure]
```

### Layers

| Layer | Location | Purpose |
|-------|----------|---------|
| [Layer 1] | [Path] | [Purpose] |

### Key Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| [Dep 1] | [Version] | [Why] |

### Testing Requirements

- [Testing requirement 1]
- [Testing requirement 2]

### Documentation Standards

- [Documentation standard 1]
- [Documentation standard 2]

## Milestones

| Milestone | Description | Status |
|-----------|-------------|--------|
| M1 | [Description] | 🆕 |
| M2 | [Description] | 🆕 |

## Appendix

### Glossary

| Term | Definition |
|------|------------|
| [Term] | [Definition] |

### References

- [Reference 1]
- [Reference 2]
```

### Step 4: Confirm and Save

Show the user a summary of what was captured and confirm before writing:

```
# PRD Summary

Project: [Name]
Vision: [One sentence]
Key Features: [Count]
Target Networks: [List]

Write PRD.md to repository root? [Confirm/Edit/Cancel]
```

### Step 5: Initialize Task Structure

After creating PRD.md, ask if user wants to initialize the task management structure:

```
PRD.md created successfully.

Would you like to initialize the task management structure?
This will create tasks/INDEX.md and tasks/0/ template.

Run: /pm:init
```
