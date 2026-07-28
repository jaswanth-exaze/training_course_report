# Flutter Core Foundation

## What is Flutter?

Flutter is an open-source UI framework developed by Google for building natively compiled applications for mobile (iOS, Android), web, and desktop from a single codebase. It uses the Dart programming language and provides a rich set of pre-designed widgets that follow Material Design and Cupertino (iOS) design principles.

### Key Characteristics:
- **Single Codebase**: Write once, deploy everywhere
- **Hot Reload**: See changes instantly during development
- **High Performance**: Compiles to native code
- **Rich Widgets**: Extensive library of customizable widgets
- **Open Source**: Community-driven development

### Why Choose Flutter?

Flutter offers several advantages over traditional cross-platform frameworks:

1. **Native Performance**: Compiles to native ARM code, not interpreted JavaScript
2. **Consistent UI**: Pixel-perfect rendering across all platforms
3. **Fast Development**: Hot reload enables instant feedback
4. **Rich Ecosystem**: Thousands of packages and plugins
5. **Strong Community**: Active development and support
6. **Cost Effective**: Single codebase for multiple platforms

### Flutter vs Other Frameworks

| Feature | Flutter | React Native | Native iOS/Android |
|---------|---------|--------------|-------------------|
| Language | Dart | JavaScript | Swift/Kotlin |
| Performance | Excellent | Good | Excellent |
| UI Consistency | Excellent | Good | Platform-specific |
| Development Speed | Fast | Fast | Slower |
| Learning Curve | Moderate | Moderate | Steep |
| Code Sharing | 100% | ~70% | 0% |

---

## Flutter Architecture

Flutter follows a layered architecture with three main layers:

### 1. **Framework Layer** (Dart)
- High-level Dart APIs
- Material and Cupertino design libraries
- Widget framework
- Gesture detection
- Navigation
- Animation system
- State management

### 2. **Engine Layer** (C/C++)
- Core rendering engine (Skia graphics library)
- Platform-specific implementations
- Graphics rendering and compositing
- Text layout and rendering
- Input handling
- Threading and scheduling

### 3. **Embedder Layer** (Platform-Specific)
- Platform-specific entry points (iOS, Android, Web, Desktop)
- Native plugin integration
- Platform channel communication
- System integration (notifications, sensors, etc.)

### Architecture Flow:
```
User Interface (Dart Code)
         ↓
    Framework Layer
         ↓
    Engine Layer (Skia)
         ↓
    Native Platform (Android/iOS)
         ↓
    Hardware
```

### How Flutter Renders:
1. Dart code builds a widget tree
2. The framework converts the widget tree to render objects
3. Render objects perform layout and painting
4. The engine (Skia) draws pixels on the screen
5. Platform-specific layers handle native integration

### Widget Tree vs Render Tree

Flutter maintains two trees:
- **Widget Tree**: Describes the UI structure (immutable)
- **Render Tree**: Handles layout and painting (mutable)

```dart
// Widget Tree (immutable configuration)
MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: Text('Title')),
    body: Center(child: Text('Hello')),
  ),
)

// Render Tree (mutable layout/paint objects)
// Created automatically by Flutter
```

### Flutter Threading Model

Flutter uses multiple threads for optimal performance:

1. **UI Thread**: Main Dart thread for UI logic
2. **Platform Thread**: Handles platform-specific operations
3. **Raster Thread**: Handles graphics rendering
4. **I/O Thread**: Handles network and file operations

---

## Dart Language Deep Dive

### Null Safety

*Null safety* prevents runtime errors from null reference exceptions.

```dart
// Without null safety - can throw error
String? name; // Nullable type
String title = "Flutter"; // Non-nullable type (cannot be null)

// Null coalescing operator
String userName = name ?? "Guest"; // Use "Guest" if name is null

// Safe navigation operator
int? length = name?.length; // Returns null if name is null, otherwise length

// Non-null assertion (use carefully!)
String forcedName = name!; // Throws error if name is null

// Late initialization
late String lateName; // Must be assigned before use
lateName = "John";

// Late with lazy initialization
late String lazyName = getName(); // Called only when accessed
```

### Advanced Null Safety Patterns

