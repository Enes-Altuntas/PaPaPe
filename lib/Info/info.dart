import 'package:bulb/Models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  final StoreModel storeData;

  Info({Key key, this.storeData}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  bool isLoading = false;

  makePhoneCall() async {
    await launch("tel:${widget.storeData.storePhone}");
  }

  findPlace() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  addFavorites() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              (widget.storeData.storePicRef != null)
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.darken),
                      child: Container(
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
              boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 3)]),
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
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Bebas'),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  addFavorites();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Favorilere Ekle',
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Bebas'),
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
                              color: Colors.white, fontFamily: 'Bebas')),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
