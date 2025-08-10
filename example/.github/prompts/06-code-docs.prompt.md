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
