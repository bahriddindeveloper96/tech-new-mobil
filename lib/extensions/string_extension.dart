extension StringExtension on String {
  String formatMoney() {
    final buffer = StringBuffer();
    final chars = split('').reversed.toList();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(chars[i]);
    }
    return buffer.toString().split('').reversed.join() + ' so\'m';
  }
}
