import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  final bool campaignActive;
  final String campaignDesc;
  final String campaignId;
  final String campaignKey;
  final int campaignCounter;
  final Timestamp campaignStart;
  final Timestamp campaignFinish;
  final Timestamp createdAt;

  Campaign({
    this.campaignActive,
    this.campaignDesc,
    this.campaignId,
    this.campaignKey,
    this.campaignCounter,
    this.campaignStart,
    this.campaignFinish,
    this.createdAt,
  });

  Campaign.fromFirestore(Map<String, dynamic> data)
      : campaignActive = data['campaignActive'],
        campaignDesc = data['campaignDesc'],
        campaignKey = data['campaignKey'],
        campaignId = data['campaignId'],
        campaignCounter = data['campaignCounter'],
        campaignStart = data['campaignStart'],
        campaignFinish = data['campaignFinish'],
        createdAt = data['createdAt'];

  Map<String, dynamic> toMap() {
    return {
      'campaignActive': campaignActive,
      'campaignDesc': campaignDesc,
      'campaignKey': campaignKey,
      'campaignCounter': campaignCounter,
      'campaignStart': campaignStart,
      'campaignFinish': campaignFinish,
      'createdAt': createdAt,
      'campaignId': campaignId,
    };
  }
}
