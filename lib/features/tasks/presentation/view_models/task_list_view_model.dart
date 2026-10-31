import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_filter.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_stats.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';

class TaskListViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  TaskListViewModel(this._repository);

  List<Task> _allTasks = [];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = true;
  AppFailure? _error;

  List<Task> get tasks => _getFilteredTasks();

  TaskFilter get filter => _filter;

  bool get isLoading => _isLoading;

  AppFailure? get error => _error;

  TaskStats get stats => _calculateStats(_allTasks);

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getTasks();

    if (result.isSuccess && result.data != null) {
      _allTasks = result.data!;
    } else {
      _error = result.error ?? AppFailure.unknown;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
  }) async {
    final result = await _repository.addTask(
      title: title,
      description: description,
      priority: priority,
      category: category,
    );

    if (result.isSuccess && result.data != null) {
      // Новые задачи сверху: так же их отдаёт БД (ORDER BY created_at DESC).
      _allTasks = [result.data!, ..._allTasks];
      notifyListeners();
    }
  }

  Task? findTask(String id) =>
      _allTasks.where((task) => task.id == id).firstOrNull;

  Future<void> toggleTask(Task task) async {
    _replaceTask(await _repository.toggleTask(task.id));
  }

  Future<void> setFavorite(String id, {required bool isFavorite}) async {
    _replaceTask(await _repository.setFavorite(id, isFavorite: isFavorite));
  }

  void _replaceTask(Result<Task> result) {
    final updatedTask = result.data;

    if (result.isFailure || updatedTask == null) {
      return;
    }

    final index = _allTasks.indexWhere((item) => item.id == updatedTask.id);

    if (index != -1) {
      _allTasks[index] = updatedTask;
      notifyListeners();
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
      TaskFilter.favorite =>
        _allTasks.where((task) => task.isFavorite).toList(),
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
