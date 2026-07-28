# Flutter Basic UI Widgets

This section covers the fundamental widgets used to build basic user interfaces in Flutter.

---

## Text Widget

The **Text** widget displays a string of text with optional styling.

### Basic Usage:

```dart
Text("Hello, Flutter!")
```

### With Styling:

```dart
Text(
  "Hello, Flutter!",
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontStyle: FontStyle.italic,
    letterSpacing: 2,
    wordSpacing: 4,
    decoration: TextDecoration.underline,
    decorationColor: Colors.red,
    decorationThickness: 2,
    height: 1.5,
  ),
)
```

### Text Properties:

```dart
Text(
  "Text Example",
  // Alignment
  textAlign: TextAlign.center,
  
  // Direction
  textDirection: TextDirection.ltr,
  
  // Overflow handling
  overflow: TextOverflow.ellipsis, // ..., fade, clip, visible
  
  // Max lines
  maxLines: 2,
  
  // Soft wrap
  softWrap: true,
  
  // Scale factor
  textScaleFactor: 1.5,
)
```

### TextStyle in Detail:

```dart
TextStyle(
  // Font properties
  fontSize: 18,
  fontWeight: FontWeight.w700, // 100-900 or bold, normal
  fontStyle: FontStyle.italic,
  
  // Color
  color: Colors.black,
  backgroundColor: Colors.yellow,
  
  // Spacing
  letterSpacing: 1.0, // Space between letters
  wordSpacing: 2.0,   // Space between words
  
  // Decoration
  decoration: TextDecoration.underline,
  decorationColor: Colors.red,
  decorationStyle: TextDecorationStyle.wavy, // solid, double, dotted, dashed, wavy
  decorationThickness: 2.0,
  
  // Line height
  height: 1.5,
  
  // Shadow
  shadows: [
    Shadow(
      offset: Offset(2, 2),
      blurRadius: 4,
      color: Colors.grey,
    ),
  ],
)
```

### Rich Text (Multiple Styles):

```dart
RichText(
  text: TextSpan(
    text: 'Hello ',
    style: TextStyle(color: Colors.black, fontSize: 18),
    children: [
      TextSpan(
        text: 'Flutter',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      TextSpan(
        text: ' World!',
        style: TextStyle(
          color: Colors.green,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  ),
)
```

### Text with Theme:

```dart
class ThemedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  
  const ThemedText(this.text, {super.key, this.style});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.primary,
    );
    
    return Text(
      text,
      style: style ?? defaultStyle,
    );
  }
}
```

### Advanced Text Features:

```dart
// Text with selectable text
SelectableText(
  'This text can be selected and copied',
  style: TextStyle(fontSize: 16),
  showCursor: true,
  cursorColor: Colors.blue,
  cursorWidth: 2,
)

// Text with custom font
Text(
  'Custom Font Text',
  style: GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
)

// Text with gradient
ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [Colors.blue, Colors.purple],
  ).createShader(bounds),
  child: Text(
    'Gradient Text',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white, // This will be masked
    ),
  ),
)
```

---

## Image Widget

The **Image** widget displays images from various sources.

### Network Image:

```dart
Image.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error, size: 50, color: Colors.red);
  },
)
```

### Asset Image:

```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.contain,
  color: Colors.blue,
  colorBlendMode: BlendMode.multiply,
)
```

### File Image:

```dart
// From file path
Image.file(
  File('/path/to/image.jpg'),
  width: 200,
  height: 200,
)

// From picked file
final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
if (pickedFile != null) {
  Image.file(File(pickedFile.path));
}
```

### Memory Image:

```dart
// From bytes
Image.memory(
  imageBytes,
  width: 200,
  height: 200,
)
```

### Image Properties:

```dart
Image(
  image: NetworkImage('https://example.com/image.jpg'),
  
  // Size
  width: 200,
  height: 200,
  
  // Scaling
  fit: BoxFit.cover, // cover, contain, fill, fitWidth, fitHeight, none, scaleDown
  
  // Alignment
  alignment: Alignment.center,
  
  // Repeat
  repeat: ImageRepeat.repeat,
  
  // Color overlay
  color: Colors.blue.withOpacity(0.5),
  colorBlendMode: BlendMode.overlay,
  
  // Filter quality
  filterQuality: FilterQuality.high,
  
  // Cache behavior
  cacheWidth: 400,  // Cache at specific size
  cacheHeight: 400,
)
```

