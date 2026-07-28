# Flutter Navigation & Routing

Navigation is how users move between different screens in your app.

---

## Navigator (Basic Navigation)

The Navigator widget manages a stack of Route objects.

### push() - Go to Next Screen:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondScreen()),
);
```

### pop() - Go Back:

```dart
Navigator.pop(context);
```

### Complete Example:

```dart
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Screen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );
          },
          child: Text("Go to Second Screen"),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Go Back"),
        ),
      ),
    );
  }
}
```

### Navigation Stack Visualization:

```
Navigation Stack:
┌──────────────┐
│ SecondScreen │  ← Top (visible)
├──────────────┤
│ FirstScreen  │  ← Bottom (hidden)
├──────────────┤
│ App Root     │
└──────────────┘

push()  → Adds to top
pop()   → Removes from top
```

### Multiple Navigation:

```dart
// Navigate: Home → Profile → Settings
Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));

// Stack: [App, Home, Profile, Settings]
// pop() returns to Profile
// pop() returns to Home
```

---

## Named Routes

Define routes in a central location for better organization.

### Define Routes:

```dart
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomeScreen(),
      '/profile': (context) => ProfileScreen(),
      '/settings': (context) => SettingsScreen(),
      '/about': (context) => AboutScreen(),
    },
  ));
}
```

### Navigate with Named Routes:

```dart
// Push named route
Navigator.pushNamed(context, '/profile');

// Push with arguments
Navigator.pushNamed(
  context,
  '/profile',
  arguments: {'userId': 123, 'showEdit': true},
);

// Replace current route
Navigator.pushReplacementNamed(context, '/login');

// Pop to named route
Navigator.popUntil(context, ModalRoute.withName('/'));

// Push and remove until
Navigator.pushNamedAndRemoveUntil(
  context,
  '/home',
  (route) => false,  // Remove all previous routes
);
```

### Access Route Arguments:

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userId = args?['userId'] as int?;
    final showEdit = args?['showEdit'] as bool? ?? false;
    
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Text('User ID: $userId, Edit: $showEdit'),
      ),
    );
  }
}
```

### Route Generation:

```dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      
      case '/profile':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: args?['userId']),
        );
      
      case '/product':
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductScreen(productId: productId),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}

// Usage in MaterialApp
MaterialApp(
  onGenerateRoute: AppRouter.generateRoute,
  // ... other properties
)
```

---

## Data Passing Between Screens

### Constructor Parameters:

```dart
class UserDetailScreen extends StatelessWidget {
  final User user;
  final bool showEditButton;
  
  const UserDetailScreen({
    super.key,
    required this.user,
    this.showEditButton = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Column(
        children: [
          Text('Email: ${user.email}'),
          Text('Phone: ${user.phone}'),
          if (showEditButton)
            ElevatedButton(
              onPressed: () => _editUser(context),
              child: Text('Edit'),
            ),
        ],
      ),
    );
  }
  
  void _editUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: user),
      ),
    );
  }
}
```

### Returning Data from Screens:

```dart
class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Item')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Item 1'),
            onTap: () => Navigator.pop(context, 'Item 1'),
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () => Navigator.pop(context, 'Item 2'),
          ),
        ],
      ),
    );
  }
}

// Usage
class HomeScreen extends StatelessWidget {
  Future<void> _selectItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );
    
    if (result != null) {
      print('Selected: $result');
      // Handle selection
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _selectItem(context),
          child: Text('Select Item'),
        ),
      ),
    );
  }
}
```

### Provider/State Management for Data:

```dart
class UserProvider extends ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  
  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}

// Navigation with shared state
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: userProvider.currentUser != null
          ? UserDetails(user: userProvider.currentUser!)
          : Center(child: Text('No user selected')),
    );
  }
}
```

---

## Custom Transitions

### Fade Transition:

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SecondScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
```

### Slide Transition:

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SecondScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);  // From right
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  ),
);
```

