class FirestoreMarkers {
  final bool hasCampaign;
  final String storeCategory;
  final double markerLatitude;
  final double markerLongtitude;
  final String markerTitle;
  final String markerId;
  final String storeId;

  FirestoreMarkers({
    this.storeCategory,
    this.hasCampaign,
    this.markerId,
    this.markerLatitude,
    this.markerLongtitude,
    this.markerTitle,
    this.storeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'storeCategory': storeCategory,
      'hasCampaign': hasCampaign,
      'markerLatitude': markerLatitude,
      'markerLongtitude': markerLongtitude,
      'markerTitle': markerTitle,
      'markerId': markerId,
      'storeId': storeId,
    };
  }

  FirestoreMarkers.fromFirestore(Map<String, dynamic> firestore)
      : storeCategory = firestore['storeCategory'],
        hasCampaign = firestore['hasCampaign'],
        markerId = firestore['markerId'],
        markerLatitude = firestore['markerLatitude'],
        markerLongtitude = firestore['markerLongtitude'],
        markerTitle = firestore['markerTitle'],
        storeId = firestore['storeId'];
}
