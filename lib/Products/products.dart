import 'package:myrest/Components/category_card.dart';
import 'package:myrest/Components/not_found.dart';
import 'package:myrest/Components/progress.dart';
import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/product_category_model.dart';
import 'package:myrest/Models/store_model.dart';
import 'package:myrest/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Menu extends StatefulWidget {
  final StoreModel storeData;

  const Menu({Key? key, required this.storeData}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? StreamBuilder<List<ProductCategory>>(
            stream: FirestoreService()
                .getProductCategories(widget.storeData.storeId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  switch (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    case true:
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: CategoryCard(
                                  category: snapshot.data![index],
                                  storeId: widget.storeData.storeId,
                                ));
                          },
                        ),
                      );
                    default:
                      return NotFound(
                        notFoundIcon: FontAwesomeIcons.exclamationTriangle,
                        notFoundText:
                            AppLocalizations.of(context)!.menuItemNotFound,
                      );
                  }
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
