import 'package:flutter/widgets.dart';

class TaskCardData {
  final String id;
  final String title;
  final String imageUrl;
  final IconData icon;
  final String? caption;
  final String? description;
  final bool isCompleted;
  final bool isLiked;

  const TaskCardData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.icon,
    this.caption,
    this.description,
    this.isCompleted = false,
    this.isLiked = false,
  });
}
