import 'package:bulb/Models/campaign_model.dart';
import 'package:bulb/Models/comment_model.dart';
import 'package:bulb/Models/product_category_model.dart';
import 'package:bulb/Models/product_model.dart';
import 'package:bulb/Models/reservations_model.dart';
import 'package:bulb/Models/store_category.dart';
import 'package:bulb/Services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulb/Models/markers_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  Stream<List<MarkerModel>> getMapData(
      bool active, String cat, double distance, double lat, double long) {
    Query ref;

    if (active) {
      ref = _db
          .collection('markers')
          .where('storeCategory', arrayContains: cat)
          .where('campaignStatus', isEqualTo: 'active');
    } else {
      ref =
          _db.collection('markers').where('storeCategory', arrayContains: cat);
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
            .map((doc) => MarkerModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<CampaignModel>> getStoreCampaigns(docId) {
    return _db
        .collection('stores')
        .doc(docId)
        .collection('campaigns')
        .where('delInd', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CampaignModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<ProductModel>> getProducts(String docId, String categoryId) {
    return _db
        .collection('stores')
        .doc(docId)
        .collection('products')
        .doc(categoryId)
        .collection('alt_products')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data()))
            .toList());
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

  Stream<List<CommentModel>> getReports(String docId) {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();
    return _db
        .collection('stores')
        .doc(docId)
        .collection('reports')
        .where('reportUser', isEqualTo: _uuid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<ReservationModel>> getReservations(String docId) {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();
    return _db
        .collection('stores')
        .doc(docId)
        .collection('reservations')
        .where('reservationUser', isEqualTo: _uuid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReservationModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<StoreCategory>> getStoreCategories() {
    return _db
        .collection('categories')
        .orderBy('storeCatRow', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoreCategory.fromFirestore(doc.data()))
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

  Future getCategoryPic(categoryName) async {
    return await _db
        .collection('categories')
        .where('storeCatName', isEqualTo: categoryName)
        .get();
  }

  Future<String> saveComment(String docId, CommentModel comment) async {
    try {
      await _db
          .collection('stores')
          .doc(docId)
          .collection('reports')
          .doc(comment.reportId)
          .set(comment.toMap());
      return 'Dilek & Şikayetiniz başarıyla iletilmiştir !';
    } catch (e) {
      throw 'Dilek & Şikayetiniz iletilirken bir hata ile karşılaşıldı ! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<String> saveReservation(
      String docId, ReservationModel reservation) async {
    try {
      await _db
          .collection('stores')
          .doc(docId)
          .collection('reservations')
          .doc(reservation.reservationId)
          .set(reservation.toMap());
      return 'Rezervasyon talebiniz başarıyla iletilmiştir !';
    } catch (e) {
      throw 'Rezervasyon talebiniz iletilirken bir hata ile karşılaşıldı ! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<String> cancelReservation(String storeId, String resId) async {
    try {
      await _db
          .collection('stores')
          .doc(storeId)
          .collection('reservations')
          .doc(resId)
          .delete();
      return 'Rezervasyon talebiniz başarıyla iptal edilmiştir !';
    } catch (e) {
      throw 'Rezervasyon talebiniz iptal edilirken bir hata ile karşılaşıldı ! Lütfen daha sonra tekrar deneyeniz.';
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
}
