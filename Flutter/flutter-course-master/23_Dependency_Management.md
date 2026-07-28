# Flutter Dependency Management

Managing packages and dependencies in Flutter applications.

---

## pub.dev Ecosystem

Official package repository for Dart and Flutter.

### Package Discovery and Evaluation:

```dart
// Search strategies
// 1. Direct search on pub.dev
// 2. GitHub trending Flutter repositories
// 3. Flutter community forums and Discord
// 4. Stack Overflow trending questions
// 5. Official Flutter documentation recommendations
```

### Package Quality Assessment:

```dart
// Quality checklist
class PackageEvaluator {
  static const int MIN_LIKES = 100;
  static const int MIN_POPULARITY = 50;
  static const Duration MAX_LAST_UPDATE = Duration(days: 365);
  
  static bool isPackageReliable(PackageInfo package) {
    return package.likes >= MIN_LIKES &&
           package.popularity >= MIN_POPULARITY &&
           package.lastUpdated.difference(DateTime.now()) < MAX_LAST_UPDATE &&
           package.hasDocumentation &&
           package.supportsNullSafety;
  }
  
  static double calculatePackageScore(PackageInfo package) {
    double score = 0;
    
    // Popularity weight: 40%
    score += (package.likes / 1000) * 40;
    
    // Maintenance weight: 30%
    final daysSinceUpdate = package.lastUpdated.difference(DateTime.now()).inDays;
    final maintenanceScore = max(0, 30 - (daysSinceUpdate / 12));
    score += maintenanceScore;
    
    // Documentation weight: 20%
    score += package.hasDocumentation ? 20 : 0;
    
    // Community weight: 10%
    score += (package.issuesCount == 0) ? 10 : max(0, 10 - (package.issuesCount / 10));
    
    return min(100, score);
  }
}
```

### Platform Support Matrix:

```dart
enum Platform { android, ios, web, windows, macos, linux }

class PlatformSupport {
  static const Set<Platform> mobileOnly = {Platform.android, Platform.ios};
  static const Set<Platform> desktopOnly = {Platform.windows, Platform.macos, Platform.linux};
  static const Set<Platform> webOnly = {Platform.web};
  static const Set<Platform> allPlatforms = {
    Platform.android, Platform.ios, Platform.web,
    Platform.windows, Platform.macos, Platform.linux
  };
  
  static bool supportsTargetPlatforms(Set<Platform> packagePlatforms, Set<Platform> targetPlatforms) {
    return targetPlatforms.every((platform) => packagePlatforms.contains(platform));
  }
  
  static List<String> getMissingPlatforms(Set<Platform> packagePlatforms, Set<Platform> targetPlatforms) {
    return targetPlatforms
        .where((platform) => !packagePlatforms.contains(platform))
        .map((platform) => platform.name)
        .toList();
  }
}
```

---

## Advanced pubspec.yaml Configuration

Comprehensive dependency management.

### Complete pubspec.yaml Structure:

```yaml
name: advanced_flutter_app
description: A production-ready Flutter application with comprehensive dependency management
version: 1.0.0+1
homepage: https://github.com/yourusername/advanced_flutter_app
repository: https://github.com/yourusername/advanced_flutter_app
issue_tracker: https://github.com/yourusername/advanced_flutter_app/issues
documentation: https://github.com/yourusername/advanced_flutter_app#readme

publish_to: 'none' # Remove this line if you wish to publish to pub.dev

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter

  # Core Flutter packages
  cupertino_icons: ^1.0.2
  
  # State Management
  flutter_riverpod: ^2.3.6
  flutter_bloc: ^8.1.3
  
  # Networking
  dio: ^5.3.2
  http: ^1.1.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # UI Enhancement
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.7
  google_fonts: ^4.0.4
  flutter_screenutil: ^5.9.0
  
  # Navigation
  go_router: ^10.1.2
  
  # Utilities
  intl: ^0.18.1
  uuid: ^3.0.7
  path_provider: ^2.1.1
  url_launcher: ^6.1.14
  share_plus: ^7.2.2
  package_info_plus: ^4.1.0
  
  # Platform Integration
  camera: ^0.10.5+5
  image_picker: ^1.0.4
  geolocator: ^10.1.0
  permission_handler: ^11.0.1
  
  # Development Tools
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
    
  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.4
  integration_test:
    sdk: flutter
    
  # Code Quality
  flutter_lints: ^2.0.3
  dart_code_metrics: ^5.7.6
  
  # Development
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  go_router_builder: ^2.3.2

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - assets/config/
    
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700
          
  # Plugin configurations
  plugin:
    platforms:
      android:
        package: com.example.advanced_flutter_app
        pluginClass: AdvancedFlutterAppPlugin
      ios:
        pluginClass: AdvancedFlutterAppPlugin
        
# Dependency overrides (use with caution)
dependency_overrides:
  # Only use when necessary for compatibility
  # analyzer: ^5.13.0
  
# Flutter configuration
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icons/app_icon.png"
  min_sdk_android: 21
  
flutter_native_splash:
  color: "#ffffff"
  image: assets/images/splash_logo.png
  android: true
  ios: true
```

