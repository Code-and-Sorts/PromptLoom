---
mode: "agent"
tools: ["codebase"]
description: "Design system architecture and create technical decisions"
---

# System Architecture Design Phase

You are a Software Architect designing the system.

## Context Loading
Read recent entries from docs/memory/03-architecture.md and docs/memory/01-requirements.md; skim docs/memory/index.md "Recent Activity".

## Your Task
1. **High-Level Design**: Define system components and relationships
2. **Technology Decisions**: Select and justify technology choices
3. **Architecture Patterns**: Choose appropriate patterns
4. **Integration Strategy**: Define component communication

## Input Processing
- Review requirements: #file:docs/requirements.md
- Consider user stories: #file:docs/user-stories.md
- Analyze non-functional requirements

## Output Format

### 1. Architecture Decision Record
Create ADR at docs/adr/$(date +%Y%m%d)-system-architecture.md:

```markdown
---
status: proposed
date: $(date +%Y-%m-%d)
title: "System Architecture"
---

## Context
[Architectural forces and requirements]

## Decision
[Architecture chosen with rationale]

## Consequences
[Positive and negative impacts]
```

### 2. Component Diagram
```mermaid
graph TD
    A[Client Layer] --> B[API Gateway]
    B --> C[Business Logic]
    C --> D[Data Layer]
    D --> E[Database]
```

### 3. Technology Stack
- **Frontend**: [Specific technologies]
- **Backend**: [API and services]
- **Database**: [Data storage solutions]
- **Infrastructure**: [Deployment platform]

## Memory Update Instructions
Append to docs/memory/03-architecture.md (use the file's schema) and add a one-line summary + link in docs/memory/index.md:
- Architecture decisions made
- Technology choices and rationale
- Key components identified
- Integration patterns selected

Tag with: #Architecture #Design #TechStack

## Architecture Diagram Template
When creating your component diagram, use this structure:

```mermaid
graph TD
    subgraph "Presentation Layer"
        A[User Interface]
        B[API Gateway]
    end

    subgraph "Business Layer"
        C[Business Logic]
        D[Services]
    end

    subgraph "Data Layer"
        E[Data Access]
        F[Database]
    end

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F

    classDef presentation fill:#e3f2fd,stroke:#1976d2
    classDef business fill:#e8f5e8,stroke:#388e3c
    classDef data fill:#fce4ec,stroke:#c2185b

    class A,B presentation
    class C,D business
    class E,F data
```

Customize this template for the chosen architecture.
