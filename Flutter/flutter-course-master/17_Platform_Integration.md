# Flutter Platform Integration

Accessing native features and communicating with platform-specific code.

---

## Platform Channels

Communication between Dart and native code (Java/Kotlin for Android, Swift/Objective-C for iOS).

### Method Channel (Dart → Native):

**Dart code:**

```dart
class PlatformService {
  static const platformMethodChannel =
      MethodChannel('com.example.app/platform');

  Future<String> getPlatformVersion() async {
    try {
      final String result =
          await platformMethodChannel.invokeMethod('getPlatformVersion');
      return result;
    } on PlatformException catch (e) {
      return "Failed: ${e.message}";
    }
  }

  Future<void> launchURL(String url) async {
    try {
      await platformMethodChannel.invokeMethod('launchURL', {'url': url});
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }
}
```

**Android (Kotlin):**

```kotlin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/platform"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getPlatformVersion" -> {
                        result("Android ${android.os.Build.VERSION.RELEASE}")
                    }
                    "launchURL" -> {
                        val url = call.argument<String>("url")
                        launchURL(url!!)
                        result(null)
                    }
                    else -> result(NotImplemented)
                }
            }
    }

    private fun launchURL(url: String) {
        // Implementation
    }
}
```

**iOS (Swift):**

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class GeneratedPluginRegistrant: NSObject {
    override init() {
        super.init()
        let controller = (UIApplication.shared.delegate as! UIApplicationDelegate)
            .window??.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(
            name: "com.example.app/platform",
            binaryMessenger: controller.binaryMessenger
        )
        methodChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "getPlatformVersion":
                result("iOS \(UIDevice.current.systemVersion)")
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
```

### Advanced Method Channel:

```dart
class AdvancedPlatformService {
  static const MethodChannel _channel = MethodChannel('com.example.app/advanced');
  
  // Synchronous method call
  Future<String> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod('getDeviceInfo');
      return result.toString();
    } catch (e) {
      throw PlatformException(code: 'DEVICE_INFO_ERROR', message: e.toString());
    }
  }
  
  // Method with complex data
  Future<Map<String, dynamic>> getBatteryInfo() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('getBatteryInfo');
      return result ?? {};
    } catch (e) {
      return {'error': e.toString()};
    }
  }
  
  // Method with callback
  Future<void> performLongRunningTask(void Function(String) onProgress) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onProgress') {
        onProgress(call.arguments as String);
      }
    });
    
    await _channel.invokeMethod('startLongRunningTask');
  }
  
  // Method with error handling
  Future<bool> checkPermission(String permission) async {
    try {
      final result = await _channel.invokeMethod('checkPermission', {'permission': permission});
      return result as bool;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        return false;
      }
      rethrow;
    }
  }
}
```

### Platform Channel with Streams:

```dart
class StreamingPlatformService {
  static const MethodChannel _methodChannel = MethodChannel('com.example.app/streaming');
  static const EventChannel _eventChannel = EventChannel('com.example.app/streaming_events');
  
  Stream<dynamic>? _eventStream;
  
  Stream<dynamic> get eventStream {
    _eventStream ??= _eventChannel.receiveBroadcastStream();
    return _eventStream!;
  }
  
  Future<void> startStreaming() async {
    await _methodChannel.invokeMethod('startStreaming');
  }
  
  Future<void> stopStreaming() async {
    await _methodChannel.invokeMethod('stopStreaming');
  }
}

// Usage
final streamingService = StreamingPlatformService();

streamingService.eventStream.listen((event) {
  print('Received event: $event');
});

await streamingService.startStreaming();
```

---

## Event Channel (Native → Dart)

Streaming data from native to Dart.

### Basic Event Channel:

**Dart code:**

```dart
class SensorService {
  static const EventChannel _eventChannel = EventChannel('com.example.app/sensors');
  
  Stream<dynamic>? _accelerometerStream;
  
  Stream<dynamic> get accelerometerStream {
    _accelerometerStream ??= _eventChannel.receiveBroadcastStream();
    return _accelerometerStream!;
  }
  
  Stream<dynamic> getAccelerometerData() {
    return accelerometerStream.map((event) {
      if (event is Map) {
        return AccelerometerData(
          x: event['x'] ?? 0.0,
          y: event['y'] ?? 0.0,
          z: event['z'] ?? 0.0,
        );
      }
      return null;
    }).where((data) => data != null);
  }
}

