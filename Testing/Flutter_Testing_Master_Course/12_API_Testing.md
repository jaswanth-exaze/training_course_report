# Module 12: API Testing

---

## Module Overview

This module goes one layer deeper than repository testing — into the data source itself, where your app actually talks HTTP to a backend. You'll learn to test API clients built on `Dio` or `http` without ever making a real network call, using mocked HTTP clients and interceptors, and how to handle status codes, timeouts, and malformed responses.

---

## Learning Objectives

- Test API/data source classes built on `Dio` or `http` in complete isolation from the network.
- Mock HTTP responses for success, error status codes, and malformed data.
- Test timeout and connectivity failure handling.
- Test request construction (headers, query params, body serialization).
- Understand the difference between mocking the HTTP client vs. using an HTTP mock server.

---

## Prerequisites

- Modules 05–07, 11

---

## Theory

### Why API Clients Need Their Own Isolated Tests

The remote data source (Module 11's `RemoteDataSource`) is the class that actually constructs HTTP requests and parses responses. Its job is narrow but critical:
- Build the correct request (URL, method, headers, body)
- Interpret the response status code correctly
- Parse the response body into DTOs
- Translate HTTP-level failures into domain-level exceptions

None of this should ever be tested by hitting a **real** network — that would violate the Repeatable and Fast FIRST principles (Module 02).

### Two Approaches to Mocking HTTP

| Approach | How it works | When to use |
|---|---|---|
| **Mock the client class** | Mock `Dio`/`http.Client` directly with `mocktail` | Fast, most common, good for unit-level isolation |
| **Mock HTTP server / interceptor** | Use `dio`'s `DioAdapter` (from `http_mock_adapter`) or a local mock server | When testing interceptors, retries, or request/response transformation pipelines |

Most day-to-day API data source testing uses the first approach — mocking the client class itself.

### Mocking `Dio`

```dart
class MockDio extends Mock implements Dio {}
```

```dart
when(() => mockDio.get('/products')).thenAnswer(
  (_) async => Response(
    requestOptions: RequestOptions(path: '/products'),
    statusCode: 200,
    data: [
      {'id': '1', 'name': 'Pen', 'price': 2.5}
    ],
  ),
);
```

### Testing Status Code Handling

A well-designed API client translates HTTP status codes into meaningful domain exceptions:

```dart
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductDto>> fetchProducts() async {
    final response = await dio.get('/products');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => ProductDto.fromJson(json))
          .toList();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else if (response.statusCode == 500) {
      throw ServerException();
    } else {
      throw UnknownApiException(response.statusCode);
    }
  }
}
```

This branching logic is exactly the kind of decision-table-worthy code (Module 04) that deserves one test per status code path.

### Testing Timeouts and Connectivity Errors

```dart
when(() => mockDio.get('/products')).thenThrow(
  DioException(
    requestOptions: RequestOptions(path: '/products'),
    type: DioExceptionType.connectionTimeout,
  ),
);
```

```dart
test('throws TimeoutException on connection timeout', () async {
  when(() => mockDio.get('/products')).thenThrow(
    DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.connectionTimeout,
    ),
  );

  expect(
    () => dataSource.fetchProducts(),
    throwsA(isA<TimeoutException>()),
  );
});
```

### Testing Request Construction

It's easy to assume a request is built correctly and only test the response handling — but request-construction bugs (wrong header, missing auth token, wrong query param) are just as common. Use `verify()` to assert the request was constructed as expected.

```dart
test('sends correct auth header and query params', () async {
  when(() => mockDio.get(any(),
      queryParameters: any(named: 'queryParameters'),
      options: any(named: 'options'))).thenAnswer((_) async => successResponse);

  await dataSource.fetchProducts(category: 'stationery');

  verify(() => mockDio.get(
        '/products',
        queryParameters: {'category': 'stationery'},
        options: any(named: 'options'),
      )).called(1);
});
```

### Testing Malformed Responses

Real APIs occasionally send unexpected shapes (a null field, a string instead of a number). A robust data source should fail predictably rather than crash with an unhandled type error.

```dart
test('throws ParsingException when response has unexpected shape', () async {
  when(() => mockDio.get('/products')).thenAnswer(
    (_) async => Response(
      requestOptions: RequestOptions(path: '/products'),
      statusCode: 200,
      data: {'unexpected': 'shape'}, // not a List as expected
    ),
  );

  expect(() => dataSource.fetchProducts(), throwsA(isA<ParsingException>()));
});
```

---

## Flutter Perspective

Well-tested API data sources give you a huge amount of confidence with almost no runtime cost, because:
- No real network calls means tests run in milliseconds, even for dozens of status-code/error scenarios.
- Backend team changes/downtime never break your test suite.
- You can test edge cases (500 errors, timeouts, malformed JSON) that are difficult or impossible to trigger against a real backend on demand.

This is also where **contract testing** becomes relevant in larger teams — verifying your mocked responses actually match what the real backend returns (often via shared OpenAPI/Swagger specs or Pact contracts), which is out of scope for this course but worth knowing about as you scale to production teams.

---

## Diagrams

### API Client Testing Boundary

```text
┌────────────────┐     mocked      ┌─────────────┐
│  Data Source    │ ───────────────►│  Dio/http    │  (never touches real network)
│  (under test)   │◄─────────────── │  Client mock │
└────────────────┘   canned response└─────────────┘
```

### Status Code Decision Table (Test Design Applied)

| Status Code | Expected Behavior |
|---|---|
| 200 | Parse and return DTOs |
| 404 | Throw `NotFoundException` |
| 401 | Throw `UnauthorizedException` |
| 500 | Throw `ServerException` |
| (timeout) | Throw `TimeoutException` |
| 200 + malformed body | Throw `ParsingException` |

---

## Code Examples

### Full API Data Source Test Suite

```dart
// test/data/datasources/product_remote_datasource_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/data/datasources/product_remote_datasource.dart';
import 'package:my_app/core/exceptions.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ProductRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = ProductRemoteDataSourceImpl(mockDio);
  });

  group('fetchProducts', () {
    test('returns list of ProductDto on 200', () async {
      when(() => mockDio.get('/products')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/products'),
          statusCode: 200,
          data: [
            {'id': '1', 'name': 'Pen', 'price': 2.5},
          ],
        ),
      );

      final result = await dataSource.fetchProducts();

      expect(result.length, 1);
      expect(result.first.name, 'Pen');
    });

    test('throws NotFoundException on 404', () async {
      when(() => mockDio.get('/products')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/products'),
          statusCode: 404,
        ),
      );

      expect(() => dataSource.fetchProducts(),
          throwsA(isA<NotFoundException>()));
    });

    test('throws ServerException on 500', () async {
      when(() => mockDio.get('/products')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/products'),
          statusCode: 500,
        ),
      );

      expect(
          () => dataSource.fetchProducts(), throwsA(isA<ServerException>()));
    });

    test('throws TimeoutException on connection timeout', () async {
      when(() => mockDio.get('/products')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
          () => dataSource.fetchProducts(), throwsA(isA<TimeoutException>()));
    });
  });
}
```

---

## Step-by-Step Explanation

1. Mock the HTTP client class (`Dio`/`http.Client`) directly — never make a real network call.
2. For each meaningful status code (derived via decision table), stub a `Response` and assert the correct outcome.
3. Test connectivity/timeout failures by throwing the client's specific exception type.
4. Test request construction correctness (headers, params, body) using `verify()`.
5. Test malformed/unexpected response shapes to confirm graceful, typed failure rather than a crash.

---

## Best Practices

- Never let a test suite make a real network call — this is a hard rule, not a suggestion.
- Cover every status code your app's error-handling logic branches on.
- Test both response parsing *and* request construction — both are common bug sources.
- Translate raw HTTP/Dio exceptions into your own domain-specific exception types, and test that translation explicitly.

---

## Common Mistakes

- Accidentally hitting a real API in "unit" tests because the client wasn't actually mocked.
- Only testing the 200 success path and ignoring 4xx/5xx/timeout branches.
- Not testing malformed response bodies, leading to unhandled `TypeError`s in production.
- Forgetting to verify request construction (query params, headers), assuming it's "obviously correct."

---

## Interview Questions

1. Why should API/data source tests never touch a real network?
2. What are the two main approaches to mocking HTTP in Flutter tests, and when would you choose each?
3. How would you test that your app gracefully handles a malformed JSON response?
4. Why is it important to translate raw `DioException`s into your own domain-specific exceptions?
5. How do you verify that a request was constructed with the correct headers and query parameters?

---

## Exercises

1. Write tests for an API data source handling a `401 Unauthorized` response, ensuring it throws a specific `UnauthorizedException`.
2. Write a test verifying a POST request sends the correct JSON body using `verify()`.
3. Write a test simulating a `DioExceptionType.connectionError` (no internet) and assert it maps to a `NoInternetException`.

---

## Mini Project

Build a `AuthRemoteDataSource` with a `login(email, password)` method. Requirements:
- 200 → parse and return an auth token DTO
- 401 → throw `InvalidCredentialsException`
- 429 → throw `TooManyAttemptsException`
- Timeout → throw `TimeoutException`
- Malformed response → throw `ParsingException`

Write a complete test suite covering all branches, plus a request-construction verification test.

---

## Assignment

Take (or design) an API data source with at least 4 distinct status-code/error branches. Write a full decision-table-driven test suite, plus at least 2 request-construction verification tests and 1 malformed-response test.

---

## Summary

- API/data source tests mock the HTTP client class directly — never a real network call.
- Status code branching logic should be tested exhaustively via decision tables.
- Timeout and connectivity failures need explicit test coverage using the client's exception types.
- Request construction (headers, params, body) deserves its own verification tests.
- Malformed responses should fail predictably with domain-specific exceptions, not crash.

---

## Revision Notes

- Mock `Dio`/`http.Client` directly, never hit real network
- Cover every status code branch (200/4xx/5xx/timeout)
- Verify request construction, not just response handling
- Malformed response → typed exception, tested explicitly

---

## Next Module

Continue with **13_Local_Storage_Testing.md**.
