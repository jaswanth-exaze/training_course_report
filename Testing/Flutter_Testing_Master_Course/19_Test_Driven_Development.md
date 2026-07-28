# Module 19: Test-Driven Development

---

## Module Overview

Test-Driven Development (TDD) inverts the usual order of writing code: you write a failing test *first*, then write just enough code to make it pass, then refactor. This module covers the Red-Green-Refactor cycle in depth, applies it to real Flutter examples (a use case and a Cubit), and gives an honest assessment of when TDD helps and when it doesn't.

---

## Learning Objectives

- Explain and apply the Red-Green-Refactor cycle.
- Practice TDD on a pure Dart business logic example.
- Practice TDD on a Cubit using `bloc_test`.
- Understand the difference between test-first and test-driven development.
- Evaluate when TDD is a good fit versus when it isn't.

---

## Prerequisites

- Modules 05–10, 19 builds directly on everything learned about unit and BLoC testing

---

## Theory

### The Red-Green-Refactor Cycle

```text
┌───────┐        ┌────────┐        ┌───────────┐
│  RED   │ ─────► │  GREEN  │ ─────► │ REFACTOR   │ ──┐
│(write a│        │(write   │        │(clean up,   │   │
│failing │        │minimal  │        │ tests still │   │
│ test)  │        │code to  │        │  pass)      │   │
└───────┘        │  pass)  │        └───────────┘   │
     ▲            └────────┘                          │
     └──────────────────────────────────────────────────┘
                    (repeat for next behavior)
```

1. **Red**: Write a test for a behavior that doesn't exist yet. Run it — it must fail (proving the test actually tests something; a test that passes before the code exists is testing nothing).
2. **Green**: Write the *minimum* code necessary to make the test pass — not more. Resist the urge to build out extra functionality not yet demanded by a test.
3. **Refactor**: With the safety net of a passing test, clean up the implementation (remove duplication, improve naming) without changing behavior. Tests must stay green throughout.

### Why "Minimum Code" Matters

The discipline of writing only enough code to pass the current test prevents speculative over-engineering (sometimes called YAGNI — "You Aren't Gonna Need It"). It also means your test suite ends up as a complete, living specification of the system's actual behavior — every piece of logic exists *because* a test demanded it.

### TDD Example: Pure Dart Business Logic

**Goal**: Build a `calculateShippingCost(weightKg)` function.

**Cycle 1 — Red**:
```dart
test('returns 5.0 for weight under 1kg', () {
  expect(calculateShippingCost(0.5), 5.0);
});
```
This fails to compile — `calculateShippingCost` doesn't exist yet. That's expected; create the function signature returning a placeholder to get a *running but failing* test first if needed, or write the function itself.

**Cycle 1 — Green**:
```dart
double calculateShippingCost(double weightKg) => 5.0;
```
Minimal, even "wrong" in general — but it passes the one test that exists so far. This is intentional.

**Cycle 2 — Red**:
```dart
test('returns 10.0 for weight between 1kg and 5kg', () {
  expect(calculateShippingCost(3.0), 10.0);
});
```
This now fails, since the current implementation always returns 5.0.

**Cycle 2 — Green**:
```dart
double calculateShippingCost(double weightKg) {
  if (weightKg < 1) return 5.0;
  return 10.0;
}
```

**Cycle 3 — Red**:
```dart
test('returns 20.0 for weight over 5kg', () {
  expect(calculateShippingCost(7.0), 20.0);
});
```

**Cycle 3 — Green**:
```dart
double calculateShippingCost(double weightKg) {
  if (weightKg < 1) return 5.0;
  if (weightKg <= 5) return 10.0;
  return 20.0;
}
```

**Refactor**: At this point, review for clarity — perhaps extract named constants for the thresholds and rates. Tests stay green throughout, confirming the refactor didn't change behavior.

```dart
double calculateShippingCost(double weightKg) {
  const lightThreshold = 1.0;
  const mediumThreshold = 5.0;
  const lightRate = 5.0;
  const mediumRate = 10.0;
  const heavyRate = 20.0;

  if (weightKg < lightThreshold) return lightRate;
  if (weightKg <= mediumThreshold) return mediumRate;
  return heavyRate;
}
```

