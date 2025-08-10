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
