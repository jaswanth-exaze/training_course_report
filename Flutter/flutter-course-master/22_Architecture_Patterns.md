# Flutter Architecture Patterns

Structuring large Flutter applications for maintainability and scalability.

---

## MVC (Model-View-Controller)

Not common in Flutter, but basic understanding is useful.

### Structure:

```
Model: Data and business logic
View: UI display
Controller: Handles input and updates
```

### Example:

```dart
// Model
class User {
  String name;
  String email;
  
  User({required this.name, required this.email});
}

// View
class UserView extends StatelessWidget {
  final User user;
  final Function onUpdate;
  
  const UserView({super.key, required this.user, required this.onUpdate});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(user.name),
        Text(user.email),
        ElevatedButton(
          onPressed: () => onUpdate(),
          child: const Text('Update'),
        ),
      ],
    );
  }
}

// Controller
class UserController {
  final User _user = User(name: 'John', email: 'john@example.com');
  
  User get user => _user;
  
  void updateUser(String name, String email) {
    _user.name = name;
    _user.email = email;
  }
}

// Usage
class MVCExample extends StatefulWidget {
  @override
  State<MVCExample> createState() => _MVCExampleState();
}

class _MVCExampleState extends State<MVCExample> {
  final UserController _controller = UserController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVC Example')),
      body: UserView(
        user: _controller.user,
        onUpdate: () {
          setState(() {
            _controller.updateUser('Jane', 'jane@example.com');
          });
        },
      ),
    );
  }
}
```

**Limitations:** Not ideal for Flutter due to tight coupling and state management issues.

---

## MVVM (Model-View-ViewModel)

Better separation of concerns with data binding.

### Structure:

```
Model: Data and business logic
ViewModel: Presentation logic and state management
View: UI display with data binding
```

### Example:

```dart
// Model
class User {
  final String id;
  final String name;
  final String email;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  User copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

// ViewModel
class UserViewModel extends ChangeNotifier {
  final ApiService _apiService;
  
  UserViewModel(this._apiService);
  
  User? _user;
  User? get user => _user;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  Future<void> fetchUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _apiService.getUser(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _apiService.updateUser(updatedUser);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// View
class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(context.read<ApiService>()),
      child: const UserProfileContent(),
    );
  }
}

class UserProfileContent extends StatefulWidget {
  const UserProfileContent({super.key});

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  @override
  void initState() {
    super.initState();
    context.read<UserViewModel>().fetchUser('123');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (viewModel.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${viewModel.error}'),
                ElevatedButton(
                  onPressed: () => viewModel.fetchUser('123'),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        final user = viewModel.user;
        if (user == null) {
          return const Center(child: Text('No user found'));
        }
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${user.name}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Email: ${user.email}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final updatedUser = user.copyWith(name: 'Updated Name');
                  viewModel.updateUser(updatedUser);
                },
                child: const Text('Update Name'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Advanced MVVM with Commands:

```dart
class Command<T> {
  final Future<void> Function(T? parameter) _execute;
  final bool Function(T? parameter)? _canExecute;
  
  Command(this._execute, {bool Function(T? parameter)? canExecute})
      : _canExecute = canExecute;
  
  Future<void> execute([T? parameter]) async {
    if (canExecute(parameter)) {
      await _execute(parameter);
    }
  }
  
  bool canExecute([T? parameter]) {
    return _canExecute?.call(parameter) ?? true;
  }
}

class UserViewModel extends ChangeNotifier {
  final ApiService _apiService;
  
  UserViewModel(this._apiService) {
    _initializeCommands();
  }
  
  void _initializeCommands() {
    fetchUserCommand = Command<String>(
      _fetchUser,
      canExecute: (id) => id != null && id.isNotEmpty,
    );
    
    updateUserCommand = Command<User>(
      _updateUser,
      canExecute: (user) => user != null && !_isLoading,
    );
  }
  
  late final Command<String> fetchUserCommand;
  late final Command<User> updateUserCommand;
  
