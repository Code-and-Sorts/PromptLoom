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
