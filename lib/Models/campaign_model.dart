import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  // inactive , wait, active
  final String campaignStatus;
  String? campaignPicRef;
  final bool? automatedStart;
  final bool? automatedStop;
  final bool? delInd;
  final String campaignDesc;
  final String? campaignDescEn;
  final String campaignId;
  final String campaignTitle;
  final String? campaignTitleEn;
  final int? campaignCounter;
  final Timestamp campaignStart;
  final Timestamp campaignFinish;
  final Timestamp createdAt;
  File? campaignLocalImage;

  CampaignModel(
      {required this.campaignStatus,
      this.campaignPicRef,
      this.automatedStart,
      this.automatedStop,
      this.delInd,
      required this.campaignDesc,
      this.campaignDescEn,
      required this.campaignId,
      required this.campaignTitle,
      this.campaignTitleEn,
      this.campaignCounter,
      required this.campaignStart,
      required this.campaignFinish,
      required this.createdAt,
      this.campaignLocalImage});

  CampaignModel.fromFirestore(Map<String, dynamic> data)
      : campaignStatus = data['campaignStatus'],
        automatedStart = data['automatedStart'],
        campaignPicRef = data['campaignPicRef'],
        delInd = data['delInd'],
        automatedStop = data['automatedStop'],
        campaignDesc = data['campaignDesc'],
        campaignDescEn = data['campaignDescEn'],
        campaignTitle = data['campaignTitle'],
        campaignTitleEn = data['campaignTitleEn'],
        campaignCounter = data['campaignCounter'],
        campaignId = data['campaignId'],
        campaignStart = data['campaignStart'],
        campaignFinish = data['campaignFinish'],
        createdAt = data['createdAt'];

  Map<String, dynamic> toMap() {
    return {
      'campaignStatus': campaignStatus,
      'automatedStart': automatedStart,
      'campaignPicRef': campaignPicRef,
      'delInd': delInd,
      'automatedStop': automatedStop,
      'campaignDesc': campaignDesc,
      'campaignDescEn': campaignDescEn,
      'campaignTitle': campaignTitle,
      'campaignTitleEn': campaignTitleEn,
      'campaignStart': campaignStart,
      'campaignCounter': campaignCounter,
      'campaignFinish': campaignFinish,
      'createdAt': createdAt,
      'campaignId': campaignId,
    };
  }
}
