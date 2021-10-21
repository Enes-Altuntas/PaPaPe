import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Components/wish_card.dart';
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
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).primaryColor
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
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
                          'Dilek ve Şikayetlerim',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
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
                                  child: StreamBuilder<List<WishesModel>>(
                                    stream: FirestoreService().getMyWishes(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.active:
                                          switch (snapshot.hasData &&
                                              snapshot.data.length > 0) {
                                            case true:
                                              return ListView.builder(
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: CommentCard(
                                                        wish: snapshot
                                                            .data[index],
                                                      ));
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
                                                    'Üzgünüz, belirtmiş olduğunuz bir dilek veya şikayet bulunmamaktadır.',
                                                notFoundTextColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                notFoundTextSize: 40.0,
                                              );
                                          }
                                          break;
                                        default:
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.amber[900],
                                            ),
                                          );
                                      }
                                    },
                                  ),
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
