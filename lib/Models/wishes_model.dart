import 'package:cloud_firestore/cloud_firestore.dart';

class WishesModel {
  final String wishDesc;
  final String wishTitle;
  final String wishId;
  final String wishUser;
  final String? wishUserPhone;
  final Timestamp createdAt;
  final String wishStore;
  final String wishStoreName;

  WishesModel(
      {required this.wishDesc,
      required this.wishTitle,
      required this.wishId,
      required this.wishUser,
      this.wishUserPhone,
      required this.createdAt,
      required this.wishStore,
      required this.wishStoreName});

  WishesModel.fromFirestore(Map<String, dynamic> data)
      : wishDesc = data['wishDesc'],
        wishTitle = data['wishTitle'],
        wishId = data['wishId'],
        wishUser = data['wishUser'],
        wishUserPhone = data['wishUserPhone'],
        createdAt = data['createdAt'],
        wishStore = data['wishStore'],
        wishStoreName = data['wishStoreName'];

  Map<String, dynamic> toMap() {
    return {
      'wishDesc': wishDesc,
      'wishTitle': wishTitle,
      'wishId': wishId,
      'wishUser': wishUser,
      'wishUserPhone': wishUserPhone,
      'createdAt': createdAt,
      'wishStore': wishStore,
      'wishStoreName': wishStoreName,
    };
  }
}
