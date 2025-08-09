#!/bin/bash

# PromptLoom Framework Setup Script
# Creates the complete directory structure and template files

set -euo pipefail
IFS=$'\n\t'

# Default values
YES_FLAG=false
FORCE_FLAG=false
PROJECT_NAME=""
TEAM_NAME=""
TECH_STACK=""
SPECIALIZATIONS=""
CUSTOM_TAGS=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes)
            YES_FLAG=true
            shift
            ;;
        --force)
            FORCE_FLAG=true
            shift
            ;;
        --project)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --team)
            TEAM_NAME="$2"
            shift 2
            ;;
        --stack)
            TECH_STACK="$2"
            shift 2
            ;;
        --specializations)
            SPECIALIZATIONS="$2"
            shift 2
            ;;
        --tags)
            CUSTOM_TAGS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -y, --yes              Skip all prompts and use defaults"
            echo "  --force                Overwrite existing files without asking"
            echo "  --project NAME         Set project name"
            echo "  --team NAME            Set team name"
            echo "  --stack STACK          Set tech stack"
            echo "  --specializations LIST Set specializations (comma-separated)"
            echo "  --tags LIST            Set custom tags (comma-separated)"
            echo "  -h, --help             Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Helper functions
confirm_write() {
  local path="$1"
  if [[ -f "$path" ]] && [[ "$FORCE_FLAG" != true ]]; then
    if [[ "$YES_FLAG" == true ]]; then
      echo -e "${YELLOW}Overwriting existing file: $path${NC}"
      return 0
    fi
    echo -e "${YELLOW}File exists: $path${NC}"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      return 1
    fi
  fi
  return 0
}

write_file() {
  local path="$1"
  local dir=$(dirname "$path")

  if ! confirm_write "$path"; then
    echo -e "${RED}Skipping: $path${NC}"
    return 1
  fi

  mkdir -p "$dir"
  cat > "$path"
  echo -e "${GREEN}Created: $path${NC}"
  return 0
}

echo -e "${PURPLE}"
cat <<'EOB'

  _   _   _   _   _   _   _   _   _   _
 / \ / \ / \ / \ / \ / \ / \ / \ / \ / \
( P | r | o | m | p | t | L | o | o | m )
 \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/


EOB
echo -e "${NC}"

# Get project configuration
if [[ "$YES_FLAG" != true && -z "$PROJECT_NAME" ]]; then
  read -p "Project Name (default: My Project): " PROJECT_NAME
fi
PROJECT_NAME=${PROJECT_NAME:-"My Project"}

if [[ "$YES_FLAG" != true && -z "$TEAM_NAME" ]]; then
  read -p "Team Name (default: Development Team): " TEAM_NAME
fi
TEAM_NAME=${TEAM_NAME:-"Development Team"}

if [[ "$YES_FLAG" != true && -z "$TECH_STACK" ]]; then
  read -p "Tech Stack (default: TypeScript/React/Node.js): " TECH_STACK
fi
TECH_STACK=${TECH_STACK:-"TypeScript/React/Node.js"}

if [[ "$YES_FLAG" != true && -z "$SPECIALIZATIONS" ]]; then
  read -p "Team Specializations (comma-separated, default: Frontend,Backend,Testing): " SPECIALIZATIONS
fi
SPECIALIZATIONS=${SPECIALIZATIONS:-"Frontend,Backend,Testing"}

if [[ "$YES_FLAG" != true && -z "$CUSTOM_TAGS" ]]; then
  read -p "Custom Tags (comma-separated, default: Performance,UX,Security): " CUSTOM_TAGS
fi
CUSTOM_TAGS=${CUSTOM_TAGS:-"Performance,UX,Security"}

echo -e "${BLUE}Setting up Copilot Framework for: ${PROJECT_NAME}${NC}"

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p .github/{prompts,config}
mkdir -p docs/{adr,framework}

# Create stubs for referenced files
echo -e "${YELLOW}Creating stubs for referenced files...${NC}"
touch README.md
write_file docs/requirements.md << EOF
# Requirements Document

## Stakeholder Analysis

## Functional Requirements

## Non-functional Requirements

## Constraints and Dependencies
EOF

write_file docs/user-stories.md << EOF
## Epics
# List of high-level epics for the project

### Example Epics
- As a Sales Rep, I want to manage my leads and opportunities so that I can close deals efficiently.
- As an Account Manager, I want to track customer interactions so that I can improve retention.

