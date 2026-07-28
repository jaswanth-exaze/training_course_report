# Flutter Gesture & Interaction

Handling user gestures and interactions.

---

## GestureDetector

Detect various gestures and user interactions.

### Basic Usage:

```dart
GestureDetector(
  onTap: () {
    print("Tapped");
  },
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)
```

### All Gesture Callbacks:

```dart
GestureDetector(
  // Tap
  onTap: () {},
  onDoubleTap: () {},
  onLongPress: () {},
  onLongPressStart: (details) {},
  onLongPressMoveUpdate: (details) {},
  onLongPressEnd: (details) {},
  
  // Drag
  onPanStart: (details) {},
  onPanUpdate: (details) {},
  onPanEnd: (details) {},
  onPanCancel: () {},
  
  // Horizontal drag
  onHorizontalDragStart: (details) {},
  onHorizontalDragUpdate: (details) {},
  onHorizontalDragEnd: (details) {},
  
  // Vertical drag
  onVerticalDragStart: (details) {},
  onVerticalDragUpdate: (details) {},
  onVerticalDragEnd: (details) {},
  
  // Scale
  onScaleStart: (details) {},
  onScaleUpdate: (details) {},
  onScaleEnd: (details) {},
  
  child: Container(),
)
```

### Drag Example:

```dart
class DraggableWidget extends StatefulWidget {
  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  late Offset _offset;

  @override
  void initState() {
    super.initState();
    _offset = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset = _offset + details.delta;
        });
      },
      child: Transform.translate(
        offset: _offset,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
        ),
      ),
    );
  }
}
```

### Advanced GestureDetector:

```dart
class AdvancedGestureDetector extends StatefulWidget {
  @override
  State<AdvancedGestureDetector> createState() => _AdvancedGestureDetectorState();
}

class _AdvancedGestureDetectorState extends State<AdvancedGestureDetector> {
  String _gesture = "No gesture detected";
  Offset _position = Offset.zero;
  double _scale = 1.0;
  double _rotation = 0.0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_gesture),
        Text("Position: ${_position.dx.toStringAsFixed(1)}, ${_position.dy.toStringAsFixed(1)}"),
        
        Expanded(
          child: GestureDetector(
            // Tap gestures
            onTap: () => setState(() => _gesture = "Single tap"),
            onDoubleTap: () => setState(() => _gesture = "Double tap"),
            onLongPress: () => setState(() => _gesture = "Long press"),
            
            // Pan gestures
            onPanStart: (details) {
              setState(() {
                _gesture = "Pan started";
                _position = details.localPosition;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _gesture = "Panning";
                _position = details.localPosition;
              });
            },
            onPanEnd: (details) {
              setState(() => _gesture = "Pan ended");
            },
            
            // Scale gestures
            onScaleStart: (details) {
              setState(() => _gesture = "Scale started");
            },
            onScaleUpdate: (details) {
              setState(() {
                _gesture = "Scaling";
                _scale = details.scale;
                _rotation = details.rotation;
              });
            },
            onScaleEnd: (details) {
              setState(() => _gesture = "Scale ended");
            },
            
            child: Container(
              color: Colors.blue.withOpacity(0.1),
              child: Center(
                child: Transform.scale(
                  scale: _scale,
                  child: Transform.rotate(
                    angle: _rotation,
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          "Gesture Area",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## InkWell

Material Design ripple effects and touch feedback.

### Basic InkWell:

```dart
InkWell(
  onTap: () {
    print("InkWell tapped");
  },
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text("Tap me"),
  ),
)
```

### Advanced InkWell:

```dart
InkWell(
  onTap: () {},
  onLongPress: () {},
  onDoubleTap: () {},
  
  // Customization
  splashColor: Colors.blue.withOpacity(0.3),
  highlightColor: Colors.blue.withOpacity(0.1),
  borderRadius: BorderRadius.circular(8),
  customBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  
  // Focus
  focusColor: Colors.blue.withOpacity(0.2),
  hoverColor: Colors.blue.withOpacity(0.1),
  autofocus: false,
  
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey),
    ),
    child: Text("Interactive Button"),
  ),
)
```

### InkWell with Custom Feedback:

```dart
class CustomInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? splashColor;
  final Color? highlightColor;
  
  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.splashColor,
    this.highlightColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? Theme.of(context).splashColor,
        highlightColor: highlightColor ?? Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

