# Flutter Custom Widgets & Reusability

Building reusable, maintainable components is crucial for scalable apps.

---

## Creating Custom Widgets

### Custom StatelessWidget:

```dart
class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage
CustomCard(
  title: "Profile",
  subtitle: "View your profile",
  icon: Icons.person,
  onTap: () {},
)
```

### Custom StatefulWidget:

```dart
class ToggleButton extends StatefulWidget {
  final String label;
  final ValueChanged<bool> onChanged;

  const ToggleButton({
    Key? key,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isActive = !_isActive;
        });
        widget.onChanged(_isActive);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isActive ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
```

### Advanced Custom Widget with Multiple States:

```dart
enum ButtonState { idle, loading, success, error }

class AsyncButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final ButtonState state;
  final VoidCallback? onStateChanged;
  
  const AsyncButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.state = ButtonState.idle,
    this.onStateChanged,
  });
  
  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  ButtonState _currentState = ButtonState.idle;
  
  @override
  void initState() {
    super.initState();
    _currentState = widget.state;
  }
  
  @override
  void didUpdateWidget(AsyncButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _currentState = widget.state;
    }
  }
  
  Future<void> _handlePress() async {
    if (_currentState == ButtonState.loading) return;
    
    setState(() => _currentState = ButtonState.loading);
    widget.onStateChanged?.call();
    
    try {
      await widget.onPressed();
      setState(() => _currentState = ButtonState.success);
    } catch (e) {
      setState(() => _currentState = ButtonState.error);
    }
    
    // Reset after delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _currentState = ButtonState.idle);
        widget.onStateChanged?.call();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _currentState == ButtonState.loading ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildChild(),
    );
  }
  
  Color _getBackgroundColor() {
    switch (_currentState) {
      case ButtonState.idle:
        return Colors.blue;
      case ButtonState.loading:
        return Colors.blue.shade300;
      case ButtonState.success:
        return Colors.green;
      case ButtonState.error:
        return Colors.red;
    }
  }
  
  Widget _buildChild() {
    switch (_currentState) {
      case ButtonState.idle:
        return Text(widget.text);
      case ButtonState.loading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Text('Loading...'),
          ],
        );
      case ButtonState.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 16),
            SizedBox(width: 8),
            Text('Success!'),
          ],
        );
      case ButtonState.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, size: 16),
            SizedBox(width: 8),
            Text('Error'),
          ],
        );
    }
  }
}
```

---

## Component Architecture

### Base Component Class:

```dart
abstract class BaseComponent extends StatelessWidget {
  const BaseComponent({super.key});
  
  @protected
  Widget buildComponent(BuildContext context);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildComponent(context),
    );
  }
}

class CardComponent extends BaseComponent {
  final String title;
  final Widget content;
  
  const CardComponent({
    super.key,
    required this.title,
    required this.content,
  });
  
  @override
  Widget buildComponent(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
```

### Component with Builder Pattern:

```dart
class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class DialogBuilder {
  String? _title;
  Widget? _content;
  final List<Widget> _actions = [];
  
  DialogBuilder title(String title) {
    _title = title;
    return this;
  }
  
  DialogBuilder content(Widget content) {
    _content = content;
    return this;
  }
  
  DialogBuilder action(Widget action) {
    _actions.add(action);
    return this;
  }
  
  DialogBuilder actions(List<Widget> actions) {
    _actions.addAll(actions);
    return this;
  }
  
  CustomDialog build() {
    assert(_title != null, 'Title is required');
    assert(_content != null, 'Content is required');
    
    return CustomDialog(
      title: _title!,
      content: _content!,
      actions: _actions,
    );
  }
  
  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) => build(),
    );
  }
}

// Usage
DialogBuilder()
  .title('Confirm Action')
  .content(Text('Are you sure you want to proceed?'))
  .action(TextButton(
    onPressed: () => Navigator.of(context).pop(false),
    child: Text('Cancel'),
  ))
  .action(TextButton(
    onPressed: () => Navigator.of(context).pop(true),
    child: Text('Confirm'),
  ))
  .show(context);
```

---

## Composition

### Composable Components:

```dart
class ListItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const ListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        leading,
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (subtitle != null) ...[
                SizedBox(height: 4),
                subtitle!,
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: content,
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: content,
    );
  }
}

// Usage with composition
ListItem(
  leading: CircleAvatar(
    backgroundImage: NetworkImage(user.avatarUrl),
  ),
  title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
  subtitle: Text(user.email, style: TextStyle(color: Colors.grey)),
  trailing: Icon(Icons.arrow_forward),
  onTap: () => navigateToUserProfile(user),
)
```

### Slot-Based Components:

```dart
class CardWithSlots extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  
  const CardWithSlots({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.padding = const EdgeInsets.all(16),
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) ...[
              header!,
              Divider(),
            ],
            if (body != null) body!,
            if (footer != null) ...[
              Divider(),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
CardWithSlots(
  header: Text('User Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  body: Column(
    children: [
      Text('Name: John Doe'),
      Text('Email: john@example.com'),
    ],
  ),
  footer: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(onPressed: () {}, child: Text('Cancel')),
      ElevatedButton(onPressed: () {}, child: Text('Save')),
    ],
  ),
)
```

---

## Configuration

### Configuration Classes:

```dart
class ButtonConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  
  const ButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    required this.textStyle,
  });
  
  ButtonConfig copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return ButtonConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

class ConfigurableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonConfig config;
  
  const ConfigurableButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.config,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.backgroundColor,
        foregroundColor: config.foregroundColor,
        padding: config.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
      ),
      child: Text(text, style: config.textStyle),
    );
  }
}

// Predefined configurations
class ButtonConfigs {
  static const primary = ButtonConfig(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontWeight: FontWeight.w600),
  );
  
  static const secondary = ButtonConfig(
    backgroundColor: Colors.grey,
    foregroundColor: Colors.black,
    textStyle: TextStyle(fontWeight: FontWeight.w500),
  );
  
  static const danger = ButtonConfig(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontWeight: FontWeight.w600),
  );
}
```

### Theme-Based Configuration:

```dart
class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  
  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getConfig(theme, variant);
    
    return ConfigurableButton(
      text: text,
      onPressed: onPressed,
      config: config,
    );
  }
  
  ButtonConfig _getConfig(ThemeData theme, ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return ButtonConfig(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          textStyle: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        );
      
      case ButtonVariant.secondary:
        return ButtonConfig(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          textStyle: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
      
      case ButtonVariant.outline:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          textStyle: theme.textTheme.labelLarge!.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }
}

enum ButtonVariant { primary, secondary, outline }
```

---

## Mixins

### Reusable Behavior Mixins:

```dart
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }
  
  Widget buildLoadingOverlay(Widget child) {
    return Stack(
      children: [
        child,
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

mixin ErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  String? _error;
  
  String? get error => _error;
  
  void setError(String? error) {
    setState(() => _error = error);
  }
  
  void clearError() {
    setError(null);
  }
  
  Widget buildErrorWidget() {
    if (_error == null) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: clearError,
          ),
        ],
      ),
    );
  }
}

mixin FormValidationMixin<T extends StatefulWidget> on State<T> {
  final Map<String, String?> _errors = {};
  
  String? getFieldError(String field) => _errors[field];
  
  void setFieldError(String field, String? error) {
    setState(() {
      if (error == null) {
        _errors.remove(field);
      } else {
        _errors[field] = error;
      }
    });
  }
  
  bool validateField(String field, String? value, String? Function(String?) validator) {
    final error = validator(value);
    setFieldError(field, error);
    return error == null;
  }
  
  bool validateAll(Map<String, String? Function(String?)> validators) {
    bool isValid = true;
    
    validators.forEach((field, validator) {
      final value = getFieldValue(field);
      if (!validateField(field, value, validator)) {
        isValid = false;
      }
    });
    
    return isValid;
  }
  
  String? getFieldValue(String field) {
    // Implement based on your form structure
    return null;
  }
  
  void clearAllErrors() {
    setState(() => _errors.clear());
  }
}
```

