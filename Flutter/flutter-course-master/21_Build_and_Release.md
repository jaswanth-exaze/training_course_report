# Flutter Build & Release

Building and deploying Flutter applications.

---

## Build Commands

### Debug Build:

```bash
flutter build debug
flutter run  # Same as run, with hot reload
```

### Release Build:

```bash
flutter build release
# Generates optimized, production-ready app
```

### Building for Specific Platform:

```bash
# Android
flutter build apk
flutter build apk --split-per-abi  # Separate APK per architecture
flutter build appbundle  # For Play Store

# iOS
flutter build ios
flutter build ios --release
```

### Profile Build:

```bash
# Android
flutter build apk --profile
flutter build appbundle --profile

# iOS
flutter build ios --profile
```

### Build Configuration:

```yaml
# pubspec.yaml
flutter:
  build:
    # Build configuration
    debug:
      build_name: "1.0.0"
      build_number: "1"
    profile:
      build_name: "1.0.0"
      build_number: "1"
    release:
      build_name: "1.0.0"
      build_number: "1"
```

---

## Android Build & Release

### Build APK:

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (Recommended):

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Split APKs:

```bash
# Build separate APKs for different architectures
flutter build apk --release --split-per-abi

# Outputs:
# app-armeabi-v7a-release.apk
# app-arm64-v8a-release.apk
# app-x86_64-release.apk
```

### Custom Build Configuration:

```dart
// android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.example.myapp"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        
        // Custom build config
        buildConfigField "String", "API_BASE_URL", "\"https://api.example.com\""
        buildConfigField "boolean", "ENABLE_LOGGING", "false"
        
        // Multi-density support
        vectorDrawables.useSupportLibrary = true
    }
    
    buildTypes {
        debug {
            buildConfigField "String", "API_BASE_URL", "\"https://dev-api.example.com\""
            buildConfigField "boolean", "ENABLE_LOGGING", "true"
        }
        
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
        }
    }
    
    // Flavor configuration
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
        }
        
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
        }
        
        prod {
            dimension "environment"
        }
    }
}
```

### Signing:

**Generate keystore:**

```bash
# Generate keystore
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# Alternative: Generate keystore with more options
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload \
  -dname "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown" \
  -storepass STORE_PASSWORD \
  -keypass KEY_PASSWORD
```

**Configure signing in android/app/build.gradle:**

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

**key.properties file:**

```properties
storePassword=STORE_PASSWORD
keyPassword=KEY_PASSWORD
keyAlias=upload
storeFile=../key.jks
```

### Build Signed Release:

```bash
# Build signed APK
flutter build apk --release

# Build signed app bundle
flutter build appbundle --release

# Build for specific flavor
flutter build appbundle --release --flavor prod
```

### Versioning:

**pubspec.yaml:**

```yaml
version: 1.0.0+1
# Format: app_version+build_number
```

**Update before release:**

```yaml
version: 1.1.0+2  # Increment both
```

### Advanced Versioning:

```dart
// lib/version.dart
class AppVersion {
  static const String version = '1.0.0';
  static const int buildNumber = 1;
  
  static String get fullVersion => '$version+$buildNumber';
  
  static String get userAgent => 'MyApp/$fullVersion';
  
  static bool isNewerThan(String otherVersion) {
    // Version comparison logic
    return false; // Implement version comparison
  }
}

// android/app/build.gradle
def versionPropsFile = file('version.properties')
if (versionPropsFile.canRead()) {
    def Properties versionProps = new Properties()
    versionProps.load(new FileInputStream(versionPropsFile))
    
    def versionCode = versionProps['VERSION_CODE'].toInteger()
    def versionName = versionProps['VERSION_NAME']
    
    defaultConfig {
        versionCode versionCode
        versionName versionName
    }
}
```

---

## iOS Build & Release

### Prerequisites:

```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios && pod install
```

### Build for iOS:

```bash
# Build for simulator
flutter build ios --debug --simulator

# Build for device
flutter build ios --release

# Build with specific configuration
flutter build ios --release --no-codesign
```

### iOS Configuration:

