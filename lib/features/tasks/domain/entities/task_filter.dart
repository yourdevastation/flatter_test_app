enum TaskFilter {
  all('Все'),
  active('Активные'),
  completed('Завершённые');

  const TaskFilter(this.label);

  final String label;
}