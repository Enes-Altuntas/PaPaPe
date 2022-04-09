import 'package:myrest/Components/app_title.dart';
import 'package:myrest/Components/favorite_store.dart';
import 'package:myrest/Components/not_found.dart';
import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/store_model.dart';
import 'package:myrest/Models/user_model.dart';
import 'package:myrest/Store/store.dart';
import 'package:myrest/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyFavorites extends StatelessWidget {
  const MyFavorites({Key? key}) : super(key: key);

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
          toolbarHeight: 50.0,
          flexibleSpace: Container(
            color: ColorConstants.instance.whiteContainer,
          ),
          iconTheme: IconThemeData(
            color: ColorConstants.instance.primaryColor,
          ),
          elevation: 0,
          title: const AppTitleWidget(),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: ColorConstants.instance.whiteContainer,
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: StreamBuilder<UserModel>(
                  stream: FirestoreService().getUserDetail(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        switch (snapshot.data != null &&
                            snapshot.data!.favorites != null &&
                            snapshot.data!.favorites!.isNotEmpty) {
                          case true:
                            return ListView.builder(
                              itemCount: snapshot.data!.favorites!.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<StoreModel>(
                                    future: FirestoreService().getStoreData(
                                        snapshot.data!.favorites![index]),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.done:
                                          switch (snapshot.data != null) {
                                            case true:
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: StoreCards(
                                                    store: snapshot.data!,
                                                    onTap: () {
                                                      openStore(snapshot.data!,
                                                          context);
                                                    },
                                                  ));
                                            default:
                                              return Container();
                                          }
                                        default:
                                          return Center(
                                              child: CircularProgressIndicator(
                                            color: ColorConstants
                                                .instance.primaryColor,
                                          ));
                                      }
                                    });
                              },
                            );
                          default:
                            return NotFound(
                              notFoundIcon:
                                  FontAwesomeIcons.exclamationTriangle,
                              notFoundText: AppLocalizations.of(context)!
                                  .favoriteStoreNotFound,
                            );
                        }
                      default:
                        return Center(
                            child: CircularProgressIndicator(
                          color: ColorConstants.instance.primaryColor,
                        ));
                    }
                  })),
        ));
  }
}
