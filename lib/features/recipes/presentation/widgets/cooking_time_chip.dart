import 'package:flutter/material.dart';

class CookingTimeChip extends StatelessWidget {
  const CookingTimeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.schedule, size: 16),
      label: Text(label),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
