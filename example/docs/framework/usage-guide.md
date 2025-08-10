# Demo Framework Usage Guide

## Quick Start

### 1. Starting a New Phase
1. Start a new GitHub Copilot Chat
2. Type `/01-requirements` (or another phase name) to load the prompt phase (example, use backticks in markdown)

### 2. Memory Management
- **Before each phase**: Read the matching per-phase file in `docs/memory/` and skim `docs/memory/index.md`.
- **After each phase**: Append a structured entry (frontmatter + sections) to the per-phase file and add a one-line summary in the index.
- **Weekly**: Prune big/old entries to `docs/memory-archive/` and leave a pointer in the per-phase file.

### 3. Team Collaboration
- Use memory sync prompts for team coordination
- Follow ADR conventions for architectural decisions
- Tag all memory entries consistently for easy filtering

## Phase Workflow

The framework includes 16 phases organized in logical sequence:

### Core Development Phases
1. **Requirements** (`01-requirements.prompt.md`) - Business Analyst
2. **User Stories** (`02-user-stories.prompt.md`) - Product Owner
3. **Architecture** (`03-architecture.prompt.md`) - Software Architect
4. **Architecture Docs** (`04-architecture-docs.prompt.md`) - Technical Writer
5. **Implementation** (`05-implementation.prompt.md`) - Developer
6. **Code Documentation** (`06-code-docs.prompt.md`) - Developer
7. **Testing** (`07-testing.prompt.md`) - QA Engineer
8. **Deployment** (`08-deployment.prompt.md`) - DevOps Engineer
9. **Release Notes** (`09-release-notes.prompt.md`) - Technical Writer
10. **Security Review** (`10-security.prompt.md`) - Security Engineer

### Meta Phases
11. **Memory Update** (`11-memory.prompt.md`) - Memory Curator
12. **Memory Pruning** (`12-memory-window.prompt.md`) - Memory Curator
13. **Memory Sync** (`13-memory-sync.prompt.md`) - Memory Curator
14. **Error Recovery** (`14-error-recovery.prompt.md`) - Recovery Specialist
15. **Integration Test** (`15-integration-test.prompt.md`) - QA Engineer
16. **Customization** (`16-customize.prompt.md`) - Framework Engineer

## Configuration

### Team-Level Customization
Edit `.github/config/team-config.yml`:
- Modify team-specific standards
- Add custom tags
- Adjust memory retention policies

### Phase-Level Customization
Edit individual prompt files in `.github/prompts/`:
- Customize role descriptions
- Add team-specific outputs
- Modify self-critique criteria

## File Structure

```
Demo/
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
```

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

**View all diagrams**: See `docs/framework/workflow-diagrams.md` for complete visual documentation.

## Best Practices

1. **Always load memory context** before starting a new phase
2. **Tag entries consistently** using the taxonomy in `tags.yml`
3. **Update memory immediately** after completing phase work
4. **Run self-critique** to catch issues early
5. **Sync with team regularly** using memory sync prompts

## Troubleshooting

### Common Issues
- **Memory too large**: Use memory pruning prompt (`12-memory-window.prompt.md`)
- **Missing dependencies**: Check `phase-config.yml` for requirements
- **Team conflicts**: Use memory sync prompt (`13-memory-sync.prompt.md`)
- **Phase errors**: Use error recovery prompt (`14-error-recovery.prompt.md`)

### Getting Help
1. Check this usage guide
2. Review prompt template frontmatter for requirements
3. Consult team configuration files
4. Use integration test prompt to validate setup

---

**Framework Version**: 1.0
**Created**: 2025-08-09 19:27:51
**Team**: Core
