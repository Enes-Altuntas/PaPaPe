import 'package:bulovva/Models/position_model.dart';

class FirestoreMarkers {
  final bool hasCampaign;
  final String storeCategory;
  final String storeAltCategory;
  final PositionMarker position;
  final String storeId;

  FirestoreMarkers({
    this.storeCategory,
    this.storeAltCategory,
    this.hasCampaign,
    this.position,
    this.storeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'storeCategory': storeCategory,
      'storeAltCategory': storeAltCategory,
      'hasCampaign': hasCampaign,
      'position': position,
      'storeId': storeId,
    };
  }

  FirestoreMarkers.fromFirestore(Map<String, dynamic> firestore)
      : storeCategory = firestore['storeCategory'],
        storeAltCategory = firestore['storeAltCategory'],
        hasCampaign = firestore['hasCampaign'],
        position = PositionMarker.fromFirestore(firestore['position']),
        storeId = firestore['storeId'];
}
