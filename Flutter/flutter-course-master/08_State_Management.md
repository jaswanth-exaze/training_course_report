# Flutter State Management (CRITICAL)

State management is crucial for building scalable Flutter applications. This section covers from basic to advanced approaches.

---

## setState() - Basic State Management

The simplest state management approach for StatefulWidget.

### How It Works:

```dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  void increment() {
    setState(() {
      count++;  // Update state
    });
    // setState triggers rebuild with new state
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Count: $count"),
        ElevatedButton(onPressed: increment, child: Text("+")),
      ],
    );
  }
}
```

### setState() Rules:

1. **Only in StatefulWidget**: Cannot use in StatelessWidget
2. **Triggers rebuild**: Rebuilds the widget tree
3. **Synchronous**: Completes before next frame
4. **Scope limited**: Only affects this widget

### When setState is Called:

```dart
void increment() {
  // Before setState
  print("Before: $count");  // 0
  
  setState(() {
    count++;
    print("Inside: $count");  // 1
  });
  
  print("After: $count");  // 1 (synchronous)
}
```

### Common Pattern - Text Field:

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  String email = "";

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
        ),
        Text("Email: $email"),
      ],
    );
  }
}
```

### setState Limitations:

```dart
// ❌ Bad: Complex state logic
class ComplexWidget extends StatefulWidget {
  @override
  _ComplexWidgetState createState() => _ComplexWidgetState();
}

class _ComplexWidgetState extends State<ComplexWidget> {
  List<User> users = [];
  bool isLoading = false;
  String error = "";
  
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  
  Future<void> _loadUsers() async {
    setState(() => isLoading = true);
    try {
      final loadedUsers = await ApiService.getUsers();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  
  // Widget becomes complex with multiple responsibilities
}
```

---

## InheritedWidget - Flutter's Built-in Solution

A base class for widgets that efficiently propagate information down the tree.

### Basic InheritedWidget:

```dart
class AppConfig extends InheritedWidget {
  final String appName;
  final ThemeData theme;
  
  const AppConfig({
    super.key,
    required this.appName,
    required this.theme,
    required super.child,
  });
  
  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }
  
  @override
  bool updateShouldNotify(AppConfig oldWidget) {
    return appName != oldWidget.appName || theme != oldWidget.theme;
  }
}

// Usage
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppConfig(
      appName: 'My App',
      theme: ThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                final config = AppConfig.of(context);
                return Text('Welcome to ${config.appName}');
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

### Counter with InheritedWidget:

```dart
class CounterProvider extends InheritedWidget {
  final CounterModel model;
  
  CounterProvider({super.key, required this.model, required super.child});
  
  static CounterProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>()!;
  }
  
  @override
  bool updateShouldNotify(CounterProvider oldWidget) {
    return model != oldWidget.model;
  }
}

class CounterModel extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    
    return Column(
      children: [
        Text('Count: ${provider.model.count}'),
        ElevatedButton(
          onPressed: provider.model.increment,
          child: Text('+'),
        ),
      ],
    );
  }
}
```

---

## Provider - Recommended by Flutter Team

A wrapper around InheritedWidget that makes state management simpler.

### Basic Provider Setup:

```dart
// pubspec.yaml
dependencies:
  provider: ^6.0.5

// main.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: MyApp(),
    ),
  );
}

class CounterModel extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}
```

### Consumer Widget:

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Text('Count: ${counter.count}');
      },
    );
  }
}

class CounterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Method 1: Using context.read()
        context.read<CounterModel>().increment();
      },
      child: Text('+'),
    );
  }
}
```

### Selector for Performance:

```dart
class OptimizedCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CounterModel, int>(
      selector: (context, model) => model.count,
      builder: (context, count, child) {
        return Text('Count: $count');
      },
    );
  }
}
```

### Complex Provider Example:

```dart
class UserModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await AuthService.login(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void logout() {
    _user = null;
    notifyListeners();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          if (userModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return LoginForm();
        },
      ),
    );
  }
}
```

### Provider Types:

```dart
// ChangeNotifierProvider - For ChangeNotifier classes
ChangeNotifierProvider(create: (_) => CounterModel())

