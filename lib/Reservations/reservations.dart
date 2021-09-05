import 'package:bulb/Components/not_found.dart';
import 'package:bulb/Components/reservation_card.dart';
import 'package:bulb/Models/reservations_model.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Reservations/reservation.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:bulb/Services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Reservations extends StatefulWidget {
  final StoreModel storeData;

  Reservations({Key key, this.storeData}) : super(key: key);

  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  bool isLoading = false;
  bool btnVis = true;

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  makePhoneCall(storePhone) async {
    await launch("tel:$storePhone");
  }

  sendReservation() async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Reservation(store: widget.storeData)));
  }

  cancelReservation(String resId) async {
    setState(() {
      isLoading = true;
    });
    FirestoreService()
        .cancelReservation(resId)
        .then((value) => ToastService().showSuccess(value, context))
        .onError(
            (error, stackTrace) => ToastService().showError(error, context))
        .whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 5.0,
          ),
          child: Text(
            'rezervasyonlar',
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
                child: Text("Rezervasyon Yaptır".toUpperCase(),
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
                  sendReservation();
                }),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: StreamBuilder<List<ReservationsModel>>(
              stream:
                  FirestoreService().getReservations(widget.storeData.storeId),
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
                                child: ReservationCard(
                                  reservation: snapshot.data[index],
                                  onPressedCancel: () {
                                    cancelReservation(
                                        snapshot.data[index].reservationId);
                                  },
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
                              'Henüz işletmeniz adına herhangi bir rezervasyon bulunmamaktadır !',
                          notFoundTextColor: Theme.of(context).primaryColor,
                          notFoundTextSize: 30.0,
                        );
                    }
                    break;
                  default:
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
