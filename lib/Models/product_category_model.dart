class ProductCategory {
  final String categoryId;
  final String categoryName;
  final String? categoryNameEn;
  final int categoryRow;

  ProductCategory({
    required this.categoryId,
    required this.categoryName,
    this.categoryNameEn,
    required this.categoryRow,
  });

  ProductCategory.fromFirestore(Map<String, dynamic>? data)
      : categoryId = data!['categoryId'],
        categoryName = data['categoryName'],
        categoryNameEn = data['categoryNameEn'],
        categoryRow = data['categoryRow'];

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryNameEn': categoryNameEn,
      'categoryRow': categoryRow,
    };
  }
}
