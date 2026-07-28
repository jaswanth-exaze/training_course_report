# Module 11: Repository Testing

---

## Module Overview

The repository layer sits between your business logic (BLoCs/use cases) and your data sources (remote APIs, local databases, caches). It's responsible for coordinating those sources and translating raw data into domain models. This module covers testing repositories in isolation, including caching strategies and the "remote-first, fallback-to-cache" pattern common in production apps.

---

## Learning Objectives

- Understand the Repository Pattern and its role in Clean Architecture.
- Test repositories that coordinate multiple data sources.
- Test caching and offline-fallback logic.
- Test data mapping between DTOs (data transfer objects) and domain models.
- Apply decision-table test design (Module 04) to repository branching logic.

---

## Prerequisites

- Modules 05–07, 10

---

## Theory

### The Repository Pattern

A repository provides a clean, abstracted API for data access, hiding *where* the data actually comes from (network, local database, cache) from the rest of the app.

```text
┌──────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  BLoC/UseCase│────►│   Repository     │────►│  Remote DataSource│ (API)
└──────────────┘     │  (coordinates)   │     └─────────────────┘
                      │                  │     ┌─────────────────┐
                      │                  │────►│  Local DataSource │ (cache/DB)
                      └─────────────────┘     └─────────────────┘
```

This layering is exactly what makes BLoC testing (Module 10) possible without touching real data — the repository is the seam we mock. Now, in this module, we test the *repository itself*, which means mocking one layer deeper: the data sources.

### Why Test Repositories Separately from BLoCs?

The repository often contains **non-trivial branching logic**:
- Fetch from network; on failure, fall back to cache
- Fetch from cache first if fresh; otherwise hit network
- Merge/transform data from multiple sources
- Handle partial failures gracefully

This logic deserves its own dedicated, isolated tests — separate from both the BLoC (Module 10) that consumes the repository and the data sources (Module 12/13) that the repository consumes.

### Testing Data Source Coordination

```dart
abstract class RemoteDataSource {
  Future<List<ProductDto>> fetchProducts();
}

abstract class LocalDataSource {
  Future<List<ProductDto>> getCachedProducts();
  Future<void> cacheProducts(List<ProductDto> products);
}

class ProductRepository {
  final RemoteDataSource remote;
  final LocalDataSource local;
  ProductRepository(this.remote, this.local);

  Future<List<Product>> getProducts() async {
    try {
      final dtos = await remote.fetchProducts();
      await local.cacheProducts(dtos);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (_) {
      final cached = await local.getCachedProducts();
      return cached.map((dto) => dto.toDomain()).toList();
    }
  }
}
```

This is a classic **remote-first, cache-fallback** pattern. Testing it requires a **decision table** (Module 04) of scenarios:

| Remote Succeeds? | Cache Called? | Result Source |
|---|---|---|
| Yes | Yes (to update cache) | Remote data |
| No | Yes (to read cache) | Cached data |

### Testing Data Mapping (DTO → Domain)

Repositories are often the boundary where raw API/DB data (DTOs) is converted into clean domain models used by the rest of the app. Mapping bugs (wrong field, wrong type conversion, wrong default) are common and deserve explicit tests, closely related to Module 06's model testing.

---

## Flutter Perspective

In a typical Flutter Clean Architecture project:

```text
lib/features/products/
├── data/
│   ├── datasources/
│   │   ├── product_remote_datasource.dart
│   │   └── product_local_datasource.dart
│   ├── models/
│   │   └── product_dto.dart
│   └── repositories/
│       └── product_repository_impl.dart
├── domain/
│   ├── entities/product.dart
│   ├── repositories/product_repository.dart (abstract)
│   └── usecases/get_products_usecase.dart
```

The **repository test** targets `product_repository_impl.dart`, mocking both `ProductRemoteDataSource` and `ProductLocalDataSource`. This is distinct from:
- **Data source tests** (Module 12/13) — mock the raw HTTP client / local storage plugin instead.
- **Use case tests** (Module 06) — mock the repository's *abstract interface* instead.

---

## Diagrams

### Layered Mocking Strategy

```text
Testing UseCase   → mock Repository (abstract)
Testing Repository → mock RemoteDataSource + LocalDataSource
Testing RemoteDataSource → mock HTTP Client (Dio/http)
Testing LocalDataSource  → mock SharedPreferences / Database
```

Each layer is tested in isolation by mocking exactly *one level down* — never skipping layers or mocking too deep.

### Remote-First, Cache-Fallback Decision Flow

```text
getProducts()
     │
     ▼
Try remote.fetchProducts()
     │
   ┌─┴─┐
 success  failure
   │        │
   ▼        ▼
cache it   read local.getCachedProducts()
   │        │
   ▼        ▼
return remote data   return cached data
```

---

## Code Examples

### Full Repository Test Suite

```dart
// lib/data/models/product_dto.dart
class ProductDto {
  final String id;
  final String name;
  final double price;
  ProductDto({required this.id, required this.name, required this.price});

  Product toDomain() => Product(id: id, name: name, price: price);
}

// lib/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  const Product({required this.id, required this.name, required this.price});

  @override
  bool operator ==(Object other) =>
      other is Product && other.id == id && other.name == name && other.price == price;

  @override
  int get hashCode => Object.hash(id, name, price);
}
```