class AccelerometerData {
  final double x, y, z;
  
  AccelerometerData({required this.x, required this.y, required this.z});
  
  @override
  String toString() => 'AccelerometerData(x: $x, y: $y, z: $z)';
}
```

**Android (Kotlin):**

```kotlin
class SensorPlugin : FlutterPlugin, EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val eventChannel = EventChannel(binding.binaryMessenger, "com.example.app/sensors")
        eventChannel.setStreamHandler(this)
        
        sensorManager = binding.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    }
    
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        accelerometer?.let { sensor ->
            sensorManager?.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }
    
    override fun onCancel(arguments: Any?) {
        sensorManager?.unregisterListener(this)
        eventSink = null
    }
    
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            val data = mapOf(
                "x" to it.values[0],
                "y" to it.values[1],
                "z" to it.values[2]
            )
            eventSink?.success(data)
        }
    }
    
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Handle accuracy changes
    }
}
```

**iOS (Swift):**

```swift
import Flutter
import CoreMotion

public class SensorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private let motionManager = CMMotionManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let eventChannel = FlutterEventChannel(
            name: "com.example.app/sensors",
            binaryMessenger: registrar.messenger()
        )
        let instance = SensorPlugin()
        eventChannel.setStreamHandler(instance)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let data = data {
                    let accelerometerData: [String: Double] = [
                        "x": data.acceleration.x,
                        "y": data.acceleration.y,
                        "z": data.acceleration.z
                    ]
                    self.eventSink?(accelerometerData)
                }
            }
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager.stopAccelerometerUpdates()
        eventSink = nil
        return nil
    }
}
```

### Advanced Event Channel:

```dart
class NetworkStatusService {
  static const EventChannel _eventChannel = EventChannel('com.example.app/network_status');
  
  Stream<NetworkStatus>? _networkStatusStream;
  
  Stream<NetworkStatus> get networkStatusStream {
    _networkStatusStream ??= _eventChannel.receiveBroadcastStream().map((event) {
      if (event is Map) {
        return NetworkStatus(
          isConnected: event['isConnected'] ?? false,
          connectionType: event['connectionType'] ?? 'unknown',
          strength: event['strength'] ?? 0,
        );
      }
      return NetworkStatus.unknown();
    });
    return _networkStatusStream!;
  }
}

class NetworkStatus {
  final bool isConnected;
  final String connectionType;
  final int strength;
  
  NetworkStatus({
    required this.isConnected,
    required this.connectionType,
    required this.strength,
  });
  
  factory NetworkStatus.unknown() {
    return NetworkStatus(
      isConnected: false,
      connectionType: 'unknown',
      strength: 0,
    );
  }
  
  @override
  String toString() {
    return 'NetworkStatus(isConnected: $isConnected, type: $connectionType, strength: $strength)';
  }
}
```

---

## Camera Integration

Accessing device camera for photo/video capture.

### Camera Plugin Usage:

```dart
class CameraService {
  static const MethodChannel _channel = MethodChannel('com.example.app/camera');
  
