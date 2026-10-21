import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/extensions/date_time_extension.dart';
import 'package:flutter_test_app/core/extensions/task_category_extension.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/presentation/view_models/task_list_view_model.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/like_icon.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/priority_chip.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/task_image.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.viewModel,
    required this.onLike,
  });

  final String taskId;
  final TaskListViewModel viewModel;
  final OnLikeCallback onLike;

  @override
  Widget build(BuildContext context) {
    // Слушаем общую view model, чтобы лайк и статус, изменённые здесь,
    // сразу отражались и на этом экране, и в списке.
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final task = viewModel.findTask(taskId);

        if (task == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Задача не найдена')),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                leading: const _AppBarCircle(child: BackButton()),
                actions: [
                  _AppBarCircle(
                    child: IconButton(
                      tooltip: task.isFavorite
                          ? 'Убрать из избранного'
                          : 'В избранное',
                      onPressed: () =>
                          onLike(task.id, task.title, !task.isFavorite),
                      icon: LikeIcon(isLiked: task.isFavorite),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: TaskImage(
                    url: task.category.imageUrl,
                    heroTag: taskImageHeroTag(task.id),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _TaskDetails(task: task)),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: () => viewModel.toggleTask(task),
              icon: Icon(task.isCompleted ? Icons.replay : Icons.check),
              label: Text(
                task.isCompleted ? 'Вернуть в работу' : 'Отметить выполненной',
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppBarCircle extends StatelessWidget {
  const _AppBarCircle({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}

class _TaskDetails extends StatelessWidget {
  const _TaskDetails({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final description = task.description;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: Icon(task.category.icon, size: 18),
                label: Text(task.category.label),
                side: BorderSide.none,
              ),
              PriorityChip(priority: task.priority),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 20),
          Text('Описание', style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(
            description ?? 'Описание не добавлено',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: description == null ? colorScheme.outline : null,
              fontStyle: description == null ? FontStyle.italic : null,
            ),
          ),
          const SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.event_outlined,
                  label: 'Создана',
                  value:
                      '${task.createdAt.toShortDate()} · '
                      '${task.createdAt.toRelativeDay()}',
                ),
                const Divider(height: 1, indent: 56),
                _InfoRow(
                  icon: task.isCompleted
                      ? Icons.check_circle_outline
                      : Icons.timelapse,
                  label: 'Статус',
                  value: task.isCompleted ? 'Выполнена' : 'В работе',
                ),
                const Divider(height: 1, indent: 56),
                _InfoRow(
                  icon: task.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: 'Избранное',
                  value: task.isFavorite ? 'Да' : 'Нет',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
