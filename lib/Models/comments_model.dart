import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  final String reportDesc;
  final String reportTitle;
  final String reportScore;
  final String reportId;
  final Timestamp createdAt;

  Comments({
    this.reportDesc,
    this.reportTitle,
    this.reportScore,
    this.reportId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportDesc': reportDesc,
      'reportTitle': reportTitle,
      'reportScore': reportScore,
      'reportId': reportId,
      'createdAt': createdAt,
    };
  }
}
