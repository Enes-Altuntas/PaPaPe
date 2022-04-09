import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/user_model.dart';
import 'package:myrest/Services/firestore_service.dart';
import 'package:myrest/Services/toast_service.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final String storeId;
  const FavoriteButton({Key? key, required this.storeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
        stream: FirestoreService().getUserDetail(),
        builder: (context, snapshot) {
          return IconButton(
              onPressed: () {
                FirestoreService()
                    .manageFavorites(storeId, snapshot.data!, context)
                    .onError((error, stackTrace) =>
                        ToastService().showError(error, context));
              },
              icon: Icon(
                (snapshot.data != null &&
                        snapshot.data!.favorites != null &&
                        snapshot.data!.favorites!.isNotEmpty &&
                        snapshot.data!.favorites!.contains(storeId))
                    ? Icons.star
                    : Icons.star_border,
                size: 30,
                color: (snapshot.data != null &&
                        snapshot.data!.favorites != null &&
                        snapshot.data!.favorites!.isNotEmpty &&
                        snapshot.data!.favorites!.contains(storeId))
                    ? ColorConstants.instance.waitingColor
                    : ColorConstants.instance.primaryColor,
              ));
        });
  }
}