### Advanced Image Handling:

```dart
// Cached network image
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)

// Image with fade in
FadeInImage(
  placeholder: AssetImage('assets/placeholder.png'),
  image: NetworkImage('https://example.com/image.jpg'),
  fadeInDuration: Duration(milliseconds: 300),
  width: 200,
  height: 200,
)

// Circle avatar with image
CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  backgroundColor: Colors.grey,
)

// Hero animation for images
Hero(
  tag: 'image-hero',
  child: Image.network('https://example.com/image.jpg'),
)
```

### Image Optimization:

```dart
// Resize for performance
Image.network(
  'https://example.com/large-image.jpg',
  width: 200,
  height: 200,
  cacheWidth: 400,  // Cache at 2x for crisp display
  cacheHeight: 400,
  filterQuality: FilterQuality.medium, // Balance quality/speed
)

// Use appropriate formats
// Prefer: WebP > PNG > JPG
// Use SVG for vector graphics
SvgPicture.asset(
  'assets/icons/logo.svg',
  width: 100,
  height: 100,
)
```

---

## Icon Widget

The **Icon** widget displays icons from the Material Design icon set.

### Basic Usage:

```dart
Icon(
  Icons.home,
  size: 24,
  color: Colors.blue,
)
```

### Icon Properties:

```dart
Icon(
  Icons.favorite,
  
  // Size
  size: 48,
  
  // Color
  color: Colors.red,
  
  // Semantic label for accessibility
  semanticLabel: 'Favorite',
  
  // Text direction
  textDirection: TextDirection.ltr,
)
```

### Custom Icons:

```dart
// Using custom icon font
class MyIcons {
  MyIcons._();
  
  static const IconData heart = IconData(0xe800, fontFamily: 'MyIcons');
  static const IconData star = IconData(0xe801, fontFamily: 'MyIcons');
}

// Usage
Icon(MyIcons.heart, size: 24, color: Colors.red)
```

### Icon with Theme:

```dart
// Using theme colors
Icon(
  Icons.settings,
  color: Theme.of(context).colorScheme.primary,
  size: 24,
)

// Icon button
IconButton(
  icon: Icon(Icons.more_vert),
  onPressed: () {
    // Show menu
  },
)
```

### Advanced Icon Usage:

```dart
// Animated icon
AnimatedIcon(
  icon: AnimatedIcons.menu_arrow,
  progress: _animationController,
  size: 24,
)

// Icon with badge
Badge(
  badgeContent: Text('3'),
  child: Icon(Icons.notifications),
)

// Icon in different styles
Icon(
  Icons.home,
  size: 24,
  color: Colors.blue,
  shadows: [
    Shadow(
      offset: Offset(1, 1),
      blurRadius: 2,
      color: Colors.black26,
    ),
  ],
)
```

---

## Button Widgets

Flutter provides several types of button widgets.

### ElevatedButton:

```dart
ElevatedButton(
  onPressed: () {
    print('Button pressed');
  },
  child: Text('Elevated Button'),
  
  // Styling
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 4,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

### TextButton:

```dart
TextButton(
  onPressed: () {},
  child: Text('Text Button'),
  
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
)
```

### OutlinedButton:

```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Outlined Button'),
  
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.blue,
    side: BorderSide(color: Colors.blue, width: 2),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

### IconButton:

```dart
IconButton(
  onPressed: () {},
  icon: Icon(Icons.favorite),
  color: Colors.red,
  iconSize: 24,
  tooltip: 'Add to favorites',
  
  style: IconButton.styleFrom(
    backgroundColor: Colors.white,
    elevation: 2,
  ),
)
```

### FloatingActionButton:

```dart
FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  elevation: 6,
  tooltip: 'Add new item',
)

// Extended FAB
FloatingActionButton.extended(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Create'),
)
```

### Custom Button:

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double borderRadius;
  
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

### Button States:

```dart
class StatefulButton extends StatefulWidget {
  @override
  State<StatefulButton> createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  bool _isLoading = false;
  
  Future<void> _handlePress() async {
    setState(() => _isLoading = true);
    try {
      await performAsyncOperation();
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePress,
      child: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text('Submit'),
    );
  }
}
```

