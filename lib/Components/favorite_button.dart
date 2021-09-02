import 'package:bulb/services/firestore_service.dart';
import 'package:bulb/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteButton extends StatefulWidget {
  final String storeId;

  FavoriteButton({Key key, this.storeId}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  Color color;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreService().isFavorite(widget.storeId),
        builder: (BuildContext context, snapshotData) {
          return IconButton(
              onPressed: () {
                FirestoreService()
                    .manageFavorites(widget.storeId)
                    .then((value) {
                  ToastService().showSuccess(value, context);
                  setState(() {
                    color = Colors.green;
                  });
                }).onError((error, stackTrace) =>
                        ToastService().showError(error, context));
              },
              icon: FaIcon(
                FontAwesomeIcons.star,
                color: this.color,
              ));
        });
  }
}
