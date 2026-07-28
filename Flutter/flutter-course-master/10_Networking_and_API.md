# Flutter Networking & API

Communicating with backend servers is essential for most applications.

---

## HTTP Library

The most popular package for HTTP requests in Flutter.

### Installation:

```yaml
dependencies:
  http: ^1.0.0
```

### Basic HTTP Request:

```dart
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/data'),
    );

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
```

### HTTP Methods:

```dart
// GET
final response = await http.get(Uri.parse('https://api.example.com/data'));

// POST
final response = await http.post(
  Uri.parse('https://api.example.com/data'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'name': 'John', 'age': 30}),
);

// PUT
final response = await http.put(
  Uri.parse('https://api.example.com/data/1'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'name': 'Jane'}),
);

// DELETE
final response = await http.delete(
  Uri.parse('https://api.example.com/data/1'),
);

// PATCH
final response = await http.patch(
  Uri.parse('https://api.example.com/data/1'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'status': 'active'}),
);
```

### Advanced HTTP Requests:

```dart
// With timeout
final response = await http.get(
  Uri.parse('https://api.example.com/data'),
).timeout(Duration(seconds: 10));

// With custom headers
final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'User-Agent': 'MyApp/1.0',
  },
);

// Multipart request (file upload)
var request = http.MultipartRequest(
  'POST',
  Uri.parse('https://api.example.com/upload'),
);

request.files.add(
  await http.MultipartFile.fromPath('file', filePath),
);

request.fields['description'] = 'File description';

var response = await request.send();
```

---

## REST API Integration

### Model Definition:

```dart
class User {
  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
```

### API Service Class:

```dart
class ApiService {
  static const String baseUrl = 'https://api.example.com';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // GET request
  Future<List<User>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request
  Future<User> createUser(String name, String email) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/users'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT request
  Future<User> updateUser(int id, String name, String email) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE request
  Future<void> deleteUser(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Add auth token if available
      // 'Authorization': 'Bearer $token',
    };
  }

  void dispose() {
    _client.close();
  }
}
```

### Using the API Service:

```dart
class UserProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  UserProvider(this._apiService);

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(String name, String email) async {
    try {
      final newUser = await _apiService.createUser(name, email);
      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUser(int id, String name, String email) async {
    try {
      final updatedUser = await _apiService.updateUser(id, name, email);
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeUser(int id) async {
    try {
      await _apiService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
```

---

## Dio - Advanced HTTP Client

A powerful HTTP client with interceptors, transformers, and more features.

### Installation:

```yaml
dependencies:
  dio: ^5.0.0
```

### Basic Dio Setup:

```dart
import 'package:dio/dio.dart';

class DioClient {
  static const String baseUrl = 'https://api.example.com';
  
  late Dio _dio;
  
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add interceptors
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      AuthInterceptor(),
    ]);
  }
  
  Dio get dio => _dio;
}

// Auth interceptor
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token to requests
    final token = getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized
      refreshToken();
    }
    super.onError(err, handler);
  }
}
```

### Dio API Service:

```dart
class DioApiService {
  final DioClient _dioClient;
  
  DioApiService(this._dioClient);
  
  Future<List<User>> getUsers() async {
    try {
      final response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<User> createUser(String name, String email) async {
    try {
      final response = await _dioClient.dio.post(
        '/users',
        data: {
          'name': name,
          'email': email,
        },
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<User> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.dio.put('/users/$id', data: data);
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> deleteUser(int id) async {
    try {
      await _dioClient.dio.delete('/users/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // File upload
  Future<String> uploadFile(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dioClient.dio.post('/upload', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
```

---

## JSON Parsing and Serialization

### Manual JSON Handling:

```dart
// Simple parsing
Map<String, dynamic> jsonData = jsonDecode(jsonString);
User user = User.fromJson(jsonData);

// Complex nested objects
class Post {
  final int id;
  final String title;
  final User author;
  final List<Comment> comments;
  
  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.comments,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      author: User.fromJson(json['author']),
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }
}
```