```dart
// test/data/repositories/product_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/data/datasources/product_local_datasource.dart';
import 'package:my_app/data/datasources/product_remote_datasource.dart';
import 'package:my_app/data/models/product_dto.dart';
import 'package:my_app/data/repositories/product_repository_impl.dart';
import 'package:my_app/domain/entities/product.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProductLocalDataSource {}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late ProductRepositoryImpl repository;

  final dtoList = [ProductDto(id: '1', name: 'Pen', price: 2.5)];
  final domainList = [const Product(id: '1', name: 'Pen', price: 2.5)];

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = ProductRepositoryImpl(mockRemote, mockLocal);

    registerFallbackValue(<ProductDto>[]);
  });

  group('ProductRepositoryImpl.getProducts', () {
    test('returns remote data and caches it when remote call succeeds',
        () async {
      when(() => mockRemote.fetchProducts()).thenAnswer((_) async => dtoList);
      when(() => mockLocal.cacheProducts(any())).thenAnswer((_) async {});

      final result = await repository.getProducts();

      expect(result, domainList);
      verify(() => mockLocal.cacheProducts(dtoList)).called(1);
      verifyNever(() => mockLocal.getCachedProducts());
    });

    test('falls back to cached data when remote call fails', () async {
      when(() => mockRemote.fetchProducts())
          .thenThrow(Exception('Network error'));
      when(() => mockLocal.getCachedProducts())
          .thenAnswer((_) async => dtoList);

      final result = await repository.getProducts();

      expect(result, domainList);
      verify(() => mockLocal.getCachedProducts()).called(1);
      verifyNever(() => mockLocal.cacheProducts(any()));
    });

    test('returns empty list when both remote and cache fail', () async {
      when(() => mockRemote.fetchProducts())
          .thenThrow(Exception('Network error'));
      when(() => mockLocal.getCachedProducts())
          .thenAnswer((_) async => <ProductDto>[]);

      final result = await repository.getProducts();

      expect(result, isEmpty);
    });
  });
}
```

---

## Step-by-Step Explanation

1. Identify all data sources the repository coordinates.
2. Mock each data source at its abstract interface boundary.
3. Derive a decision table (Module 04) of all meaningful success/failure combinations.
4. Write one test per row of the decision table.
5. Assert both the returned domain data **and** the correct interaction pattern (e.g., cache was/wasn't called).

---

## Best Practices

- Mock exactly one layer down — never mock the HTTP client directly inside a repository test.
- Always test the fallback/error path, not just the happy path.
- Verify *both* outcome (`expect`) and interaction (`verify`) for coordination logic — the interaction matters here because the repository's job is coordination, not just computation.
- Keep DTO→domain mapping tests separate and explicit (can live alongside Module 06-style model tests).

---

## Common Mistakes

- Mocking the HTTP client directly in repository tests, effectively skipping/duplicating the data source layer's own tests.
- Testing only the "remote succeeds" path and never validating cache-fallback behavior.
- Forgetting to verify that cache-writing (`cacheProducts`) only happens when appropriate (e.g., not verifying it's skipped on the fallback path).
- Not testing the "both sources fail" edge case, which often surfaces as an unhandled crash in production.

---

## Interview Questions

1. Why is repository testing kept separate from both use case testing and data source testing?
2. Describe the "remote-first, cache-fallback" pattern and how you'd derive test cases for it.
3. Why is it important to verify interactions (like whether cache was written to) in repository tests, not just the returned data?
4. Where does DTO-to-domain mapping typically belong in a Clean Architecture project, and how should it be tested?
5. What happens if you mock too deep (e.g., the HTTP client) when testing a repository?

---

## Exercises

1. Write a repository test suite for a `UserRepository` that fetches from remote first, and returns a default "Guest" user domain object if both remote and local fail.
2. Extend the `ProductRepositoryImpl` example to include a `isCacheStale(Duration)` check, and write tests for "cache is fresh, skip remote" and "cache is stale, hit remote" scenarios.
3. Write a mapping-specific test verifying a DTO with a null optional field maps to a sensible domain default.

---

## Mini Project

Build a `NewsRepository` that:
- Fetches articles from a remote API
- Caches them locally on success
- Falls back to cache on failure
- Returns an explicit "no data available" domain result if both fail

Write a complete decision-table-driven test suite covering all branches.

---

## Assignment

Take (or design) a repository from a real project with at least two data sources. Write a full test suite that: mocks both data sources, covers every meaningful success/failure combination via a decision table, and explicitly verifies both returned data and correct interaction patterns (e.g., cache writes only happening when expected).

---

## Summary

- The Repository Pattern abstracts data source coordination away from business logic.
- Repository tests mock data sources one layer down — never the raw HTTP client or database plugin directly.
- Remote-first/cache-fallback and similar coordination logic should be tested via decision tables.
- Both returned data (`expect`) and interaction patterns (`verify`) matter in repository tests.
- DTO-to-domain mapping deserves explicit, dedicated test coverage.

---

## Revision Notes

- Repository tests mock DataSources, not raw HTTP/DB clients
- Remote-first/cache-fallback = decision table candidate
- Verify both outcome AND interaction (cache written or not)
- DTO → Domain mapping tested explicitly

---

## Next Module

Continue with **12_API_Testing.md**.
