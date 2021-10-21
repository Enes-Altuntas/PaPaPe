import 'package:bulovva/Models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: (widget.product.productPicRef != null &&
                          widget.product.productPicRef.isNotEmpty)
                      ? Image.network(
                          widget.product.productPicRef,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Resim Yok',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.product.productName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        widget.product.productDesc,
                        style: TextStyle(fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Fiyat: ${widget.product.productPrice} TRY',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
