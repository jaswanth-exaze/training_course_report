# Module 06: Flutter Unit Testing

---

## Module Overview

This module focuses specifically on unit testing within a Flutter project structure — organizing test files, testing models, services, use cases, and utility/business logic that a real Flutter app is built from. It bridges the pure-Dart fundamentals of Module 05 into Flutter project conventions.

---

## Learning Objectives

- Structure a Flutter project's `test/` folder to mirror `lib/`.
- Write unit tests for data models (`fromJson`, `toJson`, `copyWith`, equality).
- Write unit tests for use cases / services following Clean Architecture principles.
- Apply test design techniques (Module 04) to real Flutter business logic.
- Understand naming conventions and test organization at scale.

---

## Prerequisites

- Module 05: Dart Testing Fundamentals

---

## Theory

### Mirroring Project Structure

A maintainable Flutter test suite mirrors the `lib/` folder structure inside `test/`. This makes it trivial to find the test for any given source file.

```text
lib/
├── models/
│   └── user.dart
├── services/
│   └── auth_service.dart
└── utils/
    └── validators.dart

test/
├── models/
│   └── user_test.dart
├── services/
│   └── auth_service_test.dart
└── utils/
    └── validators_test.dart
```

### What Belongs in a Unit Test?

A unit test should test **one unit in isolation** — meaning any external dependency (network, database, other classes with their own complex logic) should be replaced with a test double (Module 07 covers mocking in depth). At this stage, focus on units with **no external dependencies**: models, pure functions, and simple services.

### Testing Data Models

Flutter apps typically model API/domain data using classes with:
- A constructor
- `fromJson`/`toJson` (serialization)
- `copyWith` (immutable updates)
- Value equality (via `==`/`hashCode`, or packages like `equatable`/`freezed`)

Each of these deserves its own explicit test — they are common sources of subtle bugs (a forgotten field in `copyWith`, a typo in a JSON key, broken equality breaking BLoC state comparisons later).

### Testing Use Cases / Services

In a layered (Clean) architecture, **use cases** encapsulate a single business operation, often depending on abstractions (repository interfaces) rather than concrete implementations. This makes them naturally unit-testable by substituting a fake/mock repository — a preview of Module 07 and Module 11.

### Naming Conventions

Consistent naming makes test failures self-explanatory in CI logs.

```text
group('ClassName', () {
  group('methodName', () {
    test('returns X when Y', () { ... });
    test('throws Z when W', () { ... });
  });
});
```

This nested structure produces readable failure output like:

```text
ClassName > methodName > throws Z when W   FAILED
```

---

## Flutter Perspective

Unit tests in Flutter should **never**:
- Call `pumpWidget`
- Depend on `BuildContext`
- Touch real network/database/file system

If a test needs any of these, it's no longer a pure unit test — it belongs in widget testing (Module 08), repository testing (Module 11), or integration testing (Module 14).

A good rule of thumb: **if your unit test suite takes more than a few seconds to run for hundreds of tests, something is not actually isolated.**

---

## Diagrams

### Test Folder Mirrors Lib Folder

```text
lib/features/auth/
├── data/
│   └── models/user_model.dart
├── domain/
│   └── usecases/login_usecase.dart
└── presentation/
    └── ...

test/features/auth/
├── data/
│   └── models/user_model_test.dart
└── domain/
    └── usecases/login_usecase_test.dart
```

---

## Code Examples

### Testing a Data Model

```dart
// lib/models/user.dart
class User {
  final String id;
  final String name;
  final int age;

  const User({required this.id, required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        age: json['age'] as int,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'age': age};

  User copyWith({String? id, String? name, int? age}) => User(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
      );

  @override
  bool operator ==(Object other) =>
      other is User && other.id == id && other.name == name && other.age == age;

  @override
  int get hashCode => Object.hash(id, name, age);
}
```

```dart
// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user.dart';

void main() {
  group('User', () {
    const json = {'id': '1', 'name': 'Alice', 'age': 30};
    const user = User(id: '1', name: 'Alice', age: 30);

    test('fromJson creates a correct User instance', () {
      expect(User.fromJson(json), user);
    });

    test('toJson produces the correct map', () {
      expect(user.toJson(), json);
    });

    test('copyWith updates only specified fields', () {
      final updated = user.copyWith(age: 31);
      expect(updated.age, 31);
      expect(updated.name, user.name);
      expect(updated.id, user.id);
    });

    test('two users with identical fields are equal', () {
      const other = User(id: '1', name: 'Alice', age: 30);
      expect(user, other);
    });

    test('users with different fields are not equal', () {
      const other = User(id: '2', name: 'Bob', age: 25);
      expect(user, isNot(other));
    });
  });
}
```

