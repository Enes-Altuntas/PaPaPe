import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulovva/Models/markers_model.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<FirestoreMarkers>> getMapData(
      bool active, String altCat, String cat) {
    if (active == true) {
      return _db
          .collection('markers')
          .where('storeCategory', isEqualTo: cat)
          .where('storeAltCategory', isEqualTo: altCat)
          .where('hasCampaign', isEqualTo: active)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FirestoreMarkers.fromFirestore(doc.data()))
              .toList());
    } else {
      return _db
          .collection('markers')
          .where('storeCategory', isEqualTo: cat)
          .where('storeAltCategory', isEqualTo: altCat)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FirestoreMarkers.fromFirestore(doc.data()))
              .toList());
    }
  }

  Future<DocumentSnapshot> getStore(String markerId) async {
    return await _db.collection('stores').doc(markerId).get();
  }

  Future getStoreCat() async {
    return await _db.collection('categories').get();
  }

  Future getStoreAltCat(String catId) async {
    return await _db
        .collection('categories')
        .doc(catId)
        .collection('alt_categories')
        .get();
  }

  Future<QuerySnapshot> getCampaign(String storeId) async {
    String docId;
    await _db
        .collection('stores')
        .where('storeId', isEqualTo: storeId)
        .get()
        .then((value) {
      docId = value.docs[0].id;
    });

    return await _db
        .collection('stores')
        .doc(docId)
        .collection('campaigns')
        .where('campaignActive', isEqualTo: true)
        .get();
  }
}