// Provider - For any object
Provider(create: (_) => ApiService())

// FutureProvider - For async operations
FutureProvider<User>(
  create: (_) => AuthService.getCurrentUser(),
  child: MyApp(),
)

// StreamProvider - For streams
StreamProvider<ConnectivityResult>(
  create: (_) => Connectivity().onConnectivityChanged,
  child: MyApp(),
)
```

---

## BLoC (Business Logic Component) Pattern

A predictable state management pattern that separates business logic from UI.

### Basic BLoC Structure:

```dart
// pubspec.yaml
dependencies:
  flutter_bloc: ^8.1.3

// bloc/counter_event.dart
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

// bloc/counter_state.dart
class CounterState {
  final int count;
  
  const CounterState(this.count);
  
  CounterState copyWith({int? count}) {
    return CounterState(count ?? this.count);
  }
}

// bloc/counter_bloc.dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementEvent>((event, emit) {
      emit(state.copyWith(count: state.count + 1));
    });
    
    on<DecrementEvent>((event, emit) {
      emit(state.copyWith(count: state.count - 1));
    });
  }
}
```

### BLoC Widget:

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: Scaffold(
        body: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Count: ${state.count}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<CounterBloc>().add(DecrementEvent()),
                      child: Text('-'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CounterBloc>().add(IncrementEvent()),
                      child: Text('+'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

### Complex BLoC Example:

```dart
// Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthInitial());
  }
}
```

### BLoC with Repository Pattern:

```dart
class AuthRepository {
  final AuthApi _authApi;
  final SecureStorage _storage;
  
  AuthRepository(this._authApi, this._storage);
  
  Future<User> login(String email, String password) async {
    final response = await _authApi.login(email, password);
    await _storage.saveToken(response.token);
    return response.user;
  }
  
  Future<void> logout() async {
    await _storage.deleteToken();
  }
  
  Future<User?> getCurrentUser() async {
    final token = await _storage.getToken();
    if (token == null) return null;
    
    return await _authApi.getCurrentUser(token);
  }
}
```

---

## Riverpod - Modern State Management

A compile-safe, provider-based state management solution.

### Basic Riverpod Setup:

```dart
// pubspec.yaml
dependencies:
  flutter_riverpod: ^2.4.9

// main.dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// providers/counter_provider.dart
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  
  void increment() => state++;
  void decrement() => state--;
}
```

### Riverpod Widget:

```dart
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count: $count'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).decrement(),
                  child: Text('-'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).increment(),
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Different Provider Types:

```dart
// StateNotifierProvider - For complex state
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

// StateProvider - For simple state
final nameProvider = StateProvider<String>((ref) => 'John');

// FutureProvider - For async operations
final userProvider = FutureProvider<User>((ref) async {
  return ref.watch(authServiceProvider).getCurrentUser();
});

// StreamProvider - For streams
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return ref.watch(chatServiceProvider).messages;
});

// Provider - For services
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
```

### Dependency Injection:

```dart
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserRepository(authService);
});

final userProvider = FutureProvider<User>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getCurrentUser();
});
```

### Riverpod with ChangeNotifier:

```dart
final counterProvider = ChangeNotifierProvider<CounterModel>((ref) {
  return CounterModel();
});

class CounterModel extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Usage
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('Count: ${counter.count}'),
        ElevatedButton(
          onPressed: counter.increment,
          child: Text('+'),
        ),
      ],
    );
  }
}
```

---

## GetX - Reactive State Management

A lightweight solution with reactive programming.

### Basic GetX Setup:

```dart
// pubspec.yaml
dependencies:
  get: ^4.6.5

// controllers/counter_controller.dart
class CounterController extends GetxController {
  var count = 0.obs;  // Observable
  
  void increment() => count++;
  void decrement() => count--;
}

// main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}
```

### GetX Widget:

```dart
class CounterScreen extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Method 1: Obx
            Obx(() => Text('Count: ${controller.count}')),
            
            // Method 2: GetX
            GetX<CounterController>(
              builder: (controller) => Text('Count: ${controller.count}'),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.decrement,
                  child: Text('-'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: controller.increment,
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### GetX Navigation:

```dart
// Navigate to named route
Get.toNamed('/profile');

