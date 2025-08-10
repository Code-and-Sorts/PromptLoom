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
