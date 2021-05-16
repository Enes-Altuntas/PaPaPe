import 'package:bulovva/Models/campaing_model.dart';
import 'package:bulovva/Models/comments_model.dart';
import 'package:bulovva/Models/product.dart';
import 'package:bulovva/Models/product_category.dart';
import 'package:bulovva/Models/stores_model.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:bulovva/Services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: RatingBar.builder(
                            initialRating: 2.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Theme.of(context).primaryColor,
                            ),
                            onRatingUpdate: (value) {
                              setState(() {
                                rating = value;
                              });
                            },
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(fontFamily: 'Bebas', fontSize: 18.0),
            tabs: [
              Tab(
                text: 'Bilgiler',
              ),
              Tab(text: 'Kampanyalar'),
              Tab(text: 'Ürünler'),
            ],
          ),
          centerTitle: true,
          title: Text('Bulovva',
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Bebas',
                  color: Theme.of(context).primaryColor)),
        ),
        body: (isLoading == false)
            ? TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.multiply),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
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
                                fontSize:
                                    MediaQuery.of(context).size.height / 12,
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
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                makePhoneCall();
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
                                          fontFamily: 'Bebas'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                findPlace();
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
                                            fontFamily: 'Bebas')),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                openCommentDialog();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail, color: Colors.white),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Görüş Bildir',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Bebas'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<List<Campaign>>(
                    stream: FirestoreService().getStoreCampaigns(widget.docId),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState ==
                              ConnectionState.active)
                          ? (snapshot.data.length != 0)
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: (snapshot
                                                .data[index].campaignActive)
                                            ? Colors.green[800]
                                            : Theme.of(context).primaryColor,
                                        shadowColor:
                                            Theme.of(context).primaryColor,
                                        elevation: 10.0,
                                        child: ListTile(
                                          title: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              snapshot.data[index].campaignDesc,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Kampanya Başlangıç: ${formatDate(snapshot.data[index].campaignStart)}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'Kampanya Bitiş: ${formatDate(snapshot.data[index].campaignFinish)}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: (snapshot.data[index]
                                                              .campaignActive ==
                                                          false)
                                                      ? Text(
                                                          'Kampanya Anahtarı: #${snapshot.data[index].campaignKey}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            getCampaignCode(
                                                                snapshot
                                                                    .data[index]
                                                                    .campaignKey,
                                                                snapshot
                                                                    .data[index]
                                                                    .campaignId,
                                                                snapshot
                                                                    .data[index]
                                                                    .campaignCounter);
                                                          },
                                                          child: Text(
                                                            'Kampanya Kodu Al',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green[800],
                                                                fontFamily:
                                                                    'Bebas'),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.assignment_late_outlined,
                                            size: 100.0,
                                            color:
                                                Theme.of(context).primaryColor),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            'Henüz yayınlanmış herhangi bir kampanya bulunmamaktadır !',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                          : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            );
                    },
                  ),
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
