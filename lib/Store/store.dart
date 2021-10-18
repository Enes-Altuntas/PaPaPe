import 'package:bulovva/Campaigns/campaigns.dart';
import 'package:bulovva/Components/favorite_button.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Products/products.dart';
import 'package:bulovva/Store/store_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Store extends StatefulWidget {
  final StoreModel storeData;

  Store({Key key, this.storeData}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentTitle = TextEditingController();
  final TextEditingController commentDesc = TextEditingController();
  double rating;
  bool isLoading = false;

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  makePhoneCall() async {
    await launch("tel:${widget.storeData.storePhone}");
  }

  findPlace() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
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
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.tags, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bookOpen, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.store, color: Colors.white)),
            ],
          ),
          centerTitle: true,
          title: TitleApp(),
        ),
        body: (isLoading == false)
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).primaryColor
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0))),
                    child: TabBarView(
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
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[900],
                ),
              ),
      ),
    );
  }
}
