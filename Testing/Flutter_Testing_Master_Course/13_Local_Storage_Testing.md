# Module 13: Local Storage Testing

---

## Module Overview

Local persistence — key-value storage, secure storage, and local databases — is the other half of the data source layer alongside API clients (Module 12). This module covers testing `SharedPreferences`, `flutter_secure_storage`, and database layers (e.g., `sqflite`, `Hive`, `drift`) without touching real device storage.

---

## Learning Objectives

- Test `SharedPreferences`-based local data sources using its official test helpers.
- Test secure storage abstractions safely, without real keychain/keystore access.
- Test local database (SQL/NoSQL) data sources using in-memory implementations.
- Understand serialization edge cases specific to local storage.
- Apply the same layered-mocking discipline from Modules 11–12 to local storage.

---

## Prerequisites

- Modules 05–07, 11–12

---

## Theory

### Why Local Storage Testing Is Different

Unlike a mocked HTTP client (Module 12), some local storage plugins provide **official in-memory test implementations** rather than requiring you to mock the interface yourself. This is both a convenience and a trap: it's tempting to skip the abstraction layer entirely and use the real plugin's test double directly everywhere — which can quietly reintroduce coupling between your data source tests and the plugin's specific API.

The safest approach remains: **wrap the plugin behind your own abstraction**, exactly as with any other dependency (Module 07), and use the plugin's official test utility only in the concrete implementation's own test file.

### Testing `SharedPreferences`

`shared_preferences` ships `SharedPreferences.setMockInitialValues()`, which sets up an in-memory backing store for tests — no real device storage involved.

```dart
abstract class LocalCacheDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clear();
}

class SharedPrefsCacheDataSource implements LocalCacheDataSource {
  final SharedPreferences prefs;
  SharedPrefsCacheDataSource(this.prefs);

  @override
  Future<void> saveToken(String token) => prefs.setString('auth_token', token);

  @override
  Future<String?> getToken() async => prefs.getString('auth_token');

  @override
  Future<void> clear() => prefs.clear();
}
```

```dart
void main() {
  group('SharedPrefsCacheDataSource', () {
    late SharedPreferences prefs;
    late SharedPrefsCacheDataSource dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      dataSource = SharedPrefsCacheDataSource(prefs);
    });

    test('saveToken then getToken returns saved value', () async {
      await dataSource.saveToken('abc123');
      expect(await dataSource.getToken(), 'abc123');
    });

    test('getToken returns null when nothing saved', () async {
      expect(await dataSource.getToken(), isNull);
    });

    test('clear removes saved token', () async {
      await dataSource.saveToken('abc123');
      await dataSource.clear();
      expect(await dataSource.getToken(), isNull);
    });
  });
}
```

### Testing Secure Storage

`flutter_secure_storage` doesn't ship an official in-memory fake, so the standard approach is to wrap it behind your own abstraction and mock that abstraction with `mocktail` wherever it's consumed (exactly like Module 07/11) — while the concrete implementation itself is thin enough that it often doesn't need heavy testing beyond a smoke-level check, since it's mostly a pass-through to platform APIs that can't run in a pure Dart test environment anyway.

```dart
abstract class SecureTokenStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

class FlutterSecureTokenStorage implements SecureTokenStorage {
  final FlutterSecureStorage storage;
  FlutterSecureTokenStorage(this.storage);

  @override
  Future<void> write(String key, String value) => storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => storage.read(key: key);

  @override
  Future<void> delete(String key) => storage.delete(key: key);
}
```

Any class that *depends on* `SecureTokenStorage` (like a repository) mocks the abstraction — it never needs to know about `flutter_secure_storage` directly, and its tests never touch real secure storage.

### Testing Local Databases (sqflite / Hive / drift)

For SQL databases, `sqflite_common_ffi` provides an in-memory/FFI-based SQLite implementation usable in pure Dart test environments (no real device needed):

