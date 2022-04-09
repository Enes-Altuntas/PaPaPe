class StoreCategory {
  final String storeCatId;
  final String storeCatName;
  final String storeCatNameEn;
  final String storeCatPicRef;
  final String storeShort;
  final String storeShortEn;
  final int storeCatRow;

  StoreCategory({
    required this.storeCatId,
    required this.storeCatName,
    required this.storeCatNameEn,
    required this.storeCatPicRef,
    required this.storeShort,
    required this.storeShortEn,
    required this.storeCatRow,
  });

  StoreCategory.fromFirestore(Map<String, dynamic> data)
      : storeCatId = data['storeCatId'],
        storeCatName = data['storeCatName'],
        storeCatNameEn = data['storeCatNameEn'],
        storeCatPicRef = data['storeCatPicRef'],
        storeShort = data['storeShort'],
        storeShortEn = data['storeShortEn'],
        storeCatRow = data['storeCatRow'];

  Map<String, dynamic> toMap() {
    return {
      'storeCatId': storeCatId,
      'storeCatName': storeCatName,
      'storeCatNameEn': storeCatName,
      'storeCatPicRef': storeCatPicRef,
      'storeShort': storeShort,
      'storeShortEn': storeShort,
      'storeCatRow': storeCatRow,
    };
  }
}
