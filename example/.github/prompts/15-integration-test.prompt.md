---
mode: "agent"
tools: ["codebase"]
description: "Run cross-service/integration tests and document results in a language-agnostic way"
---

# Integration Test Phase

You are a QA Engineer.

## Inputs
- Test matrix: #docs/testing/test-matrix.md
- Codebase and services

## Tasks
1) Identify top 3 cross-cutting flows (e.g., user signup → notification → data persisted).
2) Write integration tests covering those flows.
3) Capture test environment and data setup steps.
4) Generate a results report.

## Optional Tooling Suggestions
- HTTP/API: Postman/Newman, RestAssured, supertest, httpx/pytest.
- UI: Playwright/Selenium.
- Messaging: Testcontainers/fakes/mocks appropriate to the stack.

## Deliverables
- `tests/integration/**` coverage for chosen flows.
- `docs/testing/integration-results.md`.

## Acceptance Criteria
- Each flow has at least one passing test.
- Results document includes environment and data setup.

## Memory Update
Append to #docs/memory/15-integration-test.md (schema at top) and add a one-line summary in #docs/memory/index.md with links to tests and results.

Tags: #IntegrationTest #Quality

## Self-Critique
- ✅ Critical paths covered
- ✅ Repeatable environment steps
