import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Filter/filter.dart';
import 'package:bulovva/Login/login.dart';
import 'package:bulovva/Profile/my_campaigns.dart';
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
        backgroundColor: ColorConstants.instance.primaryColor,
        confirmBtnColor: ColorConstants.instance.primaryColor,
        cancelBtnText: 'Hayır',
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        },
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          context.read<AuthService>().signOut().then((value) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Login()));
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
                ? Text('Hoşgeldiniz ${firebaseUser.displayName}',
                    style: TextStyle(color: ColorConstants.instance.textGold))
                : Text('Hoşgeldiniz',
                    style: TextStyle(color: ColorConstants.instance.textGold)),
            accountEmail: Text(firebaseUser.email),
            currentAccountPicture: (firebaseUser.photoURL == null)
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.instance.whiteContainer,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50.0,
                      color: ColorConstants.instance.primaryColor,
                    ),
                  )
                : CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(firebaseUser.photoURL),
                    backgroundColor: Colors.transparent,
                  ),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ColorConstants.instance.primaryColor,
              ColorConstants.instance.secondaryColor,
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
          ),
          ListTile(
            leading: Icon(
              Icons.filter_alt_sharp,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('Arama Filtrelerim'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Filter()));
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('Favori İşletmelerim'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyFavorites()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.qr_code,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('QR Kodlarım'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyCampaigns()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.menu_book,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('Rezervasyonlarım'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyReservations()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('Dilek & Şikayetlerim'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyWishes()));
            },
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.assignment_late,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('KVKK ve Gizlilik'),
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: ColorConstants.instance.primaryColor,
            ),
            title: const Text('Çıkış Yap'),
            onTap: () {
              exitYesNo(context);
            },
          ),
        ],
      ),
    );
  }
}
