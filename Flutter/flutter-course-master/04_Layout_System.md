# Flutter Layout System

The layout system in Flutter is built on the concept of constraints, sizes, and alignment. Understanding this is crucial for building responsive UIs.

---

## Understanding Constraints

Flutter's layout system is based on **constraints** passed down from parent to child widgets.

### Constraint Types:

1. **Tight Constraints**: Exact size required (width: 100, height: 100)
2. **Loose Constraints**: Maximum size allowed (maxWidth: 300, maxHeight: 200)
3. **Unbounded Constraints**: No size restrictions (infinite width/height)

### How Constraints Work:

```dart
// Parent sets constraints
Container(
  width: 200,
  height: 100,
  child: Text('Hello'), // Child receives tight constraints: 200x100
)

// Parent sets loose constraints
Center(
  child: Text('Hello'), // Child can be any size up to screen size
)
```

### Widget Size Decisions:

1. **Parent sets constraints** on child
2. **Child chooses its size** within those constraints
3. **Child returns its actual size** to parent

---

## Column

A widget that arranges children vertically, one after another.

### Basic Usage:

```dart
Column(
  children: [
    Text("First"),
    Text("Second"),
    Text("Third"),
  ],
)
```

### Main Axis Alignment (Vertical):

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.start,      // Default - top aligned
  //                 MainAxisAlignment.end,        // Bottom aligned
  //                 MainAxisAlignment.center,     // Center aligned
  //                 MainAxisAlignment.spaceBetween, // Space between items
  //                 MainAxisAlignment.spaceAround,  // Space around items
  //                 MainAxisAlignment.spaceEvenly,  // Equal space between all
  children: [
    Text("Item 1"),
    Text("Item 2"),
    Text("Item 3"),
  ],
)
```

### Cross Axis Alignment (Horizontal):

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,    // Left aligned
  //                 CrossAxisAlignment.end,       // Right aligned
  //                 CrossAxisAlignment.center,    // Center aligned
  //                 CrossAxisAlignment.stretch,   // Full width (stretch children)
  children: [
    Text("Left aligned"),
    Text("Also left"),
  ],
)
```

### Complete Example:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.person, size: 80),
    SizedBox(height: 20),
    Text(
      "Profile",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    Text("user@example.com"),
  ],
)
```

### Column with Flexible Children:

```dart
Column(
  children: [
    // Fixed size header
    Container(
      height: 100,
      color: Colors.blue,
      child: Center(child: Text('Header')),
    ),
    
    // Flexible content area
    Expanded(
      child: Container(
        color: Colors.grey,
        child: Center(child: Text('Content')),
      ),
    ),
    
    // Fixed size footer
    Container(
      height: 80,
      color: Colors.green,
      child: Center(child: Text('Footer')),
    ),
  ],
)
```

---

## Row

A widget that arranges children horizontally, one after another.

### Basic Usage:

```dart
Row(
  children: [
    Text("Left"),
    Text("Right"),
  ],
)
```

### Main Axis Alignment (Horizontal):

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)
```

### Cross Axis Alignment (Vertical):

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,    // Top aligned
  //                 CrossAxisAlignment.end,       // Bottom aligned
  //                 CrossAxisAlignment.center,    // Center aligned
  //                 CrossAxisAlignment.baseline,  // Baseline aligned
  //                 CrossAxisAlignment.stretch,   // Full height
  children: [
    Icon(Icons.star, size: 50),
    Text("Star Rating"),
  ],
)
```

### Row with Flexible Children:

```dart
Row(
  children: [
    // Fixed width sidebar
    Container(
      width: 100,
      color: Colors.blue,
      child: Center(child: Text('Menu')),
    ),
    
    // Flexible main content
    Expanded(
      flex: 3, // Takes 3x space
      child: Container(
        color: Colors.grey,
        child: Center(child: Text('Main Content')),
      ),
    ),
    
    // Flexible sidebar
    Expanded(
      flex: 1, // Takes 1x space
      child: Container(
        color: Colors.green,
        child: Center(child: Text('Sidebar')),
      ),
    ),
  ],
)
```

---

## Expanded and Flexible

Widgets that control how children of Row/Column use available space.

### Expanded:

```dart
Row(
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Expanded(
      child: Container(height: 50, color: Colors.blue),
    ),
    Container(width: 50, height: 50, color: Colors.green),
  ],
)
// Red: 50px, Blue: remaining space, Green: 50px
```

### Flexible:

```dart
Row(
  children: [
    Flexible(
      flex: 1,
      child: Container(height: 50, color: Colors.red),
    ),
    Flexible(
      flex: 2,
      child: Container(height: 50, color: Colors.blue),
    ),
    Flexible(
      flex: 1,
      child: Container(height: 50, color: Colors.green),
    ),
  ],
)
// Red: 1/4 space, Blue: 2/4 space, Green: 1/4 space
```

### Flexible with fit:

```dart
Column(
  children: [
    Flexible(
      fit: FlexFit.tight,    // Default - takes all available space
      child: Container(color: Colors.red),
    ),
    Flexible(
      fit: FlexFit.loose,    // Takes only needed space
      child: Container(
        color: Colors.blue,
        height: 100,         // Fixed height
      ),
    ),
  ],
)
```

---

## Container

A versatile widget that combines painting, positioning, and sizing.

### Basic Container:

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
  child: Center(
    child: Text('Hello'),
  ),
)
```

