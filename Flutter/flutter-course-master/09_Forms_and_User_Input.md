# Flutter Forms & User Input

Handling user input is a fundamental part of most applications.

---

## TextField

A text input widget for capturing user input.

### Basic Usage:

```dart
TextField(
  decoration: InputDecoration(
    hintText: "Enter your name",
  ),
)
```

### Complete TextField:

```dart
TextField(
  // Text styling
  style: TextStyle(fontSize: 16, color: Colors.black),
  
  // Keyboard type
  keyboardType: TextInputType.email,
  // TextInputType.number, .phone, .url, etc.
  
  // Hint
  decoration: InputDecoration(
    hintText: "Enter text",
    hintStyle: TextStyle(color: Colors.grey),
    
    // Label
    labelText: "Username",
    labelStyle: TextStyle(color: Colors.blue),
    
    // Icons
    prefixIcon: Icon(Icons.person),
    suffixIcon: Icon(Icons.clear),
    
    // Border
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    
    // Colors
    filled: true,
    fillColor: Colors.grey[100],
    
    // Padding
    contentPadding: EdgeInsets.all(16),
  ),
  
  // Obscure text (for passwords)
  obscureText: true,
  
  // Max lines
  maxLines: 1,
  minLines: 1,
  
  // Max length
  maxLength: 20,
  counterText: "characters",
  
  // Input formatting
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  
  // Callbacks
  onChanged: (value) {},
  onSubmitted: (value) {},
  onTap: () {},
)
```

### TextField Variations:

```dart
// Email
TextField(
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: "Email",
    prefixIcon: Icon(Icons.email),
  ),
)

// Password
TextField(
  obscureText: true,
  decoration: InputDecoration(
    labelText: "Password",
    prefixIcon: Icon(Icons.lock),
    suffixIcon: IconButton(
      icon: Icon(Icons.visibility),
      onPressed: () {
        // Toggle visibility
      },
    ),
  ),
)

// Number
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  decoration: InputDecoration(
    labelText: "Age",
    prefixIcon: Icon(Icons.calendar_today),
  ),
)

// Multiline
TextField(
  maxLines: 5,
  minLines: 3,
  decoration: InputDecoration(
    labelText: "Description",
    alignLabelWithHint: true,
  ),
)
```

### TextEditingController:

```dart
class TextFieldController extends StatefulWidget {
  @override
  _TextFieldControllerState createState() => _TextFieldControllerState();
}

class _TextFieldControllerState extends State<TextFieldController> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controller.text = "Initial value";
    _controller.addListener(_onTextChanged);
  }
  
  void _onTextChanged() {
    print("Text changed: ${_controller.text}");
  }
  
  void _clearText() {
    _controller.clear();
  }
  
  void _setText() {
    _controller.text = "New text";
    _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearText,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _setText,
          child: Text("Set Text"),
        ),
      ],
    );
  }
}
```

---

## Form and TextFormField

A container for grouping and validating multiple form fields.

### Basic Form:

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  
  String _email = '';
  String _password = '';
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, submit data
      print('Email: $_email, Password: $_password');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Advanced Form Validation:

```dart
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _agreeToTerms = false;
  
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }
  
  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please agree to terms and conditions')),
        );
        return;
      }
      
      _formKey.currentState!.save();
      // Submit registration
      print('Registration successful');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            validator: _validateName,
            onSaved: (value) => _name = value!,
          ),
          
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onSaved: (value) => _email = value!,
          ),
          
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: _validatePassword,
            onSaved: (value) => _password = value!,
            onChanged: (value) => _password = value,
          ),
          
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: _validateConfirmPassword,
            onSaved: (value) => _confirmPassword = value!,
          ),
          
          CheckboxListTile(
            title: Text('I agree to the terms and conditions'),
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() => _agreeToTerms = value ?? false);
            },
          ),
          
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

---

## Focus Management

Controlling which input field has focus.

### Basic Focus:

```dart
class FocusExample extends StatefulWidget {
  @override
  _FocusExampleState createState() => _FocusExampleState();
}

