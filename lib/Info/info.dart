import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:bulb/Services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  final StoreModel storeData;

  Info({Key key, this.storeData}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final firestoreService = FirestoreService();
  Future isFavorite;
  bool firstTime = true;
  bool favorite = false;
  bool _isLoading = false;

  makePhoneCall() async {
    await launch("tel:${widget.storeData.storePhone}");
  }

  findPlace() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  addFavorites() async {
    setState(() {
      _isLoading = false;
    });
    await firestoreService
        .addFavorites(widget.storeData.storeId)
        .onError(
            (error, stackTrace) => ToastService().showError(error, context))
        .whenComplete(() => setState(() {
              _isLoading = false;
            }));
  }

  removeFavorites() async {
    setState(() {
      _isLoading = false;
    });
    await firestoreService
        .removeFavorites(widget.storeData.storeId)
        .onError(
            (error, stackTrace) => ToastService().showError(error, context))
        .whenComplete(() => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? FutureBuilder<Object>(
            future: firestoreService.isFavorite(widget.storeData.storeId),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        (widget.storeData.storePicRef != null)
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Theme.of(context).accentColor,
                                      Theme.of(context).primaryColor
                                    ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft)),
                                child: Image.network(
                                  widget.storeData.storePicRef,
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Theme.of(context).accentColor,
                                      Theme.of(context).primaryColor
                                    ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft)),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.storeData.storeName,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Bebas',
                              fontSize: MediaQuery.of(context).size.height / 12,
                              shadows: <Shadow>[
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    height: MediaQuery.of(context).size.height / 10,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(color: Colors.white, spreadRadius: 3)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            makePhoneCall();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call, color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'İşletmeyi Ara',
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'Bebas'),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (snapshot.data == true) {
                              removeFavorites();
                            } else {
                              addFavorites();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: (snapshot.data == true)
                                    ? Colors.amber[300]
                                    : Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (snapshot.data == true)
                                      ? 'Favorilerden Çıkar'
                                      : 'Favorilere Ekle',
                                  style: TextStyle(
                                      color: (snapshot.data == true)
                                          ? Colors.amber[300]
                                          : Colors.white,
                                      fontFamily: 'Bebas'),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            findPlace();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Haritada Göster',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Bebas')),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })
        : Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
  }
}
