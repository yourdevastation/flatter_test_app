import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_filter.dart';

extension TaskFilterExtension on TaskFilter {
  String label(AppLocale l10n) => switch (this) {
    TaskFilter.all => l10n.filterAll,
    TaskFilter.active => l10n.filterActive,
    TaskFilter.completed => l10n.filterCompleted,
    TaskFilter.favorite => l10n.filterFavorite,
  };
}
