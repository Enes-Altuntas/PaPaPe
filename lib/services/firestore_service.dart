import 'package:myrest/Models/campaign_model.dart';
import 'package:myrest/Models/campaign_users_model.dart';
import 'package:myrest/Models/product_category_model.dart';
import 'package:myrest/Models/product_model.dart';
import 'package:myrest/Models/reservations_model.dart';
import 'package:myrest/Models/store_category.dart';
import 'package:myrest/Models/store_model.dart';
import 'package:myrest/Models/user_model.dart';
import 'package:myrest/Models/wishes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myrest/Models/markers_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Constants/db_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Geoflutterfire geo = Geoflutterfire();

  // *************************************************************************** User İşlemleri
  // *************************************************************************** User İşlemleri
  // *************************************************************************** User İşlemleri

  Stream<UserModel> userInformation() {
    return _db
        .collection(DataBaseConstants.userTable)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((value) {
      return UserModel.fromFirestore(value.data());
    });
  }

  saveUser(String name) async {
    UserModel? user = await _db
        .collection(DataBaseConstants.userTable)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        return UserModel.fromFirestore(value.data());
      }
      return null;
    });

    if (user == null) {
      UserModel newUser = UserModel(
          name: name,
          token: await FirebaseMessaging.instance.getToken(),
          iToken: null,
          userId: FirebaseAuth.instance.currentUser!.uid,
          favorites: [],
          storeId: null,
          campaignCodes: [],
          roles: []);

      newUser.roles.add("basic");

      await _db
          .collection(DataBaseConstants.userTable)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(newUser.toMap());
    } else {
      if (!user.roles.contains("basic")) {
        user.roles.add("basic");

        String? token = await FirebaseMessaging.instance.getToken();

        await _db
            .collection(DataBaseConstants.userTable)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'roles': user.roles, 'token': token});
      }
    }
  }

  // *************************************************************************** Harita İşlemleri
  // *************************************************************************** Harita İşlemleri
  // *************************************************************************** Harita İşlemleri

  Stream<List<MarkerModel>> getMapData(
      bool active, String cat, double distance, double lat, double long) {
    Query ref;

    if (active) {
      ref = _db
          .collection(DataBaseConstants.markerTable)
          .where('storeCategory', arrayContains: cat)
          .where('campaignStatus', isEqualTo: 'active');
    } else {
      ref =
          _db.collection('markers').where('storeCategory', arrayContains: cat);
    }

    GeoFirePoint center = geo.point(latitude: lat, longitude: long);

    return geo
        .collection(collectionRef: ref as Query<Map<String, dynamic>>)
        .within(
            center: center,
            radius: distance,
            field: 'position',
            strictMode: true)
        .map((snapshot) => snapshot
            .map((doc) =>
                MarkerModel.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // *************************************************************************** Ürün İşlemleri
  // *************************************************************************** Ürün İşlemleri
  // *************************************************************************** Ürün İşlemleri

  Stream<List<ProductModel>> getProducts(String storeId, String categoryId) {
    return _db
        .collection(DataBaseConstants.storesTable)
        .doc(storeId)
        .collection(DataBaseConstants.productsTable)
        .doc(categoryId)
        .collection(DataBaseConstants.altProductsTable)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<ProductCategory>> getProductCategories(String docId) {
    return _db
        .collection(DataBaseConstants.storesTable)
        .doc(docId)
        .collection(DataBaseConstants.productsTable)
        .orderBy('categoryRow', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductCategory.fromFirestore(doc.data()))
            .toList());
  }

  // *************************************************************************** Kullanıcı İşlemleri
  // *************************************************************************** Kullanıcı İşlemleri
  // *************************************************************************** Kullanıcı İşlemleri

  Stream<UserModel> getUserDetail() {
    String _uuid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection(DataBaseConstants.userTable)
        .doc(_uuid)
        .snapshots()
        .map((doc) => UserModel.fromFirestore(doc.data()));
  }

  // *************************************************************************** İşletme İşlemleri
  // *************************************************************************** İşletme İşlemleri
  // *************************************************************************** İşletme İşlemleri

  Future<DocumentSnapshot<Map<String, dynamic>>> getStore(
      String storeId) async {
    return await _db
        .collection(DataBaseConstants.storesTable)
        .doc(storeId)
        .get();
  }

  Future<StoreModel> getStoreData(String storeId) async {
    return await _db
        .collection(DataBaseConstants.storesTable)
        .doc(storeId)
        .get()
        .then((value) {
      return StoreModel.fromFirestore(value.data());
    });
  }

  // *************************************************************************** Kategori İşlemleri
  // *************************************************************************** Kategori İşlemleri
  // *************************************************************************** Kategori İşlemleri

  Future getCategoryPic(String categoryName) async {
    return await _db
        .collection(DataBaseConstants.categoriesTable)
        .where('storeCatName', isEqualTo: categoryName)
        .get();
  }

  Future<List<StoreCategory>> getStoreCategories() {
    return _db
        .collection(DataBaseConstants.categoriesTable)
        .orderBy('storeCatRow', descending: false)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => StoreCategory.fromFirestore(doc.data()))
            .toList());
  }

  Future getStoreCat() async {
    return await _db
        .collection(DataBaseConstants.categoriesTable)
        .orderBy('storeCatRow', descending: false)
        .get();
  }

  // *************************************************************************** Dilek Şikayet İşlemleri
  // *************************************************************************** Dilek Şikayet İşlemleri
  // *************************************************************************** Dilek Şikayet İşlemleri

  Stream<List<WishesModel>> getReports(String storeId) {
    String _uuid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection(DataBaseConstants.wishesTable)
        .where('wishUser', isEqualTo: _uuid)
        .where('wishStore', isEqualTo: storeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WishesModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<WishesModel>> getMyWishes() {
    String _uuid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection(DataBaseConstants.wishesTable)
        .where('wishUser', isEqualTo: _uuid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WishesModel.fromFirestore(doc.data()))
            .toList());
  }

  Future<String> saveWish(WishesModel wish, BuildContext _context) async {
    try {
      await _db
          .collection(DataBaseConstants.wishesTable)
          .doc(wish.wishId)
          .set(wish.toMap());
      return AppLocalizations.of(_context)!.wishSendComplete;
    } catch (e) {
      throw AppLocalizations.of(_context)!.wishSendError;
    }
  }

  // *************************************************************************** Rezervasyon İşlemleri
  // *************************************************************************** Rezervasyon İşlemleri
  // *************************************************************************** Rezervasyon İşlemleri

  Stream<List<ReservationsModel>> getReservations(String storeId) {
    String _uuid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection(DataBaseConstants.reservationsTable)
        .where('reservationUser', isEqualTo: _uuid)
        .where('reservationStore', isEqualTo: storeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReservationsModel.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<ReservationsModel>> getMyReservations() {
    String _uuid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection(DataBaseConstants.reservationsTable)
        .where('reservationUser', isEqualTo: _uuid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReservationsModel.fromFirestore(doc.data()))
            .toList());
  }

  Future<String> saveReservation(
      ReservationsModel reservation, BuildContext _context) async {
    try {
      await _db
          .collection(DataBaseConstants.reservationsTable)
          .doc(reservation.reservationId)
          .set(reservation.toMap());
      return AppLocalizations.of(_context)!.resSendComplete;
    } catch (e) {
      throw AppLocalizations.of(_context)!.resSendError;
    }
  }

  Future<String> cancelReservation(String resId, BuildContext _context) async {
    try {
      await _db
          .collection(DataBaseConstants.reservationsTable)
          .doc(resId)
          .update({'reservationStatus': 'canceled'});
      return AppLocalizations.of(_context)!.resCancelComplete;
    } catch (e) {
      throw AppLocalizations.of(_context)!.resCancelError;
    }
  }

  // *************************************************************************** Kampanya İşlemleri
  // *************************************************************************** Kampanya İşlemleri
  // *************************************************************************** Kampanya İşlemleri
  Future<CampaignModel> getCampaignData(String qrText) async {
    List<String> data = qrText.split('*');
    String storeId = data[0];
    String campaignId = data[1];

    return await _db
        .collection(DataBaseConstants.storesTable)
        .doc(storeId)
        .collection(DataBaseConstants.campaignsTable)
        .doc(campaignId)
        .get()
        .then((value) {
      return CampaignModel.fromFirestore(value.data()!);
    });
  }

  Stream<List<CampaignModel>> getStoreCampaigns(docId) {
    return _db
        .collection(DataBaseConstants.storesTable)
        .doc(docId)
        .collection(DataBaseConstants.campaignsTable)
        .where('delInd', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CampaignModel.fromFirestore(doc.data()))
            .toList());
  }

  Future<String> getCampaign(String storeId, String campaignId, String userName,
      BuildContext _context) async {
    UserModel user;

    String userId = FirebaseAuth.instance.currentUser!.uid;

    String campaignCodeString = storeId + '*' + campaignId + '*' + userId;

    try {
      user = await _db
          .collection(DataBaseConstants.userTable)
          .doc(userId)
          .get()
          .then((value) {
        return UserModel.fromFirestore(value.data());
      });
    } catch (e) {
      return AppLocalizations.of(_context)!.customerUnknown;
    }

    if (user.campaignCodes != null &&
        user.campaignCodes!.contains(campaignCodeString)) {
      throw AppLocalizations.of(_context)!.campaignCodeDuplicateError;
    } else {
      user.campaignCodes!.add(campaignCodeString);
    }

    try {
      await _db
          .collection(DataBaseConstants.userTable)
          .doc(userId)
          .update({'campaignCodes': user.campaignCodes});
    } catch (e) {
      throw AppLocalizations.of(_context)!.campaignCodeAddError;
    }

    try {
      CampaignUserModel campaignUserModel = CampaignUserModel(
          campaignId: campaignId,
          storeId: storeId,
          scanned: false,
          userId: userId,
          scannedAt: null,
          scannedById: null,
          scannedByName: null,
          userName: userName);

      await _db
          .collection(DataBaseConstants.storesTable)
          .doc(storeId)
          .collection(DataBaseConstants.campaignsTable)
          .doc(campaignId)
          .collection(DataBaseConstants.campaignUsersTable)
          .doc(userId)
          .set(campaignUserModel.toMap());

      return AppLocalizations.of(_context)!.campaignCodeAddComplete;
    } catch (e) {
      throw AppLocalizations.of(_context)!.campaignCodeAddError;
    }
  }

  // *************************************************************************** Favori İşlemleri
  // *************************************************************************** Favori İşlemleri
  // *************************************************************************** Favori İşlemleri

  Future<bool> manageFavorites(
      String storeId, UserModel user, BuildContext _context) async {
    String _uuid = FirebaseAuth.instance.currentUser!.uid;

    if (user.favorites != null && user.favorites!.contains(storeId)) {
      user.favorites!.remove(storeId);
    } else {
      user.favorites!.add(storeId);
    }

    try {
      await _db
          .collection(DataBaseConstants.userTable)
          .doc(_uuid)
          .set(user.toMap());
      return true;
    } catch (e) {
      throw AppLocalizations.of(_context)!.errorOccured;
    }
  }
}