  User? _user;
  User? get user => _user;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  Future<void> _fetchUser(String? id) async {
    if (id == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _apiService.getUser(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _updateUser(User? updatedUser) async {
    if (updatedUser == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _apiService.updateUser(updatedUser);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## Clean Architecture

Layered architecture for testability and maintainability.

### Structure:

```
Presentation Layer (UI)
├── Domain Layer (Business Logic)
│   ├── Entities
│   ├── Use Cases
│   └── Repository Interfaces
└── Data Layer (Data Access)
    ├── Repository Implementations
    ├── Data Sources
    └── Models
```

### Domain Layer:

```dart
// entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  
  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// repositories/user_repository.dart
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<List<User>> getUsers();
  Future<User> createUser(String name, String email);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
}

// use_cases/get_user.dart
class GetUser {
  final UserRepository _repository;
  
  GetUser(this._repository);
  
  Future<User?> call(String id) async {
    return await _repository.getUser(id);
  }
}

// use_cases/create_user.dart
class CreateUser {
  final UserRepository _repository;
  
  CreateUser(this._repository);
  
  Future<User> call(String name, String email) async {
    return await _repository.createUser(name, email);
  }
}
```

### Data Layer:

```dart
// models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String createdAt;
  
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
    };
  }
  
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: DateTime.parse(createdAt),
    );
  }
  
  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt.toIso8601String(),
    );
  }
}

// data_sources/user_remote_data_source.dart
abstract class UserRemoteDataSource {
  Future<UserModel?> getUser(String id);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

// data_sources/user_local_data_source.dart
abstract class UserLocalDataSource {
  Future<UserModel?> getUser(String id);
  Future<List<UserModel>> getUsers();
  Future<void> cacheUser(UserModel user);
  Future<void> cacheUsers(List<UserModel> users);
  Future<void> clearCache();
}

// repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  UserRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );
  
  @override
  Future<User?> getUser(String id) async {
    try {
      final remoteUser = await _remoteDataSource.getUser(id);
      if (remoteUser != null) {
        await _localDataSource.cacheUser(remoteUser);
        return remoteUser.toEntity();
      }
      
      final localUser = await _localDataSource.getUser(id);
      return localUser?.toEntity();
    } catch (e) {
      final localUser = await _localDataSource.getUser(id);
      return localUser?.toEntity();
    }
  }
  
  @override
  Future<List<User>> getUsers() async {
    try {
      if (await _networkInfo.isConnected) {
        final remoteUsers = await _remoteDataSource.getUsers();
        await _localDataSource.cacheUsers(remoteUsers);
        return remoteUsers.map((user) => user.toEntity()).toList();
      } else {
        final localUsers = await _localDataSource.getUsers();
        return localUsers.map((user) => user.toEntity()).toList();
      }
    } catch (e) {
      final localUsers = await _localDataSource.getUsers();
      return localUsers.map((user) => user.toEntity()).toList();
    }
  }
  
  @override
  Future<User> createUser(String name, String email) async {
    final userModel = UserModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    final createdUser = await _remoteDataSource.createUser(userModel);
    await _localDataSource.cacheUser(createdUser);
    
    return createdUser.toEntity();
  }
  
  @override
  Future<User> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final updatedUser = await _remoteDataSource.updateUser(userModel);
    await _localDataSource.cacheUser(updatedUser);
    
    return updatedUser.toEntity();
  }
  
  @override
  Future<void> deleteUser(String id) async {
    await _remoteDataSource.deleteUser(id);
    // Note: Local cache might be kept for offline scenarios
  }
}
```

### Presentation Layer:

```dart
// presentation/bloc/user_bloc.dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser _getUser;
  final CreateUser _createUser;
  final UpdateUser _updateUser;
  final DeleteUser _deleteUser;
  
  UserBloc(
    this._getUser,
    this._createUser,
    this._updateUser,
    this._deleteUser,
  ) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<CreateNewUser>(_onCreateUser);
    on<UpdateExistingUser>(_onUpdateUser);
    on<DeleteExistingUser>(_onDeleteUser);
  }
  
  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await _getUser(event.userId);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserNotFound());
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  
  Future<void> _onCreateUser(CreateNewUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await _createUser(event.name, event.email);
      emit(UserCreated(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  
  Future<void> _onUpdateUser(UpdateExistingUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await _updateUser(event.user);
      emit(UserUpdated(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
  
  Future<void> _onDeleteUser(DeleteExistingUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _deleteUser(event.userId);
      emit(UserDeleted());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

// presentation/events/user_event.dart
abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

class CreateNewUser extends UserEvent {
  final String name;
  final String email;
  CreateNewUser(this.name, this.email);
}

class UpdateExistingUser extends UserEvent {
  final User user;
  UpdateExistingUser(this.user);
}

class DeleteExistingUser extends UserEvent {
  final String userId;
  DeleteExistingUser(this.userId);
}

// presentation/states/user_state.dart
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UserCreated extends UserState {
  final User user;
  UserCreated(this.user);
}

class UserUpdated extends UserState {
  final User user;
  UserUpdated(this.user);
}

class UserDeleted extends UserState {}

class UserNotFound extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// presentation/pages/user_page.dart
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>(),
      child: const UserView(),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<UserBloc>().add(LoadUser('123')),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is UserLoaded) {
            return UserProfile(user: state.user);
          }
          
          return const Center(
            child: ElevatedButton(
              onPressed: () => context.read<UserBloc>().add(LoadUser('123')),
              child: Text('Load User'),
            ),
          );
        },
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  final User user;
  
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${user.name}', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Email: ${user.email}'),
          const SizedBox(height: 8),
          Text('Created: ${user.createdAt}'),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final updatedUser = user.copyWith(name: 'Updated Name');
                  context.read<UserBloc>().add(UpdateExistingUser(updatedUser));
                },
                child: const Text('Update'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  context.read<UserBloc>().add(DeleteExistingUser(user.id));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Dependency Injection

Managing dependencies and inversion of control.

### Service Locator Pattern:

```dart
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();
  
  final Map<Type, dynamic> _services = {};
  
  void register<T>(T service) {
    _services[T] = service;
  }
  
  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }
  
  void registerSingleton<T>(T service) {
    _services[T] = service;
  }
  
  T get<T>() {
    final service = _services[T];
    if (service is Function) {
      return service();
    }
    return service;
  }
  
  void unregister<T>() {
    _services.remove(T);
  }
  
  void reset() {
    _services.clear();
  }
}

// Usage
void setupDependencies() {
  final locator = ServiceLocator();
  
  // Register services
  locator.register<ApiService>(ApiService());
  locator.register<UserRepository>(UserRepositoryImpl(
    locator.get<ApiService>(),
  ));
  locator.register<UserBloc>(UserBloc(
    locator.get<UserRepository>(),
  ));
}

// Access services
final userBloc = ServiceLocator().get<UserBloc>();
```

### GetIt (Popular DI Library):

```yaml
dependencies:
  get_it: ^7.6.0
```

```dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Register services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerFactory<UserBloc>(
    () => UserBloc(getIt<UserRepository>()),
  );
  
  // Register use cases
  getIt.registerFactory<GetUser>(() => GetUser(getIt<UserRepository>()));
  getIt.registerFactory<CreateUser>(() => CreateUser(getIt<UserRepository>()));
  
  // Register blocs with dependencies
  getIt.registerFactory<UserBloc>(() => UserBloc(
    getIt<GetUser>(),
    getIt<CreateUser>(),
    getIt<UpdateUser>(),
    getIt<DeleteUser>(),
  ));
}

// Usage in widgets
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>(),
      child: const UserView(),
    );
  }
}
```

### Provider with DI:

```dart
class AppDependencies extends StatelessWidget {
  final Widget child;
  
