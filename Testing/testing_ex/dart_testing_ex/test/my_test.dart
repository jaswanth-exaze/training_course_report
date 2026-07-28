import 'package:test/test.dart';

import '../calculator/addition.dart';

void main() {
  setUpAll(() {
  print('This runs once before all tests in this file/group');
    });
  group("Unit testing on ADD function", () {
    test('Adds two comma-separated positive numbers', () {
      expect(add("1,2"), equals(3));
    });

    test('returns number if string contain number only', () {
      expect(add("1"), equals(1));
    });

    test('returns 0 if string is empty', () {
      expect(add(""), equals(0));
    });
    test("new line between numbers", () {
      expect(add("1\n2,3"), 6);
    });

    test('throws FormatException when negative numbers are present', () {
      expect(() => add("-3,10"), throwsA(isA<FormatException>()));
    });

    test('Handles zero', () {
      expect(add("0,42"), equals(42));
    });

    test('throws exception containing all negative numbers', () {
      expect(
        () => add("1,-2,3,-5"),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'negatives not allowed: -2, -5',
          ),
        ),
      );
    });

    test("delimeter  between numbers", () {
      expect(add("//;\n1;2"), 3);
    });
  });

  group("delimiter testing", () {
    test('supports semicolon delimiter', () {
      expect(add("//;\n1;2"), equals(3));
    });

    test('supports pipe delimiter', () {
      expect(add("//|\n1|2|3"), equals(6));
    });

    test('supports star delimiter', () {
      expect(add("//*\n1*2*3"), equals(6));
    });

    test('still supports comma delimiter', () {
      expect(add("1,2,3"), equals(6));
    });

    test('still supports newline delimiter', () {
      expect(add("1\n2,3"), equals(6));
    });

    test('throws on negatives with custom delimiter', () {
      expect(
        () => add("//;\n1;-2;3;-5"),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'negatives not allowed: -2, -5',
          ),
        ),
      );
    });
  });
}
