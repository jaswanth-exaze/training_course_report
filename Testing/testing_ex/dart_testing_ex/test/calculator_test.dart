import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '../calculator/calculator.dart';

void main() {
  setUp(() {
    Calculator();
  });

  group("Calculator Business Logic Test", () {
    group("Addtion -->", () {
      test('add() should accurately sum two integers', () {
        final result = Calculator().add(3, 5);
        expect(result, equals(8));
      });

      test('add() should handle negative integers', () {
        final result = Calculator().add(-3, 5);
        expect(result, equals(2));
      });

      test('add() should hanndle 0 values', () {
        final result = Calculator().add(0, 5);
        expect(result, equals(5));
      });
    });
    group("Modulous Division -->", () {
      test("modulo() by zero must throw an ArgumentError exception", () {
        expect(() => Calculator().modulo(4, 0), throwsA(isA<ArgumentError>()));
      });
    });
  });
}