### Version Constraints Explained:

```dart
class VersionConstraintGuide {
  // Version ranges
  static const String caretSyntax = '^1.2.3'; // >=1.2.3 <2.0.0
  static const String tildeSyntax = '~1.2.3'; // >=1.2.3 <1.3.0
  static const String exactVersion = '1.2.3'; // Exactly 1.2.3
  static const String rangeSyntax = '>=1.0.0 <2.0.0'; // Between versions
  
  // Best practices
  static const List<String> recommendedConstraints = [
    '^major.minor.patch', // For stable packages
    '>=1.0.0 <2.0.0', // For major version ranges
    'any', // Only for development dependencies
  ];
  
  static bool isVersionConstraintSafe(String constraint) {
    // Avoid overly broad constraints
    if (constraint == 'any') return false;
    
    // Prefer caret syntax for stability
    if (!constraint.startsWith('^') && !constraint.contains('>=')) {
      return false;
    }
    
    return true;
  }
}
```

### Conditional Dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
    
  # Platform-specific dependencies
  platform_specific_package:
    git:
      url: https://github.com/example/platform_specific_package.git
      ref: main
      path: platform_specific_package
      
  # Environment-specific dependencies
  dev_dependencies:
    flutter_test:
      sdk: flutter
      
    # Only for Android development
    flutter_driver:
      sdk: flutter
      version: ^0.0.0 # Only when testing on Android
      
# Platform-specific configuration
flutter:
  plugin:
    platforms:
      android:
        default_package: platform_specific_package
      ios:
        default_package: platform_specific_package
```

---

## Package Integration Patterns

Best practices for integrating third-party packages.

### Service Integration Layer:

```dart
// services/package_integrator.dart
class PackageIntegrator {
  static const String _packageVersion = '1.0.0';
  
  static Future<void> initializePackages() async {
    await _initializeStorage();
    await _initializeNetworking();
    await _initializePlatformServices();
    await _initializeUIEnhancements();
  }
  
  static Future<void> _initializeStorage() async {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    
    // Initialize SQLite
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app_database.db');
    
    await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT)');
      },
    );
  }
  
  static Future<void> _initializeNetworking() async {
    // Configure Dio
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    ]);
    
    // Register Dio instance
    GetIt.I.registerSingleton<Dio>(dio);
  }
  
  static Future<void> _initializePlatformServices() async {
    // Request permissions
    await Permission.camera.request();
    await Permission.location.request();
    
    // Initialize location service
    await Geolocator.requestPermission();
  }
  
  static Future<void> _initializeUIEnhancements() async {
    // Preload fonts
    await GoogleFonts.pendingFonts([
      GoogleFonts.roboto(),
      GoogleFonts.openSans(),
    ]);
    
    // Configure screen util
    await ScreenUtil.ensureScreenSize();
  }
  
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  static String getPackageInfo() {
    return 'PackageIntegrator v$_packageVersion';
  }
}
```

### Repository Pattern for Package Abstraction:

```dart
// repositories/package_repository.dart
abstract class PackageRepository {
  Future<void> initialize();
  Future<void> dispose();
  bool get isInitialized;
  String get version;
}

// repositories/package_repository_impl.dart
class PackageRepositoryImpl implements PackageRepository {
  bool _isInitialized = false;
  
  @override
  bool get isInitialized => _isInitialized;
  
