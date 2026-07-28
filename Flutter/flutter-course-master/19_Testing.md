# Flutter Testing

Ensuring code quality and reliability through testing.

---

## Unit Testing

Testing Dart logic without UI.

### Setup:

```yaml
dev_dependencies:
  test: ^1.21.0
  mockito: ^5.4.4
  build_runner: ^2.4.6
```

### Basic Test:

```dart
// lib/calculator.dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
  double divide(int a, int b) => a / b;
}

// test/calculator_test.dart
import 'package:test/test.dart';
import 'package:my_app/calculator.dart';

void main() {
  late Calculator calculator;

  setUp(() {
    calculator = Calculator();
  });

  tearDown(() {
    // Clean up after each test
  });

  group('Calculator', () {
    test('add returns correct sum', () {
      expect(calculator.add(2, 3), equals(5));
    });

    test('subtract returns correct difference', () {
      expect(calculator.subtract(5, 3), equals(2));
    });

    test('multiply returns correct product', () {
      expect(calculator.multiply(3, 4), equals(12));
    });

    test('divide returns correct quotient', () {
      expect(calculator.divide(10, 2), equals(5.0));
    });

    test('divide by zero throws exception', () {
      expect(() => calculator.divide(10, 0), throwsA(isA<UnsupportedError>()));
    });
  });
}
```

### Advanced Unit Testing:

```dart
class UserService {
  final ApiClient _apiClient;
  
  UserService(this._apiClient);
  
  Future<User?> getUser(String id) async {
    try {
      final response = await _apiClient.get('/users/$id');
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }
  
  Future<List<User>> getUsers() async {
    final response = await _apiClient.get('/users');
    return (response as List).map((json) => User.fromJson(json)).toList();
  }
  
  Future<bool> updateUser(User user) async {
    try {
      await _apiClient.put('/users/${user.id}', user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

// test/user_service_test.dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([ApiClient])
import 'user_service_test.mocks.dart';

void main() {
  late UserService userService;
  late MockApiClient mockApiClient;
  
  setUp(() {
    mockApiClient = MockApiClient();
    userService = UserService(mockApiClient);
  });
  
  group('UserService', () {
    test('getUser returns user when API call succeeds', () async {
      const userId = '123';
      final userJson = {
        'id': userId,
        'name': 'John Doe',
        'email': 'john@example.com',
      };
      
      when(mockApiClient.get('/users/$userId'))
          .thenAnswer((_) async => userJson);
      
      final result = await userService.getUser(userId);
      
      expect(result, isNotNull);
      expect(result!.id, equals(userId));
      expect(result.name, equals('John Doe'));
      expect(result.email, equals('john@example.com'));
      
      verify(mockApiClient.get('/users/$userId')).called(1);
    });
    
    test('getUser returns null when API call fails', () async {
      when(mockApiClient.get('/users/123'))
          .thenThrow(Exception('API Error'));
      
      final result = await userService.getUser('123');
      
      expect(result, isNull);
    });
    
    test('getUsers returns list of users', () async {
      final usersJson = [
        {'id': '1', 'name': 'User 1', 'email': 'user1@example.com'},
        {'id': '2', 'name': 'User 2', 'email': 'user2@example.com'},
      ];
      
      when(mockApiClient.get('/users'))
          .thenAnswer((_) async => usersJson);
      
      final result = await userService.getUsers();
      
      expect(result.length, equals(2));
      expect(result[0].name, equals('User 1'));
      expect(result[1].name, equals('User 2'));
    });
    
    test('updateUser returns true when update succeeds', () async {
      final user = User(id: '123', name: 'Updated Name', email: 'updated@example.com');
      
      when(mockApiClient.put('/users/123', user.toJson()))
          .thenAnswer((_) async => {});
      
      final result = await userService.updateUser(user);
      
      expect(result, isTrue);
      verify(mockApiClient.put('/users/123', user.toJson())).called(1);
    });
    
    test('updateUser returns false when update fails', () async {
      final user = User(id: '123', name: 'Updated Name', email: 'updated@example.com');
      
      when(mockApiClient.put('/users/123', user.toJson()))
          .thenThrow(Exception('Update failed'));
      
      final result = await userService.updateUser(user);
      
      expect(result, isFalse);
    });
  });
}
```

### Run Tests:

```bash
flutter test
flutter test test/calculator_test.dart  # Specific test
flutter test --verbose                   # With details
flutter test --coverage                 # Generate coverage report
```

### Async Testing:

