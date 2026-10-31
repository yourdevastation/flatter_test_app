import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/resources/svg_objects.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_bloc.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_event.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_state.dart';

/// Флаг текущего языка в AppBar; нажатие переключает язык.
class LocaleSwitchButton extends StatelessWidget {
  const LocaleSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.switchLanguage,
      onPressed: () => context.read<LocaleBloc>().add(const LocaleToggled()),
      icon: SizedBox.square(
        dimension: 28,
        child: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: state.currentLocale.languageCode == 'ru'
                ? const SvgRu(key: ValueKey('ru'))
                : const SvgGb(key: ValueKey('en')),
          ),
        ),
      ),
    );
  }
}