### Container with Decoration:

```dart
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.black,
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  ),
  child: Center(child: Text('Styled Container')),
)
```

### Container with Padding and Margin:

```dart
Container(
  padding: EdgeInsets.all(16),        // Internal padding
  margin: EdgeInsets.symmetric(vertical: 8), // External margin
  
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
  ),
  
  child: Text('Content with padding'),
)
```

### Container with Constraints:

```dart
Container(
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 300,
    minHeight: 50,
    maxHeight: 200,
  ),
  
  decoration: BoxDecoration(
    color: Colors.blue.shade100,
    borderRadius: BorderRadius.circular(8),
  ),
  
  child: Text('Constrained container'),
)
```

### Container as Spacer:

```dart
Column(
  children: [
    Text('Top'),
    Container(height: 20), // Spacer
    Text('Bottom'),
  ],
)
```

---

## Padding

A widget that insets its child by the given padding.

### Basic Padding:

```dart
Padding(
  padding: EdgeInsets.all(16), // All sides
  child: Text('Padded text'),
)
```

### Directional Padding:

```dart
Padding(
  padding: EdgeInsets.only(
    left: 16,
    top: 8,
    right: 16,
    bottom: 8,
  ),
  child: Text('Directional padding'),
)

Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  child: Text('Symmetric padding'),
)
```

### EdgeInsets Helpers:

```dart
// All sides equal
EdgeInsets.all(16)

// Horizontal and vertical
EdgeInsets.symmetric(horizontal: 16, vertical: 8)

// Specific sides
EdgeInsets.only(left: 16, right: 16)

// Zero padding
EdgeInsets.zero
```

---

## Align

A widget that aligns its child within itself.

### Basic Alignment:

```dart
Align(
  alignment: Alignment.center,  // Center of container
  child: Text('Centered text'),
)
```

### Alignment Options:

```dart
Align(
  alignment: Alignment.topLeft,      // Top-left corner
  //         Alignment.topCenter,     // Top center
  //         Alignment.topRight,      // Top-right corner
  //         Alignment.centerLeft,    // Left center
  //         Alignment.center,        // Center
  //         Alignment.centerRight,   // Right center
  //         Alignment.bottomLeft,    // Bottom-left corner
  //         Alignment.bottomCenter,  // Bottom center
  //         Alignment.bottomRight,   // Bottom-right corner
  child: Icon(Icons.star, size: 50),
)
```

### Custom Alignment:

```dart
Align(
  alignment: Alignment(0.5, -0.5),  // Custom position
  child: Text('Custom aligned'),
)
// 0.5 = 50% from left, -0.5 = 50% from top
```

### FractionalOffset (Legacy):

```dart
Align(
  alignment: FractionalOffset(0.2, 0.8),  // 20% from left, 80% from top
  child: Text('Fractional offset'),
)
```

---

## Center

A convenience widget that centers its child.

### Basic Usage:

```dart
Center(
  child: Text('Centered text'),
)
```

### Equivalent to:

```dart
Align(
  alignment: Alignment.center,
  child: Text('Centered text'),
)
```

### Center with Sized Container:

```dart
Container(
  width: 300,
  height: 200,
  color: Colors.grey.shade200,
  child: Center(
    child: Text('Centered in container'),
  ),
)
```

---

## SizedBox

A box with a specified size.

### Fixed Size:

