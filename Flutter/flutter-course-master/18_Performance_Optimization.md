# Flutter Performance Optimization

Building fast, responsive Flutter applications.

---

## Const Widgets

Using `const` prevents unnecessary rebuilds.

### Basic Usage:

```dart
// Without const - rebuilds every time
Widget build(BuildContext context) {
  return Text("Hello");
}

// With const - built once
Widget build(BuildContext context) {
  return const Text("Hello");
}
```

### In Collections:

```dart
// Good
children: const [
  Text("Item 1"),
  Text("Item 2"),
  Text("Item 3"),
]

// Better with entire widget
const myList = [
  Text("Item 1"),
  Text("Item 2"),
];

Column(children: myList)
```

### Widget Performance:

```dart
class OptimizedWidget extends StatelessWidget {
  final String title;

  const OptimizedWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use const where possible
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text("Static content"),
      ),
    );
  }
}
```

### Advanced Const Usage:

```dart
class ConstWidgetExamples extends StatelessWidget {
  // Static const data
  static const List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  static const Map<String, Color> _colors = {
    'primary': Colors.blue,
    'secondary': Colors.green,
    'accent': Colors.orange,
  };
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Const widgets in loops
        for (final item in _items)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text("Static Card"),
            ),
          ),
        
        // Const with conditional rendering
        if (true) const Text("Always shown"),
        
        // Const in builders
        ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return const ListTile(
              leading: Icon(Icons.star),
              title: Text("Static Title"),
            );
          },
        ),
      ],
    );
  }
}
```

---

## Rebuild Optimization

### RepaintBoundary:

Marks a boundary that only repaints when its contents change.

```dart
RepaintBoundary(
  child: AnimatedContainer(
    duration: Duration(seconds: 1),
    color: Colors.blue,
  ),
)
```

### Preventing Unnecessary Rebuilds:

```dart
class ParentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(),  // Only built once
        ElevatedButton(
          onPressed: () {
            // This rebuild doesn't affect ExpensiveWidget
          },
          child: const Text("Button"),
        ),
      ],
    );
  }
}

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Expensive computation here
    return Container(
      height: 200,
      color: Colors.blue,
      child: const Center(
        child: Text("Expensive Widget"),
      ),
    );
  }
}
```

### ValueNotifier for Selective Updates:

```dart
class SelectiveUpdateWidget extends StatefulWidget {
  @override
  State<SelectiveUpdateWidget> createState() => _SelectiveUpdateWidgetState();
}

class _SelectiveUpdateWidgetState extends State<SelectiveUpdateWidget> {
  final ValueNotifier<int> _counter1 = ValueNotifier(0);
  final ValueNotifier<int> _counter2 = ValueNotifier(0);
  
  @override
  void dispose() {
    _counter1.dispose();
    _counter2.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _counter1,
          builder: (context, value, child) {
            return Text('Counter 1: $value');
          },
        ),
        
        ValueListenableBuilder<int>(
          valueListenable: _counter2,
          builder: (context, value, child) {
            return Text('Counter 2: $value');
          },
        ),
        
        ElevatedButton(
          onPressed: () => _counter1.value++,
          child: Text('Increment Counter 1'),
        ),
        
        ElevatedButton(
          onPressed: () => _counter2.value++,
          child: Text('Increment Counter 2'),
        ),
      ],
    );
  }
}
```

### Provider with Selector:

```dart
class CounterModel extends ChangeNotifier {
  int _count1 = 0;
  int _count2 = 0;
  
  int get count1 => _count1;
  int get count2 => _count2;
  
  void increment1() {
    _count1++;
    notifyListeners();
  }
  
  void increment2() {
    _count2++;
    notifyListeners();
  }
}

class OptimizedProviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only rebuilds when count1 changes
        Selector<CounterModel, int>(
          selector: (context, model) => model.count1,
          builder: (context, count, child) {
            return Text('Counter 1: $count');
          },
        ),
        
        // Only rebuilds when count2 changes
        Selector<CounterModel, int>(
          selector: (context, model) => model.count2,
          builder: (context, count, child) {
            return Text('Counter 2: $count');
          },
        ),
        
        Consumer<CounterModel>(
          builder: (context, model, child) {
            return Row(
              children: [
                ElevatedButton(
                  onPressed: model.increment1,
                  child: Text('Increment 1'),
                ),
                ElevatedButton(
                  onPressed: model.increment2,
                  child: Text('Increment 2'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
```

