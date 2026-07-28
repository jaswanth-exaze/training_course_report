# Flutter Security Basics

Protecting Flutter applications and user data.

---

## API Security

### HTTPS & SSL/TLS

Always use HTTPS for API communication.

```dart
import 'dart:io';
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
));

class SecureHttpClientAdapter extends HttpClientAdapter {
  final SecurityContext context;

  SecureHttpClientAdapter(this.context);

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final client = HttpClient(context: context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Custom certificate pinning logic if needed
      return cert.pem == expectedCertificatePem;
    };

    final adapter = DefaultHttpClientAdapter();
    adapter.onHttpClientCreate = (_) => client;
    return adapter.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    // Clean-up if needed
  }
}

Future<void> setupDio() async {
  final context = SecurityContext(withTrustedRoots: true);
  dio.httpClientAdapter = SecureHttpClientAdapter(context);
}
```

### API Keys

**Never hardcode API keys in source code.**

```dart
// BAD
const String API_KEY = 'sk_live_12345';

// Better: Use dart-define or secure storage
const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
```

### Environment Variables & Build-time Secrets

Use build-time variables to avoid storing secrets in source control.

```bash
flutter run --dart-define=API_KEY=sk_live_12345
flutter build apk --dart-define=API_KEY=sk_live_12345
```

In Dart:

```dart
class Environment {
  static String get apiKey => const String.fromEnvironment('API_KEY');
}
```

### Token Handling

