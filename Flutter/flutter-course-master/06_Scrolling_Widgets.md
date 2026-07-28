# Flutter Scrolling Widgets

Scrolling widgets are essential for displaying content that exceeds the screen size.

---

## SingleChildScrollView

A simple scrollable widget for a single child.

### Basic Usage:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      Text("Item 1"),
      Text("Item 2"),
      Text("Item 3"),
      // ... many more items
      Text("Item 100"),
    ],
  ),
)
```

### With Scrolling Direction:

```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,  // Horizontal scroll
  // scrollDirection: Axis.vertical,  // Vertical (default)
  child: Row(
    children: [
      Container(width: 200, height: 200, color: Colors.red),
      Container(width: 200, height: 200, color: Colors.blue),
      Container(width: 200, height: 200, color: Colors.green),
    ],
  ),
)
```

### With Physics:

```dart
SingleChildScrollView(
  physics: BouncingScrollPhysics(),  // Bouncy scroll (iOS-like)
  // physics: ClampingScrollPhysics(), // Android-like scroll
  // physics: NeverScrollableScrollPhysics(), // No scroll
  child: Column(children: [...]),
)
```

### Keyboard Handler:

```dart
SingleChildScrollView(
  reverse: true,  // Reverse scroll order
  child: Column(children: [...]),
)
```

### When to Use:

- Small lists (< 50 items)
- Content that rarely changes
- When you don't need item reuse

### Performance Note:

Builds all children at once, so not suitable for large lists.

### Advanced SingleChildScrollView:

```dart
SingleChildScrollView(
  padding: EdgeInsets.all(16),
  primary: true,  // Use primary scroll controller
  restorationId: 'scroll_view',  // For state restoration
  
  // Scroll behavior
  physics: AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  ),
  
  // Scroll position restoration
  controller: ScrollController(),
  
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(
      20,
      (index) => Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Item ${index + 1}'),
        ),
      ),
    ),
  ),
)
```

---

## ListView

A scrollable list of widgets.

### Basic Usage:

```dart
ListView(
  children: [
    ListTile(title: Text("Item 1")),
    ListTile(title: Text("Item 2")),
    ListTile(title: Text("Item 3")),
  ],
)
```

### With Padding:

```dart
ListView(
  padding: EdgeInsets.all(10),
  children: [...],
)
```

### Scrolling Direction:

```dart
ListView(
  scrollDirection: Axis.horizontal,
  children: [
    Container(width: 100, height: 100, color: Colors.red),
    Container(width: 100, height: 100, color: Colors.blue),
    Container(width: 100, height: 100, color: Colors.green),
  ],
)
```

### With Separators:

```dart
ListView.separated(
  itemCount: 10,
  itemBuilder: (context, index) => ListTile(
    title: Text('Item ${index + 1}'),
  ),
  separatorBuilder: (context, index) => Divider(),
)
```

### With Scroll Controller:

```dart
class ScrollableList extends StatefulWidget {
  @override
  _ScrollableListState createState() => _ScrollableListState();
}

