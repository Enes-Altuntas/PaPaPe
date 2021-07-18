import 'package:bulb/Models/position_model.dart';

class MarkerModel {
  final bool hasCampaign;
  final String storeCategory;
  final PositionModel position;
  final String storeId;

  MarkerModel({
    this.storeCategory,
    this.hasCampaign,
    this.position,
    this.storeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'storeCategory': storeCategory,
      'hasCampaign': hasCampaign,
      'position': position.toMap(),
      'storeId': storeId,
    };
  }

  MarkerModel.fromFirestore(Map<String, dynamic> firestore)
      : storeCategory = firestore['storeCategory'],
        hasCampaign = firestore['hasCampaign'],
        position = PositionModel.fromFirestore(firestore['position']),
        storeId = firestore['storeId'];
}
