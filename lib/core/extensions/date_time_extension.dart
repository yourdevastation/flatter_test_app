import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 31.10.2026 по-русски, 10/31/2026 по-английски.
  String toShortDate(AppLocale l10n) =>
      DateFormat.yMd(l10n.localeName).format(this);

  String toRelativeDay(AppLocale l10n) {
    final today = DateTime.now();
    final days = DateTime(
      today.year,
      today.month,
      today.day,
    ).difference(DateTime(year, month, day)).inDays;

    return switch (days) {
      0 => l10n.today,
      1 => l10n.yesterday,
      _ => l10n.daysAgo(days),
    };
  }
}
