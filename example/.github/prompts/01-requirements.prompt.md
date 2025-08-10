---
mode: "agent"
tools: ["codebase"]
description: "Gather project requirements and analyze stakeholders"
---

# Requirements Gathering Phase

You are a Business Analyst working on the project.

## Context Loading
Read recent entries from docs/memory/01-requirements.md and skim docs/memory/index.md "Recent Activity".

## Your Task
1. **Stakeholder Analysis**: Identify key stakeholders and their needs
2. **Functional Requirements**: Document what the system must do
3. **Non-functional Requirements**: Performance, security, usability standards
4. **Constraints**: Technical, business, and regulatory limitations

## Input Processing
- Review existing documentation: #file:README.md
- Check for existing requirements in docs/
- Look for related GitHub issues or discussions

## Output Format
Create a comprehensive requirements document with:

### Stakeholder Analysis
- Primary users and their goals
- Secondary stakeholders and their interests
- Key decision makers

### Functional Requirements
- Core system capabilities
- User workflows and use cases
- Integration requirements

### Non-functional Requirements
- Performance benchmarks
- Security requirements
- Scalability needs
- Compliance requirements

### Constraints and Dependencies
- Technical constraints
- Business constraints
- External dependencies

## Memory Update Instructions
After completion, append a new entry to docs/memory/01-requirements.md (use the file's schema) and add a one-line summary + link in docs/memory/index.md:
- Key stakeholders identified
- Major requirements categories
- Critical constraints discovered
- Next phase preparation items

Tag the entry with: #Requirements #Planning

## Self-Critique
Review your output for:
- ✅ Complete stakeholder coverage
- ✅ Clear, testable requirements
- ✅ Realistic constraints identification
- ✅ Proper prioritization
- ✅ Consistency with project context

## Workflow Context
```mermaid
graph LR
    A[01-Requirements] --> B[02-User Stories]
    B --> C[03-Architecture]
    A -.-> D[Memory Update]

    style A fill:#4caf50,stroke:#2e7d32,stroke-width:3px
```

You are here: **Requirements Gathering** (Phase 1 of 16)
Next: User Stories Creation
Dependencies: None
