# Module 16: Code Coverage

---

## Module Overview

Code coverage measures which lines/branches of your code were executed during test runs — a useful diagnostic tool, but a dangerous target if misunderstood. This module covers generating, reading, and interpreting Flutter code coverage reports, and — critically — why coverage percentage alone is not a proxy for test quality.

---

## Learning Objectives

- Generate code coverage reports using `flutter test --coverage`.
- Interpret LCOV coverage data and HTML reports.
- Distinguish line coverage from branch coverage.
- Set meaningful, risk-based coverage targets instead of arbitrary percentages.
- Recognize coverage's real value: finding *untested* code, not proving correctness.

---

## Prerequisites

- Modules 05–14

---

## Theory

### What Code Coverage Actually Measures

Code coverage tells you **which lines of source code were executed** while your test suite ran — nothing more. It does *not* tell you:
- Whether the test asserted anything meaningful about that code
- Whether the test covers realistic inputs
- Whether the code is *correct*

Recall from Module 01: testing shows the *presence* of defects, not their absence — coverage doesn't change that. A line can be "covered" by a test with zero assertions and still be completely unverified.

```dart
// "100% covered" but proves nothing:
test('calls the function', () {
  calculateDiscount(100, 0.1); // executed, but result never checked!
});
```

### Line Coverage vs. Branch Coverage

| Type | Measures | Example gap it can miss |
|---|---|---|
| **Line coverage** | Which lines executed | `if (a && b)` — line covered even if `b` was never actually evaluated as false |
| **Branch coverage** | Which conditional branches (true/false paths) executed | Catches the above — ensures both `if` and `else` paths ran |

Flutter's default `flutter test --coverage` produces **line coverage** (LCOV format). Branch-level analysis requires additional tooling or careful manual test design using the decision-table technique from Module 04.

### Generating a Coverage Report

```bash
flutter test --coverage
```

This produces `coverage/lcov.info`. To view it as readable HTML:

```bash
# requires lcov installed (brew install lcov / apt install lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Reading the LCOV Report

```text
lib/usecase/calculate_total_usecase.dart
  Lines: 18/20 (90.0%)
  Uncovered: 45, 52
```

This tells you exactly which lines (45, 52) never executed during any test — a precise, actionable signal for *where to add tests*, which is coverage's real value.

### Why 100% Coverage Is the Wrong Goal

Chasing 100% coverage as a vanity metric leads to well-documented anti-patterns:
- Tests written just to "touch" a line, with weak or missing assertions (as shown above).
- Excessive time spent testing trivial, low-risk code (a `toString()` override) at the expense of testing complex, high-risk logic more thoroughly.
- Coverage tooling gamed by excluding files (`// coverage:ignore-file`) rather than genuinely improving weak areas.

Recall Module 02's defect clustering principle: a small number of modules contain most defects. Coverage effort should be **risk-weighted**, not uniformly maximized.

### Setting Meaningful Coverage Targets

A more mature approach than "we require 90% coverage everywhere":

| Code Category | Suggested Target | Rationale |
|---|---|---|
| Business logic (use cases, BLoCs) | High (85%+) | High risk, high defect density |
| Repositories, data sources | High (80%+) | Coordination bugs are costly |
| Simple data models | Moderate (auto via `fromJson`/`toJson`/`copyWith` tests) | Low complexity, but easy to test fully |
| UI/widget composition code | Lower priority for line coverage; covered via widget/golden tests instead | Coverage % is a poor proxy for UI correctness |
| Generated code (`.g.dart`, `.freezed.dart`) | Excluded from coverage entirely | Not hand-written, not meaningfully "tested" |

### Excluding Generated/Irrelevant Code

```dart
// coverage:ignore-file
```
or, more surgically:
```dart
// coverage:ignore-start
...
// coverage:ignore-end
```

Common exclusions: generated code (`*.g.dart`, `*.freezed.dart`), auto-generated route files, and trivial boilerplate (simple `toString()` overrides) — used sparingly and deliberately, never to hide genuinely untested risky logic.

### Enforcing Coverage in CI

Coverage thresholds can be enforced automatically (previewed here, detailed in Module 18):

```bash
# Fail CI if total coverage drops below 80%
lcov --summary coverage/lcov.info
```

Many teams use tools like Codecov or Coveralls to track coverage trends over time and flag coverage *regressions* on pull requests — a more useful signal than a single static threshold, since it catches a PR that adds untested new code even if overall coverage looks acceptable.

---

## Flutter Perspective

Coverage in Flutter projects has a Flutter-specific nuance: `flutter test --coverage` only measures coverage for code exercised by your **unit and widget tests** — it does not include `integration_test` runs by default (those require a separate, more involved coverage collection setup). This means a Flutter project's headline coverage number typically reflects unit/widget test coverage only, and teams should be aware critical user journeys covered *only* by integration tests won't show up in that number.

