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
