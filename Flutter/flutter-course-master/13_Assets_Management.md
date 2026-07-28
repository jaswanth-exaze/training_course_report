# Flutter Assets Management

Managing images, fonts, icons, and other assets in your Flutter app.

---

## Assets Configuration

### pubspec.yaml Setup:

```yaml
flutter:
  assets:
    # Single file
    - assets/images/logo.png
    
    # All files in directory
    - assets/images/
    - assets/data/
    
    # With variant
    - assets/images/2.0x/logo.png
    - assets/images/3.0x/logo.png

  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
    - family: PlayfairDisplay
      fonts:
        - asset: assets/fonts/PlayfairDisplay-Regular.ttf
```

### Directory Structure:

```
project/
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── 2.0x/
│   │   │   └── logo.png (high-res)
│   │   └── icons/
│   ├── fonts/
│   │   ├── Roboto-Regular.ttf
│   │   └── PlayfairDisplay-Regular.ttf
│   └── data/
│       └── config.json
└── lib/
```

### Asset Variants:

```yaml
flutter:
  assets:
    # Base resolution (1.0x)
    - assets/images/logo.png
    - assets/images/avatar.png
    
    # High resolution variants
    - assets/images/2.0x/logo.png
    - assets/images/2.0x/avatar.png
    - assets/images/3.0x/logo.png
    - assets/images/3.0x/avatar.png
    
    # Dark mode variants
    - assets/images/dark/logo.png
    - assets/images/light/logo.png
```

---

## Images

### Loading Images:

```dart
// From assets
Image.asset('assets/images/logo.png')

// From network
Image.network('https://example.com/image.png')

// From file
Image.file(File('/path/to/image.png'))

// From memory
Image.memory(imageBytes)
```

### Image Widget:

```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  semanticLabel: 'Logo',
)
```

### Cached Network Image:

```yaml
dependencies:
  cached_network_image: ^3.0.0
```

```dart
CachedNetworkImage(
  imageUrl: "https://example.com/image.png",
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### Advanced Image Loading:

```dart
class SmartImage extends StatelessWidget {
  final String? assetPath;
  final String? networkUrl;
  final File? file;
  final Uint8List? bytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  
  const SmartImage({
    super.key,
    this.assetPath,
    this.networkUrl,
    this.file,
    this.bytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });
  
  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Icon(Icons.broken_image);
        },
      );
    }
    
    if (networkUrl != null) {
      return CachedNetworkImage(
        imageUrl: networkUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? CircularProgressIndicator(),
        errorWidget: (context, url, error) => errorWidget ?? Icon(Icons.error),
      );
    }
    
    if (file != null) {
      return Image.file(
        file!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Icon(Icons.broken_image);
        },
      );
    }
    
    if (bytes != null) {
      return Image.memory(
        bytes!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Icon(Icons.broken_image);
        },
      );
    }
    
    return errorWidget ?? Icon(Icons.image_not_supported);
  }
}
```

### Image Optimization:

```dart
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  
  const OptimizedImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    // Calculate optimal image size based on device pixel ratio
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final optimalWidth = (width * devicePixelRatio).round();
    final optimalHeight = (height * devicePixelRatio).round();
    
    // Create optimized URL with size parameters
    final optimizedUrl = _optimizeImageUrl(imageUrl, optimalWidth, optimalHeight);
    
    return CachedNetworkImage(
      imageUrl: optimizedUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      memCacheWidth: optimalWidth,
      memCacheHeight: optimalHeight,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Icon(Icons.image, color: Colors.grey[400]),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Icon(Icons.broken_image, color: Colors.grey[400]),
      ),
    );
  }
  
  String _optimizeImageUrl(String url, int width, int height) {
    // Example for services like Cloudinary, Imgix, etc.
    final uri = Uri.parse(url);
    final newQuery = Map<String, String>.from(uri.queryParameters);
    newQuery['w'] = width.toString();
    newQuery['h'] = height.toString();
    newQuery['fit'] = 'crop';
    newQuery['auto'] = 'compress';
    
    return uri.replace(queryParameters: newQuery).toString();
  }
}
```

---

## Fonts

### Custom Font Setup:

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
        - asset: assets/fonts/Roboto-Italic.ttf
          style: italic
        - asset: assets/fonts/Roboto-Light.ttf
          weight: 300
    - family: Icons
      fonts:
        - asset: assets/fonts/MyIcons.ttf
```