  const AppDependencies({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (context) => ApiService(),
        ),
        ProxyProvider<ApiService, UserRepository>(
          update: (context, apiService, previous) =>
              UserRepositoryImpl(apiService),
        ),
        ProxyProvider<UserRepository, UserBloc>(
          update: (context, repository, previous) =>
              UserBloc(repository),
        ),
      ],
      child: child;
  }
}

// Usage
void main() {
  runApp(
    AppDependencies(
      child: const MyApp(),
    ),
  );
}
```

---

## Scalable App Architecture

Organizing large applications for growth.

### Feature-Based Structure:

```
lib/
├── core/
│   ├── network/
│   ├── storage/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── models/
│   ├── services/
│   └── widgets/
└── main.dart
```

### Core Module:

```dart
// core/network/api_client.dart
class ApiClient {
  final Dio _dio;
  
  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )) {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle token refresh
            await _refreshToken();
            // Retry request
            final response = await _retry(error.requestOptions);
            handler.resolve(response);
          } else {
            handler.next(error);
          }
        },
      ),
    ]);
  }
  
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> _refreshToken() async {
    // Implement token refresh logic
  }
  
  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
  
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
  
  Future<Response<T>> put<T>(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }
  
  Future<Response<T>> delete<T>(String path) {
    return _dio.delete(path);
  }
}

