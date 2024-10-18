class Category {
  final int categoryId;
  final String categoryName;
  final String? description;
  final int? parentCategoryId;
  final bool isParentCategory;

  Category({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.parentCategoryId,
    required this.isParentCategory,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
      parentCategoryId: json['parentCategoryId'],
      isParentCategory: json['parentCategoryId'] == null,
    );
  }
}