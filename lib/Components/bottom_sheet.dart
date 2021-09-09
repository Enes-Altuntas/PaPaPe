import 'package:bulb/Components/gradient_button.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Reservations/reservation.dart';
import 'package:bulb/Store/store.dart';
import 'package:bulb/Wishes/wish.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetMap extends StatelessWidget {
  final StoreModel store;
  final String id;

  const BottomSheetMap({Key key, this.store, this.id}) : super(key: key);

  makePhoneCall(storePhone) async {
    await launch("tel:$storePhone");
  }

  findPlace(storeLat, storeLong) async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$storeLat,$storeLong";
    await launch(googleMapslocationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).accentColor,
        Theme.of(context).primaryColor
      ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
            child: Container(
                clipBehavior: Clip.antiAlias,
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    boxShadow: [
                      BoxShadow(color: Colors.white, spreadRadius: 3),
                    ],
                    borderRadius: BorderRadius.circular(50.0)),
                child: Stack(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.darken),
                      child: (store != null && store.storePicRef != null)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Image.network(store.storePicRef,
                                  fit: BoxFit.fitWidth),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            store.storeName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 15.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                                color: Colors.white,
                                fontSize:
                                    (store.storeName.length > 30) ? 30.0 : 40.0,
                                fontFamily: 'Bebas'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[900],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      findPlace(store.storeLocLat,
                                          store.storeLocLong);
                                    },
                                    icon: Icon(
                                      Icons.location_on_outlined,
                                      size: 30.0,
                                      color: Colors.white,
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.amber[900],
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Store(
                                                    storeData: store,
                                                    docId: id,
                                                  )));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30.0,
                                      color: Colors.white,
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.amber[900],
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      makePhoneCall(store.storePhone);
                                    },
                                    icon: Icon(
                                      Icons.call,
                                      size: 30.0,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          GradientButton(
            buttonText: 'Dilek & Şikayet Bildir',
            fontColor: Colors.white,
            fontFamily: 'Roboto',
            icon: FontAwesomeIcons.bullhorn,
            fontSize: 15.0,
            iconColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Wish(store: store)));
            },
            widthMultiplier: 0.9,
            startColor: Colors.amber[900],
            finishColor: Colors.amber[900],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GradientButton(
              buttonText: 'Rezervasyon Yap',
              fontColor: Colors.white,
              fontFamily: 'Roboto',
              icon: FontAwesomeIcons.bookOpen,
              fontSize: 15.0,
              iconColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Reservation(store: store)));
              },
              widthMultiplier: 0.9,
              startColor: Colors.amber[900],
              finishColor: Colors.amber[900],
            ),
          )
        ],
      ),
    );
  }
}
