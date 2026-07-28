# Module 10: State Management Testing (BLoC)

---

## Module Overview

BLoC (Business Logic Component) is one of the most widely adopted state management patterns in Flutter, prized specifically because it's *highly testable* — BLoCs are plain Dart classes with no widget dependency. This module covers testing Cubits and BLoCs in depth using the `bloc_test` package, including state sequences, mocked dependencies, and stream-based state transitions.

---

## Learning Objectives

- Understand the BLoC pattern and why it's designed for testability.
- Differentiate Cubit (simple) from BLoC (event-driven) testing.
- Use `bloc_test`'s `blocTest()` for expressive state-sequence testing.
- Combine `mocktail` (Module 07) with `bloc_test` to isolate BLoC logic from repositories.
- Test loading/success/error state patterns and debounced/throttled events.

---

## Prerequisites

- Modules 05–07
- Basic familiarity with the `flutter_bloc` package

---

## Theory

### Why BLoC Is Inherently Testable

A Cubit/BLoC has no dependency on `BuildContext` or the widget tree. It's a plain Dart class that:
1. Receives input (a method call for Cubit, an event for BLoC)
2. Optionally depends on other classes (typically repositories, injected via constructor — mockable per Module 07)
3. Emits a sequence of states

This means BLoC logic can be tested with the same speed and isolation as any pure Dart unit test (Module 05) — no `pumpWidget` required.

```text
┌────────────┐   method call/event   ┌────────────┐   emits    ┌─────────────┐
│   UI/Test  │ ─────────────────────►│ Cubit/BLoC │───────────►│ State Stream│
└────────────┘                       └────────────┘            └─────────────┘
                                            │
                                            ▼
                                     Repository (mocked in tests)
```

### Cubit vs BLoC

| | Cubit | BLoC |
|---|---|---|
| Input | Direct method calls | Events (classes) dispatched via `add()` |
| Complexity | Simpler, less boilerplate | More structured, event-driven |
| Best for | Simple state changes | Complex flows, event transformations (debounce, throttle) |

Both expose a `Stream<State>` and a `state` getter, and both are tested using the same `bloc_test` API.

### The `bloc_test` Package

`bloc_test` provides `blocTest()`, purpose-built for testing state sequences without manually managing stream subscriptions.

```yaml
dev_dependencies:
  bloc_test: ^9.0.0
  mocktail: ^1.0.0
```

```dart
blocTest<CounterCubit, int>(
  'emits [1] when increment is called',
  build: () => CounterCubit(),
  act: (cubit) => cubit.increment(),
  expect: () => [1],
);
```

### Anatomy of `blocTest()`

| Parameter | Purpose |
|---|---|
| `build` | Constructs the Cubit/BLoC under test (with mocked dependencies) |
| `seed` | Optionally sets an initial state before `act` runs |
| `act` | Performs the action(s) under test (method call or `add(event)`) |
| `wait` | Adds a delay before evaluating expectations (for debounced logic) |
| `expect` | The **exact ordered list** of states expected to be emitted (not including the initial state) |
| `verify` | Additional assertions/verifications after the states are emitted |
| `errors` | Expected list of errors added to the Cubit/BLoC's error stream |

### Testing Loading/Success/Error Patterns

The most common real-world BLoC pattern is a three (or four) state sequence representing an async operation:

```dart
sealed class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final double temperature;
  WeatherLoaded(this.temperature);
}
class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
```

```dart
class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> fetchWeather(String city) async {
    emit(WeatherLoading());
    try {
      final temp = await repository.getTemperature(city);
      emit(WeatherLoaded(temp));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
```

### Testing Event-Transformed BLoCs (Debounce Example)

Real-world BLoCs (e.g., search-as-you-type) often transform their event stream to debounce or throttle rapid input, using the `bloc_concurrency` package's `EventTransformer`s (`droppable()`, `restartable()`, `sequential()`).

```dart
on<SearchQueryChanged>(
  _onSearchQueryChanged,
  transformer: restartable(),
);
```

Testing this requires `blocTest`'s `wait` parameter to let the debounce/async work complete before assertions run.

---

## Flutter Perspective

BLoC testing is arguably the highest-leverage testing investment in a Flutter app: business logic bugs (wrong state transitions, incorrect error handling, race conditions between rapid user actions) are exactly the kind of defects that are expensive to catch manually but trivial to catch with `blocTest`.

A well-tested BLoC layer means:
- Widget tests can safely **mock** the BLoC (Module 08/09) and focus purely on UI rendering.
- Business logic bugs are caught fast, without needing to interact with any UI at all.
- Refactoring the BLoC's internals is safe as long as the state sequence contract holds.

---

## Diagrams

### BLoC State Sequence Testing Flow

```text
build()  ──► construct Cubit/BLoC with mocked repository
   │
   ▼
seed() (optional) ──► pre-set initial state
   │
   ▼
act()  ──► call method / add event
   │
   ▼
wait() (optional) ──► allow async/debounced work to complete
   │
   ▼
expect()  ──► assert exact ordered state sequence emitted
   │
   ▼
verify() (optional) ──► assert repository interactions
```

---

## Code Examples

### Full Cubit Test Suite

```dart
// lib/repository/weather_repository.dart
abstract class WeatherRepository {
  Future<double> getTemperature(String city);
}

// lib/cubit/weather_cubit.dart
import 'package:bloc/bloc.dart';

sealed class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final double temperature;
  WeatherLoaded(this.temperature);
}
class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> fetchWeather(String city) async {
    emit(WeatherLoading());
    try {
      final temp = await repository.getTemperature(city);
      emit(WeatherLoaded(temp));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
```