### Using Mixins in Widgets:

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with LoadingMixin, ErrorHandlingMixin, FormValidationMixin {
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  String? getFieldValue(String field) {
    switch (field) {
      case 'email':
        return _emailController.text;
      case 'password':
        return _passwordController.text;
      default:
        return null;
    }
  }
  
  Future<void> _login() async {
    clearError();
    
    final validators = {
      'email': (String? value) {
        if (value == null || value.isEmpty) return 'Email is required';
        if (!value.contains('@')) return 'Invalid email';
        return null;
      },
      'password': (String? value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) return 'Password too short';
        return null;
      },
    };
    
    if (!validateAll(validators)) return;
    
    setLoading(true);
    
    try {
      await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
      // Navigate to home
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return buildLoadingOverlay(
      Column(
        children: [
          buildErrorWidget(),
          
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: getFieldError('email'),
            ),
          ),
          
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: getFieldError('password'),
            ),
            obscureText: true,
          ),
          
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

---

## Generics

### Generic Components:

```dart
class GenericListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Widget Function(T item)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  
  const GenericListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text('No items'));
    }
    
    final children = <Widget>[];
    
    for (int i = 0; i < items.length; i++) {
      children.add(itemBuilder(items[i]));
      
      if (separatorBuilder != null && i < items.length - 1) {
        children.add(separatorBuilder!(items[i]));
      }
    }
    
    return ListView(
      padding: padding,
      children: children,
    );
  }
}

// Usage
GenericListView<User>(
  items: users,
  itemBuilder: (user) => ListTile(
    title: Text(user.name),
    subtitle: Text(user.email),
  ),
  separatorBuilder: (user) => Divider(),
)
```

### Generic Data Provider:

```dart
class DataProvider<T> extends InheritedWidget {
  final T data;
  final void Function(T newData) onDataChanged;
  
  const DataProvider({
    super.key,
    required super.child,
    required this.data,
    required this.onDataChanged,
  });
  
  static DataProvider<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider<T>>();
  }
  
  @override
  bool updateShouldNotify(DataProvider<T> oldWidget) {
    return !identical(data, oldWidget.data);
  }
}

class GenericDataConsumer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T data) builder;
  
  const GenericDataConsumer({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    final provider = DataProvider.of<T>(context);
    if (provider == null) {
      throw FlutterError('No DataProvider found in context');
    }
    return builder(context, provider.data);
  }
}

// Usage
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GenericDataConsumer<User>(
      builder: (context, user) {
        return Column(
          children: [
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ],
        );
      },
    );
  }
}
```

### Generic Form Fields:

```dart
abstract class FormFieldWidget<T> extends StatefulWidget {
  final String label;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  
  const FormFieldWidget({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.validator,
  });
}

class GenericTextField extends FormFieldWidget<String> {
  const GenericTextField({
    super.key,
    required super.label,
    super.initialValue,
    super.onChanged,
    super.validator,
  });
  
  @override
  State<GenericTextField> createState() => _GenericTextFieldState();
}

class _GenericTextFieldState extends State<GenericTextField> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }
  
  @override
  void didUpdateWidget(GenericTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
```

---

## Advanced Patterns

### Widget Factories:

```dart
abstract class WidgetFactory {
  Widget createButton(String text, VoidCallback onPressed);
  Widget createCard(Widget content);
  Widget createTextField(String label);
}

class MaterialWidgetFactory implements WidgetFactory {
  @override
  Widget createButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
  
  @override
  Widget createCard(Widget content) {
    return Card(child: Padding(padding: EdgeInsets.all(16), child: content));
  }
  
  @override
  Widget createTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
    );
  }
}

class CupertinoWidgetFactory implements WidgetFactory {
  @override
  Widget createButton(String text, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
  
  @override
  Widget createCard(Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: EdgeInsets.all(16), child: content),
    );
  }
  
  @override
  Widget createTextField(String label) {
    return CupertinoTextField(
      placeholder: label,
    );
  }
}
```

### Component Registry:

```dart
class ComponentRegistry {
  static final Map<String, Widget Function(Map<String, dynamic>)> _components = {};
  
  static void register(String name, Widget Function(Map<String, dynamic>) builder) {
    _components[name] = builder;
  }
  
  static Widget build(String name, Map<String, dynamic> props) {
    final builder = _components[name];
    if (builder == null) {
      throw Exception('Component "$name" not registered');
    }
    return builder(props);
  }
}

// Register components
void initComponents() {
  ComponentRegistry.register('custom_button', (props) {
    return CustomButton(
      text: props['text'],
      onPressed: props['onPressed'],
    );
  });
  
  ComponentRegistry.register('user_card', (props) {
    return UserCard(
      user: props['user'],
      onTap: props['onTap'],
    );
  });
}

// Usage
Widget button = ComponentRegistry.build('custom_button', {
  'text': 'Click me',
  'onPressed': () => print('Clicked'),
});
```

### Higher-Order Components:

```dart
typedef WidgetBuilder = Widget Function(BuildContext context);

class HOC {
  static Widget withLoading(WidgetBuilder builder) {
    return LoadingWrapper(builder: builder);
  }
  
  static Widget withErrorHandling(WidgetBuilder builder) {
    return ErrorBoundary(builder: builder);
  }
  
  static Widget withTheme(WidgetBuilder builder) {
    return ThemeWrapper(builder: builder);
  }
  
  static Widget compose(List<Widget Function(Widget)> enhancers, Widget child) {
    return enhancers.reversed.fold(
      child,
      (widget, enhancer) => enhancer(widget),
    );
  }
}

class LoadingWrapper extends StatefulWidget {
  final WidgetBuilder builder;
  
  const LoadingWrapper({super.key, required this.builder});
  
  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> with LoadingMixin {
  @override
  Widget build(BuildContext context) {
    return buildLoadingOverlay(widget.builder(context));
  }
}

// Usage
HOC.compose([
  HOC.withLoading,
  HOC.withErrorHandling,
  HOC.withTheme,
], MyWidget())
```

---

## Summary

- **Custom Widgets**: StatelessWidget and StatefulWidget with advanced features
- **Component Architecture**: Base classes, builder patterns, and composition
- **Configuration**: Flexible configuration classes and theme-based styling
- **Mixins**: Reusable behavior for loading, error handling, and validation
- **Generics**: Type-safe generic components and data providers
- **Advanced Patterns**: Widget factories, component registries, and HOCs

Reusable components reduce code duplication and improve maintainability.
        widget.onChanged(_isActive);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isActive ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
```

### Advanced Custom Widget with Multiple States:

```dart
enum ButtonState { idle, loading, success, error }

class AsyncButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final ButtonState state;
  final VoidCallback? onStateChanged;
  
  const AsyncButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.state = ButtonState.idle,
    this.onStateChanged,
  });
  
  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  ButtonState _currentState = ButtonState.idle;
  
  @override
  void initState() {
    super.initState();
    _currentState = widget.state;
  }
  
  @override
  void didUpdateWidget(AsyncButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _currentState = widget.state;
    }
  }
  
  Future<void> _handlePress() async {
    if (_currentState == ButtonState.loading) return;
    
    setState(() => _currentState = ButtonState.loading);
    widget.onStateChanged?.call();
    
    try {
      await widget.onPressed();
      setState(() => _currentState = ButtonState.success);
    } catch (e) {
      setState(() => _currentState = ButtonState.error);
    }
    
    // Reset after delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _currentState = ButtonState.idle);
        widget.onStateChanged?.call();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _currentState == ButtonState.loading ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildChild(),
    );
  }
  
  Color _getBackgroundColor() {
    switch (_currentState) {
      case ButtonState.idle:
        return Colors.blue;
      case ButtonState.loading:
        return Colors.blue.shade300;
      case ButtonState.success:
        return Colors.green;
      case ButtonState.error:
        return Colors.red;
    }
  }
  
  Widget _buildChild() {
    switch (_currentState) {
      case ButtonState.idle:
        return Text(widget.text);
      case ButtonState.loading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Text('Loading...'),
          ],
        );
      case ButtonState.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 16),
            SizedBox(width: 8),
            Text('Success!'),
          ],
        );
      case ButtonState.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, size: 16),
            SizedBox(width: 8),
            Text('Error'),
          ],
        );
    }
  }
}
```

---

## Component Architecture

### Base Component Class:

```dart
abstract class BaseComponent extends StatelessWidget {
  const BaseComponent({super.key});
  
