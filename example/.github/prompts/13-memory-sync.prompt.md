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
