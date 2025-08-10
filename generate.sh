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
# Capability bindings (default: unbound/null)
CAP_UNIT_CMD=""
CAP_E2E_CMD=""
CAP_CONTRACT_CMD=""
CAP_PERF_CMD=""
CAP_DOCS_CMD=""
CAP_LINT_CMD=""
SUGGEST_FLAG=false

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
        --cap-unit)
            CAP_UNIT_CMD="$2"
            shift 2
            ;;
        --cap-e2e)
            CAP_E2E_CMD="$2"
            shift 2
            ;;
        --cap-contract)
            CAP_CONTRACT_CMD="$2"
            shift 2
            ;;
        --cap-perf)
            CAP_PERF_CMD="$2"
            shift 2
            ;;
        --cap-docs)
            CAP_DOCS_CMD="$2"
            shift 2
            ;;
        --cap-lint)
            CAP_LINT_CMD="$2"
            shift 2
            ;;
        --suggest)
            SUGGEST_FLAG=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --cap-unit CMD         Bind unit test capability to a command (optional)"
            echo "  --cap-e2e CMD          Bind end-to-end/UI test capability to a command (optional)"
            echo "  --cap-contract CMD     Bind contract test capability to a command (optional)"
            echo "  --cap-perf CMD         Bind performance/load capability to a command (optional)"
            echo "  --cap-docs CMD         Bind docs generation capability to a command (optional)"
            echo "  --cap-lint CMD         Bind linting/static analysis capability to a command (optional)"
            echo "  --suggest              Write capability_suggestions.yml (no binding; review-only)"
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


# Lightweight language detection (advisory only)
DETECTED_LANGS=()
DETECTION_BASIS=()
detect_file() { [[ -f "$1" ]] && DETECTION_BASIS+=("$1"); }
detect_glob() { compgen -G "$1" >/dev/null 2>&1 && DETECTION_BASIS+=("$1"); }
detect_file "package.json" && DETECTED_LANGS+=("javascript/typescript")
detect_file "tsconfig.json" && DETECTED_LANGS+=("typescript")
detect_file "pyproject.toml" && DETECTED_LANGS+=("python")
detect_file "requirements.txt" && DETECTED_LANGS+=("python")
detect_file "go.mod" && DETECTED_LANGS+=("go")
detect_glob "*.csproj" && DETECTED_LANGS+=(".net")
detect_file "Cargo.toml" && DETECTED_LANGS+=("rust")
detect_file "pom.xml" && DETECTED_LANGS+=("java")
detect_glob "build.gradle*" && DETECTED_LANGS+=("java")
detect_file "composer.json" && DETECTED_LANGS+=("php")
detect_file "Gemfile" && DETECTED_LANGS+=("ruby")
STACK_HINT="$(echo "$TECH_STACK" | tr '[:upper:]' '[:lower:]')"

# Prepare capability bindings (commands optional; tool names intentionally omitted)
CAP_UNIT_VAL="${CAP_UNIT_CMD:-null}"
CAP_E2E_VAL="${CAP_E2E_CMD:-null}"
CAP_CONTRACT_VAL="${CAP_CONTRACT_CMD:-null}"
CAP_PERF_VAL="${CAP_PERF_CMD:-null}"
CAP_DOCS_VAL="${CAP_DOCS_CMD:-null}"
CAP_LINT_VAL="${CAP_LINT_CMD:-null}"

echo -e "${BLUE}Setting up Copilot Framework for: ${PROJECT_NAME}${NC}"

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p .github/{prompts,config}
mkdir -p docs/{adr,framework,memory,memory-archive}

# Generate capabilities.yml
echo -e "${YELLOW}Creating capabilities.yml...${NC}"
write_file .github/config/capabilities.yml << EOF
capabilities:
  unit_test:
    tool: null
    command: ${CAP_UNIT_VAL}
    notes: "Runs fast, isolated tests; target ≥80% coverage"
  e2e_test:
    tool: null
    command: ${CAP_E2E_VAL}
    notes: "Covers critical user journeys end-to-end"
  contract_test:
    tool: null
    command: ${CAP_CONTRACT_VAL}
    notes: "Verifies producer/consumer API contracts"
  performance_test:
    tool: null
    command: ${CAP_PERF_VAL}
    notes: "Establishes baseline throughput/latency with thresholds"
  docs_generator:
    tool: null
    command: ${CAP_DOCS_VAL}
    notes: "Builds API/code docs; fallback to Markdown stubs if unbound"
  linter:
    tool: null
    command: ${CAP_LINT_VAL}
    notes: "Static analysis and style checks"