class _FocusExampleState extends State<FocusExample> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  
  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _focusNode1,
          decoration: InputDecoration(labelText: 'Field 1'),
          onSubmitted: (_) => _focusNode2.requestFocus(),
        ),
        TextField(
          focusNode: _focusNode2,
          decoration: InputDecoration(labelText: 'Field 2'),
        ),
        ElevatedButton(
          onPressed: () => _focusNode1.requestFocus(),
          child: Text('Focus First Field'),
        ),
      ],
    );
  }
}
```

### FocusScope:

```dart
class FocusScopeExample extends StatefulWidget {
  @override
  _FocusScopeExampleState createState() => _FocusScopeExampleState();
}

class _FocusScopeExampleState extends State<FocusScopeExample> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  
  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Field 1'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Field 2'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _focusScopeNode.nextFocus(),
                child: Text('Next'),
              ),
              ElevatedButton(
                onPressed: () => _focusScopeNode.previousFocus(),
                child: Text('Previous'),
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

## Selection Controls

Widgets for making selections.

### Checkbox:

```dart
class CheckboxExample extends StatefulWidget {
  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _isChecked = false;
  
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Agree to terms'),
      subtitle: Text('You must agree to continue'),
      value: _isChecked,
      onChanged: (value) {
        setState(() => _isChecked = value ?? false);
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
```

### Radio Buttons:

```dart
enum Gender { male, female, other }

class RadioExample extends StatefulWidget {
  @override
  _RadioExampleState createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  Gender? _selectedGender;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<Gender>(
          title: Text('Male'),
          value: Gender.male,
          groupValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        RadioListTile<Gender>(
          title: Text('Female'),
          value: Gender.female,
          groupValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        RadioListTile<Gender>(
          title: Text('Other'),
          value: Gender.other,
          groupValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
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
  _SwitchExampleState createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _isSwitched = false;
  
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Enable notifications'),
      subtitle: Text('Receive push notifications'),
      value: _isSwitched,
      onChanged: (value) => setState(() => _isSwitched = value),
      activeColor: Colors.blue,
      activeTrackColor: Colors.blue.shade200,
    );
  }
}
```

---

## Dropdown and Selection

### DropdownButtonFormField:

```dart
class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? _selectedCountry;
  final List<String> _countries = ['USA', 'Canada', 'Mexico', 'UK', 'Germany'];
  
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCountry,
      decoration: InputDecoration(
        labelText: 'Country',
        prefixIcon: Icon(Icons.location_on),
      ),
      items: _countries.map((country) {
        return DropdownMenuItem(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCountry = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a country';
        }
        return null;
      },
    );
  }
}
```

### Autocomplete:

```dart
class AutocompleteExample extends StatefulWidget {
  @override
  _AutocompleteExampleState createState() => _AutocompleteExampleState();
}

class _AutocompleteExampleState extends State<AutocompleteExample> {
  final List<String> _options = [
    'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry',
    'Fig', 'Grape', 'Honeydew', 'Kiwi', 'Lemon'
  ];
  
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _options.where((option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        print('Selected: $selection');
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Search fruits',
            prefixIcon: Icon(Icons.search),
          ),
        );
      },
    );
  }
}
```

---

## Date and Time Pickers

### Date Picker:

```dart
class DatePickerExample extends StatefulWidget {
  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? _selectedDate;
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Birth Date',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: _selectedDate != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : '',
          ),
          onTap: () => _selectDate(context),
          validator: (value) {
            if (_selectedDate == null) {
              return 'Please select a date';
            }
            return null;
          },
        ),
      ],
    );
  }
}
```

### Time Picker:

```dart
class TimePickerExample extends StatefulWidget {
  @override
  _TimePickerExampleState createState() => _TimePickerExampleState();
}

class _TimePickerExampleState extends State<TimePickerExample> {
  TimeOfDay? _selectedTime;
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Time',
        suffixIcon: Icon(Icons.access_time),
      ),
      controller: TextEditingController(
        text: _selectedTime != null ? _selectedTime!.format(context) : '',
      ),
      onTap: () => _selectTime(context),
    );
  }
}
```

---

## Slider and Range Slider

### Slider:

```dart
class SliderExample extends StatefulWidget {
  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _sliderValue = 50.0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Value: ${_sliderValue.round()}'),
        Slider(
          value: _sliderValue,
          min: 0,
          max: 100,
          divisions: 10,
          label: _sliderValue.round().toString(),
          activeColor: Colors.blue,
          inactiveColor: Colors.blue.shade100,
          onChanged: (value) {
            setState(() => _sliderValue = value);
          },
        ),
      ],
    );
  }
}
```

### Range Slider:

```dart
class RangeSliderExample extends StatefulWidget {
  @override
  _RangeSliderExampleState createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  RangeValues _rangeValues = RangeValues(20, 80);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Range: ${_rangeValues.start.round()} - ${_rangeValues.end.round()}'),
        RangeSlider(
          values: _rangeValues,
          min: 0,
          max: 100,
          divisions: 10,
          labels: RangeLabels(
            _rangeValues.start.round().toString(),
            _rangeValues.end.round().toString(),
          ),
          onChanged: (values) {
            setState(() => _rangeValues = values);
          },
        ),
      ],
    );
  }
}
```

---

## Input Formatters

### Common Formatters:

```dart
// Digits only
TextField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
)

// Allow specific characters
TextField(
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ],
)

// Phone number formatter
TextField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
)

// Currency formatter
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    final value = int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
    final formatted = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    ).format(value);
    
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Credit card formatter
class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
```

---

## Form State Management

### Using Provider:

```dart
class FormModel extends ChangeNotifier {
  final Map<String, String> _errors = {};
  final Map<String, dynamic> _values = {};
  
  String? getError(String field) => _errors[field];
  dynamic getValue(String field) => _values[field];
  
  void setValue(String field, dynamic value) {
    _values[field] = value;
    _errors.remove(field); // Clear error when value changes
    notifyListeners();
  }
  
  void setError(String field, String error) {
    _errors[field] = error;
    notifyListeners();
  }
  
  bool validate() {
    bool isValid = true;
    
    // Email validation
    final email = _values['email'] as String?;
    if (email == null || email.isEmpty) {
      setError('email', 'Email is required');
      isValid = false;
    } else if (!email.contains('@')) {
      setError('email', 'Invalid email format');
      isValid = false;
    }
    
    // Password validation
    final password = _values['password'] as String?;
    if (password == null || password.length < 6) {
      setError('password', 'Password must be at least 6 characters');
      isValid = false;
    }
    
    return isValid;
  }
  
  void submit() {
    if (validate()) {
      // Submit form
      print('Form submitted: $_values');
    }
  }
}

class ProviderForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(
      builder: (context, form, child) {
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: form.getError('email'),
              ),
              onChanged: (value) => form.setValue('email', value),
            ),
            
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: form.getError('password'),
              ),
              obscureText: true,
              onChanged: (value) => form.setValue('password', value),
            ),
            
            ElevatedButton(
              onPressed: form.submit,
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## Advanced Form Patterns

### Dynamic Forms:

```dart
class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final List<FormFieldData> _fields = [];
  
  void _addField() {
    setState(() {
      _fields.add(FormFieldData(
        id: DateTime.now().toString(),
        type: FieldType.text,
        label: 'Field ${_fields.length + 1}',
      ));
    });
  }
  
  void _removeField(String id) {
    setState(() {
      _fields.removeWhere((field) => field.id == id);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._fields.map((field) => FormFieldWidget(
          field: field,
          onRemove: () => _removeField(field.id),
        )),
        
        ElevatedButton(
          onPressed: _addField,
          child: Text('Add Field'),
        ),
      ],
    );
  }
}