```dart
class User {
  final String? name;
  final int? age;
  
  User({this.name, this.age});
  
  // Safe property access
  String get displayName => name ?? "Unknown";
  
  // Conditional execution
  void printDetails() {
    if (name != null && age != null) {
      print("$name is $age years old");
    } else {
      print("Incomplete user data");
    }
  }
  
  // Null-aware cascade
  void updateUser() {
    user
      ?..name = "New Name"
      ..age = 25;
  }
}
```

### Async/Await

Dart uses futures and async/await for asynchronous operations.

```dart
// Future - represents a value that will be available in the future
Future<String> fetchData() {
  return Future.delayed(Duration(seconds: 2), () => "Data loaded");
}

// Async/Await - cleaner syntax for handling futures
void loadData() async {
  try {
    String data = await fetchData();
    print(data); // "Data loaded"
  } catch (e) {
    print("Error: $e");
  }
}

// Future chaining
Future<String> processData() async {
  final rawData = await fetchData();
  final processed = await transformData(rawData);
  return processed;
}

// Parallel execution
Future<void> loadMultipleData() async {
  final futures = await Future.wait([
    fetchUserData(),
    fetchPosts(),
    fetchComments(),
  ]);
  
  // All futures complete here
  print("All data loaded");
}
```

### Streams for Reactive Programming

```dart
// Stream - sequence of asynchronous events
Stream<int> countStream() async* {
  for (int i = 1; i <= 5; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

// Consuming streams
void listenToStream() async {
  await for (int count in countStream()) {
    print("Count: $count");
  }
}

// Stream transformations
Stream<String> transformedStream() {
  return countStream()
    .map((count) => "Number: $count")
    .where((text) => text.contains("2") || text.contains("4"));
}

// StreamController for custom streams
class DataController {
  final StreamController<String> _controller = StreamController<String>();
  
  Stream<String> get stream => _controller.stream;
  
  void addData(String data) {
    _controller.add(data);
  }
  
  void close() {
    _controller.close();
  }
}
```

### Generics

```dart
// Generic classes
class Container<T> {
  T? value;
  
  void setValue(T value) {
    this.value = value;
  }
  
  T? getValue() {
    return value;
  }
}

// Generic methods
T findFirst<T>(List<T> items, bool Function(T) test) {
  return items.firstWhere(test);
}

// Generic constraints
class NumberContainer<T extends num> {
  T value;
  
  NumberContainer(this.value);
  
  T add(T other) {
    return (value + other) as T;
  }
}

// Usage
final stringContainer = Container<String>();
stringContainer.setValue("Hello");

final intContainer = Container<int>();
intContainer.setValue(42);

final numberContainer = NumberContainer<double>(3.14);
```

### Mixins for Code Reuse

```dart
// Mixin definition
mixin Logger {
  void log(String message) {
    print("[${DateTime.now()}] $message");
  }
}

mixin Validator {
  bool isValid(String input) {
    return input.isNotEmpty;
  }
}

// Using mixins
class UserService with Logger, Validator {
  void createUser(String name) {
    if (!isValid(name)) {
      log("Invalid user name: $name");
      return;
    }
    
    log("Creating user: $name");
    // Create user logic
  }
}

// Multiple inheritance with mixins
abstract class Animal {
  void eat();
}

mixin Walker {
  void walk() => print("Walking");
}

mixin Swimmer {
  void swim() => print("Swimming");
}

class Duck extends Animal with Walker, Swimmer {
  @override
  void eat() => print("Eating");
}
```

### Extension Methods

```dart
// Adding methods to existing classes
extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }
}

// Usage
final name = "john doe".capitalize(); // "John doe"
final isValidEmail = "user@example.com".isEmail; // true
```

### Advanced Classes and OOP

```dart
// Abstract classes
abstract class Shape {
  double get area;
  double get perimeter;
  
  void draw() {
    print("Drawing shape");
  }
}

// Implementing abstract class
class Circle extends Shape {
  final double radius;
  
  Circle(this.radius);
  
  @override
  double get area => 3.14159 * radius * radius;
  
  @override
  double get perimeter => 2 * 3.14159 * radius;
}

// Factory constructors
class User {
  final String id;
  final String name;
  
  User._(this.id, this.name);
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User._(
      json['id'] as String,
      json['name'] as String,
    );
  }
  
  factory User.guest() {
    return User._("guest", "Guest User");
  }
}

// Singleton pattern
class DatabaseManager {
  static DatabaseManager? _instance;
  
  DatabaseManager._();
  
  static DatabaseManager get instance {
    _instance ??= DatabaseManager._();
    return _instance!;
  }
  
  void connect() {
    print("Connected to database");
  }
}

// Usage
final db = DatabaseManager.instance;
db.connect();
```

