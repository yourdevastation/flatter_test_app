import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'locale_state.g.dart';

@CopyWith()
class LocaleState extends Equatable {
  final Locale currentLocale;

  const LocaleState({required this.currentLocale});

  @override
  List<Object?> get props => [currentLocale];
}
