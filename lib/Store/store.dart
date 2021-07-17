import 'package:bulovva/Info/info.dart';
import 'package:bulovva/Models/campaign_model.dart';
import 'package:bulovva/Models/comments_model.dart';
import 'package:bulovva/Models/product.dart';
import 'package:bulovva/Models/product_category.dart';
import 'package:bulovva/Models/stores_model.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:bulovva/Services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class Store extends StatefulWidget {
  final StoreModel storeData;
  final String docId;

  Store({Key key, this.storeData, this.docId}) : super(key: key);

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

  getCampaignCode(String campaignCode, String campaignId, int campaignCounter) {
    setState(() {
      isLoading = true;
    });
    campaignCounter = campaignCounter + 1;
    FirestoreService()
        .updateCounter(widget.docId, campaignId, campaignCounter, campaignCode)
        .then((value) => ToastService().showSuccess(value, context))
        .onError(
            (error, stackTrace) => ToastService().showError(error, context))
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  makePhoneCall() async {
    await launch("tel:${widget.storeData.storePhone}");
  }

  findPlace() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  sendComment() {
    if (rating == null) {
      setState(() {
        rating = 2.5;
      });
    }
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Comments comment = Comments(
          createdAt: Timestamp.fromDate(DateTime.now()),
          reportDesc: commentDesc.text,
          reportId: Uuid().v4(),
          reportTitle: commentTitle.text,
          reportScore: rating.toString());

      FirestoreService()
          .saveComment(widget.docId, comment)
          .then((value) => ToastService().showSuccess(value, context))
          .onError(
              (error, stackTrace) => ToastService().showError(error, context))
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });

      Navigator.of(context).pop();
      setState(() {
        commentTitle.text = '';
        commentDesc.text = '';
        rating = null;
      });
    }
  }

  String validateTitle(String value) {
    if (value.isEmpty) {
      return '* Başlık boş olmamalıdır !';
    }
    if (value.contains(RegExp(r'[a-zA-Z\d]')) != true) {
      return '* Harf veya rakam içermelidir !';
    }

    return null;
  }

  String validateDesc(String value) {
    if (value.isEmpty) {
      return '* Tanım boş olmamalıdır !';
    }

    if (value.contains(RegExp(r'[a-zA-Z\d]')) != true) {
      return '* Harf veya rakam içermelidir !';
    }

    return null;
  }

  openCommentDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Görüş Bildir',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    setState(() {
                      commentTitle.text = '';
                      commentDesc.text = '';
                      rating = null;
                    });
                    Navigator.of(_context).pop();
                  },
                )
              ],
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            child: RatingBar.builder(
                              initialRating: 2.5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              onRatingUpdate: (value) {
                                setState(() {
                                  rating = value;
                                });
                              },
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          controller: commentTitle,
                          maxLength: 30,
                          validator: validateTitle,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Görüş Başlığı',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          controller: commentDesc,
                          maxLines: 3,
                          maxLength: 255,
                          validator: validateDesc,
                          decoration: InputDecoration(
                              labelText: 'Görüş Açıklaması',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(_context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              sendComment();
                            },
                            child: Text('Gönder'),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.info, color: Colors.white),
              ),
              Tab(icon: FaIcon(FontAwesomeIcons.tags, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bookOpen, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bullhorn, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white)),
            ],
          ),
          centerTitle: true,
          title: Text('Bulb',
              style: TextStyle(
                  fontSize: 45.0,
                  fontFamily: 'Armatic',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: (isLoading == false)
            ? TabBarView(
                children: [
                  Info(storeData: widget.storeData),
                  StreamBuilder<List<ProductCategory>>(
                    stream:
                        FirestoreService().getProductCategories(widget.docId),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState ==
                              ConnectionState.active)
                          ? (snapshot.hasData == true)
                              ? (snapshot.data.length > 0)
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              8,
                                          color: (index % 2 == 0)
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data[index]
                                                            .categoryName,
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontFamily: 'Bebas',
                                                            color: (index % 2 !=
                                                                    0)
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                StreamBuilder<List<Product>>(
                                                    stream: FirestoreService()
                                                        .getProducts(
                                                            widget.docId,
                                                            snapshot.data[index]
                                                                .categoryId),
                                                    builder: (context,
                                                        snapshotProduct) {
                                                      return (snapshotProduct
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .active)
                                                          ? (snapshotProduct
                                                                      .hasData ==
                                                                  true)
                                                              ? (snapshotProduct
                                                                          .data
                                                                          .length >
                                                                      0)
                                                                  ? ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: snapshotProduct
                                                                              .data
                                                                              .length,
                                                                          itemBuilder: (context,
                                                                              indexDishes) {
                                                                            return Card(
                                                                              color: (index % 2 != 0) ? Theme.of(context).primaryColor : Colors.white,
                                                                              child: ListTile(
                                                                                onTap: () {},
                                                                                title: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      snapshotProduct.data[indexDishes].productName,
                                                                                      style: TextStyle(color: (index % 2 != 0) ? Colors.white : Theme.of(context).hintColor),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                trailing: Column(
                                                                                  children: [
                                                                                    Text('Fiyat: ${snapshotProduct.data[indexDishes].productPrice} ${snapshotProduct.data[indexDishes].currency}', style: TextStyle(color: (index % 2 != 0) ? Colors.white : Theme.of(context).hintColor)),
                                                                                  ],
                                                                                ),
                                                                                subtitle: Padding(
                                                                                  padding: const EdgeInsets.only(top: 8.0),
                                                                                  child: Text(snapshotProduct.data[indexDishes].productDesc, style: TextStyle(color: (index % 2 != 0) ? Colors.white : Theme.of(context).hintColor)),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          })
                                                                  : Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.assignment_late_outlined,
                                                                            size:
                                                                                30.0,
                                                                            color: (index % 2 != 0)
                                                                                ? Theme.of(context).primaryColor
                                                                                : Colors.white,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 20.0),
                                                                            child:
                                                                                Text(
                                                                              'Henüz kategori için girilmiş bir ürün bulunmamaktadır !',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: (index % 2 != 0) ? Theme.of(context).primaryColor : Colors.white, fontSize: 20.0),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                              : Center(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .assignment_late_outlined,
                                                                        size:
                                                                            30.0,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 20.0),
                                                                        child:
                                                                            Text(
                                                                          'Henüz bu kategori için girilmiş bir ürün bulunmamaktadır !',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(fontSize: 15.0),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                    }),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.assignment_late_outlined,
                                            size: 100.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              'Henüz kaydedilmiş bir kategori bulunmamaktadır !',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.assignment_late_outlined,
                                        size: 100.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Henüz kaydedilmiş bir kategori bulunmamaktadır !',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 25.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            );
                    },
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
      ),
    );
  }
}
