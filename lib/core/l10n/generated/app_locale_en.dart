// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocaleEn extends AppLocale {
  AppLocaleEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mini Tasks';

  @override
  String get tabTasks => 'Tasks';

  @override
  String get tabRecipes => 'Recipes';

  @override
  String get switchLanguage => 'Switch language';

  @override
  String get retry => 'Retry';

  @override
  String get undo => 'Undo';

  @override
  String get add => 'Add';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get errorConnection =>
      'Server is unreachable. Make sure the backend is running.';

  @override
  String get errorTimeout => 'The server is taking too long to respond.';

  @override
  String get errorServer => 'The server returned an error.';

  @override
  String get errorNotFound => 'Item not found.';

  @override
  String get errorStorage => 'Couldn\'t read or save data on the device.';

  @override
  String get errorUnknown => 'Something went wrong.';

  @override
  String get tasksHint => 'Tap a card to see the details';

  @override
  String get tasksLoadError => 'Couldn\'t load tasks';

  @override
  String get tasksEmpty => 'No tasks yet';

  @override
  String get taskNotFound => 'Task not found';

  @override
  String taskAddedToFavorites(String title) {
    return '\"$title\" added to favorites';
  }

  @override
  String taskRemovedFromFavorites(String title) {
    return '\"$title\" removed from favorites';
  }

  @override
  String get statsTotal => 'Total';

  @override
  String get statsCompleted => 'Done';

  @override
  String get statsActive => 'Active';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterFavorite => 'Favorites';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get categoryStudy => 'Study';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryHome => 'Home';

  @override
  String get newTaskTitle => 'New task';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskTitleHint => 'Enter a task title';

  @override
  String get taskTitleRequired => 'Please enter a title';

  @override
  String get taskDescriptionLabel => 'Description (optional)';

  @override
  String get categoryLabel => 'Category';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get markAsDone => 'Mark as done';

  @override
  String get markAsActive => 'Move back to active';

  @override
  String get noDescription => 'No description';

  @override
  String get createdLabel => 'Created';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusDone => 'Done';

  @override
  String get statusActive => 'In progress';

  @override
  String get favoriteLabel => 'Favorite';

  @override
  String get recipesSearchHint => 'Search by name';

  @override
  String get scrollToTop => 'Back to top';

  @override
  String get recipesLoadError => 'Couldn\'t load recipes';

  @override
  String get recipesNotFound => 'Nothing found';

  @override
  String get recipesNotFoundHint => 'Try a different search';

  @override
  String get recipesEnd => 'That\'s all the recipes';

  @override
  String get addToTasks => 'Add to tasks';

  @override
  String get addedToTasks => 'Added to tasks';

  @override
  String recipeAddedToTasks(String name) {
    return '\"$name\" added to tasks';
  }

  @override
  String recipeLiked(String name) {
    return '\"$name\" added to favorites';
  }

  @override
  String recipeUnliked(String name) {
    return '\"$name\" removed from favorites';
  }

  @override
  String cookTaskTitle(String name) {
    return 'Cook: $name';
  }

  @override
  String get authorLabel => 'Author';

  @override
  String get unknownAuthor => 'Unknown';

  @override
  String get cookingTimeLabel => 'Time';

  @override
  String get updatedLabel => 'Updated';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String hoursShort(int count) {
    return '$count h';
  }

  @override
  String hoursMinutesShort(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String minutesRangeShort(int from, int to) {
    return '$from–$to min';
  }

  @override
  String hoursRangeShort(int from, int to) {
    return '$from–$to h';
  }

  @override
  String get today => 'today';

  @override
  String get yesterday => 'yesterday';

  @override
  String daysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '$days day ago',
    );
    return '$_temp0';
  }
}