---

## List Performance

Optimizing large lists and scrolling performance.

### ListView.builder vs ListView:

```dart
// Inefficient - builds all items at once
ListView(
  children: List.generate(1000, (index) {
    return ListTile(title: Text('Item $index'));
  }),
)

// Efficient - builds items on demand
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
)
```

### Advanced List Optimization:

```dart
class OptimizedListView extends StatefulWidget {
  @override
  State<OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _items = List.generate(10000, (i) => 'Item $i');
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length,
      
      // Add cache extent for smoother scrolling
      cacheExtent: 1000,
      
      // Use itemExtent for fixed height items
      itemExtent: 60,
      
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_items[index]),
          
          // Use const widgets where possible
          leading: const Icon(Icons.star),
          
          // Avoid expensive operations in itemBuilder
          subtitle: Text('Index: $index'),
        );
      },
    );
  }
}
```

### Virtualized Lists with Slivers:

```dart
class SliverListExample extends StatelessWidget {
  final List<String> items = List.generate(1000, (i) => 'Item $i');
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Optimized List'),
          floating: true,
        ),
        
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                title: Text(items[index]),
              );
            },
            childCount: items.length,
          ),
        ),
      ],
    );
  }
}
```

### Infinite Scrolling:

```dart
class InfiniteScrollList extends StatefulWidget {
  @override
  State<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _items = [];
  bool _isLoading = false;
  int _page = 0;
  
  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }
  
  Future<void> _loadMoreItems() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    final newItems = List.generate(20, (i) => 'Item ${_page * 20 + i}');
    
    setState(() {
      _items.addAll(newItems);
      _page++;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListTile(title: Text(_items[index]));
      },
    );
  }
}
```

---

## Image Optimization

Efficient image loading and display.

### Cached Network Images:

```dart
import 'package:cached_network_image/cached_network_image.dart';

class OptimizedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  
  const OptimizedImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      
      // Placeholder while loading
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Center(child: CircularProgressIndicator()),
      ),
      
      // Error widget
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Icon(Icons.error),
      ),
      
      // Fade in animation
      fadeInDuration: Duration(milliseconds: 300),
      
      // Memory optimization
      memCacheWidth: width.toInt(),
      memCacheHeight: height.toInt(),
    );
  }
}
```

### Image Memory Management:

```dart
class ImageMemoryManager {
  static final Map<String, Uint8List> _imageCache = {};
  
  static Future<Uint8List?> loadImage(String url) async {
    if (_imageCache.containsKey(url)) {
      return _imageCache[url];
    }
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        _imageCache[url] = bytes;
        return bytes;
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    
    return null;
  }
  
  static void clearCache() {
    _imageCache.clear();
  }
  
  static int get cacheSize => _imageCache.length;
}

class MemoryOptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  
  const MemoryOptimizedImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });
  
  @override
  State<MemoryOptimizedImage> createState() => _MemoryOptimizedImageState();
}

class _MemoryOptimizedImageState extends State<MemoryOptimizedImage> {
  Uint8List? _imageData;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadImage();
  }
  
  Future<void> _loadImage() async {
    final data = await ImageMemoryManager.loadImage(widget.imageUrl);
    if (mounted) {
      setState(() {
        _imageData = data;
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_imageData == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: Icon(Icons.error),
      );
    }
    
    return Image.memory(
      _imageData!,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
    );
  }
}
```

### Image Resizing and Compression:

```dart
class ImageOptimizer {
  static Future<Uint8List?> compressImage(Uint8List imageBytes, {int quality = 80}) async {
    try {
      final ui.Image image = await decodeImageFromList(imageBytes);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }
  
  static Future<Uint8List?> resizeImage(Uint8List imageBytes, int width, int height) async {
    try {
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      
      final ui.Image resizedImage = await _resizeImage(frameInfo.image, width, height);
      final ByteData? byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }
  
  static Future<ui.Image> _resizeImage(ui.Image image, int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint(),
    );
    
    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }
}
```