class FormFieldWidget extends StatelessWidget {
  final FormFieldData field;
  final VoidCallback onRemove;
  
  const FormFieldWidget({
    super.key,
    required this.field,
    required this.onRemove,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: field.label),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
```

### Multi-Step Forms:

```dart
class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());
  
  final _controllers = List.generate(3, (_) => TextEditingController());
  
  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
      } else {
        _submitForm();
      }
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
  
  void _submitForm() {
    // Collect all data and submit
    final data = _controllers.map((c) => c.text).toList();
    print('Form data: $data');
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / 3,
        ),
        
        Expanded(
          child: IndexedStack(
            index: _currentStep,
            children: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
            ],
          ),
        ),
        
        Row(
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: _previousStep,
                child: Text('Previous'),
              ),
            Spacer(),
            ElevatedButton(
              onPressed: _nextStep,
              child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: TextFormField(
        controller: _controllers[0],
        decoration: InputDecoration(labelText: 'Name'),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
  
  Widget _buildStep2() {
    return Form(
      key: _formKeys[1],
      child: TextFormField(
        controller: _controllers[1],
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => !value!.contains('@') ? 'Invalid email' : null,
      ),
    );
  }
  
  Widget _buildStep3() {
    return Form(
      key: _formKeys[2],
      child: TextFormField(
        controller: _controllers[2],
        decoration: InputDecoration(labelText: 'Phone'),
        validator: (value) => value!.length < 10 ? 'Invalid phone' : null,
      ),
    );
  }
}
```

---

## Accessibility

### Screen Reader Support:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address',
    helperText: 'Enter your email address',
    hintText: 'example@email.com',
  ),
  // Screen reader will announce these
  semanticsLabel: 'Email input field',
  semanticsHint: 'Enter your email address to create account',
)
```

### Keyboard Navigation:

```dart
Form(
  child: Column(
    children: [
      TextFormField(
        autofocus: true,  // Start here
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
      
      TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
      
      ElevatedButton(
        onPressed: () {
          // Submit form
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

---

## Summary

- **TextField**: Basic text input with customization
- **TextFormField**: Form validation and saving
- **Form**: Container for grouping form fields
- **Focus Management**: Control input focus and navigation
- **Selection Controls**: Checkboxes, radio buttons, switches
- **Dropdown**: Selection from predefined options
- **Date/Time Pickers**: Calendar and time selection
- **Sliders**: Numeric value selection
- **Input Formatters**: Text input filtering and formatting
- **Form State Management**: Provider, BLoC patterns
- **Advanced Patterns**: Dynamic forms, multi-step forms
- **Accessibility**: Screen reader and keyboard support

Forms are essential for user interaction - focus on validation, user experience, and accessibility.
    labelText: "Password",
    prefixIcon: Icon(Icons.lock),
    suffixIcon: IconButton(
      icon: Icon(Icons.visibility),
      onPressed: () {
        // Toggle visibility
      },
    ),
  ),
)

// Number
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  decoration: InputDecoration(
    labelText: "Age",
    prefixIcon: Icon(Icons.calendar_today),
  ),
)

// Multiline
TextField(
  maxLines: 5,
  minLines: 3,
  decoration: InputDecoration(
    labelText: "Description",
    alignLabelWithHint: true,
  ),
)
```

### TextEditingController:

```dart
class TextFieldController extends StatefulWidget {
  @override
  _TextFieldControllerState createState() => _TextFieldControllerState();
}

class _TextFieldControllerState extends State<TextFieldController> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controller.text = "Initial value";
    _controller.addListener(_onTextChanged);
  }
  
  void _onTextChanged() {
    print("Text changed: ${_controller.text}");
  }
  
  void _clearText() {
    _controller.clear();
  }
  
  void _setText() {
    _controller.text = "New text";
    _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearText,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _setText,
          child: Text("Set Text"),
        ),
      ],
    );
  }
}
```

---

## Form and TextFormField

A container for grouping and validating multiple form fields.

### Basic Form:

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  
  String _email = '';
  String _password = '';
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, submit data
      print('Email: $_email, Password: $_password');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Advanced Form Validation:

```dart
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _agreeToTerms = false;
  
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }
  
  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please agree to terms and conditions')),
        );
        return;
      }
      
      _formKey.currentState!.save();
      // Submit registration
      print('Registration successful');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Full Name'),
            validator: _validateName,
            onSaved: (value) => _name = value!,
          ),
          
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onSaved: (value) => _email = value!,
          ),
          
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: _validatePassword,
            onSaved: (value) => _password = value!,
            onChanged: (value) => _password = value,
          ),
          
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: _validateConfirmPassword,
            onSaved: (value) => _confirmPassword = value!,
          ),
          
          CheckboxListTile(
            title: Text('I agree to the terms and conditions'),
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() => _agreeToTerms = value ?? false);
            },
          ),
          
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

---

## Focus Management

Controlling which input field has focus.

### Basic Focus:

```dart
class FocusExample extends StatefulWidget {
  @override
  _FocusExampleState createState() => _FocusExampleState();
}

class _FocusExampleState extends State<FocusExample> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  
  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _focusNode1,
          decoration: InputDecoration(labelText: 'Field 1'),
          onSubmitted: (_) => _focusNode2.requestFocus(),
        ),
        TextField(
          focusNode: _focusNode2,
          decoration: InputDecoration(labelText: 'Field 2'),
        ),
        ElevatedButton(
          onPressed: () => _focusNode1.requestFocus(),
          child: Text('Focus First Field'),
        ),
      ],
    );
  }
}
```

### FocusScope:

```dart
class FocusScopeExample extends StatefulWidget {
  @override
  _FocusScopeExampleState createState() => _FocusScopeExampleState();
}