```dart
SizedBox(
  width: 100,
  height: 50,
  child: Container(color: Colors.blue),
)
```

### Spacing:

```dart
Column(
  children: [
    Text('First item'),
    SizedBox(height: 16),  // Vertical spacing
    Text('Second item'),
  ],
)

Row(
  children: [
    Text('Left'),
    SizedBox(width: 16),   // Horizontal spacing
    Text('Right'),
  ],
)
```

### Infinite Size (for layout testing):

```dart
SizedBox.expand(
  child: Container(color: Colors.blue),
)
// Equivalent to: SizedBox(width: double.infinity, height: double.infinity)
```

### Square SizedBox:

```dart
SizedBox.square(
  dimension: 100,
  child: Container(color: Colors.red),
)
```

---

## Spacer

A widget that takes up available space in a Flex container.

### Basic Usage:

```dart
Row(
  children: [
    Text('Start'),
    Spacer(),              // Takes remaining space
    Text('End'),
  ],
)
```

### Multiple Spacers:

```dart
Row(
  children: [
    Text('Left'),
    Spacer(flex: 1),       // 1 part of space
    Text('Center'),
    Spacer(flex: 2),       // 2 parts of space
    Text('Right'),
  ],
)
// Space distribution: 1:2 ratio between spacers
```

### Column with Spacer:

```dart
Column(
  children: [
    Text('Header'),
    Spacer(),              // Pushes footer to bottom
    Text('Footer'),
  ],
)
```

---

## LayoutBuilder

A widget that builds differently based on parent constraints.

### Basic Usage:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Wide layout
      return Row(
        children: [
          Expanded(child: Text('Left content')),
          Expanded(child: Text('Right content')),
        ],
      );
    } else {
      // Narrow layout
      return Column(
        children: [
          Text('Top content'),
          Text('Bottom content'),
        ],
      );
    }
  },
)
```

### Responsive Card:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isWide = constraints.maxWidth > 400;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isWide ? 24 : 16),
        child: isWide
            ? Row(
                children: [
                  Icon(Icons.info, size: 48),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title', style: TextStyle(fontSize: 18)),
                        Text('Description text here...'),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(Icons.info, size: 48),
                  SizedBox(height: 16),
                  Text('Title', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Description text here...'),
                ],
              ),
      ),
    );
  },
)
```

### Debugging Constraints:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    print('Constraints: ${constraints.toString()}');
    
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          'W: ${constraints.maxWidth.toInt()}\n'
          'H: ${constraints.maxHeight.toInt()}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  },
)
```

---

## MediaQuery

Access device and screen information.

### Basic Usage:

```dart
MediaQuery(
  data: MediaQueryData(),
  child: Container(),
)
```

### Getting Screen Size:

```dart
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    
    return Container(
      width: width * 0.8,
      height: height * 0.5,
      color: Colors.blue,
      child: Center(
        child: Text('Screen: ${width.toInt()} x ${height.toInt()}'),
      ),
    );
  }
}
```

### Orientation Detection:

```dart
class OrientationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    
    return orientation == Orientation.portrait
        ? Column(
            children: [
              Text('Portrait Mode'),
              Icon(Icons.stay_primary_portrait, size: 100),
            ],
          )
        : Row(
            children: [
              Text('Landscape Mode'),
              Icon(Icons.stay_primary_landscape, size: 100),
            ],
          );
  }
}
```

### Safe Area:

```dart
class SafeAreaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text('This content is safe from notches'),
          // Content here won't be obscured
        ],
      ),
    );
  }
}
```

### Device Pixel Ratio:

```dart
class PixelRatioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    
    return Text('Device pixel ratio: $pixelRatio');
  }
}
```

---

## AspectRatio

A widget that sizes its child to a specific aspect ratio.

### Basic Usage:

```dart
AspectRatio(
  aspectRatio: 16 / 9,  // Width / Height ratio
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('16:9 Aspect Ratio')),
  ),
)
```

### Image Aspect Ratio:

```dart
AspectRatio(
  aspectRatio: 4 / 3,
  child: Image.network(
    'https://example.com/image.jpg',
    fit: BoxFit.cover,
  ),
)
```

### Video Player Container:

```dart
AspectRatio(
  aspectRatio: 16 / 9,
  child: VideoPlayer(controller: _controller),
)
```

---

## FractionallySizedBox

Sizes its child as a fraction of the available space.

### Basic Usage:

```dart
FractionallySizedBox(
  widthFactor: 0.8,   // 80% of available width
  heightFactor: 0.5,  // 50% of available height
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('80% x 50%')),
  ),
)
```

### Alignment:

```dart
FractionallySizedBox(
  widthFactor: 0.6,
  heightFactor: 0.4,
  alignment: Alignment.topLeft,  // Align to top-left of available space
  child: Container(color: Colors.red),
)
```

### Only Width or Height:

```dart
// Only width
FractionallySizedBox(
  widthFactor: 0.7,
  child: Container(color: Colors.green),
)