### Using json_serializable:

```yaml
dependencies:
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.6.0
```

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Generate: flutter pub run build_runner build
```

### Custom Converters:

```dart
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();
  
  @override
  DateTime fromJson(String json) => DateTime.parse(json);
  
  @override
  String toJson(DateTime object) => object.toIso8601String();
}

@JsonSerializable()
class Event {
  @DateTimeConverter()
  final DateTime date;
  
  Event({required this.date});
  
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
```

---

## Async/Await Patterns

### Future Handling:

```dart
class ApiService {
  // Sequential requests
  Future<List<Post>> getUserPosts(int userId) async {
    final user = await getUser(userId);
    final posts = await getPosts(user.id);
    return posts;
  }
  
  // Parallel requests
  Future<UserWithPosts> getUserWithPosts(int userId) async {
    final futures = await Future.wait([
      getUser(userId),
      getPosts(userId),
    ]);
    
    return UserWithPosts(
      user: futures[0] as User,
      posts: futures[1] as List<Post>,
    );
  }
  
  // Error handling with try-catch
  Future<User?> getUserSafe(int userId) async {
    try {
      return await getUser(userId);
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }
  
  // Timeout handling
  Future<User> getUserWithTimeout(int userId) async {
    return await getUser(userId).timeout(
      Duration(seconds: 10),
      onTimeout: () => throw Exception('Request timeout'),
    );
  }
}
```

### Stream Handling:

```dart
class StreamApiService {
  // Convert Future to Stream
  Stream<User> getUserStream(int userId) async* {
    try {
      final user = await getUser(userId);
      yield user;
    } catch (e) {
      yield* Stream.error(e);
    }
  }
  
  // Periodic updates
  Stream<List<Post>> getPostsStream() async* {
    while (true) {
      try {
        final posts = await getPosts();
        yield posts;
        await Future.delayed(Duration(seconds: 30)); // Poll every 30 seconds
      } catch (e) {
        yield* Stream.error(e);
        await Future.delayed(Duration(seconds: 5)); // Retry after 5 seconds
      }
    }
  }
}
```

---

## Error Handling

### Comprehensive Error Handling:

```dart
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;
  
  NetworkException(this.message, {this.statusCode, this.details});
  
  @override
  String toString() => 'NetworkException: $message';
}

class ApiErrorHandler {
  static Exception handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is http.ClientException) {
      return _handleHttpError(error);
    } else if (error is FormatException) {
      return NetworkException('Invalid response format');
    } else if (error is TimeoutException) {
      return NetworkException('Request timeout');
    } else {
      return NetworkException('Unknown error: $error');
    }
  }
  
  static Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.sendTimeout:
        return NetworkException('Send timeout');
      case DioExceptionType.receiveTimeout:
        return NetworkException('Receive timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        return NetworkException(message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      default:
        return NetworkException('Network error');
    }
  }
  
  static Exception _handleHttpError(http.ClientException error) {
    return NetworkException('HTTP client error: ${error.message}');
  }
}

// Usage
Future<User> getUser(int id) async {
  try {
    final response = await http.get(Uri.parse('/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw NetworkException(
        'Failed to load user',
        statusCode: response.statusCode,
      );
    }
  } catch (error) {
    throw ApiErrorHandler.handleError(error);
  }
}
```

---

## Headers and Authentication

### JWT Authentication:

```dart
class AuthService {
  String? _token;
  final Dio _dio;
  
  AuthService(this._dio) {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, try refresh
            try {
              await _refreshToken();
              // Retry the original request
              final response = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(response);
            } catch (e) {
              // Refresh failed, logout
              await logout();
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
  
  Future<void> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    
    _token = response.data['token'];
    // Save token to secure storage
  }
  
  Future<void> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    final response = await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    
    _token = response.data['token'];
    // Save new token
  }
  
