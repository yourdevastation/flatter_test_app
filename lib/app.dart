import 'package:flutter/material.dart';

import 'package:flutter_test_app/core/theme/app_theme.dart';

class MiniTasksApp extends StatelessWidget {
  const MiniTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мини-задачи',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}