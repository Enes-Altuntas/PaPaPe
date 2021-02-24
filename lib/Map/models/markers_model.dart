class FirestoreMarkers {
  final String markerEnd;
  final String markerLatitude;
  final String markerLongtitude;
  final String markerStart;
  final String markerTitle;
  final String storeId;

  FirestoreMarkers({
    this.markerEnd,
    this.markerLatitude,
    this.markerLongtitude,
    this.markerStart,
    this.markerTitle,
    this.storeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'markerEnd': markerEnd,
      'markerLatitude': markerLatitude,
      'markerLongtitude': markerLongtitude,
      'markerStart': markerStart,
      'markerTitle': markerTitle,
      'storeId': storeId,
    };
  }

  FirestoreMarkers.fromFirestore(Map<String, dynamic> firestore)
      : markerEnd = firestore['markerEnd'],
        markerLatitude = firestore['markerLatitude'],
        markerLongtitude = firestore['markerLongtitude'],
        markerStart = firestore['markerStart'],
        markerTitle = firestore['markerTitle'],
        storeId = firestore['storeId'];
}
