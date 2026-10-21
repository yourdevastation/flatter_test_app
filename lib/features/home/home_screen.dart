import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/recipes/data/repositories/remote_recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/presentation/screens/recipe_list_screen.dart';
import 'package:flutter_test_app/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:flutter_test_app/features/tasks/presentation/view_models/task_list_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // View model живёт здесь, а не в TaskListScreen, потому что задачи
  // добавляются и со вкладки рецептов.
  final TaskListViewModel _taskViewModel = TaskListViewModel(
    InMemoryTaskRepository(),
  );
  final RecipeRepository _recipeRepository = RemoteRecipeRepository();
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
      title: 'Приготовить: ${recipe.name}',
      description: recipe.description,
      priority: TaskPriority.medium,
      category: TaskCategory.home,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              children: [
                TaskListScreen(viewModel: _taskViewModel),
                RecipeListScreen(
                  repository: _recipeRepository,
                  onAddToTasks: _addRecipeToTasks,
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
          destinations: const [
            NavigationDestination(icon: Icon(Icons.checklist), label: 'Задачи'),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Рецепты',
            ),
          ],
        ),
      ],
    );
  }
}
