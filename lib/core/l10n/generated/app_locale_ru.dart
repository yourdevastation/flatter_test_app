// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Мини-задачи';

  @override
  String get tabTasks => 'Задачи';

  @override
  String get tabRecipes => 'Рецепты';

  @override
  String get switchLanguage => 'Сменить язык';

  @override
  String get retry => 'Повторить';

  @override
  String get undo => 'Отменить';

  @override
  String get add => 'Добавить';

  @override
  String get cancel => 'Отмена';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get descriptionTitle => 'Описание';

  @override
  String get errorConnection =>
      'Сервер недоступен. Проверь, что бэкенд запущен.';

  @override
  String get errorTimeout => 'Сервер слишком долго отвечает.';

  @override
  String get errorServer => 'Сервер ответил ошибкой.';

  @override
  String get errorNotFound => 'Запись не найдена.';

  @override
  String get errorStorage =>
      'Не удалось прочитать или сохранить данные на устройстве.';

  @override
  String get errorUnknown => 'Что-то пошло не так.';

  @override
  String get tasksHint => 'Нажми на карточку, чтобы открыть подробности';

  @override
  String get tasksLoadError => 'Не удалось загрузить задачи';

  @override
  String get tasksEmpty => 'Задач пока нет';

  @override
  String get taskNotFound => 'Задача не найдена';

  @override
  String taskAddedToFavorites(String title) {
    return '«$title» добавлена в избранное';
  }

  @override
  String taskRemovedFromFavorites(String title) {
    return '«$title» убрана из избранного';
  }

  @override
  String get statsTotal => 'Всего';

  @override
  String get statsCompleted => 'Выполнено';

  @override
  String get statsActive => 'Активно';

  @override
  String get filterAll => 'Все';

  @override
  String get filterActive => 'Активные';

  @override
  String get filterCompleted => 'Завершённые';

  @override
  String get filterFavorite => 'Избранные';

  @override
  String get priorityLow => 'Низкий';

  @override
  String get priorityMedium => 'Средний';

  @override
  String get priorityHigh => 'Высокий';

  @override
  String get categoryStudy => 'Учёба';

  @override
  String get categoryWork => 'Работа';

  @override
  String get categoryShopping => 'Покупки';

  @override
  String get categoryHealth => 'Здоровье';

  @override
  String get categoryHome => 'Дом';

  @override
  String get newTaskTitle => 'Новая задача';

  @override
  String get taskTitleLabel => 'Название';

  @override
  String get taskTitleHint => 'Введите название задачи';

  @override
  String get taskTitleRequired => 'Введите название задачи';

  @override
  String get taskDescriptionLabel => 'Описание (необязательно)';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get priorityLabel => 'Приоритет';

  @override
  String get addToFavorites => 'В избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String get markAsDone => 'Отметить выполненной';

  @override
  String get markAsActive => 'Вернуть в работу';

  @override
  String get noDescription => 'Описание не добавлено';

  @override
  String get createdLabel => 'Создана';

  @override
  String get statusLabel => 'Статус';

  @override
  String get statusDone => 'Выполнена';

  @override
  String get statusActive => 'В работе';

  @override
  String get favoriteLabel => 'Избранное';

  @override
  String get recipesSearchHint => 'Поиск по названию';

  @override
  String get scrollToTop => 'Наверх';

  @override
  String get recipesLoadError => 'Не удалось загрузить рецепты';

  @override
  String get recipesNotFound => 'Ничего не найдено';

  @override
  String get recipesNotFoundHint => 'Попробуй изменить запрос';

  @override
  String get recipesEnd => 'Это все рецепты';

  @override
  String get addToTasks => 'Добавить в задачи';

  @override
  String get addedToTasks => 'Добавлено в задачи';

  @override
  String recipeAddedToTasks(String name) {
    return '«$name» добавлен в задачи';
  }

  @override
  String recipeLiked(String name) {
    return '«$name» добавлен в избранное';
  }

  @override
  String recipeUnliked(String name) {
    return '«$name» убран из избранного';
  }

  @override
  String cookTaskTitle(String name) {
    return 'Приготовить: $name';
  }

  @override
  String get authorLabel => 'Автор';

  @override
  String get unknownAuthor => 'Неизвестен';

  @override
  String get cookingTimeLabel => 'Время';

  @override
  String get updatedLabel => 'Обновлён';

  @override
  String minutesShort(int count) {
    return '$count мин';
  }

  @override
  String hoursShort(int count) {
    return '$count ч';
  }

  @override
  String hoursMinutesShort(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String minutesRangeShort(int from, int to) {
    return '$from–$to мин';
  }

  @override
  String hoursRangeShort(int from, int to) {
    return '$from–$to ч';
  }

  @override
  String get today => 'сегодня';

  @override
  String get yesterday => 'вчера';

  @override
  String daysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня назад',
      many: '$days дней назад',
      few: '$days дня назад',
      one: '$days день назад',
    );
    return '$_temp0';
  }
}
