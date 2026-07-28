import 'package:flutter_application_1/addition.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('Adds two comma-separated positive numbers', () {
    expect(add("1,2"), equals(3));
  });

  test('returns number if string contain number only', () {
    expect(add("1"), equals(1));
  });

  test('returns 0 if string is empty', () {
    expect(add(""), equals(0));
  });

  test('throws FormatException when negative numbers are present', () {
    expect(() => add("-3,10"), throwsA(isA<FormatException>()));
  });

  test('Handles zero', () {
    expect(add("0,42"), equals(42));
  });

  test("new line between numbers", () {
    expect(add("1\n2,3"), 6);
  });
  
  test("new line between numbers", () {
    expect(add("//;\n1;2"), 3);
  });
}
