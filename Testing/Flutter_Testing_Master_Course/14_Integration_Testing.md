# Module 14: Integration Testing

---

## Module Overview

Integration tests sit at the top of the Test Pyramid (Module 02) — they run your full app on a real device or emulator, exercising real widgets, real navigation, and (optionally) real or near-real backends. This module covers Flutter's `integration_test` package, writing full user-journey tests, and understanding the tradeoffs that come with this level of confidence.

---

## Learning Objectives

- Understand what distinguishes integration tests from widget tests in Flutter specifically.
- Set up and run tests using the `integration_test` package.
- Write full user-journey tests spanning multiple screens.
- Understand strategies for handling real vs. faked backends in integration tests.
- Recognize when integration tests are the right tool versus over-testing at this level.

---

## Prerequisites

- Modules 05–10

---

## Theory

### Widget Tests vs. Integration Tests

Both use `WidgetTester` and similar APIs (`pump`, `find`, `tap`), which often causes confusion. The real distinction is the **execution environment**:

| | Widget Test | Integration Test |
|---|---|---|
| Environment | Simulated, in-memory (`flutter_test` binding) | Real device or emulator |
| Speed | Milliseconds | Seconds to minutes |
| Platform channels | Faked | Real (or selectively faked) |
| Scope | One widget/screen | Full app, multi-screen journeys |
| Confidence | High for UI logic | Highest — closest to real user experience |
| Flakiness risk | Low | Higher (real timing, real rendering) |

### The `integration_test` Package

Unlike `flutter_test`, `integration_test` runs your actual compiled app on a device/emulator/browser, driving it exactly as a user would.

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

Test files conventionally live in a top-level `integration_test/` directory (not `test/`):

```text
integration_test/
└── app_test.dart
```

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('complete login flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // ... interact with the real running app
    });
  });
}
```

Run with:
```bash
flutter test integration_test/app_test.dart
# or, on a connected device/emulator
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
```

### Writing a Full User Journey Test

A user journey test spans multiple screens, simulating a realistic end-to-end scenario — this is where integration tests earn their cost, unlike single-screen checks better suited to widget tests.

```dart
testWidgets('user can log in, view products, and add one to cart',
    (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Login screen
  await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
  await tester.enterText(find.byKey(const Key('password_field')), 'password123');
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle();

  // Product list screen
  expect(find.text('Products'), findsOneWidget);
  await tester.tap(find.text('Wireless Mouse'));
  await tester.pumpAndSettle();

  // Product details screen
  expect(find.text('Add to Cart'), findsOneWidget);
  await tester.tap(find.byKey(const Key('add_to_cart_button')));
  await tester.pumpAndSettle();

  // Confirm cart badge updated
  expect(find.text('1'), findsOneWidget);
});
```

### Real vs. Faked Backend Strategy

A key decision for integration tests: should they hit a **real backend** (staging environment), or should the app be built with an **injected fake/mock backend** for the test run?

| Strategy | Pros | Cons |
|---|---|---|
| Real staging backend | Highest realism, catches integration issues with actual API | Slow, flaky (network), requires test data management |
| Injected fake backend (via dependency injection) | Fast, deterministic, no network flakiness | Slightly lower realism; won't catch real API contract bugs |

Most mature Flutter teams use a **hybrid approach**: the majority of integration tests run against an injected fake/in-memory backend (via the same dependency-injection seams used for mocking in Modules 07/11), reserving a small number of true end-to-end tests against a real staging environment for critical flows (e.g., login, checkout) run less frequently (e.g., nightly, not on every PR).

### When NOT to Use Integration Tests

Given their cost (speed, flakiness, maintenance), integration tests should be reserved for:
- Critical, multi-screen user journeys (checkout, onboarding, login)
- Testing real platform integrations that can't be faked (camera, biometrics, deep links from OS)
- Final smoke-level verification that the app boots and core navigation works

Anything testable at the widget or unit level (Modules 05–10) should be — pushing coverage down the pyramid, not up.

---

## Flutter Perspective

Flutter's integration tests are unusual among mobile frameworks because they can run the **same test code** across Android, iOS, and web via `flutter drive`, and can even collect real performance metrics (frame timing, memory) during the test run using the `traceAction` API — connecting integration testing to Module 21's advanced performance topics.

---

## Diagrams

### Test Pyramid Recap with Integration Tests

```text
                ▲
               / \
              / E2E \        ← integration_test (this module): few, high-value journeys
             /-------\
            /Widget    \     ← Module 08/09/10: many, fast, isolated
           /   Tests    \
          /---------------\
         /   Unit Tests    \ ← Modules 05-07, 11-13: most numerous, fastest
        /____________________\