### Font Usage:

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
)

// Using custom icon font
Text(
  '\u{e900}', // Custom icon code
  style: TextStyle(
    fontFamily: 'Icons',
    fontSize: 24,
  ),
)
```

### Google Fonts:

```yaml
dependencies:
  google_fonts: ^4.0.0
```

```dart
import 'package:google_fonts/google_fonts.dart';

Text(
  'Hello World',
  style: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// Apply to entire theme
MaterialApp(
  theme: ThemeData(
    textTheme: GoogleFonts.robotoTextTheme(),
  ),
)
```

### Font Loading:

```dart
class FontLoader {
  static Future<void> loadCustomFont() async {
    final fontLoader = FontLoader('CustomFont');
    await fontLoader.load();
  }
  
  static Future<void> loadFontFromAsset(String fontFamily, String assetPath) async {
    final fontData = await rootBundle.load(assetPath);
    final font = Font.ttf(fontData);
    
    // Register font (advanced usage)
    // This requires custom implementation
  }
}
```

---

## Icons

### Material Icons:

```dart
Icon(
  Icons.home,
  size: 24,
  color: Colors.blue,
)

IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {},
)
```

### Custom Icons:

```dart
class MyIcons {
  static const IconData home = IconData(0xe900, fontFamily: 'MyIcons');
  static const IconData settings = IconData(0xe901, fontFamily: 'MyIcons');
  static const IconData profile = IconData(0xe902, fontFamily: 'MyIcons');
}

Icon(MyIcons.home, size: 24)
```

### Icon Themes:

```dart
ThemeData(
  iconTheme: IconThemeData(
    color: Colors.blue,
    size: 24,
  ),
  
  // Specific icon themes
  primaryIconTheme: IconThemeData(
    color: Colors.white,
    size: 20,
  ),
)
```

### Icon Fonts:

```yaml
flutter:
  fonts:
    - family: MyIcons
      fonts:
        - asset: assets/fonts/icons.ttf
```

```dart
class IconFonts {
  static const String home = '\u{e900}';
  static const String settings = '\u{e901}';
  static const String profile = '\u{e902}';
}

Text(
  IconFonts.home,
  style: TextStyle(
    fontFamily: 'MyIcons',
    fontSize: 24,
  ),
)
```

---

## JSON Loading

### Loading JSON Assets:

```dart
class JsonLoader {
  static Future<Map<String, dynamic>> loadJsonFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }
  
  static Future<List<dynamic>> loadJsonListFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }
}

// Usage
Future<void> loadConfig() async {
  final config = await JsonLoader.loadJsonFromAssets('assets/data/config.json');
  print('App version: ${config['version']}');
}
```

### Configuration Management:

```dart
class AppConfig {
  final String appName;
  final String version;
  final String apiUrl;
  final Map<String, dynamic> features;
  
  AppConfig({
    required this.appName,
    required this.version,
    required this.apiUrl,
    required this.features,
  });
  
  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['app_name'],
      version: json['version'],
      apiUrl: json['api_url'],
      features: json['features'],
    );
  }
  
  static Future<AppConfig> load() async {
    final json = await JsonLoader.loadJsonFromAssets('assets/data/config.json');
    return AppConfig.fromJson(json);
  }
}

// config.json
{
  "app_name": "My App",
  "version": "1.0.0",
  "api_url": "https://api.example.com",
  "features": {
    "dark_mode": true,
    "notifications": false
  }
}
```

### Localization:

```dart
class LocalizationLoader {
  static Future<Map<String, String>> loadLanguage(String languageCode) async {
    final path = 'assets/locales/$languageCode.json';
    final json = await JsonLoader.loadJsonFromAssets(path);
    return Map<String, String>.from(json);
  }
}

