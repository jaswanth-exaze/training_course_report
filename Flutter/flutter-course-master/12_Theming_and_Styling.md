# Flutter Theming & Styling

Create consistent, beautiful UI with theming and styling.

---

## ThemeData

Define colors, fonts, and styles for your app.

### Basic ThemeData:

```dart
MaterialApp(
  theme: ThemeData(
    // Primary color
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    
    // App bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Text
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    
    // Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Card
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    
    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  home: HomePage(),
)
```

### Complete Theme Setup:

```dart
class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  );
  
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],
    
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    
    cardTheme: CardTheme(
      color: Colors.grey[800],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  );
}
```

---

## Dark Mode

Implement dark mode with system preference detection.

### Theme Provider:

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    
    // Save preference
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('theme_mode', mode.name);
    });
  }
  
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
  
  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme_mode');
    
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == themeString,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}
```

### App Setup with Theme Provider:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'My App',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          home: HomePage(),
        );
      },
    );
  }
}
```

### Theme Toggle Widget:

```dart
class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<ThemeMode>(
          onSelected: themeProvider.setThemeMode,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: themeProvider.isLightMode ? Colors.blue : null,
                  ),
                  SizedBox(width: 8),
                  Text('Light'),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: themeProvider.isDarkMode ? Colors.blue : null,
                  ),
                  SizedBox(width: 8),
                  Text('Dark'),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.settings_system_daydream,
                    color: themeProvider.isSystemMode ? Colors.blue : null,
                  ),
                  SizedBox(width: 8),
                  Text('System'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).cardColor,
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        );
      },
    );
  }
}
```

---

## Color Schemes

Define comprehensive color palettes for your app.

### ColorScheme (Material 3):

```dart
class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFFDC004E);
  static const Color tertiary = Color(0xFF03DAC6);
  
  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
}

class AppColorScheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF9E9E9E),
    outline: Color(0xFFBDBDBD),
  );
  
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    error: AppColors.error,
    onError: Colors.white,
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
    surfaceVariant: Color(0xFF2D2D2D),
    onSurfaceVariant: Color(0xFFBDBDBD),
    outline: Color(0xFF555555),
  );
}
```

### Using ColorScheme:

```dart
class AppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorScheme.lightColorScheme,
    
    // Additional theming
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: AppColorScheme.lightColorScheme.onBackground,
      ),
      bodyLarge: TextStyle(
        color: AppColorScheme.lightColorScheme.onSurface,
      ),
    ),
    
    cardTheme: CardTheme(
      color: AppColorScheme.lightColorScheme.surface,
      elevation: 2,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorScheme.darkColorScheme,
    
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: AppColorScheme.darkColorScheme.onBackground,
      ),
      bodyLarge: TextStyle(
        color: AppColorScheme.darkColorScheme.onSurface,
      ),
    ),
    
    cardTheme: CardTheme(
      color: AppColorScheme.darkColorScheme.surface,
      elevation: 2,
    ),
  );
}
```

---

## Custom Fonts

Add custom fonts to your Flutter app.

### Font Setup:

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
        - asset: fonts/Roboto-Italic.ttf
          style: italic
    - family: OpenSans
      fonts:
        - asset: fonts/OpenSans-Regular.ttf
        - asset: fonts/OpenSans-Bold.ttf
          weight: 700
        - asset: fonts/OpenSans-Light.ttf
          weight: 300
```

### Using Custom Fonts:

```dart
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.4,
  );
}

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1,
      displayMedium: AppTextStyles.heading2,
      bodyLarge: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
    ),
    
    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // App bar theme
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
```

### Google Fonts Integration:

```yaml
dependencies:
  google_fonts: ^4.0.0
```

```dart
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      headlineLarge: GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.openSans(
        fontSize: 16,
      ),
    ),
  );
}

