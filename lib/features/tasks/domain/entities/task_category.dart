enum TaskCategory {
  study('Учёба'),
  work('Работа'),
  shopping('Покупки'),
  health('Здоровье'),
  home('Дом');

  const TaskCategory(this.label);

  final String label;
}