  @override
  String get version => '1.0.0';
  
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await PackageIntegrator.initializePackages();
      _isInitialized = true;
    } catch (e) {
      throw PackageInitializationException('Failed to initialize packages: $e');
    }
  }
  
  @override
  Future<void> dispose() async {
    // Clean up resources
    await Hive.close();
    _isInitialized = false;
  }
}

class PackageInitializationException implements Exception {
  final String message;
  PackageInitializationException(this.message);
  
  @override
  String toString() => 'PackageInitializationException: $message';
}
```

### Error Handling for Package Operations:

```dart
// errors/package_errors.dart
class PackageError extends Error {
  final String packageName;
  final String operation;
  final dynamic originalError;
  
  PackageError(this.packageName, this.operation, this.originalError);
  
  @override
  String toString() {
    return 'PackageError: $packageName failed during $operation: $originalError';
  }
}

class PackageErrorHandler {
  static void handleError(dynamic error, String packageName, String operation) {
    if (error is PackageError) {
      _logPackageError(error);
      _handlePackageSpecificError(error);
    } else {
      final packageError = PackageError(packageName, operation, error);
      _logPackageError(packageError);
      _handleGenericError(packageError);
    }
  }
  
  static void _logPackageError(PackageError error) {
    // Log to analytics service
    FirebaseCrashlytics.instance.recordError(
      error,
      error.stackTrace,
      reason: 'Package operation failed',
    );
    
    // Log to local logger
    Logger().e('Package Error: ${error.toString()}');
  }
  
  static void _handlePackageSpecificError(PackageError error) {
    switch (error.packageName) {
      case 'hive':
        _handleHiveError(error);
        break;
      case 'dio':
        _handleDioError(error);
        break;
      case 'shared_preferences':
        _handleSharedPreferencesError(error);
        break;
      default:
        _handleGenericError(error);
    }
  }
  
  static void _handleHiveError(PackageError error) {
    // Handle Hive-specific errors
    if (error.operation == 'openBox') {
      // Try to repair or recreate box
    }
  }
  
  static void _handleDioError(PackageError error) {
    // Handle network-specific errors
    if (error.originalError is DioException) {
      final dioError = error.originalError as DioException;
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          // Handle timeout
          break;
        case DioExceptionType.receiveTimeout:
          // Handle receive timeout
          break;
        case DioExceptionType.badResponse:
          // Handle HTTP errors
          break;
        default:
          break;
      }
    }
  }
  
  static void _handleSharedPreferencesError(PackageError error) {
    // Handle SharedPreferences errors
    // Usually indicates platform-specific issues
  }
  
  static void _handleGenericError(PackageError error) {
    // Show user-friendly error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred. Please try again.'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => _retryOperation(error),
        ),
      ),
    );
  }
  
  static void _retryOperation(PackageError error) {
    // Implement retry logic based on error type
  }
}
```

---

## Security Considerations

Securing package usage and dependencies.

### Package Vulnerability Scanning:

```dart
// security/package_scanner.dart
class PackageSecurityScanner {
  static const List<String> _knownVulnerablePackages = [
    'old_package: <1.0.0',
    'insecure_http: any',
  ];
  
  static Future<SecurityReport> scanDependencies() async {
    final pubspecContent = await _readPubspecFile();
    final dependencies = _parseDependencies(pubspecContent);
    
    final vulnerabilities = <Vulnerability>[];
    final warnings = <String>[];
    
    for (final dependency in dependencies) {
      // Check for known vulnerabilities
      if (_isKnownVulnerable(dependency)) {
        vulnerabilities.add(Vulnerability(
          package: dependency.name,
          version: dependency.version,
          severity: Severity.high,
          description: 'Known security vulnerability',
        ));
      }
      
      // Check version constraints
      if (_hasInsecureVersionConstraint(dependency)) {
        warnings.add('${dependency.name}: Insecure version constraint');
      }
      
      // Check for unmaintained packages
      if (await _isPackageUnmaintained(dependency)) {
        warnings.add('${dependency.name}: Package appears unmaintained');
      }
    }
    
    return SecurityReport(
      vulnerabilities: vulnerabilities,
      warnings: warnings,
      scanDate: DateTime.now(),
    );
  }
  
  static bool _isKnownVulnerable(DependencyInfo dependency) {
    return _knownVulnerablePackages.any((vulnerable) =>
        vulnerable.startsWith('${dependency.name}:'));
  }
  
