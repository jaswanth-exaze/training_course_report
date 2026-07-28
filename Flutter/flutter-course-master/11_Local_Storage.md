# Flutter Local Storage

Storing data locally on the device for offline access and preferences.

---

## SharedPreferences

Simple key-value storage for small data.

### Installation:

```yaml
dependencies:
  shared_preferences: ^2.0.0
```

### Basic Usage:

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Save data
Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();
  
  await prefs.setString('username', 'John');
  await prefs.setInt('age', 30);
  await prefs.setBool('isDarkMode', true);
  await prefs.setDouble('rating', 4.5);
  await prefs.setStringList('tags', ['flutter', 'dart']);
}

// Retrieve data
Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();
  
  String username = prefs.getString('username') ?? 'Guest';
  int age = prefs.getInt('age') ?? 0;
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  double rating = prefs.getDouble('rating') ?? 0.0;
  List<String> tags = prefs.getStringList('tags') ?? [];
  
  print('Username: $username');
}

// Delete data
Future<void> deleteData() async {
  final prefs = await SharedPreferences.getInstance();
  
  await prefs.remove('username');
  await prefs.clear();  // Clear all
}
```

### Complete Example:

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
```

### Limitations:

- Small data only (< 1MB)
- No complex structures
- Not encrypted
- Not suitable for sensitive data

---

## SQLite with sqflite

Relational database for complex data structures.

### Installation:

```yaml
dependencies:
  sqflite: ^2.0.0
  path: ^1.8.0
```

### Database Helper Class:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'app_database.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        age INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add migration logic here
      await db.execute('ALTER TABLE users ADD COLUMN avatar_url TEXT');
    }
  }
  
  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
```

### Model Classes:

```dart
class User {
  final int? id;
  final String name;
  final String email;
  final int? age;
  final String? avatarUrl;
  final DateTime? createdAt;
  