```

### Real vs Faked Backend Decision

```text
Is this testing a critical revenue/auth flow AND run infrequently (nightly)?
        │
      Yes ──► Real staging backend
        │
      No ──► Injected fake/in-memory backend (fast, most integration tests)
```

---

## Code Examples

### Setting Up a Fake Backend for Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;
import 'package:my_app/di/service_locator.dart';
import 'fakes/fake_product_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Swap the real repository for a deterministic fake before app boot
    serviceLocator.registerSingleton<ProductRepository>(FakeProductRepository());
  });

  testWidgets('browsing products shows fake catalog data', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Wireless Mouse'), findsOneWidget);
    expect(find.text('Mechanical Keyboard'), findsOneWidget);
  });
}
```

### Measuring Performance During an Integration Test

```dart
testWidgets('scrolling product list stays smooth', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  await binding.traceAction(() async {
    await tester.fling(find.byType(ListView), const Offset(0, -500), 3000);
    await tester.pumpAndSettle();
  }, reportKey: 'product_list_scrolling');
});
```

---

## Step-by-Step Explanation

1. Decide if the scenario truly warrants an integration test (multi-screen, critical journey) rather than a widget test.
2. Set up `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`.
3. Decide on real vs. fake backend strategy for this specific test.
4. Boot the real app via `app.main()`.
5. Drive the test through the full journey using standard `WidgetTester` APIs, calling `pumpAndSettle()` between screens.
6. Assert on final, user-visible outcomes at each major step.

---

## Best Practices

- Keep the number of integration tests small and focused on critical journeys — this is the narrow top of the pyramid, not the base.
- Prefer injected fake backends for most integration tests; reserve real-backend tests for a small, separately-scheduled suite.
- Reuse the same dependency injection seams from unit/widget testing to swap in fakes at the app's composition root.
- Use integration tests to also validate platform-specific behavior that can't be tested in `flutter_test`'s simulated environment.

---

## Common Mistakes

- Writing integration tests for things that could be covered faster and more reliably at the widget/unit level.
- Running all integration tests against a real staging backend on every commit, causing slow, flaky CI.
- Not resetting app/fake-backend state between tests, causing test pollution.
- Treating integration test failures the same as unit test failures without accounting for their higher inherent flakiness (e.g., real timing issues).

---

## Interview Questions

1. What's the fundamental environmental difference between a widget test and an integration test in Flutter?
2. Why should integration tests be the smallest layer of your test suite, not the largest?
3. What are the tradeoffs between testing against a real staging backend versus an injected fake backend?
4. How can Flutter integration tests be used to measure real performance metrics?
5. When would testing something at the integration level be the *wrong* choice, and what would be better?

---

## Exercises

1. Write an integration test for a 3-step onboarding flow (welcome → permissions → home).
2. Set up a fake repository via dependency injection specifically for integration test use, and write a test using it.
3. Identify 3 tests in a hypothetical suite that are integration tests but should be widget tests instead, and explain why.

---

## Mini Project

Build a small app with Login → Product List → Cart flow. Write a complete integration test suite using an injected fake backend, covering: successful login, browsing products, adding to cart, and viewing the cart total — all as one continuous user journey test plus 1-2 smaller focused journey tests.

---

## Assignment

Take a critical user journey from an existing Flutter project (or design one). Write an integration test using `integration_test`, deciding explicitly (and documenting why) whether to use a real or fake backend for it. Include at least one performance-tracing (`traceAction`) usage.

---

## Summary

- Integration tests run the real app on a real device/emulator — the highest-confidence, most expensive layer of the pyramid.
- The `integration_test` package drives full multi-screen user journeys.
- Teams typically use injected fake backends for most integration tests, reserving real-backend tests for a small critical subset.
- Integration tests should stay narrow and focused — most coverage should live at the unit/widget level.
- Flutter integration tests can also measure real performance metrics via `traceAction`.

---

## Revision Notes

- Widget test = simulated environment; Integration test = real device/emulator
- `integration_test/` folder, `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
- Prefer injected fake backend for most; real backend for a small critical subset
- Keep integration test count small — top of the pyramid
- `traceAction` for performance metrics

---

## Next Module

Continue with **15_Golden_Testing.md**.