class _FocusScopeExampleState extends State<FocusScopeExample> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  
  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Field 1'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Field 2'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _focusScopeNode.nextFocus(),
                child: Text('Next'),
              ),
              ElevatedButton(
                onPressed: () => _focusScopeNode.previousFocus(),
                child: Text('Previous'),
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

## Selection Controls

Widgets for making selections.

### Checkbox:

```dart
class CheckboxExample extends StatefulWidget {
  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _isChecked = false;
  
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Agree to terms'),
      subtitle: Text('You must agree to continue'),
      value: _isChecked,
      onChanged: (value) {
        setState(() => _isChecked = value ?? false);
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
```

### Radio Buttons:

```dart
enum Gender { male, female, other }

class RadioExample extends StatefulWidget {
  @override
  _RadioExampleState createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  Gender? _selectedGender;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<Gender>(
          title: Text('Male'),
          value: Gender.male,
          groupValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        RadioListTile<Gender>(
          title: Text('Female'),
          value: Gender.female,
          groupValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        RadioListTile<Gender>(
          title: Text('Other'),
          value: Gender.other,
          groupValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
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
  _SwitchExampleState createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _isSwitched = false;
  
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Enable notifications'),
      subtitle: Text('Receive push notifications'),
      value: _isSwitched,
      onChanged: (value) => setState(() => _isSwitched = value),
      activeColor: Colors.blue,
      activeTrackColor: Colors.blue.shade200,
    );
  }
}
```

---

## Dropdown and Selection

### DropdownButtonFormField:

```dart
class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? _selectedCountry;
  final List<String> _countries = ['USA', 'Canada', 'Mexico', 'UK', 'Germany'];
  
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCountry,
      decoration: InputDecoration(
        labelText: 'Country',
        prefixIcon: Icon(Icons.location_on),
      ),
      items: _countries.map((country) {
        return DropdownMenuItem(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCountry = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a country';
        }
        return null;
      },
    );
  }
}
```

### Autocomplete:

```dart
class AutocompleteExample extends StatefulWidget {
  @override
  _AutocompleteExampleState createState() => _AutocompleteExampleState();
}

class _AutocompleteExampleState extends State<AutocompleteExample> {
  final List<String> _options = [
    'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry',
    'Fig', 'Grape', 'Honeydew', 'Kiwi', 'Lemon'
  ];
  
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _options.where((option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        print('Selected: $selection');
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Search fruits',
            prefixIcon: Icon(Icons.search),
          ),
        );
      },
    );
  }
}
```

---

## Date and Time Pickers

### Date Picker:

```dart
class DatePickerExample extends StatefulWidget {
  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? _selectedDate;
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Birth Date',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: _selectedDate != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : '',
          ),
          onTap: () => _selectDate(context),
          validator: (value) {
            if (_selectedDate == null) {
              return 'Please select a date';
            }
            return null;
          },
        ),
      ],
    );
  }
}
```

### Time Picker:

```dart
class TimePickerExample extends StatefulWidget {
  @override
  _TimePickerExampleState createState() => _TimePickerExampleState();
}

class _TimePickerExampleState extends State<TimePickerExample> {
  TimeOfDay? _selectedTime;
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Time',
        suffixIcon: Icon(Icons.access_time),
      ),
      controller: TextEditingController(
        text: _selectedTime != null ? _selectedTime!.format(context) : '',
      ),
      onTap: () => _selectTime(context),
    );
  }
}
```

---

## Slider and Range Slider

### Slider:

```dart
class SliderExample extends StatefulWidget {
  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _sliderValue = 50.0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Value: ${_sliderValue.round()}'),
        Slider(
          value: _sliderValue,
          min: 0,
          max: 100,
          divisions: 10,
          label: _sliderValue.round().toString(),
          activeColor: Colors.blue,
          inactiveColor: Colors.blue.shade100,
          onChanged: (value) {
            setState(() => _sliderValue = value);
          },
        ),
      ],
    );
  }
}
```

### Range Slider:

```dart
class RangeSliderExample extends StatefulWidget {
  @override
  _RangeSliderExampleState createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  RangeValues _rangeValues = RangeValues(20, 80);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Range: ${_rangeValues.start.round()} - ${_rangeValues.end.round()}'),
        RangeSlider(
          values: _rangeValues,
          min: 0,
          max: 100,
          divisions: 10,
          labels: RangeLabels(
            _rangeValues.start.round().toString(),
            _rangeValues.end.round().toString(),
          ),
          onChanged: (values) {
            setState(() => _rangeValues = values);
          },
        ),
      ],
    );
  }
}
```

---

## Input Formatters

### Common Formatters:

```dart
// Digits only
TextField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
)

// Allow specific characters
TextField(
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ],
)

// Phone number formatter
TextField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
)

// Currency formatter
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    final value = int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
    final formatted = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    ).format(value);
    
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Credit card formatter
class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
```

---

## Form State Management

### Using Provider:

```dart
class FormModel extends ChangeNotifier {
  final Map<String, String> _errors = {};
  final Map<String, dynamic> _values = {};
  
  String? getError(String field) => _errors[field];
  dynamic getValue(String field) => _values[field];
  
  void setValue(String field, dynamic value) {
    _values[field] = value;
    _errors.remove(field); // Clear error when value changes
    notifyListeners();
  }
  
  void setError(String field, String error) {
    _errors[field] = error;
    notifyListeners();
  }
  
  bool validate() {
    bool isValid = true;
    
    // Email validation
    final email = _values['email'] as String?;
    if (email == null || email.isEmpty) {
      setError('email', 'Email is required');
      isValid = false;
    } else if (!email.contains('@')) {
      setError('email', 'Invalid email format');
      isValid = false;
    }
    
    // Password validation
    final password = _values['password'] as String?;
    if (password == null || password.length < 6) {
      setError('password', 'Password must be at least 6 characters');
      isValid = false;
    }
    
    return isValid;
  }
  
  void submit() {
    if (validate()) {
      // Submit form
      print('Form submitted: $_values');
    }
  }
}

class ProviderForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(
      builder: (context, form, child) {
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: form.getError('email'),
              ),
              onChanged: (value) => form.setValue('email', value),
            ),
            
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: form.getError('password'),
              ),
              obscureText: true,
              onChanged: (value) => form.setValue('password', value),
            ),
            
            ElevatedButton(
              onPressed: form.submit,
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## Advanced Form Patterns

### Dynamic Forms:

```dart
class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final List<FormFieldData> _fields = [];
  
  void _addField() {
    setState(() {
      _fields.add(FormFieldData(
        id: DateTime.now().toString(),
        type: FieldType.text,
        label: 'Field ${_fields.length + 1}',
      ));
    });
  }
  
  void _removeField(String id) {
    setState(() {
      _fields.removeWhere((field) => field.id == id);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._fields.map((field) => FormFieldWidget(
          field: field,
          onRemove: () => _removeField(field.id),
        )),
        
        ElevatedButton(
          onPressed: _addField,
          child: Text('Add Field'),
        ),
      ],
    );
  }
}