  User({
    this.id,
    required this.name,
    required this.email,
    this.age,
    this.avatarUrl,
    this.createdAt,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}

class Post {
  final int? id;
  final int userId;
  final String title;
  final String? content;
  final DateTime? createdAt;
  
  Post({
    this.id,
    required this.userId,
    required this.title,
    this.content,
    this.createdAt,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
    };
  }
  
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['content'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}
```

### CRUD Operations:

```dart
class UserRepository {
  final DatabaseHelper _dbHelper;
  
  UserRepository(this._dbHelper);
  
  // Create
  Future<int> insertUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  // Read all
  Future<List<User>> getUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }
  
  // Read by ID
  Future<User?> getUser(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
  
  // Update
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  
  // Delete
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Search
  Future<List<User>> searchUsers(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'name LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }
  
  // Complex queries
  Future<List<User>> getUsersWithPosts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT u.*, COUNT(p.id) as post_count
      FROM users u
      LEFT JOIN posts p ON u.id = p.user_id
      GROUP BY u.id
      ORDER BY post_count DESC
    ''');
    
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }
}
```

### Transactions:

```dart
class TransactionRepository {
  final DatabaseHelper _dbHelper;
  
  TransactionRepository(this._dbHelper);
  
  Future<void> createUserWithPosts(User user, List<Post> posts) async {
    final db = await _dbHelper.database;
    
    await db.transaction((txn) async {
      // Insert user
      final userId = await txn.insert('users', user.toMap());
      
      // Insert posts
      for (var post in posts) {
        final postMap = post.toMap();
        postMap['user_id'] = userId;
        await txn.insert('posts', postMap);
      }
    });
  }
  
  Future<void> deleteUserWithPosts(int userId) async {
    final db = await _dbHelper.database;
    
    await db.transaction((txn) async {
      // Delete posts first (due to foreign key constraint)
      await txn.delete(
        'posts',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      
      // Delete user
      await txn.delete(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
    });
  }
}
```

---

## Hive NoSQL

Fast, lightweight NoSQL database with type safety.

### Installation:

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
```

### Setup:

```dart
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String usersBox = 'users';
  static const String settingsBox = 'settings';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters for custom objects
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(PostAdapter());
    
    // Open boxes
    await Hive.openBox<User>(usersBox);
    await Hive.openBox(settingsBox);
  }
  
  static Future<void> close() async {
    await Hive.close();
  }
}

// Generate adapters: flutter pub run build_runner build
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String email;
  
  @HiveField(2)
  int? age;
  
  @HiveField(3)
  List<Post>? posts;
  
  User({
    required this.name,
    required this.email,
    this.age,
    this.posts,
  });
}

@HiveType(typeId: 1)
class Post extends HiveObject {
  @HiveField(0)
  String title;
  
  @HiveField(1)
  String? content;
  
  @HiveField(2)
  DateTime createdAt;
  
  Post({
    required this.title,
    this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
```

### CRUD Operations:

```dart
class HiveRepository {
  // Create/Update
  Future<void> saveUser(User user) async {
    final box = Hive.box<User>(HiveService.usersBox);
    await box.put(user.email, user); // Use email as key
  }
  
  // Read
  Future<User?> getUser(String email) async {
    final box = Hive.box<User>(HiveService.usersBox);
    return box.get(email);
  }
  
  Future<List<User>> getAllUsers() async {
    final box = Hive.box<User>(HiveService.usersBox);
    return box.values.toList();
  }
  
  // Delete
  Future<void> deleteUser(String email) async {
    final box = Hive.box<User>(HiveService.usersBox);
    await box.delete(email);
  }
  
  // Listen to changes
  Stream<List<User>> watchUsers() {
    final box = Hive.box<User>(HiveService.usersBox);
    return box.watch().map((event) => box.values.toList());
  }
  
  // Settings (primitive types)
  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(HiveService.settingsBox);
    await box.put(key, value);
  }
  
  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(HiveService.settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }
}
```

### Advanced Hive Features:

```dart
class AdvancedHiveRepository {
  // Lazy boxes for large datasets
  Future<void> initLazyBox() async {
    await Hive.openLazyBox<User>('lazy_users');
  }
  
  Future<User?> getUserLazy(String email) async {
    final box = await Hive.openLazyBox<User>('lazy_users');
    return await box.get(email);
  }
  
  // Encrypted boxes
  Future<void> initEncryptedBox() async {
    const key = 'your-encryption-key';
    await Hive.openBox('encrypted_data', encryptionCipher: HiveAesCipher(key.codeUnits));
  }
  
  // Relationships
  Future<void> saveUserWithPosts(User user) async {
    final userBox = Hive.box<User>(HiveService.usersBox);
    final postBox = Hive.box<Post>('posts');
    
    // Save posts first
    final savedPosts = <Post>[];
    for (var post in user.posts ?? []) {
      await postBox.add(post);
      savedPosts.add(post);
    }
    
    // Save user with post references
    user.posts = savedPosts;
    await userBox.put(user.email, user);
  }
  
  // Queries and filtering
  Future<List<User>> findUsersByAge(int minAge, int maxAge) async {
    final box = Hive.box<User>(HiveService.usersBox);
    return box.values.where((user) => 
      user.age != null && user.age! >= minAge && user.age! <= maxAge
    ).toList();
  }
  
  Future<List<User>> searchUsers(String query) async {
    final box = Hive.box<User>(HiveService.usersBox);
    final lowercaseQuery = query.toLowerCase();
    return box.values.where((user) =>
      user.name.toLowerCase().contains(lowercaseQuery) ||
      user.email.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}
```

---

## File System Storage

### Path Provider:

```yaml
dependencies:
  path_provider: ^2.0.0
  path: ^1.8.0
```

```dart
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }
  
  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }
  
  Future<String> readData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }
  
  Future<bool> fileExists() async {
    final file = await _localFile;
    return file.exists();
  }
  
  Future<void> deleteFile() async {
    final file = await _localFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  // JSON storage
  Future<void> saveJson(Map<String, dynamic> data) async {
    final jsonString = jsonEncode(data);
    await writeData(jsonString);
  }
  
  Future<Map<String, dynamic>?> loadJson() async {
    try {
      final jsonString = await readData();
      if (jsonString.isEmpty) return null;
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }
}
```

### Cache Directory:

```dart
class CacheService {
  Future<String> get _cachePath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
  
  Future<File> getCacheFile(String filename) async {
    final path = await _cachePath;
    return File('$path/$filename');
  }
  
  Future<void> cacheImage(String url, List<int> bytes) async {
    final filename = url.hashCode.toString();
    final file = await getCacheFile(filename);
    await file.writeAsBytes(bytes);
  }
  
  Future<List<int>?> getCachedImage(String url) async {
    final filename = url.hashCode.toString();
    final file = await getCacheFile(filename);
    
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  }
  
  Future<void> clearCache() async {
    final path = await _cachePath;
    final directory = Directory(path);
    
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
  
  Future<String> getCacheSize() async {
    final path = await _cachePath;
    final directory = Directory(path);
    
    if (!await directory.exists()) return '0 B';
    
    int totalSize = 0;
    await for (var entity in directory.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    
    return _formatBytes(totalSize);
  }
  
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).round()} MB';
    return '${(bytes / (1024 * 1024 * 1024)).round()} GB';
  }
}
```

---

## Secure Storage

### Flutter Secure Storage:

```yaml
dependencies:
  flutter_secure_storage: ^8.0.0
```

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // iOS Options
  IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  
  // Android Options
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  
  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
  
  Future<String?> readSecureData(String key) async {
    return await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
  
  Future<void> deleteSecureData(String key) async {
    await _storage.delete(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
  
  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
  
  // Auth tokens
  Future<void> saveAuthToken(String token) async {
    await writeSecureData('auth_token', token);
  }
  
  Future<String?> getAuthToken() async {
    return await readSecureData('auth_token');
  }
  
  Future<void> clearAuthToken() async {
    await deleteSecureData('auth_token');
  }
}
```

---

## Data Persistence Patterns

### Repository Pattern:

```dart
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUser(int id);
  Future<void> saveUser(User user);
  Future<void> deleteUser(int id);
  Future<List<User>> searchUsers(String query);
}

class OfflineFirstUserRepository implements UserRepository {
  final RemoteUserRepository _remoteRepo;
  final LocalUserRepository _localRepo;
  final NetworkService _networkService;
  
  OfflineFirstUserRepository(
    this._remoteRepo,
    this._localRepo,
    this._networkService,
  );
  
  @override
  Future<List<User>> getUsers() async {
    if (await _networkService.isConnected()) {
      try {
        final users = await _remoteRepo.getUsers();
        await _localRepo.saveUsers(users); // Cache locally
        return users;
      } catch (e) {
        // Network failed, return cached data
        return await _localRepo.getUsers();
      }
    } else {
      // Offline, return cached data
      return await _localRepo.getUsers();
    }
  }
  
  @override
  Future<User?> getUser(int id) async {
    // Try local first
    final localUser = await _localRepo.getUser(id);
    if (localUser != null) return localUser;
    
    // If not found locally and online, fetch from remote
    if (await _networkService.isConnected()) {
      try {
        final user = await _remoteRepo.getUser(id);
        if (user != null) {
          await _localRepo.saveUser(user);
        }
        return user;
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }
  
  @override
  Future<void> saveUser(User user) async {
    // Save locally first
    await _localRepo.saveUser(user);
    
    // Sync to remote if online
    if (await _networkService.isConnected()) {
      try {
        await _remoteRepo.saveUser(user);
      } catch (e) {
        // Mark as pending sync
        await _localRepo.markUserForSync(user.id!);
      }
    } else {
      // Mark as pending sync
      await _localRepo.markUserForSync(user.id!);
    }
  }
  
  @override
  Future<void> deleteUser(int id) async {
    await _localRepo.deleteUser(id);
    
    if (await _networkService.isConnected()) {
      try {
        await _remoteRepo.deleteUser(id);
      } catch (e) {
        // Handle deletion sync later
      }
    }
  }
  
  @override
  Future<List<User>> searchUsers(String query) async {
    // Search locally first
    final localResults = await _localRepo.searchUsers(query);
    
    // If online, also search remote and merge results
    if (await _networkService.isConnected()) {
      try {
        final remoteResults = await _remoteRepo.searchUsers(query);
        // Merge and deduplicate results
        return _mergeSearchResults(localResults, remoteResults);
      } catch (e) {
        return localResults;
      }
    }
    
    return localResults;
  }
  
  List<User> _mergeSearchResults(List<User> local, List<User> remote) {
    final merged = <User>[...local];
    for (final remoteUser in remote) {
      if (!merged.any((u) => u.id == remoteUser.id)) {
        merged.add(remoteUser);
      }
    }
    return merged;
  }
  
  Future<void> syncPendingChanges() async {
    if (!await _networkService.isConnected()) return;
    
    final pendingUsers = await _localRepo.getUsersPendingSync();
    for (final user in pendingUsers) {
      try {
        await _remoteRepo.saveUser(user);
        await _localRepo.markUserSynced(user.id!);
      } catch (e) {
        // Handle sync failure
      }
    }
  }
}
```

### Migration Strategies:

```dart
class DatabaseMigrationService {
  final DatabaseHelper _dbHelper;
  
  DatabaseMigrationService(this._dbHelper);
  
  Future<void> migrateFromVersion(int oldVersion, int newVersion) async {
    final db = await _dbHelper.database;
    
    await db.transaction((txn) async {
      if (oldVersion < 2) {
        await _migrateToVersion2(txn);
      }
      
      if (oldVersion < 3) {
        await _migrateToVersion3(txn);
      }
      
      // Add more migrations as needed
    });
  }
  
  Future<void> _migrateToVersion2(DatabaseExecutor txn) async {
    // Add new columns
    await txn.execute('ALTER TABLE users ADD COLUMN phone TEXT');
    await txn.execute('ALTER TABLE users ADD COLUMN avatar_url TEXT');
    
    // Migrate existing data if needed
    await txn.execute('''
      UPDATE users 
      SET phone = '', avatar_url = '' 
      WHERE phone IS NULL OR avatar_url IS NULL
    ''');
  }
  
  Future<void> _migrateToVersion3(DatabaseExecutor txn) async {
    // Create new table
    await txn.execute('''
      CREATE TABLE user_preferences (
        user_id INTEGER PRIMARY KEY,
        theme TEXT DEFAULT 'light',
        notifications_enabled INTEGER DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    // Migrate preferences from old storage
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';
    final notifications = prefs.getBool('notifications') ?? true;
    
    await txn.insert('user_preferences', {
      'user_id': 1, // Default user
      'theme': theme,
      'notifications_enabled': notifications ? 1 : 0,
    });
  }
  
  Future<void> exportData() async {
    final db = await _dbHelper.database;
    
    // Export users
    final users = await db.query('users');
    final userJson = jsonEncode(users);
    
    // Export posts
    final posts = await db.query('posts');
    final postJson = jsonEncode(posts);
    
    // Save to file
    final exportData = {
      'users': userJson,
      'posts': postJson,
      'exported_at': DateTime.now().toIso8601String(),
    };
    
    final exportFile = File('/path/to/export.json');
    await exportFile.writeAsString(jsonEncode(exportData));
  }
  
  Future<void> importData(String jsonData) async {
    final data = jsonDecode(jsonData);
    final db = await _dbHelper.database;
    
    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete('posts');
      await txn.delete('users');
      
      // Import users
      final users = jsonDecode(data['users']) as List;
      for (final user in users) {
        await txn.insert('users', user);
      }
      
      // Import posts
      final posts = jsonDecode(data['posts']) as List;
      for (final post in posts) {
        await txn.insert('posts', post);
      }
    });
  }
}
```

---

## Summary

- **SharedPreferences**: Simple key-value storage for small data
- **SQLite with sqflite**: Relational database for complex data structures
- **Hive NoSQL**: Fast, lightweight NoSQL with type safety
- **File System**: Direct file operations for large data
- **Secure Storage**: Encrypted storage for sensitive data
- **Repository Pattern**: Abstraction layer for data operations
- **Offline-First**: Local storage with remote sync
- **Migrations**: Database schema updates and data migration

Choose storage based on data complexity, size, and security requirements.

## SQLite with sqflite

Relational database for complex data structures.

### Installation:

```yaml
dependencies:
  sqflite: ^2.0.0
  path: ^1.8.0
```

### Database Setup:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static const String _databaseName = 'myapp.db';
  static const int _databaseVersion = 1;

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN age INTEGER');
    }
  }
}
```

### Model Class:

```dart
class User {
  final int? id;
  final String name;
  final String email;
  final String createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: map['createdAt'],
    );
  }
}
```

### CRUD Operations:

```dart
class UserDao {
  final DatabaseService _dbService = DatabaseService();

  // Create
  Future<int> insertUser(User user) async {
    final db = await _dbService.database;
    return db.insert('users', user.toMap());
  }

  // Read all
  Future<List<User>> getAllUsers() async {
    final db = await _dbService.database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  // Read one
  Future<User?> getUserById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update
  Future<int> updateUser(User user) async {
    final db = await _dbService.database;
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete
  Future<int> deleteUser(int id) async {
    final db = await _dbService.database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Complex Query
  Future<List<User>> getUsersCreatedAfter(String date) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      where: 'createdAt > ?',
      whereArgs: [date],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => User.fromMap(map)).toList();
  }
}
```

### Transactions:

```dart
Future<void> transferData() async {
  final db = await _dbService.database;
  
  await db.transaction((txn) async {
    // Multiple operations in a single transaction
    await txn.insert('users', {'name': 'John'});
    await txn.insert('logs', {'action': 'user_created'});
  });
}
```

---

## Hive (NoSQL Local DB)

A lightweight key-value database for complex objects.

### Installation:

```yaml
dependencies:
  hive: ^2.2.0
  hive_flutter: ^1.1.0
dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.0.0
```

### Model Class:

```dart
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late int age;
}
```

### Generate:

```bash
flutter pub run build_runner build
```

### Setup:

```dart
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  
  runApp(const MyApp());
}
```

### Basic Usage:

```dart
// Open box
final box = await Hive.openBox<User>('users');

// Add
final user = User()
  ..name = 'John'
  ..email = 'john@example.com'
  ..age = 30;

await box.add(user);

// Read
final allUsers = box.values.toList();
final firstUser = box.getAt(0);

// Update
user.name = 'Jane';
await user.save();

// Delete
await user.delete();

// Query by value
final users = box.values.where((u) => u.age > 25).toList();

// Clear all
await box.clear();
```

### Working with Collections:

```dart
// Get box
final usersBox = await Hive.openBox<User>('users');

// Add multiple
for (var i = 0; i < 100; i++) {
  final user = User()..name = 'User $i';
  await usersBox.add(user);
}

// Query
final adults = usersBox.values.where((u) => u.age >= 18).toList();

// Stream
usersBox.watch().listen((event) {
  print('Box changed: $event');
});
```

---

## Comparison

| Feature | SharedPreferences | SQLite | Hive |
|---------|------------------|--------|------|
| Data Type | Primitives | Relational | Objects |
| Complexity | Simple | Complex | Medium |
| Performance | Fast | Moderate | Very Fast |
| Relations | No | Yes | No |
| Size Limit | Small | Large | Large |
| Query | Key-value | SQL | Dart |

---

## Best Practices

1. **SharedPreferences**: App settings, user preferences
2. **SQLite**: Structured data, relationships
3. **Hive**: Object storage, fast access
4. **Encrypt sensitive data** before storing
5. **Use migrations** for database updates
6. **Cache API responses** locally
7. **Clear old data** periodically

---

## Summary

- **SharedPreferences**: Simple key-value storage
- **SQLite**: Relational database with queries
- **Hive**: Fast NoSQL object storage
- Use appropriate storage for your data type
- Always encrypt sensitive information
- Handle data migration properly