```dart
test('async operation completes', () async {
  final result = await fetchData();
  expect(result, equals('success'));
});

test('future completes with value', () {
  expectLater(
    Future.value('success'),
    completion(equals('success')),
  );
});

test('stream emits expected values', () {
  final controller = StreamController<String>();
  
  expectLater(
    controller.stream,
    emitsInOrder(['first', 'second', 'third']),
  );
  
  controller.add('first');
  controller.add('second');
  controller.add('third');
  controller.close();
});

test('future times out', () async {
  final future = Future.delayed(Duration(seconds: 2), () => 'done');
  
  expect(
    () => future.timeout(Duration(seconds: 1)),
    throwsA(isA<TimeoutException>()),
  );
});
```

### Mocking with Mockito:

```dart
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  test('fetches user data', () async {
    final mockApi = MockApiService();
    
    when(mockApi.getUser('123'))
        .thenAnswer((_) async => User(id: '123', name: 'John'));

    final user = await mockApi.getUser('123');
    expect(user.name, equals('John'));
    
    verify(mockApi.getUser('123')).called(1);
  });
  
  test('handles network error', () async {
    final mockApi = MockApiService();
    
    when(mockApi.getUser(any))
        .thenThrow(NetworkException('Connection failed'));
    
    expect(
      () => mockApi.getUser('123'),
      throwsA(isA<NetworkException>()),
    );
  });
}
```

---

## Widget Testing

Testing Flutter UI components.

### Setup:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  test: ^1.21.0
```

### Basic Widget Test:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

### Advanced Widget Testing:

```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// test/counter_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CounterWidget displays initial value', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CounterWidget()),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('You have pushed the button this many times:'), findsOneWidget);
  });

  testWidgets('CounterWidget increments when button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CounterWidget()),
    );

    // Initial state
    expect(find.text('0'), findsOneWidget);

    // Tap the floating action button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Rebuild the widget

    // Verify the counter incremented
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('CounterWidget has correct structure', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CounterWidget()),
    );

    // Check for Scaffold
    expect(find.byType(Scaffold), findsOneWidget);

    // Check for AppBar
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Counter'), findsOneWidget);

    // Check for FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('CounterWidget handles multiple taps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CounterWidget()),
    );

    // Tap multiple times
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
  });
}
```

### Testing Forms:

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Submit form
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: _validateEmail,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: _validatePassword,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

// test/login_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginForm validation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoginForm())),
    );

    // Find form fields
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    final loginButton = find.byType(ElevatedButton);

    // Test empty form submission
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Enter invalid email
    await tester.enterText(emailField, 'invalid-email');
    await tester.enterText(passwordField, '123');
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    // Enter valid data
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.tap(loginButton);
    await tester.pump();

    // Should not show validation errors
    expect(find.text('Please enter your email'), findsNothing);
    expect(find.text('Please enter your password'), findsNothing);
  });

  testWidgets('LoginForm has correct structure', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoginForm())),
    );

    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
```

### Testing with Providers:

```dart
class CounterProvider extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterProvider>(
      builder: (context, counter, child) {
        return Text('Count: ${counter.count}');
      },
    );
  }
}

class CounterButton extends StatelessWidget {
  const CounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CounterProvider>().increment();
      },
      child: const Text('Increment'),
    );
  }
}

// test/counter_provider_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('CounterProvider updates UI correctly', (WidgetTester tester) async {
    final counterProvider = CounterProvider();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<CounterProvider>.value(
        value: counterProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CounterDisplay(),
                CounterButton(),
              ],
            ),
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('Count: 0'), findsOneWidget);

    // Tap button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify update
    expect(find.text('Count: 1'), findsOneWidget);
  });

  testWidgets('CounterProvider handles multiple increments', (WidgetTester tester) async {
    final counterProvider = CounterProvider();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<CounterProvider>.value(
        value: counterProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CounterDisplay(),
                CounterButton(),
              ],
            ),
          ),
        ),
      ),
    );

    // Multiple taps
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Count: 3'), findsOneWidget);
  });
}
```

---

## Integration Testing

Testing complete app flows.

### Setup:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