Use secure storage for long-lived tokens and rotatable refresh tokens.

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  final FlutterSecureStorage _storage;

  SecureTokenStorage([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
```

### Authorization Header with Dio

```dart
class AuthInterceptor extends Interceptor {
  final SecureTokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

---

## Secure Storage

### Flutter Secure Storage

Use `flutter_secure_storage` for sensitive data.

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
final secureStorage = const FlutterSecureStorage();

Future<void> saveSecret(String key, String value) async {
  await secureStorage.write(key: key, value: value);
}

Future<String?> readSecret(String key) async {
  return await secureStorage.read(key: key);
}
```

### Android KeyStore and iOS Keychain

`flutter_secure_storage` uses platform-specific secure containers:

- Android: `AndroidKeyStore`
- iOS / macOS: `Keychain`

### Sensitive Data Guidelines

Use secure storage for:
- Access tokens
- Refresh tokens
- API keys
- Biometric enrollment data
- Payment tokens

Use normal encrypted storage or local storage for:
- Non-sensitive preferences
- Cached UI state
- Analytics preferences

---

## Data Encryption

Encrypt sensitive local data before storage.

```dart
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final Encrypter _encrypter;
  final IV _iv;

  EncryptionService(String key)
      : _encrypter = Encrypter(AES(Key.fromUtf8(key)));

  EncryptionService.random()
      : _encrypter = Encrypter(AES(Key.fromSecureRandom(32))),
        _iv = IV.fromSecureRandom(16);

  String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptText(String cipherText) {
    return _encrypter.decrypt64(cipherText, iv: _iv);
  }
}
```

### Encrypting SharedPreferences Data

```dart
class EncryptedPreferences {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;
  final EncryptionService _encryptionService;

  EncryptedPreferences(
    this._secureStorage,
    this._prefs,
    this._encryptionService,
  );

  Future<void> writeSecurePreference(String key, String value) async {
    final encryptedValue = _encryptionService.encryptText(value);
    await _prefs.setString(key, encryptedValue);
  }

  Future<String?> readSecurePreference(String key) async {
    final encryptedValue = _prefs.getString(key);
    if (encryptedValue == null) return null;
    return _encryptionService.decryptText(encryptedValue);
  }
}
```

### File Encryption for Local Storage

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> writeEncryptedFile(String filename, String content) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  final bytes = utf8.encode(content);
  await file.writeAsBytes(bytes, flush: true);
  return file;
}

Future<String> readEncryptedFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  final bytes = await file.readAsBytes();
  return utf8.decode(bytes);
}
```

---

## Authentication and Authorization

### OAuth2 Patterns

Use OAuth2 for secure delegated access.

```dart
import 'package:oauth2/oauth2.dart' as oauth2;

class OAuth2Service {
  final oauth2.AuthorizationCodeGrant _grant;
  final Uri _authorizationEndpoint;
  final Uri _tokenEndpoint;
  final Uri _redirectUrl;

  OAuth2Service({
    required String clientId,
    required String clientSecret,
    required String authorizationEndpoint,
    required String tokenEndpoint,
    required String redirectUrl,
  }) :
        _authorizationEndpoint = Uri.parse(authorizationEndpoint),
        _tokenEndpoint = Uri.parse(tokenEndpoint),
        _redirectUrl = Uri.parse(redirectUrl),
        _grant = oauth2.AuthorizationCodeGrant(
          clientId,
          Uri.parse(authorizationEndpoint),
          Uri.parse(tokenEndpoint),
          secret: clientSecret,
          basicAuth: true,
        );

  Uri getAuthorizationUrl() {
    return _grant.getAuthorizationUrl(_redirectUrl);
  }

  Future<oauth2.Client> handleAuthorizationResponse(Map<String, String> queryParameters) async {
    return await _grant.handleAuthorizationResponse(queryParameters);
  }
}
```

### Biometric Authentication

Use `local_auth` for fingerprint and face unlock.

```dart
import 'package:local_auth/local_auth.dart';

final localAuth = LocalAuthentication();

Future<bool> authenticateUser() async {
  final canCheckBiometrics = await localAuth.canCheckBiometrics;
  final isDeviceSupported = await localAuth.isDeviceSupported();
  
  if (!canCheckBiometrics || !isDeviceSupported) {
    return false;
  }

  return await localAuth.authenticate(
    localizedReason: 'Please verify your identity to continue',
    options: const AuthenticationOptions(
      biometricOnly: true,
      stickyAuth: true,
    ),
  );
}
```

### Role-Based Authorization

Implement authorization in the app and backend.

```dart
enum UserRole { guest, user, admin }

class AuthorizationService {
  final UserRole currentUserRole;

  AuthorizationService(this.currentUserRole);

  bool canAccess(String resource) {
    switch (currentUserRole) {
      case UserRole.admin:
        return true;
      case UserRole.user:
        return resource != 'admin_panel';
      case UserRole.guest:
        return resource == 'public_feed';
    }
  }
}
```

---

## Application Hardening

### Obfuscation

Obfuscate Dart code before release.

```bash
flutter build apk --obfuscate --split-debug-info=/<path-to-debug-info>
flutter build ios --obfuscate --split-debug-info=/<path-to-debug-info>
```

### Minification and Shrinking

Use ProGuard/R8 for Android releases.

`android/app/build.gradle`:

```gradle
buildTypes {
    release {
        signingConfig signingConfigs.release
        shrinkResources true
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### Secure Network Configuration

Configure Android network security policies if you need custom trust anchors or to block cleartext traffic.

`android/app/src/main/res/xml/network_security_config.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">example.com</domain>
    </domain-config>
</network-security-config>
```

`android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

---

## Threat Modeling and Secure Design

### Common Threats:

1. Man-in-the-middle (MITM)
2. Data leakage through logs
3. Insecure local storage
4. Unvalidated API responses
5. Broken authentication
6. Broken authorization

### Secure Coding Practices:

- Validate all inputs
- Use strong encryption for sensitive data
- Use secure storage for tokens and secrets
- Limit permission scope to only what the app needs
- Avoid debug logging in production
- Keep dependencies up to date

### Example Secure Design Checklist:

```dart
class SecurityChecklist {
  static final List<String> items = [
    'Use HTTPS for all network requests',
    'Store tokens in secure storage',
    'Do not hardcode secrets in code or config',
    'Validate input and output data',
    'Use biometric authentication for sensitive actions',
    'Rotate tokens and refresh keys regularly',
    'Remove debug logs from production builds',
    'Use proguard/R8 and obfuscate production builds',
  ];
}
```

---

## Summary

- **HTTPS and API tokens**: Use secure transport and protect secrets
- **Secure storage**: Use platform-safe storage for sensitive data
- **Encryption**: Encrypt local data and token storage
- **Authentication**: Use OAuth2 and biometric authentication
- **Hardening**: Obfuscate, shrink, and secure network configuration
- **Design**: Apply secure coding patterns and threat modeling

Security is an ongoing process; review and improve continuously.


**Best: Use backend to proxy requests:**

```dart
// Client → Your Backend → Third-party API
// Your backend handles API keys

final response = await http.get(
  Uri.parse('https://your-backend.com/api/data'),
);
```

---

## Token Management

### Store Tokens Securely:

```yaml
dependencies:
  flutter_secure_storage: ^8.0.0
```

### Save Token:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await storage.write(
    key: 'auth_token',
    value: token,
  );
}
```

### Retrieve Token:

```dart
Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}
```

### Delete Token (Logout):

```dart
Future<void> logout() async {
  await storage.delete(key: 'auth_token');
}
```

### Refresh Token:

```dart
class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      
      if (refreshToken == null) return null;
      
      final response = await _dio.post(
        'https://api.example.com/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      final newAccessToken = response.data['access_token'];
      
      await _storage.write(
        key: 'access_token',
        value: newAccessToken,
      );
      
      return newAccessToken;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }
}
```

### Auto-Refresh with Interceptor:

```dart
final dio = Dio();

dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final newToken = await refreshAccessToken();
        if (newToken != null) {
          // Retry request with new token
          return handler.resolve(
            await dio.request(
              error.requestOptions.path,
              options: RequestOptions(
                method: error.requestOptions.method,
                headers: {'Authorization': 'Bearer $newToken'},
              ),
            ),
          );
        }
      }
      return handler.next(error);
    },
  ),
);
```

---

## Secure Storage

### What to Encrypt:

- Tokens
- Passwords
- API keys
- PII (Personal Identifiable Information)

### Implementation:

```dart
Future<void> saveCredentials(String username, String password) async {
  await storage.write(
    key: 'username',
    value: username,
  );
  
  await storage.write(
    key: 'password',
    value: password,
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
    ),
  );
}
```

---

## Input Validation

### Validate user input:

```dart
class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Enter a valid email';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain lowercase letter';
    }
    
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain number';
    }
    
    return null;
  }
}
```

### Use in Form:

```dart
TextFormField(
  validator: InputValidator.validateEmail,
  decoration: InputDecoration(labelText: 'Email'),
)
```

---

## Data Encryption

### Encrypt Sensitive Data:

```yaml
dependencies:
  encrypt: ^4.0.0
```

### Implementation:

```dart
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);
  late final encrypter = encrypt.Encrypter(encrypt.AES(key));
  
  String encryptData(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }
  
  String decryptData(String encryptedText) {
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
```

---

## Permissions

### Request Permissions:

```yaml
dependencies:
  permission_handler: ^11.0.0
```

### Usage:

```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();
  
  if (status.isDenied) {
    print('Permission denied');
  } else if (status.isGranted) {
    print('Permission granted');
  } else if (status.isPermanentlyDenied) {
    // Open app settings
    openAppSettings();
  }
}
```

### Android Manifest:

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

---

## SSL Pinning

### Advanced Certificate Pinning:

```dart
import 'package:http/http.dart' as http;
import 'dart:io';

class SSLPinningHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final httpClient = HttpClient();
    
    httpClient.badCertificateCallback = (cert, host, port) {
      // Verify certificate hash
      final hash = _getCertificateHash(cert);
      return _isPinnedCertificate(hash);
    };
    
    // Rest of implementation...
  }
  
  bool _isPinnedCertificate(String hash) {
    const pinnedHashes = [
      'sha256/12345...',  // Your certificate hash
    ];
    return pinnedHashes.contains(hash);
  }
}
```

---

## Data Protection at Rest

### SQLite Encryption:

```yaml
dependencies:
  sqflite: ^2.0.0
  sqflite_common_ffi: ^2.0.0
```

```dart
import 'package:sqflite/sqflite.dart';

Future<Database> openEncryptedDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'encrypted.db');
  
  final database = await openDatabase(
    path,
    onCreate: (db, version) {
      // Create tables
    },
    onOpen: (db) async {
      // Verify database integrity
    },
  );
  
  return database;
}
```

---

## Code Obfuscation

### Enable Obfuscation:

```bash
flutter build apk --obfuscate --split-debug-info=build/debug_info/
```

Or for production:

```bash
flutter build appbundle --release --obfuscate
```

---

## Dependency Security

### Check for Vulnerabilities:

```bash
flutter pub outdated
flutter pub upgrade --dry-run
```

### Best Practices:

1. **Keep packages updated**
2. **Review security advisories**
3. **Use trusted packages**
4. **Lock production versions**

---

## OWASP Top 10 for Mobile

1. **Improper Platform Usage**: Use frameworks correctly
2. **Insecure Data Storage**: Encrypt sensitive data
3. **Insecure Communication**: Always use HTTPS
4. **Insecure Authentication**: Secure token handling
5. **Insufficient Cryptography**: Use strong encryption
6. **Insecure Authorization**: Proper access control
7. **Client Code Quality**: Secure coding practices
8. **Code Tampering**: Code obfuscation
9. **Reverse Engineering**: Obfuscate code
10. **Extraneous Functionality**: Remove debug code

---

## Security Checklist

- [ ] All API calls use HTTPS
- [ ] API keys not hardcoded
- [ ] Tokens stored securely
- [ ] Input validation implemented
- [ ] Sensitive data encrypted
- [ ] Permissions requested properly
- [ ] Code obfuscated for release
- [ ] No debug logs in production
- [ ] Dependencies kept updated
- [ ] SSL pinning implemented
- [ ] Error handling doesn't expose info
- [ ] No PII in logs
- [ ] User data encrypted at rest
- [ ] Secure password requirements
- [ ] Token refresh implemented

---

## Summary

- **HTTPS**: Always use encrypted connections
- **Tokens**: Store securely in secure storage
- **Input Validation**: Validate all user input
- **Encryption**: Encrypt sensitive data
- **Permissions**: Request only needed permissions
- **Obfuscation**: Hide code from reverse engineering
- **Dependencies**: Keep updated and reviewed
- **Logging**: Don't log sensitive information
- **SSL Pinning**: Verify certificate authenticity
- Follow OWASP guidelines
