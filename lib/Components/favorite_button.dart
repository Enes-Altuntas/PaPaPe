import 'package:papape/Models/user_model.dart';
import 'package:papape/services/firestore_service.dart';
import 'package:papape/services/toast_service.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final String storeId;
  const FavoriteButton({Key key, this.storeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
        stream: FirestoreService().getUserDetail(),
        builder: (context, snapshot) {
          return IconButton(
              onPressed: () {
                FirestoreService()
                    .manageFavorites(storeId, snapshot.data)
                    .onError((error, stackTrace) =>
                        ToastService().showError(error, context));
              },
              icon: Icon(
                Icons.star,
                size: 30,
                color: (snapshot.data != null &&
                        snapshot.data.favorites != null &&
                        snapshot.data.favorites.length > 0 &&
                        snapshot.data.favorites.contains(storeId)
                    ? Colors.amber[900]
                    : Colors.white),
              ));
        });
  }
}
