class StoreCategory {
  final String storeCatId;
  final String storeCatName;
  final String storeCatPicRef;
  final int storeCatRow;

  StoreCategory({
    this.storeCatId,
    this.storeCatName,
    this.storeCatPicRef,
    this.storeCatRow,
  });

  StoreCategory.fromFirestore(Map<String, dynamic> data)
      : storeCatId = data['storeCatId'],
        storeCatName = data['storeCatName'],
        storeCatPicRef = data['storeCatPicRef'],
        storeCatRow = data['storeCatRow'];

  Map<String, dynamic> toMap() {
    return {
      'storeCatId': storeCatId,
      'storeCatName': storeCatName,
      'storeCatPicRef': storeCatPicRef,
      'storeCatRow': storeCatRow,
    };
  }
}
