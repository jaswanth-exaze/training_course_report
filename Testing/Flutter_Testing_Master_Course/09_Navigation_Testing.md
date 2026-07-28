# Module 09: Navigation Testing

---

## Module Overview

Navigation bugs — wrong screen pushed, back button not working, deep links failing — are among the most user-visible defects in mobile apps. This module covers testing navigation with both the built-in `Navigator` API and the widely used `go_router` package, including route arguments, nested navigation, and navigation triggered by BLoC state changes.

---

## Learning Objectives

- Test navigation using a mocked/observed `NavigatorObserver`.
- Test route pushes, pops, and replacements.
- Test passing and receiving route arguments.
- Test `go_router`-based navigation.
- Test navigation triggered as a side effect of BLoC state changes.

---

## Prerequisites

- Modules 05–08

---

## Theory

### Why Navigation Needs Its Own Testing Approach

Navigation is inherently about *side effects on the widget tree* — a button tap doesn't just change local state, it changes which screen is displayed entirely. Standard widget test assertions (`find.text`, `find.byType`) still apply, but you need a way to *observe* navigation events themselves, not just their visual result.

### `NavigatorObserver`

Flutter's `Navigator` supports observers that are notified of every push/pop/replace event. In tests, you provide a mock observer and verify it received the expected calls.

```dart
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
```

```dart
await tester.pumpWidget(
  MaterialApp(
    navigatorObservers: [mockObserver],
    home: const HomeScreen(),
  ),
);

await tester.tap(find.byKey(const Key('go_to_details')));
await tester.pumpAndSettle();

verify(() => mockObserver.didPush(any(), any())).called(greaterThanOrEqualTo(1));
```

### Two Ways to Verify Navigation

1. **Behavioral verification** (preferred): After navigating, assert that the *new screen's content* is visible.
   ```dart
   expect(find.text('Details Screen'), findsOneWidget);
   ```
2. **Interaction verification**: Assert the `Navigator` was called correctly, useful when the destination screen isn't rendered in this specific test (e.g., testing only the trigger logic).
   ```dart
   verify(() => mockObserver.didPush(any(), any())).called(1);
   ```

Prefer #1 when possible — it tests the *actual user-visible outcome*, not just an internal API call, aligning with the "test behavior, not implementation" principle from Module 01.

### Testing Route Arguments

```dart
Navigator.pushNamed(context, '/details', arguments: ProductArguments(id: '42'));
```

```dart
testWidgets('navigates to details screen with correct product id',
    (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byKey(const Key('product_42')));
  await tester.pumpAndSettle();

  expect(find.text('Product ID: 42'), findsOneWidget);
});
```

### Testing `go_router`

`go_router` is the officially recommended declarative routing package for Flutter. Testing it typically involves constructing a `GoRouter` instance directly in the test and pumping a `MaterialApp.router`.

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) =>
          DetailsScreen(id: state.pathParameters['id']!),
    ),
  ],
);

testWidgets('navigates to details with correct id via go_router',
    (tester) async {
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));

  await tester.tap(find.byKey(const Key('go_to_details_1')));
  await tester.pumpAndSettle();

  expect(find.text('Details for 1'), findsOneWidget);
});
```

### Testing Navigation Triggered by BLoC State

A common pattern is a `BlocListener` that triggers navigation as a side effect of a state change (e.g., navigate to home after successful login). This requires combining widget testing with BLoC mocking (full depth in Module 10).

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  },
  child: const LoginScreen(),
);
```

```dart
testWidgets('navigates to home screen when AuthSuccess is emitted',
    (tester) async {
  whenListen(
    mockAuthBloc,
    Stream.fromIterable([AuthSuccess()]),
    initialState: AuthInitial(),
  );

  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: [mockObserver],
      home: BlocProvider.value(value: mockAuthBloc, child: const LoginScreen()),
    ),
  );

  await tester.pumpAndSettle();

  verify(() => mockObserver.didReplace(newRoute: any(named: 'newRoute'), oldRoute: any(named: 'oldRoute')))
      .called(1);
});
```

---

## Flutter Perspective

Navigation testing sits right at the boundary between widget testing and integration testing. Simple, single-screen navigation checks belong in widget tests (fast, isolated). Complex, multi-screen user journeys (e.g., "complete checkout flow across 4 screens") are better suited to `integration_test` (Module 14), since widget tests aren't designed to simulate a full app lifecycle across many screens efficiently.

Common navigation bugs this testing catches:
- Wrong screen pushed for a given trigger
- Missing/incorrect arguments passed to the next screen
- Back navigation not restoring the correct previous state
- Deep link routes not resolving to the correct screen
- Navigation not happening at all due to a broken conditional

---

## Diagrams

### Navigation Observer Flow

