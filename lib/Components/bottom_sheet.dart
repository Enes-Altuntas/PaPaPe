import 'package:bulovva/Components/gradient_button.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Store/store.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetMap extends StatelessWidget {
  final StoreModel store;

  const BottomSheetMap({Key key, this.store}) : super(key: key);

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
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).primaryColor
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
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
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.blue[900], spreadRadius: 3),
                      ],
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Stack(
                    children: [
                      (store != null &&
                              (store.storePicRef != null &&
                                  store.storePicRef.isNotEmpty))
                          ? Image.network(store.storePicRef, loadingBuilder:
                              (context, child, loadingProgress) {
                              return loadingProgress == null
                                  ? Stack(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: child),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                store.storeName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset:
                                                            Offset(1.0, 1.0),
                                                        blurRadius: 10.0,
                                                        color: Colors.black,
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                    fontSize: (store.storeName
                                                                .length >
                                                            30)
                                                        ? 30.0
                                                        : 40.0,
                                                    fontFamily: 'Bebas'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20.0, top: 20.0),
                                                child: GradientButton(
                                                  buttonText: 'Gözat',
                                                  icon: FontAwesomeIcons
                                                      .signInAlt,
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Store(
                                                                      storeData:
                                                                          store,
                                                                    )));
                                                  },
                                                  fontFamily: 'Roboto',
                                                  startColor: Colors.amber[800],
                                                  finishColor:
                                                      Colors.amber[800],
                                                  fontColor: Colors.white,
                                                  iconColor: Colors.white,
                                                  fontSize: 15,
                                                  widthMultiplier: 0.7,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.amber[900],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              'İşletme bilgileri getiriliyor.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 17.0),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            }, fit: BoxFit.fitWidth)
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      store.storeName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.0),
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                            ),
                                          ],
                                          color: Colors.white,
                                          fontSize:
                                              (store.storeName.length > 30)
                                                  ? 30.0
                                                  : 40.0,
                                          fontFamily: 'Bebas'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20.0, top: 20.0),
                                      child: GradientButton(
                                        buttonText: 'Gözat',
                                        icon: FontAwesomeIcons.signInAlt,
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => Store(
                                                        storeData: store,
                                                      )));
                                        },
                                        fontFamily: 'Roboto',
                                        startColor: Colors.amber[800],
                                        finishColor: Colors.amber[800],
                                        fontColor: Colors.white,
                                        iconColor: Colors.white,
                                        fontSize: 15,
                                        widthMultiplier: 0.7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
