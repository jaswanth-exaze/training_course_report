# Flutter Debugging

Finding and fixing issues in Flutter applications.

---

## Flutter DevTools

Comprehensive debugging suite.

### Launch DevTools:

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Or directly from VS Code / Android Studio.

### Features:

1. **Inspector**: Widget tree and properties
2. **Console**: Logs and errors
3. **Debugger**: Breakpoints and stepping
4. **Performance**: Frame rate and rendering
5. **Network**: HTTP requests
6. **Memory**: Memory profiling
7. **CPU**: CPU profiling

### Inspector Deep Dive:

```dart
class DebugWidget extends StatelessWidget {
  const DebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Example')),
      body: Column(
        children: [
          // Add debug keys for easier identification
          Container(
            key: const Key('debug_container'),
            height: 100,
            color: Colors.blue,
            child: const Center(
              child: Text('Debug Me'),
            ),
          ),
          
          // Use debug labels
          Semantics(
            label: 'Debug Label',
            child: ElevatedButton(
              onPressed: () {
                debugPrint('Button pressed');
              },
              child: const Text('Press Me'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Widget Inspector Usage:

```dart
void main() {
  runApp(
    const MyApp(),
    // Enable inspector
  );
}

// In debug mode, shake device or use:
// flutter run --debug
// Then press 'i' in terminal to open inspector
```

---

## Logging

### Print Debugging:

```dart
print("Value: $value");
print("Complete object: $myObject");
```

### Advanced Print Debugging:

```dart
class DebugUtils {
  static void log(String message, {String tag = 'DEBUG'}) {
    final timestamp = DateTime.now().toString();
    print('[$timestamp] [$tag] $message');
  }
  
  static void logObject(dynamic object, {String tag = 'OBJECT'}) {
    log('Type: ${object.runtimeType}', tag: tag);
    log('Value: $object', tag: tag);
    
    if (object is Map) {
      log('Keys: ${object.keys.toList()}', tag: tag);
    } else if (object is List) {
      log('Length: ${object.length}', tag: tag);
    }
  }
  
  static void logWidgetTree(BuildContext context, {String tag = 'WIDGET'}) {
    final widget = context.widget;
    log('Widget: ${widget.runtimeType}', tag: tag);
    log('Key: ${widget.key}', tag: tag);
    
    if (widget is StatelessWidget) {
      log('StatelessWidget', tag: tag);
    } else if (widget is StatefulWidget) {
      log('StatefulWidget', tag: tag);
    }
  }
}

// Usage
DebugUtils.log('User tapped button');
DebugUtils.logObject({'userId': 123, 'action': 'login'});
DebugUtils.logWidgetTree(context);
```

### Logging Library:

```yaml
dependencies:
  logger: ^1.1.0
```

```dart
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

void main() {
  logger.d("Debug message");
  logger.i("Info message");
  logger.w("Warning message");
  logger.e("Error message");
  
  // Structured logging
  logger.i("User login", {"userId": 123, "method": "email"});
}
```

### Structured Logging:

```dart
class StructuredLogger {
  static void logEvent(String event, Map<String, dynamic> data) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = {
      'timestamp': timestamp,
      'event': event,
      'data': data,
      'platform': Platform.operatingSystem,
      'version': '1.0.0',
    };
    
    print(jsonEncode(logEntry));
  }
  
  static void logError(String error, {StackTrace? stackTrace, Map<String, dynamic>? context}) {
    final errorData = {
      'error': error,
      'stackTrace': stackTrace?.toString(),
      'context': context,
    };
    
    logEvent('error', errorData);
  }
  
  static void logPerformance(String operation, Duration duration, {Map<String, dynamic>? metadata}) {
    final perfData = {
      'operation': operation,
      'durationMs': duration.inMilliseconds,
      'metadata': metadata,
    };
    
    logEvent('performance', perfData);
  }
}

// Usage
StructuredLogger.logEvent('user_action', {
  'action': 'button_click',
  'screen': 'home',
  'userId': 123,
});

StructuredLogger.logError('Network timeout', context: {
  'endpoint': '/api/users',
  'method': 'GET',
});
```

### File Logging:

```dart
class FileLogger {
  static const String _logFile = 'app_logs.txt';
  
