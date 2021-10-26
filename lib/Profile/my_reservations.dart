import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/reservation_card.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/reservations_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:bulovva/services/toast_service.dart';
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
            color: ColorConstants.instance.iconOnColor, //change your color here
          ),
          elevation: 0,
          title: const TitleApp(),
          centerTitle: true,
          flexibleSpace: Container(
            color: ColorConstants.instance.primaryColor,
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ColorConstants.instance.primaryColor,
            ColorConstants.instance.primaryColor,
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorConstants.instance.whiteContainer,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: StreamBuilder<List<ReservationsModel>>(
                    stream: FirestoreService().getMyReservations(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                          switch (
                              snapshot.hasData && snapshot.data.isNotEmpty) {
                            case true:
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ReservationCard(
                                        reservation: snapshot.data[index],
                                        onPressedCancel: () {
                                          cancelReservation(snapshot
                                              .data[index].reservationId);
                                        },
                                      ));
                                },
                              );
                              break;
                            default:
                              return NotFound(
                                notFoundIcon:
                                    FontAwesomeIcons.exclamationTriangle,
                                notFoundIconColor:
                                    ColorConstants.instance.primaryColor,
                                notFoundIconSize: 60,
                                notFoundText:
                                    'Üzgünüz, yapmış olduğunuz bir rezrvasyon bulunmamaktadır.',
                                notFoundTextColor:
                                    ColorConstants.instance.hintColor,
                                notFoundTextSize: 40.0,
                              );
                          }
                          break;
                        default:
                          return const ProgressWidget();
                      }
                    },
                  )),
            ),
          ),
        ));
  }
}