### Scale Transition:

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SecondScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
        ),
        child: child,
      );
    },
  ),
);
```

### Rotation Transition:

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SecondScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return RotationTransition(
        turns: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
        ),
        child: child,
      );
    },
  ),
);
```

### Hero Animation:

```dart
// First screen
Hero(
  tag: 'hero-tag',
  child: Image.network('https://example.com/image.jpg'),
)

// Second screen
Hero(
  tag: 'hero-tag',
  child: Image.network('https://example.com/image.jpg'),
)
```

### Custom Route Classes:

```dart
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}

// Usage
Navigator.push(context, FadeRoute(page: SecondScreen()));
```

---

## Bottom Navigation

### Basic BottomNavigationBar:

```dart
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
```

### BottomNavigationBar with Navigation:

```dart
class AppNavigator extends StatefulWidget {
  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;
  
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Navigator(
            key: _navigatorKeys[0],
            onGenerateRoute: (route) => MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          ),
          Navigator(
            key: _navigatorKeys[1],
            onGenerateRoute: (route) => MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          ),
          Navigator(
            key: _navigatorKeys[2],
            onGenerateRoute: (route) => MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

---

## Drawer Navigation

### Basic Drawer:

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('App Name', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Home Screen')),
    );
  }
}
```

### Drawer with Navigation:

```dart
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('john@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          
          Divider(),
          
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
  
  void _logout(BuildContext context) {
    // Logout logic
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
```

---

## Tab Navigation

### Basic TabBar:

```dart
class TabbedScreen extends StatefulWidget {
  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.search), text: 'Search'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeTab(),
          SearchTab(),
          ProfileTab(),
        ],
      ),
    );
  }
}
```

### Nested Tabs:

```dart
class NestedTabsScreen extends StatefulWidget {
  @override
  _NestedTabsScreenState createState() => _NestedTabsScreenState();
}

class _NestedTabsScreenState extends State<NestedTabsScreen>
    with TickerProviderStateMixin {
  
  late TabController _mainTabController;
  late TabController _subTabController;
  
  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _subTabController = TabController(length: 3, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nested Tabs'),
        bottom: TabBar(
          controller: _mainTabController,
          tabs: [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          // Tab 1 content
          Column(
            children: [
              TabBar(
                controller: _subTabController,
                tabs: [
                  Tab(text: 'Sub 1'),
                  Tab(text: 'Sub 2'),
                  Tab(text: 'Sub 3'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _subTabController,
                  children: [
                    Center(child: Text('Sub Tab 1')),
                    Center(child: Text('Sub Tab 2')),
                    Center(child: Text('Sub Tab 3')),
                  ],
                ),
              ),
            ],
          ),
          // Tab 2 content
          Center(child: Text('Tab 2 Content')),
        ],
      ),
    );
  }
}
```

---

## Deep Linking

### Basic Deep Linking:

```dart
void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => HomeScreen(),
      '/product': (context) => ProductScreen(),
      '/profile': (context) => ProfileScreen(),
    },
    onGenerateRoute: (settings) {
      // Handle dynamic routes
      if (settings.name?.startsWith('/product/') == true) {
        final productId = settings.name!.split('/').last;
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(productId: productId),
        );
      }
      return null;
    },
  ));
}
```

### Advanced Deep Linking with uni_links:

```dart
// pubspec.yaml
dependencies:
  uni_links: ^0.5.1

// main.dart
import 'package:uni_links/uni_links.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  
  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }
  
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Deep link error: $err');
    });
  }
  
  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (err) {
      print('Initial URI error: $err');
    }
  }
  
  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.isNotEmpty) {
      final path = uri.pathSegments.first;
      switch (path) {
        case 'product':
          if (uri.pathSegments.length > 1) {
            final productId = uri.pathSegments[1];
            Navigator.pushNamed(
              context,
              '/product',
              arguments: {'productId': productId},
            );
          }
          break;
        case 'profile':
          Navigator.pushNamed(context, '/profile');
          break;
      }
    }
  }
  
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ... routes
    );
  }
}
```

