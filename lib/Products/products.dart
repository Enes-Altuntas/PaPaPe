import 'package:bulovva/Components/category_card.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/product_category_model.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatefulWidget {
  final StoreModel storeData;

  const Menu({Key key, this.storeData}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ProductCategory> category;
  List<ProductModel> products;
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? StreamBuilder<List<ProductCategory>>(
            stream: FirestoreService()
                .getProductCategories(widget.storeData.storeId),
            builder: (context, snapshot) {
              category = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  switch (snapshot.hasData && snapshot.data.isNotEmpty) {
                    case true:
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: CategoryCard(
                                category: snapshot.data[index],
                                storeId: widget.storeData.storeId,
                              ));
                        },
                      );
                      break;
                    default:
                      return NotFound(
                        notFoundIcon: FontAwesomeIcons.exclamationTriangle,
                        notFoundIconColor: ColorConstants.instance.primaryColor,
                        notFoundIconSize: 50,
                        notFoundText: 'Üzgünüz, menüde ürün bulunmamaktadır.',
                        notFoundTextColor: ColorConstants.instance.textOnColor,
                        notFoundTextSize: 30.0,
                      );
                  }
                  break;
                default:
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.instance.primaryColor,
                    ),
                  );
              }
            },
          )
        : const ProgressWidget();
  }
}
