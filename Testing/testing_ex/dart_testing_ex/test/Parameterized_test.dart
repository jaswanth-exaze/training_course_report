import 'package:test/test.dart';

import 'exe_test.dart';

void main() {
  void addtionTestFn(String input, int expected) {
    test("Addtion of input $input is $expected", () {
      expect(Challenge().add(input), equals(expected));
    });
  }

  void addtionTestFnwithException(String input, String message) {
    test("Negative Number Exception Tests", () {
      expect(
        () => Challenge().add(input),
        throwsA(
          isA<FormatException>().having((e) => e.message, "message", message),
        ),
      );
    });
  }

  addtionTestFnwithException(
    "-1,-2,-3",
    "negative numbers not allowed: -1, -2, -3",
  );
  group("Addtion -->", () {
    addtionTestFn("", 0);
    addtionTestFn("1,3,2", 6);
  });
}