// core/storage/database_helper.dart
class DatabaseHelper {
  static const String _databaseName = 'app_database.db';
  static const int _databaseVersion = 1;
  
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades
    if (oldVersion < 2) {
      // Add migration logic
    }
  }
  
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }
  
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }
  
  Future<int> update(String table, Map<String, dynamic> row, String where, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }
  
  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
```

### Feature Module Example:

```dart
// features/authentication/data/datasources/auth_remote_data_source.dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

// features/authentication/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );
  
  @override
  Future<User> login(String email, String password) async {
    final userModel = await _remoteDataSource.login(email, password);
    await _localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }
  
  @override
  Future<User> register(String name, String email, String password) async {
    final userModel = await _remoteDataSource.register(name, email, password);
    await _localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }
  
  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearUser();
  }
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      await _localDataSource.cacheUser(userModel);
      return userModel.toEntity();
    } catch (e) {
      final userModel = await _localDataSource.getUser();
      return userModel?.toEntity();
    }
  }
}

// features/authentication/domain/usecases/login.dart
class Login {
  final AuthRepository _repository;
  
  Login(this._repository);
  
  Future<User> call(String email, String password) async {
    return await _repository.login(email, password);
  }
}

// features/authentication/presentation/bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;
  
  AuthBloc(
    this._login,
    this._register,
    this._logout,
    this._getCurrentUser,
  ) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AppStarted>(_onAppStarted);
  }
  
  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _login(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _register(event.name, event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}

// features/authentication/presentation/pages/login_page.dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      
                      context.read<AuthBloc>().add(
                        LoginRequested(email, password),
                      );
                    },
                    child: const Text('Login'),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Create Account'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Router and Navigation:

```dart
// core/router/app_router.dart
class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }
  
  static void navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }
  
  static void navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependencies
  setupDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Architecture Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.login,
      ),
    );
  }
}
```

---

## Summary

- **MVC**: Basic separation but not ideal for Flutter
- **MVVM**: Better with ViewModels and data binding
- **Clean Architecture**: Layered approach with clear separation of concerns
- **Dependency Injection**: Service locator and GetIt for managing dependencies
- **Scalable Architecture**: Feature-based structure with core modules

Choose architecture based on team size, project complexity, and maintenance needs.
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateUser(String name) async {
    if (_user == null) return;
    
    try {
      await _apiService.updateUser(_user!.id, name);
      _user = User(id: _user!.id, name: name, email: _user!.email);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

// View
class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: UserViewContent(),
    );
  }
}

class UserViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserViewModel>();
    
    if (viewModel.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (viewModel.error != null) {
      return Text('Error: ${viewModel.error}');
    }
    
    final user = viewModel.user;
    return user == null
        ? Text('No user')
        : Column(
            children: [
              Text(user.name),
              ElevatedButton(
                onPressed: () => viewModel.updateUser('New Name'),
                child: Text('Update'),
              ),
            ],
          );
  }
}
```

**Advantages:**
- Clear separation
- Testable
- Reusable ViewModels
- Good for Provider pattern

---

## Clean Architecture

Most comprehensive, suitable for large projects.

### Structure:

```
presentation/
  ├── pages/
  ├── widgets/
  └── viewmodels/

