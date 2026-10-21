import 'package:flutter/widgets.dart';

class TaskCardData {
  final String title;
  final String imageUrl;
  final IconData icon;
  final String? caption;
  final String? description;
  final bool isCompleted;

  const TaskCardData({
    required this.title,
    required this.imageUrl,
    required this.icon,
    this.caption,
    this.description,
    this.isCompleted = false,
  });
}