// Usage in widgets
Text(
  'Hello World',
  style: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

---

## Material vs Cupertino

Platform-specific theming and components.

### Platform Detection:

```dart
import 'dart:io' show Platform;

class PlatformUtils {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isWeb => kIsWeb;
  
  static TargetPlatform get platform {
    if (isIOS) return TargetPlatform.iOS;
    if (isAndroid) return TargetPlatform.android;
    return TargetPlatform.android; // Default
  }
}
```

### Platform-Specific Themes:

```dart
class AppThemes {
  static ThemeData getTheme(BuildContext context) {
    final platform = Theme.of(context).platform;
    
    if (platform == TargetPlatform.iOS) {
      return cupertinoTheme;
    } else {
      return materialTheme;
    }
  }
  
  static final materialTheme = ThemeData(
    useMaterial3: true,
    // Material Design 3 theme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    
    // Material-specific components
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  static final cupertinoTheme = ThemeData(
    // Cupertino-inspired theme
    primaryColor: CupertinoColors.systemBlue,
    
    // iOS-style components
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: CupertinoColors.systemBlue,
        foregroundColor: CupertinoColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: 0,
      color: CupertinoColors.systemGrey6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Cupertino text styles
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontFamily: '.SF Pro Text',
        fontSize: 16,
      ),
    ),
  );
}
```

### Platform-Specific Widgets:

```dart
class PlatformButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  
  const PlatformButton({
    super.key,
    required this.child,
    this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        child: child,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: child,
      );
    }
  }
}

class PlatformScaffold extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  
  const PlatformScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
  });
  
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: title != null ? CupertinoNavigationBar(
          middle: title,
          trailing: actions != null ? Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!,
          ) : null,
        ) : null,
        child: body,
      );
    } else {
      return Scaffold(
        appBar: title != null ? AppBar(
          title: title,
          actions: actions,
        ) : null,
        body: body,
      );
    }
  }
}
```

---

## Custom Widgets and Components

Create reusable themed components.

### Custom Button Component:

```dart
enum ButtonVariant { primary, secondary, outline, ghost }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;
  
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getButtonStyle(theme, colorScheme),
      child: _buildChild(theme),
    );
  }
  
  ButtonStyle _getButtonStyle(ThemeData theme, ColorScheme colorScheme) {
    final baseStyle = ElevatedButton.styleFrom(
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _getTextStyle(theme),
    );
    
    switch (variant) {
      case ButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(colorScheme.primary),
          foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        );
      
      case ButtonVariant.secondary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(colorScheme.secondary),
          foregroundColor: MaterialStateProperty.all(colorScheme.onSecondary),
        );
      
      case ButtonVariant.outline:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(colorScheme.primary),
          side: MaterialStateProperty.all(
            BorderSide(color: colorScheme.primary),
          ),
        );
      
      case ButtonVariant.ghost:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(colorScheme.primary),
          elevation: MaterialStateProperty.all(0),
        );
    }
  }
  
  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }
  
  TextStyle _getTextStyle(ThemeData theme) {
    final baseStyle = theme.textTheme.labelLarge!;
    
    switch (size) {
      case ButtonSize.small:
        return baseStyle.copyWith(fontSize: 12);
      case ButtonSize.medium:
        return baseStyle.copyWith(fontSize: 14);
      case ButtonSize.large:
        return baseStyle.copyWith(fontSize: 16);
    }
  }
  
  Widget _buildChild(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.onPrimary,
          ),
        ),
      );
    }
    
    final children = <Widget>[];
    
    if (icon != null) {
      children.add(Icon(icon, size: 18));
      children.add(SizedBox(width: 8));
    }
    
    children.add(Text(text));
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
```

### Custom Card Component:

```dart
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final card = Card(
      color: backgroundColor ?? theme.cardTheme.color,
      elevation: elevation ?? theme.cardTheme.elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(16),
        child: child,
      ),
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: card,
      );
    }
    
    return card;
  }
}
```

### Custom Input Field:

```dart
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  
  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
        ],
        
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            errorText: error,
          ),
        ),
      ],
    );
  }
}
```

---

## Dynamic Themes

Change themes at runtime.

### Theme Manager:

```dart
class DynamicThemeManager {
  static const String _themeKey = 'selected_theme';
  
  final List<AppTheme> _availableThemes = [
    AppTheme(
      id: 'default',
      name: 'Default',
      themeData: AppThemes.lightTheme,
      previewColors: [Colors.blue, Colors.white],
    ),
    AppTheme(
      id: 'dark',
      name: 'Dark',
      themeData: AppThemes.darkTheme,
      previewColors: [Colors.grey[900]!, Colors.grey[800]!],
    ),
    AppTheme(
      id: 'nature',
      name: 'Nature',
      themeData: _createNatureTheme(),
      previewColors: [Colors.green, Colors.lightGreen[100]!],
    ),
    AppTheme(
      id: 'sunset',
      name: 'Sunset',
      themeData: _createSunsetTheme(),
      previewColors: [Colors.orange, Colors.deepOrange[100]!],
    ),
  ];
  
  List<AppTheme> get availableThemes => _availableThemes;
  
  Future<AppTheme> getCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeId = prefs.getString(_themeKey) ?? 'default';
    
    return _availableThemes.firstWhere(
      (theme) => theme.id == themeId,
      orElse: () => _availableThemes.first,
    );
  }
  
  Future<void> setCurrentTheme(String themeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeId);
  }
  
  static ThemeData _createNatureTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.robotoTextTheme(),
    );
  }
  
  static ThemeData _createSunsetTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.latoTextTheme(),
    );
  }
}

class AppTheme {
  final String id;
  final String name;
  final ThemeData themeData;
  final List<Color> previewColors;
  
  const AppTheme({
    required this.id,
    required this.name,
    required this.themeData,
    required this.previewColors,
  });
}
```

### Theme Selector Widget:

```dart
class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Theme',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: themeProvider.availableThemes.map((theme) {
                return ThemePreviewCard(
                  theme: theme,
                  isSelected: theme.id == themeProvider.currentThemeId,
                  onTap: () => themeProvider.setTheme(theme.id),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class ThemePreviewCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final VoidCallback onTap;
  
  const ThemePreviewCard({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.themeData.colorScheme.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Color preview
            Row(
              children: theme.previewColors.map((color) {
                return Expanded(
                  child: Container(
                    height: 40,
                    color: color,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Text(
              theme.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Summary

- **ThemeData**: Comprehensive app theming with colors, fonts, and component styles
- **Dark Mode**: System preference detection and manual theme switching
- **Color Schemes**: Material 3 color system with semantic colors
- **Custom Fonts**: Local fonts and Google Fonts integration
- **Material vs Cupertino**: Platform-specific theming and components
- **Custom Widgets**: Reusable themed components with variants
- **Dynamic Themes**: Runtime theme switching with persistence

Consistent theming creates professional, cohesive user experiences.
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF121212),
    
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
```

---

## Dark Mode

Implement light and dark themes.

### Dynamic Theme Provider:

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
```

### Apply Themes:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'My App',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}
```

### Toggle Dark Mode:

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text("Dark Mode"),
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Color Schemes

Define custom colors for your app.

### ColorScheme:

```dart
const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6750a4),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFeaddff),
  onPrimaryContainer: Color(0xFF21005e),
  
  secondary: Color(0xFF625b71),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFe8def8),
  onSecondaryContainer: Color(0xFF1d192b),
  
  tertiary: Color(0xFF7d5260),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFffd8e4),
  onTertiaryContainer: Color(0xFF31111d),
  
  error: Color(0xFFb3261e),
  onError: Colors.white,
  errorContainer: Color(0xFff9dedc),
  onErrorContainer: Color(0xFF410e0b),
  
  background: Color(0xFfffbfe0),
  onBackground: Color(0xFF1c1b1f),
  
  surface: Color(0xFfffbfe0),
  onSurface: Color(0xFF1c1b1f),
);

MaterialApp(
  theme: ThemeData(useMaterial3: true, colorScheme: colorScheme),
)
```

### Material Design 3 Colors:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
)
```

---

## Custom Colors & Fonts

### Custom Font:

1. Add to `pubspec.yaml`:

```yaml
flutter:
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