  static Future<void> logToFile(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFile');
      
      final timestamp = DateTime.now().toIso8601String();
      final logEntry = '[$timestamp] $message\n';
      
      await file.writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      print('Failed to write to log file: $e');
    }
  }
  
  static Future<String> readLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFile');
      
      if (await file.exists()) {
        return await file.readAsString();
      }
      return 'No logs found';
    } catch (e) {
      return 'Error reading logs: $e';
    }
  }
  
  static Future<void> clearLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFile');
      
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Failed to clear logs: $e');
    }
  }
}
```

---

## Error Handling

### Try-Catch Blocks:

```dart
Future<void> fetchUserData(String userId) async {
  try {
    final response = await http.get(Uri.parse('https://api.example.com/users/$userId'));
    
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      return User.fromJson(userData);
    } else {
      throw HttpException('Failed to load user: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    // Network error
    logger.e('Network error: $e');
    throw NetworkException('No internet connection');
  } on HttpException catch (e) {
    // HTTP error
    logger.e('HTTP error: $e');
    throw e;
  } on FormatException catch (e) {
    // JSON parsing error
    logger.e('JSON parsing error: $e');
    throw DataParsingException('Invalid data format');
  } catch (e, stackTrace) {
    // Unexpected error
    logger.e('Unexpected error: $e', error: e, stackTrace: stackTrace);
    throw UnknownException('An unexpected error occurred');
  }
}
```

### Custom Exceptions:

```dart
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  AppException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class AuthenticationException extends AppException {
  AuthenticationException(String message) : super(message, code: 'AUTH_ERROR');
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;
  
  ValidationException(String message, this.fieldErrors) 
      : super(message, code: 'VALIDATION_ERROR');
}
```

### Error Boundaries:

```dart
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  
  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });
  
  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  
  @override
  void initState() {
    super.initState();
    
    // Catch Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
      
      // Log the error
      StructuredLogger.logError(
        details.exception.toString(),
        stackTrace: details.stack,
        context: {
          'library': details.library,
          'context': details.context?.toString(),
        },
      );
    };
  }
  
  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace);
      }
      
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _stackTrace = null;
                  });
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return widget.child;
  }
}

// Usage
void main() {
  runApp(
    ErrorBoundary(
      errorBuilder: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text('Custom error: $error'),
          ),
        );
      },
      child: const MyApp(),
    ),
  );
}
```

### Async Error Handling:

```dart
class AsyncErrorHandler {
  static Future<T> handleAsync<T>(
    Future<T> Function() operation, {
    T? defaultValue,
    String? operationName,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      final name = operationName ?? 'async_operation';
      StructuredLogger.logError('$name failed: $e', stackTrace: stackTrace);
      
      if (defaultValue != null) {
        return defaultValue;
      }
      
      rethrow;
    }
  }
  
  static Future<void> retryAsync<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(Object error)? shouldRetry,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        await operation();
        return;
      } catch (e) {
        attempts++;
        
        if (attempts >= maxRetries) {
          rethrow;
        }
        
        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }
        
        logger.w('Attempt $attempts failed, retrying in ${delay.inSeconds}s: $e');
        await Future.delayed(delay);
        
        // Exponential backoff
        delay *= 2;
      }
    }
  }
}

// Usage
Future<User> loadUser(String userId) async {
  return AsyncErrorHandler.handleAsync(
    () => fetchUserFromApi(userId),
    operationName: 'load_user',
    defaultValue: User.guest(),
  );
}

Future<void> uploadData(Map<String, dynamic> data) async {
  await AsyncErrorHandler.retryAsync(
    () => uploadToServer(data),
    maxRetries: 3,
    shouldRetry: (error) => error is NetworkException,
  );
}
```

---

## Breakpoints and Debugging

### Setting Breakpoints:

1. Click on line number in VS Code
2. Code will pause when reached
3. Use Debug Console to inspect variables

### Breakpoint Commands:

```dart
// Conditional breakpoint
// Set condition: count > 10

// Logpoint (log without stopping)
// Add message: "Count: {count}"
```

### Advanced Breakpoint Techniques:

```dart
class DebugBreakpoints {
  static void conditionalBreakpoint(bool condition, String message) {
    if (condition) {
      // Set breakpoint here
      print('Breakpoint triggered: $message');
    }
  }
  