  Future<void> logout() async {
    _token = null;
    // Clear stored tokens
    await _dio.post('/auth/logout');
  }
}
```

### API Key Authentication:

```dart
class ApiKeyService {
  static const String apiKey = 'your-api-key-here';
  
  static Map<String, String> getHeaders() {
    return {
      'X-API-Key': apiKey,
      'Content-Type': 'application/json',
    };
  }
  
  static Options getDioOptions() {
    return Options(headers: getHeaders());
  }
}
```

---

## File Upload and Download

### File Upload:

```dart
class FileUploadService {
  final Dio _dio;
  
  FileUploadService(this._dio);
  
  Future<String> uploadImage(File imageFile, {String? description}) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: basename(imageFile.path),
        contentType: MediaType('image', 'jpeg'),
      ),
      if (description != null) 'description': description,
    });
    
    final response = await _dio.post('/upload/image', data: formData);
    return response.data['url'];
  }
  
  Future<List<String>> uploadMultipleImages(List<File> images) async {
    final uploadFutures = images.map((image) => uploadImage(image));
    return await Future.wait(uploadFutures);
  }
  
  // Progress tracking
  Future<String> uploadWithProgress(
    File file,
    Function(int, int) onProgress,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    
    final response = await _dio.post(
      '/upload',
      data: formData,
      onSendProgress: onProgress,
    );
    
    return response.data['url'];
  }
}
```

### File Download:

```dart
class FileDownloadService {
  final Dio _dio;
  
  Future<String> downloadFile(String url, String savePath) async {
    final response = await _dio.download(url, savePath);
    return savePath;
  }
  
  Future<String> downloadWithProgress(
    String url,
    String savePath,
    Function(int, int) onProgress,
  ) async {
    final response = await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
    );
    return savePath;
  }
  
  // Get file info before downloading
  Future<FileInfo> getFileInfo(String url) async {
    final response = await _dio.head(url);
    final contentLength = int.parse(
      response.headers['content-length']?.first ?? '0',
    );
    final contentType = response.headers['content-type']?.first;
    
    return FileInfo(
      size: contentLength,
      type: contentType,
    );
  }
}

class FileInfo {
  final int size;
  final String? type;
  
  FileInfo({required this.size, this.type});
}
```

---

## Caching

### HTTP Caching:

```dart
class CacheService {
  static const String cacheKey = 'api_cache';
  
  Future<T?> getCached<T>(
    String key,
    Future<T> Function() fetchFunction,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('$cacheKey:$key');
    
    if (cached != null) {
      final cacheData = jsonDecode(cached);
      final timestamp = cacheData['timestamp'];
      
      // Check if cache is still valid (1 hour)
      if (DateTime.now().millisecondsSinceEpoch - timestamp < 3600000) {
        return cacheData['data'];
      }
    }
    
    // Fetch fresh data
    final data = await fetchFunction();
    
    // Cache the result
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    await prefs.setString('$cacheKey:$key', jsonEncode(cacheData));
    return data;
  }
  
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(cacheKey));
    
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
```

### Dio Caching with dio_http_cache:

```yaml
dependencies:
  dio_http_cache: ^0.3.0
```

```dart
class CachedApiService {
  final Dio _dio;
  
  CachedApiService() : _dio = Dio() {
    _dio.interceptors.add(
      DioCacheManager(
        CacheConfig(
          baseUrl: 'https://api.example.com',
          defaultMaxAge: Duration(hours: 1),
          defaultMaxStale: Duration(days: 7),
        ),
      ).interceptor,
    );
  }
  
  Future<List<User>> getUsers() async {
    final response = await _dio.get(
      '/users',
      options: buildCacheOptions(
        Duration(hours: 1), // Cache for 1 hour
        forceRefresh: false,
      ),
    );
    
    final List<dynamic> data = response.data;
    return data.map((json) => User.fromJson(json)).toList();
  }
  