Notice how this cycle naturally produced boundary-value test cases (Module 04) — TDD and systematic test design techniques reinforce each other.

### TDD Example: A Cubit

TDD applies equally well to BLoC/Cubit logic (Module 10), using `bloc_test` for the Red-Green-Refactor cycle.

**Red**:
```dart
blocTest<CounterCubit, int>(
  'emits [1] when increment is called',
  build: () => CounterCubit(),
  act: (cubit) => cubit.increment(),
  expect: () => [1],
);
```
This fails — `CounterCubit` doesn't exist yet.

**Green**:
```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}
```

**Red (next behavior)**:
```dart
blocTest<CounterCubit, int>(
  'does not go below 0 when decrement is called at 0',
  build: () => CounterCubit(),
  act: (cubit) => cubit.decrement(),
  expect: () => [], // no state change expected
);
```

**Green**:
```dart
void decrement() {
  if (state > 0) emit(state - 1);
}
```

This example demonstrates a particularly valuable TDD property: writing the test for the "cannot go below 0" edge case **first** forces you to consider and correctly implement the guard clause, rather than potentially forgetting it if code came first and tests were added as an afterthought.

### Test-First vs. Test-Driven

These are often conflated but are subtly different:

- **Test-first**: Simply writing the test before the implementation. A useful habit, but doesn't necessarily involve the tight Red-Green-Refactor loop or minimal-code discipline.
- **Test-driven**: The full discipline — tests *drive* the design of the code, one small increment at a time, with continuous refactoring under a passing-test safety net.

TDD is test-first, but not all test-first development is truly test-driven.

### When TDD Helps — and When It Doesn't

**TDD tends to help most with:**
- Well-defined business logic with clear inputs/outputs (use cases, validators, calculators).
- BLoC/Cubit state logic, where the "expected state sequence" is a natural test-first specification.
- Bug fixes: write a failing test that reproduces the bug *first*, then fix it — guarantees the bug can't silently regress.

**TDD is a poorer fit for:**
- Highly exploratory UI/UX work where the "right" design isn't yet known — writing widget tests before you even know what the widget should look like can be premature.
- Prototyping/spike work meant to be thrown away.
- Integration with third-party APIs/SDKs whose exact behavior isn't yet understood — some exploratory "spike" coding first, followed by TDD once the integration shape is clear, is often more pragmatic.

A mature engineering team applies TDD selectively where it adds the most value, rather than treating it as a dogmatic requirement for every single line of code.

---

## Flutter Perspective

TDD pairs exceptionally well with the layered architecture built throughout this course:
- Use cases (Module 06) and Cubits/BLoCs (Module 10) are prime TDD candidates — pure logic, clear input/output, fast test execution.
- Widget TDD is possible (write a widget test asserting expected UI, then build the widget) but is less universally practiced in Flutter teams, often because visual/UX design typically precedes implementation rather than being derived purely from test assertions.
- A pragmatic Flutter team frequently applies **strict TDD for business logic** (use cases, BLoCs, validators) and a more conventional **test-after** approach for widget/UI code, while still ensuring both are fully covered by the time a feature is "done."

---

## Diagrams

### TDD Applied Across Architecture Layers

```text
Use Cases / Validators   → Strong TDD fit (pure logic, clear contracts)
BLoC / Cubit               → Strong TDD fit (state sequences as spec)
Repositories                → Moderate TDD fit (decision-table-driven)
Widgets / UI                → Weaker TDD fit; often test-after instead
```

---

## Code Examples

### A Bug-Fix TDD Cycle

```dart
// Bug report: applyDiscount(100, 1.5) should throw, but currently returns -50.0

// RED: reproduce the bug as a failing test first
test('throws ArgumentError when percentage exceeds 1.0', () {
  expect(() => applyDiscount(100, 1.5), throwsA(isA<ArgumentError>()));
});

// GREEN: minimal fix
double applyDiscount(double price, double percentage) {
  if (percentage < 0 || percentage > 1) {
    throw ArgumentError('percentage must be between 0 and 1');
  }
  return price - (price * percentage);
}

// REFACTOR: none needed here; the fix is already minimal and clear
```

