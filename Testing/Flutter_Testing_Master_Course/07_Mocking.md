# Module 07: Mocking

---

## Module Overview

Real-world Flutter code depends on things that are slow, unpredictable, or unavailable in a test environment — network APIs, databases, device sensors. Mocking lets you replace these dependencies with controlled substitutes so you can test your logic in complete isolation. This module covers test doubles conceptually and `mocktail` practically — the modern, null-safe mocking library for Flutter.

---

## Learning Objectives

- Understand the five types of test doubles: dummy, stub, spy, mock, fake.
- Understand why mocking depends on abstraction (interfaces).
- Use `mocktail` to create mocks, stub methods, and verify interactions.
- Understand `when()`, `thenReturn()`, `thenThrow()`, `verify()`, and argument matchers.
- Avoid common mocking anti-patterns.

---

## Prerequisites

- Modules 05–06

---

## Theory

### Why Mocking Exists

Recall the Independent and Repeatable principles from FIRST (Module 02). A test that hits a real API is:
- **Slow** (network round-trip)
- **Unreliable** (network can fail, API can be down)
- **Non-repeatable** (data may change between runs)
- **Hard to trigger edge cases** (how do you make a real API return a 500 error on demand?)

Mocking solves all four problems by substituting a **test double** for the real dependency, giving you full control over its behavior during the test.

### The Five Types of Test Doubles

