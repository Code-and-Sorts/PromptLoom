# PromptLoom

PromptLoom is a framework generator and workflow for AI-driven software development. It creates a complete directory structure, configuration files, prompt templates, and documentation to help teams use GitHub Copilot Chat and agent workflows for every phase of development.

---

## What is PromptLoom?

PromptLoom sets up a Copilot-centric development environment, including:
- Directory structure for prompts, config, memory, and ADRs
- 16-phase prompt templates for Copilot Chat and agent workflows
- Team and phase configuration files
- Memory management and tagging system
- Usage guides and workflow diagrams

## Where does it work?

PromptLoom is designed for TypeScript/React/Node.js projects, but is flexible for other stacks. It creates a `.github` folder for prompts, config, plus a `docs` folder for memory, ADRs, and framework guides.

## Why use PromptLoom?

### Consistency

Covers every development phase with clear instructions and templates.

### Collaboration

Supports team workflows, memory sync, and documentation standards.

### Quality

Enforces linting, testing, security checks, and ADRs.

### AI Integration

Optimized for Copilot Chat and agentic workflows.

## How to Use

### 1. Run the Setup Script Remotely (No Download Required)

```bash
bash <(curl -sSL https://raw.githubusercontent.com/Code-and-Sorts/PromptLoom/main/generate.sh)
```

You’ll be prompted for project name, team, tech stack, specializations, and custom tags. The script will generate all necessary folders and files in your current directory.

**Prerequisites:**
- Bash shell (macOS/Linux/WSL recommended)
- GitHub Copilot Chat extension in VS Code for agent workflow

**Note:** The setup script creates the directory structure and stub files. The actual content for requirements, user stories, architecture, etc. is generated interactively during each development phase using the prompt templates and Copilot Chat.

### 2. Review the Generated Structure

- `.github/copilot-instructions.md` - Main development standards and workflow
- `.github/prompts/` - 16 phase prompt templates for Copilot Chat and agent workflows
- `.github/config/` - Team, phase, and tag configuration files
- `docs/adr/` - Architecture Decision Records
- `docs/memory.md` - Project memory and timeline
- `docs/framework/` - Usage guide and workflow diagrams

### 3. Start a Development Phase

- Open Copilot `Agent` Chat in VS Code
- In the chat, type `/{promptName}` and run the prompt (ex. `/01-requirements`)

**Example Phase Prompt:**

```markdown
# Requirements Gathering Phase

You are a Business Analyst working on the project.

## Your Task
1. Stakeholder Analysis
2. Functional Requirements
3. Non-functional Requirements
4. Constraints

## Output Format
Create a comprehensive requirements document with:
- Stakeholder Analysis
- Functional Requirements
- Non-functional Requirements
- Constraints and Dependencies
```

### 4. Customize for Your Team

- Edit `.github/config/team-config.yml` for team standards and tags
- Adjust prompt templates for your workflow
- Use ADRs for architectural decisions

---

## Documentation

- **Usage Guide:** See `docs/framework/usage-guide.md` for step-by-step instructions
- **Workflow Diagrams:** See `docs/framework/workflow-diagrams.md` for Mermaid visualizations
- **Memory Management:** Follow tagging and update conventions in `docs/memory.md`

---

## Contributing

Contributions are welcome! Please open issues or pull requests for improvements, bug fixes, or new features.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---

## Getting Help

- Review the usage guide and prompt templates
- Check configuration files for standards and retention policies
- Use Copilot Chat and agent mode for phase guidance and troubleshooting

---
