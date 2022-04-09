class UserModel {
  final String? name;
  final String userId;
  final String? token;
  final String? iToken;
  final String? storeId;
  final List? favorites;
  final List? campaignCodes;
  final List roles;

  UserModel(
      {required this.userId,
      this.token,
      this.iToken,
      this.favorites,
      this.storeId,
      this.campaignCodes,
      required this.roles,
      required this.name});

  UserModel.fromFirestore(Map<String, dynamic>? data)
      : userId = data!['userId'],
        token = data['token'],
        iToken = data['iToken'],
        favorites = data['favorites'],
        storeId = data['storeId'],
        name = data['name'],
        roles = data['roles'],
        campaignCodes = data['campaignCodes'];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'iToken': iToken,
      'token': token,
      'favorites': favorites,
      'storeId': storeId,
      'name': name,
      'roles': roles,
      'campaignCodes': campaignCodes,
    };
  }
}