class _ScrollableListState extends State<ScrollableList> {
  final ScrollController _controller = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }
  
  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // Reached bottom
      print('Reached bottom');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(
        title: Text('Item ${index + 1}'),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## ListView.builder

Efficiently builds list items on demand.

### Basic Usage:

```dart
ListView.builder(
  itemCount: 1000,  // Number of items
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item ${index + 1}'),
    );
  },
)
```

### With Item Types:

```dart
ListView.builder(
  itemCount: items.length + 1,  // +1 for loading indicator
  itemBuilder: (context, index) {
    if (index == items.length) {
      return Center(child: CircularProgressIndicator());
    }
    
    final item = items[index];
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.subtitle),
    );
  },
)
```

### Performance Optimization:

```dart
ListView.builder(
  // Only build visible items
  itemCount: 10000,
  
  // Cache extent for smoother scrolling
  cacheExtent: 100.0,
  
  // Add keys for stable item identity
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey('item_$index'),
      title: Text('Item ${index + 1}'),
    );
  },
)
```

### With Data Models:

```dart
class Product {
  final String name;
  final double price;
  final String imageUrl;
  
  Product({required this.name, required this.price, required this.imageUrl});
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  
  const ProductList({super.key, required this.products});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () => _addToCart(product),
            ),
          ),
        );
      },
    );
  }
  
  void _addToCart(Product product) {
    // Add to cart logic
  }
}
```

---

## GridView

A scrollable grid of widgets.

### GridView.count:

```dart
GridView.count(
  crossAxisCount: 2,  // Number of columns
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  children: List.generate(
    20,
    (index) => Container(
      color: Colors.blue.shade200,
      child: Center(child: Text('Item $index')),
    ),
  ),
)
```

### GridView.builder:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 1.5,  // width/height ratio
  ),
  itemCount: 100,
  itemBuilder: (context, index) {
    return Container(
      color: Colors.blue.shade200,
      child: Center(child: Text('Item $index')),
    );
  },
)
```

### GridView.extent:

```dart
GridView.extent(
  maxCrossAxisExtent: 150,  // Maximum width per item
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
  children: List.generate(
    20,
    (index) => Container(
      color: Colors.green.shade200,
      child: Center(child: Text('Item $index')),
    ),
  ),
)
```

### Responsive Grid:

```dart
class ResponsiveGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: 20,
          itemBuilder: (context, index) => Card(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue.shade100,
                    child: Center(child: Text('Item $index')),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Description $index'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

---

## CustomScrollView

A scrollable view that creates custom scroll effects with slivers.

### Basic CustomScrollView:

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text('Custom Scroll View'),
      floating: true,
      pinned: true,
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Item $index')),
        childCount: 50,
      ),
    ),
  ],
)
```

### Sliver Types:

```dart
CustomScrollView(
  slivers: [
    // Collapsing app bar
    SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Collapsing Header'),
        background: Image.network(
          'https://example.com/header.jpg',
          fit: BoxFit.cover,
        ),
      ),
      pinned: true,
    ),
    
    // Grid section
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          color: Colors.blue.shade200,
          child: Center(child: Text('Grid $index')),
        ),
        childCount: 10,
      ),
    ),
    
    // List section
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('List Item $index')),
        childCount: 20,
      ),
    ),
    
    // Fill remaining space
    SliverFillRemaining(
      child: Center(
        child: Text('End of content'),
      ),
    ),
  ],
)
```

### SliverPersistentHeader:

```dart
class StickyHeader extends SliverPersistentHeaderDelegate {
  final String title;
  
  StickyHeader({required this.title});
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  @override
  double get maxExtent => 60;
  
  @override
  double get minExtent => 60;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is StickyHeader && oldDelegate.title != title;
  }
}

// Usage
SliverPersistentHeader(delegate: StickyHeader(title: 'Section 1'))
```

### NestedScrollView:

```dart
NestedScrollView(
  headerSliverBuilder: (context, innerBoxIsScrolled) {
    return [
      SliverAppBar(
        title: Text('Nested Scroll'),
        pinned: true,
        floating: true,
        forceElevated: innerBoxIsScrolled,
      ),
    ];
  },
  body: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, index) => ListTile(
      title: Text('Item $index'),
    ),
  ),
)
```

---

## ScrollController

Controls scroll position and behavior.

### Basic Scroll Controller:

```dart
class ScrollableWidget extends StatefulWidget {
  @override
  _ScrollableWidgetState createState() => _ScrollableWidgetState();
}

class _ScrollableWidgetState extends State<ScrollableWidget> {
  final ScrollController _controller = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }
  
  void _scrollListener() {
    // Handle scroll events
    print('Scroll position: ${_controller.position.pixels}');
    
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // Load more data
      _loadMore();
    }
  }
  
  void _loadMore() {
    // Load more data logic
  }
  
  void _scrollToTop() {
    _controller.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _controller,
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(
          title: Text('Item $index'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Scroll Position Restoration:

```dart
class RestorableScrollController extends StatefulWidget {
  @override
  _RestorableScrollControllerState createState() => _RestorableScrollControllerState();
}

class _RestorableScrollControllerState extends State<RestorableScrollController>
    with RestorationMixin {
  
  final RestorableScrollController _scrollController = RestorableScrollController();
  
  @override
  String get restorationId => 'scroll_controller';
  
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_scrollController, 'scroll_controller');
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController.value,
      restorationId: 'list_view',
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(
        title: Text('Item $index'),
      ),
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

## ScrollPhysics

Controls scroll behavior and physics.

### Different Physics Types:

```dart
// iOS-style bouncy scroll
BouncingScrollPhysics()

// Android-style clamped scroll
ClampingScrollPhysics()

// Always scrollable, even with small content
AlwaysScrollableScrollPhysics()

// Never scrollable
NeverScrollableScrollPhysics()

// Page-based scrolling
PageScrollPhysics()

// Range-based scrolling
RangeMaintainingScrollPhysics()

// Custom physics
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({super.parent});
  
  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }
  
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Custom physics logic
    return offset * 0.8;  // Slower scroll
  }
}
```

### Combining Physics:

```dart
ListView(
  physics: AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  ),
  children: [...],
)
```

---

## RefreshIndicator

Pull-to-refresh functionality.

### Basic Usage:

```dart
RefreshIndicator(
  onRefresh: () async {
    // Refresh logic
    await Future.delayed(Duration(seconds: 2));
    // Update data
  },
  child: ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index) => ListTile(
      title: Text('Item $index'),
    ),
  ),
)
```

### With Custom Colors:

```dart
RefreshIndicator(
  color: Colors.white,
  backgroundColor: Colors.blue,
  strokeWidth: 3.0,
  displacement: 40.0,  // Distance from top
  
  onRefresh: _refreshData,
  
  child: ListView(...),
)
```

### Advanced Refresh:

```dart
class PullToRefreshList extends StatefulWidget {
  @override
  _PullToRefreshListState createState() => _PullToRefreshListState();
}

