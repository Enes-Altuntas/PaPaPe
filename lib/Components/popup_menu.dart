import 'package:bulb/Login/login.dart';
import 'package:bulb/Profile/MyFavorites.dart';
import 'package:bulb/Profile/MyReservations.dart';
import 'package:bulb/Profile/MyWishes.dart';
import 'package:bulb/services/authentication_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PopUpWidget extends StatelessWidget {
  const PopUpWidget({Key key}) : super(key: key);

  exitYesNo(BuildContext context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: '',
        text: 'Çıkmak istediğinize emin misiniz ?',
        showCancelBtn: true,
        backgroundColor: Theme.of(context).primaryColor,
        confirmBtnColor: Theme.of(context).primaryColor,
        cancelBtnText: 'Hayır',
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        },
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          context.read<AuthService>().signOut().then((value) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          });
        },
        barrierDismissible: false,
        confirmBtnText: 'Evet');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 1:
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyFavorites()));
              break;
            case 2:
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyReservations()));
              break;
            case 3:
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyWishes()));
              break;
            case 4:
              exitYesNo(context);
              break;
          }
        },
        itemBuilder: (contect) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: [Text("Favorilerim")],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: [Text("Rezervasyonlarım")],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: [Text("Dilek & Şikayetlerim")],
              )),
          PopupMenuItem(
              value: 4,
              child: Row(
                children: [Text("Çıkış Yap")],
              ))
        ],
        child: Icon(Icons.more_vert),
      ),
    );
  }
}
