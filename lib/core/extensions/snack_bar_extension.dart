import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showAppSnackBar({
    required String message,
    required IconData icon,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // С action снекбар по умолчанию не скрывается сам.
          persist: false,
          action: action,
          content: Row(
            // Тег Hero у снекбара строится из toString() содержимого, а у
            // нас это всегда «Row(...)». Снекбары двух вкладок получали один
            // тег, и переход на другой экран падал. Ключ делает тег уникальным.
            key: UniqueKey(),
            children: [
              Icon(icon, color: Theme.of(this).colorScheme.onInverseSurface),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