### Basic Integration Test:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete user flow', (WidgetTester tester) async {
    // Launch the app
    await tester.pumpWidget(const MyApp());

    // Navigate to login screen
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Enter credentials
    await tester.enterText(find.byKey(const Key('email_field')), 'user@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password123');

    // Submit login
    await tester.tap(find.byKey(const Key('submit_button')));
    await tester.pumpAndSettle();

    // Verify successful login
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
```

### Advanced Integration Testing:

```dart
class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProductListScreen(),
      routes: {
        '/product-details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView(
        children: [
          ListTile(
            key: const Key('product_1'),
            title: const Text('Product 1'),
            subtitle: const Text('\$10.00'),
            trailing: ElevatedButton(
              key: const Key('add_to_cart_1'),
              onPressed: () {
                // Add to cart logic
              },
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('cart_button'),
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete shopping flow', (WidgetTester tester) async {
      // Launch app
      await tester.pumpWidget(const ShoppingApp());
      await tester.pumpAndSettle();

      // Verify initial screen
      expect(find.text('Products'), findsOneWidget);
      expect(find.byKey(const Key('product_1')), findsOneWidget);

      // Add product to cart
      await tester.tap(find.byKey(const Key('add_to_cart_1')));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byKey(const Key('cart_button')));
      await tester.pumpAndSettle();

      // Verify cart screen
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.byKey(const Key('product_1')), findsOneWidget);
    });

    testWidgets('navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const ShoppingApp());
      await tester.pumpAndSettle();

      // Navigate to product details
      await tester.tap(find.byKey(const Key('product_1')));
      await tester.pumpAndSettle();

      expect(find.text('Product Details'), findsOneWidget);

      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Products'), findsOneWidget);
    });

    testWidgets('handles network errors gracefully', (WidgetTester tester) async {
      // Mock network failure
      // This would require setting up mock HTTP clients

      await tester.pumpWidget(const ShoppingApp());
      await tester.pumpAndSettle();

      // Try to load products
      await tester.tap(find.byKey(const Key('refresh_button')));
      await tester.pumpAndSettle();

      // Verify error handling
      expect(find.text('Failed to load products'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
```

### Testing Platform Channels:

```dart
// integration_test/platform_channel_test.dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('platform channel communication', (WidgetTester tester) async {
    const MethodChannel channel = MethodChannel('com.example.platform');

    // Mock platform method
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getBatteryLevel':
          return 85;
        case 'getDeviceInfo':
          return {'model': 'Test Device', 'version': '1.0'};
        default:
          throw PlatformException(code: 'unknown_method');
      }
    });

    await tester.pumpWidget(const MaterialApp(home: PlatformTestWidget()));

    // Test battery level
    await tester.tap(find.byKey(const Key('battery_button')));
    await tester.pumpAndSettle();

    expect(find.text('Battery: 85%'), findsOneWidget);

    // Test device info
    await tester.tap(find.byKey(const Key('device_button')));
    await tester.pumpAndSettle();

    expect(find.text('Model: Test Device'), findsOneWidget);
  });
}
```

---

## Coverage and Test Automation

Measuring test coverage and automating testing.

### Coverage Setup:

```yaml
dev_dependencies:
  test: ^1.21.0
  test_coverage: ^0.5.0
```

### Running Coverage:

```bash
# Generate coverage report
flutter test --coverage

# View HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Configuration:

```yaml
# pubspec.yaml
coverage:
  exclude:
    - 'lib/**/*.g.dart'  # Generated files
    - 'lib/**/*.freezed.dart'  # Freezed generated files
    - 'lib/main.dart'  # Main entry point
  threshold:
    functions: 80
    branches: 75
    lines: 85
```

### CI/CD Integration:

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
```

### Test Automation Scripts:

```dart
// test/test_runner.dart
import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Test Runner', () {
    test('runs all unit tests', () async {
      final result = await Process.run('flutter', ['test', 'test/unit/']);
      
      expect(result.exitCode, equals(0));
      print('Unit tests output: ${result.stdout}');
    });
    
    test('runs all widget tests', () async {
      final result = await Process.run('flutter', ['test', 'test/widget/']);
      
      expect(result.exitCode, equals(0));
      print('Widget tests output: ${result.stdout}');
    });
    
    test('runs integration tests', () async {
      final result = await Process.run('flutter', [
        'test',
        'integration_test/',
        '--driver=test_driver/integration_test.dart'
      ]);
      
      expect(result.exitCode, equals(0));
      print('Integration tests output: ${result.stdout}');
    });
    
    test('generates coverage report', () async {
      final result = await Process.run('flutter', ['test', '--coverage']);
      
      expect(result.exitCode, equals(0));
      
      // Check if coverage file exists
      final coverageFile = File('coverage/lcov.info');
      expect(coverageFile.existsSync(), isTrue);
    });
  });
}
```

### Test Utilities:

```dart
class TestUtils {
  static Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));
      
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    
    throw TestFailure('Widget not found within timeout');
  }
  
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));
      
      if (condition()) {
        return;
      }
    }
    
    throw TestFailure('Condition not met within timeout');
  }
  
  static Future<void> mockNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  static Future<void> mockSlowNetwork() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}

