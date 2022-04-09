import 'dart:io';

class ProductModel {
  final String? productDesc;
  final String? productDescEn;
  final String productName;
  final String? productNameEn;
  final String productPrice;
  final String? productId;
  final String productCatId;
  String? productPicRef;
  File? productLocalImage;

  ProductModel(
      {this.productDesc,
      this.productDescEn,
      required this.productName,
      required this.productNameEn,
      required this.productPrice,
      this.productId,
      required this.productCatId,
      this.productPicRef,
      this.productLocalImage});

  ProductModel.fromFirestore(Map<String, dynamic> data)
      : productDesc = data['productDesc'],
        productDescEn = data['productDescEn'],
        productName = data['productName'],
        productNameEn = data['productNameEn'],
        productPrice = data['productPrice'],
        productId = data['productId'],
        productCatId = data['productCatId'],
        productPicRef = data['productPicRef'];

  Map<String, dynamic> toMap() {
    return {
      'productDesc': productDesc,
      'productDescEn': productDescEn,
      'productName': productName,
      'productNameEn': productNameEn,
      'productPrice': productPrice,
      'productId': productId,
      'productCatId': productCatId,
      'productPicRef': productPicRef,
    };
  }
}
