import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/localization_constants.dart';
import '../Providers/locale_provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

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
                    child: Image.network(widget.product.productPicRef!))
                : null,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                (context.read<LocaleProvider>().locale ==
                        LocalizationConstant.trLocale)
                    ? widget.product.productName
                    : (widget.product.productNameEn != null)
                        ? widget.product.productNameEn!
                        : widget.product.productName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.product.productDesc != null ||
                        widget.product.productDescEn != null)
                    ? Text(
                        (context.read<LocaleProvider>().locale ==
                                LocalizationConstant.trLocale)
                            ? widget.product.productDesc!
                            : widget.product.productDescEn!,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: ColorConstants.instance.primaryColor,
                            fontSize: 12.0),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'TRY ${widget.product.productPrice}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.instance.primaryColor,
                        fontSize: 13.0),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
