import 'package:bulovva/Components/product_card.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/product_category_model.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final ProductCategory category;
  final String storeId;
  final Function onPressedEdit;
  final Function onPressedDelete;

  const CategoryCard(
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
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
                    fontSize: 23.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.instance.primaryColor,
                  ),
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
                    switch (snapshot.hasData && snapshot.data.isNotEmpty) {
                      case true:
                        return Column(
                          children: [
                            SizedBox(
                              height: 260.0,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ProductCard(
                                      product: snapshot.data[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                        break;
                      default:
                        return Container();
                    }
                    break;
                  default:
                    return Center(
                        child: CircularProgressIndicator(
                      color: ColorConstants.instance.primaryColor,
                    ));
                }
              }),
        ],
      ),
    );
  }
}
