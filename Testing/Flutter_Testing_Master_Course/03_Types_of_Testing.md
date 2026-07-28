# Module 03: Types of Testing

---

## Module Overview

Software testing is not one activity — it's a family of distinct techniques, each answering a different question about quality. This module maps out the full landscape of testing types, from functional to non-functional, so you know exactly which technique to reach for and when, before we specialize into Flutter tooling.

---

## Learning Objectives

- Differentiate functional vs non-functional testing.
- Understand black-box, white-box, and grey-box testing.
- Identify regression, smoke, and sanity testing and when each applies.
- Understand performance, security, accessibility, and usability testing at a conceptual level.
- Map each testing type to a real Flutter development scenario.

---

## Prerequisites

- Module 01: Introduction to Software Testing
- Module 02: Software Testing Fundamentals

---

## Theory

### Functional vs. Non-Functional Testing

**Functional testing** verifies *what* the system does — does a button trigger the right action, does a form validate correctly, does a calculation return the right result.

**Non-functional testing** verifies *how well* the system does it — how fast, how secure, how accessible, how usable.

```text
Functional Testing            Non-Functional Testing
─────────────────             ───────────────────────
Unit Testing                  Performance Testing
Integration Testing           Security Testing
System Testing                Usability Testing
Acceptance Testing             Accessibility Testing
Regression Testing            Load/Stress Testing
Smoke/Sanity Testing          Compatibility Testing
```

### Black-Box, White-Box, and Grey-Box Testing

These describe *how much internal knowledge* the tester has of the system.

| Type | Knowledge of Internals | Focus | Example |
|---|---|---|---|
| Black-box | None | Inputs/outputs only | Testing a login form purely via UI, no code knowledge |
| White-box | Full | Internal logic, code paths | Unit testing a function knowing its branches |
| Grey-box | Partial | Mix of both | Testing an API integration knowing the contract but not the implementation |

Most Flutter unit and widget tests are **white-box**: you know the internal structure of the widget or class you're testing and design test cases around its logic branches. Manual QA exploratory testing tends to be **black-box**.

### Regression, Smoke, and Sanity Testing

These three are frequently confused:

- **Regression testing**: Re-running existing tests after a code change to ensure nothing that used to work has broken. This is the primary job of your automated test suite in CI.
- **Smoke testing**: A quick, shallow set of tests to check that the build is stable enough to test further (e.g., "does the app launch and show the home screen?"). Named after hardware testing — "turn it on, see if it smokes."
- **Sanity testing**: A narrow, focused check after a specific fix, verifying that fix works without doing a full regression pass.

```text
Smoke Test   → "Is this build even worth testing further?"
Sanity Test  → "Did this specific fix work?"
Regression   → "Did anything break as a side effect?"
```

### Performance Testing

Evaluates responsiveness, stability, and resource usage under expected (and extreme) conditions.

- **Load testing**: behavior under expected concurrent usage.
- **Stress testing**: behavior beyond expected limits, to find the breaking point.
- **Soak testing**: behavior over an extended period (e.g., memory leaks after hours of use).

In Flutter, this maps to things like frame-rendering performance (jank), memory profiling with DevTools, and app startup time.

### Security Testing

Identifies vulnerabilities — data leaks, insecure storage, injection attacks, insecure network communication.

In Flutter apps, common security testing concerns include:
- Insecure storage of tokens (should use `flutter_secure_storage`, not plain `SharedPreferences`, for sensitive data).
- Certificate pinning for API calls.
- Obfuscation of release builds (`--obfuscate`).

### Accessibility Testing

Ensures the app is usable by people with disabilities — screen reader support, sufficient color contrast, adequate touch target sizes, semantic labels.

Flutter has first-class accessibility testing support via the `Semantics` widget and the `flutter_test` `SemanticsHandle` and accessibility guideline checkers (e.g., `meetsGuideline(androidTapTargetGuideline)`).

### Usability Testing

Evaluates how intuitive and pleasant the app is to use — typically involves real users, not automation. This is a validation activity (recall Module 01) rather than a verification activity.

### Compatibility Testing

Ensures the app works correctly across different devices, OS versions, screen sizes, and orientations — especially important for Flutter given its "write once, run on many platforms" promise.

---

## Flutter Perspective

Here's how each testing type maps to concrete Flutter tools and practices you'll use throughout this course:

