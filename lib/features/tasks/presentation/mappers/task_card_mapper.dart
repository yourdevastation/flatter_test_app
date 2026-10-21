import 'package:flutter_test_app/core/extensions/task_category_extension.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/core/widgets/content_card_data.dart';

extension TaskCardMapper on Task {
  ContentCardData toCardData() => ContentCardData(
    id: id,
    title: title,
    imageUrl: category.imageUrl,
    icon: category.icon,
    caption: category.label,
    description: description,
    isCompleted: isCompleted,
    isLiked: isFavorite,
  );
}