### Error Handling

```dart
// Custom exceptions
class NetworkException implements Exception {
  final String message;
  final int statusCode;
  
  NetworkException(this.message, this.statusCode);
  
  @override
  String toString() => "NetworkException: $message (Status: $statusCode)";
}

class ValidationException implements Exception {
  final String field;
  final String message;
  
  ValidationException(this.field, this.message);
  
  @override
  String toString() => "ValidationException: $field - $message";
}

// Exception handling patterns
Future<User> fetchUser(String id) async {
  try {
    final response = await http.get(Uri.parse('api/users/$id'));
    
    if (response.statusCode == 404) {
      throw NetworkException("User not found", 404);
    }
    
    if (response.statusCode != 200) {
      throw NetworkException("Server error", response.statusCode);
    }
    
    final json = jsonDecode(response.body);
    return User.fromJson(json);
    
  } on SocketException {
    throw NetworkException("No internet connection", 0);
  } on FormatException {
    throw ValidationException("response", "Invalid JSON format");
  } catch (e) {
    throw NetworkException("Unknown error: $e", 500);
  }
}

// Using custom exceptions
void loadUserProfile() async {
  try {
    final user = await fetchUser("123");
    print("User: ${user.name}");
  } on NetworkException catch (e) {
    print("Network error: ${e.message}");
  } on ValidationException catch (e) {
    print("Validation error: ${e.message}");
  } catch (e) {
    print("Unexpected error: $e");
  }
}
```

---

## Flutter Project Structure

### Standard Flutter Project Layout

```
my_flutter_app/
├── android/                    # Android-specific code
│   ├── app/
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── java/       # Java/Kotlin code
│   │   │   │   ├── res/        # Android resources
│   │   │   │   └── AndroidManifest.xml
│   │   └── build.gradle
│   └── build.gradle
├── ios/                        # iOS-specific code
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── Assets.xcassets/
│   └── Runner.xcodeproj/
├── lib/                        # Dart code
│   ├── main.dart              # App entry point
│   ├── widgets/               # Custom widgets
│   ├── screens/               # Screen/page widgets
│   ├── models/                # Data models
│   ├── services/              # API services
│   ├── utils/                 # Utility functions
│   └── constants.dart         # App constants
├── test/                       # Unit and widget tests
├── integration_test/           # Integration tests
├── pubspec.yaml               # Dependencies and assets
├── pubspec.lock               # Lock file
├── analysis_options.yaml      # Code analysis config
└── README.md
```

### Advanced Project Structure (Feature-based)

```
lib/
├── core/                      # Core functionality
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/                  # Feature modules
│   ├── auth/
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
├── shared/                    # Shared components
│   ├── widgets/
│   ├── models/
│   └── services/
└── main.dart
```

### Clean Architecture Structure

```
lib/
├── data/                      # Data layer
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/                    # Domain layer
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/              # Presentation layer
│   ├── pages/
│   ├── widgets/
│   └── blocs/
└── core/                      # Core utilities
    ├── error/
    ├── network/
    └── usecases/
```

---

## Flutter Entry Point

### main.dart Analysis

```dart
import 'package:flutter/material.dart';

void main() {
  // Initialize app-wide services
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure app settings
  // - Error handling
  // - Logging
  // - Dependency injection
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
```

### Advanced main.dart

```dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  await initializeServices();
  
  // Setup error handling
  setupErrorHandling();
  
  // Run zoned to catch unhandled errors
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) {
      // Log error to crash reporting service
      developer.log('Unhandled error', error: error, stackTrace: stackTrace);
    },
  );
}

Future<void> initializeServices() async {
  // Initialize local storage
  // Initialize network client
  // Initialize analytics
  // Initialize crash reporting
}

void setupErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // Handle Flutter framework errors
    developer.log('Flutter error', error: details.exception, stackTrace: details.stack);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    // Handle platform errors
    developer.log('Platform error', error: error, stackTrace: stack);
    return true;
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App-wide state providers
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Advanced Flutter App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
        },
        builder: (context, child) {
          // Global error boundary
          return ErrorBoundary(
            child: child ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
```

---

## Flutter Build Modes

