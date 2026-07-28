# Module 04: Test Design Techniques

---

## Module Overview

Knowing *that* you should test isn't enough — you need a systematic way to decide *which* test cases actually matter. This module covers the core test design techniques used by professional engineers to derive high-value test cases without exhaustively testing every possible input.

---

## Learning Objectives

- Apply Equivalence Partitioning to reduce redundant test cases.
- Apply Boundary Value Analysis to catch off-by-one and edge-case bugs.
- Understand Decision Table Testing for complex conditional logic.
- Understand State Transition Testing for stateful systems (directly relevant to BLoC later).
- Understand Exploratory Testing and when it complements systematic techniques.

---

## Prerequisites

- Module 01–03

---

## Theory

### Why Test Design Techniques Matter

Module 02 established that exhaustive testing is impossible. Test design techniques are systematic methods for choosing a *small, high-value subset* of all possible inputs that still gives strong confidence in correctness.

### Equivalence Partitioning (EP)

Divide inputs into partitions (groups) where the system is expected to behave the same way. Then test **one representative value per partition**, instead of every possible value.

**Example**: A function that accepts an age (0–120) and returns eligibility for a service starting at age 18.

```text
Invalid partition   Valid partition (ineligible)   Valid partition (eligible)   Invalid partition
   < 0                     0–17                          18–120                    > 120
```

Instead of testing all 121 valid ages, you'd test one value from each partition: e.g., `-5`, `10`, `25`, `150`.

### Boundary Value Analysis (BVA)

Most real-world bugs live at the *edges* of partitions, not in the middle (off-by-one errors, `<` vs `<=` mistakes). BVA tests values exactly at, just below, and just above each boundary.

For the age eligibility example (boundary at 18):

```text
Test values: 17, 18, 19
```

Combined, EP + BVA typically give a small, powerful set of test cases:

```text
-5 (invalid), 10 (valid, ineligible), 17 (boundary), 18 (boundary), 
19 (boundary), 25 (valid, eligible), 150 (invalid)
```

### Decision Table Testing

Used when behavior depends on **combinations of multiple conditions**. A decision table lists all relevant condition combinations and the expected outcome for each.

**Example**: A checkout discount system.

| Is Member? | Cart > $100? | Has Coupon? | Discount |
|---|---|---|---|
| Yes | Yes | Yes | 25% |
| Yes | Yes | No | 15% |
| Yes | No | Yes | 10% |
| No | Yes | Yes | 10% |
| No | No | No | 0% |

Each row becomes a test case. This technique is essential for testing business rules with multiple interacting flags — extremely common in real Flutter apps (pricing, permissions, feature flags).

### State Transition Testing

Used when a system's behavior depends on its *current state*, not just its input — directly relevant to testing BLoC/Cubit state management later in this course.

**Example**: An order's lifecycle.

```text
   ┌─────────┐  pay   ┌──────────┐ ship  ┌───────────┐ deliver ┌───────────┐
   │ Created │ ─────► │   Paid   │ ────► │  Shipped  │ ──────► │ Delivered │
   └─────────┘        └──────────┘       └───────────┘         └───────────┘
        │                   │
        │ cancel             │ cancel
        ▼                   ▼
   ┌───────────┐      ┌───────────┐
   │ Cancelled │      │ Cancelled │
   └───────────┘      └───────────┘
```

Good state transition test design covers:
- Every valid transition (Created → Paid)
- Every invalid transition (Delivered → Created should be impossible/rejected)
- Every reachable state

### Exploratory Testing

Unscripted, simultaneous learning, test design, and execution performed by a human. It complements systematic techniques by catching issues a rigid test-case list wouldn't anticipate — usability quirks, unexpected input combinations, visual glitches. It is not a replacement for EP/BVA/Decision Tables/State Transition testing, but a complement, typically done manually.

---

## Flutter Perspective

These techniques apply directly to how you'll design Dart/Flutter unit tests later in the course:

- **EP + BVA** → designing `test()` cases for validators (e.g., password strength, form field validation, age checks).
- **Decision Tables** → designing tests for BLoC business logic where multiple flags/conditions determine emitted states.
- **State Transition Testing** → designing `bloc_test` cases that verify a Cubit/BLoC only emits valid state sequences.
- **Exploratory Testing** → manual QA passes on your app before release, alongside automated coverage.

---

## Diagrams

### EP + BVA Combined

```text
        Invalid       │  Valid (partition A)  │  Valid (partition B)  │   Invalid
   ◄───────────────── │ ─────────────────────  │ ────────────────────  │ ─────────────►
         -5            0        17│18│19          25                150│         200
                                   ▲ ▲ ▲                                 ▲
                              boundary tests                       boundary test
```

---

## Code Examples

### Equivalence Partitioning + Boundary Value Analysis in Dart