class _PullToRefreshListState extends State<PullToRefreshList> {
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  
  Future<void> _refreshData() async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _items = [
        'Refreshed Item 1',
        'Refreshed Item 2',
        'Refreshed Item 3',
        'New Item 4',
      ];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_items[index]),
        ),
      ),
    );
  }
}
```

---

## Scrollbar

Shows scroll position indicator.

### Basic Scrollbar:

```dart
Scrollbar(
  child: ListView.builder(
    itemCount: 100,
    itemBuilder: (context, index) => ListTile(
      title: Text('Item $index'),
    ),
  ),
)
```

### Custom Scrollbar:

```dart
Scrollbar(
  thickness: 8.0,
  radius: Radius.circular(4),
  thumbVisibility: true,  // Always show thumb
  
  child: ListView.builder(
    itemCount: 100,
    itemBuilder: (context, index) => ListTile(
      title: Text('Item $index'),
    ),
  ),
)
```

### With Controller:

```dart
class ScrollbarWithController extends StatefulWidget {
  @override
  _ScrollbarWithControllerState createState() => _ScrollbarWithControllerState();
}

class _ScrollbarWithControllerState extends State<ScrollbarWithController> {
  final ScrollController _controller = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      child: ListView.builder(
        controller: _controller,
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(
          title: Text('Item $index'),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## NotificationListener

Listen to scroll notifications.

### Basic Usage:

```dart
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    if (notification is ScrollStartNotification) {
      print('Scroll started');
    } else if (notification is ScrollUpdateNotification) {
      print('Scroll position: ${notification.metrics.pixels}');
    } else if (notification is ScrollEndNotification) {
      print('Scroll ended');
    }
    return true;
  },
  child: ListView.builder(
    itemCount: 100,
    itemBuilder: (context, index) => ListTile(
      title: Text('Item $index'),
    ),
  ),
)
```

### Hide/Show FAB on Scroll:

```dart
class ScrollAwareFAB extends StatefulWidget {
  @override
  _ScrollAwareFABState createState() => _ScrollAwareFABState();
}

class _ScrollAwareFABState extends State<ScrollAwareFAB> {
  bool _showFAB = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            setState(() {
              _showFAB = notification.scrollDelta! <= 0;
            });
          }
          return true;
        },
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) => ListTile(
            title: Text('Item $index'),
          ),
        ),
      ),
      floatingActionButton: _showFAB
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
```

---

## Performance Optimization

### Item Reuse with ListView.builder:

```dart
// ✅ Good - Reuses items
ListView.builder(
  itemCount: 10000,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item $index'),
      subtitle: Text('Subtitle $index'),
    );
  },
)

// ❌ Bad - Builds all items at once
ListView(
  children: List.generate(
    10000,
    (index) => ListTile(
      title: Text('Item $index'),
      subtitle: Text('Subtitle $index'),
    ),
  ),
)
```

### Cache Extent:

```dart
ListView.builder(
  // Cache items outside viewport for smoother scrolling
  cacheExtent: 500.0,  // Cache 500 pixels worth of items
  
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(
    title: Text('Item $index'),
  ),
)
```

### Const Constructors:

```dart
class StaticListItem extends StatelessWidget {
  final String title;
  
  const StaticListItem({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.star),
      title: Text('Static Title'),  // This should be dynamic
    );
  }
}

// ✅ Correct
class DynamicListItem extends StatelessWidget {
  final String title;
  
  const DynamicListItem({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.star),  // Static parts can be const
      title: Text(title),  // Dynamic parts cannot
    );
  }
}
```

### RepaintBoundary:

```dart
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return RepaintBoundary(
      child: ExpensiveListItem(index: index),
    );
  },
)
```

---

## Advanced Scrolling Patterns

### Infinite Scroll:

```dart
class InfiniteScrollList extends StatefulWidget {
  @override
  _InfiniteScrollListState createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  List<String> _items = List.generate(20, (index) => 'Item $index');
  bool _isLoading = false;
  final ScrollController _controller = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }
  
  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _loadMore();
    }
  }
  
  Future<void> _loadMore() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _items.addAll(
        List.generate(10, (index) => 'Item ${_items.length + index}'),
      );
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListTile(title: Text(_items[index]));
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Sticky Headers:

```dart
class StickyHeaderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: SectionHeader('Section A'),
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: Text('A - Item $index')),
            childCount: 5,
          ),
        ),
        
        SliverPersistentHeader(
          delegate: SectionHeader('Section B'),
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: Text('B - Item $index')),
            childCount: 5,
          ),
        ),
      ],
    );
  }
}

