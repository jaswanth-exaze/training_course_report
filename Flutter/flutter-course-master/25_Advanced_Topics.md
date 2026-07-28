# Flutter Advanced Topics

Advanced concepts for experienced Flutter developers.

---

## Streams and Futures

### Futures

Single async value resolution:

```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded';
}

void main() async {
  // Await
  String data = await fetchData();
  print(data);
  
  // Then chain
  fetchData().then((data) {
    print(data);
  });
  
  // Error handling
  try {
    String data = await fetchData();
  } catch (e) {
    print('Error: $e');
  }
}
```

### Future Combinations:

```dart
// Wait for all
Future<List<T>> Future.wait<T>(Iterable<Future<T>> futures);

final results = await Future.wait([
  fetchUser(),
  fetchPosts(),
  fetchComments(),
]);

// Race (first to complete)
Future<T> Future.any<T>(Iterable<Future<T>> futures);

final first = await Future.any([
  fetchFromServer1(),
  fetchFromServer2(),
]);

// Delay
await Future.delayed(Duration(seconds: 2));

// Chain async operations
Future<String> getUserData() async {
  try {
    final user = await fetchUser();
    final posts = await fetchUserPosts(user.id);
    return '${user.name}: ${posts.length} posts';
  } catch (e) {
    return 'Error: $e';
  }
}
```

### Streams

Multiple async values over time:

```dart
Stream<int> countStream() async* {
  for (int i = 1; i <= 5; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

void main() async {
  await for (int count in countStream()) {
    print('Count: $count');
  }
}
```

### StreamController:

```dart
class DataNotifier {
  final StreamController<String> _controller = StreamController<String>();
  
  Stream<String> get stream => _controller.stream;
  
  void addData(String data) {
    _controller.add(data);
  }
  
  void dispose() {
    _controller.close();
  }
}

void main() {
  final notifier = DataNotifier();
  
  notifier.stream.listen((data) {
    print('Received: $data');
  });
  
  notifier.addData('Hello');
  notifier.addData('World');
  
  notifier.dispose();
}
```

### Stream Operations:

```dart
Stream<int> numbers() async* {
  for (int i = 1; i <= 10; i++) {
    yield i;
  }
}

void main() async {
  // Map
  numbers().map((n) => n * 2).listen(print);
  
  // Filter
  numbers().where((n) => n.isEven).listen(print);
  
  // Take
  numbers().take(3).listen(print);  // 1, 2, 3
  
  // Skip
  numbers().skip(2).listen(print);  // 3, 4, 5, ...
  
  // Reduce
  int sum = await numbers().reduce((a, b) => a + b);
  print('Sum: $sum');
  
  // Fold (with initial value)
  int product = await numbers().fold(1, (a, b) => a * b);
}
```

### BroadcastStream:

```dart
Stream<int> countStream() async* {
  for (int i = 1; i <= 3; i++) {
    yield i;
    await Future.delayed(Duration(milliseconds: 100));
  }
}

void main() async {
  final broadcast = countStream().asBroadcastStream();
  
  // Multiple listeners
  broadcast.listen((n) => print('Listener 1: $n'));
  broadcast.listen((n) => print('Listener 2: $n'));
}
```

---

## Isolates

Parallel processing in separate threads.

### Basic Isolate:

```dart
import 'dart:isolate';

int expensiveComputation() {
  int sum = 0;
  for (int i = 0; i < 1000000000; i++) {
    sum += i;
  }
  return sum;
}

void isolateEntry(SendPort sendPort) {
  final result = expensiveComputation();
  sendPort.send(result);
}

void main() async {
  // Create isolate
  final receivePort = ReceivePort();
  await Isolate.spawn(isolateEntry, receivePort.sendPort);
  
  // Get result
  final result = await receivePort.first;
  print('Result: $result');
}
```

### With Compute (Simpler):

```dart
import 'package:flutter/foundation.dart';

int heavyComputation(int value) {
  int sum = 0;
  for (int i = 0; i < value; i++) {
    sum += i;
  }
  return sum;
}

void main() async {
  final result = await compute(heavyComputation, 1000000000);
  print('Result: $result');
}
```

### Isolate Communication:

