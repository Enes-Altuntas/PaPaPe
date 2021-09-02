import 'package:bulb/Components/not_found.dart';
import 'package:bulb/Components/wish_card.dart';
import 'package:bulb/Wishes/wish.dart';
import 'package:bulb/Models/wishes_model.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Wishes extends StatefulWidget {
  final StoreModel storeData;

  Wishes({Key key, this.storeData}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Wishes> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  sendComment() async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Wish(store: widget.storeData)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
            'Dilek ve şikayet',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30.0,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextButton(
                child: Text("Dilek & Şikayet Gönder".toUpperCase(),
                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto')),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor)))),
                onPressed: () {
                  sendComment();
                }),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: StreamBuilder<List<WishesModel>>(
              stream: FirestoreService().getReports(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    switch (snapshot.hasData && snapshot.data.length > 0) {
                      case true:
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CommentCard(
                                  wish: snapshot.data[index],
                                ));
                          },
                        );
                        break;
                      default:
                        return NotFound(
                          notFoundIcon: FontAwesomeIcons.sadTear,
                          notFoundIconColor: Theme.of(context).primaryColor,
                          notFoundIconSize: 75,
                          notFoundText:
                              'Henüz işletmeniz adına hazırlanmış dilek veya şikayet bulunmamaktadır !',
                          notFoundTextColor: Theme.of(context).primaryColor,
                          notFoundTextSize: 30.0,
                        );
                    }
                    break;
                  default:
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