class SectionHeader extends SliverPersistentHeaderDelegate {
  final String title;
  
  SectionHeader(this.title);
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
  
  @override
  double get maxExtent => 60;
  
  @override
  double get minExtent => 60;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
```

### Horizontal Scrolling with PageView:

```dart
PageView(
  controller: PageController(viewportFraction: 0.8),
  children: [
    Card(child: Center(child: Text('Page 1'))),
    Card(child: Center(child: Text('Page 2'))),
    Card(child: Center(child: Text('Page 3'))),
  ],
)
```

---

## Summary

- **SingleChildScrollView**: Simple scrolling for small content
- **ListView**: Basic scrollable lists
- **ListView.builder**: Efficient for large lists with item reuse
- **GridView**: Scrollable grids with various layouts
- **CustomScrollView**: Complex scrollable layouts with slivers
- **ScrollController**: Control scroll position and listen to events
- **ScrollPhysics**: Customize scroll behavior and physics
- **RefreshIndicator**: Pull-to-refresh functionality
- **Scrollbar**: Visual scroll position indicator
- **NotificationListener**: Listen to scroll notifications
- **Performance**: Use builder constructors, cache extent, const widgets
- **Advanced Patterns**: Infinite scroll, sticky headers, page views

Choose the right scrolling widget based on your content size and performance requirements.

## ListView

A scrollable list of widgets.

### Basic Usage:

```dart
ListView(
  children: [
    ListTile(title: Text("Item 1")),
    ListTile(title: Text("Item 2")),
    ListTile(title: Text("Item 3")),
  ],
)
```

### With Padding:

```dart
ListView(
  padding: EdgeInsets.all(10),
  children: [...],
)
```

### Scrolling Direction:

```dart
ListView(
  scrollDirection: Axis.horizontal,
  children: [
    Card(child: Container(width: 200, height: 200, color: Colors.red)),
    Card(child: Container(width: 200, height: 200, color: Colors.blue)),
  ],
)
```

### With Separators:

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index]),
  ),
)
```

### Custom List Tile:

```dart
ListView(
  children: [
    ListTile(
      leading: Icon(Icons.person),
      title: Text("John Doe"),
      subtitle: Text("Developer"),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {},
    ),
  ],
)
```

---

## ListView.builder

Creates a list with on-demand item building (efficient for large lists).

### Basic Usage:

```dart
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text("Item ${index + 1}"),
    );
  },
)
```

### Dynamic List:

```dart
class ItemList extends StatefulWidget {
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<String> items = [...];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            setState(() {
              items.removeAt(index);
            });
          },
        );
      },
    );
  }
}
```

### Separated Builder:

```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index]),
  ),
)
```

### With Load More:

```dart
ListView.builder(
  itemCount: items.length + 1,
  itemBuilder: (context, index) {
    if (index == items.length) {
      return Center(
        child: ElevatedButton(
          onPressed: _loadMore,
          child: Text("Load More"),
        ),
      );
    }
    return ListTile(title: Text(items[index]));
  },
)
```

### With Physics:

```dart
ListView.builder(
  physics: AlwaysScrollableScrollPhysics(),
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index]),
  ),
)
```

---

## GridView

A scrollable grid of widgets.

### GridView.count (Fixed number of columns):

```dart
GridView.count(
  crossAxisCount: 2,  // 2 columns
  children: [
    Card(child: Container(color: Colors.red)),
    Card(child: Container(color: Colors.blue)),
    Card(child: Container(color: Colors.green)),
    Card(child: Container(color: Colors.yellow)),
  ],
)
```

### GridView.extent (Fixed cell size):

```dart
GridView.extent(
  maxCrossAxisExtent: 150,  // Max width per item
  children: [
    Card(child: Container(color: Colors.red)),
    Card(child: Container(color: Colors.blue)),
  ],
)
```

### GridView.builder (Efficient for large lists):

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,  // Space between columns
    mainAxisSpacing: 10,   // Space between rows
  ),
  itemCount: 100,
  itemBuilder: (context, index) {
    return Card(
      child: Container(
        color: Colors.primaries[index % Colors.primaries.length],
        child: Center(child: Text("${index + 1}")),
      ),
    );
  },
)
```

### Responsive GridView:

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
  ),
  itemCount: 12,
  itemBuilder: (context, index) {
    return Card(child: Container(color: Colors.blue));
  },
)
```