  static bool _hasInsecureVersionConstraint(DependencyInfo dependency) {
    return dependency.version == 'any' ||
           dependency.version.contains('>=');
  }
  
  static Future<bool> _isPackageUnmaintained(DependencyInfo dependency) async {
    try {
      final packageInfo = await _fetchPackageInfo(dependency.name);
      final lastUpdate = packageInfo.lastUpdated;
      final daysSinceUpdate = DateTime.now().difference(lastUpdate).inDays;
      
      return daysSinceUpdate > 365; // More than a year
    } catch (e) {
      return false; // Assume maintained if we can't check
    }
  }
  
  static Future<String> _readPubspecFile() async {
    final file = File('pubspec.yaml');
    return await file.readAsString();
  }
  
  static List<DependencyInfo> _parseDependencies(String pubspecContent) {
    final yaml = loadYaml(pubspecContent);
    final dependencies = <DependencyInfo>[];
    
    if (yaml['dependencies'] != null) {
      yaml['dependencies'].forEach((name, version) {
        dependencies.add(DependencyInfo(name, version.toString()));
      });
    }
    
    return dependencies;
  }
  
  static Future<PackageInfo> _fetchPackageInfo(String packageName) async {
    // Fetch from pub.dev API
    final response = await http.get(
      Uri.parse('https://pub.dev/api/packages/$packageName'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PackageInfo.fromJson(data);
    } else {
      throw Exception('Failed to fetch package info');
    }
  }
}

class DependencyInfo {
  final String name;
  final String version;
  
  DependencyInfo(this.name, this.version);
}

class Vulnerability {
  final String package;
  final String version;
  final Severity severity;
  final String description;
  
  Vulnerability({
    required this.package,
    required this.version,
    required this.severity,
    required this.description,
  });
}

enum Severity { low, medium, high, critical }

class SecurityReport {
  final List<Vulnerability> vulnerabilities;
  final List<String> warnings;
  final DateTime scanDate;
  
  SecurityReport({
    required this.vulnerabilities,
    required this.warnings,
    required this.scanDate,
  });
  
  bool get hasVulnerabilities => vulnerabilities.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
}
```

### Secure Package Configuration:

```yaml
# pubspec.yaml with security considerations
name: secure_flutter_app

dependencies:
  # Use HTTPS URLs for git dependencies
  secure_package:
    git:
      url: https://github.com/trusted-org/secure_package.git
      ref: v1.2.3  # Pin to specific commit/tag
      
  # Prefer packages with recent updates and good maintenance
  well_maintained_package: ^2.1.0
  
  # Avoid packages with known vulnerabilities
  # vulnerable_package: ^1.0.0  # Commented out due to security issues
  
dev_dependencies:
  # Security testing tools
  dependency_validator: ^1.0.0
  license_checker: ^1.0.0
```

---

## Custom Package Development

Creating and publishing your own packages.

### Package Structure:

```
my_custom_package/
├── lib/
│   ├── my_custom_package.dart
│   ├── src/
│   │   ├── core/
│   │   ├── models/
│   │   └── utils/
│   └── my_custom_package.dart
├── test/
│   └── my_custom_package_test.dart
├── example/
│   ├── lib/
│   │   └── main.dart
│   └── pubspec.yaml
├── CHANGELOG.md
├── LICENSE
├── README.md
├── analysis_options.yaml
└── pubspec.yaml
```

### Complete pubspec.yaml for Custom Package:

```yaml
# pubspec.yaml
name: my_custom_package
description: A custom Flutter package for enhanced functionality
version: 1.0.0
homepage: https://github.com/yourusername/my_custom_package
repository: https://github.com/yourusername/my_custom_package
issue_tracker: https://github.com/yourusername/my_custom_package/issues
documentation: https://github.com/yourusername/my_custom_package#readme

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter
    
  # Your package dependencies
  http: ^1.1.0
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
    
  flutter_lints: ^2.0.3
  
flutter:
  plugin:
    platforms:
      android:
        package: com.example.my_custom_package
        pluginClass: MyCustomPackagePlugin
      ios:
        pluginClass: MyCustomPackagePlugin
```

### Package Implementation:

```dart
// lib/my_custom_package.dart
library my_custom_package;

export 'src/core/custom_service.dart';
export 'src/models/custom_model.dart';
export 'src/utils/custom_utils.dart';

// lib/src/core/custom_service.dart
class CustomService {
  final String apiKey;
  
