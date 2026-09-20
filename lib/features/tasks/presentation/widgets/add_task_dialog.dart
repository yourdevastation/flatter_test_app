import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/extensions/string_extension.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onAdd});

  final Future<void> Function(String title, TaskPriority priority) onAdd;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trimmed();

    if (title.isBlank) {
      setState(() {
        _errorText = 'Введите название задачи';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    await widget.onAdd(title, _selectedPriority);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая задача'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Название',
              hintText: 'Введите название задачи',
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          Text('Приоритет', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<TaskPriority>(
            segments: TaskPriority.values
                .map(
                  (priority) => ButtonSegment(
                    value: priority,
                    label: Text(priority.label),
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
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : () => _submit(),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Добавить'),
        ),
      ],
    );
  }
}