## User Stories
# Detailed user stories for each epic

### Example User Stories
- **As a Sales Rep, I want to add new leads, so that I can track potential clients.**
  - [ ] Can add lead with name, company, contact info
  - [ ] Validation for required fields
  - [ ] Accessible form fields

- **As a Sales Rep, I want to update opportunity status, so that I can reflect deal progress.**
  - [ ] Status options: New, In Progress, Won, Lost
  - [ ] Activity log for changes

- **As an Account Manager, I want to view customer history, so that I can personalize outreach.**
  - [ ] Timeline of interactions
  - [ ] Exportable data

## Story Map
# Mapping of user journeys and dependencies

Lead Management → Opportunity Tracking → Customer History

## Prioritization
# Prioritization of user stories and epics

1. Lead Management (Critical)
2. Opportunity Tracking (High)
3. Customer History (Medium)
EOF

write_file docs/architecture/overview.md << EOF
# Architecture Overview

## System Overview
EOF

write_file docs/architecture/components.md << EOF
# Architecture Components

## Component Details
EOF

write_file docs/architecture/integrations.md << EOF
# Architecture Integrations

## Integration Points
EOF

write_file docs/architecture/deployment.md << EOF
# Deployment Architecture

## Deployment Details
EOF

# Generate .github/copilot-instructions.md
echo -e "${YELLOW}Creating copilot-instructions.md...${NC}"
write_file .github/copilot-instructions.md << EOF
# ${PROJECT_NAME} - Development Instructions

# Project Context
This is ${PROJECT_NAME} built with ${TECH_STACK}.
Team: ${TEAM_NAME}
Specializations: ${SPECIALIZATIONS}

# Development Standards
- Follow TypeScript lint and markdown style conventions
- Always update relevant README or docs when adding code
- Generate inline docstrings/JSDoc after implementation
- Run security checks: npm audit, git-secrets scan
- Enforce ADR conventions in docs/adr/

# Memory Management
- Before starting any phase, read the latest 1,000 tokens from docs/memory.md
- Filter for entries tagged with current phase from the past 7 days
- After completing work, update memory using the appropriate prompt template
- Tag all entries with relevant phase tags

# Phase Workflow
1. Load current phase prompt from .github/prompts/
2. Check dependencies listed in phase frontmatter
3. Execute phase instructions following role guidance
4. Update memory and documentation
5. Run self-critique if enabled in frontmatter

# Quality Gates
- All code must pass: npm run lint && npm run test
- Documentation must be updated for new features
- Security scans must pass before merging
- ADRs required for architectural changes
EOF

# Generate team-config.yml
echo -e "${YELLOW}Creating team-config.yml...${NC}"
write_file .github/config/team-config.yml << EOF
team:
  name: "${TEAM_NAME}"
  project: "${PROJECT_NAME}"
  techStack: "${TECH_STACK}"
  specializations:
$(echo "${SPECIALIZATIONS}" | tr ',' '\n' | sed 's/^/    - "/' | sed 's/$/"/')

customizations:
  tags:
    custom:
$(echo "${CUSTOM_TAGS}" | tr ',' '\n' | sed 's/^/      - "/' | sed 's/$/"/')

  memory:
    retention:
      critical: 60  # days
      normal: 14    # days
      ephemeral: 7  # days

  phases:
    all:
      additionalStandards:
        - "Follow ${TECH_STACK} best practices"
        - "Ensure accessibility compliance"
EOF

# Generate phase-config.yml
echo -e "${YELLOW}Creating phase-config.yml...${NC}"
write_file .github/config/phase-config.yml << EOF
phases:
  "01-requirements":
    priority: critical
    estimatedTokens: 2000
    dependencies: []

  "02-user-stories":
    priority: high
    estimatedTokens: 1500
    dependencies: ["01-requirements"]

  "03-architecture":
    priority: critical
    estimatedTokens: 3000
    dependencies: ["01-requirements", "02-user-stories"]

  "04-architecture-docs":
    priority: medium
    estimatedTokens: 1500
    dependencies: ["03-architecture"]

  "05-implementation":
    priority: high
    estimatedTokens: 4000
    dependencies: ["03-architecture"]

  "06-code-docs":
    priority: medium
    estimatedTokens: 1500
    dependencies: ["05-implementation"]

  "07-testing":
    priority: high
    estimatedTokens: 2500
    dependencies: ["05-implementation"]

  "08-deployment":
    priority: high
    estimatedTokens: 2000
    dependencies: ["07-testing"]

  "09-release-notes":
    priority: medium
    estimatedTokens: 1000
    dependencies: ["08-deployment"]

  "10-security":
    priority: critical
    estimatedTokens: 2500
    dependencies: ["05-implementation"]

  "11-memory":
    priority: low
    estimatedTokens: 500
    dependencies: []

  "12-memory-window":
    priority: low
    estimatedTokens: 500
    dependencies: ["11-memory"]

  "13-memory-sync":
    priority: medium
    estimatedTokens: 1000
    dependencies: ["11-memory"]

  "14-error-recovery":
    priority: high
    estimatedTokens: 1500
    dependencies: []

  "15-integration-test":
    priority: high
    estimatedTokens: 2000
    dependencies: []

  "16-customize":
    priority: medium
    estimatedTokens: 1500
    dependencies: []