class FormFieldWidget extends StatelessWidget {
  final FormFieldData field;
  final VoidCallback onRemove;
  
  const FormFieldWidget({
    super.key,
    required this.field,
    required this.onRemove,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: field.label),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
```

### Multi-Step Forms:

```dart
class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());
  
  final _controllers = List.generate(3, (_) => TextEditingController());
  
  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
      } else {
        _submitForm();
      }
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
  
  void _submitForm() {
    // Collect all data and submit
    final data = _controllers.map((c) => c.text).toList();
    print('Form data: $data');
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / 3,
        ),
        
        Expanded(
          child: IndexedStack(
            index: _currentStep,
            children: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
            ],
          ),
        ),
        
        Row(
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: _previousStep,
                child: Text('Previous'),
              ),
            Spacer(),
            ElevatedButton(
              onPressed: _nextStep,
              child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: TextFormField(
        controller: _controllers[0],
        decoration: InputDecoration(labelText: 'Name'),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
  
  Widget _buildStep2() {
    return Form(
      key: _formKeys[1],
      child: TextFormField(
        controller: _controllers[1],
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => !value!.contains('@') ? 'Invalid email' : null,
      ),
    );
  }
  
  Widget _buildStep3() {
    return Form(
      key: _formKeys[2],
      child: TextFormField(
        controller: _controllers[2],
        decoration: InputDecoration(labelText: 'Phone'),
        validator: (value) => value!.length < 10 ? 'Invalid phone' : null,
      ),
    );
  }
}
```

---

## Accessibility

### Screen Reader Support:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address',
    helperText: 'Enter your email address',
    hintText: 'example@email.com',
  ),
  // Screen reader will announce these
  semanticsLabel: 'Email input field',
  semanticsHint: 'Enter your email address to create account',
)
```

### Keyboard Navigation:

```dart
Form(
  child: Column(
    children: [
      TextFormField(
        autofocus: true,  // Start here
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
      
      TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
      
      ElevatedButton(
        onPressed: () {
          // Submit form
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

---

## Summary

- **TextField**: Basic text input with customization
- **TextFormField**: Form validation and saving
- **Form**: Container for grouping form fields
- **Focus Management**: Control input focus and navigation
- **Selection Controls**: Checkboxes, radio buttons, switches
- **Dropdown**: Selection from predefined options
- **Date/Time Pickers**: Calendar and time selection
- **Sliders**: Numeric value selection
- **Input Formatters**: Text input filtering and formatting
- **Form State Management**: Provider, BLoC patterns
- **Advanced Patterns**: Dynamic forms, multi-step forms
- **Accessibility**: Screen reader and keyboard support

Forms are essential for user interaction - focus on validation, user experience, and accessibility.
    labelText: "Password",
    prefixIcon: Icon(Icons.lock),
    suffixIcon: Icon(Icons.visibility),
  ),
)

// Phone
TextField(
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    labelText: "Phone",
    prefixIcon: Icon(Icons.phone),
  ),
)

// Multiline
TextField(
  maxLines: 5,
  decoration: InputDecoration(
    labelText: "Comments",
    border: OutlineInputBorder(),
  ),
)
```

---

## TextEditingController

Manage text input programmatically.

### Basic Usage:

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();  // Always dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
        ),
        ElevatedButton(
          onPressed: () {
            print(_controller.text);  // Get text
          },
          child: Text("Submit"),
        ),
      ],
    );
  }
}
```

### Controller Methods:

```dart
// Get text
String text = _controller.text;