---

## Input Widgets

### TextField:

```dart
TextField(
  // Controller
  controller: _textController,
  
  // Decoration
  decoration: InputDecoration(
    labelText: 'Enter text',
    hintText: 'Type something...',
    prefixIcon: Icon(Icons.search),
    suffixIcon: IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => _textController.clear(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.grey.shade100,
  ),
  
  // Properties
  keyboardType: TextInputType.emailAddress,
  obscureText: false,
  maxLength: 100,
  maxLines: 1,
  
  // Callbacks
  onChanged: (value) {
    print('Text changed: $value');
  },
  onSubmitted: (value) {
    print('Submitted: $value');
  },
)
```

### TextFormField (with validation):

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
  ),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  },
  onSaved: (value) {
    // Save the value
  },
)
```

### Advanced TextField:

```dart
class PasswordField extends StatefulWidget {
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
```

---

## Selection Widgets

### Checkbox:

```dart
class CheckboxExample extends StatefulWidget {
  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _isChecked = false;
  
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value ?? false;
        });
      },
      activeColor: Colors.blue,
      checkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
```

### Radio Buttons:

```dart
enum SingingCharacter { lafayette, jefferson }

class RadioExample extends StatefulWidget {
  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  SingingCharacter? _character = SingingCharacter.lafayette;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<SingingCharacter>(
          title: Text('Lafayette'),
          value: SingingCharacter.lafayette,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<SingingCharacter>(
          title: Text('Jefferson'),
          value: SingingCharacter.jefferson,
          groupValue: _character,
          onChanged: (value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ],
    );
  }
}
```

### Switch:

```dart
class SwitchExample extends StatefulWidget {
  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _isSwitched = false;
  
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isSwitched,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
        });
      },
      activeColor: Colors.blue,
      activeTrackColor: Colors.blue.shade200,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.shade300,
    );
  }
}
```

### Dropdown:

```dart
class DropdownExample extends StatefulWidget {
  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? _selectedValue;
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];
  
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      hint: Text('Select an option'),
      items: _options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
      style: TextStyle(color: Colors.black, fontSize: 16),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 8,
      isExpanded: true,
    );
  }
}
```

---

## Progress Indicators

### CircularProgressIndicator:

```dart
// Indeterminate
CircularProgressIndicator(
  color: Colors.blue,
  strokeWidth: 4,
  backgroundColor: Colors.grey.shade200,
)

// Determinate
CircularProgressIndicator(
  value: 0.7, // 70% complete
  color: Colors.green,
  backgroundColor: Colors.grey.shade200,
  strokeWidth: 6,
)
```

### LinearProgressIndicator:

```dart
// Indeterminate
LinearProgressIndicator(
  color: Colors.blue,
  backgroundColor: Colors.grey.shade200,
  minHeight: 4,
)

// Determinate
LinearProgressIndicator(
  value: 0.8,
  color: Colors.orange,
  backgroundColor: Colors.grey.shade200,
)
```

### Custom Progress Widget:

```dart
class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;
  
  const CustomProgressIndicator({
    super.key,
    required this.progress,
    this.color = Colors.blue,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
        ),
      ),
    );
  }
}
```

---

## Card Widget

The **Card** widget provides a material design card.

```dart
Card(
  elevation: 4,
  margin: EdgeInsets.all(16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  color: Colors.white,
  shadowColor: Colors.black26,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Title',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text('Card content goes here...'),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('OK'),
            ),
          ],
        ),
      ],
    ),
  ),
)
```

---

## Chip Widgets

### Chip:

```dart
Chip(
  label: Text('Basic Chip'),
  avatar: CircleAvatar(
    child: Text('A'),
  ),
  deleteIcon: Icon(Icons.close),
  onDeleted: () {
    print('Chip deleted');
  },
  backgroundColor: Colors.blue.shade100,
  labelStyle: TextStyle(color: Colors.blue.shade900),
)
```

### ActionChip:

```dart
ActionChip(
  label: Text('Action Chip'),
  onPressed: () {
    print('Action chip pressed');
  },
  avatar: Icon(Icons.settings),
)
```

### FilterChip:

```dart
class FilterChipExample extends StatefulWidget {
  @override
  State<FilterChipExample> createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  final List<String> _filters = ['All', 'Active', 'Completed'];
  String _selectedFilter = 'All';
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _filters.map((filter) {
        return FilterChip(
          label: Text(filter),
          selected: _selectedFilter == filter,
          onSelected: (selected) {
            setState(() {
              _selectedFilter = filter;
            });
          },
          selectedColor: Colors.blue.shade100,
          checkmarkColor: Colors.blue,
        );
      }).toList(),
    );
  }
}
```

---

## Tooltip Widget

```dart
Tooltip(
  message: 'This is a tooltip',
  child: IconButton(
    icon: Icon(Icons.info),
    onPressed: () {},
  ),
  height: 40,
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.black87,
    borderRadius: BorderRadius.circular(4),
  ),
  textStyle: TextStyle(color: Colors.white),
  showDuration: Duration(seconds: 2),
  waitDuration: Duration(milliseconds: 500),
)
```

---

## Divider Widget

```dart
Divider(
  height: 20,
  thickness: 1,
  indent: 16,
  endIndent: 16,
  color: Colors.grey,
)

