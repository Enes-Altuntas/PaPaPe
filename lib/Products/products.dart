import 'package:bulb/Components/category_card.dart';
import 'package:bulb/Components/not_found.dart';
import 'package:bulb/Models/product_category_model.dart';
import 'package:bulb/Models/product_model.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/services/firestore_service.dart';
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Ürünler',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontFamily: 'Armatic',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: StreamBuilder<List<ProductCategory>>(
                  stream: FirestoreService()
                      .getProductCategories(widget.storeData.storeId),
                  builder: (context, snapshot) {
                    category = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        switch (snapshot.hasData && snapshot.data.length > 0) {
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
                              notFoundIcon: FontAwesomeIcons.sadTear,
                              notFoundIconColor: Theme.of(context).primaryColor,
                              notFoundIconSize: 75,
                              notFoundText:
                                  'Şu an yayınlamış olduğunuz hiçbir başlık bulunmamaktadır.',
                              notFoundTextColor: Theme.of(context).primaryColor,
                              notFoundTextSize: 30.0,
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
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.amber[900],
            ),
          );
  }
}
