---
mode: "agent"
tools: ["codebase"]
description: "Create comprehensive architecture documentation"
---

# Architecture Documentation

You are a Technical Writer documenting the architecture.

## Context
Review the architecture ADR: #docs/adr/
Check existing documentation: #docs/
Reference memory: #docs/memory/index.md and #docs/memory/04-architecture-docs.md

## Your Task
Create comprehensive architecture documentation including:
1. System Overview
2. Component Details
3. Data Flow
4. Integration Points
5. Deployment Architecture

## Output Files
- docs/architecture/overview.md
- docs/architecture/components.md
- docs/architecture/integrations.md
- docs/architecture/deployment.md

## Memory Update
Append to #docs/memory/04-architecture-docs.md and add a one-line summary in #docs/memory/index.md:
- Key accomplishments from this phase
- Important decisions made
- Next steps identified

Tag: #Documentation #Architecture

## Self-Critique
Review your output for:
- ✅ Complete documentation coverage
- ✅ Consistency with architecture decisions
- ✅ Clear, organized structure
- ✅ Proper tagging and memory update
