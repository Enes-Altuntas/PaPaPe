import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/product_card.dart';
import 'package:bulovva/Models/product_category_model.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatefulWidget {
  final StoreModel storeData;

  Menu({Key key, this.storeData}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ProductCategory> category;
  List<ProductModel> products;
  String _selectedCategoryId;
  String _selectedCategoryName;
  bool _isLoading = false;

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
                  switch (snapshot.hasData && snapshot.data.length > 0) {
                    case true:
                      if (_selectedCategoryId == null) {
                        _selectedCategoryId = snapshot.data[0].categoryId;
                        _selectedCategoryName = snapshot.data[0].categoryName;
                      }
                      return Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.red,
                                height: 60.0,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5.0, left: 5.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedCategoryId = snapshot
                                                    .data[index].categoryId;
                                                _selectedCategoryName = snapshot
                                                    .data[index].categoryName;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  snapshot
                                                      .data[index].categoryName,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontFamily: 'Bebas',
                                                      fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: StreamBuilder<List<ProductModel>>(
                                stream: FirestoreService().getProducts(
                                    widget.storeData.storeId,
                                    _selectedCategoryId),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.active:
                                      switch (snapshot.hasData &&
                                          snapshot.data.length > 0) {
                                        case true:
                                          return Column(
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 5.0,
                                                            right: 5.0,
                                                            bottom: 10.0),
                                                    child: ProductCard(
                                                      product:
                                                          snapshot.data[index],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                          break;
                                        default:
                                          return NotFound(
                                            notFoundIcon: FontAwesomeIcons
                                                .exclamationTriangle,
                                            notFoundIconColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            notFoundIconSize: 50,
                                            notFoundText:
                                                "'$_selectedCategoryName' kategorisinde hiçbir ürün bulunamamıştır !",
                                            notFoundTextColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            notFoundTextSize: 30.0,
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
                          ),
                        ],
                      );
                      break;
                    default:
                      return NotFound(
                        notFoundIcon: FontAwesomeIcons.exclamationTriangle,
                        notFoundIconColor:
                            Theme.of(context).colorScheme.secondary,
                        notFoundIconSize: 50,
                        notFoundText: 'Üzgünüz, menüde ürün bulunmamaktadır.',
                        notFoundTextColor:
                            Theme.of(context).colorScheme.primary,
                        notFoundTextSize: 30.0,
                      );
                  }
                  break;
                default:
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
  }
}
