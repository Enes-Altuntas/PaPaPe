import 'package:bulovva/services/firestore_service.dart';
import 'package:bulovva/Map/models/markers_model.dart';
import 'package:flutter/cupertino.dart';

class StoreProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _markerEnd;
  String _markerLatitude;
  String _markerLongtitude;
  String _markerStart;
  String _markerTitle;
  String _storeId;

  String get markerEnd => _markerEnd;
  String get markerLatitude => _markerLatitude;
  String get markerLongtitude => _markerLongtitude;
  String get markerStart => _markerStart;
  String get markerTitle => _markerTitle;
  String get storeId => _storeId;

  Stream<List<FirestoreMarkers>> get stores => firestoreService.getMarkers();
}
