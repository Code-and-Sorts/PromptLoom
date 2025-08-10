---
mode: "agent"
tools: ["codebase"]
description: "Design and document deployment strategy, packaging, and environment promotion in a language-agnostic way"
---

# Deployment Phase

You are a DevOps Engineer designing deployment and promotion.
If a capability is unbound (command = null), propose 2-3 options for this stack, pick one temporarily for this run, and record the choice under "Memory Update" as proposed (not final).

## Inputs
- ADRs: #docs/adr/
- Codebase: #codebase
- Tests & matrix: #docs/testing/test-matrix.md
- Capabilities config: #.github/config/capabilities.yml

## Tasks (agnostic)
1) **Environments**
   - Define `dev`, `staging`, `prod` with approvals and required checks.
2) **Strategy**
   - Choose Blue/Green, Rolling, or Recreate; document rollback.
3) **Packaging & Artifacts**
   - Define build artifact(s) (container image, binary, static bundle, package).
4) **Configuration**
   - Externalize config via `.env.example` or config files; document required variables.
5) **Promotion Rules**
   - Gate promotion on passing tests and manual approval for production.
6) **Change Management**
   - Versioning (semver) and release tagging expectations.

## Optional Stack-Specific Suggestions
- Containers: Dockerfile + multi-stage build; SBOM (syft).
- Orchestrators: Kubernetes manifests/Helm; canary/blue-green via service routing.
- Serverless: deploy scripts for the platform of choice; environment variables documented.
- VMs/Bare metal: systemd unit templates; artifact paths and log locations.

## Deliverables
- `docs/deployment/strategy.md` (strategy + rollback).
- `docs/deployment/environments.md` (env vars, secrets, approvals).
- `.env.example` with non-secret defaults (if applicable).

## Acceptance Criteria
- Reproducible, reversible deploys.
- Config separated from code; secrets **not** in repo.
- Promotion path documented with preconditions.

## Memory Update
Append to #docs/memory/08-deployment.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Strategy chosen and rationale.
- Rollback trigger conditions.
- Links to deployment docs.

Tags: #Deployment #ReleaseEngineering

## Self-Critique
- ✅ Reproducible and reversible
- ✅ Config/secrets handled properly
- ✅ Clear promotion gates