---

## Diagrams

### Coverage Report Flow

```text
flutter test --coverage
        │
        ▼
coverage/lcov.info generated
        │
        ▼
genhtml coverage/lcov.info -o coverage/html
        │
        ▼
Open HTML report ──► identify uncovered lines ──► write targeted tests
```

### Risk-Weighted Coverage Allocation

```text
High risk, high coverage target:   Business logic, BLoCs, Repositories
Medium:                            Data sources, simple validators
Low priority for line coverage:    UI composition (use widget/golden tests instead)
Excluded:                          Generated code
```

---

## Code Examples

### A Coverage Gap Caught by Line Numbers

```dart
// lib/usecase/apply_discount_usecase.dart
double applyDiscount(double price, double percentage) {
  if (percentage < 0 || percentage > 1) {
    throw ArgumentError('percentage must be between 0 and 1'); // line 4
  }
  return price - (price * percentage); // line 6
}
```

```dart
// test/usecase/apply_discount_usecase_test.dart
void main() {
  test('applies discount correctly', () {
    expect(applyDiscount(100, 0.2), 80.0);
  });
  // Line 4 (the ArgumentError branch) is NEVER exercised by this suite!
}
```

Coverage report would flag line 4 as uncovered — a precise signal to add:

```dart
test('throws ArgumentError for invalid percentage', () {
  expect(() => applyDiscount(100, 1.5), throwsA(isA<ArgumentError>()));
});
```

---

## Step-by-Step Explanation

1. Run `flutter test --coverage` to generate `coverage/lcov.info`.
2. Convert to HTML with `genhtml` (or use an editor plugin/CI integration) for a readable view.
3. Identify uncovered lines, prioritizing high-risk modules (business logic, repositories) first.
4. Write targeted tests for those specific gaps — using test design techniques (Module 04) to ensure the new tests are meaningful, not just line-touching.
5. Exclude genuinely irrelevant code (generated files) rather than lowering the bar for real logic.
6. Track coverage *trends* over time in CI rather than fixating on a single static percentage.

---

## Best Practices

- Use coverage reports as a *diagnostic tool* to find untested code, not as a quality certification.
- Set risk-weighted targets per code category rather than one blanket percentage.
- Exclude only genuinely generated/trivial code from coverage — never risky business logic.
- Track coverage regressions per pull request, not just a single static organization-wide number.

---

## Common Mistakes

- Treating 100% coverage as equivalent to "bug-free" or "well-tested."
- Writing assertion-free tests purely to inflate coverage numbers.
- Applying a single uniform coverage target to both trivial and high-risk code.
- Excluding real business logic from coverage to artificially hit a target.

---

## Interview Questions

1. What does code coverage actually measure, and what does it fail to measure?
2. What's the difference between line coverage and branch coverage, with an example of a bug branch coverage would catch that line coverage wouldn't?
3. Why is 100% coverage often the wrong goal for a team to chase?
4. How would you set coverage targets differently for business logic versus UI composition code?
5. Why might tracking coverage *regressions* per PR be more useful than a single static coverage threshold?

---

## Exercises

1. Take the `applyDiscount` example above, run coverage, and confirm line 4 is flagged uncovered before adding the missing test.
2. Write a deliberately "bad" test that touches a line without meaningfully asserting on it, and explain why it's harmful despite improving the coverage number.
3. Propose risk-weighted coverage targets for a hypothetical banking app's `lib/` folder (auth, transactions, settings, help screen).

---

## Mini Project

Take the `TodoCubit` mini project from Module 10 (or a similar small feature). Run `flutter test --coverage`, generate the HTML report, and iteratively add tests until all business-logic branches are covered — using the LCOV report to guide exactly which lines/branches still need tests.

---

## Assignment

Run `flutter test --coverage` on an existing Flutter project. Generate the HTML report and identify the 3 most concerning coverage gaps (prioritizing business logic over UI). Write targeted tests to close those gaps, and write a short reflection on what the coverage number told you — and didn't tell you — about the code's quality.

---

## Summary

- Code coverage measures executed lines, not test quality or correctness.
- Line coverage can miss untested branches; branch coverage (or careful decision-table test design) catches more.
- 100% coverage is a vanity-metric trap; risk-weighted targets are more meaningful.
- Coverage's real value is pinpointing *exactly* which lines/branches lack any test at all.
- Track coverage trends and per-PR regressions rather than fixating on one static number.

---

## Revision Notes

- `flutter test --coverage` → `coverage/lcov.info` → `genhtml` for HTML view
- Coverage measures execution, not assertion quality
- Line vs branch coverage — branch is stricter
- Risk-weighted targets > one blanket percentage
- Exclude only generated/trivial code, never real logic

---

## Next Module

Continue with **17_Test_Architecture.md**.
