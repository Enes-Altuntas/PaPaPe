import 'package:papape/Components/favorite_store.dart';
import 'package:papape/Components/not_found.dart';
import 'package:papape/Components/title.dart';
import 'package:papape/Models/store_model.dart';
import 'package:papape/Models/user_model.dart';
import 'package:papape/Store/store.dart';
import 'package:papape/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyFavorites extends StatelessWidget {
  const MyFavorites({Key key}) : super(key: key);

  openStore(StoreModel store, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Store(
              storeData: store,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          title: TitleApp(),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0))),
              child: Column(
                children: [
                  SizedBox(
                    height: 60.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Favorilerim',
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
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: StreamBuilder<UserModel>(
                                      stream:
                                          FirestoreService().getUserDetail(),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.active:
                                            switch (snapshot.data != null &&
                                                snapshot.data.favorites !=
                                                    null &&
                                                snapshot.data.favorites.length >
                                                    0) {
                                              case true:
                                                return ListView.builder(
                                                  itemCount: snapshot
                                                      .data.favorites.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return FutureBuilder<
                                                            StoreModel>(
                                                        future: FirestoreService()
                                                            .getStoreData(snapshot
                                                                    .data
                                                                    .favorites[
                                                                index]),
                                                        builder: (context,
                                                            snapshot) {
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .done:
                                                              switch (snapshot
                                                                      .data !=
                                                                  null) {
                                                                case true:
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          StoreCards(
                                                                        store: snapshot
                                                                            .data,
                                                                        onTap:
                                                                            () {
                                                                          openStore(
                                                                              snapshot.data,
                                                                              context);
                                                                        },
                                                                      ));
                                                                  break;
                                                                default:
                                                                  return NotFound(
                                                                    notFoundIcon:
                                                                        FontAwesomeIcons
                                                                            .exclamationCircle,
                                                                    notFoundIconColor:
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                    notFoundIconSize:
                                                                        40,
                                                                    notFoundText:
                                                                        'İşletme bilgileri bulunamadı !',
                                                                    notFoundTextColor:
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                    notFoundTextSize:
                                                                        40.0,
                                                                  );
                                                              }
                                                              break;
                                                            default:
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                color: Colors
                                                                    .amber[900],
                                                              ));
                                                          }
                                                        });
                                                  },
                                                );
                                                break;
                                              default:
                                                return NotFound(
                                                  notFoundIcon: FontAwesomeIcons
                                                      .exclamationTriangle,
                                                  notFoundIconColor:
                                                      Colors.amber[900],
                                                  notFoundIconSize: 60,
                                                  notFoundText:
                                                      'Üzgünüz, favorilerinizde işletme bulunmamaktadır.',
                                                  notFoundTextColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  notFoundTextSize: 40.0,
                                                );
                                            }
                                            break;
                                          default:
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.amber[900],
                                            ));
                                        }
                                      }),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