domain/
  ├── entities/
  ├── repositories/
  └── usecases/

data/
  ├── datasources/
  ├── models/
  └── repositories/
```

### Example:

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
}

// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> updateUser(User user);
}

// domain/usecases/get_user.dart
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  Future<User> call(String id) async {
    return await repository.getUser(id);
  }
}

// data/models/user_model.dart
class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// data/datasources/user_remote_datasource.dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;
  
  UserRemoteDataSourceImpl(this.apiClient);
  
  @override
  Future<UserModel> getUser(String id) async {
    final response = await apiClient.get('/users/$id');
    return UserModel.fromJson(response);
  }
}

// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  
  UserRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<User> getUser(String id) async {
    return await remoteDataSource.getUser(id);
  }
  
  @override
  Future<void> updateUser(User user) async {
    // Implementation
  }
}

// presentation/viewmodels/user_viewmodel.dart
class UserViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  
  User? _user;
  User? get user => _user;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  UserViewModel(this.getUserUseCase);
  
  Future<void> fetchUser(String id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await getUserUseCase(id);
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// presentation/pages/user_page.dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(GetUserUseCase(userRepository)),
      child: UserPageContent(),
    );
  }
}

class UserPageContent extends StatefulWidget {
  @override
  State<UserPageContent> createState() => _UserPageContentState();
}

class _UserPageContentState extends State<UserPageContent> {
  @override
  void initState() {
    super.initState();
    context.read<UserViewModel>().fetchUser('123');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return Center(
            child: Text(viewModel.user?.name ?? 'No user'),
          );
        },
      ),
    );
  }
}
```

**Advantages:**
- Highly testable
- Clear dependencies
- Scalable for large projects
- Team-friendly

---

## Dependency Injection

Using GetIt or Riverpod for dependency management.

### GetIt:

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register repositories
  getIt.registerSingleton<UserRepository>(UserRepositoryImpl());
  
  // Register use cases
  getIt.registerSingleton<GetUserUseCase>(
    GetUserUseCase(getIt<UserRepository>()),
  );
  
  // Register view models
  getIt.registerFactory<UserViewModel>(
    () => UserViewModel(getIt<GetUserUseCase>()),
  );
}

// Usage
void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class UserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<UserViewModel>();
    return UserContent(viewModel: viewModel);
  }
}
```

---

## Project Structure Best Practices

### Organize by Feature:

```
lib/
├── src/
│   ├── config/
│   │   └── theme.dart
│   ├── core/
│   │   ├── errors/
│   │   ├── usecases/
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── user/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── settings/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── main.dart
└── test/
```

### Benefits:
- Features are self-contained
- Easy to remove features
- Clear dependencies
- Scaling is easier

---

## State Management Patterns

### By App Size:

| App Size | Pattern | Why |
|----------|---------|-----|
| Tiny | setState | Simple, no overhead |
| Small | Provider | Easy to implement |
| Medium | BLoC | Better control |
| Large | Clean Arch + BLoC | Highly scalable |

---

## API Design Patterns

### Repository Pattern:

```dart
abstract class BaseRepository<T> {
  Future<T> getById(String id);
  Future<List<T>> getAll();
  Future<void> create(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}
```

---

## Error Handling

### Custom Exceptions:

```dart
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}
```

---

## Best Practices

1. **Separation of concerns**: Each layer has single responsibility
2. **Dependency injection**: Easy testing and flexibility
3. **Use interfaces**: Domain layer doesn't know about implementation
4. **Constants**: Extract magic strings/numbers
5. **Error handling**: Proper exception types
6. **Testing**: Each layer is testable
7. **Documentation**: Clear architecture notes
8. **Consistency**: Follow patterns across project

---

## Summary

- **MVC**: Basic pattern (not ideal for Flutter)
- **MVVM**: Better separation (with Provider)
- **Clean Architecture**: Most comprehensive (for large apps)
- **Dependency Injection**: Manage dependencies
- **Feature-based**: Organize by features
- Choose pattern based on app complexity
- Prioritize testability and maintainability
