# Flutter Advanced Layout

This section covers complex layout patterns and responsive design techniques.

---

## Stack

A widget that positions children on top of each other.

### Basic Usage:

```dart
Stack(
  children: [
    Container(
      width: 200,
      height: 200,
      color: Colors.red,
    ),
    Container(
      width: 150,
      height: 150,
      color: Colors.blue,
    ),
    Container(
      width: 100,
      height: 100,
      color: Colors.green,
    ),
  ],
)
```

The widgets are stacked in order - first child is at the bottom, last child is on top.

### Stack Properties:

```dart
Stack(
  alignment: Alignment.center,        // Default: top-left
  textDirection: TextDirection.ltr,
  fit: StackFit.loose,               // loose, expand, passthrough
  clipBehavior: Clip.hardEdge,       // none, hardEdge, antiAlias, antiAliasWithSaveLayer
  
  children: [
    // Children here
  ],
)
```

### Stack with Positioning:

```dart
Stack(
  children: [
    Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    ),
    Positioned(
      top: 20,
      left: 20,
      child: Container(width: 50, height: 50, color: Colors.red),
    ),
  ],
)
```

### Use Cases:

```dart
// Profile card with overlay
Stack(
  children: [
    Image.network('https://example.com/cover.jpg'),
    Positioned(
      bottom: 10,
      left: 10,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
        ),
      ),
    ),
  ],
)
```

### Floating Action Button Overlay:

```dart
Stack(
  children: [
    // Main content
    ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    ),
    
    // FAB positioned at bottom-right
    Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    ),
  ],
)
```

### Badge Overlay:

```dart
Stack(
  children: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {},
    ),
    Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '3',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
)
```

---

## Positioned

Places a child at a specific position within a Stack.

### Basic Usage:

```dart
Positioned(
  top: 10,
  left: 10,
  child: Container(width: 50, height: 50, color: Colors.blue),
)
```

### Complete Positioning:

```dart
Positioned(
  top: 20,        // Distance from top
  bottom: 20,     // Distance from bottom
  left: 20,       // Distance from left
  right: 20,      // Distance from right
  width: 100,     // Explicit width
  height: 100,    // Explicit height
  
  child: Container(color: Colors.blue),
)
```

### Positioning Strategies:

```dart
// Top-left corner
Positioned(
  top: 0,
  left: 0,
  child: Text('Top Left'),
)

// Center horizontally, specific top
Positioned(
  top: 50,
  left: 0,
  right: 0,
  child: Center(child: Text('Centered')),
)

// Full width, specific height from bottom
Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  height: 60,
  child: Container(color: Colors.black),
)
```

### Responsive Positioning:

```dart
Positioned(
  top: MediaQuery.of(context).size.height * 0.1,
  left: MediaQuery.of(context).size.width * 0.05,
  child: Container(
    width: MediaQuery.of(context).size.width * 0.9,
    height: 100,
    color: Colors.blue,
  ),
)
```

---

## Wrap

A widget that displays children in multiple horizontal or vertical runs.

### Basic Usage:

```dart
Wrap(
  children: [
    Chip(label: Text('Chip 1')),
    Chip(label: Text('Chip 2')),
    Chip(label: Text('Chip 3')),
    Chip(label: Text('Chip 4')),
    Chip(label: Text('Chip 5')),
  ],
)
```

### Wrap Properties:

```dart
Wrap(
  direction: Axis.horizontal,        // horizontal, vertical
  alignment: WrapAlignment.start,    // start, end, center, spaceBetween, spaceAround, spaceEvenly
  spacing: 8.0,                      // Space between children in main axis
  runSpacing: 4.0,                   // Space between runs
  crossAxisAlignment: WrapCrossAlignment.start, // start, end, center
  textDirection: TextDirection.ltr,
  verticalDirection: VerticalDirection.down, // down, up
  
  children: [...],
)
```

### Tag Cloud Example:

```dart
Wrap(
  spacing: 8.0,
  runSpacing: 4.0,
  children: [
    'Flutter', 'Dart', 'Mobile', 'Cross-platform', 'UI', 'Widgets',
    'Material Design', 'Cupertino', 'Hot Reload', 'Performance'
  ].map((tag) => Chip(
    label: Text(tag),
    backgroundColor: Colors.blue.shade100,
  )).toList(),
)
```

