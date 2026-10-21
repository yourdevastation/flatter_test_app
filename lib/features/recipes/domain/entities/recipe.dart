class Recipe {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int? cookingTimeFrom;
  final int? cookingTimeTo;
  final String? authorName;
  final String? categoryName;
  final DateTime? updatedAt;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.cookingTimeFrom,
    this.cookingTimeTo,
    this.authorName,
    this.categoryName,
    this.updatedAt,
  });
}