---

## Memory Management

Preventing memory leaks and optimizing memory usage.

### Object Disposal:

```dart
class MemoryManagedWidget extends StatefulWidget {
  @override
  State<MemoryManagedWidget> createState() => _MemoryManagedWidgetState();
}

class _MemoryManagedWidgetState extends State<MemoryManagedWidget> {
  Timer? _timer;
  StreamSubscription? _subscription;
  AnimationController? _animationController;
  
  @override
  void initState() {
    super.initState();
    
    // Timer management
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Do something
    });
    
    // Stream subscription
    _subscription = someStream.listen((data) {
      // Handle data
    });
    
    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }
  
  @override
  void dispose() {
    // Clean up all resources
    _timer?.cancel();
    _subscription?.cancel();
    _animationController?.dispose();
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Weak References and Callbacks:

```dart
class WeakReferenceManager {
  static final Expando<Function> _callbacks = Expando();
  
  static void registerCallback(Object key, Function callback) {
    _callbacks[key] = callback;
  }
  
  static Function? getCallback(Object key) {
    return _callbacks[key];
  }
  
  static void removeCallback(Object key) {
    _callbacks[key] = null;
  }
}

class CallbackSafeWidget extends StatefulWidget {
  @override
  State<CallbackSafeWidget> createState() => _CallbackSafeWidgetState();
}

class _CallbackSafeWidgetState extends State<CallbackSafeWidget> {
  late final Object _callbackKey;
  
  @override
  void initState() {
    super.initState();
    _callbackKey = Object();
    
    WeakReferenceManager.registerCallback(_callbackKey, () {
      if (mounted) {
        setState(() {
          // Safe to update state
        });
      }
    });
  }
  
  @override
  void dispose() {
    WeakReferenceManager.removeCallback(_callbackKey);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Memory Monitoring:

```dart
class MemoryMonitor {
  static void printMemoryUsage() {
    // This is a simplified example
    // In a real app, you'd use platform-specific APIs
    print('Memory monitoring not available on this platform');
  }
  
  static Future<void> forceGC() async {
    // Force garbage collection (debug only)
    print('Forcing garbage collection...');
  }
}

class MemoryAwareWidget extends StatefulWidget {
  @override
  State<MemoryAwareWidget> createState() => _MemoryAwareWidgetState();
}

class _MemoryAwareWidgetState extends State<MemoryAwareWidget>
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
      case AppLifecycleState.inactive:
        // Clear caches, stop timers
        break;
      case AppLifecycleState.resumed:
        // Restore state if needed
        break;
      default:
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: MemoryMonitor.printMemoryUsage,
      child: Text('Check Memory'),
    );
  }
}
```

---

## Profiling

Using Flutter DevTools to analyze performance.

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

### Custom Performance Metrics:

```dart
class PerformanceMetrics {
  static final Stopwatch _frameStopwatch = Stopwatch();
  static int _frameCount = 0;
  static double _fps = 0.0;
  
  static void startFrame() {
    _frameStopwatch.start();
  }
  
  static void endFrame() {
    _frameCount++;
    
    if (_frameStopwatch.elapsedMilliseconds >= 1000) {
      _fps = _frameCount / (_frameStopwatch.elapsedMilliseconds / 1000);
      _frameCount = 0;
      _frameStopwatch.reset();
    }
  }
  
  static double get fps => _fps;
  
  static String getFormattedMetrics() {
    return 'FPS: ${_fps.toStringAsFixed(1)}';
  }
}

class PerformanceMonitoredWidget extends StatefulWidget {
  final Widget child;
  
  const PerformanceMonitoredWidget({super.key, required this.child});
  
  @override
  State<PerformanceMonitoredWidget> createState() => _PerformanceMonitoredWidgetState();
}

class _PerformanceMonitoredWidgetState extends State<PerformanceMonitoredWidget>
    with SingleTickerProviderStateMixin {
  
  late Ticker _ticker;
  
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      PerformanceMetrics.endFrame();
      PerformanceMetrics.startFrame();
    });
    _ticker.start();
  }
  
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.black.withOpacity(0.7),
            child: Text(
              PerformanceMetrics.getFormattedMetrics(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## Debugging Performance Issues

Identifying and fixing performance problems.

### Performance Debugging Tools:

```dart
class PerformanceDebugger {
  static void measureExecutionTime(String label, Function function) {
    final stopwatch = Stopwatch()..start();
    
    function();
    
    stopwatch.stop();
    print('$label took ${stopwatch.elapsedMilliseconds}ms');
  }
  
  static Future<void> measureAsyncExecutionTime(String label, Future<void> Function() function) async {
    final stopwatch = Stopwatch()..start();
    
    await function();
    
    stopwatch.stop();
    print('$label took ${stopwatch.elapsedMilliseconds}ms');
  }
  
  static Widget debugBuildTime(Widget child, String label) {
    return _BuildTimeDebugger(child: child, label: label);
  }
}

class _BuildTimeDebugger extends StatefulWidget {
  final Widget child;
  final String label;
  
  const _BuildTimeDebugger({required this.child, required this.label});
  
  @override
  State<_BuildTimeDebugger> createState() => _BuildTimeDebuggerState();
}

class _BuildTimeDebuggerState extends State<_BuildTimeDebugger> {
  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    final result = widget.child;
    
    stopwatch.stop();
    print('${widget.label} build took ${stopwatch.elapsedMilliseconds}ms');
    
    return result;
  }
}

// Usage
class DebugExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerformanceDebugger.debugBuildTime(
      Column(
        children: [
          ExpensiveWidget(),
          AnotherExpensiveWidget(),
        ],
      ),
      'Main Column',
    );
  }
}
```

### Performance Best Practices:

```dart
class PerformanceBestPractices {
  // 1. Avoid expensive operations in build()
  static Widget optimizedListItem(String title, String subtitle) {
    return ListTile(
      title: Text(title), // Static text
      subtitle: Text(subtitle), // Static text
      leading: const Icon(Icons.star), // Const widget
    );
  }
  