// Usage
CustomInkWell(
  onTap: () => print("Custom tap"),
  splashColor: Colors.red.withOpacity(0.3),
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text("Custom InkWell"),
  ),
)
```

---

## Drag and Drop

Implementing drag and drop functionality.

### Basic Draggable:

```dart
class DragDropExample extends StatefulWidget {
  @override
  State<DragDropExample> createState() => _DragDropExampleState();
}

class _DragDropExampleState extends State<DragDropExample> {
  Color _color = Colors.blue;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Draggable<Color>(
          data: Colors.red,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.red,
            child: Center(child: Text("Drag me")),
          ),
          feedback: Container(
            width: 100,
            height: 100,
            color: Colors.red.withOpacity(0.5),
            child: Center(child: Text("Dragging")),
          ),
          childWhenDragging: Container(
            width: 100,
            height: 100,
            color: Colors.grey,
            child: Center(child: Text("Dragged")),
          ),
        ),
        
        SizedBox(height: 50),
        
        DragTarget<Color>(
          onAccept: (color) {
            setState(() => _color = color);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 200,
              height: 200,
              color: _color,
              child: Center(
                child: Text(
                  "Drop here",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
```

### Advanced Drag and Drop:

```dart
class AdvancedDragDrop extends StatefulWidget {
  @override
  State<AdvancedDragDrop> createState() => _AdvancedDragDropState();
}

class _AdvancedDragDropState extends State<AdvancedDragDrop> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  final List<String> _droppedItems = [];
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Source area
        Expanded(
          child: Container(
            height: 400,
            color: Colors.grey[200],
            child: Column(
              children: [
                Text("Drag from here"),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return LongPressDraggable<String>(
                        data: _items[index],
                        child: ListTile(
                          title: Text(_items[index]),
                        ),
                        feedback: Material(
                          child: Container(
                            width: 200,
                            height: 50,
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                _items[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Drop area
        Expanded(
          child: Container(
            height: 400,
            color: Colors.blue[50],
            child: Column(
              children: [
                Text("Drop here"),
                Expanded(
                  child: DragTarget<String>(
                    onAccept: (item) {
                      setState(() {
                        _droppedItems.add(item);
                        _items.remove(item);
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: candidateData.isNotEmpty 
                            ? Colors.blue.withOpacity(0.2) 
                            : Colors.white,
                          border: Border.all(
                            color: candidateData.isNotEmpty 
                              ? Colors.blue 
                              : Colors.grey,
                            width: candidateData.isNotEmpty ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: _droppedItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_droppedItems[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _items.add(_droppedItems[index]);
                                    _droppedItems.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## Swipe Detection

Detecting swipe gestures in different directions.

### Basic Swipe Detection:

```dart
class SwipeDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  
  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
  });
  
  @override
  State<SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  double _startX = 0;
  double _startY = 0;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _startX = details.globalPosition.dx;
        _startY = details.globalPosition.dy;
      },
      onPanEnd: (details) {
        final endX = details.velocity.pixelsPerSecond.dx;
        final endY = details.velocity.pixelsPerSecond.dy;
        
        const minVelocity = 300.0;
        
        if (endX.abs() > minVelocity || endY.abs() > minVelocity) {
          if (endX.abs() > endY.abs()) {
            // Horizontal swipe
            if (endX > 0) {
              widget.onSwipeRight?.call();
            } else {
              widget.onSwipeLeft?.call();
            }
          } else {
            // Vertical swipe
            if (endY > 0) {
              widget.onSwipeDown?.call();
            } else {
              widget.onSwipeUp?.call();
            }
          }
        }
      },
      child: widget.child,
    );
  }
}

// Usage
SwipeDetector(
  onSwipeLeft: () => print("Swiped left"),
  onSwipeRight: () => print("Swiped right"),
  child: Container(
    width: 200,
    height: 200,
    color: Colors.blue,
    child: Center(child: Text("Swipe me")),
  ),
)
```

### Swipeable Cards:

```dart
class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipedLeft;
  final VoidCallback? onSwipedRight;
  
  const SwipeableCard({
    super.key,
    required this.child,
    this.onSwipedLeft,
    this.onSwipedRight,
  });
  
  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragExtent = 0;
  bool _isDragging = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _controller.stop();
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
    });
  }
  
  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    
    const threshold = 100.0;
    
    if (_dragExtent.abs() > threshold) {
      if (_dragExtent > 0) {
        widget.onSwipedRight?.call();
      } else {
        widget.onSwipedLeft?.call();
      }
      
      // Animate out
      _controller.animateTo(1.0).then((_) {
        // Remove card or handle completion
      });
    } else {
      // Snap back
      setState(() => _dragExtent = 0);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Transform.translate(
        offset: Offset(_dragExtent, 0),
        child: widget.child,
      ),
    );
  }
}
```

---

## Dismissible

Swipe to dismiss widgets.

### Basic Dismissible:

```dart
Dismissible(
  key: Key(item.id),
  direction: DismissDirection.endToStart,
  onDismissed: (direction) {
    // Remove item from list
    setState(() {
      items.remove(item);
    });
  },
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20),
    child: Icon(Icons.delete, color: Colors.white),
  ),
  child: ListTile(
    title: Text(item.title),
  ),
)
```

### Advanced Dismissible:

```dart
class AdvancedDismissible extends StatelessWidget {
  final String item;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  
  const AdvancedDismissible({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onArchive,
  });
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.horizontal,
      
      // Left to right (archive)
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.archive, color: Colors.white),
      ),
      
      // Right to left (delete)
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Confirm delete
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Item'),
              content: Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete'),
                ),
              ],
            ),
          );
        }
        return true;
      },
      
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onArchive();
        }
      },
      
      child: ListTile(
        title: Text(item),
        trailing: Icon(Icons.drag_handle),
      ),
    );
  }
}
```

---

## Focus

Managing keyboard focus and focus traversal.

### Basic Focus:

```dart
class FocusExample extends StatefulWidget {
  @override
  State<FocusExample> createState() => _FocusExampleState();
}

class _FocusExampleState extends State<FocusExample> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  
  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _focusNode1,
          decoration: InputDecoration(labelText: "Field 1"),
          onSubmitted: (value) {
            _focusNode2.requestFocus();
          },
        ),
        
        TextField(
          focusNode: _focusNode2,
          decoration: InputDecoration(labelText: "Field 2"),
        ),
        
        ElevatedButton(
          onPressed: () {
            _focusNode1.requestFocus();
          },
          child: Text("Focus First Field"),
        ),
      ],
    );
  }
}
```

### FocusScope and FocusTraversal:

```dart
class FocusTraversalExample extends StatefulWidget {
  @override
  State<FocusTraversalExample> createState() => _FocusTraversalExampleState();
}

class _FocusTraversalExampleState extends State<FocusTraversalExample> {
  final FocusScopeNode _focusScope = FocusScopeNode();
  
  @override
  void dispose() {
    _focusScope.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScope,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "First Name"),
          ),
          
          TextField(
            decoration: InputDecoration(labelText: "Last Name"),
          ),
          
          TextField(
            decoration: InputDecoration(labelText: "Email"),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              _focusScope.unfocus();
            },
          ),
          
          ElevatedButton(
            onPressed: () {
              _focusScope.nextFocus();
            },
            child: Text("Next Focus"),
          ),
          
          ElevatedButton(
            onPressed: () {
              _focusScope.previousFocus();
            },
            child: Text("Previous Focus"),
          ),
        ],
      ),
    );
  }
}
```

### Custom Focus Order:

```dart
class CustomFocusOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        children: [
          FocusTraversalOrder(
            order: NumericFocusOrder(1),
            child: TextField(
              decoration: InputDecoration(labelText: "First"),
            ),
          ),
          
          FocusTraversalOrder(
            order: NumericFocusOrder(3),
            child: TextField(
              decoration: InputDecoration(labelText: "Third"),
            ),
          ),
          
          FocusTraversalOrder(
            order: NumericFocusOrder(2),
            child: TextField(
              decoration: InputDecoration(labelText: "Second"),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Hover

Detecting mouse hover on desktop platforms.

### Basic Hover:

```dart
class HoverExample extends StatefulWidget {
  @override
  State<HoverExample> createState() => _HoverExampleState();
}

class _HoverExampleState extends State<HoverExample> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 200,
        height: 200,
        color: _isHovered ? Colors.blue : Colors.grey,
        child: Center(
          child: Text(
            _isHovered ? "Hovered!" : "Hover me",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
```

### Advanced Hover Effects:

```dart
class AdvancedHover extends StatefulWidget {
  @override
  State<AdvancedHover> createState() => _AdvancedHoverState();
}

class _AdvancedHoverState extends State<AdvancedHover>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _handleHover(true),
      onExit: (event) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _isHovered ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isHovered ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    _isHovered ? "Hovered!" : "Hover me",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## Custom Gestures

Creating custom gesture recognizers.

### Custom Gesture Recognizer:

```dart
class CustomGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function(Offset) onCustomGesture;
  
  CustomGestureRecognizer({required this.onCustomGesture});
  
  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }
  
  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      // Handle custom gesture logic
    } else if (event is PointerMoveEvent) {
      // Track movement
    } else if (event is PointerUpEvent) {
      // Complete gesture
      onCustomGesture(event.position);
      stopTrackingPointer(event.pointer);
    }
  }
  
  @override
  String get debugDescription => 'custom gesture';
  
  @override
  void didStopTrackingLastPointer(int pointer) {}
}
```

### Using Custom Gesture Recognizer:

```dart
class CustomGestureWidget extends StatefulWidget {
  @override
  State<CustomGestureWidget> createState() => _CustomGestureWidgetState();
}

class _CustomGestureWidgetState extends State<CustomGestureWidget> {
  String _gestureInfo = "Perform custom gesture";
  
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        CustomGestureRecognizer: GestureRecognizerFactoryWithHandlers<CustomGestureRecognizer>(
          () => CustomGestureRecognizer(
            onCustomGesture: (position) {
              setState(() {
                _gestureInfo = "Custom gesture at ${position.dx.toStringAsFixed(1)}, ${position.dy.toStringAsFixed(1)}";
              });
            },
          ),
          (CustomGestureRecognizer instance) {},
        ),
      },
      child: Container(
        width: 300,
        height: 300,
        color: Colors.blue.withOpacity(0.1),
        child: Center(
          child: Text(_gestureInfo),
        ),
      ),
    );
  }
}
```

### Multi-Touch Gesture Recognizer:

```dart
class MultiTouchRecognizer extends MultiTapGestureRecognizer {
  final Function(int) onTapCount;
  
  MultiTouchRecognizer({required this.onTapCount});
  
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
  
  @override
  void acceptGesture(int pointer) {
    super.acceptGesture(pointer);
  }
  
  @override
  void resolve(GestureDisposition disposition) {
    super.resolve(disposition);
  }
}

// Usage
RawGestureDetector(
  gestures: {
    MultiTouchRecognizer: GestureRecognizerFactoryWithHandlers<MultiTouchRecognizer>(
      () => MultiTouchRecognizer(
        onTapCount: (count) {
          print("Multi-touch with $count pointers");
        },
      ),
      (MultiTouchRecognizer instance) {},
    ),
  },
  child: Container(...),
)
```

---

## Accessibility

Making gestures and interactions accessible.

### Semantic Gestures:

```dart
class AccessibleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      enabled: true,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
```

### Gesture Accessibility:

```dart
class AccessibleGestureArea extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? hint;
  
  const AccessibleGestureArea({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.hint,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      hint: hint,
      onTapHint: onTap != null ? "Double tap to activate" : null,
      onLongPressHint: onLongPress != null ? "Long press for more options" : null,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
```

### Focus and Screen Reader Support:

```dart
class AccessibleForm extends StatefulWidget {
  @override
  State<AccessibleForm> createState() => _AccessibleFormState();
}

class _AccessibleFormState extends State<AccessibleForm> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  
  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          label: "Full name",
          hint: "Enter your full name",
          textField: true,
          child: TextField(
            focusNode: _nameFocus,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter your name",
            ),
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              _emailFocus.requestFocus();
            },
          ),
        ),
        
        Semantics(
          label: "Email address",
          hint: "Enter your email address",
          textField: true,
          child: TextField(
            focusNode: _emailFocus,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        
        Semantics(
          label: "Submit form",
          button: true,
          hint: "Double tap to submit the form",
          child: ElevatedButton(
            onPressed: () {
              // Submit form
            },
            child: Text("Submit"),
          ),
        ),
      ],
    );
  }
}
```

---

## Summary

- **GestureDetector**: Comprehensive gesture detection with tap, drag, scale, and custom callbacks
- **InkWell**: Material Design ripple effects and touch feedback with customization
- **Drag and Drop**: Draggable widgets and DragTarget for complex interactions
- **Swipe Detection**: Custom swipe gesture detection in all directions
- **Dismissible**: Swipe-to-dismiss functionality with confirmation dialogs
- **Focus**: Keyboard focus management and focus traversal
- **Hover**: Mouse hover detection for desktop platforms
- **Custom Gestures**: Creating custom gesture recognizers for specialized interactions
- **Accessibility**: Making gestures and interactions accessible to all users

Proper gesture handling creates intuitive and accessible user interfaces.

### Long Press Example:

```dart
GestureDetector(
  onLongPress: () {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        PopupMenuItem(
          child: Text("Delete"),
          value: "delete",
        ),
        PopupMenuItem(
          child: Text("Edit"),
          value: "edit",
        ),
      ],
    );
  },
  child: ListTile(title: Text("Item")),
)
```

---

## InkWell

Visual feedback on tap (Material ink effect).

### Basic Usage:

```dart
InkWell(
  onTap: () {},
  child: Container(
    child: Text("Tap me"),
  ),
)
```

### Customization:

```dart
InkWell(
  onTap: () {},
  splashColor: Colors.blue,
  highlightColor: Colors.lightBlue,
  borderRadius: BorderRadius.circular(8),
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text("Button"),
  ),
)
```

### InkResponse:

```dart
InkResponse(
  onTap: () {},
  radius: 50,
  child: Icon(Icons.favorite),
)
```

---

## Drag and Drop

### Draggable and DragTarget:

```dart
class DragDropExample extends StatefulWidget {
  @override
  State<DragDropExample> createState() => _DragDropExampleState();
}

class _DragDropExampleState extends State<DragDropExample> {
  String? _droppedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Draggable<String>(
          data: "Item 1",
          feedback: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(child: Text("Item 1")),
          ),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(child: Text("Item 1")),
          ),
        ),
        SizedBox(height: 50),
        DragTarget<String>(
          onAccept: (data) {
            setState(() {
              _droppedItem = data;
            });
          },
          onWillAccept: (data) => true,
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 200,
              height: 200,
              color: _droppedItem != null ? Colors.green : Colors.grey,
              child: Center(
                child: _droppedItem != null
                    ? Text(_droppedItem!)
                    : Text("Drop here"),
              ),
            );
          },
        ),
      ],
    );
  }
}
```

---

## Swipe Detection

### Horizontal Swipe:

```dart
class SwipeDetector extends StatefulWidget {
  final Widget child;

  const SwipeDetector({required this.child});

  @override
  State<SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  late Offset _startPosition;
  late Offset _endPosition;

  void _onHorizontalDragStart(DragStartDetails details) {
    _startPosition = details.globalPosition;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _endPosition = details.globalPosition;
    _detectSwipe();
  }

  void _detectSwipe() {
    final distance = _endPosition.dx - _startPosition.dx;
    if (distance > 50) {
      // Swiped right
      print("Swiped right");
    } else if (distance < -50) {
      // Swiped left
      print("Swiped left");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: widget.child,
    );
  }
}
```

---

## Dismissible Widget

Swipe to dismiss.

```dart
Dismissible(
  key: Key(item.id),
  direction: DismissDirection.endToStart,
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20),
    child: Icon(Icons.delete, color: Colors.white),
  ),
  onDismissed: (direction) {
    setState(() {
      items.remove(item);
    });
  },
  child: ListTile(title: Text(item.name)),
)
```

---

## Focus and Hover

### Focus:

```dart
Focus(
  onKey: (node, event) {
    print("Key pressed");
    return KeyEventResult.handled;
  },
  child: TextField(),
)
```

### Hover (Desktop):

```dart
MouseRegion(
  onEnter: (event) {
    print("Hovered");
  },
  onExit: (event) {
    print("Left");
  },
  cursor: SystemMouseCursors.click,
  child: Container(),
)
```

---

## Summary

- **GestureDetector**: Detect all gestures
- **InkWell**: Material tap feedback
- **Draggable/DragTarget**: Drag and drop
- **Dismissible**: Swipe to dismiss
- **Focus**: Keyboard focus
- **MouseRegion**: Desktop hover support