// Set text
_controller.text = "New text";

// Clear
_controller.clear();

// Get selection
TextSelection selection = _controller.selection;

// Set cursor position
_controller.selection = TextSelection.fromPosition(
  TextPosition(offset: 0),
);

// Listen to changes
_controller.addListener(() {
  print("Text changed: ${_controller.text}");
});
```

---

## Form Widget

Validate multiple input fields together.

### Basic Form:

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid
                print("Email: ${_emailController.text}");
                print("Password: ${_passwordController.text}");
              }
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
```

---

## Validation

### Common Validations:

```dart
// Email validation
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  },
)

// Number validation
TextFormField(
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Required";
    }
    if (int.tryParse(value) == null) {
      return "Enter a valid number";
    }
    return null;
  },
)

// Phone validation
TextFormField(
  keyboardType: TextInputType.phone,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Phone required";
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Enter 10 digit phone";
    }
    return null;
  },
)

// Custom validation
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Required";
    }
    if (!_isValidUsername(value)) {
      return "Invalid username";
    }
    return null;
  },
)

bool _isValidUsername(String username) {
  return username.length >= 3 && username.length <= 20;
}
```

### Async Validation:

```dart
TextFormField(
  validator: (value) async {
    if (value == null || value.isEmpty) {
      return "Required";
    }
    
    // Check if username is available
    bool isAvailable = await _checkUsernameAvailability(value);
    
    if (!isAvailable) {
      return "Username already taken";
    }
    return null;
  },
)

Future<bool> _checkUsernameAvailability(String username) async {
  // API call
  await Future.delayed(Duration(seconds: 1));
  return true;
}
```