### Debug Mode
- **Hot Reload**: Instant code changes
- **Assertions**: Debug checks enabled
- **Debugging**: Full debugging support
- **Performance**: Slower, includes debug banners
- **Use**: Development

### Profile Mode
- **Performance**: Optimized for performance measurement
- **Debugging**: Limited debugging
- **Assertions**: Disabled
- **Use**: Performance testing

### Release Mode
- **Performance**: Fully optimized
- **Debugging**: No debugging support
- **Assertions**: Disabled
- **Code**: Minified and obfuscated
- **Use**: Production deployment

### Build Commands

```bash
# Debug build
flutter run

# Profile build
flutter run --profile

# Release build
flutter run --release

# Build APK
flutter build apk --debug
flutter build apk --profile
flutter build apk --release

# Build AAB (Android App Bundle)
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

---

## Flutter Internals

### Widget Lifecycle

```dart
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Called once when widget is inserted into tree
    print('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when dependencies change
    print('didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Called when widget configuration changes
    print('didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    // Called when widget needs to rebuild
    print('build');
    return const Text('Hello');
  }

  @override
  void dispose() {
    // Called when widget is removed from tree
    print('dispose');
    super.dispose();
  }
}
```

### BuildContext

```dart
class BuildContextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    
    // Get theme
    final theme = Theme.of(context);
    
    // Navigate
    Navigator.of(context).pushNamed('/details');
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hello')),
    );
    
    return Container(
      width: size.width,
      height: size.height,
      color: theme.primaryColor,
      child: const Text('Context Example'),
    );
  }
}
```

### Key Concepts

1. **Everything is a Widget**: UI is built from composable widgets
2. **Immutable Widgets**: Widgets are configuration, not UI elements
3. **Build Method**: Called whenever widget needs to update
4. **Context**: Provides access to widget tree and inherited widgets
5. **Keys**: Unique identifiers for widgets in the tree

---

## Performance Considerations

### Common Performance Issues

1. **Frequent Rebuilds**: Widgets rebuilding unnecessarily
2. **Expensive Build Methods**: Heavy computations in build()
3. **Large Widget Trees**: Deep nesting causing layout issues
4. **Memory Leaks**: Not disposing resources properly
5. **Inefficient Lists**: Not using proper list optimizations

### Optimization Techniques

```dart
// Use const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Text('Optimized'); // const prevents unnecessary rebuilds
  }
}

// Extract expensive computations
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Move expensive operations outside build()
    return Text(_getFormattedText());
  }
  
  String _getFormattedText() {
    // Expensive formatting logic here
    return "Formatted text";
  }
}

// Use keys for list items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id), // Stable key
      title: Text(items[index].name),
    );
  },
);
```

---

## Flutter Development Workflow

### Development Cycle

1. **Planning**: Design UI and architecture
2. **Setup**: Create project and configure dependencies
3. **Development**: Write code with hot reload
4. **Testing**: Unit tests, widget tests, integration tests
5. **Debugging**: Use DevTools for performance and debugging
6. **Building**: Create release builds
7. **Deployment**: Publish to app stores

### Best Practices

1. **Use const**: For immutable widgets
2. **Avoid setState in build**: Causes infinite loops
3. **Use keys**: For stable widget identity
4. **Profile performance**: Use DevTools regularly
5. **Write tests**: Ensure code reliability
6. **Follow conventions**: Consistent code style
7. **Document code**: Clear comments and documentation
8. **Version control**: Use Git for source control

---

## Summary

- **Flutter**: Cross-platform UI framework using Dart
- **Architecture**: Framework → Engine → Embedder layers
- **Dart**: Modern language with null safety and async support
- **Widgets**: Building blocks of Flutter UI
- **Hot Reload**: Instant development feedback
- **Performance**: Native compilation for high performance
- **Ecosystem**: Rich package ecosystem
- **Community**: Active development and support

Flutter provides a modern, efficient way to build beautiful, high-performance applications across multiple platforms with a single codebase.

// Multiple async operations
Future<void> loadMultipleData() async {
  String data1 = await fetchData();
  String data2 = await fetchData();
  print("$data1 and $data2");
}

// Parallel async operations
Future<void> loadParallel() async {
  final results = await Future.wait([
    fetchData(),
    fetchData(),
    fetchData(),
  ]);
}
```

### Object-Oriented Programming (OOP)