EOF

# Generate tags.yml
echo -e "${YELLOW}Creating tags.yml...${NC}"
write_file .github/config/tags.yml << EOF
# Tag Taxonomy for Memory Management

phases:
  - Requirements
  - UserStories
  - Architecture
  - Implementation
  - Testing
  - Deployment
  - Security
  - Release
  - Memory
  - Recovery

domains:
  - Frontend
  - Backend
  - Database
  - Infrastructure
  - DevOps
  - Security

priorities:
  - Critical
  - High
  - Medium
  - Low

custom:
$(echo "${CUSTOM_TAGS}" | tr ',' '\n' | sed 's/^/  - /')
EOF

# Generate prompt templates
echo -e "${YELLOW}Creating prompt templates...${NC}"

# 01-requirements.prompt.md
write_file .github/prompts/01-requirements.prompt.md << 'PROMPT1'
---
mode: "agent"
tools: ["codebase"]
description: "Gather project requirements and analyze stakeholders"
---

# Requirements Gathering Phase

You are a Business Analyst working on the project.

## Context Loading
Load the last 1,000 tokens from docs/memory.md tagged with #Requirements from the past 7 days.

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
After completion, update docs/memory.md with:
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
PROMPT1

# 02-user-stories.prompt.md
write_file .github/prompts/02-user-stories.prompt.md << 'PROMPT2'
---
mode: "agent"
tools: ["codebase"]
description: "Convert requirements into user stories with acceptance criteria"
---

# User Stories Creation

You are a Product Owner creating user stories for the project.

## Context
Review the requirements document: #docs/requirements.md
Check project memory: #docs/memory.md

## Your Task
Convert the documented requirements into well-structured user stories following the format:

**As a** [user type]
**I want** [functionality]
**So that** [business value]

## Deliverables
1. **Epic Overview** - High-level user journeys
2. **Detailed User Stories** - Individual stories with acceptance criteria
3. **Story Map** - Organized by user journey
4. **Prioritization** - Ranked by business value

## Acceptance Criteria Format
For each story include:
- [ ] Specific, testable criteria
- [ ] Edge cases considered
- [ ] Performance requirements
- [ ] Accessibility requirements

## Memory Update
Update #docs/memory.md with:
- Number of stories created
- Key epics identified
- Prioritization rationale
- Dependencies noted

Tag: #UserStories #Product
PROMPT2

# 03-architecture.prompt.md
write_file .github/prompts/03-architecture.prompt.md << 'PROMPT3'
---
mode: "agent"
tools: ["codebase"]
description: "Design system architecture and create technical decisions"
---

# System Architecture Design Phase

You are a Software Architect designing the system.

## Context Loading
Load the last 1,000 tokens from docs/memory.md tagged with #Architecture OR #Requirements from the past 7 days.

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
Update docs/memory.md with:
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
PROMPT3

# Continue with remaining prompts (4-16) with proper content
echo -e "${YELLOW}Creating remaining prompt files...${NC}"

# 04-architecture-docs.prompt.md
write_file .github/prompts/04-architecture-docs.prompt.md << 'PROMPT4'
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
Reference memory: #docs/memory.md

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
After completion, update #docs/memory.md with:
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
PROMPT4

# 05-implementation.prompt.md
write_file .github/prompts/05-implementation.prompt.md << 'PROMPT5'
---
mode: "agent"
tools: ["codebase"]
description: "Implement code based on architecture and requirements"
---

# Implementation Phase

You are a Developer implementing the core functionality.

