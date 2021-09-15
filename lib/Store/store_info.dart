import 'dart:developer';

import 'package:papape/Components/gradient_button.dart';
import 'package:papape/Components/image_container.dart';
import 'package:papape/Models/store_model.dart';
import 'package:papape/Reservations/reservation.dart';
import 'package:papape/Wishes/wish.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreInfo extends StatefulWidget {
  final StoreModel storeData;

  StoreInfo({Key key, this.storeData}) : super(key: key);

  @override
  _StoreInfoState createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pers1 = TextEditingController();
  final TextEditingController pers2 = TextEditingController();
  final TextEditingController pers3 = TextEditingController();
  final TextEditingController pers1Phone = TextEditingController();
  final TextEditingController pers2Phone = TextEditingController();
  final TextEditingController pers3Phone = TextEditingController();
  bool _isLoading = false;
  bool isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      name.text = widget.storeData.storeName;
      address.text = widget.storeData.storeAddress;
      phone.text = widget.storeData.storePhone;
      pers1.text = widget.storeData.pers1;
      pers2.text = widget.storeData.pers2;
      pers3.text = widget.storeData.pers3;
      pers1Phone.text = widget.storeData.pers1Phone;
      pers2Phone.text = widget.storeData.pers2Phone;
      pers3Phone.text = widget.storeData.pers3Phone;
      setState(() {
        isInit = false;
      });
    }
  }

  makePhoneCall(phone) async {
    await launch("tel:$phone");
  }

  findPlace(lat, long) async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    await launch(googleMapslocationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? Column(
            children: [
              SizedBox(
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Genel Bilgiler',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                          fontFamily: 'Armatic',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CustomImageContainer(
                                addText: 'Resim Yok',
                                addable: false,
                                buttonVis: false,
                                localImage:
                                    widget.storeData.storeLocalImagePath,
                                urlImage: widget.storeData.storePicRef,
                                onPressedAdd: () {},
                                onPressedDelete: () {},
                                onPressedEdit: () {},
                              )),
                          GradientButton(
                              startColor: Colors.red[900],
                              finishColor: Colors.red[500],
                              buttonText: 'Rezervasyon',
                              icon: Icons.menu_book,
                              fontColor: Colors.white,
                              iconColor: Colors.white,
                              widthMultiplier: 0.9,
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Reservation(
                                          store: widget.storeData,
                                        )));
                              }),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 7.0, bottom: 7.0),
                              child: GradientButton(
                                startColor: Colors.green[900],
                                finishColor: Colors.green[500],
                                buttonText: 'Dilek & Şikayet',
                                iconColor: Colors.white,
                                fontColor: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                icon: FontAwesomeIcons.bullhorn,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Wish(
                                            store: widget.storeData,
                                          )));
                                },
                                widthMultiplier: 0.9,
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    onTap: () {},
                                    controller: name,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    decoration: InputDecoration(
                                        labelText: 'İşletme İsmi',
                                        icon: Icon(Icons.announcement_sharp),
                                        border: OutlineInputBorder()),
                                    maxLength: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    onTap: () {
                                      findPlace(widget.storeData.storeLocLat,
                                          widget.storeData.storeLocLong);
                                    },
                                    maxLength: 255,
                                    maxLines: 3,
                                    controller: address,
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    decoration: InputDecoration(
                                        labelText: 'İşletme Adresi',
                                        icon: Icon(Icons.add_location_rounded),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    controller: phone,
                                    onTap: () {
                                      makePhoneCall(
                                          widget.storeData.storePhone);
                                    },
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        labelText: 'İşletme Telefon Numarası',
                                        prefix: Text('+90'),
                                        icon: Icon(Icons.phone),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    controller: pers1,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.text,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                        labelText:
                                            'İlgili kişi isim-soyisim (1)',
                                        icon:
                                            Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    controller: pers1Phone,
                                    onTap: () {
                                      makePhoneCall(
                                          widget.storeData.pers1Phone);
                                    },
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        labelText: 'İlgili kişi telefon (1)',
                                        prefix: Text('+90'),
                                        icon: Icon(Icons.phone),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    controller: pers2,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.text,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                        labelText:
                                            'İlgili kişi isim-soyisim (2)',
                                        icon:
                                            Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    controller: pers2Phone,
                                    onTap: () {
                                      makePhoneCall(
                                          widget.storeData.pers2Phone);
                                    },
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        labelText: 'İlgili kişi telefon (2)',
                                        prefix: Text('+90'),
                                        icon: Icon(Icons.phone),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: pers3,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.text,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                        labelText:
                                            'İlgili kişi isim-soyisim (3)',
                                        icon:
                                            Icon(Icons.account_circle_outlined),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  child: TextFormField(
                                    controller: pers3,
                                    onTap: () {
                                      makePhoneCall(
                                          widget.storeData.pers3Phone);
                                    },
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context).hintColor),
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        labelText: 'İlgili kişi telefon (3)',
                                        prefix: Text('+90'),
                                        icon: Icon(Icons.phone),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.amber[900],
            ),
          );
  }
}