```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

setUpAll(() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
});
```

This lets you test real SQL queries against a real (but temporary, in-memory) SQLite database — giving higher confidence than fully mocking the database layer, at a small speed cost. This is a deliberate exception to "always mock the dependency": for query-heavy local database logic, testing against a real (temporary) database catches SQL bugs that a mock never could.

```dart
test('inserting and querying a todo returns the correct row', () async {
  final db = await openDatabase(inMemoryDatabasePath, version: 1,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, done INTEGER)'));

  await db.insert('todos', {'id': '1', 'title': 'Buy milk', 'done': 0});
  final rows = await db.query('todos', where: 'id = ?', whereArgs: ['1']);

  expect(rows.length, 1);
  expect(rows.first['title'], 'Buy milk');

  await db.close();
});
```

For `Hive`, a similar pattern applies using `Hive.init()` pointed at a temporary directory, or `hive_test`'s in-memory setup helpers.

### Serialization Edge Cases

Local storage often stores serialized JSON strings, which introduces its own edge cases distinct from API JSON parsing (Module 12):
- Corrupted/partial JSON from an interrupted write
- Schema migrations (old cached data missing a newly-added field)
- Type coercion issues (`int` stored as `String` in older app versions)

These deserve explicit tests wherever your app reads potentially "stale" cached data written by an older app version.

---

## Flutter Perspective

The layered-mocking discipline from Modules 11–12 fully applies here:

```text
Testing Repository       → mock LocalDataSource abstraction (Module 11)
Testing LocalDataSource  → use SharedPreferences.setMockInitialValues() 
                            or sqflite_common_ffi (this module)
```

The key architectural decision that makes all of this testable is the same one repeated throughout the course: **depend on abstractions, test the concrete implementation with the narrowest realistic test double available** (official mock initializer, in-memory FFI database, or `mocktail` when no official fake exists).

---

## Diagrams

### Local Storage Testing Strategy by Type

```text
SharedPreferences   → setMockInitialValues() (official in-memory fake)
flutter_secure_storage → wrap in abstraction, mock the abstraction elsewhere
sqflite             → sqflite_common_ffi (real SQL, in-memory/temp)
Hive                → temp directory / hive_test in-memory helpers
```

---

## Code Examples

### Testing Cache Freshness Logic (Serialization + Business Logic Combined)

```dart
class CachedProductsDataSource {
  final SharedPreferences prefs;
  CachedProductsDataSource(this.prefs);

  Future<void> cache(List<ProductDto> products) async {
    final json = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString('products_cache', json);
    await prefs.setInt('products_cache_time', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<ProductDto>?> getCachedIfFresh(Duration maxAge) async {
    final timestamp = prefs.getInt('products_cache_time');
    if (timestamp == null) return null;

    final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
    if (age > maxAge) return null;

    final raw = prefs.getString('products_cache');
    if (raw == null) return null;

    final decoded = jsonDecode(raw) as List;
    return decoded.map((json) => ProductDto.fromJson(json)).toList();
  }
}
```

```dart
group('CachedProductsDataSource', () {
  late SharedPreferences prefs;
  late CachedProductsDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = CachedProductsDataSource(prefs);
  });

  test('returns null when nothing has been cached', () async {
    final result = await dataSource.getCachedIfFresh(const Duration(hours: 1));
    expect(result, isNull);
  });

  test('returns cached data when within max age', () async {
    await dataSource.cache([ProductDto(id: '1', name: 'Pen', price: 2.5)]);
    final result = await dataSource.getCachedIfFresh(const Duration(hours: 1));
    expect(result, isNotNull);
    expect(result!.first.name, 'Pen');
  });

  test('returns null when cache is stale', () async {
    await prefs.setInt(
      'products_cache_time',
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
    );
    await prefs.setString('products_cache', jsonEncode([]));

    final result = await dataSource.getCachedIfFresh(const Duration(hours: 1));
    expect(result, isNull);
  });
});
```

