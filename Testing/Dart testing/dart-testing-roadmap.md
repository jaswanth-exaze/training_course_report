# Dart Testing — Complete Learning Roadmap

*A beginner-to-advanced guide covering everything from testing fundamentals to Flutter widget/golden tests, mocking, TDD, and best practices.*

---

## Table of Contents

1. [Introduction to Testing](#module-1-introduction-to-testing)
2. [Dart Test Package](#module-2-dart-test-package)
3. [Core Testing APIs](#module-3-core-testing-apis)
4. [Matchers](#module-4-matchers-very-important)
5. [Data Driven Testing](#module-5-data-driven-testing)
6. [Parameterized Testing](#module-6-parameterized-testing)
7. [Exception Testing](#module-7-exception-testing)
8. [Asynchronous Testing](#module-8-asynchronous-testing)
9. [Mocking](#module-9-mocking)
10. [Code Coverage](#module-10-code-coverage)
11. [Flutter Testing](#module-11-flutter-testing)
12. [TDD (Test-Driven Development)](#module-12-tdd-test-driven-development)
13. [Best Practices](#module-13-best-practices)

---

## Module 1: Introduction to Testing

### What is testing?

Software testing is the process of executing a program or system with the intent of finding defects and verifying that it behaves as expected. In practice, a "test" is simply a small, repeatable piece of code (or a manual procedure) that:

1. Sets up a known starting condition (**Arrange**)
2. Performs an action (**Act**)
3. Checks that the outcome matches what was expected (**Assert**)

If the outcome doesn't match, the test **fails**, telling you something is broken *before* your users find out.

### Why testing is important

- **Confidence to change code.** Tests act as a safety net. You can refactor, upgrade dependencies, or add features without fear of silently breaking existing behavior.
- **Faster feedback loop.** A test suite that runs in seconds catches bugs immediately, instead of waiting for QA or, worse, production incidents.
- **Living documentation.** A well-named test describes exactly how a piece of code is supposed to behave — often better than comments, because tests can't lie (they either pass or fail).
- **Reduced cost of bugs.** The earlier a bug is found, the cheaper it is to fix. A bug caught by a unit test costs seconds; the same bug caught in production can cost hours of debugging, hotfixes, and reputational damage.
- **Enables collaboration.** In teams, tests communicate intent and prevent one developer's change from silently breaking another's feature.
- **Encourages better design.** Code that is hard to test is often poorly designed (too many responsibilities, tight coupling, hidden dependencies). Writing tests pushes you toward cleaner, more modular code.

### Manual Testing vs Automated Testing

| Aspect | Manual Testing | Automated Testing |
|---|---|---|
| Execution | A human performs steps and observes results | Code executes the steps and asserts results |
| Speed | Slow, one scenario at a time | Fast — hundreds/thousands of tests in seconds |
| Repeatability | Prone to human error, inconsistent | Perfectly repeatable every run |
| Cost over time | Cost grows linearly with every release | High upfront cost, near-zero marginal cost afterward |
| Best suited for | Exploratory testing, usability, one-off checks | Regression testing, CI/CD pipelines, frequent releases |
| Regression safety | Weak — easy to forget to re-check old features | Strong — the whole suite reruns every time |

In real projects, both approaches coexist. Automated tests handle repetitive verification (does this function still return the right value?), while manual/exploratory testing is reserved for judgment calls a machine can't make (does this UI *feel* right?).

### Testing pyramid

The testing pyramid is a model for how much of each test type you should have, based on cost, speed, and reliability.

```
        /\
       /  \        End-to-End / UI Tests (few)
      /----\        - slow, brittle, expensive
     /      \       - high confidence in real user flow
    /--------\     Integration Tests (some)
   /          \      - medium speed
  /------------\     - test how components work together
 /              \   Unit Tests (many)
/----------------\   - fast, cheap, isolated
                      - test one function/class at a time
```

- **Unit tests (base, the largest layer):** test a single function, method, or class in isolation. Fast, cheap, and should make up the bulk of your suite.
- **Integration tests (middle layer):** test how multiple units work together — e.g., a repository talking to a real (or in-memory) database, or a service composing several classes.
- **End-to-end / UI tests (top, smallest layer):** simulate a real user interacting with the whole running application. These are valuable but slow and more fragile, so you write fewer of them.

The pyramid shape is a *guideline*, not a law — the key lesson is: **favor many fast, isolated tests over a few slow, broad ones.**

### Types of testing

- **Unit testing** — verifies a single unit of code (function/class) in isolation, usually with dependencies replaced by fakes/mocks.
- **Integration testing** — verifies that multiple units or subsystems work correctly together (e.g., a service + real database).
- **Widget testing** (Flutter-specific) — verifies a single widget's UI and behavior in a simulated environment without a real device.
- **Golden testing** (Flutter-specific) — compares rendered UI pixel-for-pixel against a saved reference ("golden") image to catch visual regressions.
- **End-to-end (E2E) / Integration (Flutter `integration_test`) testing** — runs the full app on a real or simulated device, testing complete user flows.
- **Regression testing** — re-running existing tests after a change to make sure nothing that used to work has broken.
- **Performance testing** — measures speed, memory usage, and responsiveness under load.
- **Acceptance testing** — verifies the software meets business/user requirements, often written in collaboration with stakeholders.
- **Smoke testing** — a small set of tests that quickly verify the most critical functionality works ("does the app even start?").

### Why developers write tests

- To **prevent regressions** — ensure a fix or feature doesn't break something else.
- To **specify behavior** before or while implementing it (see TDD in Module 12).
- To **enable safe refactoring** — you can restructure internals as long as tests still pass.
- To **communicate intent** to teammates and future maintainers (including future-you).
- To **catch edge cases** that are easy to overlook during manual testing (empty lists, null values, network failures, race conditions).
- Because **CI/CD pipelines require it** — automated pipelines gate merges and deployments on tests passing.

---

## Module 2: Dart Test Package

Dart's official testing library is [`package:test`](https://pub.dev/packages/test), maintained by the Dart team. It provides the `test()`/`group()` functions, the `expect()` assertion API, and a test runner.

### Installing `package:test`

Add it as a **dev dependency** (tests are not shipped with your production code):

```yaml
# pubspec.yaml
dev_dependencies:
  test: ^1.25.0
```

Then fetch packages:

```bash
dart pub get
```

For a **Flutter** project, you'll use `flutter_test` (bundled with the Flutter SDK) for widget-level tests instead of/in addition to `package:test`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

### Project structure

The Dart/Flutter tooling expects tests to live in a top-level `test/` directory, mirroring your `lib/` structure. This convention allows `dart test` / `flutter test` to auto-discover test files.

```
my_project/
├── lib/
│   ├── src/
│   │   ├── calculator.dart
│   │   └── string_utils.dart
├── test/
│   ├── src/
│   │   ├── calculator_test.dart
│   │   └── string_utils_test.dart
│   └── test_helpers.dart
├── pubspec.yaml
```

Conventions:
- Test files must end in `_test.dart` — the runner only picks up files matching that suffix.
- Mirror the `lib/` folder structure inside `test/` so it's easy to find the test for any given source file.
- Shared setup code (fakes, fixtures, helper functions) can live in non-`_test.dart` files inside `test/` and be imported by your test files.

### Writing your first test

```dart
// lib/calculator.dart
class Calculator {
  int add(int a, int b) => a + b;
}
```

```dart
// test/calculator_test.dart
import 'package:test/test.dart';
import 'package:my_project/calculator.dart';

void main() {
  test('add() returns the sum of two integers', () {
    final calculator = Calculator();

    final result = calculator.add(2, 3);

    expect(result, equals(5));
  });
}
```

Breaking this down:
- `main()` is the entry point the test runner executes.
- `test(description, body)` registers one test case with a human-readable description and a callback containing the Arrange-Act-Assert steps.
- `expect(actual, matcher)` is the assertion — it compares the actual value against an expected condition (a "matcher", covered in Module 4).

### Running tests

```bash
# Run every test in the test/ directory
dart test

# Run a single file
dart test test/calculator_test.dart

# Run a single test by name (substring match)
dart test --name "add()"

# Run tests tagged a certain way (see Module 3)
dart test --tags fast

# Run with more verbose reporting
dart test --reporter expanded

# For Flutter projects
flutter test
flutter test test/calculator_test.dart
```

Useful flags:
- `-j <n>` / `--concurrency=<n>` — control how many test files run in parallel (default is based on CPU cores).
- `--coverage=<dir>` — collect code coverage data (see Module 10).
- `-p chrome` — run tests in Chrome instead of the Dart VM (useful for web-targeted code).

### Understanding test output

A typical passing run looks like:

```
00:01 +1: add() returns the sum of two integers
00:01 +1: All tests passed!
```

- `+1` means one test has passed so far.
- If a test fails, you'll see `+<passed> -<failed>: <test name> [E]`, followed by the failure reason:

```
00:00 +0 -1: add() returns the sum of two integers [E]
  Expected: <6>
    Actual: <5>

  test/calculator_test.dart 8:5  main.<fn>
```

This tells you exactly what was expected, what was actually produced, and the line where the assertion failed — enough information to jump straight to the bug without extra debugging in most cases.

### Organizing test files

- **One test file per source file** is the most common convention (`calculator.dart` → `calculator_test.dart`).
- Use `group()` (Module 3) inside a file to cluster related tests (e.g., all tests for one method).
- Keep test files **flat and readable** — avoid deeply nested helper abstractions that make it hard to see what's being tested.
- Extract **shared fixtures/fakes** into a `test/helpers/` or `test/fixtures/` folder to avoid duplication across files.
- Separate **unit tests**, **widget tests**, and **integration tests** into their own top-level folders when a project has all three, e.g.:

```
test/                → unit tests
test_widget/ or test/widgets/  → widget tests
integration_test/    → Flutter integration tests (special folder name required by tooling)
```

---

## Module 3: Core Testing APIs

These are the building blocks you'll use in nearly every test file.

### `test()`

Registers a single test case.

```dart
test('description of expected behavior', () {
  // Arrange, Act, Assert
});
```
```dart
import 'package:test/test.dart';

void main() {
  test('should return 10 when adding 4 and 6', () {

    // Arrange
    final calculator = Calculator();
    const firstNumber = 4;
    const secondNumber = 6;

    // Act
    final result = calculator.add(firstNumber, secondNumber);

    // Assert
    expect(result, equals(10));
  });
}
```
- The first argument is a description — write it so that a failure message reads like a sentence: `"add() returns the sum of two positive integers"`.
- The body can be synchronous or return a `Future` for async tests (see Module 8).

### `group()`

Groups related tests together, both for organization and for output readability. Groups can nest.

```dart
group('Calculator', () {
  group('add()', () {
    test('adds two positive numbers', () { /* ... */ });
    test('adds a negative and a positive number', () { /* ... */ });
  });

  group('subtract()', () {
    test('subtracts two positive numbers', () { /* ... */ });
  });
});
```

Test output nests the group names, so failures show a full path like `Calculator add() adds two positive numbers`.

Groups also let you scope `setUp()`/`tearDown()` and `tags`/`timeout` to only the tests inside them.

### `expect()`

The core assertion function.

```dart
expect(actual, matcher, {reason, skip});
```

- `actual` — the value produced by your code.
- `matcher` — either a literal value (Dart wraps it in `equals()` automatically) or a `Matcher` object from Module 4.
- `reason` — optional custom failure message, useful in loops/data-driven tests to say *which* case failed.

```dart
expect(2 + 2, 4);                     // simple equality
expect(2 + 2, equals(4));             // explicit matcher
expect(name, isNotEmpty, reason: 'name should never be blank');
```

### `setUp()`

Runs **before every test** in the current file (or current `group()`, if placed inside one). Use it to create fresh objects so tests don't leak state into each other.

```dart
late Calculator calculator;

setUp(() {
  calculator = Calculator(); // fresh instance for every single test
});
```

### `tearDown()`

Runs **after every test**, whether it passed or failed. Use it to release resources — closing files, database connections, streams, timers, etc.

```dart
late File tempFile;

setUp(() => tempFile = File('temp.txt')..createSync());
tearDown(() => tempFile.deleteSync());
```

### `setUpAll()`

Runs **once**, before any test in the file/group — not before each individual test. Use it for expensive setup that can safely be shared across tests (e.g., starting an in-memory server).

```dart
setUpAll(() {
  print('This runs once before all tests in this file/group');
});
```

⚠️ Because the same instance is shared across tests, mutable state set up here can leak between tests if you're not careful. Prefer `setUp()` unless the cost of recreating state is genuinely too high.

### `tearDownAll()`

Runs **once**, after all tests in the file/group have finished. Use it to clean up whatever `setUpAll()` created.

```dart
tearDownAll(() {
  print('This runs once after all tests are done');
});
```

**Execution order recap:**

```
setUpAll()
  setUp() → test 1 → tearDown()
  setUp() → test 2 → tearDown()
  setUp() → test 3 → tearDown()
tearDownAll()
```

### `skip`

Temporarily disables a test (or group) without deleting it — useful for known-broken or work-in-progress tests, with a paper trail of *why* it's skipped.

```dart
test('feature not implemented yet', () {
  // ...
}, skip: 'Waiting on API-123 to be implemented');

// Skip an entire group
group('legacy payment flow', () {
  test('...', () { /* ... */ });
}, skip: true);
```

Skipped tests are reported separately (`+2 ~1: All tests passed!`, where `~1` means one skipped) so they don't silently disappear.

### `timeout`

Fails a test if it takes longer than the given duration — critical for catching hangs (e.g., a `Future` that never completes).

```dart
test('completes within 2 seconds', () async {
  await someLongRunningOperation();
}, timeout: Timeout(Duration(seconds: 2)));

// Relative to the default timeout (default is 30s), e.g. 2x longer
test('slow but legit operation', () async {
  await heavyComputation();
}, timeout: Timeout.factor(2));
```

You can also set a suite-wide default in `dart_test.yaml`:

```yaml
timeout: 60s
```

### `tags`

Labels tests so you can selectively include/exclude them at run time — commonly used to separate fast unit tests from slow integration tests, or to mark flaky/tests that need special infrastructure.

```dart
test('hits the real network', () {
  // ...
}, tags: ['integration', 'network']);
```

```bash
dart test --tags integration        # only run tests tagged 'integration'
dart test --exclude-tags integration # run everything except that tag
```

Tags can also be configured centrally in `dart_test.yaml`, e.g. to require special setup for a tag:

```yaml
tags:
  integration:
    timeout: 2x
```

---

## Module 4: Matchers (Very Important)

A **matcher** is an object that describes *how* to check a value, decoupled from the value itself. Matchers make `expect()` expressive and produce much better failure messages than raw `if`/`assert` checks. They live in `package:matcher` (re-exported by `package:test`).

### `equals`

Deep equality check (works for collections too, unlike `==` on some types).

```dart
expect(actual, equals(5));
expect([1, 2, 3], equals([1, 2, 3])); // element-by-element
expect({'a': 1}, equals({'a': 1}));
```

Note: for primitive values, `expect(actual, 5)` implicitly wraps `5` in `equals(5)` — they're equivalent.

### `isTrue` / `isFalse`

```dart
expect(isPrime(7), isTrue);
expect(isPrime(8), isFalse);
```

Prefer these over `expect(isPrime(7), equals(true))` — they read more naturally and are the idiomatic style.

### `isNull` / `isNotNull`

```dart
expect(findUser('missing-id'), isNull);
expect(findUser('123'), isNotNull);
```

### `contains`

Works on strings, `Iterable`s, and `Map`s.

```dart
expect('hello world', contains('world'));
expect([1, 2, 3], contains(2));
expect({'name': 'Alice', 'age': 30}, containsPair('name', 'Alice'));
```

### `startsWith` / `endsWith`

String-specific matchers.

```dart
expect('hello.dart', endsWith('.dart'));
expect('https://example.com', startsWith('https://'));
```

### `throwsException`

Matches when calling the given function throws any `Exception`.

```dart
expect(() => parseConfig(''), throwsException);
```

### `throwsArgumentError`

More specific — matches only `ArgumentError`.

```dart
expect(() => List.filled(-1, 0), throwsArgumentError);
```

Dart's `matcher` package ships similar ready-made matchers for common exception types: `throwsStateError`, `throwsRangeError`, `throwsFormatException`, `throwsUnsupportedError`, `throwsNoSuchMethodError`, and the general-purpose `throwsA(matcher)` (see Module 7 for full details on exception testing).

### `same`

Checks **identity** (same object in memory), not just equality — the equivalent of Dart's `identical()`.

```dart
final a = SomeObject();
final b = a;
final c = SomeObject();

expect(b, same(a)); // passes — same instance
expect(c, same(a)); // fails — different instance, even if "equal"
```

This matters for testing caching/singleton behavior, where you specifically want to verify no new object was created.

### `closeTo`

For floating-point comparisons, where exact equality is unreliable due to rounding.

```dart
expect(0.1 + 0.2, closeTo(0.3, 0.0001)); // within a delta of 0.3
```

Never use plain `equals()` for computed doubles — floating-point arithmetic almost never lands on an exact value.

### `everyElement`

Passes only if **every** element of an iterable satisfies the given matcher.

```dart
expect([2, 4, 6, 8], everyElement(predicate((n) => n.isEven)));
```

### `anyElement`

Passes if **at least one** element satisfies the given matcher.

```dart
expect([1, 3, 4, 7], anyElement(predicate((n) => n.isEven)));
```

### Custom matchers

When built-in matchers aren't expressive enough, create your own by extending `Matcher`. This is especially useful for asserting on custom domain objects.

```dart
import 'package:matcher/matcher.dart';

class IsValidEmail extends Matcher {
  const IsValidEmail();

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  @override
  bool matches(dynamic item, Map matchState) {
    return item is String && _emailRegex.hasMatch(item);
  }

  @override
  Description describe(Description description) =>
      description.add('a valid email address');
}

const isValidEmail = IsValidEmail();
```

Usage:

```dart
expect('alice@example.com', isValidEmail);
expect('not-an-email', isNot(isValidEmail));
```

For simpler cases, `predicate()` lets you build an inline matcher from a boolean function without a whole class:

```dart
expect(user.age, predicate((int age) => age >= 18, 'is an adult'));
```

Custom matchers pay off quickly once you're asserting the same complex condition (e.g., "is a valid UUID", "is a sorted list", "is within business hours") across many tests.

---

## Module 5: Data Driven Testing

Data-driven testing means running the *same* test logic against many different inputs, so you avoid copy-pasting near-identical test cases.

### Test datasets

Define a list of cases (input + expected output) as plain Dart data, then iterate over it.

```dart
final cases = <({int a, int b, int expected})>[
  (a: 1, b: 1, expected: 2),
  (a: -1, b: 1, expected: 0),
  (a: 0, b: 0, expected: 0),
  (a: 100, b: 200, expected: 300),
];
```

Using Dart records (as above) keeps each case self-documenting compared to positional lists/tuples.

### Looping tests

Generate one `test()` per case inside a loop so failures point to the *specific* case that failed, rather than lumping every input into one giant test.

```dart
void main() {
  final calculator = Calculator();

  final cases = <({int a, int b, int expected})>[
    (a: 1, b: 1, expected: 2),
    (a: -1, b: 1, expected: 0),
    (a: 0, b: 0, expected: 0),
  ];

  for (final c in cases) {
    test('add(${c.a}, ${c.b}) == ${c.expected}', () {
      expect(calculator.add(c.a, c.b), equals(c.expected));
    });
  }
}
```

This produces individual, readable test entries:

```
+1: add(1, 1) == 2
+1: add(-1, 1) == 0
+1: add(0, 0) == 0
```

If one fails, you know instantly *which combination* broke — you don't have to add print statements to figure it out.

### External JSON

For larger datasets, or data shared with other tools/languages, store cases in a JSON fixture file and load it at test time.

```json
// test/fixtures/add_cases.json
[
  { "a": 1, "b": 1, "expected": 2 },
  { "a": -5, "b": 5, "expected": 0 },
  { "a": 10, "b": -3, "expected": 7 }
]
```

```dart
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  final raw = File('test/fixtures/add_cases.json').readAsStringSync();
  final cases = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

  for (final c in cases) {
    test('add(${c['a']}, ${c['b']}) == ${c['expected']}', () {
      expect(Calculator().add(c['a'], c['b']), equals(c['expected']));
    });
  }
}
```

This is especially useful when non-developers (QA, product) maintain the test data, or when the same fixture is shared across a backend and frontend test suite.

### CSV driven tests

For tabular datasets (e.g., exported from a spreadsheet), parse CSV with a package like `csv` and treat each row as a case.

```yaml
dev_dependencies:
  csv: ^6.0.0
```

```csv
a,b,expected
1,1,2
-5,5,0
10,-3,7
```

```dart
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  final raw = File('test/fixtures/add_cases.csv').readAsStringSync();
  final rows = const CsvToListConverter(eol: '\n').convert(raw);
  final header = rows.first;
  final dataRows = rows.skip(1);

  for (final row in dataRows) {
    final a = row[header.indexOf('a')] as int;
    final b = row[header.indexOf('b')] as int;
    final expected = row[header.indexOf('expected')] as int;

    test('add($a, $b) == $expected', () {
      expect(Calculator().add(a, b), equals(expected));
    });
  }
}
```

CSV-driven testing is common when business analysts define test scenarios in a spreadsheet that gets exported and versioned alongside the code.

---

## Module 6: Parameterized Testing

Dart's `package:test` has **no built-in `@ParameterizedTest`-style annotation** (unlike JUnit 5 in Java or pytest in Python). Instead, parameterization is achieved idiomatically through **loops and helper functions**, as introduced in Module 5. This module focuses that pattern specifically for "one behavior, many inputs" scenarios (as opposed to full datasets with expected outputs).

### The loop + helper function pattern

Extract the test body into a reusable function, then call it once per input:

```dart
void main() {
  void expectIsPalindrome(String input, bool expected) {
    test('isPalindrome("$input") == $expected', () {
      expect(isPalindrome(input), equals(expected));
    });
  }

  expectIsPalindrome('racecar', true);
  expectIsPalindrome('hello', false);
  expectIsPalindrome('', true);
  expectIsPalindrome('a', true);
  expectIsPalindrome('Never odd or even', false); // case-sensitive, spaces matter
}
```

### Combining multiple parameters

When a test needs to vary across two or more independent dimensions, use nested loops or the Cartesian product of two lists:

```dart
final roles = ['admin', 'editor', 'viewer'];
final actions = ['create', 'update', 'delete'];

for (final role in roles) {
  for (final action in actions) {
    test('$role can ${canPerform(role, action) ? '' : 'not '}$action', () {
      final allowed = canPerform(role, action);
      expect(allowed, equals(expectedPermission(role, action)));
    });
  }
}
```

### Grouping parameterized tests for readability

Wrap the loop in a `group()` so the parameterized cases are visually separated from unrelated tests in the same file:

```dart
group('isPalindrome', () {
  for (final entry in {
    'racecar': true,
    'hello': false,
    '': true,
  }.entries) {
    test('"${entry.key}" -> ${entry.value}', () {
      expect(isPalindrome(entry.key), equals(entry.value));
    });
  }
});
```

### Why this is "good enough" without built-in annotations

- It's plain Dart — no code generation, no reflection, no extra package required.
- Each generated `test()` still shows up as its own line in the test runner output, with its own pass/fail status — you get the same reporting benefits as a "real" parameterized test framework.
- It composes naturally with everything else in this guide (matchers, `setUp()`, tags, etc.) since it's just regular Dart control flow, not a special DSL.

---

## Module 7: Exception Testing

Verifying that code fails *correctly* — throwing the right error under the right conditions — is just as important as verifying happy-path behavior.

### `throwsException`

Matches any thrown object that is (or extends) `Exception`.

```dart
void validateAge(int age) {
  if (age < 0) throw Exception('Age cannot be negative');
}

test('throws when age is negative', () {
  expect(() => validateAge(-1), throwsException);
});
```

Note: the function passed to `expect()` must **not** be called directly — pass a closure (`() => validateAge(-1)`), so `expect()` can invoke it internally and catch the throw. Calling `validateAge(-1)` directly would throw before `expect()` even runs, crashing the test instead of being asserted on.

### `throwsA`

The general-purpose building block behind all the `throwsXyz` matchers. It accepts **any matcher**, giving you fine-grained control over the thrown object, not just its type.

```dart
expect(
  () => validateAge(-1),
  throwsA(isA<Exception>()),
);

// Match on the exception's message too
expect(
  () => validateAge(-1),
  throwsA(
    isA<Exception>().having(
      (e) => e.toString(),
      'message',
      contains('negative'),
    ),
  ),
);
```

`isA<T>()` checks the runtime type, and `.having()` lets you drill into a property of the matched object and assert on it with another matcher — extremely useful for checking exception messages, error codes, or custom exception fields.

### Custom exceptions

Define domain-specific exceptions so your code's failure modes are self-documenting, and test them precisely with `throwsA(isA<YourException>())`.

```dart
class InsufficientFundsException implements Exception {
  InsufficientFundsException(this.shortfall);
  final double shortfall;

  @override
  String toString() => 'InsufficientFundsException: short by $shortfall';
}

class Account {
  double balance = 100;

  void withdraw(double amount) {
    if (amount > balance) {
      throw InsufficientFundsException(amount - balance);
    }
    balance -= amount;
  }
}
```

```dart
test('withdraw throws InsufficientFundsException when overdrawing', () {
  final account = Account();

  expect(
    () => account.withdraw(150),
    throwsA(
      isA<InsufficientFundsException>()
          .having((e) => e.shortfall, 'shortfall', equals(50)),
    ),
  );
});
```

### Async exceptions

Exceptions thrown inside a `Future` (or during `await`) can't be caught by wrapping a plain closure — you need `expectLater` combined with `throwsA` (or its shorthand matchers), or `try/catch` inside an `async` test.

```dart
Future<void> fetchUser(String id) async {
  if (id.isEmpty) throw ArgumentError('id must not be empty');
  await Future.delayed(Duration(milliseconds: 10));
}
```

```dart
test('fetchUser throws ArgumentError for an empty id', () async {
  await expectLater(
    fetchUser(''),
    throwsA(isA<ArgumentError>()),
  );
});
```

Key rule: for a `Future`-returning function, pass the `Future` itself (or its invocation) to `expectLater`/`expect`, not a wrapped no-arg closure that swallows the `await` — and always `await` the `expectLater()` call itself, since it's asynchronous.

For code using `Stream`s, the equivalent is asserting on a stream that emits an error event — see Module 8 for `emitsError`.

---

## Module 8: Asynchronous Testing

Dart is single-threaded but heavily asynchronous (I/O, timers, network calls). `package:test` has first-class support for testing `Future`s and `Stream`s.

### Futures

Mark the test function `async` and `await` the code under test directly — `package:test` automatically waits for the returned `Future` before considering the test complete.

```dart
Future<int> fetchAnswer() async {
  await Future.delayed(Duration(milliseconds: 5));
  return 42;
}

test('fetchAnswer resolves to 42', () async {
  final result = await fetchAnswer();
  expect(result, equals(42));
});
```

⚠️ A common mistake: forgetting `async`/`await`. If the test body doesn't return the `Future` (or await it), the test may report as passed before the async code even finishes running.

### Streams

Streams can be tested by collecting emitted values (e.g., with `toList()`) or, more idiomatically, using matchers designed for streams: `emits`, `emitsInOrder`, `emitsDone`, `emitsError`.

```dart
Stream<int> countTo(int n) async* {
  for (var i = 1; i <= n; i++) {
    yield i;
  }
}

test('countTo(3) emits 1, 2, 3, then closes', () {
  expect(countTo(3), emitsInOrder([1, 2, 3, emitsDone]));
});

test('a broken stream emits an error', () {
  final controller = StreamController<int>();
  controller.addError(Exception('boom'));

  expect(controller.stream, emitsError(isA<Exception>()));
});
```

### async/await

Standard Dart `async`/`await` works exactly the same inside tests as anywhere else in your code — there's no special syntax to learn, which is one of the nicer aspects of Dart's async testing story.

```dart
test('multiple awaits in sequence', () async {
  final a = await stepOne();
  final b = await stepTwo(a);
  expect(b, equals('expected result'));
});
```

### `expectLater`

The asynchronous counterpart to `expect()`. Use it whenever the matcher itself needs to wait on something asynchronous — matching against a `Future`, a `Stream`, or matchers like `completes`/`throwsA` combined with async values. Always `await` it.

```dart
await expectLater(fetchAnswer(), completion(equals(42)));
```

`expectLater` is also required when running inside a `fakeAsync()` zone or when you need the assertion itself to be awaited before the test proceeds to further assertions.

### `completion`

A matcher that unwraps a `Future` and asserts on its resolved value — a shorthand alternative to manually awaiting and then calling `expect`.

```dart
test('fetchAnswer completes with 42', () {
  expect(fetchAnswer(), completion(equals(42)));
});
```

Note that in this form, the *test callback itself* doesn't need to be `async` because `completion()` internally returns a `Future` that `package:test` will wait on — though many teams prefer the explicit `await`-based style shown earlier for readability and stack traces.

### `throwsA` with Future

Same idea as completion, but for a `Future` that's expected to fail rather than succeed:

```dart
Future<void> alwaysFails() async {
  throw StateError('nope');
}

test('alwaysFails completes with an error', () {
  expect(alwaysFails(), throwsA(isA<StateError>()));
});
```

Behind the scenes, `throwsA` handles both synchronous throws and `Future` rejections — it inspects whether the value passed to it is a `Future` and adapts automatically.

---

## Module 9: Mocking

### Why mocks?

Most real-world code depends on things that are slow, unpredictable, or hard to control in a test: network calls, databases, file systems, the current time, third-party services. **Test doubles** let you replace those dependencies with something you fully control, so tests are:

- **Fast** — no real network/database round-trips.
- **Deterministic** — no flaky failures caused by external state.
- **Focused** — a failure means *your* code is wrong, not that a server was down.
- **Able to simulate edge cases** — e.g., force a network timeout or a 500 error, which is hard to reliably trigger against a real server.

"Mocking" is often used loosely to mean any test double, but there are useful distinctions:

### Fake objects

A **fake** has a real, working implementation, just a simplified one unsuitable for production (e.g., an in-memory database standing in for a real one).

```dart
class FakeUserRepository implements UserRepository {
  final Map<String, User> _storage = {};

  @override
  Future<void> save(User user) async => _storage[user.id] = user;

  @override
  Future<User?> findById(String id) async => _storage[id];
}
```

Fakes are great when you want realistic, stateful behavior without the cost/flakiness of the real dependency.

### Stub objects

A **stub** returns hard-coded, canned answers to calls made during the test, with no real logic behind it.

```dart
class StubClock implements Clock {
  StubClock(this.fixedTime);
  final DateTime fixedTime;

  @override
  DateTime now() => fixedTime;
}
```

Stubs are useful when you just need a predictable value returned (e.g., "pretend it's always Jan 1, 2030") without caring about interaction details.

### Mock objects

A **mock** goes further than a stub: it also lets you *verify* how it was used — which methods were called, with what arguments, how many times. This is central to **behavior verification** (as opposed to just checking output/state).

```dart
verify(() => mockEmailSender.send(any(), any())).called(1);
```

### Mockito

[`mockito`](https://pub.dev/packages/mockito) is Dart's long-standing mocking package, using code generation (`build_runner`) to create mock classes.

```yaml
dev_dependencies:
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepo;

  setUp(() => mockRepo = MockUserRepository());

  test('saves a user and can retrieve it', () async {
    when(mockRepo.findById('1'))
        .thenAnswer((_) async => User(id: '1', name: 'Alice'));

    final user = await mockRepo.findById('1');

    expect(user?.name, equals('Alice'));
    verify(mockRepo.findById('1')).called(1);
  });
}
```

Run `dart run build_runner build` to generate `*.mocks.dart` before running these tests. Mockito's `when()`/`thenReturn()`/`thenAnswer()`/`verify()` API will feel familiar if you've used Mockito in Java.

### Mocktail

[`mocktail`](https://pub.dev/packages/mocktail) provides the same capabilities as Mockito **without code generation**, relying on Dart's `noSuchMethod` — simpler to set up and faster to iterate with, which has made it the more popular choice in newer Flutter projects.

```yaml
dev_dependencies:
  mocktail: ^1.0.0
```

```dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  setUp(() => mockRepo = MockUserRepository());

  test('findById returns the stubbed user', () async {
    when(() => mockRepo.findById('1'))
        .thenAnswer((_) async => User(id: '1', name: 'Alice'));

    final user = await mockRepo.findById('1');

    expect(user?.name, equals('Alice'));
    verify(() => mockRepo.findById('1')).called(1);
  });

  test('throws if the repository fails', () {
    when(() => mockRepo.findById(any())).thenThrow(Exception('DB down'));

    expect(() => mockRepo.findById('1'), throwsException);
  });
}
```

Notes on Mocktail:
- Method stubbing (`when`) and verification (`verify`) wrap calls in a closure `() => ...` — this is required because Mocktail relies on static analysis of the call, not runtime interception the way Mockito's generated code does.
- For non-nullable parameters that aren't `Object`/registered types, you may need to call `registerFallbackValue()` in `setUpAll()` before using `any()` with that type.

**Mockito vs Mocktail at a glance:**

| | Mockito | Mocktail |
|---|---|---|
| Code generation required | Yes (`build_runner`) | No |
| Setup speed | Slower (must regenerate on interface changes) | Faster |
| Null-safety ergonomics | Good | Good, slightly more concise |
| Popularity in new Flutter projects | Declining | Growing |

---

## Module 10: Code Coverage

### What is coverage?

Code coverage measures **how much of your source code executes while running your test suite**, expressed as a percentage. It answers "did any test even run this line?" — it does *not* tell you whether the assertions were meaningful. 100% coverage with weak assertions still lets bugs through; coverage is a *floor*, not a guarantee of quality.

### Line coverage

The most common metric: the percentage of executable lines that were run by at least one test.

```dart
int classify(int n) {
  if (n < 0) return -1;     // line A
  if (n == 0) return 0;     // line B
  return 1;                 // line C
}
```

A test suite that only calls `classify(5)` covers line C but not A or B — line coverage would be roughly 33–66% depending on how the tool counts the `if` lines.

### Branch coverage

A stricter metric: checks that **every branch** of a conditional (`if`/`else`, `switch`, ternary, short-circuit `&&`/`||`) has been exercised in both directions, not just that the line containing the branch ran at all.

For the same `classify` function, branch coverage requires tests hitting: `n < 0` true AND false, `n == 0` true AND false — line coverage can look deceptively high while branch coverage reveals untested paths (e.g., you tested `n < 0` being false, but never tested it being true).

### Measuring coverage

Dart's tooling collects raw coverage data via `--coverage`, then converts it into the standard **LCOV** format for reporting.

```bash
# 1. Add the coverage package
dart pub add --dev coverage

# 2. Run tests with coverage collection
dart test --coverage=coverage

# 3. Convert to LCOV format
dart run coverage:format_coverage \
  --lcov \
  --in=coverage \
  --out=coverage/lcov.info \
  --report-on=lib

# 4. (Optional) Generate an HTML report to browse locally
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

For **Flutter** projects, this is simpler out of the box:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Coverage reports (`lcov.info`) are also what CI services like Codecov or Coveralls ingest to show coverage trends and diffs on pull requests.

### Improving coverage

- Identify uncovered lines/branches from the HTML report (they're usually highlighted in red).
- Prioritize covering **business logic** and **error-handling branches** — these are where real bugs hide, more so than trivial getters/setters.
- Add tests for **edge cases**: empty collections, zero/negative numbers, null values, boundary values (`n == 0`, `n == list.length`).
- Don't chase 100% coverage for its own sake — writing a test just to tick a coverage number, with no meaningful assertion, adds maintenance cost without adding safety. A trivial `toString()` override often isn't worth a dedicated test.
- Use coverage as a **discovery tool** ("what haven't we thought to test?"), not as the sole definition of "well tested".

---

## Module 11: Flutter Testing

Flutter builds on `package:test` with `flutter_test`, adding tools specifically for testing widgets and full app flows.

### Widget tests

Widget tests render a widget in an offline, simulated environment (no real device/emulator needed), letting you verify UI structure and interaction quickly.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments when + is tapped', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CounterPage()));

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // rebuild the widget tree after the tap

    expect(find.text('1'), findsOneWidget);
  });
}
```

Key concepts:
- `testWidgets()` replaces `test()` and provides a `WidgetTester`.
- `tester.pumpWidget()` mounts a widget tree into the test environment.
- `find.byType`, `find.text`, `find.byIcon`, `find.byKey` locate widgets ("finders").
- `tester.tap()`, `tester.enterText()`, `tester.drag()` simulate user interaction.
- `tester.pump()` triggers a frame rebuild (needed after any state change); `tester.pumpAndSettle()` pumps repeatedly until animations finish.
- Matchers like `findsOneWidget`, `findsNothing`, `findsNWidgets(n)` assert on how many matching widgets exist.

Widget tests sit in the "integration" layer of the pyramid relative to plain Dart unit tests — they're slower than pure logic tests but far faster and more reliable than running on a real device.

### Integration tests

Flutter's `integration_test` package runs your **entire app** on a real device, simulator, or in a browser, driving it exactly as a user would — this is the Flutter-specific realization of "end-to-end testing" from Module 1.

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full sign-up flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('email_field')), 'a@b.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'secret123');
    await tester.tap(find.byKey(const Key('submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, a@b.com!'), findsOneWidget);
  });
}
```

Run with:

```bash
flutter test integration_test/app_test.dart
```

Because these tests exercise real platform channels, plugins, and rendering, they catch issues widget tests can't (platform-specific bugs, real navigation, actual animations) — at the cost of being much slower and requiring a device/emulator/browser.

### Golden tests

A **golden test** renders a widget and compares the resulting pixels against a previously saved reference ("golden") image, catching *visual* regressions that assertion-based tests can't (a misaligned padding, a wrong color, a broken layout at a certain screen size).

```dart
testWidgets('ProfileCard matches golden file', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: ProfileCard(name: 'Alice', avatarUrl: '...')),
  );

  await expectLater(
    find.byType(ProfileCard),
    matchesGoldenFile('goldens/profile_card.png'),
  );
});
```

Workflow:
1. First run with `flutter test --update-goldens` to generate the initial reference image — commit it to version control.
2. Subsequent runs render the widget and diff it against that saved file.
3. If a UI change is intentional, regenerate the golden with `--update-goldens` again and review the diff in your PR like any other code change.

⚠️ Golden tests are sensitive to fonts, platform rendering differences, and anti-aliasing — teams typically run them in a controlled environment (e.g., CI with a pinned Flutter version/OS) to avoid false failures from local machine differences.

---

## Module 12: TDD (Test-Driven Development)

TDD is a development workflow where you write a *failing* test **before** writing the implementation, then write just enough code to pass it, then improve the code's structure — repeating in a tight loop.

### Red

Write a test for behavior that doesn't exist yet. Run it — it should **fail** (red), and for the *right reason* (e.g., "method not found" or an assertion mismatch, not a typo in the test itself).

```dart
test('FizzBuzz: multiples of 3 return "Fizz"', () {
  expect(fizzBuzz(3), equals('Fizz'));
});
// fizzBuzz doesn't exist yet -> compile error / test fails
```

### Green

Write the **simplest possible code** that makes the test pass — resist the urge to over-engineer at this stage.

```dart
String fizzBuzz(int n) {
  if (n % 3 == 0) return 'Fizz';
  return n.toString();
}
```

Run the test again — it should now pass (green).

### Refactor

With a passing test as a safety net, clean up the implementation (and/or the test) without changing behavior — remove duplication, improve names, simplify logic. Re-run tests after every change to confirm they still pass.

```dart
String fizzBuzz(int n) {
  if (n % 15 == 0) return 'FizzBuzz';
  if (n % 3 == 0) return 'Fizz';
  if (n % 5 == 0) return 'Buzz';
  return n.toString();
}
```

Then the cycle repeats: write the next failing test (e.g., for multiples of 5, then multiples of 15), make it pass, refactor, and so on — building up the implementation incrementally, always backed by tests.

### Real project examples

**Example: building a `ShoppingCart.total()` with TDD**

1. **Red:** `test('total() is 0 for an empty cart', () => expect(ShoppingCart().total(), equals(0)));` → fails, `ShoppingCart` doesn't exist.
2. **Green:** create `ShoppingCart` with a `total()` that returns `0` (hard-coded) — simplest thing that passes.
3. **Red:** `test('total() sums item prices', () { cart.add(Item(price: 10)); cart.add(Item(price: 5)); expect(cart.total(), equals(15)); });` → fails, since `total()` is still hard-coded.
4. **Green:** implement `total()` as `_items.fold(0, (sum, item) => sum + item.price);` — now both tests pass.
5. **Red:** `test('total() applies a 10% discount over \$100', () { ... expect(cart.total(), equals(90)); });`
6. **Green:** add discount logic.
7. **Refactor:** extract discount calculation into a separate `DiscountPolicy` class once the logic grows complex, re-running the full test suite after each step to confirm nothing broke.

This example shows the core TDD benefit: at every point in development, you have a **passing, growing** test suite that documents exactly what the class is supposed to do — and the design (e.g., extracting `DiscountPolicy`) emerges naturally from making tests easy to write, rather than being guessed upfront.

**Common TDD pitfalls to avoid:**
- Writing several tests at once before implementing anything (defeats the tight feedback loop).
- Skipping the "simplest possible code" step and over-building in the Green phase.
- Skipping the Refactor step entirely, letting technical debt accumulate even though tests pass.

---

## Module 13: Best Practices

### Naming conventions

- Test descriptions should read like a specification: `test('returns null when the user is not found', ...)`, not `test('test1', ...)`.
- A useful pattern: **`methodName_condition_expectedResult`** or a plain English sentence — pick one convention and use it consistently across the codebase.
- `group()` names should identify the unit under test (a class or method), so nested test names read naturally: `Calculator` → `add()` → `"returns the sum of two positive integers"`.
- Name test files after what they test: `user_repository_test.dart` for `user_repository.dart`.

### Arrange-Act-Assert (AAA)

Structure every test body in three clear, visually separated sections:

```dart
test('withdraw() reduces the balance by the withdrawn amount', () {
  // Arrange
  final account = Account(balance: 100);

  // Act
  account.withdraw(30);

  // Assert
  expect(account.balance, equals(70));
});
```

- **Arrange** — set up the object(s) under test and any inputs/dependencies.
- **Act** — perform the single action being tested.
- **Assert** — verify the outcome.

Keeping these visually distinct (even with comments, as above) makes tests easy to scan, and makes it obvious when a test is doing *too much* (multiple "Act" steps usually signal the test should be split).

### FIRST principles

A widely used acronym for what makes a *good* unit test:

- **F — Fast.** Tests should run in milliseconds. Slow tests get skipped or run less often, defeating their purpose.
- **I — Independent/Isolated.** Tests must not depend on each other's execution order or shared mutable state. Any test should be runnable alone and still pass.
- **R — Repeatable.** The same test should produce the same result every time, in any environment (no reliance on system time, random values, or network availability unless explicitly controlled/stubbed).
- **S — Self-validating.** A test should produce a clear pass/fail with no manual inspection of logs required — assertions decide the outcome, not a human reading output.
- **T — Timely.** Tests should be written close to when the production code is written (ideally *before*, as in TDD) — not bolted on months later when the context is lost.

### Clean test code

- **Treat test code as production code.** Apply the same care to naming, structure, and DRY-ness (within reason — see below on duplication).
- **One logical assertion focus per test.** A test can have multiple `expect()` calls, but they should all verify one behavior/scenario — don't test unrelated things in the same test just to save time.
- **Prefer explicit values over shared magic constants** hidden in setup, unless the constant's meaning is obvious from context — a reader shouldn't need to jump around the file to understand what's being tested.
- **Avoid logic in tests.** Loops and conditionals inside a test body make it harder to trust — a bug in the test's own logic can hide a bug in the production code. (The data-driven loop pattern from Module 5/6 is an accepted exception since it generates *separate* simple tests, not conditional logic within one test.)
- **Don't over-mock.** Mock only what's necessary (external dependencies, slow/unreliable collaborators) — mocking everything makes tests brittle and coupled to implementation details rather than behavior.
- **Keep tests independent of execution order** — never rely on one test's side effects to make another test pass; use `setUp()`/`tearDown()` to guarantee a clean slate.
- **Fail with a clear message.** Use the `reason` parameter in `expect()` where the failure wouldn't otherwise be self-explanatory, especially inside loops.
- **Delete or fix broken/skipped tests promptly** — a growing pile of `skip: true` tests erodes trust in the whole suite.
- **Keep the suite fast overall.** Use tags (Module 3) to separate slow integration/golden/e2e tests from the fast unit tests that run on every save, and run the full suite in CI.

---

## Summary: Where to Go From Here

1. Start by writing simple unit tests with `test()`/`expect()` for pure functions.
2. Get comfortable with matchers — they make failures far more diagnosable than raw booleans.
3. Introduce `setUp()`/`tearDown()` once you have shared fixtures across multiple tests.
4. Learn Mocktail (or Mockito) as soon as your code has external dependencies worth isolating.
5. Adopt data-driven/parameterized patterns to keep test files short and readable as edge cases grow.
6. Move into Flutter-specific testing (widget → golden → integration) as your UI stabilizes.
7. Track code coverage as a discovery tool, not a vanity metric.
8. Practice TDD on a small, real feature to internalize the Red-Green-Refactor rhythm.
9. Revisit Module 13's best practices periodically — they're easy to state and easy to drift away from under deadline pressure.

