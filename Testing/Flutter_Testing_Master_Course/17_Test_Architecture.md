# Module 17: Test Architecture

---

## Module Overview

This module steps back from individual test techniques to how a **large, long-lived** Flutter test suite should be architected — folder structure, shared test utilities, fixtures/builders, dependency injection for testability, and keeping thousands of tests fast and maintainable as a project scales over years.

---

## Learning Objectives

- Design a scalable test folder structure for a large Flutter project.
- Build reusable test utilities: fixtures, object mothers/builders, and shared setup helpers.
- Understand how dependency injection choices affect testability at the architecture level.
- Apply the Test Pyramid (Module 02) as an ongoing architectural discipline, not a one-time decision.
- Recognize signs of test suite architectural decay and how to address them.

---

## Prerequisites

- Modules 05–16

---

## Theory

### Why Test Architecture Matters at Scale

A test suite with 20 tests needs almost no architecture. A test suite with 2,000 tests across a team of 15 engineers absolutely does — without deliberate structure, you get duplicated setup code, inconsistent mocking patterns, slow CI, and tests that are afraid to touch because nobody remembers what they actually verify.

### Test Folder Structure at Scale

Building on Module 06's "mirror `lib/`" principle, larger projects add shared infrastructure:

```text
test/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── products/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── fixtures/
│   ├── user_fixtures.dart
│   └── product_fixtures.dart
├── helpers/
│   ├── pump_app.dart
│   └── mock_registration.dart
└── mocks/
    └── mocks.dart
integration_test/
└── flows/
    ├── login_flow_test.dart
    └── checkout_flow_test.dart
```

### Test Fixtures and Object Mothers/Builders

Repeating the construction of complex test data across dozens of test files is a maintenance trap — when the model changes, every duplicated construction site needs updating. **Fixtures** (static sample data) and **builders/object mothers** (functions that construct valid test objects with sensible defaults, overridable per test) solve this.

```dart
// test/fixtures/product_fixtures.dart
Product buildProduct({
  String id = '1',
  String name = 'Test Product',
  double price = 9.99,
}) =>
    Product(id: id, name: name, price: price);
```

```dart
test('applies 10% discount correctly', () {
  final product = buildProduct(price: 100.0);
  expect(applyDiscount(product, 0.1), 90.0);
});
```

Every test that needs *a* product can use `buildProduct()` with only the fields relevant to that specific test overridden — dramatically reducing noise and duplication, and centralizing the "what does a valid Product look like" concern in one place.

### Shared Test Helpers

Common boilerplate (wrapping a widget in `MaterialApp`, registering `mocktail` fallback values, setting up `SharedPreferences` mocks) belongs in shared helper functions, not copy-pasted across every test file.

```dart
// test/helpers/pump_app.dart
Future<void> pumpApp(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(body: widget),
    ),
  );
}
```

```dart
testWidgets('shows product name', (tester) async {
  await pumpApp(tester, ProductCard(product: buildProduct()));
  expect(find.text('Test Product'), findsOneWidget);
});
```

### Centralized Mock Registration

Rather than redefining `MockX` classes in every test file, centralize them:

```dart
// test/mocks/mocks.dart
class MockProductRepository extends Mock implements ProductRepository {}
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
// ... all shared mocks in one place

void registerFallbackValues() {
  registerFallbackValue(buildProduct());
  registerFallbackValue(FakeAuthEvent());
}
```

This also solves a subtle correctness issue: if two files define `MockProductRepository` independently, Dart treats them as different types, which can cause confusing type errors if fixtures/helpers are shared across files.

### Dependency Injection and Testability

The architectural decisions made in Modules 07/11 ("depend on abstractions") only work at scale if your app has a consistent, centralized **composition root** — a single place where concrete implementations are wired up (via `get_it`, `provider`, `riverpod`, or manual constructor injection).

```text
┌─────────────────┐
│ Composition Root │  (main.dart / service_locator.dart)
│  wires concrete   │
│  implementations  │
│  to abstractions   │
└─────────────────┘
         │
         ▼
   Rest of the app only ever depends on abstractions
```

This is what allows Module 14's integration tests to swap in fake backends at a single seam, and what allows every unit/widget test in this course to inject mocks cleanly — it is a direct architectural prerequisite for a maintainable test suite, not an afterthought.

### Signs of Test Suite Architectural Decay

- **Duplicated setup logic** copy-pasted across dozens of files instead of centralized in fixtures/helpers.
- **Slow full-suite runtime** because unit tests accidentally depend on real I/O or widget bindings unnecessarily (Module 05/06 discipline eroding).
- **Flaky tests tolerated and re-run** instead of fixed — eroding trust in the whole suite (the "boy who cried wolf" problem).
- **Inconsistent mocking patterns** — some files use `mocktail`, others hand-roll fakes, with no shared convention.
- **Ice-cream-cone drift** — new features get integration tests added because "it's easier to just launch the app," gradually inverting the pyramid.

---

## Flutter Perspective

Flutter projects that scale well over years typically enforce test architecture through:
- A documented, versioned **testing style guide** (naming, folder structure, mocking conventions).
- Lint rules or custom CI checks (e.g., flagging new `integration_test` files above a threshold, or flagging widget tests missing `Key`-based finders).
- A `test/helpers` and `test/fixtures` layer treated as first-class code — reviewed, refactored, and owned, not an afterthought.
- Regular "test suite health" reviews, similar to how Module 02's pesticide paradox calls for periodically refreshing tests.

---

## Diagrams

### Test Architecture Layers

