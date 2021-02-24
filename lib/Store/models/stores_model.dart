class FirestoreStores {
  final bool hasCampaign;
  final String latitude;
  final String longtitude;
  final String storeAddress;
  final String storeFacebook;
  final String storeId;
  final String storeInstagram;
  final String storeName;
  final String storePhone;
  final String storePicRef;

  FirestoreStores({
    this.hasCampaign,
    this.latitude,
    this.longtitude,
    this.storeAddress,
    this.storeFacebook,
    this.storeId,
    this.storeInstagram,
    this.storeName,
    this.storePhone,
    this.storePicRef,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasCampaign': hasCampaign,
      'latitude': latitude,
      'longtitude': longtitude,
      'storeAddress': storeAddress,
      'storeFacebook': storeFacebook,
      'storeId': storeId,
      'storeInstagram': storeInstagram,
      'storeName': storeName,
      'storePhone': storePhone,
      'storePicRef': storePicRef,
    };
  }

  FirestoreStores.fromFirestore(Map<String, dynamic> firestore)
      : hasCampaign = firestore['hasCampaign'],
        latitude = firestore['latitude'],
        longtitude = firestore['longtitude'],
        storeAddress = firestore['storeAddress'],
        storeFacebook = firestore['storeFacebook'],
        storeId = firestore['storeId'],
        storeInstagram = firestore['storeInstagram'],
        storeName = firestore['storeName'],
        storePhone = firestore['storePhone'],
        storePicRef = firestore['storePicRef'];
}