// Only height
FractionallySizedBox(
  heightFactor: 0.3,
  child: Container(color: Colors.yellow),
)
```

---

## IntrinsicWidth/IntrinsicHeight

Widgets that size themselves based on their child's intrinsic dimensions.

### IntrinsicWidth:

```dart
IntrinsicWidth(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Short'),
      Text('This is a much longer text that determines width'),
      Text('Medium length'),
    ],
  ),
)
```

### IntrinsicHeight:

```dart
IntrinsicHeight(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(width: 50, color: Colors.red),
      Container(width: 50, color: Colors.blue, height: 100),
      Container(width: 50, color: Colors.green),
    ],
  ),
)
// All containers will be 100px tall (tallest child)
```

### Performance Note:

Intrinsic widgets can be expensive as they require multiple layout passes. Use sparingly.

---

## Custom Layout Widgets

### Custom Single Child Layout:

```dart
class CircularLayout extends StatelessWidget {
  final Widget child;
  
  const CircularLayout({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: CircularLayoutDelegate(),
      child: child,
    );
  }
}

class CircularLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Child can be any size up to a circle
    final size = min(constraints.maxWidth, constraints.maxHeight);
    return BoxConstraints.loose(Size.square(size));
  }
  
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Center the child
    return Offset(
      (size.width - childSize.width) / 2,
      (size.height - childSize.height) / 2,
    );
  }
  
  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => false;
}
```

### Custom Multi Child Layout:

```dart
class GridLayout extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  
  const GridLayout({
    super.key,
    required this.children,
    this.columns = 2,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: GridLayoutDelegate(columns: columns),
      children: children.map((child) {
        final index = children.indexOf(child);
        return LayoutId(
          id: index,
          child: child,
        );
      }).toList(),
    );
  }
}

class GridLayoutDelegate extends MultiChildLayoutDelegate {
  final int columns;
  
  GridLayoutDelegate({required this.columns});
  
  @override
  void performLayout(Size size) {
    final itemWidth = size.width / columns;
    final itemHeight = 60.0; // Fixed height
    
    for (int i = 0; i < childCount; i++) {
      if (hasChild(i)) {
        final row = i ~/ columns;
        final col = i % columns;
        
        layoutChild(
          i,
          BoxConstraints.tight(Size(itemWidth, itemHeight)),
        );
        
        positionChild(
          i,
          Offset(col * itemWidth, row * itemHeight),
        );
      }
    }
  }
  
  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return oldDelegate is GridLayoutDelegate && 
           oldDelegate.columns != columns;
  }
}
```

---

## Layout Debugging

### Debug Paint:

```dart
void main() {
  debugPaintSizeEnabled = true;        // Show sizes
  debugPaintBaselinesEnabled = true;   // Show baselines
  debugPaintPointersEnabled = true;    // Show pointer positions
  
  runApp(const MyApp());
}
```

### Visual Debug Borders:

```dart
class DebugContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  
  const DebugContainer({
    super.key,
    required this.child,
    this.color = Colors.red,
  });
  
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

### Layout Explorer:

```dart
// Add to MaterialApp
MaterialApp(
  builder: (context, child) {
    return LayoutExplorer(
      child: child ?? const SizedBox(),
    );
  },
  // ... other properties
)
```

---

## Performance Tips

1. **Avoid deep nesting**: Keep widget trees shallow
2. **Use const constructors**: Prevents unnecessary rebuilds
3. **Prefer SizedBox over Container**: For simple spacing
4. **Use LayoutBuilder sparingly**: Expensive for frequent rebuilds
5. **Cache expensive layouts**: Use keys for stable widget identity
6. **Profile layout performance**: Use DevTools Performance tab

### Common Layout Mistakes:

```dart
// ❌ Bad: Unnecessary nesting
Container(
  padding: EdgeInsets.all(16),
  child: Container(
    decoration: BoxDecoration(color: Colors.blue),
    child: Container(
      alignment: Alignment.center,
      child: Text('Hello'),
    ),
  ),
)

// ✅ Good: Single Container
Container(
  padding: EdgeInsets.all(16),
  color: Colors.blue,
  alignment: Alignment.center,
  child: Text('Hello'),
)
```

---

## Summary

- **Constraints**: Parent sets limits, child chooses size
- **Column/Row**: Main axis (flow) and cross axis (alignment)
- **Expanded/Flexible**: Control space distribution
- **Container**: Versatile layout and styling widget
- **Padding**: Internal spacing
- **Align/Center**: Position children within available space
- **SizedBox/Spacer**: Fixed and flexible spacing
- **LayoutBuilder**: Responsive layouts based on constraints
- **MediaQuery**: Device and screen information
- **AspectRatio**: Maintain specific width/height ratios
- **FractionallySizedBox**: Size as fraction of available space
- **IntrinsicWidth/Height**: Size based on child content
- **Custom layouts**: For complex positioning requirements

Mastering Flutter's layout system requires understanding constraints and how widgets negotiate sizes with their parents.

## Row

A widget that arranges children horizontally, one after another.

### Basic Usage:

```dart
Row(
  children: [
    Text("Left"),
    Text("Right"),
  ],
)
```

### Main Axis Alignment (Horizontal):

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)
```

### Cross Axis Alignment (Vertical):

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.star, size: 40),
    SizedBox(width: 10),
    Text("Rating: 5.0"),
  ],
)
```

### Common Row Pattern:

```dart
Row(
  children: [
    Expanded(
      child: Container(color: Colors.red),
    ),
    SizedBox(width: 10),
    Expanded(
      child: Container(color: Colors.blue),
    ),
  ],
)
```

---

## Expanded

Expands a child to fill available space.

### Basic Usage:

```dart
Row(
  children: [
    Expanded(
      child: Container(color: Colors.red),
    ),
    Container(
      width: 100,
      color: Colors.blue,
    ),
  ],
)
```

### Flex Property:

```dart
Row(
  children: [
    Expanded(
      flex: 2,
      child: Container(color: Colors.red),    // 2/3 of space
    ),
    Expanded(
      flex: 1,
      child: Container(color: Colors.blue),   // 1/3 of space
    ),
  ],
)
```

### Nested Expanded:

```dart
Column(
  children: [
    Expanded(
      flex: 1,
      child: Container(color: Colors.red),
    ),
    Expanded(
      flex: 2,
      child: Container(
        color: Colors.blue,
        child: Row(
          children: [
            Expanded(child: Container(color: Colors.green)),
            Expanded(child: Container(color: Colors.yellow)),
          ],
        ),
      ),
    ),
  ],
)
```

---

## Flexible

Gives a child flexibility to take up available space (more control than Expanded).

### Basic Usage:

```dart
Row(
  children: [
    Flexible(
      child: TextField(
        decoration: InputDecoration(hintText: "Search"),
      ),
    ),
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

### Fit Property:

```dart
Flexible(
  fit: FlexFit.tight,   // Force child to fill available space
  //  FlexFit.loose,   // Child can be smaller than available space
  child: Container(color: Colors.blue),
)
```

### Expanded vs Flexible:

```dart
// Expanded - always fills available space
Expanded(child: Item())           // flex: 1 by default

// Flexible - can fill or not fill
Flexible(child: Item())           // Respects child's size

// Equivalent:
Expanded(child: Item()) 
// is the same as
Flexible(fit: FlexFit.tight, child: Item())
```

---

## Container

A versatile widget that combines common painting, positioning, and sizing widgets.

### Basic Usage:

```dart
Container(
  width: 200,
  height: 200,
  color: Colors.blue,
  child: Text("Container"),
)
```

### Complete Styling:

```dart
Container(
  width: 300,
  height: 200,
  
  // Color and decoration
  color: Colors.red,              // Simple coloring
  // OR use decoration for advanced styling:
  decoration: BoxDecoration(
    color: Colors.red,
    border: Border.all(color: Colors.black, width: 2),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 10,
        offset: Offset(2, 2),
      ),
    ],
  ),
  
  // Padding (inside)
  padding: EdgeInsets.all(20),
  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  // padding: EdgeInsets.only(left: 10, top: 20),
  
  // Margin (outside)
  margin: EdgeInsets.all(10),
  
  // Alignment of child
  alignment: Alignment.center,
  
  // Transform
  transform: Matrix4.rotationZ(0.1),
  
  // Opacity
  opacity: 0.8,
  
  child: Text("Styled Container"),
)
```

### Creating Circular Containers:

```dart
Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.blue,
    shape: BoxShape.circle,
  ),
  child: Center(child: Icon(Icons.person)),
)
```

---

## Padding

Adds empty space inside a widget.

### Basic Usage:

```dart
Padding(
  padding: EdgeInsets.all(20),
  child: Text("Padded text"),
)
```

### Different Padding:

```dart
// Symmetric padding
Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), ...)