  Future<String?> takePhoto() async {
    try {
      final result = await _channel.invokeMethod('takePhoto');
      return result as String?;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }
  
  Future<String?> recordVideo(int durationSeconds) async {
    try {
      final result = await _channel.invokeMethod('recordVideo', {
        'duration': durationSeconds,
      });
      return result as String?;
    } catch (e) {
      print('Error recording video: $e');
      return null;
    }
  }
  
  Future<List<String>> getGalleryPhotos() async {
    try {
      final result = await _channel.invokeListMethod<String>('getGalleryPhotos');
      return result ?? [];
    } catch (e) {
      print('Error getting gallery photos: $e');
      return [];
    }
  }
}
```

### Camera Widget:

```dart
class CameraWidget extends StatefulWidget {
  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  final CameraService _cameraService = CameraService();
  String? _imagePath;
  bool _isRecording = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_imagePath != null)
          Image.file(File(_imagePath!)),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: Icon(Icons.camera),
              label: Text('Take Photo'),
            ),
            
            SizedBox(width: 16),
            
            ElevatedButton.icon(
              onPressed: _isRecording ? null : _recordVideo,
              icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
              label: Text(_isRecording ? 'Recording...' : 'Record Video'),
            ),
          ],
        ),
        
        ElevatedButton(
          onPressed: _openGallery,
          child: Text('Open Gallery'),
        ),
      ],
    );
  }
  
  Future<void> _takePhoto() async {
    final path = await _cameraService.takePhoto();
    if (path != null) {
      setState(() => _imagePath = path);
    }
  }
  
  Future<void> _recordVideo() async {
    setState(() => _isRecording = true);
    
    final path = await _cameraService.recordVideo(10);
    
    setState(() => _isRecording = false);
    
    if (path != null) {
      // Handle video path
      print('Video saved at: $path');
    }
  }
  
  Future<void> _openGallery() async {
    final photos = await _cameraService.getGalleryPhotos();
    // Navigate to gallery view with photos
  }
}
```

---

## Location Services

Accessing GPS and location data.

### Location Service:

```dart
class LocationService {
  static const MethodChannel _channel = MethodChannel('com.example.app/location');
  
  Future<LocationData?> getCurrentLocation() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('getCurrentLocation');
      if (result != null) {
        return LocationData.fromMap(result);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
    return null;
  }
  
  Future<void> startLocationUpdates() async {
    await _channel.invokeMethod('startLocationUpdates');
  }
  
  Future<void> stopLocationUpdates() async {
    await _channel.invokeMethod('stopLocationUpdates');
  }
  
  Future<bool> checkLocationPermission() async {
    try {
      final result = await _channel.invokeMethod('checkLocationPermission');
      return result as bool;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> requestLocationPermission() async {
    try {
      final result = await _channel.invokeMethod('requestLocationPermission');
      return result as bool;
    } catch (e) {
      return false;
    }
  }
}

class LocationData {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  
  LocationData({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.speed,
  });
  
  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      altitude: map['altitude'],
      accuracy: map['accuracy'],
      speed: map['speed'],
    );
  }
  