policies:
  coverage_threshold: 0.80
  allow_unbound_capabilities: true
EOF

# Optionally generate capability_suggestions.yml (advisory only)
if [[ "$SUGGEST_FLAG" == true ]]; then
  echo -e "${YELLOW}Creating capability_suggestions.yml...${NC}"
  write_file .github/config/capability_suggestions.yml << EOF
suggestions:
  unit_test:
    - { tool: "pytest", command: "pytest -q" }
    - { tool: "jest", command: "npx jest --ci" }
    - { tool: "go test", command: "go test ./..." }
  e2e_test:
    - { tool: "playwright", command: "npx playwright test" }
    - { tool: "selenium", command: "selenium-standalone start # then run tests" }
  contract_test:
    - { tool: "pact", command: "pact-broker verify # adjust to stack" }
    - { tool: "schemathesis", command: "schemathesis run openapi.yaml" }
  performance_test:
    - { tool: "k6", command: "k6 run tests/perf/*.js" }
    - { tool: "jmeter", command: "jmeter -n -t tests/perf/test.jmx" }
  docs_generator:
    - { tool: "markdown-stubs", command: "scripts/docs-stubs.sh" }
    - { tool: "pdoc", command: "pdoc -o docs/api <package>" }
    - { tool: "typedoc", command: "npx typedoc --out docs/api ./src" }
    - { tool: "gomarkdoc", command: "gomarkdoc ./... > docs/api/GO_API.md" }
  linter:
    - { tool: "generic-lint", command: "scripts/lint.sh" }
    - { tool: "eslint", command: "npx eslint ." }
    - { tool: "ruff", command: "ruff check ." }
evidence:
  languages:
$(printf "%s\n" "${DETECTED_LANGS[@]}" | sed 's/^/    - "/' | sed 's/$/"/')
  files:
$(printf "%s\n" "${DETECTION_BASIS[@]}" | sed 's/^/    - "/' | sed 's/$/"/')
confidence:
  unit_test: 0.6
  e2e_test: 0.6
  contract_test: 0.5
  performance_test: 0.5
  docs_generator: 0.5
  linter: 0.6
EOF
fi

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
- Follow project language and markdown style conventions
- Update README and docs when adding code or changing behavior
- Generate inline documentation for public APIs where applicable
- Run security checks appropriate to the stack (e.g., dependency and secret scans)
- Enforce ADR conventions in docs/adr/
- Bind and use capabilities from .github/config/capabilities.yml (tools are suggestions, not mandates)