### Responsive Wrap:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    return Wrap(
      spacing: constraints.maxWidth > 600 ? 16.0 : 8.0,
      runSpacing: constraints.maxWidth > 600 ? 12.0 : 6.0,
      children: List.generate(
        20,
        (index) => Container(
          width: constraints.maxWidth > 600 ? 120 : 80,
          height: 40,
          color: Colors.blue.shade200,
          child: Center(child: Text('Item $index')),
        ),
      ),
    );
  },
)
```

---

## Flow

A widget that positions children using a delegate.

### Basic Flow:

```dart
Flow(
  delegate: MyFlowDelegate(),
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Container(width: 50, height: 50, color: Colors.blue),
    Container(width: 50, height: 50, color: Colors.green),
  ],
)

class MyFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      context.paintChild(i);
    }
  }
  
  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
```

### Circle Layout with Flow:

```dart
class CircleFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    final center = context.size.center(Offset.zero);
    final radius = min(context.size.width, context.size.height) / 2;
    
    for (int i = 0; i < context.childCount; i++) {
      final angle = 2 * pi * i / context.childCount;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
```

---

## Table

A widget that displays children in a table format.

### Basic Table:

```dart
Table(
  border: TableBorder.all(),
  children: [
    TableRow(
      children: [
        Text('Name'),
        Text('Age'),
        Text('City'),
      ],
    ),
    TableRow(
      children: [
        Text('John'),
        Text('25'),
        Text('New York'),
      ],
    ),
    TableRow(
      children: [
        Text('Jane'),
        Text('30'),
        Text('London'),
      ],
    ),
  ],
)
```

### Table Properties:

```dart
Table(
  columnWidths: {
    0: FixedColumnWidth(100),      // Fixed width
    1: FlexColumnWidth(2),         // 2x flexible
    2: FractionColumnWidth(0.3),   // 30% of table width
  },
  
  defaultColumnWidth: FlexColumnWidth(),
  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  
  border: TableBorder.symmetric(
    inside: BorderSide(width: 1, color: Colors.grey),
    outside: BorderSide(width: 2, color: Colors.black),
  ),
  
  children: [...],
)
```

### Advanced Table:

```dart
Table(
  columnWidths: const {
    0: FixedColumnWidth(120),
    1: FixedColumnWidth(80),
    2: FlexColumnWidth(),
  },
  border: TableBorder.all(color: Colors.grey.shade300),
  children: [
    // Header
    TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ),
    // Data rows
    ...products.map((product) => TableRow(
      children: [
        Padding(padding: EdgeInsets.all(8), child: Text(product.name)),
        Padding(padding: EdgeInsets.all(8), child: Text(product.quantity.toString())),
        Padding(padding: EdgeInsets.all(8), child: Text('\$${product.price}')),
      ],
    )),
  ],
)
```

---

## GridView

A scrollable grid of widgets.

### Basic GridView:

```dart
GridView.count(
  crossAxisCount: 2,  // Number of columns
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

### Different Grid Delegates:

```dart
// Fixed number of columns
SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  childAspectRatio: 1.5,  // width/height ratio
)

// Max cross axis extent
SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 150,  // Max width per item
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  childAspectRatio: 1,
)
```

### Responsive Grid:

```dart
LayoutBuilder(
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
      ),
      itemCount: 20,
      itemBuilder: (context, index) => Card(
        child: Center(child: Text('Item $index')),
      ),
    );
  },
)
```

---

## CustomScrollView

A scrollable view that creates custom scroll effects.

### Basic CustomScrollView:

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text('Custom Scroll View'),
      floating: true,
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
    // App bar that can collapse
    SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Collapsing Header'),
        background: Image.network('https://example.com/header.jpg', fit: BoxFit.cover),
      ),
      pinned: true,
    ),
    
    // Grid section
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
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
  ],
)
```

### SliverPersistentHeader:

```dart
class StickyHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          'Sticky Header',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
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