  @override
  String toString() {
    return 'LocationData(lat: $latitude, lng: $longitude, alt: $altitude)';
  }
}
```

### Location Widget:

```dart
class LocationWidget extends StatefulWidget {
  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final LocationService _locationService = LocationService();
  LocationData? _currentLocation;
  bool _isTracking = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }
  
  Future<void> _checkPermission() async {
    final hasPermission = await _locationService.checkLocationPermission();
    if (!hasPermission) {
      final granted = await _locationService.requestLocationPermission();
      if (!granted) {
        // Handle permission denied
      }
    }
  }
  
  Future<void> _getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    setState(() => _currentLocation = location);
  }
  
  Future<void> _toggleTracking() async {
    if (_isTracking) {
      await _locationService.stopLocationUpdates();
    } else {
      await _locationService.startLocationUpdates();
    }
    setState(() => _isTracking = !_isTracking);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_currentLocation != null)
          Text('Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}'),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Get Location'),
            ),
            
            SizedBox(width: 16),
            
            ElevatedButton(
              onPressed: _toggleTracking,
              child: Text(_isTracking ? 'Stop Tracking' : 'Start Tracking'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Notifications

Local and push notifications.

### Notification Service:

```dart
class NotificationService {
  static const MethodChannel _channel = MethodChannel('com.example.app/notifications');
  
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _channel.invokeMethod('showNotification', {
      'title': title,
      'body': body,
      'payload': payload,
    });
  }
  
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await _channel.invokeMethod('scheduleNotification', {
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.millisecondsSinceEpoch,
      'payload': payload,
    });
  }
  
  Future<void> cancelNotification(int id) async {
    await _channel.invokeMethod('cancelNotification', {'id': id});
  }
  
  Future<void> cancelAllNotifications() async {
    await _channel.invokeMethod('cancelAllNotifications');
  }
  
  Future<List<Map<String, dynamic>>> getPendingNotifications() async {
    final result = await _channel.invokeListMethod<Map<String, dynamic>>('getPendingNotifications');
    return result ?? [];
  }
}
```

### Notification Widget:

```dart
class NotificationWidget extends StatefulWidget {
  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  
  Future<void> _showNotification() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;
    
    await _notificationService.showNotification(
      title: _titleController.text,
      body: _bodyController.text,
    );
    
    _titleController.clear();
    _bodyController.clear();
  }
  
  Future<void> _scheduleNotification() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;
    
    final scheduledTime = DateTime.now().add(Duration(minutes: 1));
    
    await _notificationService.scheduleNotification(
      title: _titleController.text,
      body: _bodyController.text,
      scheduledTime: scheduledTime,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for ${scheduledTime.toString()}')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          
          TextField(
            controller: _bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
          
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _showNotification,
                  child: Text('Show Now'),
                ),
              ),
              
              SizedBox(width: 16),
              
              Expanded(
                child: ElevatedButton(
                  onPressed: _scheduleNotification,
                  child: Text('Schedule'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## File Access

Reading and writing files on device.

### File Service:

```dart
class FileService {
  static const MethodChannel _channel = MethodChannel('com.example.app/files');
  
  Future<String?> getDocumentsDirectory() async {
    try {
      final result = await _channel.invokeMethod('getDocumentsDirectory');
      return result as String?;
    } catch (e) {
      print('Error getting documents directory: $e');
      return null;
    }
  }
  
  Future<String?> readFile(String filePath) async {
    try {
      final result = await _channel.invokeMethod('readFile', {'path': filePath});
      return result as String?;
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }
  
  Future<bool> writeFile(String filePath, String content) async {
    try {
      await _channel.invokeMethod('writeFile', {
        'path': filePath,
        'content': content,
      });
      return true;
    } catch (e) {
      print('Error writing file: $e');
      return false;
    }
  }
  
  Future<List<String>> listFiles(String directoryPath) async {
    try {
      final result = await _channel.invokeListMethod<String>('listFiles', {'path': directoryPath});
      return result ?? [];
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }
  
  Future<bool> deleteFile(String filePath) async {
    try {
      await _channel.invokeMethod('deleteFile', {'path': filePath});
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
  
  Future<bool> fileExists(String filePath) async {
    try {
      final result = await _channel.invokeMethod('fileExists', {'path': filePath});
      return result as bool;
    } catch (e) {
      return false;
    }
  }
}
```

### File Manager Widget:

```dart
class FileManagerWidget extends StatefulWidget {
  @override
  State<FileManagerWidget> createState() => _FileManagerWidgetState();
}

class _FileManagerWidgetState extends State<FileManagerWidget> {
  final FileService _fileService = FileService();
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  String? _documentsPath;
  List<String> _files = [];
  String? _selectedFile;
  String? _fileContent;
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }
  
  Future<void> _initialize() async {
    _documentsPath = await _fileService.getDocumentsDirectory();
    if (_documentsPath != null) {
      await _listFiles();
    }
  }
  
  Future<void> _listFiles() async {
    if (_documentsPath == null) return;
    
    final files = await _fileService.listFiles(_documentsPath!);
    setState(() => _files = files);
  }
  
  Future<void> _readFile(String fileName) async {
    if (_documentsPath == null) return;
    
    final filePath = '$_documentsPath/$fileName';
    final content = await _fileService.readFile(filePath);
    
    setState(() {
      _selectedFile = fileName;
      _fileContent = content;
      _contentController.text = content ?? '';
    });
  }
  
  Future<void> _saveFile() async {
    if (_documentsPath == null || _fileNameController.text.isEmpty) return;
    
    final filePath = '$_documentsPath/${_fileNameController.text}';
    final success = await _fileService.writeFile(filePath, _contentController.text);
    
    if (success) {
      await _listFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved successfully')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // File list
        Expanded(
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: (context, index) {
              final fileName = _files[index];
              return ListTile(
                title: Text(fileName),
                onTap: () => _readFile(fileName),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final filePath = '$_documentsPath/$fileName';
                    await _fileService.deleteFile(filePath);
                    await _listFiles();
                  },
                ),
              );
            },
          ),
        ),
        
        // File editor
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _fileNameController,
                decoration: InputDecoration(labelText: 'File name'),
              ),
              
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
              
              ElevatedButton(
                onPressed: _saveFile,
                child: Text('Save File'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

---

## Plugins

Using Flutter plugins for platform integration.

### Using Existing Plugins:

```yaml
# pubspec.yaml
dependencies:
  camera: ^0.10.0
  location: ^4.4.0
  path_provider: ^2.0.11
  shared_preferences: ^2.0.15
  flutter_local_notifications: ^12.0.3
  image_picker: ^0.8.6
```

### Camera Plugin Example:

```dart
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraPluginExample extends StatefulWidget {
  @override
  State<CameraPluginExample> createState() => _CameraPluginExampleState();
}

class _CameraPluginExampleState extends State<CameraPluginExample> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  XFile? _image;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _controller = CameraController(_cameras[0], ResolutionPreset.medium);
      await _controller!.initialize();
      setState(() {});
    }
  }
  
  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    final image = await _controller!.takePicture();
    setState(() => _image = image);
  }
  
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() => _image = image);
  }
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_controller != null && _controller!.value.isInitialized)
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
        
        if (_image != null)
          Image.file(File(_image!.path)),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
            
            ElevatedButton(
              onPressed: _pickFromGallery,
              child: Text('Pick from Gallery'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Location Plugin Example:

```dart
import 'package:location/location.dart';

class LocationPluginExample extends StatefulWidget {
  @override
  State<LocationPluginExample> createState() => _LocationPluginExampleState();
}

class _LocationPluginExampleState extends State<LocationPluginExample> {
  Location location = Location();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }
  
  Future<void> _checkPermissions() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }
    
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
  }
  
  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await location.getLocation();
      setState(() => _currentLocation = locationData);
    } catch (e) {
      print('Error getting location: $e');
    }
  }
  
  void _startLocationUpdates() {
    _locationSubscription = location.onLocationChanged.listen((locationData) {
      setState(() => _currentLocation = locationData);
    });
  }
  
  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }
  
  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_currentLocation != null)
          Text('Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}'),
        
        ElevatedButton(
          onPressed: _getCurrentLocation,
          child: Text('Get Location'),
        ),
        
        ElevatedButton(
          onPressed: _locationSubscription == null ? _startLocationUpdates : _stopLocationUpdates,
          child: Text(_locationSubscription == null ? 'Start Updates' : 'Stop Updates'),
        ),
      ],
    );
  }
}
```

---

## Permissions

Requesting and managing app permissions.

### Permission Service:

```dart
class PermissionService {
  static const MethodChannel _channel = MethodChannel('com.example.app/permissions');
  
