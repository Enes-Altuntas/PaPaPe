import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Constants/localization_constants.dart';
import 'package:bulovva/Filter/filter.dart';
import 'package:bulovva/Profile/my_campaigns.dart';
import 'package:bulovva/Profile/my_favorites.dart';
import 'package:bulovva/Profile/my_reservations.dart';
import 'package:bulovva/Profile/my_wishes.dart';
import 'package:bulovva/Providers/locale_provider.dart';
import 'package:bulovva/Providers/user_provider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? selectedLanguageName;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        setState(() {
          selectedLanguageName = LocalizationConstant.locals
              .firstWhere((element) =>
                  element.locale == context.read<LocaleProvider>().locale)
              .localeName;
        });
      },
    );
  }

  exitYesNo(BuildContext context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: '',
        text: AppLocalizations.of(context)!.wannaQuit,
        showCancelBtn: true,
        backgroundColor: ColorConstants.instance.primaryColor,
        confirmBtnColor: ColorConstants.instance.primaryColor,
        cancelBtnText: AppLocalizations.of(context)!.no,
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        },
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          context.read<UserProvider>().free();
          FirebaseAuth.instance.signOut();
        },
        barrierDismissible: false,
        confirmBtnText: AppLocalizations.of(context)!.yes);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: (context.read<UserProvider>().name != null)
                ? Text(
                    AppLocalizations.of(context)!.welcome +
                        ' ' +
                        context.read<UserProvider>().name!,
                    style: TextStyle(
                        color: ColorConstants.instance.textGold,
                        fontWeight: FontWeight.bold),
                  )
                : Text(
                    AppLocalizations.of(context)!.welcome,
                    style: TextStyle(
                        color: ColorConstants.instance.textGold,
                        fontWeight: FontWeight.bold),
                  ),
            accountEmail: Text(FirebaseAuth.instance.currentUser!.email ??
                FirebaseAuth.instance.currentUser!.phoneNumber!),
            currentAccountPicture:
                (FirebaseAuth.instance.currentUser!.photoURL == null)
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
                        backgroundImage: NetworkImage(
                            FirebaseAuth.instance.currentUser!.photoURL!),
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
            title: Text(AppLocalizations.of(context)!.searchFilters),
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
            title: Text(AppLocalizations.of(context)!.favoriteBusinesses),
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
            title: Text(AppLocalizations.of(context)!.myCampaignCodes),
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
            title: Text(AppLocalizations.of(context)!.myReservations),
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
            title: Text(AppLocalizations.of(context)!.myWishes),
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
            title: Text(AppLocalizations.of(context)!.kvkk),
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: ColorConstants.instance.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              exitYesNo(context);
            },
          ),
          ListTile(
            title: DropdownButton(
              onChanged: (String? value) {
                setState(() {
                  selectedLanguageName = value;
                  context.read<LocaleProvider>().setLocale(LocalizationConstant
                      .locals
                      .firstWhere((element) => element.localeName == value)
                      .locale);
                });
              },
              value: selectedLanguageName,
              isExpanded: true,
              icon: const Icon(Icons.language),
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(
                    child: Text(LocalizationConstant.trName),
                    value: LocalizationConstant.trName),
                DropdownMenuItem(
                    child: Text(LocalizationConstant.enName),
                    value: LocalizationConstant.enName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
