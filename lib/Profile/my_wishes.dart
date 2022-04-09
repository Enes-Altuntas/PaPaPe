import 'package:myrest/Components/app_title.dart';
import 'package:myrest/Components/not_found.dart';
import 'package:myrest/Components/progress.dart';
import 'package:myrest/Components/wish_card.dart';
import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/wishes_model.dart';
import 'package:myrest/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWishes extends StatelessWidget {
  const MyWishes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50.0,
          iconTheme: IconThemeData(
            color: ColorConstants.instance.primaryColor,
          ),
          elevation: 0,
          title: const AppTitleWidget(),
          centerTitle: true,
          flexibleSpace: Container(
            color: ColorConstants.instance.whiteContainer,
          ),
        ),
        body: Builder(builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: ColorConstants.instance.whiteContainer,
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: StreamBuilder<List<WishesModel>>(
                  stream: FirestoreService().getMyWishes(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        switch (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          case true:
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CommentCard(
                                      wish: snapshot.data![index],
                                    ));
                              },
                            );
                          default:
                            return NotFound(
                              notFoundIcon:
                                  FontAwesomeIcons.exclamationTriangle,
                              notFoundText:
                                  AppLocalizations.of(context)!.wishesNotFound,
                            );
                        }
                      default:
                        return const ProgressWidget();
                    }
                  },
                )),
          );
        }));
  }
}