```dart
// ios/Runner.xcodeproj/project.pbxproj
// Or use Xcode to configure:

// 1. Bundle Identifier: com.example.myapp
// 2. Version: 1.0.0
// 3. Build: 1
// 4. Team: Select your Apple Developer account
// 5. Provisioning Profile: Select appropriate profile
```

### Code Signing:

```bash
# Automatic signing (Xcode)
# 1. Open ios/Runner.xcworkspace in Xcode
# 2. Select target > Signing & Capabilities
# 3. Enable "Automatically manage signing"
# 4. Select your team

# Manual signing
# 1. Create provisioning profile in Apple Developer Console
# 2. Download and install profile
# 3. Configure in Xcode
```

### Build Archive:

```bash
# Create archive for App Store submission
flutter build ios --release

# Then use Xcode:
# 1. Open ios/Runner.xcworkspace
# 2. Product > Archive
# 3. Distribute App > App Store Connect
```

### iOS Flavors:

```dart
// ios/Runner.xcodeproj/xcshareddata/xcschemes/
// Create different schemes for different environments

// Runner-Dev.xcscheme
// Runner-Staging.xcscheme
// Runner-Prod.xcscheme
```

### iOS Build Configuration:

```dart
// ios/Runner/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>MyApp</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>myapp</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    
    <!-- Custom configurations -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
    </dict>
    
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    
    <!-- Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to take photos</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to select images</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access for maps</string>
</dict>
</plist>
```

---

## CI/CD Integration

### GitHub Actions:

```yaml
# .github/workflows/build.yml
name: Build and Release

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build Android APK
      run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: android-apk
        path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.10.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Install CocoaPods
      run: |
        cd ios
        pod install
    
    - name: Build iOS
      run: flutter build ios --release --no-codesign
    
    - name: Upload iOS build
      uses: actions/upload-artifact@v3
      with:
        name: ios-build
        path: build/ios/iphoneos/Runner.app

  release:
    needs: [build-android, build-ios]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Download Android APK
      uses: actions/download-artifact@v3
      with:
        name: android-apk
    
    - name: Download iOS build
      uses: actions/download-artifact@v3
      with:
        name: ios-build
    
    - name: Create Release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: v${{ github.run_number }}
        release_name: Release v${{ github.run_number }}
        body: |
          Automated release
        draft: false
        prerelease: false
```

### Fastlane Integration:

```ruby
# Gemfile
source "https://rubygems.org"

gem "fastlane"

# fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Build and deploy Android app"
  lane :deploy do
    # Build
    sh("flutter build appbundle --release")
    
    # Upload to Play Store
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end
end

platform :ios do
  desc "Build and deploy iOS app"
  lane :deploy do
    # Build
    sh("flutter build ios --release")
    
    # Upload to TestFlight
    upload_to_testflight
  end
end
```

### Codemagic CI/CD:

```yaml
# codemagic.yaml
workflows:
  android-workflow:
    name: Android Build
    instance_type: mac_mini_m1
    max_build_duration: 30
    environment:
      flutter: stable
      xcode: latest
    scripts:
      - name: Install dependencies
        script: flutter pub get
      - name: Build Android
        script: flutter build appbundle --release
    artifacts:
      - build/**/outputs/bundle/**/*.aab
    publishing:
      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal

  ios-workflow:
    name: iOS Build
    instance_type: mac_mini_m1
    max_build_duration: 30
    environment:
      flutter: stable
      xcode: latest
    scripts:
      - name: Install dependencies
        script: flutter pub get
      - name: Install CocoaPods
        script: |
          cd ios
          pod install
      - name: Build iOS
        script: flutter build ios --release
    artifacts:
      - build/ios/iphoneos/**/*.app
    publishing:
      app_store_connect:
        api_key: $APP_STORE_CONNECT_PRIVATE_KEY
        key_id: $APP_STORE_CONNECT_KEY_IDENTIFIER
        issuer_id: $APP_STORE_CONNECT_ISSUER_ID
```

---

## Deployment Strategies

### Blue-Green Deployment:

```dart
class DeploymentManager {
  static const String _currentVersionKey = 'current_version';
  static const String _blueVersion = '1.0.0';
  static const String _greenVersion = '1.1.0';
  
  static Future<String> getCurrentVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentVersionKey) ?? _blueVersion;
  }
  
  static Future<void> switchVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentVersionKey, version);
    
    // Force app restart
    Phoenix.rebirth(context);
  }
  
  static Future<void> rollback() async {
    final currentVersion = await getCurrentVersion();
    final rollbackVersion = currentVersion == _blueVersion ? _greenVersion : _blueVersion;
    
    await switchVersion(rollbackVersion);
  }
}
```

### Feature Flags:

```dart
class FeatureFlags {
  static const String _flagsKey = 'feature_flags';
  
  static Future<Map<String, bool>> getFlags() async {
    final prefs = await SharedPreferences.getInstance();
    final flagsJson = prefs.getString(_flagsKey);
    
    if (flagsJson != null) {
      final flags = jsonDecode(flagsJson) as Map<String, dynamic>;
      return flags.map((key, value) => MapEntry(key, value as bool));
    }
    
    return _defaultFlags;
  }
  
  static Future<void> setFlag(String flag, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    final flags = await getFlags();
    flags[flag] = enabled;
    
    await prefs.setString(_flagsKey, jsonEncode(flags));
  }
  
  static Future<bool> isEnabled(String flag) async {
    final flags = await getFlags();
    return flags[flag] ?? false;
  }
  
  static const Map<String, bool> _defaultFlags = {
    'new_ui': false,
    'dark_mode': true,
    'notifications': true,
  };
}

// Usage
class FeatureGatedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: FeatureFlags.isEnabled('new_ui'),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return NewUIWidget();
        }
        return OldUIWidget();
      },
    );
  }
}
```

### Staged Rollout:

```dart
class StagedRollout {
  static Future<bool> shouldEnableFeature(String feature, {double percentage = 10.0}) async {
    final deviceId = await _getDeviceId();
    final hash = _hashString(deviceId + feature);
    final normalizedHash = hash % 100;
    
    return normalizedHash < percentage;
  }
  
  static Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    }
    
    return 'unknown';
  }
  
  static int _hashString(String input) {
    var hash = 0;
    for (var i = 0; i < input.length; i++) {
      final char = input.codeUnitAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.abs();
  }
}

// Usage
Future<void> initApp() async {
  final enableNewFeature = await StagedRollout.shouldEnableFeature('new_feature', percentage: 20.0);
  
  if (enableNewFeature) {
    // Enable new feature for 20% of users
  }
}
```

---

## App Store Submission

### Google Play Store:

```bash
# Upload using fastlane
fastlane supply --aab build/app/outputs/bundle/release/app-release.aab --track internal

# Or use Google Play Developer API
```

### Play Store Configuration:

```json
// fastlane/metadata/android/en-US/changelogs/default.txt
- Bug fixes and performance improvements
- New feature: Dark mode support
- Updated UI components

// fastlane/metadata/android/en-US/full_description.txt
A comprehensive Flutter application that provides...

// fastlane/metadata/android/en-US/short_description.txt
A powerful Flutter app for productivity
```

### iOS App Store:

```bash
# Upload using fastlane
fastlane deliver --ipa build/ios/iphoneos/Runner.ipa --skip_screenshots

# Or use Xcode:
# 1. Open ios/Runner.xcworkspace
# 2. Product > Archive
# 3. Distribute App > App Store Connect
```

### App Store Metadata:

```xml
<!-- ios/metadata.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://apple.com/itunes/importer" version="software5.11">
  <software>
    <vendor_id>123456789</vendor_id>
    <bundle_identifier>com.example.myapp</bundle_identifier>
    <version>1.0.0</version>
    
    <locales>
      <locale name="en-US">
        <title>My Awesome App</title>
        <description>
          A comprehensive Flutter application that provides amazing features...
        </description>
        <keywords>flutter,app,productivity</keywords>
        <version_whats_new>
          - Bug fixes and performance improvements
          - New feature: Dark mode support
          - Updated UI components
        </version_whats_new>
      </locale>
    </locales>
    
    <software_screenshots>
      <software_screenshot display_target="iOS-6.5-in" position="1">
        <file_name>screenshot1.png</file_name>
        <size>1242x2688</size>
      </software_screenshot>
    </software_screenshots>
  </software>
</package>
```

### Screenshots Automation:

```dart
class ScreenshotGenerator {
  static Future<void> generateScreenshots() async {
    // Use flutter_driver for automated screenshots
    
    final driver = await FlutterDriver.connect();
    
    // Navigate to different screens and take screenshots
    await driver.tap(find.byValueKey('home_screen'));
    await _takeScreenshot(driver, 'home_screen');
    
    await driver.tap(find.byValueKey('settings_screen'));
    await _takeScreenshot(driver, 'settings_screen');
    
    await driver.close();
  }
  
  static Future<void> _takeScreenshot(FlutterDriver driver, String name) async {
    final pixels = await driver.screenshot();
    final file = File('screenshots/$name.png');
    await file.writeAsBytes(pixels);
  }
}
```

### Beta Testing:

```dart
// Google Play Beta
// 1. Create beta track in Play Console
// 2. Upload app bundle
// 3. Add testers via email or Google Group
// 4. Publish to beta

// TestFlight Beta
// 1. Upload build to App Store Connect
// 2. Add testers via email
// 3. Publish to TestFlight
// 4. Testers download via TestFlight app
```

---

## Build Optimization

### Tree Shaking:

```yaml
# pubspec.yaml
flutter:
  build:
    tree_shake_icons: true
    
# Enable in build.gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### Asset Optimization:

```dart
class AssetOptimizer {
  static Future<void> optimizeImages() async {
    final assetDir = Directory('assets/images');
    final files = assetDir.listSync();
    
    for (final file in files) {
      if (file is File && _isImageFile(file.path)) {
        await _compressImage(file);
      }
    }
  }
  
  static bool _isImageFile(String path) {
    return path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg');
  }
  
  static Future<void> _compressImage(File file) async {
    // Use image compression library
    final bytes = await file.readAsBytes();
    final compressed = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 800,
      minHeight: 600,
      quality: 80,
    );
    
    await file.writeAsBytes(compressed);
  }
}
```

### Bundle Size Analysis:

```bash
# Analyze APK size
flutter build apk --analyze-size

# Analyze app bundle
flutter build appbundle --analyze-size

# View build output
flutter build apk --verbose
```

### Performance Monitoring:

```dart
class BuildMetrics {
  static Future<void> logBuildMetrics() async {
    final buildDir = Directory('build');
    final size = await _calculateDirectorySize(buildDir);
    
    print('Build size: ${_formatBytes(size)}');
    
    // Log to analytics
    await _sendMetricsToAnalytics({
      'build_size': size,
      'build_time': DateTime.now().toIso8601String(),
      'flutter_version': await _getFlutterVersion(),
    });
  }
  
  static Future<int> _calculateDirectorySize(Directory dir) async {
    int size = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return size;
  }
  
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  static Future<String> _getFlutterVersion() async {
    final result = await Process.run('flutter', ['--version']);
    return result.stdout.toString().split('\n').first;
  }
  
  static Future<void> _sendMetricsToAnalytics(Map<String, dynamic> metrics) async {
    // Send to your analytics service
    print('Build metrics: $metrics');
  }
}
```

---

## Summary

- **Build Commands**: Use flutter build commands for different platforms and configurations
- **Android**: Build APKs and app bundles with proper signing and versioning
- **iOS**: Build archives with code signing and provisioning profiles
- **CI/CD**: Automate builds and deployments with GitHub Actions, Fastlane, or Codemagic
- **Deployment**: Use blue-green deployments, feature flags, and staged rollouts
- **App Stores**: Submit to Google Play and App Store with proper metadata and screenshots
- **Optimization**: Tree shaking, asset optimization, and bundle size analysis

Build and release processes should be automated and include proper testing and quality assurance.

---

## iOS Build & Release

### Build iOS App:

```bash
flutter build ios --release
```

### Configure Signing:

1. Open `ios/Runner.xcworkspace` (NOT .xcodeproj)
2. Select Runner in Project navigator
3. Go to Signing & Capabilities
4. Select Team

### Build Archive:

```bash
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -archivePath build/Runner.xcarchive \
  archive