// Directional padding
Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 20), ...)

// Combination
Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 30), ...)
```

---

## Align

Aligns a child within its parent.

### Basic Usage:

```dart
Container(
  width: 300,
  height: 300,
  color: Colors.grey,
  child: Align(
    alignment: Alignment.center,
    child: Container(width: 100, height: 100, color: Colors.blue),
  ),
)
```

### Alignment Options:

```dart
Align(
  alignment: Alignment.topLeft,    // Top-left corner
  //        Alignment.topCenter,   // Top-center
  //        Alignment.topRight,    // Top-right corner
  //        Alignment.centerLeft,  // Center-left
  //        Alignment.center,      // Center
  //        Alignment.centerRight, // Center-right
  //        Alignment.bottomLeft,  // Bottom-left corner
  //        Alignment.bottomCenter,// Bottom-center
  //        Alignment.bottomRight, // Bottom-right corner
  child: Widget(),
)
```

### Custom Alignment:

```dart
Align(
  alignment: Alignment(0.5, -0.5),  // Custom position
  child: Widget(),
)
```

---

## Center

Centers a child within its parent (shorthand for Align(alignment: Alignment.center)).

### Usage:

```dart
Center(
  child: Text("Centered text"),
)
```

### Equivalent to:

```dart
Align(
  alignment: Alignment.center,
  child: Text("Centered text"),
)
```

---

## SizedBox

Creates a box with specific width and height.

### Basic Usage:

```dart
SizedBox(
  width: 200,
  height: 100,
  child: Container(color: Colors.blue),
)
```

### Spacing Between Widgets:

```dart
Column(
  children: [
    Text("First"),
    SizedBox(height: 20),  // Vertical space
    Text("Second"),
  ],
)

Row(
  children: [
    Icon(Icons.home),
    SizedBox(width: 10),   // Horizontal space
    Text("Home"),
  ],
)
```

### Responsive SizedBox:

```dart
SizedBox(
  width: MediaQuery.of(context).size.width * 0.5,
  height: 100,
  child: Widget(),
)
```

---

## Spacer

Takes up available space in a flex container (Column, Row).

### Usage:

```dart
Column(
  children: [
    Text("Top"),
    Spacer(),     // Takes up all available space
    Text("Bottom"),
  ],
)
```

### Multiple Spacers:

```dart
Row(
  children: [
    Text("Left"),
    Spacer(flex: 2),   // 2/3 of space
    Text("Middle"),
    Spacer(flex: 1),   // 1/3 of space
    Text("Right"),
  ],
)
```

---

## Layout Constraints

Understanding constraints is crucial for Flutter layout.

### Rule: Constraints go down, sizes go up

```
Parent applies constraints to child
                ↓
Child determines its own size (respecting constraints)
                ↓
Parent positions child
```

### Example:

```dart
Container(
  width: 200,
  height: 200,
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 300,
    minHeight: 100,
    maxHeight: 300,
  ),
  child: Container(color: Colors.blue),
)
```

### BoxConstraints:

```dart
BoxConstraints(
  minWidth: 0,
  maxWidth: double.infinity,
  minHeight: 0,
  maxHeight: double.infinity,
)
```

---

## Summary

- **Column**: Vertical layout
- **Row**: Horizontal layout
- **Expanded**: Fill available space
- **Flexible**: Flexible sizing
- **Container**: Combine painting, positioning, sizing
- **Padding**: Add internal spacing
- **Align**: Position child within parent
- **Center**: Center child
- **SizedBox**: Fixed size box
- **Spacer**: Take up available space
- Master constraints for responsive layouts
