# Module 05: Dart Testing Fundamentals

---

## Module Overview

This is where theory becomes code. Before testing widgets or BLoCs, you must be fluent in the core Dart `test` package — the foundation every other Flutter testing tool is built on. This module covers the package structure, matchers, grouping, setup/teardown, async testing, and exception testing in pure Dart.

---

## Learning Objectives

- Set up a Dart/Flutter project for testing.
- Write tests using `test()`, `group()`, `expect()`.
- Use built-in matchers effectively.
- Use `setUp()`, `tearDown()`, `setUpAll()`, `tearDownAll()` correctly.
- Test asynchronous code (`Future`, `Stream`) and exceptions.
- Understand test tags and skipping tests appropriately.

---

## Prerequisites

- Modules 01–04
- Basic Dart syntax

---

## Theory

### The `test` Package

Flutter and Dart projects use the `test` package (pure Dart) or `flutter_test` (which wraps `test` and adds widget-testing capability). For pure Dart logic — models, utility functions, validators — you use `test` directly.

**pubspec.yaml**
```yaml
dev_dependencies:
  test: ^1.24.0
  flutter_test:
    sdk: flutter
```

Test files live in the `test/` directory and conventionally end in `_test.dart`. Run them with:

```bash
dart test
# or, in a Flutter project
flutter test
```

### Anatomy of a Test File

```dart
import 'package:test/test.dart';

void main() {
  group('Description of the unit under test', () {
    test('description of expected behavior', () {
      // Arrange, Act, Assert
    });
  });
}
```

- `main()` is the entry point Dart's test runner executes.
- `group()` organizes related tests and enables shared `setUp`/`tearDown` scoping.
- `test()` defines a single test case.

### Matchers

`expect(actual, matcher)` is the core assertion API. Dart's `test` package ships a rich matcher library beyond simple equality.

| Matcher | Purpose |
|---|---|
| `equals(x)` | Deep equality (default when passing a raw value) |
| `isTrue` / `isFalse` | Boolean checks |
| `isNull` / `isNotNull` | Null checks |
| `throwsA(matcher)` / `throwsException` | Exception assertions |
| `isA<T>()` | Type checks |
| `contains(x)` | Collection/string membership |
| `isEmpty` / `isNotEmpty` | Collection/string emptiness |
| `greaterThan(x)` / `lessThan(x)` | Numeric comparisons |
| `allOf(...)` / `anyOf(...)` | Combine multiple matchers |
| `closeTo(x, delta)` | Floating-point approximate equality |

### `setUp`, `tearDown`, `setUpAll`, `tearDownAll`

These hooks avoid duplicating Arrange logic across tests, while respecting the **Independent** FIRST principle.

```dart
group('Counter', () {
  late Counter counter;

  setUp(() {
    counter = Counter(); // Runs before EACH test — fresh state
  });

  tearDown(() {
    counter.dispose(); // Runs after EACH test — cleanup
  });

  setUpAll(() {
    // Runs ONCE before all tests in this group — for expensive shared setup
  });

  tearDownAll(() {
    // Runs ONCE after all tests in this group
  });

  test('starts at zero', () {
    expect(counter.value, 0);
  });
});
```

**Important**: `setUp` (per-test) is almost always preferred over `setUpAll` (shared across tests) because shared state across tests violates the Independent principle from Module 02. Use `setUpAll` only for genuinely expensive, read-only, immutable setup.

### Testing Asynchronous Code

Dart tests support `async`/`await` directly in the test callback.

```dart
test('fetchValue resolves with 42', () async {
  final result = await fetchValue();
  expect(result, 42);
});
```

For `Stream`s, use `expectLater` combined with stream matchers like `emits`, `emitsInOrder`, `emitsError`, `emitsDone`.

```dart
test('counterStream emits 1, 2, 3 then closes', () {
  final stream = Stream.fromIterable([1, 2, 3]);
  expect(stream, emitsInOrder([1, 2, 3, emitsDone]));
});
```

### Testing Exceptions

```dart
test('divide by zero throws ArgumentError', () {
  expect(() => divide(10, 0), throwsA(isA<ArgumentError>()));
});
```

Always assert on the **specific exception type**, not just `throwsException`, whenever possible — this catches cases where the wrong kind of error is thrown.

### Tags and Skipping

```dart
test('slow integration-like test', () {
  // ...
}, tags: ['slow']);

test('temporarily broken test', () {
  // ...
}, skip: 'Blocked by BUG-1234');
```

Tags let you selectively run subsets of tests in CI (e.g., `dart test --exclude-tags=slow` for fast feedback loops), while `skip` should always include a *reason* and a reference to a tracked issue — never leave a test silently skipped with no explanation.

---

## Flutter Perspective

Pure Dart tests (using just `test`, not `flutter_test`) are the **fastest** tests in your suite because they don't need to initialize the Flutter widget binding. Use them for:

