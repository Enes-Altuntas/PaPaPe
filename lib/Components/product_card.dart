import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            trailing: (widget.product.productPicRef != null)
                ? Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                    child: Image.network(widget.product.productPicRef))
                : Container(),
            title: Text(
              widget.product.productName,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: ColorConstants.instance.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.productDesc,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: ColorConstants.instance.primaryColor,
                      fontSize: 12.0),
                ),
                Text(
                  'TRY ${widget.product.productPrice.toDouble().toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.instance.primaryColor,
                      fontSize: 13.0),
                ),
              ],
            ),
          ),
        ));
  }
}