## Context
Review architecture: #docs/adr/
Check user stories: #docs/user-stories.md
Reference codebase: #codebase

## Your Task
1. Setup Project Structure
2. Implement Core Components
3. Create API Endpoints
4. Implement Data Models
5. Add Integration Logic

## Quality Requirements
- Follow established best practices
- Include error handling and logging
- Write clean, maintainable code
- Add inline documentation
- Implement proper validation

## Memory Update
After completion, update #docs/memory.md with:
- Key accomplishments from this phase
- Important decisions made
- Next steps identified

Tag: #Implementation #Development

## Self-Critique
Review your output for:
- ✅ Code matches architecture and requirements
- ✅ Error handling and validation present
- ✅ Documentation included
- ✅ Proper tagging and memory update
PROMPT5

# Create remaining prompts 06-16 with basic structure
for i in {6..16}; do
    case $i in
        6) name="code-docs"; desc="Generate comprehensive code documentation"; role="Developer" ;;
        7) name="testing"; desc="Create and execute comprehensive testing strategy"; role="QA Engineer" ;;
        8) name="deployment"; desc="Design and implement deployment pipeline"; role="DevOps Engineer" ;;
        9) name="release-notes"; desc="Generate release notes and changelog"; role="Technical Writer" ;;
        10) name="security"; desc="Perform security review and vulnerability assessment"; role="Security Engineer" ;;
        11) name="memory"; desc="Update project memory with phase completion"; role="Memory Curator" ;;
        12) name="memory-window"; desc="Prune and manage memory window size"; role="Memory Curator" ;;
        13) name="memory-sync"; desc="Synchronize memory across team members"; role="Memory Curator" ;;
        14) name="error-recovery"; desc="Recover from errors and provide solutions"; role="Recovery Specialist" ;;
        15) name="integration-test"; desc="Run integration tests across the framework"; role="QA Engineer" ;;
        16) name="customize"; desc="Customize framework for team needs"; role="Framework Engineer" ;;
    esac

    tools='["codebase"]'
    if [[ $i -ge 11 && $i -le 13 ]]; then
        tools='[]'
    fi

    filename=$(printf "%02d" $i)
    desc_capitalized="$(echo "${desc}" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
    name_capitalized="$(echo "${name}" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
    write_file .github/prompts/${filename}-${name}.prompt.md << EOF
---
mode: "agent"
tools: ${tools}
description: "${desc}"
---

# ${desc_capitalized}

You are a ${role} working on the project.

## Context
Reference files: #docs/memory.md for project context
Review relevant documentation and codebase: #codebase

## Your Task
${desc}

## Instructions
[Phase-specific detailed instructions for ${name}]

## Memory Update
After completion, update #docs/memory.md with:
- Key accomplishments from this phase
- Important decisions made
- Next steps identified

Tag: #${name_capitalized} #$(echo "${PROJECT_NAME}" | tr -d ' ')
EOF
done

# Generate workflow diagrams
echo -e "${YELLOW}Creating workflow diagrams...${NC}"
write_file docs/framework/workflow-diagrams.md << 'DIAGRAMS'
# Project Workflow Diagrams

## Phase Flow Diagram

```mermaid
graph TD
    A[01-Requirements] --> B[02-User Stories]
    B --> C[03-Architecture]
    C --> D[04-Architecture Docs]
    C --> E[05-Implementation]
    E --> F[06-Code Docs]
    E --> G[07-Testing]
    G --> H[08-Deployment]
    H --> I[09-Release Notes]
    E --> J[10-Security]

    %% Memory Management
    K[11-Memory Update] -.-> A
    K -.-> B
    K -.-> C
    K -.-> E
    K -.-> G
    K -.-> H

    L[12-Memory Window] --> K
    M[13-Memory Sync] --> K

    %% Support Processes
    N[14-Error Recovery] -.-> A
    N -.-> B
    N -.-> C
    N -.-> E
    N -.-> G
    N -.-> H

    O[15-Integration Test] --> H
    P[16-Customize] -.-> A

    %% Styling
    classDef phase fill:#90caf9,stroke:#0d47a1,stroke-width:3px,color:#212121,rx:8px,ry:8px,shadow:2px 2px 8px #bdbdbd;
    classDef memory fill:#ce93d8,stroke:#6a1b9a,stroke-width:3px,color:#212121,rx:8px,ry:8px,shadow:2px 2px 8px #bdbdbd;
    classDef support fill:#a5d6a7,stroke:#2e7d32,stroke-width:3px,color:#212121,rx:8px,ry:8px,shadow:2px 2px 8px #bdbdbd;

    class A,B,C,D,E,F,G,H,I,J phase
    class K,L,M memory
    class N,O,P support
```