  static void watchVariable(dynamic variable, String name) {
    // Set breakpoint here to watch variable changes
    print('Watching $name: $variable');
  }
  
  static void assertCondition(bool condition, String message) {
    assert(condition, message);
  }
}

// Usage
void processItems(List<String> items) {
  for (int i = 0; i < items.length; i++) {
    final item = items[i];
    
    // Conditional breakpoint
    DebugBreakpoints.conditionalBreakpoint(
      item.contains('error'),
      'Found error item at index $i',
    );
    
    // Watch variable
    DebugBreakpoints.watchVariable(item, 'current_item');
    
    // Assert condition
    DebugBreakpoints.assertCondition(
      item.isNotEmpty,
      'Item at index $i is empty',
    );
  }
}
```

### Stepping:

- **Step Over** (F10): Execute current line
- **Step Into** (F11): Enter function
- **Step Out** (Shift+F11): Exit function
- **Continue** (F5): Resume execution

### Inspect Variables:

```dart
class DebugInspector {
  static void inspectObject(dynamic object, {String label = 'Object'}) {
    print('=== $label ===');
    print('Type: ${object.runtimeType}');
    print('Value: $object');
    
    if (object is Map) {
      print('Keys: ${object.keys.toList()}');
      print('Values: ${object.values.toList()}');
    } else if (object is List) {
      print('Length: ${object.length}');
      if (object.isNotEmpty) {
        print('First item: ${object.first}');
        print('Last item: ${object.last}');
      }
    } else if (object is String) {
      print('Length: ${object.length}');
      print('Is empty: ${object.isEmpty}');
    }
    
    print('================');
  }
  
  static void inspectWidget(BuildContext context) {
    final widget = context.widget;
    final renderObject = context.findRenderObject();
    
    print('=== Widget Inspection ===');
    print('Widget type: ${widget.runtimeType}');
    print('Key: ${widget.key}');
    print('Render object: ${renderObject?.runtimeType}');
    
    if (renderObject is RenderBox) {
      print('Size: ${renderObject.size}');
      print('Position: ${renderObject.localToGlobal(Offset.zero)}');
    }
    
    print('========================');
  }
  
  static void inspectBuildContext(BuildContext context) {
    print('=== BuildContext Inspection ===');
    print('Widget: ${context.widget.runtimeType}');
    print('Mounted: ${context.mounted}');
    print('Owner: ${context.owner?.runtimeType}');
    print('Size: ${MediaQuery.of(context).size}');
    print('Orientation: ${MediaQuery.of(context).orientation}');
    print('==============================');
  }
}

// Usage in debugger
DebugInspector.inspectObject(myVariable);
DebugInspector.inspectWidget(context);
DebugInspector.inspectBuildContext(context);
```

---

## Performance Debugging

### Performance Overlay:

```dart
class PerformanceOverlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YourAppContent(),
        
        // Performance overlay
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.black.withOpacity(0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                // Add performance metrics here
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Enable performance overlay in MaterialApp
MaterialApp(
  showPerformanceOverlay: true, // Shows FPS and GPU info
  debugShowCheckedModeBanner: false,
  home: YourHomePage(),
)
```

### Performance Profiling:

```dart
class PerformanceProfiler {
  static final Map<String, Stopwatch> _timers = {};
  
  static void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }
  
  static void stopTimer(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      final duration = timer.elapsed;
      print('[$name] took ${duration.inMilliseconds}ms');
      _timers.remove(name);
    }
  }
  
  static void measureFunction(String name, Function function) {
    startTimer(name);
    function();
    stopTimer(name);
  }
  
  static Future<void> measureAsyncFunction(String name, Future<void> Function() function) async {
    startTimer(name);
    await function();
    stopTimer(name);
  }
  
  static Widget profileBuildTime(Widget child, String widgetName) {
    return _BuildTimeProfiler(child: child, widgetName: widgetName);
  }
}

class _BuildTimeProfiler extends StatefulWidget {
  final Widget child;
  final String widgetName;
  
  const _BuildTimeProfiler({required this.child, required this.widgetName});
  
