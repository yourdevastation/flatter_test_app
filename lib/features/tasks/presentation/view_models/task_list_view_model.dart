import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_filter.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_stats.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';

class TaskListViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  TaskListViewModel(this._repository);

  List<Task> _allTasks = [];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = true;
  String? _error;

  List<Task> get tasks => _getFilteredTasks();

  TaskFilter get filter => _filter;

  bool get isLoading => _isLoading;

  String? get error => _error;

  TaskStats get stats => _calculateStats(_allTasks);

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getTasks();

    if (result.isSuccess && result.data != null) {
      _allTasks = result.data!;
    } else {
      _error = result.error ?? 'Неизвестная ошибка';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, TaskPriority priority) async {
    final result = await _repository.addTask(title, priority);

    if (result.isSuccess && result.data != null) {
      _allTasks = [..._allTasks, result.data!];
      notifyListeners();
    }
  }

  Future<void> toggleTask(Task task) async {
    final result = await _repository.toggleTask(task.id);

    if (result.isSuccess && result.data != null) {
      final index = _allTasks.indexWhere((item) => item.id == task.id);

      if (index != -1) {
        _allTasks[index] = result.data!;
        notifyListeners();
      }
    }
  }

  void setFilter(TaskFilter filter) {
    if (_filter == filter) {
      return;
    }

    _filter = filter;
    notifyListeners();
  }

  List<Task> _getFilteredTasks() {
    return switch (_filter) {
      TaskFilter.all => List<Task>.from(_allTasks),
      TaskFilter.active =>
        _allTasks.where((task) => !task.isCompleted).toList(),
      TaskFilter.completed =>
        _allTasks.where((task) => task.isCompleted).toList(),
    };
  }

  TaskStats _calculateStats(List<Task> tasks) {
    var completedCount = 0;

    for (final task in tasks) {
      if (task.isCompleted) {
        completedCount++;
      }
    }

    return TaskStats(total: tasks.length, completed: completedCount);
  }
}
