void main() {}
int add(String numbers) {
  int sum = 0;
  if (numbers.isNotEmpty) {
    if (numbers.contains("-")) {
      throw FormatException('Negative numbers are not allowed');
    }
    if (RegExp(r'^\d+$').hasMatch(numbers)) {
      return int.parse(numbers);
    }
    if (numbers.contains('\n')) {
      print(numbers);
      numbers.replaceAll('\n', ",");
    }
    List<String> numbersInList = numbers.split(",");
    sum = numbersInList.map((e) => int.parse(e)).reduce((a, b) => a + b);
    return sum;
  }

  return sum;
}