  Future<bool> checkPermission(String permission) async {
    try {
      final result = await _channel.invokeMethod('checkPermission', {'permission': permission});
      return result as bool;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> requestPermission(String permission) async {
    try {
      final result = await _channel.invokeMethod('requestPermission', {'permission': permission});
      return result as bool;
    } catch (e) {
      return false;
    }
  }
  
  Future<Map<String, bool>> checkMultiplePermissions(List<String> permissions) async {
    try {
      final result = await _channel.invokeMapMethod<String, bool>(
        'checkMultiplePermissions', 
        {'permissions': permissions}
      );
      return result ?? {};
    } catch (e) {
      return {};
    }
  }
  
  Future<Map<String, bool>> requestMultiplePermissions(List<String> permissions) async {
    try {
      final result = await _channel.invokeMapMethod<String, bool>(
        'requestMultiplePermissions', 
        {'permissions': permissions}
      );
      return result ?? {};
    } catch (e) {
      return {};
    }
  }
  
  Future<bool> openAppSettings() async {
    try {
      await _channel.invokeMethod('openAppSettings');
      return true;
    } catch (e) {
      return false;
    }
  }
}

class PermissionConstants {
  static const String camera = 'camera';
  static const String location = 'location';
  static const String storage = 'storage';
  static const String microphone = 'microphone';
  static const String contacts = 'contacts';
  static const String calendar = 'calendar';
  static const String notifications = 'notifications';
}
```

### Permission Widget:

```dart
class PermissionWidget extends StatefulWidget {
  @override
  State<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> {
  final PermissionService _permissionService = PermissionService();
  final Map<String, bool> _permissions = {};
  
  @override
  void initState() {
    super.initState();
    _checkAllPermissions();
  }
  
  Future<void> _checkAllPermissions() async {
    final permissions = await _permissionService.checkMultiplePermissions([
      PermissionConstants.camera,
      PermissionConstants.location,
      PermissionConstants.storage,
      PermissionConstants.notifications,
    ]);
    
    setState(() => _permissions.addAll(permissions));
  }
  
  Future<void> _requestPermission(String permission) async {
    final granted = await _permissionService.requestPermission(permission);
    setState(() => _permissions[permission] = granted);
  }
  
  Future<void> _requestAllPermissions() async {
    final results = await _permissionService.requestMultiplePermissions([
      PermissionConstants.camera,
      PermissionConstants.location,
      PermissionConstants.storage,
      PermissionConstants.notifications,
    ]);
    
    setState(() => _permissions.addAll(results));
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._permissions.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  entry.value ? Icons.check_circle : Icons.cancel,
                  color: entry.value ? Colors.green : Colors.red,
                ),
                if (!entry.value)
                  TextButton(
                    onPressed: () => _requestPermission(entry.key),
                    child: Text('Request'),
                  ),
              ],
            ),
          );
        }),
        
        ElevatedButton(
          onPressed: _requestAllPermissions,
          child: Text('Request All'),
        ),
        
        ElevatedButton(
          onPressed: () async {
            await _permissionService.openAppSettings();
          },
          child: Text('Open Settings'),
        ),
      ],
    );
  }
}
```

---

## Summary

- **Platform Channels**: MethodChannel for Dart-native communication, EventChannel for streaming data
- **Camera Integration**: Photo/video capture and gallery access
- **Location Services**: GPS location data and tracking
- **Notifications**: Local and scheduled notifications
- **File Access**: Reading/writing files and directory management
- **Plugins**: Using existing Flutter plugins for common functionality
- **Permissions**: Requesting and managing app permissions

Platform integration enables access to native device features and capabilities.
```