// Navigate with arguments
Get.toNamed('/profile', arguments: {'userId': 123});

// Navigate and remove previous
Get.offNamed('/login');

// Navigate and remove all previous
Get.offAllNamed('/home');

// Go back
Get.back();

// Pass data back
Get.back(result: 'Selected Item');
```

### GetX Dependency Injection:

```dart
class ApiService {
  Future<User> getUser(int id) async {
    // API call
  }
}

class UserController extends GetxController {
  final apiService = Get.find<ApiService>();
  var user = Rxn<User>();
  
  void loadUser(int id) async {
    user.value = await apiService.getUser(id);
  }
}

// Register services
void main() {
  Get.put(ApiService());
  Get.put(UserController());
  
  runApp(MyApp());
}
```

---

## MobX - Reactive State Management

Observable-based state management with code generation.

### Basic MobX Setup:

```dart
// pubspec.yaml
dependencies:
  mobx: ^2.2.0
  flutter_mobx: ^2.1.0

dev_dependencies:
  build_runner: ^2.4.6
  mobx_codegen: ^2.6.1

// stores/counter_store.dart
import 'package:mobx/mobx.dart';

part 'counter_store.g.dart';

class CounterStore = CounterStoreBase with _$CounterStore;

abstract class CounterStoreBase with Store {
  @observable
  int count = 0;
  
  @action
  void increment() {
    count++;
  }
  
  @action
  void decrement() {
    count--;
  }
  
  @computed
  bool get isEven => count % 2 == 0;
}

