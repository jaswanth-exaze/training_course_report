# Module 22: Capstone Project

---

## Module Overview

This is the final module of the Flutter Testing Master Course. Instead of introducing new material, it asks you to independently design, build, and fully test a complete Flutter application — applying every principle, technique, and tool from Modules 01 through 21 as a cohesive whole, exactly as you would on a professional engineering team.

---

## Learning Objectives

- Independently plan a complete test strategy for a real application, from scratch.
- Apply the full testing stack: unit, mocking, BLoC, repository, API, local storage, widget, navigation, golden, integration, coverage, CI/CD, and TDD where appropriate.
- Make and justify professional testing tradeoffs under realistic constraints.
- Produce a portfolio-quality artifact demonstrating mastery of Flutter testing.

---

## Prerequisites

- Modules 01–21 (all of them)

---

## Capstone Project Brief

### Build: "TaskFlow" — A Task Management App

You will build and fully test a task management app with the following features:

1. **Authentication** — email/password login (can be a fake/mock backend; real auth infra is out of scope).
2. **Task List** — fetch tasks from an API, cache locally, display with loading/empty/error states.
3. **Task Details & Editing** — view and edit a task's title, description, due date, and priority.
4. **Task Completion** — mark tasks complete/incomplete, with a running "X of Y completed" summary.
5. **Filtering & Search** — filter by status (all/active/completed) and search by title.
6. **Offline Support** — the app must gracefully fall back to cached data when the network is unavailable.
7. **Navigation** — multi-screen flow (Login → Task List → Task Details → Edit Task) using `go_router`.

### Required Architecture

Follow the layered Clean Architecture structure used throughout this course:

```text
lib/features/tasks/
├── data/ (datasources, models, repository impl)
├── domain/ (entities, abstract repository, use cases)
└── presentation/ (cubits/blocs, screens, widgets)
```

### Required Test Coverage

Your capstone submission must include, at minimum:

| Layer | Requirement |
|---|---|
| Domain entities | Full `fromJson`/`toJson`/`copyWith`/equality tests (Module 06) |
| Use cases | At least 2 use cases (e.g., `FilterTasksUseCase`, `CalculateCompletionUseCase`) with EP+BVA-derived tests (Modules 04, 06) |
| Remote data source | Mocked HTTP client, covering success + at least 3 failure branches (Module 12) |
| Local data source | `SharedPreferences` or database-backed caching, with freshness logic tested (Module 13) |
| Repository | Remote-first/cache-fallback decision table fully tested (Module 11) |
| Cubits/BLoCs | At least 2, using `bloc_test`, covering all state sequences including errors (Module 10) |
| Widget tests | At least 4 screens/widgets, covering all meaningful UI states (Module 08) |
| Navigation tests | At least 2 navigation flows tested, including argument passing (Module 09) |
| Golden tests | At least 2 reusable components (e.g., `TaskCard`, `PriorityBadge`) (Module 15) |
| Integration test | 1 complete critical user journey: login → view tasks → complete a task (Module 14) |
| Coverage | Generate and include an `lcov` report; document your risk-weighted coverage rationale (Module 16) |
| CI/CD | A working GitHub Actions (or equivalent) workflow YAML file (Module 18) |
| TDD | At least one feature/bug fix built and documented using explicit Red-Green-Refactor cycles (Module 19) |
| Test architecture | `test/fixtures`, `test/helpers`, `test/mocks` structure in place (Module 17) |

### Deliverables

1. The full Flutter project source code (`lib/` and `test/`/`integration_test/`).
2. A `TESTING_STRATEGY.md` document (1-2 pages) explaining:
   - Your risk-weighted prioritization decisions (what got the most test investment, and why).
   - Your coverage numbers per layer, with rationale for any gaps.
   - Your CI/CD pipeline design and quality gates.
   - At least one TDD cycle log (Red-Green-Refactor steps documented).
3. A short reflection (half a page) on which testing techniques from the course felt highest-leverage for this project, and which felt like overkill — and why.

---

## Suggested Timeline

| Phase | Focus | Modules Applied |
|---|---|---|
| 1 | Domain layer + use cases (TDD encouraged here) | 04, 05, 06, 19 |
| 2 | Data sources + repository | 07, 11, 12, 13 |
| 3 | Cubits/BLoCs | 10 |
| 4 | Screens + navigation + widget tests | 08, 09 |
| 5 | Golden tests + accessibility pass | 15, 21 |
| 6 | Integration test + full user journey | 14 |
| 7 | Coverage analysis + gap-filling | 16 |
| 8 | CI/CD pipeline setup | 18 |
| 9 | Test architecture cleanup + documentation | 17 |
| 10 | Final review + reflection writeup | — |

---

## Evaluation Rubric (Self-Assessment)

Use this rubric to self-assess your capstone before considering it complete.

**Architecture & Testability (20%)**
- [ ] Clear separation of data/domain/presentation layers.
- [ ] All external dependencies depend on abstractions (mockable per Module 07).
- [ ] Dependency injection composition root clearly identifiable.

**Test Coverage Breadth (25%)**
- [ ] Every required layer from the table above has tests.
- [ ] Test Pyramid shape is visible in the actual test count (many unit, some widget, few integration).
- [ ] Coverage report generated and gaps are risk-justified, not arbitrary.

**Test Quality (25%)**
- [ ] Tests follow FIRST principles (Module 02).
- [ ] Test design techniques (EP, BVA, decision tables, state transitions — Module 04) are visibly applied, not just happy-path testing.
- [ ] Mocking is used correctly and only at appropriate boundaries (Module 07/11 discipline).
- [ ] BLoC tests assert exact state sequences, not just final state.

**Test Architecture (15%)**
- [ ] Fixtures/builders reduce duplication (Module 17).
- [ ] Shared helpers exist for common setup (widget pumping, mock registration).
- [ ] Folder structure mirrors `lib/`.

**Professional Practices (15%)**
- [ ] CI/CD pipeline runs tests automatically and enforces a quality gate.
- [ ] At least one documented TDD cycle.
- [ ] `TESTING_STRATEGY.md` clearly articulates prioritization reasoning, not just a checklist of what was done.

---

## Reflection Prompts

Answer these in your final reflection document:

1. Which testing layer took the most time relative to the confidence it provided? Was that time well spent?
2. If you had half the time, which tests would you cut first, and why? (This directly exercises Module 20's prioritization skill.)
3. Did TDD change how you designed any part of your domain or Cubit logic? How?
4. What's one testing technique from this course you expect to use constantly in future projects, and one you expect to use rarely?
5. If a new engineer joined your "team" tomorrow, what would your test suite communicate to them about how the app is supposed to behave — without them reading a single line of production code?

---

## Final Words

If you have completed this capstone honestly and thoroughly, you now possess something most Flutter developers never build for themselves: a complete, working mental model of how professional testing actually functions across an entire application, from a single boundary-value test case up through a CI/CD pipeline enforcing quality on every commit.

Testing is not a phase you complete and move past — it's a discipline you carry into every feature you build from here forward. The specific APIs (`bloc_test`, `mocktail`, `golden_toolkit`) will evolve. The underlying judgment — what to test, how deeply, and why — is what you've actually built in this course, and that judgment will remain valuable for the rest of your career.

**Congratulations on completing the Flutter Testing Master Course.**

---

## Course Complete

You have finished all 22 modules:

00 → 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11 → 12 → 13 → 14 → 15 → 16 → 17 → 18 → 19 → 20 → 21 → 22

Go build something well-tested.