---

## Event Channel (Native → Dart):

Communication for continuous streams of data.

**Dart code:**

```dart
class EventChannelService {
  static const eventChannel =
      EventChannel('com.example.app/battery');

  Stream<int> get batteryLevel {
    return eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => event as int);
  }
}

class BatteryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: EventChannelService().batteryLevel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text("Battery: ${snapshot.data}%");
        }
        return Text("Loading...");
      },
    );
  }
}
```

**Android (Kotlin):**

```kotlin
EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.app/battery")
    .setStreamHandler(object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            val batteryLevel = getBatteryLevel()
            events?.success(batteryLevel)
        }

        override fun onCancel(arguments: Any?) {}
    })
```

---

## Common Use Cases

### Camera Access:

```yaml
dependencies:
  image_picker: ^0.8.0
```

```dart
import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}
```

### Location Access:

```yaml
dependencies:
  geolocator: ^9.0.0
```

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
```

### Notifications:

```yaml
dependencies:
  flutter_local_notifications: ^12.0.0
```

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initIOS = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: initAndroid, iOS: initIOS);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {},
    );
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      generalNotificationDetails,
    );
  }
}
```

### File Access:

```yaml
dependencies:
  file_picker: ^5.0.0
  path_provider: ^2.0.0
```

```dart
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<String> getAppDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveFile(String filename, String content) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsString(content);
    } catch (e) {
      print("Error: $e");
    }
  }
}
```

---

## Plugin Usage

### Choosing Plugins:

1. Check [pub.dev](https://pub.dev)
2. Look at:
   - Publication date (recent = well-maintained)
   - GitHub stars and activity
   - Issue/PR responses
   - Platform support

### Common Plugins:

| Plugin | Use Case |
|--------|----------|
| image_picker | Camera/gallery |
| geolocator | GPS location |
| flutter_local_notifications | Local notifications |
| firebase_messaging | Push notifications |
| connectivity_plus | Network status |
| device_info_plus | Device info |
| shared_preferences | User preferences |
| sqflite | Local database |

---

## Android Permissions

**AndroidManifest.xml:**

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

**Project-level build.gradle:**

```gradle
android {
    compileSdkVersion 33
    // ...
}
```

---

## iOS Permissions

**Info.plist:**

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access</string>
```

---

## Summary

- **Method Channel**: Dart ↔ Native communication
- **Event Channel**: Continuous data streams
- **Platform plugins**: Extend Flutter functionality
- **Permissions**: Request platform permissions
- **Common use cases**: Camera, location, notifications
- Always handle errors and missing permissions