This pattern — **write a failing test that reproduces the bug, then fix it** — guarantees the specific bug can never silently reappear (regression), directly connecting back to Module 03's regression testing concept.

---

## Step-by-Step Explanation

1. Pick the smallest possible next behavior to implement.
2. Write a test for that behavior. Run it and confirm it fails (Red) — never skip this verification step.
3. Write the minimum code to make it pass (Green).
4. Run the full test suite to confirm nothing else broke.
5. Refactor the implementation for clarity, keeping tests green throughout.
6. Repeat for the next smallest behavior.

---

## Best Practices

- Always confirm a new test actually fails before writing the implementation — a test that passes immediately might not be testing anything real.
- Write the *minimum* code to pass, resisting the urge to add untested speculative functionality.
- Use TDD's Red step for bug fixes specifically — it guarantees regression protection.
- Apply TDD selectively: strong fit for business logic/BLoCs, weaker fit for exploratory UI work.

---

## Common Mistakes

- Writing the implementation first and the test second, then calling it "TDD" — this is test-after, not test-driven, even if tests exist.
- Skipping the Red step verification, potentially missing that a test isn't actually exercising the intended code path.
- Writing more implementation code than the current test demands, undermining the incremental-design benefit of TDD.
- Applying strict TDD dogmatically to exploratory/prototype work where requirements are still unclear.

---

## Interview Questions

1. Explain the Red-Green-Refactor cycle in your own words.
2. What's the difference between "test-first" and "test-driven" development?
3. Why is it important to see a new test fail before writing the implementation?
4. Why is TDD often considered a strong fit for BLoC/Cubit logic specifically?
5. Describe a scenario where TDD would be a poor development approach, and explain why.

---

## Exercises

1. Using strict Red-Green-Refactor, TDD a `isPalindrome(String)` function, adding test cases incrementally (empty string, single character, mixed case, with spaces).
2. TDD a `LoginCubit` with states `LoginInitial`, `LoginLoading`, `LoginSuccess`, `LoginFailure`, driven entirely by `blocTest` cases written before the implementation.
3. Take a hypothetical bug report ("negative quantities should be rejected in the cart") and write the Red step test that would reproduce it, before writing any fix.

---

## Mini Project

TDD an entire `PasswordStrengthValidator` from scratch: start with a single Red-Green-Refactor cycle for "too short," then incrementally add cycles for "missing uppercase," "missing number," "missing special character," and "strong password accepted." Document each Red-Green-Refactor cycle explicitly (what test, what minimal code, what refactor if any).

---

## Assignment

Pick a small feature (business logic or a Cubit) you haven't built yet. Build it entirely test-driven, documenting each Red-Green-Refactor cycle in a short log (test written → confirmed failing → minimal code → confirmed passing → refactor notes). Reflect in writing on whether TDD felt like it improved your design decisions compared to your usual approach.

---

## Summary

- TDD follows a disciplined Red-Green-Refactor cycle: failing test, minimal passing code, safe refactor.
- Writing only minimal code per cycle prevents speculative over-engineering and produces a test suite that is a living specification.
- TDD applies particularly well to use cases and BLoC/Cubit logic; less naturally to exploratory UI work.
- Test-first is not automatically test-driven — the discipline of the full cycle is what defines TDD.
- TDD is an excellent tool for bug fixes: reproduce first, fix second, regression-proof by construction.

---

## Revision Notes

- Red (failing test) → Green (minimal code) → Refactor (clean up, tests stay green)
- Confirm Red before Green — always
- Minimal code only — avoid speculative extra functionality
- Strong fit: use cases, BLoCs; weaker fit: exploratory UI, prototypes
- Bug fixes: reproduce via failing test first, then fix

---

## Next Module

Continue with **20_Real_Project_Testing.md**.