  @override
  State<_BuildTimeProfiler> createState() => _BuildTimeProfilerState();
}

class _BuildTimeProfilerState extends State<_BuildTimeProfiler> {
  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    final result = widget.child;
    
    stopwatch.stop();
    print('[${widget.widgetName}] build took ${stopwatch.elapsedMilliseconds}ms');
    
    return result;
  }
}

// Usage
class ProfiledWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerformanceProfiler.profileBuildTime(
      Column(
        children: [
          ExpensiveWidget(),
          AnotherExpensiveWidget(),
        ],
      ),
      'MainColumn',
    );
  }
}

Future<void> loadData() async {
  await PerformanceProfiler.measureAsyncFunction('data_loading', () async {
    // Simulate data loading
    await Future.delayed(Duration(seconds: 2));
  });
}
```

### Memory Debugging:

```dart
class MemoryDebugger {
  static void printMemoryInfo() {
    // This is a simplified example
    // In a real app, you'd use platform-specific APIs or dev tools
    print('Memory debugging not available on this platform');
  }
  
  static void checkForMemoryLeaks() {
    // Force garbage collection (debug only)
    print('Checking for memory leaks...');
  }
  
  static Widget memoryAwareWidget(Widget child) {
    return _MemoryAwareWidget(child: child);
  }
}

class _MemoryAwareWidget extends StatefulWidget {
  final Widget child;
  
  const _MemoryAwareWidget({required this.child});
  
  @override
  State<_MemoryAwareWidget> createState() => _MemoryAwareWidgetState();
}

class _MemoryAwareWidgetState extends State<_MemoryAwareWidget>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // Clear caches, dispose resources
        print('App paused - clearing memory');
        break;
      case AppLifecycleState.resumed:
        // Restore if needed
        print('App resumed');
        break;
      default:
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

---

## Crash Reporting

### Firebase Crashlytics:

```yaml
dependencies:
  firebase_crashlytics: ^3.0.0
```

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Crashlytics
  await Firebase.initializeApp();
  
  // Pass all uncaught errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  // Handle async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const MyApp());
}

class CrashReportingService {
  static void recordError(dynamic error, StackTrace? stack, {String? reason}) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
    );
  }
  
  static void setUserIdentifier(String userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }
  
  static void setCustomKey(String key, dynamic value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value);
  }
  
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
}

// Usage
try {
  // Risky operation
  await riskyApiCall();
} catch (e, stack) {
  CrashReportingService.recordError(e, stack, reason: 'API call failed');
  CrashReportingService.setCustomKey('last_api_call', DateTime.now().toString());
  
  // Still handle the error gracefully
  showErrorDialog('Something went wrong');
}
```

### Sentry Integration:

```yaml
dependencies:
  sentry_flutter: ^7.0.0
```

```dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'your-dsn-here';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class SentryReportingService {
  static void captureException(dynamic exception, {StackTrace? stackTrace, Map<String, dynamic>? extras}) {
    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (extras != null) {
          for (final entry in extras.entries) {
            scope.setExtra(entry.key, entry.value);
          }
        }
      },
    );
  }
  
  static void addBreadcrumb(String message, {String? category, SentryLevel? level}) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level ?? SentryLevel.info,
      ),
    );
  }
  
  static Future<void> setUser(SentryUser user) async {
    await Sentry.setUser(user);
  }
}

// Usage
SentryReportingService.addBreadcrumb('User tapped login button', category: 'ui');

try {
  await loginUser(email, password);
} catch (e, stack) {
  SentryReportingService.captureException(e, stackTrace: stack, extras: {
    'email': email,
    'login_method': 'email',
  });
}
```

---

## Troubleshooting Techniques

### Common Issues and Solutions:

```dart
class TroubleshootingGuide {
  // Issue: Widget not updating
  static void debugWidgetNotUpdating(BuildContext context) {
    print('=== Widget Update Debug ===');
    print('Widget: ${context.widget.runtimeType}');
    print('Mounted: ${context.mounted}');
    
    // Check if state is being set
    if (context is StatefulElement) {
      print('State: ${context.state.runtimeType}');
    }
    
    // Check for const widgets
    final widget = context.widget;
    if (widget is StatelessWidget) {
      print('Stateless widget - check if parent is updating');
    }
  }
  
