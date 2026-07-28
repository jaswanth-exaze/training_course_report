import 'package:test/test.dart';

import 'exe_test.dart';

void main() {
  group("Looing Tests ", () {
    final cases = <({String input, int expected})>[
      (input: "", expected: 0),
      (input: "1,2", expected: 3),
      (input: "0, 0", expected: 0),
      (input: "2,1001", expected: 2),
      (input: "4\n6", expected: 10),
      (input: "//;\n1;2", expected: 3),
    ];

    for (final c in cases) {
      test("add(${c.input})==${c.expected}", () {
        expect(Challenge().add(c.input), equals(c.expected));
      });
    }
  });
  group("Negative Number Exception Tests", () {
    final cases = <({String input, String message})>[
      (input: "1,0,-3,-4", message: "negative numbers not allowed: -3, -4"),
      (
        input: "//;\n1;-2;3;-5",
        message: "negative numbers not allowed: -2, -5",
      ),
      (input: "-1", message: "negative numbers not allowed: -1"),
      (input: "-1,-2,-3", message: "negative numbers not allowed: -1, -2, -3"),
    ];

    for (final c in cases) {
      test("add('${c.input}') throws FormatException", () {
        expect(
          () => Challenge().add(c.input),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              "message",
              c.message,
            ),
          ),
        );
      });
    }
  });
  group("Multiple Delimiter Tests", () {
    final cases = <({String input, int expected})>[
      (input: "//[*][%]\n1*2%3", expected: 6),
      (input: "//[***][#]\n1***2#3", expected: 6),
      (input: "//[***][%%]\n1***2%%3", expected: 6),
      (input: "//[*][%][#]\n1*2%3#4", expected: 10),
      (input: "//[--][+++]\n1--2+++3", expected: 6),
      (input: "//[abc][xyz]\n1abc2xyz3", expected: 6),
    ];

    for (final c in cases) {
      test("add('${c.input}') == ${c.expected}", () {
        expect(Challenge().add(c.input), equals(c.expected));
      });
    }
  });
  group("Multiple Delimiter Exception Tests", () {
    final cases = <({String input, String expectedMessage})>[
      (
        input: "//[*][%]\n1*-2%3",
        expectedMessage: "negative numbers not allowed: -2",
      ),
      (
        input: "//[***][#]\n1***-2#-3",
        expectedMessage: "negative numbers not allowed: -2, -3",
      ),
      (
        input: "//[abc][xyz]\n-1abc2xyz-5",
        expectedMessage: "negative numbers not allowed: -1, -5",
      ),
    ];

    for (final c in cases) {
      test("add('${c.input}') throws FormatException", () {
        expect(
          () => Challenge().add(c.input),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              "message",
              equals(c.expectedMessage),
            ),
          ),
        );
      });
    }
  });
}
