# Flutter Widget System

## What is a Widget?

A **widget** is the basic building block of Flutter UI. Everything in Flutter is a widget - it's a description of part of the user interface.

### Key Concepts:

1. **Immutable**: Widgets are immutable - once created, they cannot be changed
2. **Declarative**: Describe what the UI should look like for a given state
3. **Composable**: Build complex UIs by combining simple widgets
4. **Lightweight**: Widgets are cheap to create and destroy

### Widget vs Widget Instance:

```dart
// Widget class - blueprint
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('Click me'),
    );
  }
}

// Widget instance - actual object
const myButton = MyButton(); // This is a widget instance
```

### Widget Categories

Flutter widgets can be categorized in several ways:

#### By State Management:
- **StatelessWidget**: No internal state, rebuilds when parent changes
- **StatefulWidget**: Has internal state, can rebuild itself
- **InheritedWidget**: Shares data down the widget tree

#### By Functionality:
- **Layout Widgets**: Control how child widgets are arranged (Container, Row, Column)
- **Display Widgets**: Show content (Text, Image, Icon)
- **Interaction Widgets**: Handle user input (Button, TextField, GestureDetector)
- **Structural Widgets**: Provide structure (Scaffold, AppBar, Drawer)

#### By Material/Cupertino:
- **Material Widgets**: Follow Material Design (ElevatedButton, Card)
- **Cupertino Widgets**: Follow iOS design (CupertinoButton, CupertinoPageScaffold)

---

## Widget Tree

The **widget tree** is the hierarchical structure of all widgets in your app.

### Example Widget Tree:

```
MaterialApp
  ├── Scaffold
  │   ├── AppBar
  │   │   └── Text("Home")
  │   └── Body
  │       └── Column
  │           ├── Container
  │           │   └── Text("Title")
  │           ├── ListView
  │           │   ├── ListTile
  │           │   └── ListTile
  │           └── ElevatedButton
  │               └── Text("Submit")
```

### Visualizing the Tree:

```dart
MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: Text("Home"),
    ),
    body: Column(
      children: [
        Container(
          child: Text("Title"),
        ),
        ListView(
          children: [
            ListTile(title: Text("Item 1")),
            ListTile(title: Text("Item 2")),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Submit"),
        ),
      ],
    ),
  ),
)
```

### Why Widget Tree Matters:

- Determines the layout hierarchy
- Affects how constraints and sizes are calculated
- Used for state management
- Important for performance optimization
- Essential for understanding widget lifecycle

### Widget Tree vs Render Tree

Flutter maintains two separate trees:

1. **Widget Tree**: Immutable configuration objects
2. **Render Tree**: Mutable objects that handle layout and painting

```dart
// Widget Tree (immutable)
Column(
  children: [
    Text('Hello'),
    Text('World'),
  ],
)

// Render Tree (mutable, created by Flutter)
// RenderFlex (Column's render object)
// ├── RenderParagraph (Text's render object)
// └── RenderParagraph (Text's render object)
```

The framework automatically converts widget tree changes into render tree updates.

---

## Build Method

The `build()` method describes what a widget should display.

```dart
@override
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Text('Hello World'),
  );
}
```

### Build Method Rules:

1. **Must return a Widget**: Always return exactly one widget
2. **Can be called frequently**: Framework calls build() often
3. **Should be fast**: Keep build() methods lightweight
4. **Use context**: Access theme, media queries, etc.
5. **No side effects**: Don't modify state or trigger async operations

### Build Context

`BuildContext` provides access to:
- Parent widgets in the tree
- Inherited widgets (Theme, MediaQuery, etc.)
- Navigation and routing
- Widget lifecycle information

```dart
@override
Widget build(BuildContext context) {
  // Access theme
  final theme = Theme.of(context);
  
  // Access screen size
  final size = MediaQuery.of(context).size;
  
  // Access scaffold for snackbars
  final scaffold = Scaffold.of(context);
  
  return Container(
    width: size.width * 0.8,
    color: theme.primaryColor,
    child: Text(
      'Responsive Text',
      style: theme.textTheme.headlineMedium,
    ),
  );
}
```

---

## StatelessWidget

A widget that doesn't have any mutable state.

### When to Use:
- UI depends only on configuration and parent state
- No internal state changes
- Simple, static content
- Performance-critical widgets

### Example:

```dart
class GreetingCard extends StatelessWidget {
  final String name;
  final String message;
  final Color backgroundColor;
  
  const GreetingCard({
    super.key,
    required this.name,
    required this.message,
    this.backgroundColor = Colors.white,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Hello, $name!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}

// Usage
GreetingCard(
  name: 'John',
  message: 'Welcome to Flutter!',
  backgroundColor: Colors.blue.shade50,
)
```

### StatelessWidget Lifecycle:

1. **Constructor**: Widget is created
2. **build()**: Called when widget needs to render
3. **Destruction**: Widget is garbage collected

---

## StatefulWidget

A widget that has mutable state that can change over time.

### When to Use:
- UI changes based on user interaction
- Internal state management needed
- Animation or timer-based updates
- Form inputs and validation

### Basic Structure:

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
    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

### StatefulWidget Lifecycle:

1. **createState()**: Creates associated State object
2. **initState()**: Called once when state is created
3. **didChangeDependencies()**: Called when dependencies change
4. **build()**: Called when widget needs to render
5. **didUpdateWidget()**: Called when widget configuration changes
6. **setState()**: Triggers rebuild with new state
7. **dispose()**: Called when state is destroyed

### Advanced StatefulWidget:

```dart
class UserProfile extends StatefulWidget {
  final String userId;
  
  const UserProfile({super.key, required this.userId});
  
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? _user;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  
  @override
  void didUpdateWidget(covariant UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _loadUser();
    }
  }
  
  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final user = await ApiService.getUser(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (_error != null) {
      return Text('Error: $_error');
    }
    
    return Column(
      children: [
        Text('Name: ${_user?.name}'),
        Text('Email: ${_user?.email}'),
        ElevatedButton(
          onPressed: _loadUser,
          child: const Text('Refresh'),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
```

---

## Widget Keys

Keys help Flutter identify widgets when the widget tree changes.

### Types of Keys:

1. **ValueKey**: Uses a value for identification
2. **ObjectKey**: Uses an object for identification
3. **UniqueKey**: Always unique, forces rebuild
4. **GlobalKey**: Unique across entire app
5. **PageStorageKey**: Preserves scroll position

### When to Use Keys:

- Lists with dynamic content
- Widgets that change position
- Preserving state across rebuilds
- Animations between widgets

### Examples:

```dart
// List with stable keys
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id), // Stable key
      title: Text(items[index].name),
    );
  },
)

// Preserving state
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const ValueKey('email'), // Preserves input
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Submit form
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

---

## InheritedWidget

Shares data down the widget tree without explicitly passing it.

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
    final AppConfig? result = context.dependOnInheritedWidgetOfExactType<AppConfig>();
    assert(result != null, 'No AppConfig found in context');
    return result!;
  }
  
  @override
  bool updateShouldNotify(covariant AppConfig oldWidget) {
    return oldWidget.appName != appName || oldWidget.theme != theme;
  }
}

// Usage
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);
    
    return Text(
      config.appName,
      style: config.theme.textTheme.headlineMedium,
    );
  }
}
```

### Advanced InheritedWidget with Model:

```dart
class UserProvider extends InheritedNotifier<UserModel> {
  final UserModel userModel;
  
  UserProvider({
    super.key,
    required this.userModel,
    required super.child,
  }) : super(notifier: userModel);
  
  static UserModel of(BuildContext context) {
    final UserProvider? provider = context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'No UserProvider found in context');
    return provider!.userModel;
  }
}

class UserModel extends ChangeNotifier {
  User? _user;
  
  User? get user => _user;
  
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

// Usage with Consumer
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        final user = userModel.user;
        return user == null
            ? const Text('No user')
            : Text('Welcome, ${user.name}');
      },
    );
  }
}
```

---

## Custom Widgets

Creating reusable widget components.

### Simple Custom Widget:

```dart
class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  
  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.leading,
    this.trailing,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
```

### Advanced Custom Widget with Builder:

```dart
class ExpandablePanel extends StatefulWidget {
  final String title;
  final WidgetBuilder builder;
  final bool initiallyExpanded;
  
  const ExpandablePanel({
    super.key,
    required this.title,
    required this.builder,
    this.initiallyExpanded = false,
  });
  
  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  late bool _isExpanded;
  
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }
  
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: _toggleExpanded,
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.builder(context),
          ),
      ],
    );
  }
}

// Usage
ExpandablePanel(
  title: 'Advanced Settings',
  builder: (context) => Column(
    children: [
      TextField(decoration: InputDecoration(labelText: 'Setting 1')),
      TextField(decoration: InputDecoration(labelText: 'Setting 2')),
    ],
  ),
)
```

---

## Widget Composition vs Inheritance

### Composition (Preferred):

```dart
class ProfileCard extends StatelessWidget {
  final User user;
  
  const ProfileCard({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          Text(user.name),
          Text(user.email),
          Row(
            children: [
              IconButton(icon: Icon(Icons.message), onPressed: () {}),
              IconButton(icon: Icon(Icons.call), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
```

### Inheritance (Less Common):

```dart
class CustomElevatedButton extends ElevatedButton {
  CustomElevatedButton({
    super.key,
    required super.onPressed,
    required super.child,
    Color? backgroundColor,
  }) : super(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
}
```

