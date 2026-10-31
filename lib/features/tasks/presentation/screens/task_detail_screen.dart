import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/extensions/date_time_extension.dart';
import 'package:flutter_test_app/core/extensions/task_category_extension.dart';
import 'package:flutter_test_app/core/widgets/app_bar_circle.dart';
import 'package:flutter_test_app/core/widgets/card_image.dart';
import 'package:flutter_test_app/core/widgets/content_card.dart';
import 'package:flutter_test_app/core/widgets/info_section.dart';
import 'package:flutter_test_app/core/widgets/like_icon.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/presentation/view_models/task_list_view_model.dart';
import 'package:flutter_test_app/features/tasks/presentation/widgets/priority_chip.dart';

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
            body: Center(child: Text(context.l10n.taskNotFound)),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                leading: const AppBarCircle(child: BackButton()),
                actions: [
                  AppBarCircle(
                    child: IconButton(
                      tooltip: task.isFavorite
                          ? context.l10n.removeFromFavorites
                          : context.l10n.addToFavorites,
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
                  background: CardImage(
                    url: task.category.imageUrl,
                    heroTag: cardImageHeroTag(task.id),
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
                task.isCompleted
                    ? context.l10n.markAsActive
                    : context.l10n.markAsDone,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TaskDetails extends StatelessWidget {
  const _TaskDetails({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                label: Text(task.category.label(l10n)),
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
          Text(l10n.descriptionTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(
            description ?? l10n.noDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: description == null ? colorScheme.outline : null,
              fontStyle: description == null ? FontStyle.italic : null,
            ),
          ),
          const SizedBox(height: 24),
          InfoSection(
            rows: [
              InfoRow(
                icon: Icons.event_outlined,
                label: l10n.createdLabel,
                value:
                    '${task.createdAt.toShortDate(l10n)} · '
                    '${task.createdAt.toRelativeDay(l10n)}',
              ),
              InfoRow(
                icon: task.isCompleted
                    ? Icons.check_circle_outline
                    : Icons.timelapse,
                label: l10n.statusLabel,
                value: task.isCompleted ? l10n.statusDone : l10n.statusActive,
              ),
              InfoRow(
                icon: task.isFavorite ? Icons.favorite : Icons.favorite_border,
                label: l10n.favoriteLabel,
                value: task.isFavorite ? l10n.yes : l10n.no,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
