import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_filter.dart';
import 'package:flutter_test_app/features/tasks/presentation/view_models/task_list_view_model.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/add_task_dialog.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/stats_card.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TaskListViewModel(InMemoryTaskRepository());
    _viewModel.loadTasks();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мини-задачи')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.error != null) {
            return _ErrorState(
              message: _viewModel.error!,
              onRetry: () => _viewModel.loadTasks(),
            );
          }

          final tasks = _viewModel.tasks;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatsCard(stats: _viewModel.stats),
              ),
              _FilterChips(
                selectedFilter: _viewModel.filter,
                onFilterSelected: (filter) => _viewModel.setFilter(filter),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return TaskTile(
                            task: task,
                            onToggle: () => _viewModel.toggleTask(task),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AddTaskDialog(
          onAdd: (title, priority) async {
            await _viewModel.addTask(title, priority);

            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          },
        );
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final TaskFilter selectedFilter;
  final ValueChanged<TaskFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TaskFilter.values.map((filter) {
            final isSelected = filter == selectedFilter;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) => onFilterSelected(filter),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('Задач пока нет', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Повторить')),
        ],
      ),
    );
  }
}
