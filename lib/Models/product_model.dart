import 'dart:io';

class ProductModel {
  final String productDesc;
  final String productName;
  final int productPrice;
  final String productId;
  final String productCatId;
  String productPicRef;
  File productLocalImage;

  ProductModel(
      {this.productDesc,
      this.productName,
      this.productPrice,
      this.productId,
      this.productCatId,
      this.productPicRef,
      this.productLocalImage});

  ProductModel.fromFirestore(Map<String, dynamic> data)
      : productDesc = data['productDesc'],
        productName = data['productName'],
        productPrice = data['productPrice'],
        productId = data['productId'],
        productCatId = data['productCatId'],
        productPicRef = data['productPicRef'];

  Map<String, dynamic> toMap() {
    return {
      'productDesc': productDesc,
      'productName': productName,
      'productPrice': productPrice,
      'productId': productId,
      'productCatId': productCatId,
      'productPicRef': productPicRef,
    };
  }
}