  // Force refresh cache
  Future<void> refreshUsers() async {
    await _dio.get(
      '/users',
      options: buildCacheOptions(
        Duration(hours: 1),
        forceRefresh: true,
      ),
    );
  }
}
```

---

## WebSocket Communication

### Basic WebSocket:

```yaml
dependencies:
  web_socket_channel: ^2.4.0
```

```dart
class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _controller = StreamController.broadcast();
  
  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    
    _channel!.stream.listen(
      (message) {
        _controller.add(message);
      },
      onError: (error) {
        _controller.addError(error);
      },
      onDone: () {
        _controller.close();
      },
    );
  }
  
  Stream<dynamic> get messages => _controller.stream;
  
  void send(dynamic message) {
    _channel?.sink.add(message);
  }
  
  void disconnect() {
    _channel?.sink.close();
    _controller.close();
  }
}

// Usage
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketService _wsService = WebSocketService();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  
  @override
  void initState() {
    super.initState();
    _wsService.connect('ws://localhost:8080/chat');
    _wsService.messages.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
  }
  
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _wsService.send(_controller.text);
      _controller.clear();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) => Text(_messages[index]),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(controller: _controller),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _wsService.disconnect();
    _controller.dispose();
    super.dispose();
  }
}
```

---

## GraphQL Integration

### GraphQL Client Setup:

```yaml
dependencies:
  graphql_flutter: ^5.1.0
```

```dart
class GraphQLService {
  late GraphQLClient _client;
  
  GraphQLService() {
    final HttpLink httpLink = HttpLink('https://api.example.com/graphql');
    
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer ${await getToken()}',
    );
    
    final Link link = authLink.concat(httpLink);
    
    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }
  
  Future<QueryResult> query(String query, {Map<String, dynamic>? variables}) {
    return _client.query(
      QueryOptions(
        document: gql(query),
        variables: variables ?? {},
      ),
    );
  }
  
  Future<QueryResult> mutate(String mutation, {Map<String, dynamic>? variables}) {
    return _client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variables ?? {},
      ),
    );
  }
}

// Usage
const String getUsersQuery = '''
  query GetUsers(\$limit: Int!) {
    users(limit: \$limit) {
      id
      name
      email
    }
  }
''';

class UserProvider extends ChangeNotifier {
  final GraphQLService _graphQLService;
  List<User> _users = [];
  
  UserProvider(this._graphQLService);
  
  Future<void> loadUsers(int limit) async {
    final result = await _graphQLService.query(
      getUsersQuery,
      variables: {'limit': limit},
    );
    
    if (!result.hasException) {
      final List<dynamic> usersData = result.data?['users'];
      _users = usersData.map((json) => User.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
```

---

## Summary

- **HTTP Library**: Basic HTTP requests with http package
- **REST API Integration**: Model classes, API services, error handling
- **Dio**: Advanced HTTP client with interceptors and transformers
- **JSON Parsing**: Manual parsing and json_serializable
- **Async/Await**: Future handling, parallel requests, timeouts
- **Error Handling**: Comprehensive error management and user feedback
- **Authentication**: JWT, API keys, token refresh
- **File Operations**: Upload/download with progress tracking
- **Caching**: HTTP caching and local storage
- **WebSocket**: Real-time communication
- **GraphQL**: Modern API querying

Networking is critical for app functionality - focus on error handling, caching, and user experience.

## REST API Integration

### Model Definition:

```dart
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

### Service Class:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Fetch all users
  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fetch single user
  Future<User> fetchUser(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create user
  Future<User> createUser(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email}),
      );

      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update user
  Future<User> updateUser(int id, String name, String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

---

## JSON Parsing

### Automatic JSON Serialization with json_serializable:

```yaml
dependencies:
  json_annotation: ^4.0.0
dev_dependencies:
  build_runner: ^2.0.0
  json_serializable: ^6.0.0
```

### Define Model:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

### Generate:

```bash
flutter pub run build_runner build
```

### Handle Complex JSON:

```dart
@JsonSerializable()
class Post {
  final int id;
  
  @JsonKey(name: 'user_id')
  final int userId;
  
  final String title;
  
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  static DateTime _dateTimeFromJson(String? dateTime) {
    return DateTime.parse(dateTime ?? '');
  }

  static String _dateTimeToJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
```

---

## Async/Await with HTTP

### FutureBuilder:

```dart
class UsersList extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: apiService.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        } else {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
              );
            },
          );
        }
      },
    );
  }
}
```

### StreamBuilder (Polling):

```dart
Stream<List<User>> getUsersStream() async* {
  while (true) {
    yield await apiService.fetchUsers();
    await Future.delayed(Duration(seconds: 5));
  }
}

StreamBuilder<List<User>>(
  stream: getUsersStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(snapshot.data![index].name));
        },
      );
    }
    return Center(child: CircularProgressIndicator());
  },
)
```

---

## Error Handling

### Try-Catch:

```dart
try {
  final users = await apiService.fetchUsers();
  print('Success: $users');
} on TimeoutException {
  print('Request timeout');
} on SocketException {
  print('Network error');
} on HttpException {
  print('HTTP error');
} catch (e) {
  print('Unknown error: $e');
}
```

### Custom Exception Handling:

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

Future<List<User>> fetchUsers() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => User.fromJson(data)).toList();
    } else {
      throw ApiException(
        message: 'Failed to fetch users',
        statusCode: response.statusCode,
      );
    }
  } catch (e) {
    if (e is ApiException) rethrow;
    throw ApiException(message: e.toString());
  }
}

