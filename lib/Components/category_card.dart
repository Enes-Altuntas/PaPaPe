import 'package:bulovva/Components/product_card.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/product_category_model.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/localization_constants.dart';
import '../Providers/locale_provider.dart';

class CategoryCard extends StatefulWidget {
  final ProductCategory category;
  final String storeId;
  final Function? onPressedEdit;
  final Function? onPressedDelete;

  const CategoryCard(
      {Key? key,
      required this.category,
      required this.storeId,
      this.onPressedEdit,
      this.onPressedDelete})
      : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (context.read<LocaleProvider>().locale ==
                        LocalizationConstant.trLocale)
                    ? widget.category.categoryName
                    : (widget.category.categoryNameEn != null)
                        ? widget.category.categoryNameEn!
                        : widget.category.categoryName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.instance.textGold,
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
                  switch (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    case true:
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ProductCard(
                                  product: snapshot.data![index],
                                ),
                              );
                            },
                          ),
                          const Divider(
                            thickness: 1.0,
                          )
                        ],
                      );
                    default:
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                            child: Text(
                          "Bu kategoride ürün yoktur",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.instance.primaryColor,
                          ),
                        )),
                      );
                  }
                default:
                  return Center(
                      child: CircularProgressIndicator(
                    color: ColorConstants.instance.primaryColor,
                  ));
              }
            }),
      ],
    );
  }
}
