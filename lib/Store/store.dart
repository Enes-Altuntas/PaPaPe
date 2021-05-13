import 'package:bulovva/Models/campaing_model.dart';
import 'package:bulovva/Models/stores_model.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Store extends StatefulWidget {
  final StoreModel storeData;

  Store({Key key, this.storeData}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  Future getCampaign;
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  @override
  Future<void> didChangeDependencies() async {
    getCampaign = _getCampaing();
    super.didChangeDependencies();
  }

  Future<Campaign> _getCampaing() async {
    return await FirestoreService()
        .getCampaign(widget.storeData.storeId)
        .then((value) {
      return Campaign.fromFirestore(value.docs[0].data());
    });
  }

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Bulovva',
              style: TextStyle(
                  fontSize: 25.0, fontFamily: 'Bebas', color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.multiply),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.red),
                      child: Image.network(
                        widget.storeData.storePicRef,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Text(
                    widget.storeData.storeName,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Bebas',
                      fontSize: MediaQuery.of(context).size.height / 12,
                      shadows: <Shadow>[
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        print('Bas1');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call, color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'İşletmeyi Ara',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print('Bas2');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Haritada Göster',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 30),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_tree_outlined,
                            color: Theme.of(context).primaryColor),
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: (widget.storeData.storeAltCategory != null)
                              ? Text(
                                  'İşletme Sektörü: ${widget.storeData.storeCategory} / ${widget.storeData.storeAltCategory}',
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  'İşletme Sektörü: ${widget.storeData.storeCategory}',
                                  textAlign: TextAlign.center,
                                ),
                        ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Theme.of(context).primaryColor),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Adres: ${widget.storeData.storeAddress}',
                              textAlign: TextAlign.center,
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: FutureBuilder(
                          future: getCampaign,
                          builder: (BuildContext context, snapshotCampaign) {
                            return (snapshotCampaign.connectionState ==
                                    ConnectionState.done)
                                ? (snapshotCampaign.hasData == true)
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: 30.0, top: 30.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                    snapshotCampaign
                                                        .data.campaignDesc,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                    'Kampanya Başlangıç : ${formatDate(snapshotCampaign.data.campaignStart)}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              Text(
                                                  'Kampanya Bitiş : ${formatDate(snapshotCampaign.data.campaignFinish)}',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      primary: Colors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .accusoft,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(
                                                              'Kampanya Kodu Al',
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: FaIcon(
                                              FontAwesomeIcons.sadTear,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          Text('Üzgünüz',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Bebas')),
                                          Center(
                                            child: Text(
                                                'Bu işletmenin henüz yayınlamış olduğu bir kampanya bulunmamaktadır !',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: 'Bebas')),
                                          ),
                                        ],
                                      )
                                : Center(
                                    child: CircularProgressIndicator(
                                        backgroundColor: Colors.white),
                                  );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