  @protected
  Widget buildComponent(BuildContext context);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildComponent(context),
    );
  }
}

class CardComponent extends BaseComponent {
  final String title;
  final Widget content;
  
  const CardComponent({
    super.key,
    required this.title,
    required this.content,
  });
  
  @override
  Widget buildComponent(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
```

### Component with Builder Pattern:

```dart
class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class DialogBuilder {
  String? _title;
  Widget? _content;
  final List<Widget> _actions = [];
  
  DialogBuilder title(String title) {
    _title = title;
    return this;
  }
  
  DialogBuilder content(Widget content) {
    _content = content;
    return this;
  }
  
  DialogBuilder action(Widget action) {
    _actions.add(action);
    return this;
  }
  
  DialogBuilder actions(List<Widget> actions) {
    _actions.addAll(actions);
    return this;
  }
  
  CustomDialog build() {
    assert(_title != null, 'Title is required');
    assert(_content != null, 'Content is required');
    
    return CustomDialog(
      title: _title!,
      content: _content!,
      actions: _actions,
    );
  }
  
  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) => build(),
    );
  }
}

// Usage
DialogBuilder()
  .title('Confirm Action')
  .content(Text('Are you sure you want to proceed?'))
  .action(TextButton(
    onPressed: () => Navigator.of(context).pop(false),
    child: Text('Cancel'),
  ))
  .action(TextButton(
    onPressed: () => Navigator.of(context).pop(true),
    child: Text('Confirm'),
  ))
  .show(context);
