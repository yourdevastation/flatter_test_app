enum TaskFilter {
  all('Все'),
  active('Активные'),
  completed('Завершённые'),
  favorite('Избранные');

  const TaskFilter(this.label);

  final String label;
}
