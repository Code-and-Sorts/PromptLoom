# Demo - Development Instructions

# Project Context
This is Demo built with TypeScript/React/Node.
Team: Core
Specializations: Frontend,Backend,Testing

# Development Standards
- Follow project language and markdown style conventions
- Update README and docs when adding code or changing behavior
- Generate inline documentation for public APIs where applicable
- Run security checks appropriate to the stack (e.g., dependency and secret scans)
- Enforce ADR conventions in docs/adr/
- Bind and use capabilities from .github/config/capabilities.yml (tools are suggestions, not mandates)

# Memory Management
- Before starting any phase, read the relevant **per-phase** memory file under `docs/memory/` (e.g., `03-architecture.md`) and skim `docs/memory/index.md` "Recent Activity"
- Load only the **last few entries** from the current phase file to reduce context bloat
- When you finish a phase, **append a new entry** to that phase's file using the schema at the top of the file
- Include `sources:` links (ADRs, PRs, docs) and set a `confidence` level
- Add a one-line summary + link in `docs/memory/index.md` under "Recent Activity"
- Use tags from `.github/config/tags.yml`
- Prune or archive older content into `docs/memory-archive/` when entries get large

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
- Unit tests command: null
- E2E tests command: null
- Contract tests command: null
- Performance tests command: null
- Docs generator command: null
- Linter command: null
(Edit .github/config/capabilities.yml to bind or change these. Optionally run with --suggest to generate capability_suggestions.yml for review.)
