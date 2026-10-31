import 'package:flutter/material.dart';

import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';

extension TaskCategoryExtension on TaskCategory {
  IconData get icon => switch (this) {
    TaskCategory.study => Icons.school_outlined,
    TaskCategory.work => Icons.work_outline,
    TaskCategory.shopping => Icons.shopping_cart_outlined,
    TaskCategory.health => Icons.fitness_center,
    TaskCategory.home => Icons.home_outlined,
  };

  String get imageUrl => switch (this) {
    TaskCategory.study => _unsplash('1434030216411-0b793f4b4173'),
    TaskCategory.work => _unsplash('1497032628192-86f99bcd76bc'),
    TaskCategory.shopping => _unsplash('1542838132-92c53300491e'),
    TaskCategory.health => _unsplash('1571019613454-1cb2f99b2d8b'),
    TaskCategory.home => _unsplash('1484154218962-a197022b5858'),
  };

  String label(AppLocale l10n) => switch (this) {
    TaskCategory.study => l10n.categoryStudy,
    TaskCategory.work => l10n.categoryWork,
    TaskCategory.shopping => l10n.categoryShopping,
    TaskCategory.health => l10n.categoryHealth,
    TaskCategory.home => l10n.categoryHome,
  };
}

String _unsplash(String photoId) =>
    'https://images.unsplash.com/photo-$photoId?w=800&q=70&auto=format&fit=crop';