```text
┌───────────────────────────────────────────────────┐
│                  Actual Test Files                  │
│      (organized to mirror lib/ feature structure)   │
└───────────────────────────────────────────────────┘
                        │ uses
                        ▼
┌───────────────────────────────────────────────────┐
│         Shared Fixtures / Builders / Helpers         │
│   (buildProduct(), pumpApp(), registerMocks())      │
└───────────────────────────────────────────────────┘
                        │ relies on
                        ▼
┌───────────────────────────────────────────────────┐
│        App's Dependency Injection Composition Root   │
│         (the seam that makes mocking possible)        │
└───────────────────────────────────────────────────┘
```

---

## Code Examples

### Full Example: Fixtures + Helpers + Mocks Working Together

```dart
// test/fixtures/user_fixtures.dart
User buildUser({String id = '1', String name = 'Alice', int age = 30}) =>
    User(id: id, name: name, age: age);

// test/mocks/mocks.dart
class MockUserRepository extends Mock implements UserRepository {}

void registerCommonFallbackValues() {
  registerFallbackValue(buildUser());
}

// test/helpers/pump_app.dart
Future<void> pumpApp(
  WidgetTester tester,
  Widget widget, {
  List<BlocProvider> providers = const [],
}) {
  return tester.pumpWidget(
    MultiBlocProvider(
      providers: providers,
      child: MaterialApp(home: Scaffold(body: widget)),
    ),
  );
}
```

```dart
// test/features/profile/presentation/profile_card_test.dart
import '../../../fixtures/user_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('ProfileCard displays user name and age', (tester) async {
    final user = buildUser(name: 'Bob', age: 25);

    await pumpApp(tester, ProfileCard(user: user));

    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
  });
}
```

This test reads cleanly precisely *because* the fixture and helper infrastructure absorbed all the boilerplate — the test itself communicates only what's relevant to this specific behavior.

---

## Step-by-Step Explanation

1. Establish a `test/fixtures`, `test/helpers`, and `test/mocks` layer early — ideally from a project's first few tests, not retrofitted later.
2. Mirror `lib/` feature structure inside `test/features/` (or equivalent).
3. Centralize mock class definitions and fallback value registration in one place.
4. Build reusable object builders with sensible defaults for every non-trivial domain model.
5. Periodically review the test suite for the decay signs listed above, treating this as ongoing architectural maintenance, not a one-time setup task.

---

## Best Practices

- Treat `test/fixtures` and `test/helpers` as first-class, reviewed code — not scratch space.
- Centralize mock class definitions to avoid duplicate-type confusion across files.
- Design object builders with sensible defaults, overriding only what each specific test cares about.
- Revisit test architecture periodically as the app grows — it's an ongoing discipline, not a one-time setup.

---

## Common Mistakes

- Copy-pasting widget-wrapping boilerplate (`MaterialApp(home: Scaffold(...))`) across hundreds of test files instead of a shared helper.
- Defining the same `MockX` class independently in multiple files, causing type mismatches.
- Letting integration tests silently multiply because "it's easier" than writing proper widget/unit tests — pyramid inversion.
- Ignoring flaky tests instead of fixing or removing them, eroding trust in CI (a real-world extension of Module 02's pesticide paradox).

---

## Interview Questions

1. Why do fixtures/object builders become essential as a test suite scales, when they might feel unnecessary for a small project?
2. How does a well-defined dependency injection composition root directly enable a maintainable test suite?
3. What are three concrete signs that a test suite's architecture has decayed?
4. Why should mock class definitions be centralized rather than redefined per test file?
5. How does the Test Pyramid (Module 02) function as an *ongoing* architectural discipline rather than a one-time decision?

---

## Exercises

1. Refactor 3 existing widget tests that each independently wrap their widget in `MaterialApp(home: Scaffold(...))` to use a shared `pumpApp()` helper instead.
2. Design an object builder (`buildOrder({...})`) for an `Order` model with at least 5 fields, providing sensible defaults for all of them.
3. Audit a hypothetical test suite description (provided by your instructor or self-authored) and identify at least 2 signs of architectural decay from the list in this module.

---

## Mini Project

Take the `TodoCubit`/`ProductRepository` mini projects from earlier modules (10, 11) and formally reorganize their tests into a `test/fixtures`, `test/helpers`, `test/mocks` structure. Refactor at least 5 existing tests to use the new shared infrastructure, and document the before/after reduction in duplicated code.

---

## Assignment

Design a complete test architecture proposal (1-2 pages) for a mid-sized Flutter app (10+ features) your team is starting. Include: folder structure, fixture/builder conventions, mock centralization strategy, and at least 3 CI-enforceable rules to prevent architectural decay (e.g., pyramid-shape enforcement, flaky test policy).

---

## Summary

- Test architecture becomes essential as suites scale beyond a handful of tests.
- Fixtures/builders and shared helpers eliminate duplicated setup and centralize domain knowledge.
- Centralized mock definitions avoid duplicate-type bugs across test files.
- A consistent dependency injection composition root is the architectural prerequisite for scalable testability.
- Test suites decay over time without active maintenance — treat test code as first-class, reviewed code.

---

## Revision Notes

- `test/fixtures`, `test/helpers`, `test/mocks` as first-class layers
- Object builders: sensible defaults, override only what matters per test
- Centralize mock class definitions — avoid duplicate-type issues
- DI composition root = prerequisite for scalable mocking/testability
- Watch for decay: duplicated setup, slow suite, tolerated flakiness, pyramid inversion

---

## Next Module

Continue with **18_CI_CD_Testing.md**.