- Models and data classes (`toJson`/`fromJson`, `copyWith`, equality)
- Utility/helper functions (formatters, validators, calculators)
- Business logic classes not tied to widgets (use cases, services)
- BLoC/Cubit classes (BLoCs are plain Dart classes — no widget tree needed to test them, as you'll see in Module 10)

Anything that *doesn't* need a `BuildContext`, widget tree, or rendering pipeline should be tested with plain `test`, not `flutter_test` — this keeps your unit test suite fast, which matters enormously as your test suite grows into the hundreds or thousands of tests.

---

## Diagrams

### Test Lifecycle Hooks

```text
setUpAll()  ──────────────────────────────────────────────►  (once)
    │
    ▼
 ┌─ setUp() ─► test 1 ─► tearDown() ─┐
 │                                    │
 ├─ setUp() ─► test 2 ─► tearDown() ─┤   (per test, repeats)
 │                                    │
 └─ setUp() ─► test 3 ─► tearDown() ─┘
    │
    ▼
tearDownAll()  ────────────────────────────────────────────► (once)
```

---

## Code Examples

### Full Example: Testing a Validator Class

```dart
// lib/email_validator.dart
class EmailValidator {
  bool isValid(String email) {
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
}
```

```dart
// test/email_validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/email_validator.dart';

void main() {
  group('EmailValidator', () {
    late EmailValidator validator;

    setUp(() {
      validator = EmailValidator();
    });

    test('returns true for a valid email', () {
      expect(validator.isValid('user@example.com'), isTrue);
    });

    test('returns false for a missing @ symbol', () {
      expect(validator.isValid('userexample.com'), isFalse);
    });

    test('returns false for an empty string', () {
      expect(validator.isValid(''), isFalse);
    });

    test('returns false for missing domain extension', () {
      expect(validator.isValid('user@example'), isFalse);
    });
  });
}
```

### Async Example

```dart
class UserRepository {
  Future<String> fetchUserName(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (id.isEmpty) throw ArgumentError('id must not be empty');
    return 'User_$id';
  }
}

void main() {
  final repo = UserRepository();

  test('fetchUserName returns formatted name', () async {
    final name = await repo.fetchUserName('42');
    expect(name, 'User_42');
  });

  test('fetchUserName throws for empty id', () {
    expect(
      () => repo.fetchUserName(''),
      throwsA(isA<ArgumentError>()),
    );
  });
}
```

---

## Step-by-Step Explanation

1. Create the class/function you want to test in `lib/`.
2. Create a matching test file in `test/`, named `<file>_test.dart`.
3. Import `flutter_test` (or `test` for pure Dart, no-Flutter packages) and your source file.
4. Use `group()` to organize by class/feature, `setUp()` for shared fresh state.
5. Write one `test()` per behavior, following Arrange-Act-Assert.
6. Choose the most specific matcher available (`isA<T>()`, `throwsA(isA<SpecificError>())`) over generic ones.
7. Run `flutter test` (or `dart test`) and confirm all pass.

---

## Best Practices

- Prefer plain `test` package over `flutter_test` for non-widget logic — it's faster.
- Use `setUp()` (per-test) over `setUpAll()` (shared) unless setup is expensive and read-only.
- Always use the most specific matcher available.
- Give every `skip` a documented reason and a tracked issue reference.
- Group related tests together for readable output and shared context.

---

## Common Mistakes

- Using `setUpAll()` for mutable state, causing test pollution between tests.
- Asserting with generic `throwsException` instead of the specific exception type.
- Forgetting `await` on async test bodies, causing false positives (test passes before the async code even runs).
- Testing multiple unrelated behaviors in a single `test()` block, making failures hard to diagnose.

---

## Interview Questions

1. What's the difference between `setUp()` and `setUpAll()`, and when would you use each?
2. How do you test that a `Future` throws a specific exception?
3. Why should unit tests avoid `flutter_test`'s widget-testing bindings when testing pure logic?
4. What's the danger of using `throwsException` instead of `throwsA(isA<SpecificError>())`?
5. How do you test a `Stream` that emits multiple values before closing?

---

## Exercises

1. Write a `Temperature` class with a `celsiusToFahrenheit()` method, and write at least 4 tests covering normal, zero, and negative values.
2. Write a test using `setUp`/`tearDown` for a `ShoppingCart` class that must start empty before every test.
2. Write a test for a function that throws `FormatException` for invalid input, asserting on the specific exception type.
3. Write a test for a `Stream<int>` that emits values 1 through 5 and then completes.

---

## Mini Project

Build a small **Temperature Converter** class (Celsius ↔ Fahrenheit ↔ Kelvin) with full input validation (reject temperatures below absolute zero). Write a complete test suite covering:
- Normal conversions
- Boundary values (absolute zero)
- Invalid input exceptions
- At least one async wrapper method with a `Future`

---

## Assignment

Take any 2–3 pure-Dart utility functions/classes from a project you own (or write new ones: a `StringFormatter`, a `DiscountCalculator`, a `PasswordStrengthChecker`). Write a complete, well-organized test suite using everything covered in this module: `group`, `setUp`/`tearDown`, multiple matcher types, async tests, and exception tests.

---

## Summary

- The `test` package is the foundation of all Dart/Flutter testing.
- `group`, `test`, and `expect` form the backbone of test structure.
- Matchers should be as specific as possible for clear, meaningful failures.
- Lifecycle hooks (`setUp`/`tearDown`) keep tests independent and DRY.
- Async and exception testing use `async`/`await`, `throwsA`, and stream matchers like `emitsInOrder`.

---

## Revision Notes

- `test()` = one test case; `group()` = organizes related tests
- `setUp()` per test (preferred) vs `setUpAll()` once (use sparingly)
- Prefer `throwsA(isA<SpecificError>())` over `throwsException`
- Pure Dart logic → use `test`, not `flutter_test`, for speed

---

## Next Module

Continue with **06_Flutter_Unit_Testing.md**.