// Generate: flutter pub run build_runner build
```

### MobX Widget:

```dart
class CounterScreen extends StatelessWidget {
  final CounterStore store = CounterStore();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Observer(
              builder: (_) => Text('Count: ${store.count}'),
            ),
            Observer(
              builder: (_) => Text(
                store.isEven ? 'Even' : 'Odd',
                style: TextStyle(
                  color: store.isEven ? Colors.green : Colors.red,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: store.decrement,
                  child: Text('-'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: store.increment,
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## State Management Comparison

### When to Use Each Approach:

| Approach | Complexity | Use Case | Learning Curve |
|----------|------------|----------|----------------|
| setState | Low | Simple UI state | Low |
| InheritedWidget | Medium | App-wide config | Medium |
| Provider | Low-Medium | Most apps | Low |
| BLoC | High | Complex business logic | High |
| Riverpod | Medium | Modern apps | Medium |
| GetX | Low | Simple reactive apps | Low |
| MobX | Medium | Reactive programming | Medium |

### Migration Strategies:

```dart
// From setState to Provider
class OldWidget extends StatefulWidget {
  @override
  _OldWidgetState createState() => _OldWidgetState();
}

class _OldWidgetState extends State<OldWidget> {
  int count = 0;
  
  void increment() => setState(() => count++);
}

// Migrate to Provider
class CounterModel extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Usage
class NewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterModel>();
    
    return ElevatedButton(
      onPressed: counter.increment,
      child: Text('Count: ${counter.count}'),
    );
  }
}
```

---

## Architecture Patterns

### MVC (Model-View-Controller):

```dart
// Model
class User {
  final String name;
  final String email;
  
  User({required this.name, required this.email});
}

// View
class UserView extends StatelessWidget {
  final UserController controller;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(controller.user.name),
        Text(controller.user.email),
      ],
    );
  }
}

// Controller
class UserController extends ChangeNotifier {
  User _user = User(name: 'John', email: 'john@example.com');
  
  User get user => _user;
  
  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
```

### MVVM (Model-View-ViewModel):

```dart
// Model
class User {
  final String name;
  final String email;
  
  User({required this.name, required this.email});
}

// ViewModel
class UserViewModel extends ChangeNotifier {
  final UserRepository _repository;
  
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  UserViewModel(this._repository);
  
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    
    _user = await _repository.getUser();
    
    _isLoading = false;
    notifyListeners();
  }
}

// View
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserViewModel>();
    
    if (viewModel.isLoading) {
      return CircularProgressIndicator();
    }
    
    return Column(
      children: [
        Text(viewModel.user?.name ?? ''),
        Text(viewModel.user?.email ?? ''),
      ],
    );
  }
}
```

---

## Testing State Management

### Testing Provider:

```dart
void main() {
  test('CounterModel increments', () {
    final model = CounterModel();
    
    expect(model.count, 0);
    
    model.increment();
    
    expect(model.count, 1);
  });
  
  testWidgets('CounterWidget displays count', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CounterModel(),
        child: MaterialApp(home: CounterWidget()),
      ),
    );
    
    expect(find.text('Count: 0'), findsOneWidget);
    
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    
    expect(find.text('Count: 1'), findsOneWidget);
  });
}
```

### Testing BLoC:

```dart
void main() {
  group('CounterBloc', () {
    late CounterBloc bloc;
    
    setUp(() {
      bloc = CounterBloc();
    });
    
    tearDown(() {
      bloc.close();
    });
    
    test('initial state is 0', () {
      expect(bloc.state.count, 0);
    });
    
    blocTest<CounterBloc, CounterState>(
      'emits [1] when increment is added',
      build: () => bloc,
      act: (bloc) => bloc.add(IncrementEvent()),
      expect: () => [const CounterState(1)],
    );
  });
}
```

---

## Performance Best Practices

### Avoid Unnecessary Rebuilds:

```dart
// ✅ Good: Use const constructors
class StaticWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static Text'),
        Icon(Icons.star),
      ],
    );
  }
}

// ✅ Good: Extract static parts
class OptimizedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterModel>();
    
    return Column(
      children: [
        const Text('Count:'),  // Static
        Text('${counter.count}'),  // Dynamic
      ],
    );
  }
}
```

### Use Selectors for Performance:

```dart
// Provider
Selector<CounterModel, int>(
  selector: (context, model) => model.count,
  builder: (context, count, child) {
    return Text('Count: $count');
  },
)

// Riverpod
final countProvider = Provider<int>((ref) {
  return ref.watch(counterProvider.select((counter) => counter.count));
});
```

### Dispose Resources:

```dart
class MyController extends ChangeNotifier {
  Timer? _timer;
  
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
```

---

## Summary

- **setState**: Simple, local state in StatefulWidget
- **InheritedWidget**: Flutter's built-in dependency injection
- **Provider**: Recommended, simple and powerful
- **BLoC**: Complex apps with clear separation of concerns
- **Riverpod**: Modern, compile-safe alternative to Provider
- **GetX**: Lightweight reactive solution
- **MobX**: Observable-based reactive programming
- **Architecture**: MVC, MVVM patterns for complex apps
- **Testing**: Unit and widget tests for state management
- **Performance**: Avoid unnecessary rebuilds, use selectors

Choose based on app complexity, team preferences, and scalability needs.

### Limitations of setState:

- Rebuilds entire widget
- Not efficient for large apps
- Difficult to share state across widgets
- No time-travel debugging
- Hard to test

---

## InheritedWidget (Concept)

A way to pass data down the widget tree efficiently.

### Understanding InheritedWidget:

```dart
class MyInheritedWidget extends InheritedWidget {
  final String data;

  MyInheritedWidget({
    required this.data,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return oldWidget.data != data;
  }

  static MyInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!;
  }
}
```

### Using InheritedWidget:

```dart
// Provide data
MyInheritedWidget(
  data: "Hello",
  child: MyApp(),
)

// Access data
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inheritedData = MyInheritedWidget.of(context);
    return Text(inheritedData.data);  // "Hello"
  }
}
```

### How It Works:

```
MyInheritedWidget
├── Widget 1 (can access data)
├── Widget 2 (can access data)
│  └── Widget 3 (can access data)
└── Widget 4 (can access data)
```

### Real Example - Theme:

```dart
class ThemeProvider extends InheritedWidget {
  final bool isDarkMode;

  ThemeProvider({
    required this.isDarkMode,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return oldWidget.isDarkMode != isDarkMode;
  }

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }
}

// Usage
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      isDarkMode: _isDarkMode,
      child: Scaffold(
        body: MyWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
            });
          },
          child: Text("Toggle"),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    return Container(
      color: theme.isDarkMode ? Colors.black : Colors.white,
    );
  }
}
```

---

## Provider (Popular Solution)

Provider is a state management solution that combines InheritedWidget with StatefulWidget.

### Installation:

```yaml
# pubspec.yaml
dependencies:
  provider: ^6.0.0
```

### Basic ChangeNotifier:

```dart
class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();  // Notify all listeners
  }
}
```

### Provide Data:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}
```

### Consume Data:

```dart
// Read (don't rebuild on changes)
final count = Provider.of<CounterProvider>(context, listen: false).count;

// Watch (rebuild on changes)
final provider = Provider.of<CounterProvider>(context);
Text("Count: ${provider.count}");

// Or using Consumer
Consumer<CounterProvider>(
  builder: (context, provider, child) {
    return Text("Count: ${provider.count}");
  },
)

// Or using context.watch() (recommended)
final provider = context.watch<CounterProvider>();
Text("Count: ${provider.count}");
```

### Complete Provider Example:

```dart
class User extends ChangeNotifier {
  String _name = "";
  bool _isLogged = false;

  String get name => _name;
  bool get isLogged => _isLogged;

  void login(String name) {
    _name = name;
    _isLogged = true;
    notifyListeners();
  }

  void logout() {
    _name = "";
    _isLogged = false;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: const MyApp(),
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Scaffold(
      body: user.isLogged
          ? Center(child: Text("Welcome ${user.name}"))
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  user.login("John");
                },
                child: Text("Login"),
              ),
            ),
    );
  }
}
```

### Multiple Providers:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ],
  child: const MyApp(),
)
```

### ProxyProvider (Dependent Provider):

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => User()),
    ChangeNotifierProxyProvider<User, Cart>(
      create: (context) => Cart(),
      update: (context, user, previousCart) {
        previousCart?.setUser(user);
        return previousCart ?? Cart();
      },
    ),
  ],
  child: const MyApp(),
)
```

---

## BLoC Pattern (Advanced)

BLoC (Business Logic Component) separates business logic from UI.

### Basic BLoC:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

// States
abstract class CounterState {}
class CounterInitial extends CounterState {}
class CounterUpdated extends CounterState {
  final int count;
  CounterUpdated(this.count);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  int count = 0;

  CounterBloc() : super(CounterInitial()) {
    on<IncrementEvent>((event, emit) {
      count++;
      emit(CounterUpdated(count));
    });

    on<DecrementEvent>((event, emit) {
      count--;
      emit(CounterUpdated(count));
    });
  }
}
```

