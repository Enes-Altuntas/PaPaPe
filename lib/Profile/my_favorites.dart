import 'package:bulovva/Components/favorite_store.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Models/user_model.dart';
import 'package:bulovva/Store/store.dart';
import 'package:bulovva/services/firestore_service.dart';
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
          flexibleSpace: Container(
            color: ColorConstants.instance.primaryColor,
          ),
          iconTheme: IconThemeData(
            color: ColorConstants.instance.iconOnColor, //change your color here
          ),
          elevation: 0,
          title: const TitleWidget(),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorConstants.instance.primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorConstants.instance.whiteContainer,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: StreamBuilder<UserModel>(
                      stream: FirestoreService().getUserDetail(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                            switch (snapshot.data != null &&
                                snapshot.data.favorites != null &&
                                snapshot.data.favorites.isNotEmpty) {
                              case true:
                                return ListView.builder(
                                  itemCount: snapshot.data.favorites.length,
                                  itemBuilder: (context, index) {
                                    return FutureBuilder<StoreModel>(
                                        future: FirestoreService().getStoreData(
                                            snapshot.data.favorites[index]),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.done:
                                              switch (snapshot.data != null) {
                                                case true:
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: StoreCards(
                                                        store: snapshot.data,
                                                        onTap: () {
                                                          openStore(
                                                              snapshot.data,
                                                              context);
                                                        },
                                                      ));
                                                  break;
                                                default:
                                                  return Container();
                                              }
                                              break;
                                            default:
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: ColorConstants
                                                    .instance.primaryColor,
                                              ));
                                          }
                                        });
                                  },
                                );
                                break;
                              default:
                                return NotFound(
                                  notFoundIcon:
                                      FontAwesomeIcons.exclamationTriangle,
                                  notFoundIconColor:
                                      ColorConstants.instance.primaryColor,
                                  notFoundText:
                                      'Üzgünüz, favorilerinizde işletme bulunmamaktadır.',
                                  notFoundTextColor:
                                      ColorConstants.instance.hintColor,
                                );
                            }
                            break;
                          default:
                            return Center(
                                child: CircularProgressIndicator(
                              color: ColorConstants.instance.primaryColor,
                            ));
                        }
                      })),
            ),
          ),
        ));
  }
}