```

---

## Composition

### Composable Components:

```dart
class ListItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const ListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        leading,
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (subtitle != null) ...[
                SizedBox(height: 4),
                subtitle!,
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: content,
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: content,
    );
  }
}

// Usage with composition
ListItem(
  leading: CircleAvatar(
    backgroundImage: NetworkImage(user.avatarUrl),
  ),
  title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
  subtitle: Text(user.email, style: TextStyle(color: Colors.grey)),
  trailing: Icon(Icons.arrow_forward),
  onTap: () => navigateToUserProfile(user),
)
```

### Slot-Based Components:

```dart
class CardWithSlots extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  
  const CardWithSlots({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.padding = const EdgeInsets.all(16),
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) ...[
              header!,
              Divider(),
            ],
            if (body != null) body!,
            if (footer != null) ...[
              Divider(),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
CardWithSlots(
  header: Text('User Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  body: Column(
    children: [
      Text('Name: John Doe'),
      Text('Email: john@example.com'),
    ],
  ),
  footer: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(onPressed: () {}, child: Text('Cancel')),
      ElevatedButton(onPressed: () {}, child: Text('Save')),
    ],
  ),
)
```

---

## Configuration

### Configuration Classes:

```dart
class ButtonConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  
  const ButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    required this.textStyle,
  });
  
  ButtonConfig copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return ButtonConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

class ConfigurableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonConfig config;
  
  const ConfigurableButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.config,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.backgroundColor,
        foregroundColor: config.foregroundColor,
        padding: config.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
      ),
      child: Text(text, style: config.textStyle),
    );
  }
}

// Predefined configurations
class ButtonConfigs {
  static const primary = ButtonConfig(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontWeight: FontWeight.w600),
  );
  
  static const secondary = ButtonConfig(
    backgroundColor: Colors.grey,
    foregroundColor: Colors.black,
    textStyle: TextStyle(fontWeight: FontWeight.w500),
  );
  
  static const danger = ButtonConfig(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontWeight: FontWeight.w600),
  );
}
```

### Theme-Based Configuration:

```dart
class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  
  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getConfig(theme, variant);
    
    return ConfigurableButton(
      text: text,
      onPressed: onPressed,
      config: config,
    );
  }
  
  ButtonConfig _getConfig(ThemeData theme, ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return ButtonConfig(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          textStyle: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        );
      
      case ButtonVariant.secondary:
        return ButtonConfig(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          textStyle: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
      
      case ButtonVariant.outline:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          textStyle: theme.textTheme.labelLarge!.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }
}