### Using BLoC:

```dart
BlocProvider(
  create: (_) => CounterBloc(),
  child: const MyApp(),
)

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state is CounterUpdated) {
            return Center(child: Text("Count: ${state.count}"));
          }
          return Center(child: Text("Count: 0"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterBloc>().add(IncrementEvent());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## Riverpod (Advanced Alternative)

Riverpod is a modern, compile-time safe state management solution.

### Installation:

```yaml
dependencies:
  riverpod: ^2.0.0
  flutter_riverpod: ^2.0.0
```

### Basic Provider:

```dart
final countProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}
```

### Using Riverpod:

```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider);

    return Scaffold(
      body: Center(child: Text("Count: $count")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countProvider.notifier).increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## State Management Comparison

| Approach | Simplicity | Scalability | Learning Curve |
|----------|-----------|-------------|-----------------|
| setState | ⭐⭐⭐⭐⭐ | ⭐ | Easy |
| InheritedWidget | ⭐⭐⭐ | ⭐⭐ | Medium |
| Provider | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Easy |
| BLoC | ⭐⭐ | ⭐⭐⭐⭐⭐ | Hard |
| Riverpod | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Medium |

---

## Best Practices

1. **Use setState for simple widgets**
2. **Use Provider for medium complexity**
3. **Use BLoC/Riverpod for large apps**
4. **Always call dispose() to free resources**
5. **Avoid creating new providers on every build**
6. **Keep business logic separate from UI**

---

## Summary

- **setState**: Simplest for single widgets
- **InheritedWidget**: Foundation for other solutions
- **Provider**: Best for most applications
- **BLoC**: Best for large, complex apps
- **Riverpod**: Modern, type-safe alternative
- Choose based on app complexity
- Test state management thoroughly
