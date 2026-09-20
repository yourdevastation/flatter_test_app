class TaskStats {
  final int total;
  final int completed;

  const TaskStats({
    required this.total,
    required this.completed,
  });

  int get active => total - completed;
}