  // Issue: Layout overflow
  static void debugLayoutOverflow(BoxConstraints constraints, Size size) {
    print('=== Layout Debug ===');
    print('Constraints: $constraints');
    print('Size: $size');
    print('Overflow: ${constraints.maxWidth < size.width || constraints.maxHeight < size.height}');
    
    if (constraints.maxWidth < size.width) {
      print('Width overflow: ${size.width - constraints.maxWidth}');
    }
    if (constraints.maxHeight < size.height) {
      print('Height overflow: ${size.height - constraints.maxHeight}');
    }
  }
  
  // Issue: Performance issues
  static void debugPerformance() {
    print('=== Performance Debug ===');
    
    // Check for expensive operations in build
    print('Check for:');
    print('- Expensive computations in build()');
    print('- Large lists without builders');
    print('- Unnecessary rebuilds');
    print('- Missing const constructors');
    
    // Memory issues
    print('Memory checks:');
    print('- Disposed controllers?');
    print('- Closed streams?');
    print('- Cleared caches?');
  }
  
  // Issue: Navigation problems
  static void debugNavigation(BuildContext context) {
    print('=== Navigation Debug ===');
    print('Current route: ${ModalRoute.of(context)?.settings.name}');
    print('Can pop: ${Navigator.canPop(context)}');
    print('Route stack: ${Navigator.of(context).toString()}');
  }
  
  // Issue: State management issues
  static void debugStateManagement(ChangeNotifier? notifier) {
    print('=== State Management Debug ===');
    print('Notifier: ${notifier?.runtimeType}');
    print('Has listeners: ${notifier?.hasListeners ?? false}');
    
    if (notifier != null) {
      print('Listener count: ${notifier.listenerCount}');
    }
  }
}

// Usage in widgets
class DebuggableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Debug widget updates
    TroubleshootingGuide.debugWidgetNotUpdating(context);
    
    return Container();
  }
}

class DebugLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  TroubleshootingGuide.debugLayoutOverflow(
                    constraints,
                    renderBox.size,
                  );
                }
              });
              
              return const Text('Debug Layout');
            },
          ),
        );
      },
    );
  }
}
```

### Debug Shortcuts:

```dart
class DebugShortcuts {
  static void enableDebugShortcuts(BuildContext context) {
    // Add debug shortcuts for development
    debugPrint('Debug shortcuts enabled');
    
    // Example: Triple tap to open debug menu
    // Implementation would go here
  }
  