### Custom Aspect Ratio:

```dart
GridView.count(
  crossAxisCount: 2,
  childAspectRatio: 1.5,  // Width:Height ratio
  children: [...],
)
```

---

## CustomScrollView (Advanced)

Combines multiple scrolling widget views into one scrollable view.

### Basic Usage with Multiple Lists:

```dart
CustomScrollView(
  slivers: [
    // Sliver AppBar
    SliverAppBar(
      title: Text("Title"),
      expandedHeight: 200,
    ),
    // Sliver List
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text("Item $index")),
        childCount: 20,
      ),
    ),
  ],
)
```

### Sliver Widgets:

```dart
CustomScrollView(
  slivers: [
    // Fixed AppBar
    SliverAppBar(
      title: Text("Explore"),
      pinned: true,  // Stay at top when scrolling
      floating: true,  // Show when scrolling up
    ),
    
    // Section Header
    SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Text("Popular Items", style: TextStyle(fontSize: 18)),
        ]),
      ),
    ),
    
    // Grid View
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Card(child: Container()),
        childCount: 10,
      ),
    ),
    
    // List View
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text("Item $index")),
        childCount: 20,
      ),
    ),
  ],
)
```

### Collapsing Header Example:

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Details"),
        background: Image.network(
          'https://example.com/image.jpg',
          fit: BoxFit.cover,
        ),
      ),
      pinned: true,
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          title: Text("Item ${index + 1}"),
        ),
        childCount: 20,
      ),
    ),
  ],
)
```

### Sliver AppBar Options:

```dart
SliverAppBar(
  title: Text("Title"),
  
  // Collapse behavior
  pinned: true,         // Stay at top
  floating: true,       // Show on scroll up
  snap: true,           // Snap open/close
  
  // Size
  expandedHeight: 250,
  
  // Content
  flexibleSpace: FlexibleSpaceBar(
    title: Text("Flexible Title"),
    background: Container(color: Colors.blue),
  ),
  
  // Actions
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
  
  // Styling
  backgroundColor: Colors.blue,
  elevation: 0,
)
```

---

## Scroll Controller

Control scrolling programmatically.

### Basic Usage:

```dart
class ScrollExample extends StatefulWidget {
  @override
  State<ScrollExample> createState() => _ScrollExampleState();
}

class _ScrollExampleState extends State<ScrollExample> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(
          title: Text("Item $index"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
```

### Listen to Scroll Events:

```dart
@override
void initState() {
  super.initState();
  _scrollController = ScrollController();
  _scrollController.addListener(() {
    print("Scroll position: ${_scrollController.offset}");
    
    // Load more when near bottom
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  });
}
```

---

## Scrolling Behavior

Control scrolling physics and behavior.

### ScrollBehavior:

```dart
class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return BouncingScrollPhysics();  // iOS-like
  }
}

// Apply globally
MaterialApp(
  scrollBehavior: CustomScrollBehavior(),
  home: HomePage(),
)
```

### Local Physics:

```dart
ListView(
  physics: BouncingScrollPhysics(),     // iOS bouncy
  // physics: ClampingScrollPhysics(),  // Android
  // physics: NeverScrollableScrollPhysics(),  // No scroll
  // physics: AlwaysScrollableScrollPhysics(), // Always scroll
  children: [...],
)
```

---

## Summary

- **SingleChildScrollView**: Simple scrolling for single child
- **ListView**: Basic list of items
- **ListView.builder**: Efficient list with item building
- **GridView**: 2D grid of items
- **GridView.builder**: Efficient grid
- **CustomScrollView**: Combine multiple scrolling views
- **ScrollController**: Control scrolling programmatically
- Use `.builder` for large lists (better performance)
- Use `CustomScrollView` for complex layouts
