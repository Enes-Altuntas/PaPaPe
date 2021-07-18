class TokenModel {
  final String tokenId;
  final String tokenUser;

  TokenModel({
    this.tokenId,
    this.tokenUser,
  });

  TokenModel.fromFirestore(Map<String, dynamic> data)
      : tokenId = data['tokenId'],
        tokenUser = data['tokenUser'];

  Map<String, dynamic> toMap() {
    return {
      'tokenId': tokenId,
      'tokenUser': tokenUser,
    };
  }
}