---

## Widget Testing

Testing widget behavior and appearance.

### Widget Test Example:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: CounterWidget(),
      ),
    );
    
    // Verify initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    
    // Tap the button
    await tester.tap(find.byIcon(Icons.add));
    
    // Rebuild the widget
    await tester.pump();
    
    // Verify updated state
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

---

## Performance Considerations

### Common Performance Issues:

1. **Unnecessary Rebuilds**: Widgets rebuilding when they don't need to
2. **Expensive Build Methods**: Heavy computations in build()
3. **Deep Widget Trees**: Too many nested widgets
4. **Missing Keys**: Widgets losing state during rebuilds

### Optimization Techniques:

```dart
// Use const constructors
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Text('This widget never rebuilds unnecessarily');
  }
}

// Extract expensive operations
class ExpensiveWidget extends StatelessWidget {
  final String formattedText;
  
  const ExpensiveWidget({super.key, required this.formattedText});
  
  @override
  Widget build(BuildContext context) {
    return Text(formattedText);
  }
}

// Use keys for stable identity
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id),
      title: Text(items[index].name),
    );
  },
);
```

---

## Widget Communication Patterns

### Parent-Child Communication:

```dart
class ParentWidget extends StatefulWidget {
  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  String _message = 'Hello';
  
  void _updateMessage(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_message),
        ChildWidget(onMessageChanged: _updateMessage),
      ],
    );
  }
}

class ChildWidget extends StatelessWidget {
  final ValueChanged<String> onMessageChanged;
  
  const ChildWidget({super.key, required this.onMessageChanged});
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onMessageChanged,
      decoration: const InputDecoration(labelText: 'Enter message'),
    );
  }
}
```

### Global State Communication:

```dart
// Using Provider
class MessageProvider extends ChangeNotifier {
  String _message = 'Hello';
  
  String get message => _message;
  
  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }
}

// Usage
class ConsumerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messageProvider = context.watch<MessageProvider>();
    
    return Column(
      children: [
        Text(messageProvider.message),
        ElevatedButton(
          onPressed: () => messageProvider.updateMessage('New message'),
          child: const Text('Update'),
        ),
      ],
    );
  }
}
```

---

## Advanced Widget Concepts

### Multi-Child Widgets:

```dart
class CustomLayout extends StatelessWidget {
  final List<Widget> children;
  
  const CustomLayout({super.key, required this.children});
  
  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: MyLayoutDelegate(),
      children: children.map((child) {
        return LayoutId(
          id: children.indexOf(child),
          child: child,
        );
      }).toList(),
    );
  }
}

class MyLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // Custom layout logic
    if (hasChild(0)) {
      layoutChild(0, BoxConstraints.loose(size));
      positionChild(0, Offset.zero);
    }
    
    if (hasChild(1)) {
      layoutChild(1, BoxConstraints.loose(size));
      positionChild(1, const Offset(100, 100));
    }
  }
  
  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}
```

### Render Objects:

```dart
class CustomRenderObject extends RenderBox {
  @override
  void performLayout() {
    size = constraints.constrain(Size(100, 100));
  }
  
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final paint = Paint()..color = Colors.blue;
    
    canvas.drawRect(
      Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
      paint,
    );
  }
}

class CustomWidget extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRenderObject();
  }
}
```

---

## Summary

- **Widgets**: Immutable building blocks of Flutter UI
- **Widget Tree**: Hierarchical structure of all widgets
- **StatelessWidget**: No internal state, rebuilds when parent changes
- **StatefulWidget**: Has internal state, can rebuild itself
- **Build Method**: Describes what widget should display
- **Keys**: Help identify widgets during tree changes
- **InheritedWidget**: Shares data down the widget tree
- **Composition**: Preferred over inheritance for widget reuse
- **Performance**: Optimize rebuilds and expensive operations
- **Testing**: Verify widget behavior and appearance

Understanding the widget system is fundamental to building effective Flutter applications.
Widget build(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Text("Hello"),
  );
}
```

### Important Rules:

1. **Must return a Widget**
2. **Should be pure** - returns the same output for same input
3. **Can be called multiple times** - must be efficient
4. **Accessed via BuildContext**

### BuildContext

`BuildContext` is a handle to the location of a widget in the widget tree.

```dart
@override
Widget build(BuildContext context) {
  // Access theme
  final theme = Theme.of(context);
  
  // Access screen size
  final screenSize = MediaQuery.of(context).size;
  
  // Navigate
  Navigator.push(context, MaterialPageRoute(...));
  
  // Show dialogs
  showDialog(context: context, builder: ...);
  
  // Access inherited widgets
  final appState = Provider.of<AppState>(context);
}
```

### BuildContext Example:

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Title")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SecondPage()),
                );
              },
              child: Text("Go to Next Page"),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## StatelessWidget

A **StatelessWidget** is a widget that doesn't have mutable state - it can only be updated by rebuilding.

### Characteristics:
- Immutable
- No setState() method
- Rebuilds only when parent rebuilds
- Lightweight and efficient
- Used for static UI

### Example:

```dart
class GreetingCard extends StatelessWidget {
  final String name;
  final String message;