| Testing Type | Flutter Tooling |
|---|---|
| Unit (functional, white-box) | `test` / `flutter_test` |
| Widget (functional) | `flutter_test` |
| Integration/E2E (functional) | `integration_test` |
| Regression | CI running the full suite on every PR |
| Smoke | A minimal `integration_test` that just launches the app |
| Performance | Flutter DevTools, `flutter drive --profile` |
| Accessibility | `flutter_test` semantics guideline checkers |
| Golden/Visual | `golden_toolkit` |
| Security | Manual review + `flutter_secure_storage`, static analysis |

---

## Diagrams

### The Testing Landscape

```text
                     Software Testing
                            │
          ┌─────────────────┴─────────────────┐
          │                                    │
     Functional                          Non-Functional
          │                                    │
 ┌────────┼────────┐               ┌───────────┼────────────┐
 │        │        │               │           │            │
Unit  Integration System      Performance  Security   Accessibility
```

### Regression vs Smoke vs Sanity

```text
New Build Deployed
        │
        ▼
   Smoke Test ──fail──► Reject build immediately
        │ pass
        ▼
  Specific Fix Verified? ──► Sanity Test
        │
        ▼
   Full Regression Suite (CI)
```

---

## Code Examples

### White-Box Unit Test (knows internal branch logic)

```dart
String classify(int score) {
  if (score >= 90) return 'A';
  if (score >= 75) return 'B';
  if (score >= 50) return 'C';
  return 'F';
}

void main() {
  test('classify covers all branches (white-box)', () {
    expect(classify(95), 'A');
    expect(classify(80), 'B');
    expect(classify(60), 'C');
    expect(classify(30), 'F');
  });
}
```

Notice how the test author had to *know* the internal boundaries (90, 75, 50) to write meaningful white-box test cases — this is the defining trait of white-box testing.

### Accessibility (Semantics) Test Example

```dart
testWidgets('Submit button meets tap target accessibility guideline',
    (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: ElevatedButton(onPressed: null, child: Text('Submit')),
      ),
    ),
  );

  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  handle.dispose();
});
```

---

## Step-by-Step Explanation

1. Identify which *question* you're trying to answer (correctness? speed? security? usability?).
2. Match that question to a testing type from the table above.
3. Choose the smallest, fastest testing technique that can answer that question (favor unit/widget over full E2E where possible).
4. Automate what can be automated; reserve manual testing for usability/exploratory concerns.

---

## Best Practices

- Don't rely solely on manual regression testing — automate regression via CI.
- Run smoke tests first in CI pipelines to fail fast on badly broken builds.
- Bake accessibility checks into your widget test suite, not as an afterthought.
- Treat non-functional requirements (performance, security, accessibility) as first-class, not optional extras.

---

## Common Mistakes

- Confusing smoke tests with full regression suites.
- Assuming "it looks fine on my device" is equivalent to compatibility testing.
- Skipping accessibility testing entirely because it's "non-functional."
- Treating security testing as a one-time task instead of ongoing practice.

---

## Interview Questions

1. What's the difference between black-box and white-box testing?
2. Explain the difference between smoke testing and sanity testing.
3. Why is regression testing usually automated rather than manual?
4. Name three non-functional testing types and give a Flutter-specific example of each.
5. Why is accessibility testing often overlooked, and why is that a mistake?

---

## Exercises

1. Classify the following as functional or non-functional: login validation, app launch time, screen reader support, form field required-check.
2. Write a black-box test scenario (no code, just steps) for a login screen, using only what a user could observe.
3. Explain, in your own words, the difference between load testing and stress testing.

---

## Mini Project

For a hypothetical Flutter "Notes" app, write a one-page **Test Type Matrix**: list at least 8 testing types (functional and non-functional) and describe one concrete test case for each, specific to the Notes app.

---

## Assignment

Pick a real app on your phone. Spend 15 minutes doing manual black-box exploratory testing on one screen. Document at least 3 issues or edge cases you found (even minor ones), and classify each as a functional or non-functional concern.

---

## Summary

- Functional testing checks *what* the system does; non-functional checks *how well*.
- Black-box, white-box, and grey-box describe how much internal knowledge the tester has.
- Regression, smoke, and sanity testing serve different, complementary purposes.
- Performance, security, accessibility, usability, and compatibility testing round out a complete quality picture.
- Flutter has dedicated tooling mapping to nearly every testing type.

---

## Revision Notes

- Functional = what; Non-functional = how well
- Black-box = no internal knowledge; White-box = full internal knowledge
- Smoke = build worth testing?; Sanity = did this fix work?; Regression = did anything break?
- Flutter accessibility testing uses `Semantics` + guideline checkers

---

## Next Module

Continue with **04_Test_Design_Techniques.md**.
