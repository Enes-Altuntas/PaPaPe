import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsModel {
  final String reservationDesc;
  final String reservationStatus;
  final String reservationId;
  final String reservationName;
  final String reservationPhone;
  final int reservationCount;
  final String reservationUser;
  final String reservationStore;
  final String reservationStoreName;
  final Timestamp reservationTime;

  ReservationsModel(
      {this.reservationDesc,
      // approved, rejected, canceled
      this.reservationStatus,
      this.reservationCount,
      this.reservationName,
      this.reservationPhone,
      this.reservationId,
      this.reservationUser,
      this.reservationTime,
      this.reservationStoreName,
      this.reservationStore});

  ReservationsModel.fromFirestore(Map<String, dynamic> data)
      : reservationDesc = data['reservationDesc'],
        reservationStatus = data['reservationStatus'],
        reservationCount = data['reservationCount'],
        reservationName = data['reservationName'],
        reservationPhone = data['reservationPhone'],
        reservationId = data['reservationId'],
        reservationStoreName = data['reservationStoreName'],
        reservationUser = data['reservationUser'],
        reservationTime = data['reservationTime'],
        reservationStore = data['reservationStore'];

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
      'reservationStore': reservationStore,
      'reservationStoreName': reservationStoreName,
    };
  }
}