  const GreetingCard({
    Key? key,
    required this.name,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Hello, $name!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}

// Usage
GreetingCard(
  name: "John",
  message: "Welcome to Flutter!",
)
```

### When to Use:
- Static content
- Display-only widgets
- Receiving data through constructor parameters
- No internal state management needed

---

## StatefulWidget

A **StatefulWidget** is a widget with mutable state - it can update itself and rebuild.

### Characteristics:
- Mutable state via State class
- Has setState() method
- Can rebuild itself
- More complex than StatelessWidget
- Used for interactive UI

### Example:

```dart
class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Count: $count",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: decrement,
              child: Text("-"),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: increment,
              child: Text("+"),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Key Methods:

```dart
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  
  // Called when widget is inserted into tree
  @override
  void initState() {
    super.initState();
    // Initialize state variables
    // Load data
    // Set up listeners
  }

  // Called when widget configuration changes
  @override
  void didUpdateWidget(MyStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // React to changes in parent widget
  }

  // Called when State is removed from tree
  @override
  void deactivate() {
    super.deactivate();
    // Clean up resources
  }

  // Called after deactivate
  @override
  void dispose() {
    super.dispose();
    // Clean up final resources
    // Cancel subscriptions
    // Dispose controllers
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### setState()

`setState()` marks the widget as needing to rebuild.

```dart
setState(() {
  // Update state variables
  counter++;
  isEnabled = !isEnabled;
  items.add("new item");
}); // This triggers rebuild
```

**Important:** setState() only works in StatefulWidget, not StatelessWidget.

---

## Widget Lifecycle

The lifecycle of a StatefulWidget:

### 1. **Creation Phase**

```dart
// Widget is created
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}
```

### 2. **Mounting Phase**

```dart
class _CounterState extends State<Counter> {
  
  @override
  void initState() {
    print("initState called - widget is mounted");
    super.initState();
    // Called once, after build() first time
    // Use for initialization
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    // Called whenever widget needs to rebuild
    return Container();
  }
}
```

### 3. **Updating Phase**

```dart
class _CounterState extends State<Counter> {
  
  @override
  void didUpdateWidget(Counter oldWidget) {
    print("didUpdateWidget called");
    super.didUpdateWidget(oldWidget);
    // Called when parent widget changes
  }

  @override
  void setState(VoidCallback fn) {
    print("setState called - triggering rebuild");
    // Called when state changes
    super.setState(fn);
  }
}
```

### 4. **Unmounting Phase**

```dart
class _CounterState extends State<Counter> {
  
  @override
  void deactivate() {
    print("deactivate called");
    super.deactivate();
    // Widget removed from tree
  }

  @override
  void dispose() {
    print("dispose called - widget destroyed");
    super.dispose();
    // Clean up resources
    // Cancel subscriptions
    // Dispose controllers
  }
}
```

### Complete Lifecycle Example:

```dart
class LifecycleExample extends StatefulWidget {
  @override
  State<LifecycleExample> createState() => _LifecycleExampleState();
}

class _LifecycleExampleState extends State<LifecycleExample> {
  late TextEditingController _controller;

  @override
  void initState() {
    print("1. initState");
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      print("Text changed: ${_controller.text}");
    });
  }

  @override
  void didUpdateWidget(LifecycleExample oldWidget) {
    print("2. didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("3. dispose");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("4. build");
    return Scaffold(
      appBar: AppBar(title: Text("Lifecycle Demo")),
      body: TextField(controller: _controller),
    );
  }
}
```

### Lifecycle Flow Diagram:

```
StatefulWidget Created
        ↓
   createState()
        ↓
   initState()
        ↓
   build()
        ↓
   MOUNTED (User can see widget)
        ↓
  (User interaction or parent update)
        ↓
  setState() or didUpdateWidget()
        ↓
   build() - Rebuilds with new state
        ↓
  (Widget removed from tree)
        ↓
   deactivate()
        ↓
   dispose() - Cleanup
        ↓
   DESTROYED
```

---

## Summary

- **Widgets** are immutable descriptions of UI
- **Widget Tree** is the hierarchical structure of all widgets
- **build()** method returns the widget's UI description
- **BuildContext** provides access to contextual information
- **StatelessWidget** has no mutable state
- **StatefulWidget** has mutable state via State class
- **Lifecycle** includes initState, build, setState, and dispose stages
- Understand the lifecycle for proper resource management