# Memory Management
- Before starting any phase, read the relevant **per-phase** memory file under \`docs/memory/\` (e.g., \`03-architecture.md\`) and skim \`docs/memory/index.md\` "Recent Activity"
- Load only the **last few entries** from the current phase file to reduce context bloat
- When you finish a phase, **append a new entry** to that phase's file using the schema at the top of the file
- Include \`sources:\` links (ADRs, PRs, docs) and set a \`confidence\` level
- Add a one-line summary + link in \`docs/memory/index.md\` under "Recent Activity"
- Use tags from \`.github/config/tags.yml\`
- Prune or archive older content into \`docs/memory-archive/\` when entries get large

# Phase Workflow
1. Load current phase prompt from .github/prompts/
2. Check dependencies listed in phase frontmatter
3. Execute phase instructions following role guidance
4. Update memory and documentation
5. Run self-critique if enabled in frontmatter

# Quality Gates
- All code must pass linting and tests as bound in capabilities.yml; if unbound, propose and record
- Documentation must be updated for new features
- Security scans must pass before merging
- ADRs required for architectural changes

# Capabilities
Current bindings (null = unbound; agents should propose options but not assume a specific tool):
- Unit tests command: ${CAP_UNIT_CMD:-null}
- E2E tests command: ${CAP_E2E_CMD:-null}
- Contract tests command: ${CAP_CONTRACT_CMD:-null}
- Performance tests command: ${CAP_PERF_CMD:-null}
- Docs generator command: ${CAP_DOCS_CMD:-null}
- Linter command: ${CAP_LINT_CMD:-null}
(Edit .github/config/capabilities.yml to bind or change these. Optionally run with --suggest to generate capability_suggestions.yml for review.)
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
Check project memory: #docs/memory/index.md and #docs/memory/02-user-stories.md

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
Append to #docs/memory/02-user-stories.md (schema at top) and add a one-line summary in #docs/memory/index.md:
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
Append to #docs/memory/05-implementation.md and add a one-line summary in #docs/memory/index.md:
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


# 06-code-docs.prompt.md (language-agnostic)
write_file .github/prompts/06-code-docs.prompt.md << 'PROMPT6'
---
mode: "agent"
tools: ["codebase"]
description: "Generate comprehensive code documentation with language-agnostic goals and optional stack-specific steps"
---

# Code Documentation Phase

You are a Developer producing code-level documentation that is **language-agnostic** and repeatable.
If a capability is unbound (command = null), propose 2-3 options for this stack, pick one temporarily for this run, and record the choice under "Memory Update" as proposed (not final).

## Inputs
- Source code: #codebase
- Architecture docs: #docs/architecture/
- Memory context: #docs/memory/index.md and #docs/memory/06-code-docs.md
- Team/stack hints: #.github/config/team-config.yml
- Capabilities config: #.github/config/capabilities.yml

## Stack Detection (do this first)
1) Detect primary languages by scanning file extensions and build files (e.g., `go.mod`, `package.json`, `pyproject.toml`, `pom.xml`, `build.gradle`, `Cargo.toml`, `.csproj`, `composer.json`, `Gemfile`).
2) Read `techStack` from `team-config.yml` if available.
3) Decide on a **docs strategy**:
   - Strategy A (preferred): Use a stack-appropriate generator to produce HTML/Markdown API docs.
   - Strategy B (fallback): Generate Markdown stubs by extracting public symbols from source files and organizing by module/package.

Record your chosen strategy in the output.

## Core Tasks (language-agnostic)
1) **Public API Surface**
   - Document public entry points: modules/packages, exported functions/types/classes, CLI commands, HTTP endpoints, configuration, environment variables.
2) **Module Overviews**
   - For each module/package: brief purpose, key types/functions, invariants, error behaviors, dependencies.
3) **Usage Examples**
   - Add runnable examples/snippets for the top 10 most-used APIs or endpoints.
4) **Architecture Links**
   - Cross-link relevant sections in `docs/architecture/*` and any ADRs that shaped the API.
5) **Developer Guide**
   - Update `README.md` with local dev, build, test, and docs instructions, plus a link to the generated API docs.

## Optional Stack-Specific Suggestions (use only if applicable)
- Go: `gomarkdoc ./... > docs/api/GO_API.md` or `godoc -http=:6060`
- TypeScript/JavaScript: `npx typedoc --out docs/api ./src` or `npx documentation build src -f html -o docs/api`
- Python: `pdoc -o docs/api <package>` or `sphinx-apidoc -o docs/api <package> && make -C docs/api html`
- Java: Maven `mvn javadoc:javadoc` or Gradle `./gradlew javadoc` -> copy to `docs/api`
- .NET: `docfx docfx.json` -> `docs/api` (or XML docs as fallback)
- Rust: `cargo doc --no-deps --target-dir target && cp -r target/doc docs/api`
- Ruby: `yard doc --output-dir docs/api`
- PHP: `phpDocumentor -d src -t docs/api`

If none fit, proceed with **Strategy B** (fallback Markdown stubs).

## Deliverables
- `docs/api/` (HTML site or Markdown set) **or** `docs/api/*_API.md` stubs (fallback).
- Updated `README.md` with “API Docs” link and docs build instructions.
- Examples demonstrating common use.

## Acceptance Criteria (agnostic)
- Public API surface documented.
- Module overviews exist for each non-trivial module/package.
- Examples compile/run where applicable.
- A single documented command builds docs or stubs.
- Architecture/ADR cross-links included; no broken links.

## Memory Update
Append to #docs/memory/06-code-docs.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Chosen strategy and rationale.
- Gaps identified and follow-ups.
- Link to `docs/api` and updated `README.md`.

Tags: #CodeDocs #Documentation

## Self-Critique
- ✅ Tool-agnostic with graceful fallback
- ✅ Public surface and examples complete
- ✅ Cross-linked to architecture/ADRs
PROMPT6

# 07-testing.prompt.md (language-agnostic)
write_file .github/prompts/07-testing.prompt.md << 'PROMPT7'
---
mode: "agent"
tools: ["codebase"]
description: "Define and execute unit, integration, e2e, contract, and performance tests with language-agnostic thresholds"
---

# Testing Phase

You are a QA Engineer defining and executing a comprehensive test strategy.
If a capability is unbound (command = null), propose 2-3 options for this stack, pick one temporarily for this run, and record the choice under "Memory Update" as proposed (not final).

## Inputs
- Requirements: #docs/requirements.md
- User stories: #docs/user-stories.md
- Architecture ADRs: #docs/adr/
- Codebase: #codebase
- Capabilities config: #.github/config/capabilities.yml

## Stack/Context Detection
- Identify primary languages and frameworks (build files, test directories).
- Determine external dependencies (databases, queues, third-party APIs) needing fakes/mocks.

## Tasks (agnostic)
1) **Test Matrix**
   - Define test types: unit, integration, end-to-end, contract, performance.
   - Map critical user stories (US-IDs) to test cases; mark Critical, High, Medium.
2) **Unit Tests**
   - Create `tests/unit/**`; target coverage ≥ 80% lines/branches.
   - Ensure fast, isolated, deterministic tests.
3) **Integration Tests**
   - Create `tests/integration/**`; stand up minimal infra (local containers, in-memory DB, or mocks).
4) **Contract Tests** (if services)
   - Create `tests/contract/**`; define producer/consumer contracts and verification.
5) **End-to-End Tests**
   - Create `tests/e2e/**`; cover at least one top user journey.
6) **Performance/Load (smoke baseline)**
   - Add a small k6/JMeter/Locust/RPS baseline under `tests/perf/**` with thresholds.
7) **Coverage Gate**
   - Document the coverage threshold; ensure CI will fail below the threshold.
8) **Test Data**
   - Create deterministic fixtures and builders; avoid time and randomness without seeding.

## Optional Stack-Specific Suggestions (use only if applicable)
- JS/TS: Jest/Vitest; Playwright/Cypress; Pact for contracts.
- Python: pytest; Playwright/Robot; `schemathesis` for API contract.
- Go: `testing` + `testify`; `httptest`; Dapper/Pact-Go for contracts.
- Java: JUnit5; RestAssured; Pact-JVM; Selenium/Playwright.
- .NET: xUnit/NUnit; WireMock.Net; Playwright.
- Rust: `cargo test`; `tarpc`/`wiremock` equivalents; `criterion` for perf.

## Deliverables
- `docs/testing/test-matrix.md` (story→test mapping, types, thresholds).
- Tests under `tests/**` per type.
- Coverage report path documented.

## Acceptance Criteria
- Matrix includes all critical US-IDs.
- Unit coverage ≥ 80% (or team-config override).
- ≥ 1 integration and ≥ 1 e2e path for a top user journey.
- Contracts exist for any external service boundaries.

## Memory Update
Append to #docs/memory/07-testing.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Coverage summary.
- Flaky areas and mitigation.
- Links to reports.

Tags: #Testing #Quality

## Self-Critique
- ✅ Tests align to user stories
- ✅ Deterministic and repeatable
- ✅ Coverage threshold enforced
PROMPT7

# 08-deployment.prompt.md (language-agnostic)
write_file .github/prompts/08-deployment.prompt.md << 'PROMPT8'
---
mode: "agent"
tools: ["codebase"]
description: "Design and document deployment strategy, packaging, and environment promotion in a language-agnostic way"
---

# Deployment Phase

You are a DevOps Engineer designing deployment and promotion.
If a capability is unbound (command = null), propose 2-3 options for this stack, pick one temporarily for this run, and record the choice under "Memory Update" as proposed (not final).

## Inputs
- ADRs: #docs/adr/
- Codebase: #codebase
- Tests & matrix: #docs/testing/test-matrix.md
- Capabilities config: #.github/config/capabilities.yml

## Tasks (agnostic)
1) **Environments**
   - Define `dev`, `staging`, `prod` with approvals and required checks.
2) **Strategy**
   - Choose Blue/Green, Rolling, or Recreate; document rollback.
3) **Packaging & Artifacts**
   - Define build artifact(s) (container image, binary, static bundle, package).
4) **Configuration**
   - Externalize config via `.env.example` or config files; document required variables.
5) **Promotion Rules**
   - Gate promotion on passing tests and manual approval for production.
6) **Change Management**
   - Versioning (semver) and release tagging expectations.

## Optional Stack-Specific Suggestions
- Containers: Dockerfile + multi-stage build; SBOM (syft).
- Orchestrators: Kubernetes manifests/Helm; canary/blue-green via service routing.
- Serverless: deploy scripts for the platform of choice; environment variables documented.
- VMs/Bare metal: systemd unit templates; artifact paths and log locations.

## Deliverables
- `docs/deployment/strategy.md` (strategy + rollback).
- `docs/deployment/environments.md` (env vars, secrets, approvals).
- `.env.example` with non-secret defaults (if applicable).

## Acceptance Criteria
- Reproducible, reversible deploys.
- Config separated from code; secrets **not** in repo.
- Promotion path documented with preconditions.

## Memory Update
Append to #docs/memory/08-deployment.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Strategy chosen and rationale.
- Rollback trigger conditions.
- Links to deployment docs.

Tags: #Deployment #ReleaseEngineering

## Self-Critique
- ✅ Reproducible and reversible
- ✅ Config/secrets handled properly
- ✅ Clear promotion gates
PROMPT8

# 09-release-notes.prompt.md (language-agnostic)
write_file .github/prompts/09-release-notes.prompt.md << 'PROMPT9'
---
mode: "agent"
tools: ["codebase"]
description: "Generate release notes and changelog with traceability to stories and PRs"
---

# Release Notes Phase

You are a Technical Writer creating release notes.

## Inputs
- Closed PRs/issues since last tag.
- User stories: #docs/user-stories.md

## Tasks (agnostic)
1) Categorize changes (Features, Fixes, Docs, Security, Chore).
2) Reference user stories (US-IDs) and PR links.
3) Summarize breaking changes and migration steps.
4) Update `CHANGELOG.md` and draft a release announcement.

## Optional Tooling Suggestions
- Conventional Commits; Changesets; semantic-release; GitVersion.

## Deliverables
- `CHANGELOG.md` updated.
- `docs/release/<YYYY-MM-DD>-release-notes.md`.

## Acceptance Criteria
- Every entry references a PR or commit.
- Breaking changes flagged with migration steps.

## Memory Update
Append to #docs/memory/09-release-notes.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Scope of release.
- Known issues.
- Links to artifacts.

Tags: #ReleaseNotes #Changelog

## Self-Critique
- ✅ Traceable to PRs/issues
- ✅ Breaking changes explicit
- ✅ User-facing summary is clear
PROMPT9

# 10-security.prompt.md (language-agnostic)
write_file .github/prompts/10-security.prompt.md << 'PROMPT10'
---
mode: "agent"
tools: ["codebase"]
description: "Perform security review, threat model (STRIDE), and mitigation plan in a language-agnostic way"
---

# Security Review Phase

You are a Security Engineer.
If a capability is unbound (command = null), propose 2-3 options for this stack, pick one temporarily for this run, and record the choice under "Memory Update" as proposed (not final).

## Inputs
- Codebase: #codebase
- ADRs: #docs/adr/
- Dependencies: lockfiles or manifests
- Capabilities config: #.github/config/capabilities.yml

## Tasks (agnostic)
1) **Threat Modeling**
   - Apply STRIDE to main data flows; record mitigations.
2) **Static Analysis Plan**
   - Identify SAST/linters appropriate for the stack; list key checks.
3) **Dependency/Vulnerability Review**
   - Identify high-risk dependencies; plan updates or compensating controls.
4) **Secrets Hygiene**
   - Verify no secrets in repo; recommend pre-commit scans and CI scans.
5) **AuthN/Z Review**
   - Review roles/permissions and data access patterns.

## Optional Tooling Suggestions
- Secrets: gitleaks, truffleHog.
- Deps: osv-scanner, OWASP Dependency-Check, `npm audit`, `pip-audit`, `cargo audit`, `govulncheck`.
- SAST: CodeQL, Bandit, ESLint security plugins, SpotBugs/FindSecBugs.

## Deliverables
- `docs/security/threat-model.md` (diagrams + mitigations).
- `docs/security/findings.md` (risk → mitigation with owners/dates).
- `.gitignore` additions if required.

## Acceptance Criteria
- No P0 secrets in repo.
- High-risk deps have a documented decision.
- ≥ 1 actionable mitigation per STRIDE category found.

## Memory Update
Append to #docs/memory/10-security.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Risks identified.
- Mitigation priorities.
- Links to security docs.

Tags: #Security #ThreatModel

## Self-Critique
- ✅ Concrete mitigations
- ✅ Clear owners and due dates
- ✅ Ties back to ADRs
PROMPT10

# 11-memory.prompt.md (language-agnostic)
write_file .github/prompts/11-memory.prompt.md << 'PROMPT11'
---
mode: "agent"
tools: []
description: "Update project memory with phase completion details"
---

# Memory Update Phase

You are a Memory Curator.

## Inputs
- Outputs from the just-completed phase.
- The relevant per-phase memory file under `docs/memory/` (match your phase).
- docs/memory/index.md

## Tasks
1) Append a new entry to the matching per-phase file with:
   - Frontmatter: phase, tags, sources, last_updated, confidence, status
   - Sections: Summary, Key Decisions, Evidence, Open Questions, Links
2) Add a one-line summary with link under "Recent Activity" in docs/memory/index.md.
3) Ensure each claim links to a source (ADR, PR, doc) in `sources:`.

## Deliverables
- New entry appended to the relevant `docs/memory/<phase>.md`
- One-line summary added to `docs/memory/index.md`

## Acceptance Criteria
- Entry contains links and tags.
- Entry references the phase outputs.

Tags: #Memory #ProjectLog

## Self-Critique
- ✅ Concise and link-rich
- ✅ Tagged for retrieval
PROMPT11

# 12-memory-window.prompt.md (language-agnostic)
write_file .github/prompts/12-memory-window.prompt.md << 'PROMPT12'
---
mode: "agent"
tools: []
description: "Prune memory to keep a workable window; archive older entries"
---

# Memory Pruning Phase

You are a Memory Curator.

## Inputs
- team-config retention: #.github/config/team-config.yml
- docs/memory/index.md
- All per-phase files under docs/memory/

## Tasks
1) For each per-phase file, move entries older than the configured retention to `docs/memory-archive/YYYY-WW.md`.
2) In the original per-phase file, replace moved content with a one-line pointer + archive link.
3) Add a summary of pruned entries to docs/memory/index.md "Recent Activity".

## Deliverables
- Updated per-phase files in `docs/memory/`.
- New archive file created for the week.

## Acceptance Criteria
- Current memory file reduced in size.
- No loss of links or decisions.

Tags: #MemoryPrune #Archive

## Self-Critique
- ✅ Window sized for fast retrieval
- ✅ Archives properly indexed
PROMPT12

# 13-memory-sync.prompt.md (language-agnostic)
write_file .github/prompts/13-memory-sync.prompt.md << 'PROMPT13'
---
mode: "agent"
tools: []
description: "Synchronize memory across contributors; resolve conflicts"
---

# Memory Sync Phase

You are a Memory Curator.

## Inputs
- Latest commits from all contributors.
- docs/memory/index.md
- All per-phase files under docs/memory/

## Tasks
1) Merge entries across per-phase files added by others.
2) Resolve conflicts; if duplication remains, keep newest summary and preserve all source links.
3) Add a "Sync Note" entry in docs/memory/13-memory-sync.md and link it from docs/memory/index.md.

## Deliverables
- Reconciled per-phase files in `docs/memory/`.
- Sync summary appended to `docs/memory/13-memory-sync.md` with diff details.

## Acceptance Criteria
- No unresolved conflict markers.
- Sync note links to relevant PRs/commits.

Tags: #MemorySync #Collaboration

## Self-Critique
- ✅ No duplication
- ✅ Clear provenance
PROMPT13

# 14-error-recovery.prompt.md (language-agnostic)
write_file .github/prompts/14-error-recovery.prompt.md << 'PROMPT14'
---
mode: "agent"
tools: ["codebase"]
description: "Diagnose failures and produce fixes with a lightweight postmortem"
---

# Error Recovery Phase

You are a Recovery Specialist.

## Inputs
- Failing tests/builds.
- Logs and error messages.
- Recent changes.

## Tasks
1) Reproduce the failure deterministically.
2) Identify root cause; list hypotheses and elimination steps.
3) Implement fix or document rollback.
4) Add a lightweight postmortem entry.

## Deliverables
- Fix (code or config) or rollback doc `docs/recovery/rollback-<id>.md`.
- Postmortem: `docs/recovery/postmortem-YYYY-MM-DD.md`.

## Acceptance Criteria
- Reproduction steps recorded.
- Fix validated by tests.
- Postmortem includes “lessons learned”.

## Memory Update
Append to #docs/memory/14-error-recovery.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Root cause and fix link.
- Any follow-up tasks.

Tags: #Recovery #Postmortem

## Self-Critique
- ✅ Reproducible
- ✅ Prevents recurrence
PROMPT14

# 15-integration-test.prompt.md (language-agnostic)
write_file .github/prompts/15-integration-test.prompt.md << 'PROMPT15'
---
mode: "agent"
tools: ["codebase"]
description: "Run cross-service/integration tests and document results in a language-agnostic way"
---

# Integration Test Phase

You are a QA Engineer.

## Inputs
- Test matrix: #docs/testing/test-matrix.md
- Codebase and services

## Tasks
1) Identify top 3 cross-cutting flows (e.g., user signup → notification → data persisted).
2) Write integration tests covering those flows.
3) Capture test environment and data setup steps.
4) Generate a results report.

## Optional Tooling Suggestions
- HTTP/API: Postman/Newman, RestAssured, supertest, httpx/pytest.
- UI: Playwright/Selenium.
- Messaging: Testcontainers/fakes/mocks appropriate to the stack.

## Deliverables
- `tests/integration/**` coverage for chosen flows.
- `docs/testing/integration-results.md`.

## Acceptance Criteria
- Each flow has at least one passing test.
- Results document includes environment and data setup.

## Memory Update
Append to #docs/memory/15-integration-test.md (schema at top) and add a one-line summary in #docs/memory/index.md with links to tests and results.

Tags: #IntegrationTest #Quality

## Self-Critique
- ✅ Critical paths covered
- ✅ Repeatable environment steps
PROMPT15

# 16-customize.prompt.md (language-agnostic)
write_file .github/prompts/16-customize.prompt.md << 'PROMPT16'
---
mode: "agent"
tools: ["codebase"]
description: "Customize framework knobs for team and stack in a language-agnostic way"
---

# Customization Phase

You are a Framework Engineer.

## Inputs
- team-config: #.github/config/team-config.yml
- phase-config: #.github/config/phase-config.yml
- tags: #.github/config/tags.yml

## Tasks
1) Review tags and adjust to project domain.
2) Adjust phase priorities/estimates as needed.
3) Add stack-specific scripts to package manifest or Taskfile.
4) Document team-specific standards in `copilot-instructions.md`.

## Deliverables
- Updated config files.
- `docs/framework/customizations.md`.

## Acceptance Criteria
- Config matches actual team stack and needs.
- Standards reflected in Copilot instructions.

## Memory Update
Append to #docs/memory/16-customize.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Summary of customizations.
- Any new scripts/paths.

Tags: #Customize #Framework

## Self-Critique
- ✅ Knobs reflect reality
- ✅ Minimal friction to adopt
PROMPT16

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

echo -e "${YELLOW}Creating structured memory (index + per-phase files)...${NC}"

# Memory index
write_file docs/memory/index.md << EOF
# ${PROJECT_NAME} — Project Memory Index

> Structured memory to minimize hallucinations and improve retrieval.
> Keep entries concise and link to source-of-truth docs (requirements, ADRs, tests).

## How to use
- When working in a phase, read the **matching per-phase memory file** below.
- Append new entries to that file using the schema shown in each file header.
- Keep this index lean; add a one-line summary under "Recent Activity" and link to the per-phase entry.

## Per-Phase Files
- [01 Requirements](01-requirements.md)
- [02 User Stories](02-user-stories.md)
- [03 Architecture](03-architecture.md)
- [04 Architecture Docs](04-architecture-docs.md)
- [05 Implementation](05-implementation.md)
- [06 Code Docs](06-code-docs.md)
- [07 Testing](07-testing.md)
- [08 Deployment](08-deployment.md)
- [09 Release Notes](09-release-notes.md)
- [10 Security](10-security.md)
- [11 Memory Update](11-memory.md)
- [12 Memory Window](12-memory-window.md)
- [13 Memory Sync](13-memory-sync.md)
- [14 Error Recovery](14-error-recovery.md)
- [15 Integration Test](15-integration-test.md)
- [16 Customize](16-customize.md)

## Recent Activity
- $(date +%Y-%m-%d) — Project initialized; per-phase memory scaffolds created.

## Archive
Older entries and large sections should be moved into: \`../memory-archive/\`
EOF

# Helper to write a per-phase memory file with schema
write_phase_mem() {
  local file="$1"
  local phase="$2"
  write_file "docs/memory/${file}" << EOF
---
phase: ${phase}
tags: []
sources: []
last_updated: $(date +%F)
confidence: medium
status: active
---

# Summary
<!-- 3-10 lines max. What changed? Why? -->

# Key Decisions
- Decision: ...
- Rationale: ...
- Owner: ...
- Date: $(date +%F)

# Evidence
- Source: docs/... (link)
- PR/Commit: ...

# Open Questions
- [ ] ...

# Links
- Related ADR: docs/adr/...
- Related Doc: docs/...
EOF
}

# Generate per-phase memory files
write_phase_mem "01-requirements.md"       "01-requirements"
write_phase_mem "02-user-stories.md"       "02-user-stories"
write_phase_mem "03-architecture.md"       "03-architecture"
write_phase_mem "04-architecture-docs.md"  "04-architecture-docs"
write_phase_mem "05-implementation.md"     "05-implementation"
write_phase_mem "06-code-docs.md"          "06-code-docs"
write_phase_mem "07-testing.md"            "07-testing"
write_phase_mem "08-deployment.md"         "08-deployment"
write_phase_mem "09-release-notes.md"      "09-release-notes"
write_phase_mem "10-security.md"           "10-security"
write_phase_mem "11-memory.md"             "11-memory"
write_phase_mem "12-memory-window.md"      "12-memory-window"
write_phase_mem "13-memory-sync.md"        "13-memory-sync"
write_phase_mem "14-error-recovery.md"     "14-error-recovery"
write_phase_mem "15-integration-test.md"   "15-integration-test"
write_phase_mem "16-customize.md"          "16-customize"

# Generate usage guide
echo -e "${YELLOW}Creating usage guide...${NC}"
write_file docs/framework/usage-guide.md << EOF
# ${PROJECT_NAME} Framework Usage Guide

## Quick Start

### 1. Starting a New Phase
1. Start a new GitHub Copilot Chat
2. Type \`/01-requirements\` (or another phase name) to load the prompt phase (example, use backticks in markdown)

### 2. Memory Management
- **Before each phase**: Read the matching per-phase file in \`docs/memory/\` and skim \`docs/memory/index.md\`.
- **After each phase**: Append a structured entry (frontmatter + sections) to the per-phase file and add a one-line summary in the index.
- **Weekly**: Prune big/old entries to \`docs/memory-archive/\` and leave a pointer in the per-phase file.

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
    ├── memory/                      # Structured per-phase memory
    │   ├── index.md                 # Memory index and navigation
    │   ├── 01-requirements.md       # Requirements phase memory
    │   ├── 02-user-stories.md       # User stories phase memory
    │   └── ...                      # Other phase memory files
    ├── memory-archive/              # Archived memory entries
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