---

## Step-by-Step Explanation

1. Determine which local storage mechanism is used (key-value, secure, or database).
2. For `SharedPreferences`, use `setMockInitialValues({})` in `setUp()` for a clean in-memory store per test.
3. For secure storage, wrap in your own abstraction and mock it wherever consumed; keep the concrete wrapper's own tests minimal.
4. For SQL databases, use `sqflite_common_ffi` to run real queries against a temporary in-memory database.
5. Explicitly test cache freshness/expiry and malformed/legacy data scenarios.

---

## Best Practices

- Reset `SharedPreferences` mock values in `setUp()` for every test to avoid cross-test pollution.
- Wrap `flutter_secure_storage` behind your own abstraction — never mock the plugin class directly across your codebase.
- Prefer real (in-memory/FFI) database testing over fully mocking SQL query logic — mocks can't catch SQL syntax/logic bugs.
- Explicitly test stale-cache and malformed-cache scenarios, not just the happy "fresh, well-formed data" path.

---

## Common Mistakes

- Forgetting `setMockInitialValues({})`, causing `SharedPreferences.getInstance()` to fail or leak state between tests.
- Testing SQL query logic entirely through mocks, missing real query bugs that only a real database engine would catch.
- Not testing cache expiry boundaries (Module 04's BVA applies directly here — test exactly at the max-age boundary).
- Assuming cached data is always well-formed, and never testing corrupted/legacy schema scenarios.

---

## Interview Questions

1. Why does `SharedPreferences` testing differ from typical `mocktail`-based dependency testing?
2. Why is it often preferable to test SQL database logic against a real in-memory database rather than fully mocking it?
3. How would you test cache-freshness logic without relying on real wall-clock time delays?
4. Why should `flutter_secure_storage` be wrapped in your own abstraction rather than mocked directly everywhere it's used?
5. What kinds of bugs are specific to local storage serialization, distinct from API JSON parsing bugs?

---

## Exercises

1. Write a test suite for a `ThemePreferenceDataSource` that saves/reads a `bool isDarkMode` value using `SharedPreferences`.
2. Write an in-memory `sqflite_common_ffi` test for a `NotesDatabase` with `insertNote`, `getAllNotes`, and `deleteNote` methods.
3. Write a boundary-value test (Module 04 technique) for cache freshness exactly at, just before, and just after the max-age threshold.

---

## Mini Project

Build a `SettingsLocalDataSource` backed by `SharedPreferences` supporting: `saveLanguage(String)`, `getLanguage()` (default `'en'` if unset), `saveNotificationsEnabled(bool)`, `getNotificationsEnabled()` (default `true`). Write a complete test suite covering defaults, saved values, and overwrite behavior.

---

## Assignment

Design a local database schema (SQL or Hive) for a "Favorites" feature (add/remove/list favorite item IDs). Implement the data source and write a full test suite using an in-memory database/store, covering: adding, removing, listing, duplicate-add handling, and removing a non-existent item.

---

## Summary

- Local storage testing uses the narrowest realistic test double for each mechanism: `setMockInitialValues` for `SharedPreferences`, in-memory FFI for SQL databases, and abstraction-wrapping + `mocktail` for secure storage.
- SQL/database logic benefits from real (in-memory) testing over full mocking, since mocks can't catch query bugs.
- Cache freshness and malformed/legacy data scenarios need explicit boundary-value test coverage.
- The same "depend on abstractions" discipline from Modules 07/11/12 applies fully to local storage.

---

## Revision Notes

- `SharedPreferences.setMockInitialValues({})` per test
- `flutter_secure_storage` → wrap + mock abstraction, don't mock plugin directly
- SQL → `sqflite_common_ffi` in-memory, prefer real queries over mocks
- Test cache freshness boundaries + malformed/legacy data

---

## Next Module

Continue with **14_Integration_Testing.md**.