enum ButtonVariant { primary, secondary, outline }
```

---

## Mixins

### Reusable Behavior Mixins:

```dart
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }
  
  Widget buildLoadingOverlay(Widget child) {
    return Stack(
      children: [
        child,
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

mixin ErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  String? _error;
  
  String? get error => _error;
  
  void setError(String? error) {
    setState(() => _error = error);
  }
  
  void clearError() {
    setError(null);
  }
  
  Widget buildErrorWidget() {
    if (_error == null) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: clearError,
          ),
        ],
      ),
    );
  }
}

mixin FormValidationMixin<T extends StatefulWidget> on State<T> {
  final Map<String, String?> _errors = {};
  
  String? getFieldError(String field) => _errors[field];
  
  void setFieldError(String field, String? error) {
    setState(() {
      if (error == null) {
        _errors.remove(field);
      } else {
        _errors[field] = error;
      }
    });
  }
  
  bool validateField(String field, String? value, String? Function(String?) validator) {
    final error = validator(value);
    setFieldError(field, error);
    return error == null;
  }
  
  bool validateAll(Map<String, String? Function(String?)> validators) {
    bool isValid = true;
    
    validators.forEach((field, validator) {
      final value = getFieldValue(field);
      if (!validateField(field, value, validator)) {
        isValid = false;
      }
    });
    
    return isValid;
  }
  
  String? getFieldValue(String field) {
    // Implement based on your form structure
    return null;
  }
  
  void clearAllErrors() {
    setState(() => _errors.clear());
  }
}
```

### Using Mixins in Widgets:

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with LoadingMixin, ErrorHandlingMixin, FormValidationMixin {
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  String? getFieldValue(String field) {
    switch (field) {
      case 'email':
        return _emailController.text;
      case 'password':
        return _passwordController.text;
      default:
        return null;
    }
  }
  
  Future<void> _login() async {
    clearError();
    
    final validators = {
      'email': (String? value) {
        if (value == null || value.isEmpty) return 'Email is required';
        if (!value.contains('@')) return 'Invalid email';
        return null;
      },
      'password': (String? value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) return 'Password too short';
        return null;
      },
    };
    
    if (!validateAll(validators)) return;
    
    setLoading(true);
    
    try {
      await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
      // Navigate to home
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return buildLoadingOverlay(
      Column(
        children: [
          buildErrorWidget(),
          
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: getFieldError('email'),
            ),
          ),
          
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: getFieldError('password'),
            ),
            obscureText: true,
          ),
          
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

---

## Generics

### Generic Components:

```dart
class GenericListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Widget Function(T item)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  
  const GenericListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text('No items'));
    }
    
    final children = <Widget>[];
    
    for (int i = 0; i < items.length; i++) {
      children.add(itemBuilder(items[i]));
      
      if (separatorBuilder != null && i < items.length - 1) {
        children.add(separatorBuilder!(items[i]));
      }
    }
    
    return ListView(
      padding: padding,
      children: children,
    );
  }
}

// Usage
GenericListView<User>(
  items: users,
  itemBuilder: (user) => ListTile(
    title: Text(user.name),
    subtitle: Text(user.email),
  ),
  separatorBuilder: (user) => Divider(),
)
```

### Generic Data Provider:

```dart
class DataProvider<T> extends InheritedWidget {
  final T data;
  final void Function(T newData) onDataChanged;
  
  const DataProvider({
    super.key,
    required super.child,
    required this.data,
    required this.onDataChanged,
  });
  
  static DataProvider<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider<T>>();
  }
  
  @override
  bool updateShouldNotify(DataProvider<T> oldWidget) {
    return !identical(data, oldWidget.data);
  }
}

class GenericDataConsumer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T data) builder;
  
  const GenericDataConsumer({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    final provider = DataProvider.of<T>(context);
    if (provider == null) {
      throw FlutterError('No DataProvider found in context');
    }
    return builder(context, provider.data);
  }
}

// Usage
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GenericDataConsumer<User>(
      builder: (context, user) {
        return Column(
          children: [
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ],
        );
      },
    );
  }
}
```

### Generic Form Fields:

```dart
abstract class FormFieldWidget<T> extends StatefulWidget {
  final String label;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  
  const FormFieldWidget({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.validator,
  });
}