### Testing a Use Case with an Abstract Dependency

```dart
// lib/domain/usecases/calculate_total_usecase.dart
class CalculateTotalUseCase {
  double execute(List<double> prices, {double taxRate = 0.0}) {
    if (prices.isEmpty) return 0.0;
    final subtotal = prices.fold(0.0, (sum, price) => sum + price);
    return subtotal + (subtotal * taxRate);
  }
}
```

```dart
// test/domain/usecases/calculate_total_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/domain/usecases/calculate_total_usecase.dart';

void main() {
  group('CalculateTotalUseCase', () {
    late CalculateTotalUseCase useCase;

    setUp(() => useCase = CalculateTotalUseCase());

    test('returns 0 for empty price list', () {
      expect(useCase.execute([]), 0.0);
    });

    test('sums prices with no tax by default', () {
      expect(useCase.execute([10.0, 20.0, 30.0]), 60.0);
    });

    test('applies tax rate correctly', () {
      final result = useCase.execute([100.0], taxRate: 0.1);
      expect(result, closeTo(110.0, 0.001));
    });

    test('handles a single price with zero tax', () {
      expect(useCase.execute([50.0]), 50.0);
    });
  });
}
```

---

## Step-by-Step Explanation

1. Locate the source file in `lib/` you want to test.
2. Create a mirrored file path under `test/`.
3. Identify every public method/behavior that needs coverage.
4. Apply EP + BVA (Module 04) to derive meaningful test cases, not arbitrary ones.
5. Write tests grouped by class, then by method.
6. Confirm the test suite runs fast (no widget bindings, no real I/O).

---

## Best Practices

- Test serialization (`fromJson`/`toJson`) explicitly — these are common sources of production bugs from API contract drift.
- Test `copyWith` for every field, not just one, to catch forgotten fields.
- Test equality explicitly if you rely on it elsewhere (e.g., BLoC state comparison).
- Keep unit tests free of any widget/BuildContext/real I/O dependency.

---

## Common Mistakes

- Testing a model's constructor but skipping `fromJson`/`toJson`, leaving serialization bugs undetected.
- Only testing the "happy path" of a use case and ignoring empty/edge inputs.
- Letting unit tests silently depend on real repositories/network calls, making them slow and flaky.
- Inconsistent naming making CI failure output hard to interpret.

---

## Interview Questions

1. Why should a Flutter unit test never call `pumpWidget`?
2. What common bugs does testing `copyWith` catch that testing the constructor alone would miss?
3. How should test folder structure relate to `lib/` folder structure, and why?
4. Why is testing `fromJson`/`toJson` particularly important for API-driven apps?
5. What distinguishes a true "unit" test from an integration test in Flutter?

---

## Exercises

1. Write a `Product` model with `fromJson`/`toJson`/`copyWith`/equality, and a full test suite for it.
2. Write a `DiscountUseCase` that takes a price and a percentage and returns the discounted price, with EP+BVA-derived tests.
3. Refactor an existing test file to follow the `group(Class) > group(method) > test(behavior)` nesting convention.

---

## Mini Project

Build a small **Shopping Cart** domain layer:
- `CartItem` model (`fromJson`/`toJson`/`copyWith`/equality)
- `CalculateCartTotalUseCase` (handles quantity, price, optional discount code)
- A complete unit test suite for both, using EP+BVA and decision-table-derived test cases from Module 04.

---

## Assignment

Take an existing Flutter project (yours or an open-source one). Identify 3 models and 2 use cases/services with no external dependencies. Write full unit test suites for all 5, following every convention covered in this module.

---

## Summary

- Flutter unit tests should mirror the `lib/` structure inside `test/`.
- Models deserve explicit tests for `fromJson`, `toJson`, `copyWith`, and equality.
- Use cases with abstract dependencies are naturally isolated and unit-testable.
- Nested `group`/`test` naming produces self-explanatory CI failure output.
- True unit tests never touch widgets, `BuildContext`, or real I/O.

---

## Revision Notes

- Mirror `lib/` → `test/`
- Always test: constructor, fromJson, toJson, copyWith, equality
- Nested groups: Class > Method > Behavior
- No widgets, no BuildContext, no real I/O in unit tests

---

## Next Module

Continue with **07_Mocking.md**.
