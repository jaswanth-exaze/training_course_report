# Module 08: Widget Testing

---

## Module Overview

Widget testing is Flutter's signature testing capability — rendering a widget tree in a fast, simulated environment (no real device needed) and interacting with it programmatically. This module covers `WidgetTester`, `pumpWidget`, finders, matchers, and interaction simulation in depth.

---

## Learning Objectives

- Understand what a widget test actually does under the hood.
- Use `pumpWidget`, `pump`, and `pumpAndSettle` correctly.
- Find widgets using `find.byType`, `find.text`, `find.byKey`, and more.
- Simulate user interaction: taps, text entry, scrolling, gestures.
- Assert on widget presence, absence, and properties.
- Test widgets that depend on external state (BLoCs, providers) using mocks from Module 07.

---

## Prerequisites

- Modules 05–07

---

## Theory

### What Is a Widget Test?

A widget test renders a widget (or widget tree) using a simulated environment provided by `flutter_test`, without needing a real device, emulator, or platform channels. It sits in the middle of the Test Pyramid (Module 02) — faster than full integration tests, but able to verify actual rendered UI behavior, unlike pure unit tests.

```text
Unit Test        → tests logic, no UI at all
Widget Test       → tests UI in a simulated environment (fast, no device)
Integration Test  → tests full app on a real device/emulator (slow, high confidence)
```

### The `WidgetTester` and the Test Binding

Every widget test runs inside a `testWidgets()` block, which provides a `WidgetTester` — your handle for interacting with the simulated widget tree.

```dart
testWidgets('description', (WidgetTester tester) async {
  // test body
});
```

Behind the scenes, `flutter_test` initializes a `TestWidgetsFlutterBinding`, which fakes the rendering pipeline, animation clock, and platform channels so tests run instantly and deterministically — no real frame rendering, no real time passing unless you explicitly advance it.

### `pumpWidget`, `pump`, and `pumpAndSettle`

