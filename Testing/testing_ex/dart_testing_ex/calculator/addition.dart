int add(String numbers) {
  if (numbers.isEmpty) return 0;

    if (numbers.startsWith('//')) {
    final parts = numbers.split('\n');

    final delimiter = parts[0].substring(2);

    numbers = parts[1].replaceAll(delimiter, ',');
  } else {
    numbers = numbers.replaceAll('\n', ',');
  }

  List<int> numbersInList = numbers
      .split(',')
      .map((e) => int.parse(e))
      .toList();

  List<int> negatives = numbersInList.where((e) => e < 0).toList();

  if (negatives.isNotEmpty) {
    throw FormatException(
      'negatives not allowed: ${negatives.join(", ")}',
    );
  }

  return numbersInList.fold(0, (sum, number) => sum + number);
}