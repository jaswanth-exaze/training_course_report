# Module 18: CI/CD Testing

---

## Module Overview

Tests only protect your team if they actually run — automatically, on every change, before code reaches production. This module covers integrating your Flutter test suite (unit, widget, golden, integration) into a CI/CD pipeline, using GitHub Actions as the primary example, plus strategies for keeping pipelines fast and reliable at scale.

---

## Learning Objectives

- Understand the role of CI/CD in a testing strategy.
- Build a GitHub Actions workflow that runs Flutter tests automatically.
- Enforce code coverage thresholds and quality gates in CI.
- Run different test layers (unit/widget vs. integration vs. golden) with appropriate CI strategies.
- Apply strategies for parallelization and caching to keep CI fast as the suite grows.

---

## Prerequisites

- Modules 05–17

---

## Theory

### Why CI/CD Is Where Testing Strategy Actually Pays Off

Every principle from this course — the Test Pyramid, FIRST principles, coverage discipline, test architecture — only delivers real value if tests run **consistently and automatically**. A test suite that only runs when a developer remembers to run it locally is not a safety net; it's a suggestion.

CI/CD (Continuous Integration / Continuous Delivery) automates running your test suite on every code change, providing:
- **Fast feedback**: developers learn about regressions within minutes, not after a release.
- **Consistency**: tests always run in the same clean environment (recall Module 15's golden-test platform-consistency problem — this is exactly why).
- **A quality gate**: merges/releases can be blocked automatically if tests fail.

### A Basic GitHub Actions Workflow

```yaml
# .github/workflows/test.yml
name: Flutter Tests

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze

      - name: Run tests with coverage
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          sudo apt-get install -y lcov
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | grep -oP '\d+\.\d+(?=%)')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage below 80% threshold"
            exit 1
          fi

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info
```

Running on **Linux CI** (Ubuntu) is deliberate — recall Module 15's golden testing platform-consistency problem: generating and comparing golden files in a consistent Linux environment avoids the flakiness that arises from macOS/Windows font rendering differences.

### Layering CI Strategy by Test Type

Not all test types should run on every trigger with the same frequency, given the cost/speed tradeoffs established in Module 14.

| Test Type | Trigger | Rationale |
|---|---|---|
| Unit + Widget tests | Every push/PR | Fast (seconds), cheap, run constantly |
| Golden tests | Every push/PR | Fast, but only reliable if run in consistent (Linux) environment |
| Integration tests (fake backend) | Every push/PR, or on a subset of critical PRs | Slower; some teams run only on `main`/release branches |
| Integration tests (real staging backend) | Nightly / scheduled | Slow, network-dependent; not suitable for blocking every PR |

```yaml
# Nightly job for real-backend integration tests
on:
  schedule:
    - cron: '0 2 * * *' # 2 AM daily
```

### Enforcing Quality Gates

Beyond running tests, CI can **block merges** based on:
- All tests passing (baseline requirement).
- Coverage not regressing below a threshold, or not dropping compared to the base branch (Module 16).
- `flutter analyze` passing with zero warnings/errors (static analysis, complementary to testing).
- No new golden file changes without explicit review/approval (Module 15).

Branch protection rules in GitHub (or equivalent in GitLab/Bitbucket) enforce that these checks must pass before a PR can be merged — turning "we should write tests" into "the pipeline literally won't let you merge without passing tests."

### Keeping CI Fast at Scale

As a Flutter project and its test suite grow, naive CI pipelines slow down. Key strategies:

1. **Caching dependencies**: cache `~/.pub-cache` and Flutter SDK installation between runs.
   ```yaml
   - uses: actions/cache@v4
     with:
       path: |
         ~/.pub-cache
       key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
   ```
2. **Parallelization/sharding**: split the test suite across multiple parallel CI jobs (e.g., by folder) and merge results.
3. **Fail fast**: run `flutter analyze` and unit tests (fastest) before widget/golden/integration tests, so obviously broken PRs fail in seconds, not minutes.
4. **Selective test running**: on very large monorepos, some teams run only tests affected by changed files for draft/early PRs, running the full suite before merge.

```text
Pipeline order (fail-fast):
flutter analyze (seconds)
        │
        ▼
Unit tests (seconds)
        │
        ▼
Widget + Golden tests (tens of seconds)
        │
        ▼
Integration tests, fake backend (minutes)
```

### Flaky Test Handling in CI

Module 17 identified tolerated flakiness as an architectural decay signal. In CI specifically, teams need an explicit policy:
- **Never** auto-retry-and-ignore flaky tests silently — this hides real bugs (race conditions, timing issues) and erodes trust in the whole suite.
- Quarantine genuinely flaky tests (tag them, exclude from blocking CI, but track them with an owner and a deadline to fix) rather than deleting them or ignoring failures forever.

---

## Flutter Perspective

Flutter's official tooling integrates cleanly with virtually any CI provider (GitHub Actions, GitLab CI, Bitrise, Codemagic — the latter two specialize in mobile CI/CD with built-in code-signing support for app store deployment). The `subosito/flutter-action` GitHub Action shown above is the most widely used community action for pinning a specific Flutter SDK version in CI — version-pinning matters because Flutter SDK upgrades can occasionally shift golden-test rendering output (Module 15) or widget test framework behavior.

---

## Diagrams

### CI/CD Testing Pipeline Overview

```text
Developer pushes commit / opens PR
              │
              ▼
     ┌─────────────────┐
     │  flutter analyze  │ ── fail fast on static issues
     └─────────────────┘
              │ pass
              ▼
     ┌─────────────────┐
     │   Unit tests      │
     └─────────────────┘
              │ pass
              ▼
     ┌─────────────────┐
     │ Widget + Golden   │
     │      tests         │
     └─────────────────┘
              │ pass
              ▼
     ┌─────────────────┐
     │ Coverage check     │ ── block if regressed
     └─────────────────┘
              │ pass
              ▼
       PR eligible to merge
              │
     (nightly, separate pipeline)
              ▼
     ┌─────────────────┐
     │ Integration tests  │
     │ (real backend)     │
     └─────────────────┘
```

---

## Code Examples

### Coverage Diff Enforcement (Conceptual)

```yaml
- name: Compare coverage to base branch
  run: |
    # Simplified concept: fetch base branch coverage, compare to current
    CURRENT=$(lcov --summary coverage/lcov.info | grep -oP '\d+\.\d+(?=%)')
    BASE=$(cat .github/base_coverage.txt)
    if (( $(echo "$CURRENT < $BASE" | bc -l) )); then
      echo "Coverage regressed from $BASE% to $CURRENT%"
      exit 1
    fi
```

### Tagging and Excluding Flaky/Slow Tests

```dart
test('known flaky test - tracked in JIRA-1234', () {
  // ...
}, tags: ['flaky']);
```

```bash
flutter test --exclude-tags=flaky   # blocking CI run
flutter test --tags=flaky            # separate, non-blocking monitoring job
```

---

## Step-by-Step Explanation

1. Set up a CI workflow file triggered on `push`/`pull_request`.
2. Pin the Flutter SDK version explicitly for consistency.
3. Run `flutter analyze` first for fast static-analysis failure.
4. Run `flutter test --coverage` for unit, widget, and golden tests.
5. Enforce a coverage threshold or regression check as a merge-blocking gate.
6. Schedule slower integration tests (especially real-backend ones) on a separate, less frequent trigger (nightly/scheduled).
7. Tag and quarantine flaky tests explicitly rather than tolerating silent failures.

---

## Best Practices

- Pin exact Flutter SDK versions in CI to avoid unexpected golden/widget test drift.
- Order pipeline steps fastest-to-slowest for fail-fast feedback.
- Enforce coverage as a *regression* check (compared to base branch) rather than only a static threshold.
- Run real-backend integration tests on a schedule, not on every PR.
- Cache dependencies aggressively to keep CI runtime manageable as the suite grows.

---

## Common Mistakes

- Running slow, real-backend integration tests on every single PR, causing painfully slow feedback loops.
- Auto-retrying flaky tests silently instead of tracking and fixing them.
- Not pinning the Flutter SDK version, causing CI failures unrelated to actual code changes after SDK upgrades.
- Treating `flutter analyze` and tests as optional/non-blocking, undermining the entire quality-gate purpose of CI.

---

## Interview Questions

1. Why is a testing strategy incomplete without CI/CD integration?
2. Why should golden tests be run in a consistent environment like Linux-based CI rather than relying on local developer runs?
3. How would you structure a CI pipeline to fail fast while still covering unit, widget, golden, and integration tests?
4. What's the risk of silently auto-retrying flaky tests in CI, and what's a better policy?
5. Why might a team run real-backend integration tests nightly instead of on every pull request?

---

## Exercises

1. Write a GitHub Actions workflow YAML that runs `flutter analyze` and `flutter test` on every pull request, failing fast on analyze errors.
2. Design a tagging strategy (using Dart test `tags`) to separate fast blocking tests from slow/flaky ones in CI.
3. Propose a coverage-regression-check script (pseudocode is fine) that compares current PR coverage to the `main` branch's coverage.

---

## Mini Project

Set up a complete CI pipeline (as a YAML file, testable conceptually even without a live repo) for a Flutter project that: runs analyze, unit, widget, and golden tests on every PR; enforces an 80% coverage threshold; caches pub dependencies; and runs a separate nightly job for real-backend integration tests.

---

## Assignment

Take (or design) a Flutter project's existing CI setup. Audit it against this module's best practices: Is the SDK version pinned? Is the pipeline ordered fail-fast? Are coverage regressions checked? Is there a flaky-test policy? Write a short improvement proposal addressing any gaps found.

---

## Summary

- CI/CD is what turns a testing strategy from aspirational into actually enforced.
- GitHub Actions (or equivalent) can run `flutter analyze`, unit/widget/golden tests, and coverage checks automatically on every PR.
- Different test layers warrant different CI triggers/frequencies based on their speed/cost (fast tests on every PR, slow real-backend tests nightly).
- Quality gates (coverage thresholds, analyze, test pass/fail) should block merges, not just report status.
- Flaky tests need an explicit quarantine-and-track policy, never silent tolerance.

---

## Revision Notes

- CI/CD = where testing strategy actually gets enforced
- Order: analyze → unit → widget/golden → coverage gate → (nightly) integration
- Pin Flutter SDK version; run golden tests on consistent (Linux) CI
- Coverage regression checks > static thresholds alone
- Flaky tests: tag, quarantine, track — never silently retry-and-ignore

---

## Next Module

Continue with **19_Test_Driven_Development.md**.