// Usage
SliverPersistentHeader(delegate: StickyHeader())
```

---

## SliverFillRemaining

Fills the remaining space in a CustomScrollView.

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(title: Text('App Bar')),
    SliverList(
      delegate: SliverChildListDelegate([
        ListTile(title: Text('Item 1')),
        ListTile(title: Text('Item 2')),
      ]),
    ),
    SliverFillRemaining(
      child: Center(
        child: Text('This fills remaining space'),
      ),
    ),
  ],
)
```

---

## Responsive Design Patterns

### Breakpoint System:

```dart
enum ScreenSize { small, medium, large }

class ResponsiveLayout extends StatelessWidget {
  final Widget smallScreen;
  final Widget mediumScreen;
  final Widget largeScreen;
  
  const ResponsiveLayout({
    super.key,
    required this.smallScreen,
    required this.mediumScreen,
    required this.largeScreen,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth > 600) {
          return mediumScreen;
        } else {
          return smallScreen;
        }
      },
    );
  }
}
```

### Adaptive Widgets:

```dart
class AdaptiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    
    return Scaffold(
      appBar: AppBar(title: Text('Adaptive Layout')),
      body: isWide
          ? Row(
              children: [
                Expanded(child: Sidebar()),
                Expanded(flex: 2, child: MainContent()),
              ],
            )
          : Column(
              children: [
                Expanded(child: MainContent()),
                BottomNavigation(),
              ],
            ),
    );
  }
}
```

### Orientation-Aware Layout:

```dart
class OrientationLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    
    return orientation == Orientation.portrait
        ? Column(
            children: [
              Header(),
              Expanded(child: Content()),
              Footer(),
            ],
          )
        : Row(
            children: [
              Sidebar(),
              Expanded(child: Content()),
            ],
          );
  }
}
```

---

## Layout Performance

### RepaintBoundary:

```dart
RepaintBoundary(
  child: ExpensiveWidget(),  // Only this subtree repaints
)
```

### Avoiding Unnecessary Rebuilds:

```dart
class OptimizedList extends StatelessWidget {
  final List<String> items;
  
  const OptimizedList({super.key, required this.items});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _ListItem(
          key: ValueKey(items[index]),  // Stable key
          text: items[index],
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final String text;
  
  const _ListItem({super.key, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(text),
    );
  }
}
```

### Const Constructors:

```dart
class StaticLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static Text 1'),
        Text('Static Text 2'),
        Text('Static Text 3'),
      ],
    );
  }
}
```

---

## Advanced Layout Techniques

### Transform Widgets:

```dart
Transform.rotate(
  angle: pi / 4,  // 45 degrees
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)

Transform.scale(
  scale: 1.5,
  child: Icon(Icons.star, size: 50),
)

Transform.translate(
  offset: Offset(50, 100),
  child: Text('Translated Text'),
)
```

### Clip Widgets:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.network('https://example.com/image.jpg'),
)

ClipOval(
  child: Image.network('https://example.com/avatar.jpg'),
)

ClipPath(
  clipper: TriangleClipper(),
  child: Container(color: Colors.blue),
)

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
```

### OverflowBox:

```dart
OverflowBox(
  maxWidth: double.infinity,
  maxHeight: double.infinity,
  child: Container(
    width: 100,
    height: 100,
    color: Colors.red,
  ),
)
// Allows child to overflow parent constraints
```

### SizedOverflowBox:

```dart
SizedOverflowBox(
  size: Size(200, 200),  // Force this size
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)
// Child will be 200x200 regardless of its natural size
```

---

## Layout Debugging

### Visual Debugging:

```dart
// Show layout bounds
debugPaintSizeEnabled = true;

// Show baselines
debugPaintBaselinesEnabled = true;

// Show repaint boundaries
debugPaintLayerBordersEnabled = true;

// Show pointer events
debugPaintPointersEnabled = true;
```

### Custom Debug Paint:

```dart
class DebugLayout extends StatelessWidget {
  final Widget child;
  final Color color;
  