// Usage in tests
testWidgets('waits for async operation', (WidgetTester tester) async {
  await tester.pumpWidget(const MyAsyncWidget());
  
  await TestUtils.pumpUntilFound(tester, find.text('Loaded'));
  
  expect(find.text('Loaded'), findsOneWidget);
});
```

---

## Advanced Testing Patterns

### Test Doubles:

```dart
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
}

class FakeUserRepository implements UserRepository {
  final Map<String, User> _users = {};
  
  @override
  Future<User?> getUser(String id) async {
    await TestUtils.mockNetworkDelay();
    return _users[id];
  }
  
  @override
  Future<void> saveUser(User user) async {
    await TestUtils.mockNetworkDelay();
    _users[user.id] = user;
  }
  
  @override
  Future<void> deleteUser(String id) async {
    await TestUtils.mockNetworkDelay();
    _users.remove(id);
  }
}

class StubUserRepository implements UserRepository {
  final User? stubUser;
  
  StubUserRepository({this.stubUser});
  
  @override
  Future<User?> getUser(String id) async {
    return stubUser;
  }
  
  @override
  Future<void> saveUser(User user) async {
    // Do nothing
  }
  
  @override
  Future<void> deleteUser(String id) async {
    // Do nothing
  }
}
```

### Property-Based Testing:

```dart
import 'package:test/test.dart';

void main() {
  test('addition is commutative', () {
    for (int i = 0; i < 100; i++) {
      final a = i - 50; // Generate test values
      final b = i % 10;
      
      expect(a + b, equals(b + a));
    }
  });
  
  test('string concatenation properties', () {
    final randomStrings = [
      '', 'a', 'hello', 'world', '123', 'special chars !@#',
      'very long string that might cause issues' * 10,
    ];
    
    for (final str1 in randomStrings) {
      for (final str2 in randomStrings) {
        // Associativity
        expect((str1 + str2) + str2, equals(str1 + (str2 + str2)));
        
        // Length property
        expect((str1 + str2).length, equals(str1.length + str2.length));
      }
    }
  });
}
```

### Golden Tests:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget matches golden file', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MyWidget()),
    );
    
    await expectLater(
      find.byType(MyWidget),
      matchesGoldenFile('goldens/my_widget.png'),
    );
  });
  
  testWidgets('Button states match golden files', (WidgetTester tester) async {
    // Test normal state
    await tester.pumpWidget(
      const MaterialApp(home: ElevatedButton(onPressed: null, child: Text('Test'))),
    );
    
    await expectLater(
      find.byType(ElevatedButton),
      matchesGoldenFile('goldens/button_normal.png'),
    );
    
    // Test pressed state
    await tester.press(find.byType(ElevatedButton));
    await tester.pump();
    
    await expectLater(
      find.byType(ElevatedButton),
      matchesGoldenFile('goldens/button_pressed.png'),
    );
  });
}
```

### Performance Testing:

```dart
class PerformanceTestUtils {
  static Future<Duration> measureBuildTime(
    WidgetTester tester,
    Widget widget,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    
    stopwatch.stop();
    return stopwatch.elapsed;
  }
  
  static Future<void> testBuildPerformance(
    WidgetTester tester,
    Widget widget, {
    Duration maxBuildTime = const Duration(milliseconds: 100),
  }) async {
    final buildTime = await measureBuildTime(tester, widget);
    
    expect(buildTime, lessThan(maxBuildTime));
  }
  
  static Future<void> testScrollPerformance(
    WidgetTester tester,
    Finder scrollable, {
    int itemCount = 100,
    Duration maxScrollTime = const Duration(milliseconds: 500),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    // Simulate scrolling through all items
    for (int i = 0; i < itemCount; i++) {
      await tester.drag(scrollable, const Offset(0, -100));
      await tester.pump();
    }
    
    stopwatch.stop();
    
    expect(stopwatch.elapsed, lessThan(maxScrollTime));
  }
}

testWidgets('ListView builds quickly', (WidgetTester tester) async {
  final items = List.generate(1000, (i) => 'Item $i');
  
  await PerformanceTestUtils.testBuildPerformance(
    tester,
    MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(title: Text(items[index])),
        ),
      ),
    ),
    maxBuildTime: const Duration(milliseconds: 200),
  );
});
```

