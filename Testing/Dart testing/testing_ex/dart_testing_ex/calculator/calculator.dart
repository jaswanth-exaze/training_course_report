import 'dart:math' as math;

class Calculator {
  double add(double a, double b) => a + b;

  double subtract(double a, double b) => a - b;

  double multiply(double a, double b) => a * b;

  double divide(double a, double b) {
    if (b == 0) {
      throw ArgumentError('Division by zero is strictly prohibited.');
    }
    return a / b;
  }

  double modulo(double a, double b) {
    if (b == 0) {
      throw ArgumentError('Modulo by zero is strictly prohibited.');
    }
    return a % b;
  }

  double power(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }

  double squareRoot(double value) {
    if (value < 0) {
      throw ArgumentError(
        'Cannot calculate the square root of a negative number.',
      );
    }

    return math.sqrt(value);
  }

  double absolute(double value) => value.abs();

  double percentage(double total, double percent) => (total * percent) / 100;

  double roundToDecimalPlaces(double value, int places) {
    if (places < 0) {
      throw ArgumentError('Decimal places cannot be negative.');
    }

    num mod = math.pow(10, places);
    return (value * mod).round() / mod;
  }

  double sumList(List<double> numbers) {
    if (numbers.isEmpty) return 0.0;
    return numbers.reduce((value, element) => value + element);
  }

  double averageList(List<double> numbers) {
    if (numbers.isEmpty) return 0.0;
    return sumList(numbers) / numbers.length;
  }
}
