import 'package:bulovva/Models/campaing_model.dart';
import 'package:bulovva/Models/comments_model.dart';
import 'package:bulovva/Models/product.dart';
import 'package:bulovva/Models/product_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulovva/Models/markers_model.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  Stream<List<FirestoreMarkers>> getMapData(
      bool active, String cat, double distance, double lat, double long) {
    Query ref;

    if (active) {
      ref = _db
          .collection('markers')
          .where('storeCategory', isEqualTo: cat)
          .where('hasCampaign', isEqualTo: active);
    } else {
      ref = _db.collection('markers').where('storeCategory', isEqualTo: cat);
    }

    GeoFirePoint center = geo.point(latitude: lat, longitude: long);

    return geo
        .collection(collectionRef: ref)
        .within(
            center: center,
            radius: distance,
            field: 'position',
            strictMode: true)
        .map((snapshot) => snapshot
            .map((doc) => FirestoreMarkers.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<Campaign>> getStoreCampaigns(docId) {
    return _db
        .collection('stores')
        .doc(docId)
        .collection('campaigns')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Campaign.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<Product>> getProducts(String docId, String categoryId) {
    return _db
        .collection('stores')
        .doc(docId)
        .collection('products')
        .doc(categoryId)
        .collection('alt_products')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc.data()))
            .toList());
  }

  Future<String> saveComment(String docId, Comments comment) async {
    try {
      await _db
          .collection('stores')
          .doc(docId)
          .collection('reports')
          .doc(comment.reportId)
          .set(comment.toMap());
      return 'Görüşünüz başarıyla bildirilmiştir !';
    } catch (e) {
      throw 'Görüşünüz bildirilirken bir hata ile karşılaşıldı ! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<String> updateCounter(String docId, String campaignId,
      int campaignCounter, String campaignCode) async {
    try {
      await _db
          .collection('stores')
          .doc(docId)
          .collection('campaigns')
          .doc(campaignId)
          .update({'campaignCounter': campaignCounter});
      return "Kampanya kodunuz #$campaignCode'dir. Bu kampanya kodunu gittiğiniz işletmede ödemenizi yaparken kullanabilirsiniz !";
    } catch (e) {
      throw 'Görüşünüz bildirilirken bir hata ile karşılaşıldı ! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Stream<List<ProductCategory>> getProductCategories(String docId) {
    return _db
        .collection('stores')
        .doc(docId)
        .collection('products')
        .orderBy('categoryRow', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductCategory.fromFirestore(doc.data()))
            .toList());
  }

  Future<DocumentSnapshot> getStore(String storeId) async {
    return await _db.collection('stores').doc(storeId).get();
  }

  Future getStoreCat() async {
    return await _db
        .collection('categories')
        .orderBy('storeCatRow', descending: false)
        .get();
  }
}