- **`pumpWidget(widget)`**: Builds and renders the widget tree for the first time (like the app's initial frame).
- **`pump([duration])`**: Triggers a single frame rebuild, optionally advancing the fake clock by `duration`. Needed after any state change (e.g., after a tap) to let the UI rebuild.
- **`pumpAndSettle()`**: Repeatedly pumps frames until no more frames are scheduled (e.g., until an animation finishes). Useful for animations, but can hang forever on infinite/repeating animations — use with care.

```text
pumpWidget()  → initial render
    │
    ▼
tap/enterText  → triggers a state change
    │
    ▼
pump()  → rebuild reflecting the new state
```

### Finders

Finders locate widgets in the tree for interaction or assertion.

| Finder | Matches |
|---|---|
| `find.text('Login')` | A `Text` widget with exact string |
| `find.byType(ElevatedButton)` | Widgets of a specific type |
| `find.byKey(Key('submit_btn'))` | A widget with a specific `Key` |
| `find.byIcon(Icons.add)` | A specific `Icon` |
| `find.widgetWithText(Button, 'Submit')` | A widget of type containing given text |
| `find.byWidgetPredicate((w) => ...)` | Custom predicate matching |

Using `Key`s for critical interactive widgets (buttons, form fields) is a best practice — text can change (localization, copy edits) but keys remain stable.

### Simulating Interaction

```dart
await tester.tap(find.byKey(const Key('login_button')));
await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
await tester.drag(find.byType(ListView), const Offset(0, -300));
await tester.longPress(find.byKey(const Key('item')));
```

Every interaction that changes state must be followed by `pump()` (or `pumpAndSettle()`) for the resulting UI change to actually render before you assert on it.

### Assertions

```dart
expect(find.text('Welcome'), findsOneWidget);
expect(find.byType(CircularProgressIndicator), findsNothing);
expect(find.byIcon(Icons.error), findsWidgets); // one or more
expect(find.text('Item'), findsNWidgets(3));
```

| Matcher | Meaning |
|---|---|
| `findsOneWidget` | Exactly one match |
| `findsNothing` | Zero matches |
| `findsWidgets` | One or more matches |
| `findsNWidgets(n)` | Exactly `n` matches |

### Testing Widgets with Dependencies

Real widgets often depend on a BLoC, Provider, or service. Use `mocktail` (Module 07) to inject a controlled fake dependency so the widget test focuses purely on rendering/interaction logic, not business logic.

```dart
await tester.pumpWidget(
  MaterialApp(
    home: BlocProvider<CounterCubit>.value(
      value: mockCubit,
      child: const CounterScreen(),
    ),
  ),
);
```

Note: Always wrap the widget under test in a `MaterialApp` (or `WidgetsApp`) — most Flutter widgets (Text styling, Navigator, Theme, Directionality) require this ancestor to function correctly in tests.

---

## Flutter Perspective

Widget tests are the sweet spot of the Flutter test pyramid: they render real widget trees (catching layout/rendering bugs that pure unit tests can't) while running in milliseconds (unlike `integration_test`, which needs a real device/emulator). A healthy Flutter app should have substantially more widget tests than integration tests.

Common things widget tests should verify:
- Correct widget appears for each state (loading, success, error, empty)
- Buttons/inputs trigger the correct callbacks
- Conditional UI (e.g., error text) appears/disappears correctly
- Form validation messages appear correctly
- Navigation is triggered correctly (covered in depth in Module 09)

---

## Diagrams

### Widget Test Lifecycle

```text
testWidgets('...', (tester) async {
      │
      ▼
 pumpWidget(MyWidget())  ── initial build
      │
      ▼
 tester.tap(...) / enterText(...)  ── simulate interaction
      │
      ▼
 tester.pump()  ── rebuild after state change
      │
      ▼
 expect(find.text('...'), findsOneWidget)  ── assert
});
```

---

## Code Examples

### Testing a Simple Counter Widget

```dart
// lib/widgets/counter_widget.dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_count', key: const Key('count_text')),
        ElevatedButton(
          key: const Key('increment_button'),
          onPressed: () => setState(() => _count++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

```dart
// test/widgets/counter_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/counter_widget.dart';

void main() {
  group('CounterWidget', () {
    testWidgets('displays initial count of 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('increments count when button is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('Count: 1'), findsOneWidget);
      expect(find.text('Count: 0'), findsNothing);
    });

    testWidgets('increments count multiple times correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      final button = find.byKey(const Key('increment_button'));
      await tester.tap(button);
      await tester.tap(button);
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Count: 3'), findsOneWidget);
    });
  });
}
```

### Testing a Form with Validation

```dart
testWidgets('shows error text when email field is empty on submit',
    (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoginForm())));

  await tester.tap(find.byKey(const Key('submit_button')));
  await tester.pump();

  expect(find.text('Email is required'), findsOneWidget);
});
```

---

## Step-by-Step Explanation

1. Wrap the widget under test in `MaterialApp`/`Scaffold` as needed for ancestor dependencies.
2. Call `pumpWidget()` to render the initial frame.
3. Assert the initial state is correct.
4. Simulate interaction (`tap`, `enterText`, `drag`) as needed.
5. Call `pump()` (or `pumpAndSettle()` for animations) to let the UI rebuild.
6. Assert the resulting state is correct — both what *should* appear and what should *not*.

---

## Best Practices

- Use `Key`s for all interactive/critical widgets rather than relying solely on text/type finders.
- Always pair a state-changing interaction with `pump()` before asserting.
- Use `pumpAndSettle()` cautiously — never on infinitely repeating animations.
- Mock dependencies (BLoCs, services) so widget tests isolate UI behavior from business logic.
- Assert both presence (`findsOneWidget`) and absence (`findsNothing`) where relevant.

---

## Common Mistakes

- Forgetting `pump()` after an interaction, causing false failures (or false passes) because the UI never rebuilt.
- Relying purely on `find.text()` for widgets whose text may change/localize.
- Calling `pumpAndSettle()` on a widget with a continuous animation, causing test timeouts.
- Not wrapping the widget under test in `MaterialApp`, causing "No Directionality widget found" or similar errors.

---

## Interview Questions

1. What's the difference between `pump()` and `pumpAndSettle()`?
2. Why do widget tests generally not require a real device or emulator?
3. Why should critical interactive widgets use `Key`s instead of relying on `find.text()`?
4. What happens if you forget to call `pump()` after simulating a tap?
5. Why would you mock a BLoC/provider in a widget test instead of using the real implementation?

---

## Exercises

1. Write a widget test for a `ToggleSwitch` widget verifying it flips state on tap.
2. Write a widget test for a text field that shows a character counter and updates as text is entered.
3. Write a widget test asserting that a `CircularProgressIndicator` appears while `isLoading` is true and disappears when `false`.

---

## Mini Project

Build a **Login Form** widget with email and password fields and a submit button. Requirements:
- Shows "Email is required" if email is empty on submit
- Shows "Password must be at least 6 characters" if password too short
- Shows a `CircularProgressIndicator` while "logging in" (simulate with a 1-second delay)
- Write a complete widget test suite covering all of the above states.

---

## Assignment

Take any screen from an existing Flutter project. Write a widget test suite covering: initial render state, all interactive elements, all conditional UI states (loading/error/empty/success), and at least one test explicitly using `findsNothing` to assert something is correctly absent.

---

## Summary

- Widget tests render real widget trees in a fast, simulated (no-device) environment.
- `pumpWidget`, `pump`, and `pumpAndSettle` control the rendering lifecycle.
- Finders (`find.byKey`, `find.text`, `find.byType`) locate widgets for interaction/assertion.
- Interactions (`tap`, `enterText`, `drag`) must be followed by `pump()` to reflect state changes.
- Mocking dependencies keeps widget tests focused purely on UI behavior.

---

## Revision Notes

- `pumpWidget` = initial render; `pump` = rebuild after change; `pumpAndSettle` = pump until settled
- Prefer `Key`-based finders for stability
- Always `pump()` after interaction before asserting
- Mock BLoCs/services to isolate UI from business logic

---

## Next Module

Continue with **09_Navigation_Testing.md**.