---

## Navigation Guards

### Route Protection:

```dart
class AuthGuard extends StatelessWidget {
  final Widget child;
  
  const AuthGuard({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.data == true) {
          return child;
        } else {
          return LoginScreen();
        }
      },
    );
  }
  
  Future<bool> _checkAuthStatus() async {
    // Check authentication status
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

// Usage in routes
MaterialApp(
  routes: {
    '/': (context) => AuthGuard(child: HomeScreen()),
    '/profile': (context) => AuthGuard(child: ProfileScreen()),
  },
)
```

### Route Middleware:

```dart
class RouteMiddleware {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Check authentication
    if (_requiresAuth(settings.name) && !_isAuthenticated()) {
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
    
    // Check permissions
    if (!_hasPermission(settings.name)) {
      return MaterialPageRoute(builder: (_) => PermissionDeniedScreen());
    }
    
    // Generate route
    return AppRouter.generateRoute(settings);
  }
  
  static bool _requiresAuth(String? routeName) {
    return ['/profile', '/settings'].contains(routeName);
  }
  
  static bool _isAuthenticated() {
    // Check auth status
    return true; // Placeholder
  }
  
  static bool _hasPermission(String? routeName) {
    // Check permissions
    return true; // Placeholder
  }
}
```

---

## Navigation History and State

### Navigation Observer:

```dart
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('Pushed: ${route.settings.name}');
  }
  
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped: ${route.settings.name}');
  }
  
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}

// Usage
MaterialApp(
  navigatorObservers: [AppNavigatorObserver()],
  // ... other properties
)
```

### Route Aware Widgets:

```dart
class RouteAwareWidget extends StatefulWidget {
  @override
  _RouteAwareWidgetState createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget>
    with RouteAware {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }
  
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
  
  @override
  void didPush() {
    // Called when this route is pushed
    print('Route pushed');
  }
  
  @override
  void didPopNext() {
    // Called when next route is popped, revealing this route
    print('Next route popped');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Route Aware')));
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
```

---

## Summary

- **Basic Navigation**: push(), pop(), MaterialPageRoute
- **Named Routes**: Central route definitions, arguments passing
- **Data Passing**: Constructor parameters, return values, shared state
- **Custom Transitions**: Fade, slide, scale, rotation, hero animations
- **Bottom Navigation**: Tab-based navigation with state preservation
- **Drawer Navigation**: Side menu navigation
- **Tab Navigation**: Horizontal tab navigation
- **Deep Linking**: Handle external links and app URLs
- **Navigation Guards**: Route protection and middleware
- **Navigation History**: Observers and route-aware widgets

Choose the appropriate navigation pattern based on your app's complexity and user experience requirements.

## Routes and Navigation Stack

### Understanding the Stack:

```
Navigation Stack:
┌──────────────┐
│ SecondScreen │  ← Top (visible)
├──────────────┤
│ FirstScreen  │  ← Bottom (hidden)
├──────────────┤
│ App Root     │
└──────────────┘

push()  → Adds to top
pop()   → Removes from top
```

### Multiple pushes:

```dart
// Navigate: Home → Profile → Settings
Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
Navigator.push(context, MaterialPageRoute(builder: (_) => Settings()));

// Stack: [App, Home, Profile, Settings]
// pop() returns to Profile
// pop() returns to Home
```

### pushReplacement() - Replace Current Screen:

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
// Doesn't leave the old screen in the stack
```

### popUntil() - Pop Multiple Screens:

```dart
Navigator.popUntil(context, (route) => route.isFirst);
// Pops all screens until first screen

// More specific:
Navigator.popUntil(
  context,
  ModalRoute.withName('/home'),
);
```

---

## Named Routes

Better organization with named routes instead of anonymous routes.

### Define Routes:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/details': (context) => const DetailsPage(),
      },
      home: const HomePage(),
    );
  }
}
```

### Navigate Using Named Routes:

```dart
// Push
Navigator.pushNamed(context, '/profile');

// Push Replacement
Navigator.pushReplacementNamed(context, '/profile');

// Remove all routes and go to new one
Navigator.pushNamedAndRemoveUntil(
  context,
  '/profile',
  (route) => false,
);
```

### OnGenerateRoute (Dynamic Routes):

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Handle dynamic routes
        if (settings.name == '/user') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => UserPage(userId: userId),
          );
        }
        // Return not found page
        return MaterialPageRoute(
          builder: (context) => NotFoundPage(),
        );
      },
    );
  }
}

// Navigate
Navigator.pushNamed(context, '/user', arguments: '123');
```

---

## Passing Data Between Screens

### Pass Data Forward:

```dart
// Send data to next screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SecondScreen(name: "John"),
  ),
);

class SecondScreen extends StatelessWidget {
  final String name;
  
  const SecondScreen({required this.name});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Hello $name")),
    );
  }
}
```

### Pass Data Back:

```dart
// First Screen - send and receive
class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result),
            ElevatedButton(
              onPressed: () async {
                final data = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(),
                  ),
                );
                if (data != null) {
                  setState(() {
                    result = data;
                  });
                }
              },
              child: Text("Go to Second"),
            ),
          ],
        ),
      ),
    );
  }
}

// Second Screen - return data
class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, "Data from Second Screen");
          },
          child: Text("Go Back with Data"),
        ),
      ),
    );
  }
}
```

### With Named Routes:

```dart
// Define route
routes: {
  '/user': (context) => UserPage(),
}

// Navigate with arguments
Navigator.pushNamed(
  context,
  '/user',
  arguments: {'userId': 123, 'name': 'John'},
);

// Receive
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      body: Center(child: Text("User: ${args['name']}")),
    );
  }
}
```

---

## Page Routes and Transitions

### MaterialPageRoute:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SecondScreen(),
    fullscreenDialog: true,  // Animation from bottom
  ),
);
```

### CupertinoPageRoute (iOS-style):

```dart
Navigator.push(
  context,
  CupertinoPageRoute(
    builder: (context) => SecondScreen(),
  ),
);
```

### Custom Transition:

```dart
Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);  // Bottom
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 500),
  );
}

// Use
Navigator.push(context, _createRoute(SecondScreen()));
```

### Fade Transition:

```dart
Route _createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
```

### Scale Transition:

```dart
Route _createScaleRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(scale: animation, child: child);
    },
  );
}
```

---

## Route Management

### Checking if Route is First:

```dart
bool isFirst = Navigator.of(context).canPop() == false;
```

### Custom Navigation Logic:

```dart
if (Navigator.canPop(context)) {
  Navigator.pop(context);
} else {
  // Exit app
  SystemNavigator.pop();
}
```

### Nested Navigation (Bottom Navigation):

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Navigator(
              key: _navigatorKeys[0],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => HomePage(),
                );
              },
            ),
            Navigator(
              key: _navigatorKeys[1],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => SearchPage(),
                );
              },
            ),
            Navigator(
              key: _navigatorKeys[2],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
```

---

## Deep Linking

Navigating to a specific part of the app via URL.

### Configure Deep Links:

```dart
// main.dart
MaterialApp(
  onGenerateRoute: (settings) {
    if (settings.name == '/product') {
      final productId = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => ProductPage(productId: productId),
      );
    }
    return MaterialPageRoute(builder: (context) => HomePage());
  },
)
```

### Handle Deep Links (Android):

```xml
<!-- AndroidManifest.xml -->
<activity
    android:name=".MainActivity"
    android:launchMode="singleTop">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="https"
            android:host="example.com"
            android:pathPrefix="/product" />
    </intent-filter>
</activity>
```

---

## Summary

- **push()**: Navigate to new screen
- **pop()**: Go back to previous screen
- **pushReplacement()**: Replace current screen
- **Named routes**: Better organization
- **Pass data**: Forward and backward
- **Page routes**: Different transition animations
- **Route management**: Control navigation stack
- Use deep linking for URLs
