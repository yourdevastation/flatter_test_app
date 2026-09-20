import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/theme/app_theme.dart';
import 'package:flutter_test_app/features/tasks/presentation/screens/task_list_screen.dart';

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
      home: const TaskListScreen(),
    );
  }
}
