import 'package:bulovva/Campaigns/campaigns.dart';
import 'package:bulovva/Components/favorite_button.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Products/products.dart';
import 'package:bulovva/Reservations/reservation.dart';
import 'package:bulovva/Store/store_info.dart';
import 'package:bulovva/Wishes/wish.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class Store extends StatefulWidget {
  final StoreModel storeData;

  Store({Key key, this.storeData}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  int _selectedIndex = 0;
  List<Icon> items = [
    Icon(
      Icons.add_alert,
      color: Colors.white,
    ),
    Icon(
      Icons.menu_book,
      color: Colors.white,
    ),
    Icon(
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
          toolbarHeight: 70.0,
          flexibleSpace: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: FavoriteButton(
                storeId: widget.storeData.storeId,
              ),
            )
          ],
          elevation: 5,
          centerTitle: true,
          title: TitleApp(),
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
                  color: Colors.amber[900],
                ),
              ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.call,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                backgroundColor: Colors.white,
                onTap: () {
                  makePhoneCall();
                },
                label: 'İşletmeyi Ara'),
            SpeedDialChild(
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  findPlace();
                },
                label: 'İşletmeyi Bul'),
            SpeedDialChild(
                child: Icon(
                  Icons.menu_book,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Reservation(
                            store: widget.storeData,
                          )));
                },
                backgroundColor: Colors.white,
                label: 'Rezervasyon Yaptır'),
            SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Wish(
                            store: widget.storeData,
                          )));
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                label: 'Dilek & Şikayet Yaz'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          height: 60.0,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeIn,
          animationDuration: Duration(milliseconds: 500),
          onTap: onTapped,
          index: _selectedIndex,
          color: Theme.of(context).colorScheme.secondary,
          buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        ));
  }
}