  // 2. Use keys appropriately
  static Widget keyedWidget(int id, String data) {
    return Container(
      key: ValueKey(id), // Use ValueKey for dynamic content
      child: Text(data),
    );
  }
  
  // 3. Debounce expensive operations
  static Function debounce(Function func, Duration delay) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => func());
    };
  }
  
  // 4. Use compute for heavy computations
  static Future<List<String>> processData(List<String> data) async {
    return await compute(_processDataInIsolate, data);
  }
  
  static List<String> _processDataInIsolate(List<String> data) {
    // Heavy processing in separate isolate
    return data.map((item) => item.toUpperCase()).toList();
  }
  
  // 5. Cache expensive computations
  static final Map<String, dynamic> _cache = {};
  
  static dynamic cachedComputation(String key, dynamic Function() computation) {
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    
    final result = computation();
    _cache[key] = result;
    return result;
  }
}
```

### Performance Testing:

```dart
class PerformanceTest {
  static Future<void> runPerformanceTests() async {
    print('Running performance tests...');
    
    // Test build time
    await PerformanceDebugger.measureAsyncExecutionTime(
      'ListView build with 1000 items',
      () async {
        final items = List.generate(1000, (i) => 'Item $i');
        final listView = ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(title: Text(items[index])),
        );
        // Force build
        await Future.delayed(Duration.zero);
      },
    );
    
    // Test memory usage
    print('Memory usage: ${PerformanceTest.getMemoryUsage()}');
  }
  
  static String getMemoryUsage() {
    // Platform-specific memory monitoring
    return 'Memory monitoring not implemented for this platform';
  }
  
  static void benchmarkFunction(String name, Function function, {int iterations = 100}) {
    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < iterations; i++) {
      function();
    }
    
    stopwatch.stop();
    final averageTime = stopwatch.elapsedMilliseconds / iterations;
    print('$name: ${averageTime.toStringAsFixed(2)}ms per iteration');
  }
}
```

---

## Summary

- **Const Widgets**: Prevent unnecessary rebuilds by using const constructors
- **Rebuild Optimization**: Use RepaintBoundary, ValueNotifier, and Provider selectors
- **List Performance**: Use ListView.builder, cacheExtent, and itemExtent for large lists
- **Image Optimization**: Cache images, resize appropriately, and manage memory
- **Memory Management**: Properly dispose resources and use weak references
- **Profiling**: Use performance overlays and custom metrics
- **Debugging**: Measure execution times and identify bottlenecks

Performance optimization is an ongoing process that requires monitoring and profiling.

### GridView.builder:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: 200,
  itemBuilder: (context, index) {
    return Card(child: Text("Item $index"));
  },
)
```

