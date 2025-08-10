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
