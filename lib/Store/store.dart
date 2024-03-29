import 'package:myrest/Campaigns/campaigns.dart';
import 'package:myrest/Components/app_title.dart';
import 'package:myrest/Components/favorite_button.dart';
import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/store_model.dart';
import 'package:myrest/Products/products.dart';
import 'package:myrest/Reservations/reservation.dart';
import 'package:myrest/Store/store_info.dart';
import 'package:myrest/Wishes/wish.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Store extends StatefulWidget {
  final StoreModel storeData;

  const Store({Key? key, required this.storeData}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  int _selectedIndex = 0;
  List<Icon> items = [
    const Icon(
      Icons.add_alert,
      color: Colors.white,
    ),
    const Icon(
      Icons.menu_book,
      color: Colors.white,
    ),
    const Icon(
      Icons.store,
      color: Colors.white,
    )
  ];
  bool isLoading = false;

  makePhoneCall() async {
    await launch("tel:${widget.storeData.storePhone}");
  }

  findPlace() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 50.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: ColorConstants.instance.whiteContainer,
            ),
          ),
          iconTheme: IconThemeData(
            color: ColorConstants.instance.primaryColor,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: FavoriteButton(
                storeId: widget.storeData.storeId,
              ),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: const AppTitleWidget(),
        ),
        body: (isLoading == false)
            ? PageView(
                controller: pageController,
                children: [
                  Campaigns(
                    storeData: widget.storeData,
                  ),
                  Menu(
                    storeData: widget.storeData,
                  ),
                  StoreInfo(
                    storeData: widget.storeData,
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.instance.primaryColor,
                ),
              ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(
            color: ColorConstants.instance.iconOnColor,
          ),
          backgroundColor: ColorConstants.instance.textGold,
          overlayColor: ColorConstants.instance.hintColor,
          overlayOpacity: 0.8,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: ColorConstants.instance.whiteContainer,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Wish(
                            store: widget.storeData,
                          )));
                },
                backgroundColor: ColorConstants.instance.primaryColor,
                label: AppLocalizations.of(context)!.sendWishes),
            SpeedDialChild(
                child: Icon(
                  Icons.menu_book,
                  color: ColorConstants.instance.primaryColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Reservation(
                            store: widget.storeData,
                          )));
                },
                backgroundColor: ColorConstants.instance.whiteContainer,
                label: AppLocalizations.of(context)!.makeReservation),
            SpeedDialChild(
                child: Icon(
                  Icons.location_on,
                  color: ColorConstants.instance.whiteContainer,
                ),
                backgroundColor: ColorConstants.instance.primaryColor,
                onTap: () {
                  findPlace();
                },
                label: AppLocalizations.of(context)!.findBusiness),
            SpeedDialChild(
                child: Icon(
                  Icons.call,
                  color: ColorConstants.instance.primaryColor,
                ),
                backgroundColor: ColorConstants.instance.whiteContainer,
                onTap: () {
                  makePhoneCall();
                },
                label: AppLocalizations.of(context)!.callBusiness),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          height: 60.0,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 500),
          onTap: onTapped,
          index: _selectedIndex,
          color: ColorConstants.instance.primaryColor,
          buttonBackgroundColor: ColorConstants.instance.textGold,
        ));
  }
}