// Usage
try {
  await fetchUsers();
} on ApiException catch (e) {
  print('API Error: ${e.message} - ${e.statusCode}');
}
```

---

## Headers and Authentication

### Common Headers:

```dart
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer YOUR_TOKEN',
  'Accept': 'application/json',
};

final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: headers,
);
```

### Bearer Token:

```dart
class ApiService {
  String? token;

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        token = json.decode(response.body)['token'];
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }
}
```

---

## File Upload

### Multipart Upload:

```dart
Future<void> uploadImage(File imageFile) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.fields['description'] = 'My image';

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    }
  } catch (e) {
    print('Upload failed: $e');
  }
}
```

---

## Dio Package (Alternative)

A powerful HTTP client with interceptors and more.

### Installation:

```yaml
dependencies:
  dio: ^5.0.0
```

### Basic Usage:

```dart
import 'package:dio/dio.dart';

class DioService {
  late Dio _dio;

  DioService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ));

    // Add interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get('/users');
      return (response.data as List)
          .map((data) => User.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<User> createUser(User user) async {
    try {
      final response = await _dio.post(
        '/users',
        data: user.toJson(),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
```

---

## Caching API Responses

```dart
class CachedApiService {
  Map<String, dynamic> _cache = {};
  Map<String, DateTime> _cacheTime = {};

  Future<List<User>> fetchUsers({int cacheMinutes = 5}) async {
    final cacheKey = 'users';

    // Check cache
    if (_cache.containsKey(cacheKey)) {
      final lastTime = _cacheTime[cacheKey]!;
      final elapsedTime = DateTime.now().difference(lastTime).inMinutes;

      if (elapsedTime < cacheMinutes) {
        print('Returning cached data');
        return _cache[cacheKey];
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final users =
            jsonData.map((data) => User.fromJson(data)).toList();

        // Cache the response
        _cache[cacheKey] = users;
        _cacheTime[cacheKey] = DateTime.now();

        return users;
      } else {
        throw Exception('Failed to fetch');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void clearCache() {
    _cache.clear();
    _cacheTime.clear();
  }
}
```

---

## Summary

- **http package**: Basic HTTP requests
- **Model classes**: Define data structure
- **FutureBuilder**: Display async data
- **Error handling**: Handle API errors gracefully
- **Authentication**: Use tokens and headers
- **JSON parsing**: Convert JSON to/from objects
- **File upload**: Upload files to server
- **Dio**: Advanced HTTP client with interceptors
- **Caching**: Improve performance
