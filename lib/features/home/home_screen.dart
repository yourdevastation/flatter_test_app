import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_event.dart';
import 'package:flutter_test_app/features/recipes/presentation/screens/recipe_list_screen.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_test_app/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:flutter_test_app/features/tasks/presentation/view_models/task_list_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // View model живёт здесь, а не в TaskListScreen, потому что задачи
  // добавляются и со вкладки рецептов. late: context.read можно вызвать
  // только после создания State, и поле инициализируется при первом
  // обращении (в initState).
  late final TaskListViewModel _taskViewModel = TaskListViewModel(
    context.read<TaskRepository>(),
  );
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _taskViewModel.loadTasks();
  }

  @override
  void dispose() {
    _taskViewModel.dispose();
    super.dispose();
  }

  Future<void> _addRecipeToTasks(Recipe recipe) {
    return _taskViewModel.addTask(
      title: context.l10n.cookTaskTitle(recipe.name),
      description: recipe.description,
      priority: TaskPriority.medium,
      category: TaskCategory.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          // Отступ снизу (системная навигация) учитывает NavigationBar,
          // вложенным Scaffold'ам его учитывать не нужно.
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: IndexedStack(
              index: _selectedIndex,
              // У каждой вкладки свой ScaffoldMessenger. С одним общим снекбар
              // показывался в Scaffold'ах обеих вкладок сразу, и при переходе
              // на экран деталей Flutter падал: два Hero с одним тегом.
              children: [
                ScaffoldMessenger(
                  child: TaskListScreen(viewModel: _taskViewModel),
                ),
                ScaffoldMessenger(
                  child: BlocProvider<RecipeListBloc>(
                    create: (context) =>
                        RecipeListBloc(context.read<RecipeRepository>())
                          ..add(const RecipeListLoadRequested()),
                    child: RecipeListScreen(onAddToTasks: _addRecipeToTasks),
                  ),
                ),
              ],
            ),
          ),
        ),
        NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.checklist),
              label: l10n.tabTasks,
            ),
            NavigationDestination(
              icon: const Icon(Icons.restaurant_menu_outlined),
              selectedIcon: const Icon(Icons.restaurant_menu),
              label: l10n.tabRecipes,
            ),
          ],
        ),
      ],
    );
  }
}
