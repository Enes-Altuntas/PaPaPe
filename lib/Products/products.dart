import 'package:bulb/Models/product_category_model.dart';
import 'package:bulb/Models/product_model.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final StoreModel storeData;

  Menu({Key key, this.storeData}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ProductCategory> category;
  List<Product> products;
  bool _isLoading = false;

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
                    return (snapshot.connectionState == ConnectionState.active)
                        ? (snapshot.data.length > 0)
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width / 8,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data[index].categoryName,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: 'Bebas',
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          StreamBuilder<List<Product>>(
                                              stream: FirestoreService()
                                                  .getProducts(
                                                      widget.storeData.storeId,
                                                      snapshot.data[index]
                                                          .categoryId),
                                              builder:
                                                  (context, snapshotProduct) {
                                                products = snapshotProduct.data;
                                                return (snapshotProduct
                                                            .connectionState ==
                                                        ConnectionState.active)
                                                    ? (snapshotProduct
                                                                .data.length >
                                                            0)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            child: Column(
                                                              children: [
                                                                ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            ClampingScrollPhysics(),
                                                                        itemCount: snapshotProduct
                                                                            .data
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                indexDishes) {
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 10.0),
                                                                            child:
                                                                                Card(
                                                                              elevation: 5,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(50.0),
                                                                              ),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              color: Colors.white,
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    gradient: LinearGradient(colors: [
                                                                                  Theme.of(context).accentColor,
                                                                                  Theme.of(context).primaryColor
                                                                                ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(15.0),
                                                                                  child: ListTile(
                                                                                    title: Row(
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Text(
                                                                                            snapshotProduct.data[indexDishes].productName,
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    trailing: Container(
                                                                                      height: MediaQuery.of(context).size.height,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 10.0),
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Icon(Icons.arrow_forward, color: Colors.white)
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    subtitle: Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(snapshotProduct.data[indexDishes].productDesc, style: TextStyle(color: Colors.white)),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                                                            child: Text(
                                                                                              'Fiyat: ${snapshotProduct.data[indexDishes].productPrice} TRY',
                                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              ],
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .assignment_late_outlined,
                                                                  size: 100.0,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          20.0),
                                                                  child: Text(
                                                                    "Henüz '${snapshot.data[index].categoryName}' başlığına kaydedilmiş bir ürününüz bulunmamaktadır !",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25.0,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.white,
                                                      ));
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.assignment_late_outlined,
                                      size: 100.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        'Henüz kaydedilmiş bir başlığınız bulunmamaktadır !',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                  },
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
  }
}