```dart
class IsolateService {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  
  Future<void> start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntry, _receivePort!.sendPort);
    
    _sendPort = await _receivePort!.first;
  }
  
  Future<int> compute(int value) async {
    final response = ReceivePort();
    _sendPort?.send({
      'value': value,
      'sendPort': response.sendPort,
    });
    
    return await response.first;
  }
  
  void dispose() {
    _isolate?.kill();
    _receivePort?.close();
  }
  
  static void _isolateEntry(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) {
      final value = message['value'] as int;
      final response = message['sendPort'] as SendPort;
      
      final result = expensiveComputation(value);
      response.send(result);
    });
  }
}
```

---

## Background Tasks

### WorkManager:

```yaml
dependencies:
  workmanager: ^0.5.0
```

**Android Setup (AndroidManifest.xml):**

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

**Implementation:**

```dart
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('Background task: $task');
    
    // Do background work
    await Future.delayed(Duration(seconds: 2));
    
    return Future.value(true);
  });
}

void main() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // One-time task
              Workmanager().registerOneOffTask(
                'unique-id',
                'simpleTask',
                inputData: {'param': 'value'},
              );
              
              // Periodic task (minimum 15 min)
              Workmanager().registerPeriodicTask(
                'periodic-id',
                'periodicTask',
                frequency: Duration(hours: 1),
              );
            },
            child: Text('Schedule Task'),
          ),
        ),
      ),
    );
  }
}
```

---

## Advanced State Management

### StateNotifier with Riverpod:

```yaml
dependencies:
  riverpod: ^2.0.0
  flutter_riverpod: ^2.0.0
```

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  
  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Scaffold(
      body: Column(
        children: [
          Text('Count: $count'),
          ElevatedButton(
            onPressed: () => ref.read(counterProvider.notifier).increment(),
            child: Text('Increment'),
          ),
        ],
      ),
    );
  }
}
```

---

## Code Generation

### Build Runner:

```yaml
dev_dependencies:
  build_runner: ^2.3.0
  json_serializable: ^6.5.0
```

### Serialization:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

**Generate:**

```bash
flutter pub run build_runner build
flutter pub run build_runner watch  # Watch for changes
```

---

## Platform Channels (Advanced)

### Custom Platform Integration:

**iOS (Swift):**

```swift
import UIKit

class GeneratedPluginRegistrant { }

func customMethod(arguments: [String: Any]) -> String {
  return "iOS response"
}
```

**Android (Kotlin):**

```kotlin
package com.example.app

import android.os.Handler
import android.os.Looper

class MainActivity : FlutterActivity() {
  private val CHANNEL = "com.example.app/platform"
  
  fun setupChannel() {
    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
      .setMethodCallHandler { call, result ->
        if (call.method == "getInfo") {
          result("Android info")
        }
      }
  }
}
```

**Dart:**

```dart
const platform = MethodChannel('com.example.app/platform');

Future<String> getInfo() async {
  try {
    final String result = await platform.invokeMethod('getInfo');
    return result;
  } catch (e) {
    return 'Failed: $e';
  }
}
```

---

## Custom Rendering

### CustomPaint:

```dart
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    
    // Draw circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50,
      paint,
    );
    
    // Draw line
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MyCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(200, 200),
    );
  }
}
```

---

## Performance Optimization (Advanced)

### Memory Profiling:

1. Open DevTools Memory tab
2. Record allocation profile
3. Identify memory leaks
4. Optimize large allocations

### Frame Rate Analysis:

```dart
// Check frame time
import 'dart:developer' as developer;

void monitorPerformance() {
  developer.Timeline.startSync('Operation');
  
  // Do work
  
  developer.Timeline.finishSync();
}
```

### Cache Optimization:

```dart
class CachedDataProvider extends StateNotifier<AsyncValue<Data>> {
  final Ref ref;
  
  CachedDataProvider(this.ref) : super(const AsyncValue.loading()) {
    _load();
  }
  
  Future<void> _load() async {
    try {
      final data = await ref.read(apiProvider).fetchData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
```

---

## Summary

- **Futures**: Single async values
- **Streams**: Multiple async values
- **Isolates**: Parallel processing
- **Background Tasks**: Long-running work
- **State Management**: Advanced patterns
- **Code Generation**: Automated boilerplate
- **Platform Channels**: Native integration
- **Custom Rendering**: Complex UI
- **Performance**: Profiling and optimization
- **Advanced patterns** require deep understanding
- Measure before optimizing
- Test thoroughly