class GenericTextField extends FormFieldWidget<String> {
  const GenericTextField({
    super.key,
    required super.label,
    super.initialValue,
    super.onChanged,
    super.validator,
  });
  
  @override
  State<GenericTextField> createState() => _GenericTextFieldState();
}

class _GenericTextFieldState extends State<GenericTextField> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }
  
  @override
  void didUpdateWidget(GenericTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
```

---

## Advanced Patterns

### Widget Factories:

```dart
abstract class WidgetFactory {
  Widget createButton(String text, VoidCallback onPressed);
  Widget createCard(Widget content);
  Widget createTextField(String label);
}

class MaterialWidgetFactory implements WidgetFactory {
  @override
  Widget createButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
  
  @override
  Widget createCard(Widget content) {
    return Card(child: Padding(padding: EdgeInsets.all(16), child: content));
  }
  
  @override
  Widget createTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
    );
  }
}

class CupertinoWidgetFactory implements WidgetFactory {
  @override
  Widget createButton(String text, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
  
  @override
  Widget createCard(Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: EdgeInsets.all(16), child: content),
    );
  }
  
  @override
  Widget createTextField(String label) {
    return CupertinoTextField(
      placeholder: label,
    );
  }
}
```

### Component Registry:

```dart
class ComponentRegistry {
  static final Map<String, Widget Function(Map<String, dynamic>)> _components = {};
  
  static void register(String name, Widget Function(Map<String, dynamic>) builder) {
    _components[name] = builder;
  }
  
  static Widget build(String name, Map<String, dynamic> props) {
    final builder = _components[name];
    if (builder == null) {
      throw Exception('Component "$name" not registered');
    }
    return builder(props);
  }
}

// Register components
void initComponents() {
  ComponentRegistry.register('custom_button', (props) {
    return CustomButton(
      text: props['text'],
      onPressed: props['onPressed'],
    );
  });
  
  ComponentRegistry.register('user_card', (props) {
    return UserCard(
      user: props['user'],
      onTap: props['onTap'],
    );
  });
}

// Usage
Widget button = ComponentRegistry.build('custom_button', {
  'text': 'Click me',
  'onPressed': () => print('Clicked'),
});
```

### Higher-Order Components:

```dart
typedef WidgetBuilder = Widget Function(BuildContext context);

class HOC {
  static Widget withLoading(WidgetBuilder builder) {
    return LoadingWrapper(builder: builder);
  }
  
  static Widget withErrorHandling(WidgetBuilder builder) {
    return ErrorBoundary(builder: builder);
  }
  
  static Widget withTheme(WidgetBuilder builder) {
    return ThemeWrapper(builder: builder);
  }
  
  static Widget compose(List<Widget Function(Widget)> enhancers, Widget child) {
    return enhancers.reversed.fold(
      child,
      (widget, enhancer) => enhancer(widget),
    );
  }
}

class LoadingWrapper extends StatefulWidget {
  final WidgetBuilder builder;
  
