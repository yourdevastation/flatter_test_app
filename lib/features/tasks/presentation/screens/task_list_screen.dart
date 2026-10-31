import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/settings/presentation/widgets/locale_switch_button.dart';
import 'package:flutter_test_app/core/extensions/task_filter_extension.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/extensions/snack_bar_extension.dart';
import 'package:flutter_test_app/core/widgets/content_card.dart';
import 'package:flutter_test_app/core/widgets/status_view.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_filter.dart';
import 'package:flutter_test_app/features/tasks/presentation/mappers/task_card_mapper.dart';
import 'package:flutter_test_app/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:flutter_test_app/features/tasks/presentation/view_models/task_list_view_model.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/add_task_dialog.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/priority_chip.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/stats_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.viewModel});

  final TaskListViewModel viewModel;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskListViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();

    // В initState ещё нельзя обращаться к ScaffoldMessenger через context:
    // дерево не построено. Поэтому откладываем показ до конца первого кадра.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar(
        message: context.l10n.tasksHint,
        icon: Icons.touch_app_outlined,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LocaleSwitchButton()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final error = _viewModel.error;

          if (error != null) {
            return StatusView(
              icon: Icons.error_outline,
              title: l10n.tasksLoadError,
              message: error.message(l10n),
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
                    ? StatusView(
                        icon: Icons.check_circle_outline,
                        title: l10n.tasksEmpty,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return ContentCard.fromData(
                            task.toCardData(l10n),
                            key: ValueKey(task.id),
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (_) => _viewModel.toggleTask(task),
                            ),
                            trailing: PriorityChip(priority: task.priority),
                            onTap: () => _openDetails(task),
                            onLike: _likeHandler(context),
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

  /// Снекбар показываем там, откуда лайкнули: со списка — во вкладке,
  /// с экрана деталей — на нём самом ([snackBarContext] — контекст экрана).
  OnLikeCallback _likeHandler(BuildContext snackBarContext) {
    return (id, title, isLiked) {
      final l10n = snackBarContext.l10n;
      _viewModel.setFavorite(id, isFavorite: isLiked);

      snackBarContext.showAppSnackBar(
        message: isLiked
            ? l10n.taskAddedToFavorites(title)
            : l10n.taskRemovedFromFavorites(title),
        icon: isLiked ? Icons.favorite : Icons.heart_broken_outlined,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => _viewModel.setFavorite(id, isFavorite: !isLiked),
        ),
      );
    };
  }

  void _showSnackBar({
    required String message,
    required IconData icon,
    SnackBarAction? action,
  }) {
    context.showAppSnackBar(message: message, icon: icon, action: action);
  }

  void _openDetails(Task task) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (routeContext) => TaskDetailScreen(
          taskId: task.id,
          viewModel: _viewModel,
          onLike: _likeHandler(routeContext),
        ),
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AddTaskDialog(
          onAdd:
              ({
                required title,
                description,
                required priority,
                required category,
              }) async {
                await _viewModel.addTask(
                  title: title,
                  description: description,
                  priority: priority,
                  category: category,
                );

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
                label: Text(filter.label(context.l10n)),
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
