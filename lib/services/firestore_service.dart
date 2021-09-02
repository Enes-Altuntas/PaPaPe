import 'package:bulb/Models/campaign_model.dart';
import 'package:bulb/Models/favorite_model.dart';
import 'package:bulb/Models/product_category_model.dart';
import 'package:bulb/Models/product_model.dart';
import 'package:bulb/Models/reservations_model.dart';
import 'package:bulb/Models/store_category.dart';
import 'package:bulb/Models/user_model.dart';
import 'package:bulb/Models/wishes_model.dart';
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

  Stream<List<ProductModel>> getProducts(String storeId, String categoryId) {
    return _db
        .collection('stores')
        .doc(storeId)
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

  Stream<List<WishesModel>> getReports() {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();
    return _db
        .collection('wishes')
        .where('wishUser', isEqualTo: _uuid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WishesModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<ReservationsModel>> getReservations() {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();
    return _db
        .collection('reservations')
        .where('reservationUser', isEqualTo: _uuid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReservationsModel.fromFirestore(doc.data()))
            .toList());
  }

  Future<List<StoreCategory>> getStoreCategories() {
    return _db
        .collection('categories')
        .orderBy('storeCatRow', descending: false)
        .get()
        .then((snapshot) => snapshot.docs
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

  Future getCategoryPic(String categoryName) async {
    return await _db
        .collection('categories')
        .where('storeCatName', isEqualTo: categoryName)
        .get();
  }

  Future<String> saveWish(WishesModel wish) async {
    try {
      await _db.collection('wishes').doc(wish.wishId).set(wish.toMap());
      return 'Dilek & Şikayetiniz başarıyla iletilmiştir!';
    } catch (e) {
      throw 'Dilek & Şikayetiniz iletilirken bir hata ile karşılaşıldı! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<String> saveReservation(ReservationsModel reservation) async {
    try {
      await _db
          .collection('reservations')
          .doc(reservation.reservationId)
          .set(reservation.toMap());
      return 'Rezervasyon talebiniz başarıyla iletilmiştir!';
    } catch (e) {
      throw 'Rezervasyon talebiniz iletilirken bir hata ile karşılaşıldı! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<String> cancelReservation(String resId) async {
    try {
      await _db
          .collection('reservations')
          .doc(resId)
          .update({'reservationStatus': 'canceled'});
      return 'Rezervasyon talebiniz başarıyla iptal edilmiştir!';
    } catch (e) {
      throw 'Rezervasyon talebiniz iptal edilirken bir hata ile karşılaşıldı! Lütfen daha sonra tekrar deneyeniz.';
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
          .update({'campaignCounter': campaignCounter + 1});

      return "Kampanya kodunuz #$campaignCode'dir. Bu kampanya kodunu gittiğiniz işletmede ödemenizi yaparken kullanabilirsiniz!";
    } catch (e) {
      throw 'Görüşünüz bildirilirken bir hata ile karşılaşıldı! Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<UserModel> getUser() async {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();

    try {
      return await _db
          .collection('users')
          .doc(_uuid)
          .get()
          .then((doc) => UserModel.fromFirestore(doc.data()));
    } catch (e) {
      throw 'Kullanıcı bilgileri çekilirken bir hata ile karşılaşıldı !';
    }
  }

  Future<String> manageFavorites(String storeId) async {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();

    UserModel user = await getUser();

    if (user.favorites.contains(storeId)) {
      user.favorites.remove(storeId);
    } else {
      user.favorites.add(storeId);
    }

    try {
      await _db.collection('users').doc(_uuid).set(user.toMap());

      return 'Bu işletme başarıyla favorilerinize eklendi';
    } catch (e) {
      throw 'Lütfen daha sonra tekrar deneyeniz.';
    }
  }

  Future<bool> isFavorite(String storeId) async {
    String _uuid = AuthService(FirebaseAuth.instance).getUserId();

    try {
      UserModel user = await _db
          .collection('users')
          .doc(_uuid)
          .get()
          .then((doc) => UserModel.fromFirestore(doc.data()));

      if (user.favorites.contains(storeId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