---

## Summary

- **Unit Testing**: Test business logic with test package and Mockito for mocking
- **Widget Testing**: Test UI components with flutter_test and WidgetTester
- **Integration Testing**: Test complete app flows with integration_test
- **Coverage**: Measure test coverage with --coverage flag
- **CI/CD**: Automate testing in GitHub Actions or other CI systems
- **Advanced Patterns**: Use test doubles, property-based testing, golden tests, and performance testing

Testing ensures code quality, prevents regressions, and enables confident refactoring.
  });
}
```

---

## Widget Testing

Testing UI components and interactions.

### Basic Widget Test:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('count', key: Key('counter')),
              ElevatedButton(
                key: Key('increment-button'),
                onPressed: () {},
                child: Text('Increment'),
              ),
            ],
          ),
        ),
      ),
    );

    // Find widgets
    expect(find.text('count'), findsOneWidget);
    expect(find.byKey(Key('increment-button')), findsOneWidget);

    // Tap button
    await tester.tap(find.byKey(Key('increment-button')));
    
    // Rebuild after state change
    await tester.pumpAndSettle();
  });
}
```

### Finding Widgets:

```dart
// Find by type
find.byType(Text);
find.byType(ElevatedButton);

// Find by Key
find.byKey(Key('unique-key'));

// Find by text
find.text('Button Label');

// Find by icon
find.byIcon(Icons.home);

// Combined
find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Hello');
```

### Interactions:

```dart
testWidgets('Form validation', (WidgetTester tester) async {
  // Type text
  await tester.enterText(find.byType(TextField), 'test@example.com');
  
  // Tap widget
  await tester.tap(find.byType(ElevatedButton));
  
  // Long press
  await tester.longPress(find.byType(ListTile));
  
  // Drag
  await tester.drag(find.byType(Slider), Offset(100, 0));
  
  // Pump to rebuild
  await tester.pump();
  
  // Pump until certain state
  await tester.pumpUntil(find.text('Success'), Duration(seconds: 5));
});
```

### Testing State Changes:

```dart
testWidgets('Counter updates state', (WidgetTester tester) async {
  await tester.pumpWidget(CounterApp());

  expect(find.text('0'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  expect(find.text('1'), findsOneWidget);
  expect(find.text('0'), findsNothing);
});
```

### Testing Navigation:

```dart
testWidgets('Navigate to detail screen', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  await tester.tap(find.text('Details'));
  await tester.pumpAndSettle();

  expect(find.text('Detail Screen'), findsOneWidget);
});
```

---

## Integration Testing

Testing complete workflows end-to-end.

### Setup:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

### Basic Integration Test:

```dart
// test_driver/integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete user flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byType(TextField).first, 'user@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify logged in
    expect(find.text('Welcome'), findsOneWidget);

    // Navigate to profile
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify profile
    expect(find.text('Profile'), findsOneWidget);
  });
}
```

### Run Integration Tests:

```bash
flutter test integration_test/integration_test.dart
```

---

## Test Coverage

### Generate Coverage Report:

```bash
flutter test --coverage
```

### View Coverage:

```bash
brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## BDD Testing with Golden Tests

### Golden Tests:

```dart
testWidgets('Counter widget matches gold file', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Text('Hello'),
      ),
    ),
  );

  await expectLater(
    find.byType(Text),
    matchesGoldenFile('counter.png'),
  );
});
```

### Generate Golden Files:

```bash
flutter test --update-goldens
```

---

## Best Practices

1. **Test behavior, not implementation**
2. **Keep tests simple and focused**
3. **Use descriptive test names**
4. **Test edge cases and error handling**
5. **Mock external dependencies**
6. **Aim for high coverage**
7. **Run tests frequently**
8. **Keep tests fast**
9. **Test user interactions**
10. **Use setup/teardown for cleanup**

---

## Test Structure

```dart
void main() {
  group('Feature', () {
    setUp(() {
      // Prepare test
    });

    tearDown(() {
      // Cleanup
    });

    test('requirement', () {
      // Arrange
      
      // Act
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

---

## Summary

- **Unit Tests**: Test business logic
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete workflows
- **Golden Tests**: Visual regression testing
- **Mocking**: Mock dependencies
- **Coverage**: Measure code coverage
- Always test edge cases
- Keep tests clear and maintainable
