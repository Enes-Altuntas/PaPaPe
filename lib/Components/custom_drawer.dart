import 'package:bulovva/Filter/filter.dart';
import 'package:bulovva/Login/login.dart';
import 'package:bulovva/Profile/my_favorites.dart';
import 'package:bulovva/Profile/my_reservations.dart';
import 'package:bulovva/Profile/my_wishes.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  exitYesNo(BuildContext context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: '',
        text: 'Çıkmak istediğinize emin misiniz ?',
        showCancelBtn: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        confirmBtnColor: Theme.of(context).colorScheme.primary,
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
    final User firebaseUser = context.watch<User>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: (firebaseUser.displayName != null)
                ? Text(firebaseUser.displayName)
                : Text('Kullanıcı'),
            accountEmail: Text(firebaseUser.email),
            currentAccountPicture: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Icon(
                Icons.person,
                size: 50.0,
                color: Colors.red[900],
              ),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.red[900],
              Colors.red,
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
          ),
          ListTile(
            leading: Icon(
              Icons.filter_alt_sharp,
              color: Colors.red[900],
            ),
            title: Text('Arama Filtrelerim'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Filter()));
            },
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.red[900],
            ),
            title: Text('Favori İşletmelerim'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyFavorites()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.menu_book,
              color: Colors.red[900],
            ),
            title: Text('Rezervasyonlarım'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyReservations()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.red[900],
            ),
            title: Text('Dilek & Şikayetlerim'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyWishes()));
            },
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.assignment_late,
              color: Colors.red[900],
            ),
            title: Text('KVK ve Gizlilik'),
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.red[900],
            ),
            title: Text('Çıkış Yap'),
            onTap: () {
              exitYesNo(context);
            },
          ),
        ],
      ),
    );
  }
}
