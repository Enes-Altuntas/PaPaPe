import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulovva/Map/models/markers_model.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<FirestoreMarkers>> getMarkers() {
    return _db.collection('markers').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => FirestoreMarkers.fromFirestore(doc.data()))
        .toList());
  }
}