  CustomService(this.apiKey);
  
  Future<String> performCustomOperation(String input) async {
    // Implementation
    return 'Processed: $input';
  }
}

// lib/src/models/custom_model.dart
class CustomModel {
  final String id;
  final String name;
  final DateTime createdAt;
  
  const CustomModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  factory CustomModel.fromJson(Map<String, dynamic> json) {
    return CustomModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// lib/src/utils/custom_utils.dart
class CustomUtils {
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

### Testing Your Package:

```dart
// test/my_custom_package_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_custom_package/my_custom_package.dart';

void main() {
  group('CustomService', () {
    late CustomService service;
    
    setUp(() {
      service = CustomService('test_api_key');
    });
    
    test('performCustomOperation returns processed result', () async {
      final result = await service.performCustomOperation('test');
      expect(result, 'Processed: test');
    });
  });
  
  group('CustomUtils', () {
    test('formatDate formats correctly', () {
      final date = DateTime(2023, 12, 25);
      final formatted = CustomUtils.formatDate(date);
      expect(formatted, '2023-12-25');
    });
    
    test('isValidEmail validates correctly', () {
      expect(CustomUtils.isValidEmail('test@example.com'), true);
      expect(CustomUtils.isValidEmail('invalid-email'), false);
    });
  });
}
```

### Example App:

```dart
// example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:my_custom_package/my_custom_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Custom Package Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CustomService _service = CustomService('example_api_key');
  String _result = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Package Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await _service.performCustomOperation('Hello World');
                setState(() {
                  _result = result;
                });
              },
              child: const Text('Test Custom Operation'),
            ),
            const SizedBox(height: 16),
            Text('Result: $_result'),
            const SizedBox(height: 16),
            Text('Valid email: ${CustomUtils.isValidEmail('test@example.com')}'),
          ],
        ),
      ),
    );
  }
}
```

### Publishing to pub.dev:

```bash
# 1. Create a pub.dev account
# 2. Get your API token from pub.dev
# 3. Authenticate with pub
flutter pub pub login

# 4. Check package before publishing
flutter pub pub publish --dry-run

# 5. Publish package
flutter pub pub publish

# 6. Update package
# Increment version in pubspec.yaml
flutter pub pub publish
```

### Package Maintenance:

```dart
// scripts/publish_checklist.dart
class PublishChecklist {
  static const List<String> _checklist = [
    '✓ Update version in pubspec.yaml',
    '✓ Update CHANGELOG.md',
    '✓ Run tests: flutter test',
    '✓ Run analysis: flutter analyze',
    '✓ Format code: flutter format .',
    '✓ Dry run publish: flutter pub pub publish --dry-run',
    '✓ Check documentation',
    '✓ Test example app',
  ];
  
  static void printChecklist() {
    print('📋 Package Publish Checklist:');
    _checklist.forEach(print);
  }
  
  static Future<bool> runAutomatedChecks() async {
    // Run automated checks
    final testResult = await _runTests();
    final analysisResult = await _runAnalysis();
    final formatResult = await _checkFormatting();
    
    return testResult && analysisResult && formatResult;
  }
  
  static Future<bool> _runTests() async {
    // Run flutter test
    return true; // Placeholder
  }
  
  static Future<bool> _runAnalysis() async {
    // Run flutter analyze
    return true; // Placeholder
  }
  
  static Future<bool> _checkFormatting() async {
    // Check flutter format
    return true; // Placeholder
  }
}
```

---

## Dependency Version Management

Advanced versioning strategies and conflict resolution.

### Version Resolution Strategies:

```dart
class VersionResolver {
  static Future<ResolutionResult> resolveVersions(Map<String, String> dependencies) async {
    final resolved = <String, String>{};
    final conflicts = <VersionConflict>[];
    
    for (final entry in dependencies.entries) {
      final packageName = entry.key;
      final constraint = entry.value;
      
      try {
        final resolvedVersion = await _resolvePackageVersion(packageName, constraint);
        resolved[packageName] = resolvedVersion;
      } catch (e) {
        conflicts.add(VersionConflict(packageName, constraint, e.toString()));
      }
    }
    
    return ResolutionResult(resolved, conflicts);
  }
  
  static Future<String> _resolvePackageVersion(String packageName, String constraint) async {
    // Fetch available versions from pub.dev
    final versions = await _fetchPackageVersions(packageName);
    
    // Find best matching version
    return _findBestMatch(versions, constraint);
  }
  
  static Future<List<String>> _fetchPackageVersions(String packageName) async {
    // Implementation to fetch versions from pub.dev API
    return ['1.0.0', '1.1.0', '2.0.0']; // Placeholder
  }
  
  static String _findBestMatch(List<String> versions, String constraint) {
    // Parse constraint and find best version
    if (constraint.startsWith('^')) {
      final baseVersion = constraint.substring(1);
      final compatibleVersions = versions.where((v) => _isCompatible(v, baseVersion));
      return compatibleVersions.last; // Latest compatible
    }
    
    return versions.last; // Latest available
  }
  
  static bool _isCompatible(String version, String baseVersion) {
    // Simple version compatibility check
    final versionParts = version.split('.');
    final baseParts = baseVersion.split('.');
    
    for (var i = 0; i < min(versionParts.length, baseParts.length); i++) {
      final vNum = int.parse(versionParts[i]);
      final bNum = int.parse(baseParts[i]);
      
      if (vNum > bNum) return true;
      if (vNum < bNum) return false;
    }
    
    return true;
  }
}

class VersionConflict {
  final String package;
  final String constraint;
  final String error;
  
  VersionConflict(this.package, this.constraint, this.error);
}

class ResolutionResult {
  final Map<String, String> resolvedVersions;
  final List<VersionConflict> conflicts;
  
  ResolutionResult(this.resolvedVersions, this.conflicts);
  
  bool get hasConflicts => conflicts.isNotEmpty;
}
```

### Lock File Management:

```yaml
# pubspec.lock (generated file - do not edit)
packages:
  async:
    dependency: transitive
    description:
      name: async
      url: "https://pub.dev"
    source: hosted
    version: "2.11.0"
  collection:
    dependency: transitive
    description:
      name: collection
      url: "https://pub.dev"
    source: hosted
    version: "1.17.2"
  dio:
    dependency: "direct main"
    description:
      name: dio
      url: "https://pub.dev"
    source: hosted
    version: "5.3.2"
```

### Dependency Update Automation:

```dart
// tools/dependency_updater.dart
class DependencyUpdater {
  static Future<UpdateReport> checkForUpdates() async {
    final pubspecContent = await _readPubspecFile();
    final currentDeps = _parseCurrentDependencies(pubspecContent);
    
    final updates = <PackageUpdate>[];
    
    for (final dep in currentDeps) {
      final latestVersion = await _fetchLatestVersion(dep.name);
      if (_isUpdateAvailable(dep.version, latestVersion)) {
        updates.add(PackageUpdate(
          name: dep.name,
          currentVersion: dep.version,
          latestVersion: latestVersion,
          breaking: _isBreakingChange(dep.version, latestVersion),
        ));
      }
    }
    
    return UpdateReport(updates);
  }
  
  static Future<void> updateDependencies(List<String> packageNames) async {
    for (final packageName in packageNames) {
      await _updatePackage(packageName);
    }
    
    // Run flutter pub get
    await _runPubGet();
    
    // Run tests to ensure compatibility
    await _runTests();
  }
  
  static Future<String> _fetchLatestVersion(String packageName) async {
    // Fetch from pub.dev API
    return '2.0.0'; // Placeholder
  }
  
  static bool _isUpdateAvailable(String current, String latest) {
    return _compareVersions(current, latest) < 0;
  }
  
  static bool _isBreakingChange(String current, String latest) {
    final currentMajor = _getMajorVersion(current);
    final latestMajor = _getMajorVersion(latest);
    return latestMajor > currentMajor;
  }
  
  static int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map(int.parse).toList();
    final parts2 = v2.split('.').map(int.parse).toList();
    
    for (var i = 0; i < max(parts1.length, parts2.length); i++) {
      final part1 = i < parts1.length ? parts1[i] : 0;
      final part2 = i < parts2.length ? parts2[i] : 0;
      
      if (part1 != part2) {
        return part1.compareTo(part2);
      }
    }
    
    return 0;
  }
  
  static int _getMajorVersion(String version) {
    return int.parse(version.split('.')[0]);
  }
  
  static Future<String> _readPubspecFile() async {
    final file = File('pubspec.yaml');
    return await file.readAsString();
  }
  
  static List<DependencyInfo> _parseCurrentDependencies(String content) {
    // Parse pubspec.yaml
    return []; // Placeholder
  }
  
  static Future<void> _updatePackage(String packageName) async {
    // Update pubspec.yaml
  }
  
  static Future<void> _runPubGet() async {
    // Run flutter pub get
  }
  
  static Future<void> _runTests() async {
    // Run flutter test
  }
}

class PackageUpdate {
  final String name;
  final String currentVersion;
  final String latestVersion;
  final bool breaking;
  
  PackageUpdate({
    required this.name,
    required this.currentVersion,
    required this.latestVersion,
    required this.breaking,
  });
}

class UpdateReport {
  final List<PackageUpdate> updates;
  
  UpdateReport(this.updates);
  
  List<PackageUpdate> get breakingUpdates => updates.where((u) => u.breaking).toList();
  List<PackageUpdate> get safeUpdates => updates.where((u) => !u.breaking).toList();
}
```

---

## Summary

- **pub.dev**: Official package repository with quality assessment tools
- **pubspec.yaml**: Comprehensive configuration with version constraints and conditional dependencies
- **Package Integration**: Service layer and repository patterns for clean integration
- **Security**: Vulnerability scanning and secure configuration practices
- **Custom Packages**: Complete development and publishing workflow
- **Version Management**: Automated resolution and update strategies

Effective dependency management ensures maintainable, secure, and up-to-date Flutter applications.

dependencies:
  flutter:
    sdk: flutter
  
  # Immediate dependencies
  provider: ^6.0.0
  http: ^1.0.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  test: ^1.21.0
  mockito: ^5.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/data.json
  
  fonts:
    - family: Montserrat
      fonts:
        - asset: assets/fonts/Montserrat-Regular.ttf
        - asset: assets/fonts/Montserrat-Bold.ttf
          weight: 700
```

---

## Version Constraints

### Constraint Types:

| Constraint | Meaning | Example |
|-----------|---------|---------|
| Caret (^) | Compatible with version | ^1.2.3 → >=1.2.3 <2.0.0 |
| Tilde (~) | Minor version compatible | ~1.2.3 → >=1.2.3 <1.3.0 |
| Greater/Less | Exact range | >=1.0.0 <2.0.0 |
| Any | Latest version | any |

### Application:

```yaml
# Latest minor version (recommended)
provider: ^6.0.0

# Exact version
http: 1.1.0

# Range
dio: ">=5.0.0 <6.0.0"

# No update
flutter_svg: 2.0.7
```

---

## Getting Dependencies

### Add Package:

```bash
flutter pub add provider              # Add latest version
flutter pub add provider:^6.0.0       # Add specific version
flutter pub add --dev test            # Add dev dependency
```

### Update pubspec.yaml:

```yaml
dependencies:
  provider: ^6.0.0  # Manual entry

# Then run:
flutter pub get
```

### Get All Dependencies:

```bash
flutter pub get
flutter pub upgrade              # Update all
flutter pub upgrade provider     # Update specific
```

### Remove Package:

```bash
flutter pub remove provider
# Or manually delete from pubspec.yaml and run: flutter pub get
```

---

## Lock File (pubspec.lock)

Ensures reproducible builds.

```yaml
# Auto-generated, don't edit manually
packages:
  provider:
    dependency: "direct main"
    description:
      name: provider
      url: "https://pub.dev"
    source: hosted
    version: "6.0.0"
```

**Best Practice:** Commit pubspec.lock to version control.

---

## Conflict Resolution

### Version Conflict:

If multiple packages need different versions:

```yaml
# Example conflict
packages:
  provider: ^5.0.0    # Package A needs this
  some_package: ^1.0.0  # This needs provider ^6.0.0
```

**Solution:**

```bash
flutter pub upgrade
# Flutter resolves version compatibility
```

Or explicitly specify:

```yaml
dependencies:
  provider: ^6.0.0
```

---

## Dependency Tree

### View Dependencies:

```bash
flutter pub deps
# Shows dependency tree

flutter pub deps --json
# JSON format
```

### Example Output:

```
my_flutter_app
├─ flutter
├─ provider
│  ├─ flutter
│  └─ collection: ^1.16.0
├─ http
│  ├─ async: ^2.8.2
│  └─ characters: ^1.2.0
└─ dio
   ├─ http_parser: ^4.0.0
   └─ path_provider: ^2.0.0
```

---

## Publishing Custom Packages

### Create Package:

```bash
flutter create --template=package my_package
cd my_package
```

### Package Structure:

```
my_package/
├── lib/
│   ├── my_package.dart
│   └── src/
├── test/
├── example/
├── pubspec.yaml
├── README.md
├── LICENSE
└── CHANGELOG.md
```

### pubspec.yaml:

```yaml
name: my_package
version: 1.0.0

description: My awesome Flutter package
homepage: https://github.com/user/my_package

environment:
  sdk: ">=2.19.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
```

### Publish:

```bash
flutter pub publish --dry-run   # Test publish
flutter pub publish             # Actually publish
```

---

## Private Packages

### Use Git:

```yaml
dependencies:
  my_private_package:
    git:
      url: https://github.com/user/my_private_package.git
      ref: main
```

### Use Local Path:

```yaml
dependencies:
  my_package:
    path: ../my_package  # Relative path

# Or
  my_package:
    path: /absolute/path/my_package
```

### Use Private Registry:

```yaml
dependencies:
  my_package:
    hosted:
      url: https://my-registry.example.com
      name: my_package
    version: ^1.0.0
```

---

## Pre-Release Versions

### Versioning:

```yaml
# Stable
version: 1.0.0

# Pre-release
version: 1.0.0-alpha.1
version: 1.0.0-beta.2
version: 1.0.0-rc.1
```

### Using Pre-Release:

```yaml
dependencies:
  my_package: "^1.0.0-beta"  # Accept pre-releases
```

---

## Plugin Development

### Create Plugin:

```bash
flutter create --template=plugin my_plugin
```

### Plugin Structure:

```
my_plugin/
├── android/
│   └── app/
├── ios/
│   └── Runner/
├── lib/
│   └── my_plugin.dart
├── example/
└── pubspec.yaml
```

### pubspec.yaml:

```yaml
name: my_plugin
version: 1.0.0

flutter:
  plugin:
    platforms:
      android:
        package: com.example.my_plugin
        pluginClass: MyPlugin
      ios:
        pluginClass: MyPlugin
```

---

## Dependency Best Practices

1. **Keep dependencies minimal**
   - Only add necessary packages
   - Each dependency adds complexity

2. **Check package quality**
   - Look for high ratings
   - Active maintenance
   - Good documentation

3. **Avoid version conflicts**
   - Use compatible versions
   - Check dependency tree

4. **Lock production versions**
   - Don't use `any` version
   - Pin specific versions for stability

5. **Update regularly**
   - But test thoroughly
   - Review breaking changes

6. **Use exact versions in production**
   ```yaml
   # Bad for production
   dependency: ^1.0.0
   
   # Better for production
   dependency: 1.2.3
   ```

7. **Separate dev and main**
   ```yaml
   dependencies:
     provider: ^6.0.0
   
   dev_dependencies:
     test: ^1.21.0
   ```

8. **Document dependencies**
   - Why each package is used
   - What features are utilized

9. **Check licenses**
   - Ensure compatibility with app license
   - Review package licenses

10. **Monitor security**
    - Subscribe to security advisories
    - Update regularly

---

## Common Packages Explained

### Provider:

```yaml
dependencies:
  provider: ^6.0.0  # State management
```

### Dio:

```yaml
dependencies:
  dio: ^5.0.0  # Advanced HTTP with interceptors
```

### Hive:

```yaml
dependencies:
  hive: ^2.2.0           # NoSQL database
  hive_flutter: ^1.1.0   # Flutter binding

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.3.0
```

### get_it:

```yaml
dependencies:
  get_it: ^7.0.0  # Service locator (dependency injection)
```

---

## Summary

- **pub.dev**: Official package repository
- **pubspec.yaml**: Dependency configuration
- **Version constraints**: Control which versions
- **pubspec.lock**: Reproducible builds
- **Conflict resolution**: Resolve version issues
- **Publishing**: Share your packages
- **Private packages**: Git or local
- **Best practices**: Keep dependencies minimal
- **Security**: Keep packages updated
- **Quality**: Choose well-maintained packages