### Caching List Items:

```dart
class CachedListView extends StatefulWidget {
  @override
  State<CachedListView> createState() => _CachedListViewState();
}

class _CachedListViewState extends State<CachedListView> {
  late ScrollController _scrollController;
  List<Widget> _cache = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 1000,
      itemBuilder: (context, index) {
        // Cache built widgets
        if (index >= _cache.length) {
          _cache.add(
            ListTile(
              title: Text("Item $index"),
            ),
          );
        }
        return _cache[index];
      },
    );
  }
}
```

---

## Image Optimization

### Lazy Load Images:

```dart
class LazyImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return LazyImage(
          url: "https://example.com/image_$index.jpg",
        );
      },
    );
  }
}

class LazyImage extends StatefulWidget {
  final String url;

  const LazyImage({required this.url});

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage> {
  late Future<ImageProvider> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage();
  }

  Future<ImageProvider> _loadImage() async {
    return NetworkImage(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image(image: snapshot.data!);
        }
        return Container(color: Colors.grey);
      },
    );
  }
}
```

### Image Caching:

```dart
// Configure cache size
imageCache.maximumSize = 100;  // Number of images
imageCache.maximumSizeBytes = 50 * 1024 * 1024;  // 50 MB

// Cached network image
CachedNetworkImage(
  imageUrl: "https://example.com/image.png",
  cacheManager: CacheManager(
    Config(
      'custom_cache',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  ),
)
```

---

## Memory Management

### Dispose Resources:

```dart
class ResourcefulWidget extends StatefulWidget {
  @override
  State<ResourcefulWidget> createState() => _ResourcefulWidgetState();
}

class _ResourcefulWidgetState extends State<ResourcefulWidget> {
  late AnimationController _controller;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _subscription = myStream.listen((event) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Avoid Memory Leaks:

```dart
// Bad - holds reference
class BadListener {
  StreamSubscription? _subscription;

  void start(Stream stream) {
    _subscription = stream.listen((_) {});
  }
  
  // Forgot to cancel!
}

// Good - proper cleanup
class GoodListener {
  StreamSubscription? _subscription;

  void start(Stream stream) {
    _subscription = stream.listen((_) {});
  }

  void stop() {
    _subscription?.cancel();
  }
}
```

---

## Code Splitting

### Lazy Loading Routes:

```dart
router.define(
  '/details',
  page: () => const DetailsPage(),
  // Loaded only when navigated to
);
```

---

## Profiling

### Use DevTools:

```
flutter pub global activate devtools
flutter pub global run devtools
```

### Performance Overlay:

```dart
MaterialApp(
  showPerformanceOverlay: true,  // Shows FPS
  home: HomePage(),
)
```

### Frame Timing:

```dart
// Find slow frames
Timeline.startSync('ExpensiveOperation');
// ... do work
Timeline.finishSync();
```

---

## Best Practices

1. **Use `const` everywhere possible**
2. **Use `.builder` for scrollable lists**
3. **Dispose of resources in `dispose()`**
4. **Avoid building expensive widgets repeatedly**
5. **Cache images and data**
6. **Profile your app regularly**
7. **Use RepaintBoundary for animations**
8. **Optimize image sizes**
9. **Minimize widget tree depth**
10. **Use Provider or BLoC for state**

---

## Summary

- **Const Widgets**: Prevent unnecessary rebuilds
- **Rebuild Optimization**: Use RepaintBoundary
- **List Performance**: Use ListView.builder
- **Image Optimization**: Lazy load and cache
- **Memory Management**: Dispose of resources
- **Profiling**: Use DevTools to find bottlenecks
- Measure before optimizing
- Focus on user perception
