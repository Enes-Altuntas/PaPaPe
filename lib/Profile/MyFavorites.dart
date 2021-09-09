import 'package:bulb/Components/favorite_store.dart';
import 'package:bulb/Components/not_found.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Models/user_model.dart';
import 'package:bulb/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyFavorites extends StatelessWidget {
  const MyFavorites({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          ),
          elevation: 0,
          title: Text('PaPaPe',
              style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0))),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 5.0,
                        ),
                        child: Text(
                          'Favorilerim',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30.0,
                              fontFamily: 'Armatic',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: StreamBuilder<UserModel>(
                              stream: FirestoreService().getUserDetail(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.active:
                                    switch (snapshot.data != null &&
                                        snapshot.data.favorites != null &&
                                        snapshot.data.favorites.length > 0) {
                                      case true:
                                        return ListView.builder(
                                          itemCount:
                                              snapshot.data.favorites.length,
                                          itemBuilder: (context, index) {
                                            return FutureBuilder<StoreModel>(
                                                future: FirestoreService()
                                                    .getStoreData(snapshot
                                                        .data.favorites[index]),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState.done:
                                                      switch (snapshot.data !=
                                                          null) {
                                                        case true:
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: StoreCards(
                                                                store: snapshot
                                                                    .data,
                                                              ));
                                                          break;
                                                        default:
                                                          return NotFound(
                                                            notFoundIcon:
                                                                FontAwesomeIcons
                                                                    .sadTear,
                                                            notFoundIconColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            notFoundIconSize:
                                                                75,
                                                            notFoundText:
                                                                'İşletme bilgileri bulunamadı !',
                                                            notFoundTextColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            notFoundTextSize:
                                                                30.0,
                                                          );
                                                      }
                                                      break;
                                                    default:
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ));
                                                  }
                                                });
                                          },
                                        );
                                        break;
                                      default:
                                        return NotFound(
                                          notFoundIcon:
                                              FontAwesomeIcons.sadTear,
                                          notFoundIconColor:
                                              Theme.of(context).primaryColor,
                                          notFoundIconSize: 75,
                                          notFoundText:
                                              'Henüz favorilerinize eklediğiniz herhangi bir işletme yoktur !',
                                          notFoundTextColor:
                                              Theme.of(context).primaryColor,
                                          notFoundTextSize: 30.0,
                                        );
                                    }
                                    break;
                                  default:
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ));
                                }
                              }),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}