```text
User Taps Button
       │
       ▼
Navigator.push() called
       │
       ▼
NavigatorObserver.didPush() fires ──► test verifies this call
       │
       ▼
New screen widget builds ──► test asserts new screen's content is visible
```

---

## Code Examples

### Full Named-Route Navigation Test

```dart
// lib/main_routes.dart
final routes = <String, WidgetBuilder>{
  '/': (context) => const HomeScreen(),
  '/details': (context) => const DetailsScreen(),
};
```

```dart
testWidgets('tapping "View Details" navigates to DetailsScreen',
    (tester) async {
  final mockObserver = MockNavigatorObserver();

  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: [mockObserver],
      initialRoute: '/',
      routes: routes,
    ),
  );

  expect(find.text('Home Screen'), findsOneWidget);

  await tester.tap(find.byKey(const Key('view_details_button')));
  await tester.pumpAndSettle();

  expect(find.text('Details Screen'), findsOneWidget);
  expect(find.text('Home Screen'), findsNothing);
  verify(() => mockObserver.didPush(any(), any())).called(greaterThanOrEqualTo(1));
});
```

### Testing Back Navigation

```dart
testWidgets('back button returns to home screen', (tester) async {
  await tester.pumpWidget(
    MaterialApp(initialRoute: '/', routes: routes),
  );

  await tester.tap(find.byKey(const Key('view_details_button')));
  await tester.pumpAndSettle();
  expect(find.text('Details Screen'), findsOneWidget);

  await tester.pageBack();
  await tester.pumpAndSettle();

  expect(find.text('Home Screen'), findsOneWidget);
});
```

---

## Step-by-Step Explanation

1. Decide whether you're testing the *trigger* (interaction-based, use a `NavigatorObserver`) or the *outcome* (behavior-based, assert on destination screen content).
2. Set up the app with all needed routes (`MaterialApp` with `routes`, or `MaterialApp.router` with `GoRouter`).
3. Simulate the trigger interaction (tap, state emission).
4. Call `pumpAndSettle()` to let navigation transitions complete.
5. Assert on the destination screen's visible content (preferred) and/or observer calls.

---

## Best Practices

- Prefer asserting on destination screen content over purely verifying `Navigator` calls.
- Use `tester.pageBack()` to simulate back navigation cleanly instead of manually popping.
- For `go_router`, construct a real `GoRouter` instance scoped to the test rather than mocking the router itself.
- Combine navigation tests with BLoC mocking (Module 10) when navigation is a state-driven side effect.

---

## Common Mistakes

- Forgetting `pumpAndSettle()` after a navigation trigger, causing assertions to run before the transition completes.
- Over-relying on `verify(mockObserver...)` without ever confirming the destination screen actually renders correctly.
- Hardcoding route argument assumptions without testing missing/invalid arguments.
- Testing multi-screen flows entirely in widget tests when `integration_test` would be more appropriate and realistic.

---

## Interview Questions

1. What's the difference between behavioral and interaction-based navigation verification, and which is generally preferred?
2. How would you test that a screen correctly receives and displays a passed route argument?
3. How do you test navigation with `go_router` versus the classic `Navigator` API?
4. Why might a navigation-triggered-by-BLoC-state test require `whenListen` instead of simple `when`/`thenReturn` stubbing?
5. When should a navigation test move from widget testing to full integration testing?

---

## Exercises

1. Write a test verifying that tapping a "Logout" button navigates back to a login screen and clears the navigation stack (`pushNamedAndRemoveUntil`).
2. Write a `go_router` test verifying a route with a path parameter renders the correct content.
3. Write a test verifying that an invalid/missing route argument results in a graceful fallback UI rather than a crash.

---

## Mini Project

Build a small 3-screen app (Home → Product List → Product Details) using `go_router` with a path parameter for product ID. Write a complete navigation test suite covering: initial route, forward navigation with correct argument passing, and back navigation.

---

## Assignment

Take a multi-screen flow from an existing Flutter project (or build one: onboarding → signup → home). Write navigation tests covering every screen transition, at least one argument-passing scenario, and at least one BLoC-triggered navigation side effect.

---

## Summary

- Navigation testing requires observing navigation events (`NavigatorObserver`) or asserting destination content.
- Behavioral verification (destination content) is preferred over pure interaction verification.
- `go_router` testing involves constructing a real router instance scoped to the test.
- BLoC-triggered navigation requires combining widget testing with BLoC state stream stubbing.
- Complex multi-screen flows are often better suited to integration testing than widget testing.

---

## Revision Notes

- `NavigatorObserver` for interaction verification
- Prefer asserting destination screen content
- `go_router` tests use a real `GoRouter` instance + `MaterialApp.router`
- `pumpAndSettle()` needed after navigation transitions
- BLoC-driven nav needs `whenListen` (previewed here, detailed in Module 10)

---

## Next Module

Continue with **10_State_Management_Testing_BLoC.md**.