// en.json
{
  "hello": "Hello",
  "welcome": "Welcome to the app",
  "settings": "Settings"
}

// es.json
{
  "hello": "Hola",
  "welcome": "Bienvenido a la aplicación",
  "settings": "Configuración"
}
```

---

## Asset Bundles

### Custom Asset Bundle:

```dart
class CustomAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    // Custom loading logic
    final data = await _loadAsset(key);
    return ByteData.view(data.buffer);
  }
  
  @override
  Future<T> loadStructuredData<T>(
    String key,
    Future<T> Function(ByteData data) parser,
  ) async {
    final data = await load(key);
    return parser(data);
  }
  
  Future<Uint8List> _loadAsset(String key) async {
    // Implement custom asset loading
    // Could load from network, encrypted storage, etc.
    return Uint8List(0);
  }
}
```

### Asset Bundle Management:

```dart
class AssetManager {
  static final Map<String, dynamic> _cache = {};
  
  static Future<T> loadAsset<T>(
    String key,
    Future<T> Function(String) loader,
  ) async {
    if (_cache.containsKey(key)) {
      return _cache[key] as T;
    }
    
    final asset = await loader(key);
    _cache[key] = asset;
    return asset;
  }
  
  static void clearCache() {
    _cache.clear();
  }
  
  static Future<Image> loadImage(String path) async {
    return await loadAsset(
      path,
      (key) async => Image.asset(key),
    );
  }
  
  static Future<String> loadString(String path) async {
    return await loadAsset(
      path,
      (key) async => await rootBundle.loadString(key),
    );
  }
  
  static Future<Map<String, dynamic>> loadJson(String path) async {
    return await loadAsset(
      path,
      (key) async => await JsonLoader.loadJsonFromAssets(key),
    );
  }
}
```

### Encrypted Assets:

```dart
class EncryptedAssetBundle extends AssetBundle {
  final String encryptionKey;
  
  EncryptedAssetBundle(this.encryptionKey);
  
  @override
  Future<ByteData> load(String key) async {
    final encryptedData = await rootBundle.load(key);
    final decryptedData = await _decryptData(encryptedData, encryptionKey);
    return ByteData.view(decryptedData.buffer);
  }
  
  Future<Uint8List> _decryptData(ByteData data, String key) async {
    // Implement decryption logic
    // Use packages like encrypt or pointycastle
    return data.buffer.asUint8List();
  }
}
```

---

## Best Practices

### Asset Organization:

```dart
// assets/
// ├── images/
// │   ├── logos/
// │   ├── icons/
// │   ├── backgrounds/
// │   └── placeholders/
// ├── fonts/
// │   ├── primary/
// │   └── secondary/
// ├── data/
// │   ├── config/
// │   ├── locales/
// │   └── mock/
// └── audio/
//     └── effects/
```

### Asset Constants:

```dart
class AssetPaths {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String placeholder = 'assets/images/placeholder.png';
  
  // Icons
  static const String homeIcon = 'assets/icons/home.png';
  static const String settingsIcon = 'assets/icons/settings.png';
  
  // Fonts
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'PlayfairDisplay';
  
  // Data
  static const String config = 'assets/data/config.json';
  static const String enLocale = 'assets/data/locales/en.json';
  static const String esLocale = 'assets/data/locales/es.json';
}

