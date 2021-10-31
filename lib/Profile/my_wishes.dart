import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Components/wish_card.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/wishes_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyWishes extends StatelessWidget {
  const MyWishes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ColorConstants.instance.iconOnColor, //change your color here
          ),
          elevation: 0,
          title: const TitleWidget(),
          centerTitle: true,
          flexibleSpace: Container(
            color: ColorConstants.instance.primaryColor,
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorConstants.instance.primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Builder(builder: (context) {
              return Container(
                decoration: BoxDecoration(
                    color: ColorConstants.instance.whiteContainer,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0))),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 20.0, right: 10.0),
                    child: StreamBuilder<List<WishesModel>>(
                      stream: FirestoreService().getMyWishes(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                            switch (
                                snapshot.hasData && snapshot.data.isNotEmpty) {
                              case true:
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CommentCard(
                                          wish: snapshot.data[index],
                                        ));
                                  },
                                );
                                break;
                              default:
                                return NotFound(
                                  notFoundIcon:
                                      FontAwesomeIcons.exclamationTriangle,
                                  notFoundIconColor:
                                      ColorConstants.instance.primaryColor,
                                  notFoundIconSize: 50,
                                  notFoundText:
                                      'Üzgünüz, belirtmiş olduğunuz bir dilek veya şikayet bulunmamaktadır.',
                                  notFoundTextColor:
                                      ColorConstants.instance.hintColor,
                                  notFoundTextSize: 30.0,
                                );
                            }
                            break;
                          default:
                            return const ProgressWidget();
                        }
                      },
                    )),
              );
            }),
          ),
        ));
  }
}