---

## Focus Management

### FocusNode:

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _emailFocus,
          decoration: InputDecoration(labelText: "Email"),
          onSubmitted: (_) {
            // Move to password field
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
        ),
        TextField(
          focusNode: _passwordFocus,
          decoration: InputDecoration(labelText: "Password"),
        ),
      ],
    );
  }
}
```

### Focus Operations:

```dart
// Request focus
FocusScope.of(context).requestFocus(_emailFocus);

// Remove focus
_emailFocus.unfocus();

// Check if focused
if (_emailFocus.hasFocus) {
  print("Email field is focused");
}

// Listen to focus changes
_emailFocus.addListener(() {
  if (_emailFocus.hasFocus) {
    print("Email focused");
  } else {
    print("Email unfocused");
  }
});
```

### Keyboard Management:

```dart
// Hide keyboard
FocusScope.of(context).unfocus();

// Or
FocusManager.instance.primaryFocus?.unfocus();
```

---

## Dropdown

Select from a list of options.

### Basic Dropdown:

```dart
class DropdownExample extends StatefulWidget {
  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? selectedValue = "Option 1";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: [
        DropdownMenuItem(value: "Option 1", child: Text("Option 1")),
        DropdownMenuItem(value: "Option 2", child: Text("Option 2")),
        DropdownMenuItem(value: "Option 3", child: Text("Option 3")),
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}
```

### Dropdown with Dynamic Items:

```dart
List<String> countries = ["USA", "Canada", "UK", "India"];

DropdownButton<String>(
  value: selectedCountry,
  items: countries
      .map((country) =>
          DropdownMenuItem(value: country, child: Text(country)))
      .toList(),
  onChanged: (value) {
    setState(() {
      selectedCountry = value!;
    });
  },
)
```

### DropdownButton vs DropdownButton2:

```yaml
dependencies:
  dropdown_button2: ^2.0.0
```

```dart
DropdownButton2(
  value: selectedValue,
  items: items,
  onChanged: (value) {},
  buttonStyleData: ButtonStyleData(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey),
    ),
  ),
)
```

---

## Checkbox, Radio, Switch

### Checkbox:

```dart
bool isChecked = false;