class AppImages {
  static Image logo() => Image.asset(AssetPaths.logo);
  static Image placeholder() => Image.asset(AssetPaths.placeholder);
}
```

### Asset Preloading:

```dart
class AssetPreloader {
  static Future<void> preloadAssets() async {
    // Preload critical images
    await precacheImage(Image.asset(AssetPaths.logo).image, context);
    await precacheImage(Image.asset(AssetPaths.placeholder).image, context);
    
    // Preload fonts
    await FontLoader.loadCustomFont();
    
    // Preload data
    await AppConfig.load();
  }
}
```

### Asset Validation:

```dart
class AssetValidator {
  static Future<bool> validateAsset(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      print('Asset not found: $path');
      return false;
    }
  }
  
  static Future<void> validateAllAssets() async {
    final assets = [
      AssetPaths.logo,
      AssetPaths.config,
      // Add all assets
    ];
    
    for (final asset in assets) {
      final exists = await validateAsset(asset);
      if (!exists) {
        throw Exception('Missing asset: $asset');
      }
    }
  }
}
```

### Performance Optimization:

```dart
class AssetOptimizer {
  static const int maxImageSize = 1024 * 1024; // 1MB
  
  static Future<Uint8List> optimizeImage(Uint8List imageBytes) async {
    // Resize large images
    if (imageBytes.length > maxImageSize) {
      // Use image package to resize
      // final image = decodeImage(imageBytes);
      // final resized = copyResize(image, width: 800);
      // return encodePng(resized);
    }
    return imageBytes;
  }
  
  static Future<void> compressAssets() async {
    // Compress assets during build
    // Use tools like flutter_asset_generator
  }
}
```

### Asset Variants for Different Themes:

```dart
class ThemeAssetManager {
  static String getAssetPath(String basePath, BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    
    // Check for theme-specific variant
    final themePath = isDark
        ? basePath.replaceFirst('assets/', 'assets/dark/')
        : basePath.replaceFirst('assets/', 'assets/light/');
    
    // Return theme-specific path if it exists, otherwise base path
    return themePath;
  }
}

class ThemeAwareImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  
  const ThemeAwareImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    final themedPath = ThemeAssetManager.getAssetPath(assetPath, context);
    return Image.asset(
      themedPath,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to original asset if themed version doesn't exist
        return Image.asset(
          assetPath,
          width: width,
          height: height,
        );
      },
    );
  }
}
```

---

## Summary

- **Assets Configuration**: pubspec.yaml setup with variants and organization
- **Images**: Asset, network, file, and memory images with optimization
- **Fonts**: Custom fonts, Google Fonts, and font loading
- **Icons**: Material icons, custom icons, and icon fonts
- **JSON Loading**: Configuration, localization, and data loading
- **Asset Bundles**: Custom bundles, caching, and encryption
- **Best Practices**: Organization, constants, preloading, validation, and optimization

Proper asset management ensures efficient loading and better user experience.

## Images

### Loading Images:

```dart
// From assets
Image.asset('assets/images/logo.png')

// From network
Image.network('https://example.com/image.png')

// From file
Image.file(File('/path/to/image.png'))

// From memory
Image.memory(imageBytes)
```

### Image Widget:

```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  semanticLabel: 'Logo',
)
```

### Cached Network Image:

```yaml
dependencies:
  cached_network_image: ^3.0.0