  static void showDebugMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Show Performance Overlay'),
              onTap: () {
                // Toggle performance overlay
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Clear App Data'),
              onTap: () {
                // Clear app data
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Export Logs'),
              onTap: () {
                // Export logs
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Summary

- **Flutter DevTools**: Comprehensive debugging suite with inspector, performance, memory, and network tools
- **Logging**: Use structured logging with libraries like logger for better debugging
- **Error Handling**: Implement try-catch blocks, custom exceptions, and error boundaries
- **Breakpoints**: Set conditional breakpoints and use stepping for detailed debugging
- **Performance Debugging**: Use performance overlays and profiling to identify bottlenecks
- **Crash Reporting**: Integrate Firebase Crashlytics or Sentry for production error tracking
- **Troubleshooting**: Use systematic approaches to identify and fix common issues

Effective debugging combines multiple techniques and tools to quickly identify and resolve issues.

## Debugger

### Setting Breakpoints:

1. Click on line number in VS Code
2. Code will pause when reached
3. Use Debug Console to inspect variables

### Breakpoint Commands:

```dart
// Conditional breakpoint
// Set condition: count > 10

// Logpoint (log without stopping)
// Add message: "Count: {count}"
```

### Stepping:

- **Step Over** (F10): Execute current line
- **Step Into** (F11): Enter function
- **Step Out** (Shift+F11): Exit function
- **Continue** (F5): Resume execution

### Inspect Variables:

```dart
void myFunction(String name, int age) {
  // Set breakpoint here
  print("name: $name, age: $age");
}

// In debugger, hover over variables or use:
// > name          (returns value)
// > age           (returns value)
// > this          (shows all members)
```

---

## Error Handling & Stack Traces

### Try-Catch:

```dart
try {
  riskyOperation();
} catch (e, stackTrace) {
  print('Error: $e');
  print('Stack trace: $stackTrace');
  
  // Log for analytics
  logError(e, stackTrace);
}
```

### Global Error Handler:

```dart
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('$details');
    
    // Send to error tracking service
    reportError(details.exception, details.stack);
  };

  runApp(const MyApp());
}
```

### Pyramid Testing:

```dart
// Bottom: Unit tests (quick, specific)
// Middle: Widget tests (component level)
// Top: Integration tests (end-to-end)

// Test pyramid:
// - 70% unit tests
// - 20% widget tests
// - 10% integration tests
```

---

## Performance Debugging

### Hot Reload Issues:

```
If hot reload fails:
1. Check for syntax errors
2. Resave the file
3. Use hot restart if needed
4. Restart from command line

flutter run -h  (see options)
```

### Frame Rate Problems:

- Enable Performance Overlay: `showPerformanceOverlay: true`
- Check for:
  - Expensive build methods
  - Rebuilding entire widget tree
  - Large lists without .builder
  - Animations that impact frame rate

### Memory Issues:

- Use DevTools Memory tab
- Check for:
  - Memory leaks (subscriptions not cancelled)
  - Large data structures
  - Unclosed streams
  - Missing dispose() calls

---

## Widget Inspection

### Inspector Tab in DevTools:

1. Click widget in app
2. See widget tree
3. View properties and state
4. Highlight in widget tree

### Debug Paint:

```dart
MaterialApp(
  debugShowMaterialGrid: true,  // Show grid
  home: Scaffold(
    body: Container(
      color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text("Debug"),
      ),
    ),
  ),
)
```

### Check Widgets:

```dart
// Get widget info
print(widget.runtimeType);
print(widget.toString());

// Check if in widget tree
if (context.findRenderObject() != null) {
  print("Widget is mounted");
}
```

---

## Network Debugging

### Inspect Network Requests:

1. Open DevTools Network tab
2. Make API requests
3. See full request/response
4. Check headers and status

### Dio Logging:

```dart
final dio = Dio();

dio.interceptors.add(
  LoggingInterceptor(),
);

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE: ${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR: ${err.error}');
    handler.next(err);
  }
}
```

---

## Common Issues & Solutions

### Issue: Widget not updating

**Cause:** Not calling setState()
**Solution:** Ensure setState() is called after state change

### Issue: Infinite loop

**Cause:** setState() in build method
**Solution:** Move setState() caller outside build()

### Issue: Memory leak

**Cause:** Subscriptions not cancelled
**Solution:** Always cancel in dispose()

```dart
@override
void dispose() {
  _subscription?.cancel();
  _controller.dispose();
  super.dispose();
}
```

### Issue: UI not responsive

**Cause:** Heavy computation on main thread
**Solution:** Use Isolate for background work

```dart
Future<int> compute() async {
  return await Isolate.run(() {
    return expensiveComputation();
  });
}
```

---

## Profiling

### CPU Profiling:

1. Open DevTools Performance tab
2. Record session
3. View flame chart
4. Identify slow functions

### Memory Profiling:

1. Open DevTools Memory tab
2. Take snapshots
3. Compare allocations
4. Find memory leaks

---

## Remote Debugging

### Debug on Connected Device:

```bash
flutter run -v  # Verbose output

# On error, check:
1. Device is connected
2. USB debugging enabled
3. Correct device selected
```

---

## Best Practices

1. **Use logger instead of print** for production
2. **Attach debugger during development**
3. **Use DevTools regularly**
4. **Check memory usage often**
5. **Profile performance bottlenecks**
6. **Test on real devices**
7. **Monitor error logs**
8. **Use error tracking services**
9. **Keep stack traces organized**
10. **Document known issues**

---

## Summary

- **DevTools**: Comprehensive debugging suite
- **Logging**: Track app behavior
- **Breakpoints**: Pause and inspect
- **Performance**: Monitor frame rates
- **Network**: Debug API calls
- **Memory**: Find memory leaks
- **Error Handling**: Catch and log errors
- Always dispose resources
- Use production error tracking