These terms (from Martin Fowler's taxonomy) are often used loosely, but precise understanding helps you pick the right tool.

| Type | Description | Example |
|---|---|---|
| **Dummy** | Passed but never actually used; fills a parameter list | An unused `Logger` passed to satisfy a constructor |
| **Fake** | A working but simplified implementation | An in-memory database instead of a real one |
| **Stub** | Returns canned answers to calls, no logic | An API client that always returns a fixed JSON response |
| **Spy** | A stub that also records how it was called | A stub that also tracks call count/arguments |
| **Mock** | Pre-programmed with expectations; verifies interactions occurred | Verifying `repository.save()` was called exactly once |

In everyday Flutter development, "mocking" is used as an umbrella term covering stubs, spies, and true mocks — and `mocktail` provides all three capabilities in one API.

### Mocking Requires Abstraction

You can only mock something you can substitute — which means your code must depend on an **abstraction** (an interface/abstract class), not a concrete implementation. This is the Dependency Inversion Principle in action.

```text
BAD (cannot mock):                 GOOD (mockable):
┌────────────┐                     ┌────────────┐        ┌──────────────────┐
│ UseCase    │                     │  UseCase   │───────►│ Repository        │
│  depends   │                     │            │        │ (abstract class)  │
│  directly  │                     └────────────┘        └──────────────────┘
│  on        │                                                     ▲
│  ApiClient │                                       ┌─────────────┴─────────────┐
└────────────┘                                real impl                    mock impl
```

This is why Module 06 emphasized use cases depending on abstract repositories — that design decision is *what makes mocking possible in the first place*.

### `mocktail` Basics

`mocktail` is the standard modern mocking library for Dart/Flutter (successor to `mockito`, and preferred because it requires no code generation).

```yaml
dev_dependencies:
  mocktail: ^1.0.0
```

**Step 1: Define an abstraction**

```dart
abstract class WeatherRepository {
  Future<double> getTemperature(String city);
}
```

**Step 2: Create a mock class**

```dart
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}
```

**Step 3: Stub behavior with `when()`**

```dart
final mockRepo = MockWeatherRepository();

when(() => mockRepo.getTemperature('London')).thenAnswer((_) async => 15.0);
```

**Step 4: Use the mock in your test**

```dart
test('returns temperature from repository', () async {
  final result = await mockRepo.getTemperature('London');
  expect(result, 15.0);
});
```

**Step 5: Verify interactions**

```dart
verify(() => mockRepo.getTemperature('London')).called(1);
```

### `thenReturn` vs `thenAnswer` vs `thenThrow`

```dart
// Synchronous return
when(() => mock.getValue()).thenReturn(42);

// Return a Future (async methods)
when(() => mock.fetchValue()).thenAnswer((_) async => 42);

// Simulate a thrown exception
when(() => mock.fetchValue()).thenThrow(Exception('Network error'));
```

Use `thenAnswer` (not `thenReturn`) whenever the mocked method returns a `Future` or `Stream` — this is one of the most common beginner mistakes.

### Argument Matchers

```dart
when(() => mockRepo.getTemperature(any())).thenAnswer((_) async => 20.0);

verify(() => mockRepo.getTemperature(any(that: contains('don')))).called(1);
```

`any()` matches any argument value; you can combine with more specific matchers for precise verification.

### Registering Fallback Values

`mocktail` requires registering a fallback value for any custom object type used with `any()` or as a default argument, typically done once in `setUpAll()`:

```dart
class FakeCity extends Fake implements City {}

setUpAll(() {
  registerFallbackValue(FakeCity());
});
```

This is required because `mocktail` needs *some* instance to return when argument matching machinery needs a placeholder for custom types.

---

## Flutter Perspective

Mocking is essential across nearly every layer you'll test in this course:

- **Repository tests** (Module 11): mock the API client / local data source.
- **BLoC tests** (Module 10): mock the repository the BLoC depends on.
- **API tests** (Module 12): mock the HTTP client (`Dio`/`http`).
- **Widget tests** (Module 08): mock BLoCs/services a widget depends on, so widget tests don't need real business logic.

Without mocking, most of these tests would either be impossible to write in isolation or would silently become integration tests in disguise — slow, flaky, and hard to diagnose when they fail.

---

## Diagrams

### Test Double Spectrum

```text
Dummy ──► Fake ──► Stub ──► Spy ──► Mock
(unused)  (simple  (canned  (stub+   (expectations
           working  answers) recording) + verification)
           impl)
```

### Mocking a Dependency Chain

```text
┌─────────────┐      ┌──────────────────┐      ┌─────────────────┐
│    BLoC     │─────►│   Repository     │─────►│   API Client     │
│ (under test)│      │  (abstract, MOCKED)│      │ (never touched) │
└─────────────┘      └──────────────────┘      └─────────────────┘
```

When testing the BLoC, only the repository needs to be mocked — the BLoC never even knows the API client exists.

---

## Code Examples

### Complete Mocking Example

```dart
// lib/repository/weather_repository.dart
abstract class WeatherRepository {
  Future<double> getTemperature(String city);
}

// lib/usecase/get_temperature_usecase.dart
class GetTemperatureUseCase {
  final WeatherRepository repository;
  GetTemperatureUseCase(this.repository);

  Future<String> execute(String city) async {
    final temp = await repository.getTemperature(city);
    if (temp < 0) return 'Freezing in $city';
    if (temp < 20) return 'Cool in $city';
    return 'Warm in $city';
  }
}
```

```dart
// test/usecase/get_temperature_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/repository/weather_repository.dart';
import 'package:my_app/usecase/get_temperature_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockRepository;
  late GetTemperatureUseCase useCase;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetTemperatureUseCase(mockRepository);
  });

  group('GetTemperatureUseCase', () {
    test('returns "Freezing" message for negative temperature', () async {
      when(() => mockRepository.getTemperature('Oslo'))
          .thenAnswer((_) async => -5.0);

      final result = await useCase.execute('Oslo');

      expect(result, 'Freezing in Oslo');
      verify(() => mockRepository.getTemperature('Oslo')).called(1);
    });

    test('returns "Cool" message for temperature between 0-19', () async {
      when(() => mockRepository.getTemperature('London'))
          .thenAnswer((_) async => 12.0);

      final result = await useCase.execute('London');

      expect(result, 'Cool in London');
    });

    test('returns "Warm" message for temperature 20+', () async {
      when(() => mockRepository.getTemperature('Dubai'))
          .thenAnswer((_) async => 35.0);

      final result = await useCase.execute('Dubai');

      expect(result, 'Warm in Dubai');
    });

    test('propagates exceptions from repository', () async {
      when(() => mockRepository.getTemperature('Nowhere'))
          .thenThrow(Exception('City not found'));

      expect(
        () => useCase.execute('Nowhere'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
```

---

## Step-by-Step Explanation

1. Identify the external dependency your unit under test relies on.
2. Confirm the dependency is defined as an abstraction (abstract class/interface) — refactor if not.
3. Create a `Mock` subclass implementing that abstraction with `mocktail`.
4. In `setUp()`, instantiate the mock and inject it into the class under test.
5. Use `when()` to stub the exact scenario each test needs (success, error, edge case).
6. Assert on the *output* of your class under test — and optionally `verify()` the interaction occurred as expected.

---

## Best Practices

- Only mock what you own the abstraction for — don't mock concrete third-party classes directly; wrap them behind your own interface first.
- Use `thenAnswer` for anything async; `thenReturn` for anything synchronous.
- Register fallback values for custom types in `setUpAll()` once, not per test.
- Prefer asserting on output/state over over-using `verify()` — excessive verification couples tests to implementation details.

---

## Common Mistakes

- Using `thenReturn` for a method that returns a `Future`, causing type errors.
- Forgetting `registerFallbackValue()` for custom argument types used with `any()`.
- Mocking too deep — mocking third-party SDK classes directly instead of wrapping them in your own abstraction first.
- Over-verifying every single call, turning tests into brittle mirrors of implementation rather than behavior checks.

---

## Interview Questions

1. What are the five types of test doubles, and how do they differ?
2. Why does mocking require your code to depend on an abstraction rather than a concrete class?
3. What's the difference between `thenReturn` and `thenAnswer` in `mocktail`?
4. Why would you need `registerFallbackValue()`?
5. What's the risk of over-using `verify()` in your tests?

---

## Exercises

1. Create an abstract `PaymentGateway` with a `charge(double amount)` method, mock it, and write tests for a `CheckoutUseCase` that depends on it (success and failure cases).
2. Rewrite a test using `thenReturn` incorrectly on an async method, observe the failure, then fix it with `thenAnswer`.
3. Write a test that verifies a mock method was called exactly twice using `verify(...).called(2)`.

---

## Mini Project

Build a `NotificationService` abstraction with a `send(String message)` method. Build a `ReminderUseCase` that depends on it and sends a reminder only if a given `DateTime` is in the future. Write a full mocktail-based test suite covering: success, past-date rejection, and exception propagation from the service.

---

## Assignment

Refactor one class from an existing Flutter project so that it depends on an abstraction instead of a concrete third-party class (e.g., wrap `http.Client` or `SharedPreferences` behind your own interface). Write a `mocktail`-based test suite for that class, using at least one `thenAnswer`, one `thenThrow`, and one `verify()` call.

---

## Summary

- Mocking replaces slow/unpredictable dependencies with controlled test doubles.
- The five test double types (dummy, fake, stub, spy, mock) serve different purposes.
- Mocking requires depending on abstractions, not concrete implementations.
- `mocktail` provides `when()`/`thenReturn()`/`thenAnswer()`/`thenThrow()`/`verify()` for full control.
- Fallback values must be registered for custom argument types.

---

## Revision Notes

- 5 doubles: Dummy, Fake, Stub, Spy, Mock
- Mockable code = depends on abstraction
- `thenAnswer` for async, `thenReturn` for sync
- `registerFallbackValue()` for custom types with `any()`
- Prefer output assertions over excessive `verify()`

---

## Next Module

Continue with **08_Widget_Testing.md**.