Checkbox(
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value!;
    });
  },
)
```

### Radio:

```dart
String? selectedOption = "Option 1";

Column(
  children: [
    Radio<String>(
      value: "Option 1",
      groupValue: selectedOption,
      onChanged: (value) {
        setState(() {
          selectedOption = value;
        });
      },
    ),
    Radio<String>(
      value: "Option 2",
      groupValue: selectedOption,
      onChanged: (value) {
        setState(() {
          selectedOption = value;
        });
      },
    ),
  ],
)
```

### Switch:

```dart
bool isEnabled = false;

Switch(
  value: isEnabled,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
)
```

---

## Date & Time Pickers

### Date Picker:

```dart
DateTime? selectedDate;

ElevatedButton(
  onPressed: () async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  },
  child: Text(
    selectedDate == null
        ? "Pick Date"
        : selectedDate!.toString().split(" ")[0],
  ),
)
```

### Time Picker:

```dart
TimeOfDay? selectedTime;

ElevatedButton(
  onPressed: () async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  },
  child: Text(
    selectedTime == null
        ? "Pick Time"
        : selectedTime!.format(context),
  ),
)
```

---

## Summary

- **TextField**: Basic text input
- **TextEditingController**: Manage text programmatically
- **Form**: Validate multiple fields
- **TextFormField**: Form field with validation
- **FocusNode**: Manage focus
- **Validation**: Ensure user input
- **Dropdown**: Select from options
- **Checkboxes/Radio/Switch**: Boolean inputs
- **Date/Time Pickers**: Select dates/times