```

```dart
CachedNetworkImage(
  imageUrl: "https://example.com/image.png",
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### Image Variants (Resolution):

```
assets/
├── images/
│   ├── logo.png (1x - baseline)
│   ├── 2.0x/
│   │   └── logo.png (2x - higher DPI)
│   └── 3.0x/
│       └── logo.png (3x - very high DPI)
```

Flutter automatically loads the right version based on device pixel density.

---

## Fonts

### Using Custom Fonts:

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
          weight: 400
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
        - asset: assets/fonts/Roboto-Italic.ttf
          style: italic
```

### Apply Font:

```dart
Text(
  "Hello",
  style: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
)

// Or in theme
textTheme: TextTheme(
  bodyLarge: TextStyle(fontFamily: 'Roboto'),
)
```

### Google Fonts Package:

```yaml
dependencies:
  google_fonts: ^4.0.0
```

```dart
import 'package:google_fonts/google_fonts.dart';

Text(
  "Hello",
  style: GoogleFonts.playfairDisplay(fontSize: 28),
)

// Or use in theme
textTheme: TextTheme(
  displayLarge: GoogleFonts.playfairDisplay(fontSize: 32),
  bodyLarge: GoogleFonts.roboto(fontSize: 16),
)
```

---

## Icons

### Material Icons (Built-in):

```dart
Icon(Icons.home)
Icon(Icons.favorite, color: Colors.red, size: 32)
Icon(Icons.settings, color: Colors.blue)
```

### Custom Icon Fonts:

```yaml
dependencies:
  flutter_icons: ^1.1.0
```

```dart
Icon(FlutterIcons.home_fea)
Icon(FlutterIcons.github_fab)
```

### Creating Custom Icons from SVG:

```yaml
dependencies:
  flutter_svg: ^2.0.0
```

```dart
SvgPicture.asset(
  'assets/icons/home.svg',
  width: 24,
  height: 24,
  color: Colors.blue,
)
```

### Icon Button:

```dart
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
  color: Colors.red,
  iconSize: 28,
)
```

---

## Loading JSON/Data Files

### Load JSON Asset:

```dart
Future<String> loadJsonAsset(String path) async {
  return await rootBundle.loadString(path);
}

Future<List<Item>> loadItems() async {
  final jsonString = await rootBundle.loadString('assets/data/items.json');
  final jsonData = json.decode(jsonString) as List;
  return jsonData.map((item) => Item.fromJson(item)).toList();
}
```

### Using in Widget:

```dart
class ItemsList extends StatefulWidget {
  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name),
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

## Asset Bundle

### rootBundle:

```dart
import 'package:flutter/services.dart';

// Load text asset
final text = await rootBundle.loadString('assets/data/config.txt');

// Load image
final imageData = await rootBundle.load('assets/images/logo.png');

// Load all assets with prefix
final assets = await rootBundle.list('assets/');
```

---

## Best Practices

### Naming Conventions:

```
assets/
├── images/
│   ├── backgrounds/
│   │   └── bg_login.png
│   ├── icons/
│   │   └── ic_home.png
│   └── logos/
│       └── logo_main.png
├── fonts/
│   └── Roboto-Regular.ttf
└── data/
    └── countries.json
```

### Resolution-Independent Assets:

```
Keep only 1x (baseline) in assets/
Flutter will scale for 2x and 3x devices automatically

For specific device types:
assets/images/logo.png (1x)
assets/images/2.0x/logo.png (2x)
assets/images/3.0x/logo.png (3x)
```

### Asset Size Optimization:

```dart
// Use WebP instead of PNG for network images
CachedNetworkImage(
  imageUrl: "https://example.com/image.webp",
)

// Compress images before adding to assets
// Use tools like: ImageOptim, TinyPNG

// Use const Image.asset() for better performance
const Image(image: AssetImage('assets/images/logo.png'))
```

### Lazy Load Assets:

```dart
// Load asset only when needed
class ImageProvider extends StatefulWidget {
  @override
  State<ImageProvider> createState() => _ImageProviderState();
}

class _ImageProviderState extends State<ImageProvider> {
  late Future<AssetImage> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage();
  }

  Future<AssetImage> _loadImage() async {
    return AssetImage('assets/images/large_image.png');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AssetImage>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image(image: snapshot.data!);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

## Common Asset Issues

### 1. Image not loading:

```dart
// Make sure path is correct in pubspec.yaml
// Run flutter pub get
// Rebuild app
```

### 2. Font not applying:

```dart
// Verify font name in pubspec.yaml
// Use exact family name in TextStyle
// Rebuild app (hot reload won't work for fonts)
```

### 3. Large app size:

```dart
// Compress images
// Use WebP format
// Remove unused assets
// Use flutter build release --split-debug-info
```

---

## Summary

- Configure assets in `pubspec.yaml`
- Use `Image.asset()` for local images
- Apply custom fonts in TextStyle
- Use Material Icons or custom icons
- Load JSON and data files from assets
- Organize assets in a logical directory structure
- Optimize image sizes and formats
- Use device-specific image variants
