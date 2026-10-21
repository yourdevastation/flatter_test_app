extension DateTimeExtension on DateTime {
  String toShortDate() => '${_twoDigits(day)}.${_twoDigits(month)}.$year';

  String toRelativeDay() {
    final today = DateTime.now();
    final days = DateTime(
      today.year,
      today.month,
      today.day,
    ).difference(DateTime(year, month, day)).inDays;

    return switch (days) {
      0 => 'сегодня',
      1 => 'вчера',
      _ => '$days дн. назад',
    };
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
