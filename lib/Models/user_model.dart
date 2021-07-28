class UserModel {
  final String userId;
  final String token;
  final String userType;

  UserModel({
    this.userId,
    this.token,
    this.userType,
  });

  UserModel.fromFirestore(Map<String, dynamic> data)
      : userId = data['userId'],
        token = data['token'],
        userType = data['userType'];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'token': token,
      'userType': userType,
    };
  }
}