2. Use in theme:

```dart
textTheme: TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
  ),
)
```

### Google Fonts Package:

```yaml
dependencies:
  google_fonts: ^4.0.0
```

```dart
import 'package:google_fonts/google_fonts.dart';

TextTheme(
  displayLarge: GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
  bodyLarge: GoogleFonts.roboto(fontSize: 16),
)
```

---

## Material vs Cupertino Design

### Material Design (Android):

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // Material-specific theming
  ),
)
```

### Cupertino Design (iOS):

```dart
CupertinoApp(
  theme: CupertinoThemeData(
    primaryColor: CupertinoColors.systemBlue,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(fontSize: 16),
    ),
  ),
)
```

### Platform-Aware Theming:

```dart
class AdaptiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoApp(
        theme: CupertinoThemeData(),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(),
      );
    }
  }
}
```

---

## Custom Widgets with Theme

### Respecting Theme:

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).textTheme.labelLarge?.color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
```

### Custom Theme Data:

```dart
class CustomTheme {
  static const Color primaryColor = Color(0xFF6750a4);
  static const Color secondaryColor = Color(0xFF625b71);
  static const Color tertiaryColor = Color(0xFF7d5260);
  
  static const Color lightBg = Color(0xFFFFFBFE);
  static const Color darkBg = Color(0xFF1C1B1F);
  
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16);
  static const EdgeInsets largePadding = EdgeInsets.all(24);
  
  static const double smallRadius = 4;
  static const double mediumRadius = 8;
  static const double largeRadius = 12;
}
```

---

## Gradients and Shadows

### Gradient Container:

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.blue, Colors.purple],
    ),
  ),
  child: Center(child: Text("Gradient")),
)
```

### Shadow and Elevation:

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  padding: EdgeInsets.all(16),
  child: Text("Elevated Card"),
)
```

---

## Text Styling Best Practices

### Consistent Text Styles:

```dart
// Define reusable text styles
final headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final bodyStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
  height: 1.5,
);

// Use
Text("Heading", style: headingStyle),
Text("Body text", style: bodyStyle),
```

### Theme-Aware Text:

```dart
Text(
  "Title",
  style: Theme.of(context).textTheme.headlineMedium,
)
```

---

## Summary

- **ThemeData**: Configure app-wide styling
- **Dark Mode**: Support light and dark themes
- **ColorScheme**: Define consistent colors
- **Custom Fonts**: Use custom or Google Fonts
- **Material vs Cupertino**: Choose design language
- **Custom Widgets**: Respect theme settings
- **Gradients and Shadows**: Add visual depth
- Apply theme consistently across your app
