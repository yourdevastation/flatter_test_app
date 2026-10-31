import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_locale_en.dart';
import 'app_locale_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocale
/// returned by `AppLocale.of(context)`.
///
/// Applications need to include `AppLocale.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_locale.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocale.localizationsDelegates,
///   supportedLocales: AppLocale.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocale.supportedLocales
/// property.
abstract class AppLocale {
  AppLocale(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocale of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale)!;
  }

  static const LocalizationsDelegate<AppLocale> delegate = _AppLocaleDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мини-задачи'**
  String get appTitle;

  /// No description provided for @tabTasks.
  ///
  /// In ru, this message translates to:
  /// **'Задачи'**
  String get tabTasks;

  /// No description provided for @tabRecipes.
  ///
  /// In ru, this message translates to:
  /// **'Рецепты'**
  String get tabRecipes;

  /// No description provided for @switchLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Сменить язык'**
  String get switchLanguage;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @undo.
  ///
  /// In ru, this message translates to:
  /// **'Отменить'**
  String get undo;

  /// No description provided for @add.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In ru, this message translates to:
  /// **'Да'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get no;

  /// No description provided for @descriptionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get descriptionTitle;

  /// No description provided for @errorConnection.
  ///
  /// In ru, this message translates to:
  /// **'Сервер недоступен. Проверь, что бэкенд запущен.'**
  String get errorConnection;

  /// No description provided for @errorTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Сервер слишком долго отвечает.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In ru, this message translates to:
  /// **'Сервер ответил ошибкой.'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Запись не найдена.'**
  String get errorNotFound;

  /// No description provided for @errorStorage.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать или сохранить данные на устройстве.'**
  String get errorStorage;

  /// No description provided for @errorUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так.'**
  String get errorUnknown;

  /// No description provided for @tasksHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажми на карточку, чтобы открыть подробности'**
  String get tasksHint;

  /// No description provided for @tasksLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить задачи'**
  String get tasksLoadError;

  /// No description provided for @tasksEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Задач пока нет'**
  String get tasksEmpty;

  /// No description provided for @taskNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Задача не найдена'**
  String get taskNotFound;

  /// No description provided for @taskAddedToFavorites.
  ///
  /// In ru, this message translates to:
  /// **'«{title}» добавлена в избранное'**
  String taskAddedToFavorites(String title);

  /// No description provided for @taskRemovedFromFavorites.
  ///
  /// In ru, this message translates to:
  /// **'«{title}» убрана из избранного'**
  String taskRemovedFromFavorites(String title);

  /// No description provided for @statsTotal.
  ///
  /// In ru, this message translates to:
  /// **'Всего'**
  String get statsTotal;

  /// No description provided for @statsCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено'**
  String get statsCompleted;

  /// No description provided for @statsActive.
  ///
  /// In ru, this message translates to:
  /// **'Активно'**
  String get statsActive;

  /// No description provided for @filterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In ru, this message translates to:
  /// **'Активные'**
  String get filterActive;

  /// No description provided for @filterCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Завершённые'**
  String get filterCompleted;

  /// No description provided for @filterFavorite.
  ///
  /// In ru, this message translates to:
  /// **'Избранные'**
  String get filterFavorite;

  /// No description provided for @priorityLow.
  ///
  /// In ru, this message translates to:
  /// **'Низкий'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In ru, this message translates to:
  /// **'Средний'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In ru, this message translates to:
  /// **'Высокий'**
  String get priorityHigh;

  /// No description provided for @categoryStudy.
  ///
  /// In ru, this message translates to:
  /// **'Учёба'**
  String get categoryStudy;

  /// No description provided for @categoryWork.
  ///
  /// In ru, this message translates to:
  /// **'Работа'**
  String get categoryWork;

  /// No description provided for @categoryShopping.
  ///
  /// In ru, this message translates to:
  /// **'Покупки'**
  String get categoryShopping;

  /// No description provided for @categoryHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get categoryHealth;

  /// No description provided for @categoryHome.
  ///
  /// In ru, this message translates to:
  /// **'Дом'**
  String get categoryHome;

  /// No description provided for @newTaskTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая задача'**
  String get newTaskTitle;

  /// No description provided for @taskTitleLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In ru, this message translates to:
  /// **'Введите название задачи'**
  String get taskTitleHint;

  /// No description provided for @taskTitleRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите название задачи'**
  String get taskTitleRequired;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Описание (необязательно)'**
  String get taskDescriptionLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get categoryLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Приоритет'**
  String get priorityLabel;

  /// No description provided for @addToFavorites.
  ///
  /// In ru, this message translates to:
  /// **'В избранное'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из избранного'**
  String get removeFromFavorites;

  /// No description provided for @markAsDone.
  ///
  /// In ru, this message translates to:
  /// **'Отметить выполненной'**
  String get markAsDone;

  /// No description provided for @markAsActive.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть в работу'**
  String get markAsActive;

  /// No description provided for @noDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание не добавлено'**
  String get noDescription;

  /// No description provided for @createdLabel.
  ///
  /// In ru, this message translates to:
  /// **'Создана'**
  String get createdLabel;

  /// No description provided for @statusLabel.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get statusLabel;

  /// No description provided for @statusDone.
  ///
  /// In ru, this message translates to:
  /// **'Выполнена'**
  String get statusDone;

  /// No description provided for @statusActive.
  ///
  /// In ru, this message translates to:
  /// **'В работе'**
  String get statusActive;

  /// No description provided for @favoriteLabel.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get favoriteLabel;

  /// No description provided for @recipesSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по названию'**
  String get recipesSearchHint;

  /// No description provided for @scrollToTop.
  ///
  /// In ru, this message translates to:
  /// **'Наверх'**
  String get scrollToTop;

  /// No description provided for @recipesLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить рецепты'**
  String get recipesLoadError;

  /// No description provided for @recipesNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get recipesNotFound;

  /// No description provided for @recipesNotFoundHint.
  ///
  /// In ru, this message translates to:
  /// **'Попробуй изменить запрос'**
  String get recipesNotFoundHint;

  /// No description provided for @recipesEnd.
  ///
  /// In ru, this message translates to:
  /// **'Это все рецепты'**
  String get recipesEnd;

  /// No description provided for @addToTasks.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в задачи'**
  String get addToTasks;

  /// No description provided for @addedToTasks.
  ///
  /// In ru, this message translates to:
  /// **'Добавлено в задачи'**
  String get addedToTasks;

  /// No description provided for @recipeAddedToTasks.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» добавлен в задачи'**
  String recipeAddedToTasks(String name);

  /// No description provided for @recipeLiked.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» добавлен в избранное'**
  String recipeLiked(String name);

  /// No description provided for @recipeUnliked.
  ///
  /// In ru, this message translates to:
  /// **'«{name}» убран из избранного'**
  String recipeUnliked(String name);

  /// Название задачи, созданной из рецепта
  ///
  /// In ru, this message translates to:
  /// **'Приготовить: {name}'**
  String cookTaskTitle(String name);

  /// No description provided for @authorLabel.
  ///
  /// In ru, this message translates to:
  /// **'Автор'**
  String get authorLabel;

  /// No description provided for @unknownAuthor.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестен'**
  String get unknownAuthor;

  /// No description provided for @cookingTimeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get cookingTimeLabel;

  /// No description provided for @updatedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Обновлён'**
  String get updatedLabel;

  /// No description provided for @minutesShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} мин'**
  String minutesShort(int count);

  /// No description provided for @hoursShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} ч'**
  String hoursShort(int count);

  /// No description provided for @hoursMinutesShort.
  ///
  /// In ru, this message translates to:
  /// **'{hours} ч {minutes} мин'**
  String hoursMinutesShort(int hours, int minutes);

  /// No description provided for @minutesRangeShort.
  ///
  /// In ru, this message translates to:
  /// **'{from}–{to} мин'**
  String minutesRangeShort(int from, int to);

  /// No description provided for @hoursRangeShort.
  ///
  /// In ru, this message translates to:
  /// **'{from}–{to} ч'**
  String hoursRangeShort(int from, int to);

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'сегодня'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In ru, this message translates to:
  /// **'вчера'**
  String get yesterday;

  /// Русский различает формы one (21 день), few (2 дня), many (5 дней)
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{{days} день назад} few{{days} дня назад} many{{days} дней назад} other{{days} дня назад}}'**
  String daysAgo(int days);
}

class _AppLocaleDelegate extends LocalizationsDelegate<AppLocale> {
  const _AppLocaleDelegate();

  @override
  Future<AppLocale> load(Locale locale) {
    return SynchronousFuture<AppLocale>(lookupAppLocale(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocaleDelegate old) => false;
}

AppLocale lookupAppLocale(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocaleEn();
    case 'ru':
      return AppLocaleRu();
  }

  throw FlutterError(
    'AppLocale.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
