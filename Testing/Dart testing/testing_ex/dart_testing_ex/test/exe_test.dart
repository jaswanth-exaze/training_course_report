import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class Challenge {
  int add(String input) {
    if (input.isEmpty) return 0;

    if (input.startsWith("//")) {
      final parts = input.split('\n');

      input = parts[1];

      if (parts[0].contains("[")) {
        final matches = RegExp(r'\[(.*?)\]').allMatches(parts[0]);

        final delimiters = matches.map((e) => e.group(1)!).toList();

        for (final delimiter in delimiters) {
          input = input.replaceAll(delimiter, ",");
        }
      } else {
        final delimiter = parts[0].substring(2);

        input = input.replaceAll(delimiter, ",");
      }
    } else {
      input = input.replaceAll('\n', ",");
    }

    List<int> numbersList = input.split(',').map((e) => int.parse(e)).toList();

    final negatives = numbersList.where((e) => e < 0).toList();

    if (negatives.isNotEmpty) {
      throw FormatException(
        'negative numbers not allowed: ${negatives.join(", ")}',
      );
    }

    numbersList = numbersList.where((e) => e <= 1000).toList();

    return numbersList.fold(0, (sum, number) => sum + number);
  }
}

void main() {
  setUpAll(() {
    print('This runs once before all tests in this file/group');
  });
  group("tests for addition->", () {
    test("Addition of two numbers with 0 as one input", () {
      final result = Challenge().add("4, 0");
      expect((result), equals(4));
    });
    test("Addition of two numbers with 0 as two inputs", () {
      final result = Challenge().add("0, 0");
      expect((result), equals(0));
    });
    test("Addition of two numbers", () {
      final result = Challenge().add("4, 6");
      expect((result), equals(10));
    });
    test("Numbers bigger than 1000 should be ignored", () {
      final result = Challenge().add("2,1001");
      expect(result, equals(2));
    });
    test("Addition of two numbers with new line(\n)", () {
      final result = Challenge().add("4\n6");
      expect((result), equals(10));
    });
    test("Addition of two numbers with delimiter", () {
      final result = Challenge().add("//;\n1;2");
      expect((result), equals(3));
    });

    test("throws on negative numbers", () {
      expect(
        () => Challenge().add("1,0,-3,-4"),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            "message",
            "negative numbers not allowed: -3, -4",
          ),
        ),
      );
    });
    test('throws on negatives with custom delimiter', () {
      expect(
        () => Challenge().add("//;\n1;-2;3;-5"),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'negative numbers not allowed: -2, -5',
          ),
        ),
      );
    });
  });
}
