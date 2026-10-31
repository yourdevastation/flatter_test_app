import 'package:flutter/widgets.dart';
import 'package:flutter_test_app/core/l10n/generated/app_locale.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';

export 'package:flutter_test_app/core/l10n/generated/app_locale.dart';

extension LocaleContextExtension on BuildContext {
  /// Строки на текущем языке: `context.l10n.tabTasks`.
  AppLocale get l10n => AppLocale.of(this);
}

extension AppFailureMessage on AppFailure {
  String message(AppLocale l10n) => switch (this) {
    AppFailure.connection => l10n.errorConnection,
    AppFailure.timeout => l10n.errorTimeout,
    AppFailure.server => l10n.errorServer,
    AppFailure.notFound => l10n.errorNotFound,
    AppFailure.storage => l10n.errorStorage,
    AppFailure.unknown => l10n.errorUnknown,
  };
}