```

### Upload to App Store:

1. Create App ID and Certificates in Apple Developer
2. Build archive in Xcode
3. Use Xcode Organizer to upload
4. Or use transporter CLI

---

## Play Store Submission

### Prepare:

1. Create Google Play Developer account ($25)
2. Create app listing
3. Add screenshots, description, etc.
4. Upload signed AAB

### Upload AAB:

1. Go to Google Play Console
2. Internal Testing / Closed Testing / Production
3. Upload AAB
4. Fill in release notes
5. Review and submit

### Timeline:

- **Internal Testing**: Immediate
- **Closed Testing**: ~1 hour
- **Production**: 2-4 hours review

---

## App Store Submission

### Prepare:

1. Create Apple Developer account ($99/year)
2. Create app in App Store Connect
3. Take screenshots (5 sizes)
4. Write description and keywords
5. Configure pricing

### Upload:

1. Archive app in Xcode
2. Validate archive
3. Upload archive
4. Submit for review

### Review Process:

- Typically 24-48 hours
- May request changes
- Resubmit if rejected

---

## Versioning Strategy

### Semantic Versioning:

```
MAJOR.MINOR.PATCH+BUILD
3.2.1+15

MAJOR: Incompatible API changes
MINOR: New features, backward compatible
PATCH: Bug fixes
BUILD: Build number (auto-increment)
```

### Update Versions:

```dart
// pubspec.yaml
version: 1.0.0+1

// Code
if (Platform.isAndroid) {
  print("Version: 1.0.0");
}
```

---

## Configuration Management

### Environment-Specific Builds:

```bash
# Development
flutter run -t lib/main_dev.dart

# Production
flutter run -t lib/main_prod.dart
```

### main_dev.dart:

```dart
void main() {
  // Dev configuration
  setupDev();
  runApp(const MyApp());
}
```

### main_prod.dart:

```dart
void main() {
  // Prod configuration
  setupProd();
  runApp(const MyApp());
}
```

### Flavor Configuration:

```bash
flutter build apk --flavor development
flutter build apk --flavor production
```

---

## App Size Optimization

### Analyze Size:

```bash
flutter build apk --analyze-size
```

### Reduce Size:

1. **Remove unused code**:

```bash
flutter build apk --split-debug-info=build/debug_info
```

2. **Optimize images**: Use WebP, compress
3. **Remove unused assets**: Clean pubspec.yaml
4. **Use ProGuard** (Android):

```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
        }
    }
}
```

5. **Fat APK Split** (Android):

```bash
flutter build apk --split-per-abi
```

---

## Release Checklist

- [ ] Update version number
- [ ] Update app name if needed
- [ ] Test on real devices
- [ ] Complete unit tests
- [ ] Run static analysis: `flutter analyze`
- [ ] Check for console warnings
- [ ] Update changelog
- [ ] Remove debug prints and logs
- [ ] Check app icons and splash screens
- [ ] Configure proper permissions
- [ ] Test push notifications
- [ ] Verify analytics integration
- [ ] Check crash reporting setup
- [ ] Update README and documentation
- [ ] Create git tag for release
- [ ] Build signed release APK/AAB
- [ ] Test signed build on device
- [ ] Upload to stores
- [ ] Monitor crash reports post-release

---

## Post-Release

### Monitor:

1. Check crash reports
2. Monitor analytics
3. Respond to reviews
4. Track performance

### Update:

1. Fix critical bugs immediately
2. Release minor updates with new features
3. Keep changelog up to date
4. Communicate with users

### Versioning After Release:

- **Patch release**: 1.0.1 (bug fixes)
- **Minor releases**: 1.1.0 (features)
- **Major releases**: 2.0.0 (breaking changes)

---

## CI/CD Integration

### GitHub Actions:

```yaml
name: Build and Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
      
      - run: flutter pub get
      
      - run: flutter build apk --release
      
      - name: Upload to Play Store
        run: # Upload script
```

---

## Summary

- **Debug**: Use `flutter run`
- **Release**: Use `flutter build release`
- **APK**: For side-loading
- **AAB**: For Play Store (recommended)
- **Signing**: Required for release
- **Versioning**: Use semantic versioning
- **Size**: Analyze and optimize
- **Stores**: Follow submission guidelines
- **CI/CD**: Automate build process
- **Monitor**: Track crashes and feedback