```dart
// test/cubit/weather_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/cubit/weather_cubit.dart';
import 'package:my_app/repository/weather_repository.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
  });

  group('WeatherCubit', () {
    test('initial state is WeatherInitial', () {
      final cubit = WeatherCubit(mockRepository);
      expect(cubit.state, isA<WeatherInitial>());
    });

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Loaded] when fetchWeather succeeds',
      build: () {
        when(() => mockRepository.getTemperature('London'))
            .thenAnswer((_) async => 18.0);
        return WeatherCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchWeather('London'),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherLoaded>().having((s) => s.temperature, 'temperature', 18.0),
      ],
      verify: (_) {
        verify(() => mockRepository.getTemperature('London')).called(1);
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [Loading, Error] when fetchWeather fails',
      build: () {
        when(() => mockRepository.getTemperature('Nowhere'))
            .thenThrow(Exception('City not found'));
        return WeatherCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchWeather('Nowhere'),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherError>(),
      ],
    );
  });
}
```

### Testing an Event-Driven BLoC

```dart
blocTest<SearchBloc, SearchState>(
  'debounces rapid query changes and only searches for the last query',
  build: () {
    when(() => mockRepository.search('flu')).thenAnswer((_) async => []);
    when(() => mockRepository.search('flutter'))
        .thenAnswer((_) async => ['Flutter Widget', 'Flutter BLoC']);
    return SearchBloc(mockRepository);
  },
  act: (bloc) {
    bloc.add(SearchQueryChanged('flu'));
    bloc.add(SearchQueryChanged('flutter'));
  },
  wait: const Duration(milliseconds: 350),
  expect: () => [
    isA<SearchLoading>(),
    isA<SearchLoaded>().having((s) => s.results.length, 'results', 2),
  ],
  verify: (_) {
    verifyNever(() => mockRepository.search('flu'));
    verify(() => mockRepository.search('flutter')).called(1);
  },
);
```

---

## Step-by-Step Explanation

1. Identify the Cubit/BLoC's dependencies and mock them with `mocktail`.
2. In `build()`, stub the mocked dependency's behavior for this specific scenario.
3. Use `act()` to trigger the method call or event.
4. If the BLoC does debounced/async work, use `wait` to let it settle.
5. In `expect()`, list the **exact** ordered sequence of states expected (excluding the initial state).
6. Use `verify()` to confirm the correct repository interactions occurred.

---

## Best Practices

- Always test both the success and failure paths for any async BLoC method.
- Use `isA<T>().having(...)` matchers for precise field-level assertions on emitted states, not just type checks.
- Keep `expect()` sequences exact and minimal — don't over-specify unrelated intermediate states.
- Test the *initial state* separately from `blocTest`-driven sequences, using a plain `test()`.

---

## Common Mistakes

- Forgetting that `expect()` in `blocTest` does **not** include the initial/seeded state — only states emitted *during* `act()`.
- Not using `wait` for debounced/throttled BLoCs, causing flaky or incomplete state assertions.
- Testing implementation details (internal method calls) instead of the observable state sequence.
- Mocking the BLoC itself instead of its dependencies when unit testing BLoC logic (only mock the BLoC when testing something else, like a widget, that depends on it).

---

## Interview Questions

1. Why is BLoC considered inherently more testable than some other state management approaches?
2. What's the difference between `build`, `act`, `seed`, and `expect` in `blocTest()`?
3. Why doesn't `expect()` include the BLoC's initial state?
4. How would you test a debounced search BLoC without flaky timing issues?
5. What's the difference between testing a Cubit and testing a BLoC, structurally?

---

## Exercises

1. Write a `blocTest` suite for a `CounterCubit` with `increment()`, `decrement()`, and a rule that count cannot go below 0.
2. Write a `blocTest` suite for an async `LoginBloc` that emits `AuthLoading` → `AuthSuccess`/`AuthFailure` based on a mocked `AuthRepository`.
3. Write a test verifying a BLoC's error state contains the correct error message text using `having()`.

---

## Mini Project

Build a `TodoCubit` with states `TodoInitial`, `TodoLoading`, `TodoLoaded(List<Todo>)`, `TodoError(String)`, and methods `loadTodos()`, `addTodo(Todo)`, `removeTodo(String id)`. Mock a `TodoRepository` dependency. Write a complete `blocTest` suite covering all methods, success and failure paths, and correct state sequences.

---

## Assignment

Take a BLoC/Cubit from an existing Flutter project (or design one: a `CartCubit` managing add/remove/clear operations with a running total). Write a complete `bloc_test` suite covering every public method, every possible state sequence (success/error/edge cases), and at least one `verify()`-based interaction check.

---

## Summary

- BLoC/Cubit are plain Dart classes, making them naturally unit-testable without widgets.
- `bloc_test`'s `blocTest()` expressively tests state sequences via `build`/`act`/`expect`/`verify`.
- `expect()` lists states emitted *during* `act()`, not including the initial state.
- Combine `mocktail` for dependencies with `blocTest` for state sequence assertions.
- Debounced/throttled BLoCs require the `wait` parameter to test reliably.

---

## Revision Notes

- BLoC/Cubit = plain Dart, no widget dependency
- `blocTest`: build → seed → act → wait → expect → verify
- `expect()` excludes initial state
- `having()` for field-level state assertions
- `wait` needed for debounce/throttle testing

---

## Next Module

Continue with **11_Repository_Testing.md**.