  const DebugLayout({super.key, required this.child, this.color = Colors.red});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
      ),
      child: child,
    );
  }
}
```

### Layout Inspector:

```dart
// Add to MaterialApp
MaterialApp(
  showSemanticsDebugger: true,  // Shows semantic boundaries
  debugShowMaterialGrid: true,  // Shows material grid
  // ... other properties
)
```

---

## Summary

- **Stack**: Layer widgets on top of each other
- **Positioned**: Place widgets at specific coordinates in Stack
- **Wrap**: Flow children into multiple lines when needed
- **Flow**: Advanced positioning with custom delegates
- **Table**: Display data in tabular format
- **GridView**: Scrollable grid layouts
- **CustomScrollView**: Complex scrollable layouts with slivers
- **Responsive Design**: Adapt layouts to different screen sizes
- **Performance**: Optimize with RepaintBoundary and const constructors
- **Advanced Techniques**: Transforms, clips, and overflow handling
- **Debugging**: Visual tools for layout inspection

Advanced layouts require understanding of constraints, positioning, and responsive design principles.

## Positioned

Places a child at a specific position within a Stack.

### Basic Usage:

```dart
Positioned(
  top: 10,
  left: 10,
  child: Container(width: 50, height: 50, color: Colors.blue),
)
```

### Complete Positioning:

```dart
Positioned(
  top: 10,           // Distance from top
  bottom: 10,        // Distance from bottom
  left: 10,          // Distance from left
  right: 10,         // Distance from right
  width: 100,        // Optional: set width
  height: 100,       // Optional: set height
  child: Widget(),
)
```

### Responsive Positioning:

```dart
Stack(
  children: [
    Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    ),
    Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: MediaQuery.of(context).size.width * 0.05,
      child: Widget(),
    ),
  ],
)
```

---

## Wrap

Arranges children in rows and columns with wrapping.

### Basic Usage:

```dart
Wrap(
  children: [
    Chip(label: Text("Flutter")),
    Chip(label: Text("Dart")),
    Chip(label: Text("Mobile")),
    Chip(label: Text("UI")),
    Chip(label: Text("Design")),
  ],
)
```

### With Spacing:

```dart
Wrap(
  spacing: 10,        // Horizontal space between items
  runSpacing: 10,     // Vertical space between rows
  children: [
    Chip(label: Text("Tag 1")),
    Chip(label: Text("Tag 2")),
    Chip(label: Text("Tag 3")),
  ],
)
```

### Alignment:

```dart
Wrap(
  alignment: WrapAlignment.center,  // How items align in a row
  //         WrapAlignment.start,
  //         WrapAlignment.end,
  //         WrapAlignment.spaceBetween,
  //         WrapAlignment.spaceAround,
  //         WrapAlignment.spaceEvenly,
  runAlignment: WrapAlignment.center, // How rows align
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [...],
)
```

### Use Case - Tag Input:

```dart
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: tags.map((tag) {
    return Chip(
      label: Text(tag),
      onDeleted: () {
        setState(() {
          tags.remove(tag);
        });
      },
    );
  }).toList(),
)
```

---

## IntrinsicHeight

Makes all children the same height as the tallest child.

### Usage:

```dart
IntrinsicHeight(
  child: Row(
    children: [
      Container(
        width: 50,
        color: Colors.red,
      ),
      Container(
        width: 50,
        height: 100,
        color: Colors.blue,
      ),
      Container(
        width: 50,
        color: Colors.green,
      ),
    ],
  ),
)
```

All children will be 100 pixels tall (same as the blue container).

### Use Case:

```dart
IntrinsicHeight(
  child: Row(
    children: [
      Expanded(
        child: Container(
          color: Colors.red,
          child: Text("Item 1"),
        ),
      ),
      Container(width: 1, color: Colors.grey),
      Expanded(
        child: Container(
          color: Colors.blue,
          child: Text("Item 2"),
        ),
      ),
    ],
  ),
)
```

---

## IntrinsicWidth

Makes all children the same width as the widest child.

### Usage:

```dart
IntrinsicWidth(
  child: Column(
    children: [
      ElevatedButton(onPressed: () {}, child: Text("Short")),
      ElevatedButton(onPressed: () {}, child: Text("Much longer button")),
      ElevatedButton(onPressed: () {}, child: Text("OK")),
    ],
  ),
)
```

All buttons will be as wide as the widest one.

---

## LayoutBuilder

Gives you the parent's constraints so you can build responsively.

### Basic Usage:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    print("Max width: ${constraints.maxWidth}");
    print("Max height: ${constraints.maxHeight}");
    
    if (constraints.maxWidth > 600) {
      return Row(...);  // Desktop layout
    } else {
      return Column(...);  // Mobile layout
    }
  },
)
```