## Memory Management Flow

```mermaid
graph TD
    A[Phase Completion] --> B[11-Memory Update]
    B --> C{Memory Size Check}
    C -->|Too Large| D[12-Memory Window]
    C -->|OK| E[Continue]
    D --> F[Archive Old Entries]
    F --> G[Prune Details]
    G --> E

    H[Team Member Updates] --> I[13-Memory Sync]
    I --> J{Conflicts?}
    J -->|Yes| K[Resolve Conflicts]
    J -->|No| L[Merge Memories]
    K --> L
    L --> E

    M[Error Occurs] --> N[14-Error Recovery]
    N --> O[Analyze & Fix]
    O --> B

    classDef memory fill:#90caf9,stroke:#0d47a1,stroke-width:3px,color:#212121,rx:8px,ry:8px,shadow:2px 2px 8px #bdbdbd;
    classDef decision fill:#ce93d8,stroke:#6a1b9a,stroke-width:3px,color:#212121,rx:8px,ry:8px,shadow:2px 2px 8px #bdbdbd;
    classDef action fill:#a5d6a7,stroke:#2e7d32,stroke-width:3px,color:#212121,rx:8px,ry:8px,shadow:2px 2px 8px #bdbdbd;

    class A,B,D,F,G,H,I,K,L,N,O action
    class C,J decision
```
DIAGRAMS

echo -e "${YELLOW}Creating memory.md...${NC}"
write_file docs/memory.md << EOF
## ${PROJECT_NAME} Memory

~~~mermaid
timeline
    title Project Timeline
    $(date +%Y-%m-%d) : Project Initialized
~~~

## Current Status
Project initialized with Copilot-centric prompt framework.

### Team Configuration
- **Project**: ${PROJECT_NAME}
- **Team**: ${TEAM_NAME}
- **Tech Stack**: ${TECH_STACK}
- **Specializations**: ${SPECIALIZATIONS}

### Framework Setup
- ✅ Directory structure created
- ✅ Prompt templates generated
- ✅ Configuration files ready
- ✅ Memory system initialized

### Phase Outputs
# This section summarizes outputs from each phase for traceability.

#### Requirements Phase
- Stakeholder analysis, functional and non-functional requirements, constraints stored in docs/requirements.md

#### User Stories Phase
- Epics and detailed user stories stored in docs/user-stories.md
- Story map and prioritization documented

#### Architecture Phase
- Architecture decisions and diagrams stored in docs/adr/ and docs/architecture/

#### Implementation Phase
- Core components, API endpoints, and models implemented

... (add summaries for other phases as completed)

### Next Steps
1. Begin Phase 1: Requirements Gathering
2. Customize team configuration if needed
3. Set up development environment
4. Initialize project documentation

### Tags
#ProjectInit #FrameworkSetup #$(echo "${PROJECT_NAME}" | tr -d ' ')

---

## Archive
[Older entries will be moved here after 14 days]
EOF

# Generate usage guide
echo -e "${YELLOW}Creating usage guide...${NC}"
write_file docs/framework/usage-guide.md << EOF
# ${PROJECT_NAME} Framework Usage Guide

## Quick Start

