class FavoriteModel {
  final String storeId;

  FavoriteModel({
    this.storeId,
  });

  FavoriteModel.fromFirestore(Map<String, dynamic> data)
      : storeId = data['storeId'];

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
    };
  }
}