  const LoadingWrapper({super.key, required this.builder});
  
  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> with LoadingMixin {
  @override
  Widget build(BuildContext context) {
    return buildLoadingOverlay(widget.builder(context));
  }
}

// Usage
HOC.compose([
  HOC.withLoading,
  HOC.withErrorHandling,
  HOC.withTheme,
], MyWidget())
```

---

## Summary

- **Custom Widgets**: StatelessWidget and StatefulWidget with advanced features
- **Component Architecture**: Base classes, builder patterns, and composition
- **Configuration**: Flexible configuration classes and theme-based styling
- **Mixins**: Reusable behavior for loading, error handling, and validation
- **Generics**: Type-safe generic components and data providers
- **Advanced Patterns**: Widget factories, component registries, and HOCs

Reusable components reduce code duplication and improve maintainability.
        widget.onChanged(_isActive);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isActive ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Usage
ToggleButton(
  label: "Active",
  onChanged: (isActive) {
    print("Toggled: $isActive");
  },
)
```

---

## Component Architecture

### Clean Separation:

```
lib/
├── screens/
│   └── home_screen.dart
├── widgets/
│   ├── buttons/
│   │   ├── custom_button.dart
│   │   └── icon_button.dart
│   ├── cards/
│   │   ├── product_card.dart
│   │   └── user_card.dart
│   └── dialogs/
│       └── confirm_dialog.dart
├── models/
│   └── user.dart
├── services/
│   └── api_service.dart
└── utils/
    └── constants.dart
```

### Custom Button Widget:

```dart
// widgets/buttons/custom_button.dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isLoading;
  final bool isFullWidth;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: _buildButton(context),
          )
        : _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}

// Usage
CustomButton(
  label: "Submit",
  onPressed: _handleSubmit,
  isFullWidth: true,
  isLoading: _isLoading,
)
```

### Custom Dialog:

```dart
// widgets/dialogs/confirm_dialog.dart
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmLabel = "Confirm",
    this.cancelLabel = "Cancel",
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

// Usage
showDialog(
  context: context,
  builder: (context) => ConfirmDialog(
    title: "Delete?",
    message: "Are you sure?",
    onConfirm: () {
      // Handle delete
    },
  ),
)
```

---

## Composition Over Inheritance

### Bad (Inheritance):

```dart
class PrimaryButton extends ElevatedButton {
  PrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) : super(
    onPressed: onPressed,
    child: Text(label),
  );
}
```

### Good (Composition):

```dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
```

---

## Widget Configuration

### Using Enums for Options:

```dart
enum ButtonSize { small, medium, large }

class ResponsiveButton extends StatelessWidget {
  final String label;
  final ButtonSize size;
  final VoidCallback onPressed;

  const ResponsiveButton({
    Key? key,
    required this.label,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  double _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.medium:
        return 12;
      case ButtonSize.large:
        return 16;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding:
            EdgeInsets.symmetric(horizontal: _getPadding() * 2,
                vertical: _getPadding()),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: _getFontSize()),
      ),
    );
  }
}

// Usage
ResponsiveButton(
  label: "Click",
  size: ButtonSize.large,
  onPressed: () {},
)
```

---

## Mixin Usage

```dart
mixin Loadable {
  bool get isLoading;
  set isLoading(bool value);
}

mixin Validatable {
  bool validate();
  List<String> getErrors();
}

class FormWidget extends StatefulWidget with Loadable {
  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> with Validatable {
  bool isLoading = false;

  @override
  bool validate() {
    // Validation logic
    return true;
  }

  @override
  List<String> getErrors() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## Generic Widgets

### Generic List Item:

```dart
class ListItemWidget<T> extends StatelessWidget {
  final T item;
  final Widget Function(BuildContext, T) builder;
  final VoidCallback? onTap;

  const ListItemWidget({
    Key? key,
    required this.item,
    required this.builder,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: builder(context, item),
        ),
      ),
    );
  }
}

// Usage
ListItemWidget<User>(
  item: user,
  builder: (context, user) => Text(user.name),
  onTap: () {},
)
```

---

## Slot-Based Widgets

### Widget with Slots:

```dart
class Container extends StatelessWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final Color? backgroundColor;

  const Container({
    Key? key,
    this.header,
    required this.body,
    this.footer,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          if (header != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: header!,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: body,
            ),
          ),
          if (footer != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: footer!,
            ),
        ],
      ),
    );
  }
}

// Usage
Container(
  header: Text("Header"),
  body: ListView(...),
  footer: ElevatedButton(...),
)
```

---

## Testing Custom Widgets

```dart
void main() {
  group('CustomButton', () {
    testWidgets('taps callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: "Tap me",
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });
  });
}
```

---

## Best Practices

1. **Composition over Inheritance**: Build with composition
2. **Single Responsibility**: Each widget does one thing
3. **Props Validation**: Use required parameters
4. **Const Constructor**: Make widgets immutable
5. **DRY Principle**: Extract common patterns
6. **Clear Naming**: Use descriptive names
7. **Documentation**: Comment complex widgets
8. **Testing**: Test custom widgets thoroughly

---

## Summary

- Create reusable StatelessWidget and StatefulWidget
- Use composition over inheritance
- Organize widgets in logical folders
- Use generics for flexible widgets
- Apply mixins for shared behavior
- Create slot-based widgets for flexibility
- Test custom widgets
- Follow SOLID principles
