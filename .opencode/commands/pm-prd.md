---
description: Interactively create the global project PRD.md
---

# Create Project PRD (Product Requirements Document)

Use interactive Q&A to gather project requirements and generate the global PRD.md at the repository root.

## Instructions

### Step 1: Check for Existing PRD

Look for existing PRD.md at the repository root. If it exists, ask user if they want to update/replace it or cancel.

### Step 2: Interactive Requirements Gathering

Ask 2-4 questions per round:

- **Round 1 - Vision & Purpose:** Project name? What does it do? Problem solved? Target users?
- **Round 2 - Scope & Goals:** Key features (3-5)? Non-goals? Success metrics? Timeline/milestones?
- **Round 3 - Technical Context:** Technical constraints? External integrations? Security requirements? Target chains/networks?
- **Round 4 - Development Approach:** Repository structure? Key dependencies/frameworks? Testing requirements? Documentation standards?

### Step 3: Generate PRD.md

Create PRD.md at the repository root with YAML frontmatter (project, version, dates) and sections for: Vision, Problem Statement, Target Users, Goals, Non-Goals, Key Features, Technical Requirements (architecture, integrations, security, constraints), Development Approach (repo structure, dependencies, testing, docs), Milestones, and Appendix (glossary, references).

### Step 4: Confirm and Save

Show a summary of what was captured. Confirm before writing.

### Step 5: Suggest Next Steps

After creating PRD.md, suggest running `/pm-init` to initialize the task management structure.

## Related Commands

- `/pm-init` - Initialize task management structure
- `/pm-design` - Create a new task
- `/pm-digest <file>` - Import tasks from document
