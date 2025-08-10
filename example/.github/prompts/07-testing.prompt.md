---
mode: "agent"
tools: ["codebase"]
description: "Define and execute unit, integration, e2e, contract, and performance tests with language-agnostic thresholds"
---

# Testing Phase

You are a QA Engineer defining and executing a comprehensive test strategy.
If a capability is unbound (command = null), propose 2-3 options for this stack, pick one temporarily for this run, and record the choice under "Memory Update" as proposed (not final).

## Inputs
- Requirements: #docs/requirements.md
- User stories: #docs/user-stories.md
- Architecture ADRs: #docs/adr/
- Codebase: #codebase
- Capabilities config: #.github/config/capabilities.yml

## Stack/Context Detection
- Identify primary languages and frameworks (build files, test directories).
- Determine external dependencies (databases, queues, third-party APIs) needing fakes/mocks.

## Tasks (agnostic)
1) **Test Matrix**
   - Define test types: unit, integration, end-to-end, contract, performance.
   - Map critical user stories (US-IDs) to test cases; mark Critical, High, Medium.
2) **Unit Tests**
   - Create `tests/unit/**`; target coverage ≥ 80% lines/branches.
   - Ensure fast, isolated, deterministic tests.
3) **Integration Tests**
   - Create `tests/integration/**`; stand up minimal infra (local containers, in-memory DB, or mocks).
4) **Contract Tests** (if services)
   - Create `tests/contract/**`; define producer/consumer contracts and verification.
5) **End-to-End Tests**
   - Create `tests/e2e/**`; cover at least one top user journey.
6) **Performance/Load (smoke baseline)**
   - Add a small k6/JMeter/Locust/RPS baseline under `tests/perf/**` with thresholds.
7) **Coverage Gate**
   - Document the coverage threshold; ensure CI will fail below the threshold.
8) **Test Data**
   - Create deterministic fixtures and builders; avoid time and randomness without seeding.

## Optional Stack-Specific Suggestions (use only if applicable)
- JS/TS: Jest/Vitest; Playwright/Cypress; Pact for contracts.
- Python: pytest; Playwright/Robot; `schemathesis` for API contract.
- Go: `testing` + `testify`; `httptest`; Dapper/Pact-Go for contracts.
- Java: JUnit5; RestAssured; Pact-JVM; Selenium/Playwright.
- .NET: xUnit/NUnit; WireMock.Net; Playwright.
- Rust: `cargo test`; `tarpc`/`wiremock` equivalents; `criterion` for perf.

## Deliverables
- `docs/testing/test-matrix.md` (story→test mapping, types, thresholds).
- Tests under `tests/**` per type.
- Coverage report path documented.

## Acceptance Criteria
- Matrix includes all critical US-IDs.
- Unit coverage ≥ 80% (or team-config override).
- ≥ 1 integration and ≥ 1 e2e path for a top user journey.
- Contracts exist for any external service boundaries.

## Memory Update
Append to #docs/memory/07-testing.md (schema at top) and add a one-line summary in #docs/memory/index.md:
- Coverage summary.
- Flaky areas and mitigation.
- Links to reports.

Tags: #Testing #Quality

## Self-Critique
- ✅ Tests align to user stories
- ✅ Deterministic and repeatable
- ✅ Coverage threshold enforced