```dart
// Classes and constructors
class Person {
  String name;
  int age;
  
  // Constructor
  Person(this.name, this.age);
  
  // Named constructor
  Person.guest() : name = "Guest", age = 0;
  
  // Method
  void greet() {
    print("Hello, I'm $name");
  }
}

// Inheritance
class Employee extends Person {
  String employeeId;
  
  Employee(String name, int age, this.employeeId) : super(name, age);
  
  @override
  void greet() {
    print("I'm employee $employeeId");
  }
}

// Mixins - reusable code in multiple classes
mixin Swimmer {
  void swim() {
    print("Swimming...");
  }
}

mixin Runner {
  void run() {
    print("Running...");
  }
}

class Athlete extends Person with Swimmer, Runner {
  Athlete(String name, int age) : super(name, age);
}

// Abstract classes
abstract class Shape {
  double getArea();
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);
  
  @override
  double getArea() => 3.14159 * radius * radius;
}
```

---

## Project Structure

A typical Flutter project structure:

```
my_flutter_app/
├── android/               # Android native code
├── ios/                   # iOS native code
├── lib/                   # Dart code (main directory)
│   ├── main.dart         # Entry point
│   ├── screens/          # Full screen widgets
│   ├── widgets/          # Reusable widgets
│   ├── models/           # Data models
│   ├── services/         # API and business logic
│   ├── providers/        # State management
│   └── utils/            # Utilities and constants
├── test/                 # Unit and widget tests
├── web/                  # Web build files
├── pubspec.yaml          # Dependencies and project config
├── pubspec.lock          # Lock file for dependencies
└── README.md
```

### Best Practices:
- Organize code by feature or layer
- Keep lib/ clean and organized
- Place constants in a separate utils/ file
- Separate UI logic from business logic

---

## main.dart

The entry point of every Flutter application.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(child: Text('Hello, Flutter!')),
    );
  }
}
```

---

## runApp()

`runApp()` is the entry point that:
1. Takes a widget as an argument
2. Inflates the widget and attaches it to the screen
3. Typically used to run the root widget (usually MaterialApp or CupertinoApp)

```dart
void main() {
  // This tells Flutter to run the MyApp widget
  runApp(const MyApp());
}
```

### What happens inside runApp():
1. Initializes the Flutter engine
2. Binds the widget to the platform
3. Schedules the first frame
4. Listens to platform messages

---

## MaterialApp vs CupertinoApp

### MaterialApp (Android/Google Design)

```dart
MaterialApp(
  title: 'Material App',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
  ),
  home: const HomePage(),
  routes: {
    '/about': (context) => const AboutPage(),
  },
)
```

**Features:**
- Material Design 3 (or older Material Design 2)
- Uses Material widgets
- Provides Material theme
- Default for Android-like UIs

### CupertinoApp (iOS Design)

```dart
CupertinoApp(
  title: 'Cupertino App',
  theme: const CupertinoThemeData(
    primaryColor: CupertinoColors.systemBlue,
  ),
  home: const HomePage(),
  routes: {
    '/about': (context) => const AboutPage(),
  },
)
```

**Features:**
- iOS-style design (Cupertino = Apple's design system)
- Uses iOS-like transitions and patterns
- Follows iOS Human Interface Guidelines
- Better for iOS-first applications

### Comparison Table

| Feature | MaterialApp | CupertinoApp |
|---------|-------------|--------------|
| Design Language | Material Design 3 | iOS (Cupertino) |
| Platform | Android/Web | iOS |
| Navigation | Push from left | Push from right |
| AppBar | AppBar | CupertinoNavigationBar |
| Button | ElevatedButton | CupertinoButton |
| Dialog | AlertDialog | CupertinoAlertDialog |

### Platform-Agnostic App

For cross-platform apps, use MaterialApp but implement platform-specific widgets where needed:

```dart
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'My App',
        home: const HomePage(),
      );
    }
    return MaterialApp(
      title: 'My App',
      home: const HomePage(),
    );
  }
}
```

---

## Summary

- **Flutter** is a cross-platform UI framework using Dart
- **Architecture** has three layers: Framework, Engine, and Embedder
- **Dart** uses null safety, async/await, and strong OOP support
- **Project structure** should be organized logically
- **main.dart** contains the entry point and app configuration
- **runApp()** initializes and runs the Flutter app
- **MaterialApp** is for Android/Material Design
- **CupertinoApp** is for iOS/Cupertino Design