### 1. Starting a New Phase
1. Start a new GitHub Copilot Chat
2. Type \`/01-requirements\` (or another phase name) to load the prompt phase (example, use backticks in markdown)

### 2. Memory Management
- **Before each phase**: Read current memory context from \`docs/memory.md\`
- **After each phase**: Update memory using the provided template
- **Weekly**: Review and prune memory entries as needed

### 3. Team Collaboration
- Use memory sync prompts for team coordination
- Follow ADR conventions for architectural decisions
- Tag all memory entries consistently for easy filtering

## Phase Workflow

The framework includes 16 phases organized in logical sequence:

### Core Development Phases
1. **Requirements** (\`01-requirements.prompt.md\`) - Business Analyst
2. **User Stories** (\`02-user-stories.prompt.md\`) - Product Owner
3. **Architecture** (\`03-architecture.prompt.md\`) - Software Architect
4. **Architecture Docs** (\`04-architecture-docs.prompt.md\`) - Technical Writer
5. **Implementation** (\`05-implementation.prompt.md\`) - Developer
6. **Code Documentation** (\`06-code-docs.prompt.md\`) - Developer
7. **Testing** (\`07-testing.prompt.md\`) - QA Engineer
8. **Deployment** (\`08-deployment.prompt.md\`) - DevOps Engineer
9. **Release Notes** (\`09-release-notes.prompt.md\`) - Technical Writer
10. **Security Review** (\`10-security.prompt.md\`) - Security Engineer

### Meta Phases
11. **Memory Update** (\`11-memory.prompt.md\`) - Memory Curator
12. **Memory Pruning** (\`12-memory-window.prompt.md\`) - Memory Curator
13. **Memory Sync** (\`13-memory-sync.prompt.md\`) - Memory Curator
14. **Error Recovery** (\`14-error-recovery.prompt.md\`) - Recovery Specialist
15. **Integration Test** (\`15-integration-test.prompt.md\`) - QA Engineer
16. **Customization** (\`16-customize.prompt.md\`) - Framework Engineer

## Configuration

### Team-Level Customization
Edit \`.github/config/team-config.yml\`:
- Modify team-specific standards
- Add custom tags
- Adjust memory retention policies

### Phase-Level Customization
Edit individual prompt files in \`.github/prompts/\`:
- Customize role descriptions
- Add team-specific outputs
- Modify self-critique criteria

## File Structure

\`\`\`
${PROJECT_NAME}/
├── .github/
│   ├── copilot-instructions.md      # Global project context
│   ├── prompts/                     # All phase templates
│   └── config/                      # Team configuration
└── docs/
    ├── adr/                         # Architecture decisions
    ├── memory.md                    # Project memory
    └── framework/                   # Framework documentation
        ├── usage-guide.md           # This file
        └── workflow-diagrams.md     # Mermaid diagrams
\`\`\`

## Workflow Visualization

The framework includes comprehensive Mermaid diagrams to help agents understand:

### Phase Flow
Shows the logical progression through all 16 phases with dependencies and parallel tracks.

### Memory Management
Illustrates how the memory system updates, prunes, and synchronizes across team members.

### Tool Integration
Maps how GitHub Copilot connects to the framework tools and external systems.

### Error Recovery
Visualizes the error detection and recovery workflow.

**View all diagrams**: See \`docs/framework/workflow-diagrams.md\` for complete visual documentation.

## Best Practices

1. **Always load memory context** before starting a new phase
2. **Tag entries consistently** using the taxonomy in \`tags.yml\`
3. **Update memory immediately** after completing phase work
4. **Run self-critique** to catch issues early
5. **Sync with team regularly** using memory sync prompts

## Troubleshooting

### Common Issues
- **Memory too large**: Use memory pruning prompt (\`12-memory-window.prompt.md\`)
- **Missing dependencies**: Check \`phase-config.yml\` for requirements
- **Team conflicts**: Use memory sync prompt (\`13-memory-sync.prompt.md\`)
- **Phase errors**: Use error recovery prompt (\`14-error-recovery.prompt.md\`)

### Getting Help
1. Check this usage guide
2. Review prompt template frontmatter for requirements
3. Consult team configuration files
4. Use integration test prompt to validate setup

---

**Framework Version**: 1.0
**Created**: $(date +"%Y-%m-%d %H:%M:%S")
**Team**: ${TEAM_NAME}
EOF

# Create empty ADR directory with template
echo -e "${YELLOW}Setting up ADR directory...${NC}"
write_file docs/adr/.gitkeep << EOF
# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) following the format:
- Filename: YYYYMMDD-short-title.md
- Status: proposed | accepted | deprecated
- Sections: Context → Decision → Consequences

Example:
docs/adr/20240715-database-selection.md
EOF

echo -e "${GREEN}✅ Framework setup complete!${NC}"
echo ""
echo -e "${BLUE}📁 Created structure for: ${PROJECT_NAME}${NC}"
echo -e "${BLUE}👥 Team: ${TEAM_NAME}${NC}"
echo -e "${BLUE}⚡ Stack: ${TECH_STACK}${NC}"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Review and customize .github/config/ files"
echo "2. Start with Phase 1: In GitHub Copilot Chat, type '/01-requirements' to load the requirements prompt"
echo ""
echo -e "${GREEN}🚀 Happy coding with your new Copilot framework!${NC}"
