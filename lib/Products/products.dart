import 'package:papape/Components/category_card.dart';
import 'package:papape/Components/not_found.dart';
import 'package:papape/Models/product_category_model.dart';
import 'package:papape/Models/product_model.dart';
import 'package:papape/Models/store_model.dart';
import 'package:papape/services/firestore_service.dart';
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
  bool _isLoading = false;

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
    return (_isLoading == false)
        ? Column(
            children: [
              SizedBox(
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ürünler',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                          fontFamily: 'Armatic',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: StreamBuilder<List<ProductCategory>>(
                      stream: FirestoreService()
                          .getProductCategories(widget.storeData.storeId),
                      builder: (context, snapshot) {
                        category = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                            switch (
                                snapshot.hasData && snapshot.data.length > 0) {
                              case true:
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: CategoryCard(
                                          category: snapshot.data[index],
                                          storeId: widget.storeData.storeId,
                                        ));
                                  },
                                );
                                break;
                              default:
                                return NotFound(
                                  notFoundIcon:
                                      FontAwesomeIcons.exclamationTriangle,
                                  notFoundIconColor: Colors.amber[900],
                                  notFoundIconSize: 60,
                                  notFoundText:
                                      'Üzgünüz, menüde ürün bulunmamaktadır.',
                                  notFoundTextColor:
                                      Theme.of(context).primaryColor,
                                  notFoundTextSize: 40.0,
                                );
                            }
                            break;
                          default:
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber[900],
                              ),
                            );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.amber[900],
            ),
          );
  }
}
