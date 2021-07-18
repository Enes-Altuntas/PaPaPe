import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String reservationDesc;
  final String reservationStatus;
  final String reservationId;
  final String reservationName;
  final String reservationPhone;
  final int reservationCount;
  final String reservationUser;
  final Timestamp reservationTime;

  ReservationModel({
    this.reservationDesc,
    this.reservationStatus,
    this.reservationCount,
    this.reservationName,
    this.reservationPhone,
    this.reservationId,
    this.reservationUser,
    this.reservationTime,
  });

  ReservationModel.fromFirestore(Map<String, dynamic> data)
      : reservationDesc = data['reservationDesc'],
        reservationStatus = data['reservationStatus'],
        reservationCount = data['reservationCount'],
        reservationName = data['reservationName'],
        reservationPhone = data['reservationPhone'],
        reservationId = data['reservationId'],
        reservationUser = data['reservationUser'],
        reservationTime = data['reservationTime'];

  Map<String, dynamic> toMap() {
    return {
      'reservationDesc': reservationDesc,
      'reservationStatus': reservationStatus,
      'reservationCount': reservationCount,
      'reservationName': reservationName,
      'reservationPhone': reservationPhone,
      'reservationId': reservationId,
      'reservationUser': reservationUser,
      'reservationTime': reservationTime,
    };
  }
}
