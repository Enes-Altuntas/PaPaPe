import 'package:bulb/Components/not_found.dart';
import 'package:bulb/Components/reservation_card.dart';
import 'package:bulb/Components/title.dart';
import 'package:bulb/Models/reservations_model.dart';
import 'package:bulb/services/firestore_service.dart';
import 'package:bulb/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyReservations extends StatefulWidget {
  const MyReservations({Key key}) : super(key: key);

  @override
  _MyReservationsState createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  bool isLoading = false;

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
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          ),
          elevation: 0,
          title: TitleApp(),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0))),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 5.0,
                        ),
                        child: Text(
                          'Rezervasyonlarım',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30.0,
                              fontFamily: 'Armatic',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: StreamBuilder<List<ReservationsModel>>(
                            stream: FirestoreService().getMyReservations(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.active:
                                  switch (snapshot.hasData &&
                                      snapshot.data.length > 0) {
                                    case true:
                                      return ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ReservationCard(
                                                reservation:
                                                    snapshot.data[index],
                                                onPressedCancel: () {
                                                  cancelReservation(snapshot
                                                      .data[index]
                                                      .reservationId);
                                                },
                                              ));
                                        },
                                      );
                                      break;
                                    default:
                                      return NotFound(
                                        notFoundIcon: FontAwesomeIcons.sadTear,
                                        notFoundIconColor:
                                            Theme.of(context).primaryColor,
                                        notFoundIconSize: 75,
                                        notFoundText:
                                            'Henüz işletmeniz adına herhangi bir rezervasyon bulunmamaktadır !',
                                        notFoundTextColor:
                                            Theme.of(context).primaryColor,
                                        notFoundTextSize: 30.0,
                                      );
                                  }
                                  break;
                                default:
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.amber[900],
                                  ));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}