```dart
bool isEligible(int age) => age >= 18 && age <= 120;

void main() {
  group('isEligible - Equivalence Partitioning + BVA', () {
    test('invalid partition: negative age', () {
      expect(isEligible(-5), false);
    });

    test('valid partition: ineligible age', () {
      expect(isEligible(10), false);
    });

    test('boundary: just below eligible age (17)', () {
      expect(isEligible(17), false);
    });

    test('boundary: exactly eligible age (18)', () {
      expect(isEligible(18), true);
    });

    test('boundary: just above eligible age (19)', () {
      expect(isEligible(19), true);
    });

    test('valid partition: clearly eligible age', () {
      expect(isEligible(25), true);
    });

    test('boundary: upper limit (120)', () {
      expect(isEligible(120), true);
    });

    test('invalid partition: above max age', () {
      expect(isEligible(150), false);
    });
  });
}
```

### Decision Table Testing in Dart

```dart
double calculateDiscount({
  required bool isMember,
  required bool cartOver100,
  required bool hasCoupon,
}) {
  if (isMember && cartOver100 && hasCoupon) return 0.25;
  if (isMember && cartOver100 && !hasCoupon) return 0.15;
  if (isMember && !cartOver100 && hasCoupon) return 0.10;
  if (!isMember && cartOver100 && hasCoupon) return 0.10;
  return 0.0;
}

void main() {
  group('calculateDiscount - Decision Table', () {
    test('member, over 100, coupon => 25%', () {
      expect(
        calculateDiscount(isMember: true, cartOver100: true, hasCoupon: true),
        0.25,
      );
    });

    test('member, over 100, no coupon => 15%', () {
      expect(
        calculateDiscount(isMember: true, cartOver100: true, hasCoupon: false),
        0.15,
      );
    });

    test('non-member, under 100, no coupon => 0%', () {
      expect(
        calculateDiscount(isMember: false, cartOver100: false, hasCoupon: false),
        0.0,
      );
    });
  });
}
```

---

## Step-by-Step Explanation

1. **Identify input domains** for the function/feature under test.
2. **Partition** those domains into valid/invalid equivalence classes (EP).
3. **Pinpoint boundaries** between partitions and test just inside/outside them (BVA).
4. **If multiple conditions interact**, build a decision table covering meaningful combinations.
5. **If behavior depends on prior state**, map out a state transition diagram and test each transition.
6. **Supplement with exploratory testing** for anything systematic techniques might miss.

---

## Best Practices

- Always pair Equivalence Partitioning with Boundary Value Analysis — EP alone misses edge bugs.
- For business rules with 3+ boolean flags, use a decision table instead of ad-hoc test cases.
- For anything modeled as a state machine (BLoC, order status, auth state), explicitly test invalid transitions, not just valid ones.
- Reserve exploratory testing time even in fully automated pipelines — it catches what scripts don't.

---

## Common Mistakes

- Testing only "happy path" middle values and ignoring boundaries.
- Writing an unmanageable number of test cases for combinational logic instead of using a decision table.
- Forgetting to test invalid/impossible state transitions.
- Treating exploratory testing as unnecessary once automation exists.

---

## Interview Questions

1. What is Equivalence Partitioning and why does it reduce test case count without reducing confidence?
2. Why are boundary values more bug-prone than "middle" values?
3. When would you use a decision table instead of individual test cases?
4. How does state transition testing apply to BLoC-based state management?
5. What role does exploratory testing play alongside automated test design techniques?

---

## Exercises

1. Given a function that validates a password must be 8–20 characters, design EP + BVA test cases.
2. Build a decision table for a login system with conditions: `hasValidEmail`, `hasValidPassword`, `accountLocked`.
3. Draw a state transition diagram for a simple traffic light (Red → Green → Yellow → Red) and list all valid and invalid transitions.

---

## Mini Project

Design a complete test case matrix (EP + BVA + Decision Table) for a **shipping cost calculator** that takes `weightKg` (0–50) and `isPriority` (bool), applying different cost tiers. Document at least 10 test cases with expected outcomes.

---

## Assignment

Take a feature from a Flutter app you've built or plan to build. Apply all four techniques (EP, BVA, Decision Table, State Transition) where relevant, and write out the resulting test case list in a markdown table, ready to be converted into actual Dart tests in later modules.

---

## Summary

- Equivalence Partitioning reduces test volume by grouping inputs into representative classes.
- Boundary Value Analysis targets the highest-bug-density areas: partition edges.
- Decision Tables systematically cover combinational business logic.
- State Transition Testing ensures state machines (like BLoCs) only allow valid transitions.
- Exploratory testing remains a valuable complement to all systematic techniques.

---

## Revision Notes

- EP: representative value per partition
- BVA: test at, just below, just above boundaries
- Decision Table: rows = condition combinations, columns = conditions + outcome
- State Transition: valid transitions + invalid transitions + reachable states
- Exploratory: manual, unscripted, complementary

---

## Next Module

Continue with **05_Dart_Testing_Fundamentals.md**.
