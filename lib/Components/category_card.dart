import 'package:papape/Components/not_found.dart';
import 'package:papape/Components/product_card.dart';
import 'package:papape/Models/product_category_model.dart';
import 'package:papape/Models/product_model.dart';
import 'package:papape/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryCard extends StatefulWidget {
  final ProductCategory category;
  final String storeId;
  final Function onPressedEdit;
  final Function onPressedDelete;

  CategoryCard(
      {Key key,
      this.category,
      this.storeId,
      this.onPressedEdit,
      this.onPressedDelete})
      : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  showImage(String url) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ], begin: Alignment.centerRight, end: Alignment.centerLeft),
              ),
              child: Image.network(
                url,
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                },
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.category.categoryName,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Bebas',
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<ProductModel>>(
                stream: FirestoreService()
                    .getProducts(widget.storeId, widget.category.categoryId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      switch (snapshot.hasData && snapshot.data.length > 0) {
                        case true:
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: ProductCard(
                                      onTapped: () {
                                        if (snapshot
                                                .data[index].productPicRef !=
                                            null) {
                                          showImage(snapshot
                                              .data[index].productPicRef);
                                        }
                                      },
                                      product: snapshot.data[index],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                          break;
                        default:
                          return NotFound(
                            notFoundIcon: FontAwesomeIcons.exclamationTriangle,
                            notFoundIconColor: Colors.amber[900],
                            notFoundIconSize: 30,
                            notFoundText:
                                "'${widget.category.categoryName}' kategorisinde hiçbir ürün bulunamamıştır !",
                            notFoundTextColor: Theme.of(context).primaryColor,
                            notFoundTextSize: 20.0,
                          );
                      }
                      break;
                    default:
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.amber[900],
                      ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
