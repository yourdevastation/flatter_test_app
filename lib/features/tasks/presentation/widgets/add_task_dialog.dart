import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/extensions/task_priority_extension.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/extensions/string_extension.dart';
import 'package:flutter_test_app/core/extensions/task_category_extension.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onAdd});

  final Future<void> Function({
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
  })
  onAdd;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskCategory _selectedCategory = TaskCategory.study;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trimmed();
    final description = _descriptionController.text.trimmed();

    if (title.isBlank) {
      setState(() {
        _errorText = context.l10n.taskTitleRequired;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    await widget.onAdd(
      title: title,
      description: description.isBlank ? null : description,
      priority: _selectedPriority,
      category: _selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelStyle = Theme.of(context).textTheme.labelLarge;

    return AlertDialog(
      title: Text(l10n.newTaskTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.taskTitleLabel,
                hintText: l10n.taskTitleHint,
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.taskDescriptionLabel,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Text(l10n.categoryLabel, style: labelStyle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TaskCategory.values
                  .map(
                    (category) => ChoiceChip(
                      avatar: Icon(category.icon),
                      label: Text(category.label(l10n)),
                      selected: category == _selectedCategory,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(l10n.priorityLabel, style: labelStyle),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: TaskPriority.values
                  .map(
                    (priority) => ButtonSegment(
                      value: priority,
                      label: Text(priority.label(l10n)),
                    ),
                  )
                  .toList(),
              selected: {_selectedPriority},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedPriority = selection.first;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : () => _submit(),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.add),
        ),
      ],
    );
  }
}
