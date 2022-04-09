import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignUserModel {
  final String userId;
  final String campaignId;
  final String storeId;
  final String userName;
  final String? scannedByName;
  final String? scannedById;
  final Timestamp? scannedAt;
  final bool scanned;

  CampaignUserModel({
    required this.userId,
    required this.campaignId,
    required this.storeId,
    required this.userName,
    this.scannedByName,
    this.scannedById,
    this.scannedAt,
    required this.scanned,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'campaignId': campaignId,
      'storeId': storeId,
      'userName': userName,
      'scannedByName': scannedByName,
      'scannedById': scannedById,
      'scannedAt': scannedAt,
      'scanned': scanned
    };
  }

  CampaignUserModel.fromFirestore(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        campaignId = firestore['campaignId'],
        storeId = firestore['storeId'],
        userName = firestore['userName'],
        scannedByName = firestore['scannedByName'],
        scannedById = firestore['scannedById'],
        scannedAt = firestore['scannedAt'],
        scanned = firestore['scanned'];
}