### Responsive Grid:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    int columns = (constraints.maxWidth ~/ 200).toInt();
    return GridView.count(
      crossAxisCount: columns,
      children: items.map((item) => ItemCard(item)).toList(),
    );
  },
)
```

### Complete Example:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      // Mobile
      return SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildContent(),
            buildFooter(),
          ],
        ),
      );
    } else if (constraints.maxWidth < 1200) {
      // Tablet
      return Row(
        children: [
          Expanded(child: buildHeader()),
          Expanded(child: buildContent()),
        ],
      );
    } else {
      // Desktop
      return Row(
        children: [
          Expanded(child: buildHeader()),
          Expanded(child: buildContent()),
          Expanded(child: buildFooter()),
        ],
      );
    }
  },
)
```

---

## MediaQuery (Responsive Design)

Access device information for responsive design.

### Screen Size:

```dart
MediaQuery.of(context).size.width   // Screen width
MediaQuery.of(context).size.height  // Screen height

// Safe area (avoiding notches)
MediaQuery.of(context).padding.top
MediaQuery.of(context).padding.bottom
MediaQuery.of(context).viewInsets.bottom  // Keyboard height
```

### Device Orientation:

```dart
if (MediaQuery.of(context).orientation == Orientation.landscape) {
  // Landscape
} else {
  // Portrait
}
```

### Device Pixel Ratio:

```dart
double pixelRatio = MediaQuery.of(context).devicePixelRatio;
// Density of pixels (typically 1.0 to 3.0+)
```

### Responsive Container:

```dart
Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height * 0.5,
  color: Colors.blue,
)
```

### Responsive Padding:

```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.05,
    vertical: MediaQuery.of(context).size.height * 0.02,
  ),
  child: Text("Responsive padding"),
)
```

### Complete Responsive Example:

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: size.width > 600
          ? DesktopLayout()      // Wide screen
          : MobileLayout(),      // Narrow screen
    );
  }
}
```

### Breakpoints:

```dart
double screenWidth = MediaQuery.of(context).size.width;

if (screenWidth < 600) {
  // Mobile
} else if (screenWidth < 900) {
  // Tablet
} else {
  // Desktop
}
```

### Orientation-Based Layout:

```dart
Scaffold(
  body: OrientationBuilder(
    builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return PortraitLayout();
      } else {
        return LandscapeLayout();
      }
    },
  ),
)
```

---

## Advanced Layout Pattern

### Responsive Dashboard:

```dart
class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile: Single column
          return ListView(
            children: [
              Card(child: Widget1()),
              Card(child: Widget2()),
              Card(child: Widget3()),
            ],
          );
        } else if (constraints.maxWidth < 1200) {
          // Tablet: Two columns
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: Card(child: Widget1())),
                  SizedBox(width: 10),
                  Expanded(child: Card(child: Widget2())),
                ],
              ),
              SizedBox(height: 10),
              Card(child: Widget3()),
            ],
          );
        } else {
          // Desktop: Three columns
          return Row(
            children: [
              Expanded(child: Card(child: Widget1())),
              SizedBox(width: 10),
              Expanded(child: Card(child: Widget2())),
              SizedBox(width: 10),
              Expanded(child: Card(child: Widget3())),
            ],
          );
        }
      },
    );
  }
}
```

---

## Summary

- **Stack**: Layer widgets on top of each other
- **Positioned**: Position widget absolutely in Stack
- **Wrap**: Arrange with wrapping
- **IntrinsicHeight/Width**: Match heights/widths
- **LayoutBuilder**: React to parent constraints
- **MediaQuery**: Access device information
- **Responsive design**: Adapt to screen size
- Use LayoutBuilder + MediaQuery for true responsiveness