// Vertical divider
VerticalDivider(
  width: 20,
  thickness: 1,
  indent: 16,
  endIndent: 16,
  color: Colors.grey,
)
```

---

## Spacer Widget

```dart
Column(
  children: [
    Text('Top'),
    Spacer(), // Takes up remaining space
    Text('Bottom'),
  ],
)

Row(
  children: [
    Text('Left'),
    Spacer(flex: 2), // Takes 2x space
    Text('Middle'),
    Spacer(), // Takes 1x space
    Text('Right'),
  ],
)
```

---

## SizedBox Widget

```dart
// Fixed size container
SizedBox(
  width: 100,
  height: 100,
  child: Container(color: Colors.blue),
)

// Spacing
Column(
  children: [
    Text('First'),
    SizedBox(height: 16), // Vertical spacing
    Text('Second'),
  ],
)

Row(
  children: [
    Text('First'),
    SizedBox(width: 16), // Horizontal spacing
    Text('Second'),
  ],
)
```

---

## Summary

- **Text**: Display styled text with RichText for multiple styles
- **Image**: Display images from network, assets, files, or memory
- **Icon**: Display Material Design icons with customization
- **Buttons**: ElevatedButton, TextButton, OutlinedButton, IconButton, FloatingActionButton
- **Inputs**: TextField, TextFormField with validation
- **Selection**: Checkbox, Radio, Switch, Dropdown
- **Progress**: CircularProgressIndicator, LinearProgressIndicator
- **Card**: Material Design card with elevation and shape
- **Chips**: ActionChip, FilterChip for selections
- **Tooltip**: Show helpful information on hover/tap
- **Divider**: Visual separation between sections
- **Spacer**: Flexible spacing in layouts
- **SizedBox**: Fixed size containers and spacing

These basic UI widgets form the foundation for building rich Flutter interfaces.

```dart
RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: "Hello ",
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      TextSpan(
        text: "Flutter",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: "!",
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    ],
  ),
)
```

---

## Image Widget

The **Image** widget displays images from various sources.

### From Network:

```dart
Image.network(
  'https://example.com/image.png',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Center(child: Icon(Icons.broken_image));
  },
)
```

### From Asset:

```dart
Image.asset(
  'assets/images/my_image.png',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### From File:

```dart
import 'dart:io';

Image.file(
  File('/path/to/image.png'),
  width: 200,
  height: 200,
)
```

### From Memory:

```dart
import 'dart:typed_data';

Image.memory(
  Uint8List.fromList([...]), // Image bytes
  width: 200,
  height: 200,
)
```

### Image Properties:

```dart
Image.network(
  'https://example.com/image.png',
  
  // Size
  width: 200,
  height: 150,
  
  // Fit: how to fit the image in the box
  fit: BoxFit.cover,     // Fill box, maintain aspect ratio
  //    BoxFit.contain    // Fit in box, maintain aspect ratio
  //    BoxFit.fill       // Fill box (may distort)
  //    BoxFit.fitWidth   // Fill width
  //    BoxFit.fitHeight  // Fill height
  //    BoxFit.scaleDown  // Smaller than box if needed
  
  // Alignment
  alignment: Alignment.center,
  
  // Repeat
  repeat: ImageRepeat.noRepeat, // repeat, repeatX, repeatY, noRepeat
  
  // Color blend
  color: Colors.blue,
  colorBlendMode: BlendMode.multiply,
  
  // Opacity
  opacity: 0.8,
)
```

### BoxFit Comparison:

```
Original Image: 400x300

BoxFit.cover    → Box becomes 200x200 (crops image to fill)
BoxFit.contain  → Image sized to 200x150 (fits inside box)
BoxFit.fill     → Image sized to 200x200 (may distort)
BoxFit.fitWidth → Image sized to 200x150 (fits width)
BoxFit.fitHeight→ Image sized to 267x200 (fits height)
```

---

## Icon Widget

The **Icon** widget displays Material Design icons.

### Basic Usage:

```dart
Icon(Icons.home)
```

### With Styling:

```dart
Icon(
  Icons.home,
  size: 32,
  color: Colors.blue,
  semanticLabel: "Home",
)
```

### Common Icons:

```dart
// Navigation
Icons.home
Icons.menu
Icons.arrow_back
Icons.arrow_forward
Icons.close

// Action
Icons.add
Icons.edit
Icons.delete
Icons.search
Icons.settings

// Status
Icons.check_circle
Icons.error
Icons.warning
Icons.info

// Social
Icons.favorite
Icons.share
Icons.thumb_up

// Communication
Icons.call
Icons.email
Icons.message

// Media
Icons.play_arrow
Icons.pause
Icons.stop
Icons.volume_up

// File
Icons.folder
Icons.file_copy
Icons.download
Icons.upload
```

### Icon Button:

```dart
IconButton(
  icon: Icon(Icons.home),
  onPressed: () {},
  tooltip: "Home",
  iconSize: 32,
  color: Colors.blue,
  splashRadius: 28,
)
```

---

## Button Widgets

### ElevatedButton

A filled button that raises above the surface when clicked.

```dart
ElevatedButton(
  onPressed: () {
    print("Button pressed");
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  child: Text("Click Me"),
)
```

### Disabled State:

```dart
ElevatedButton(
  onPressed: null, // null makes button disabled
  child: Text("Disabled"),
)
```

### With Icon:

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.save),
  label: Text("Save"),
)
```

### TextButton

A flat button with text only.

```dart
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    textStyle: TextStyle(fontSize: 16),
  ),
  child: Text("Click Me"),
)
```

### OutlinedButton

A button with a border outline.

```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.blue,
    side: BorderSide(color: Colors.blue, width: 2),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
  child: Text("Click Me"),
)
```

### IconButton

A button containing only an icon.

```dart
IconButton(
  onPressed: () {},
  icon: Icon(Icons.favorite),
  iconSize: 32,
  color: Colors.red,
)
```

### FloatingActionButton

A circular button typically used for primary actions.

```dart
FloatingActionButton(
  onPressed: () {},
  tooltip: "Add",
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  elevation: 8,
  child: Icon(Icons.add),
)
```

### Custom Button Styling:

```dart
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: () {},
    splashColor: Colors.blue.withOpacity(0.3),
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("Custom Button"),
    ),
  ),
)
```

### Button Styling Best Practices:

```dart
ElevatedButton(
  onPressed: isValid ? () {} : null,
  style: ElevatedButton.styleFrom(
    // Use colors from theme
    backgroundColor: Theme.of(context).primaryColor,
    
    // Responsive padding
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.1,
      vertical: 15,
    ),
    
    // Consistent border radius
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    
    // Shadow for depth
    elevation: 8,
  ),
  child: Text("Submit"),
)
```

---

## Button Comparison Table

| Button | Use Case | Style |
|--------|----------|-------|
| ElevatedButton | Primary action | Filled, raised |
| TextButton | Secondary action | Text only, flat |
| OutlinedButton | Alternative action | Border outline |
| IconButton | Icon action | Icon only |
| FloatingActionButton | Primary floating action | Circular, floating |

---

## Summary

- **Text**: Display and style text with TextStyle
- **Image**: Load from network, asset, file, or memory
- **Icon**: Use Material Design icons
- **ElevatedButton**: Filled raised button for primary actions
- **TextButton**: Flat button for secondary actions
- **IconButton**: Button with just an icon
- **FloatingActionButton**: Circular floating action button
- Use proper styling and accessibility features
