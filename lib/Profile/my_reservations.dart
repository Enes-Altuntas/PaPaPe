import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/reservation_card.dart';
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
          toolbarHeight: 50.0,
          iconTheme: IconThemeData(
            color: ColorConstants.instance.primaryColor,
          ),
          elevation: 0,
          title: const AppTitleWidget(),
          centerTitle: true,
          flexibleSpace: Container(
            color: ColorConstants.instance.whiteContainer,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: ColorConstants.instance.whiteContainer,
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: StreamBuilder<List<ReservationsModel>>(
                stream: FirestoreService().getMyReservations(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      switch (snapshot.hasData && snapshot.data.isNotEmpty) {
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
                          return const NotFound(
                            notFoundIcon: FontAwesomeIcons.exclamationTriangle,
                            notFoundText:
                                'Üzgünüz, yapmış olduğunuz bir rezrvasyon bulunmamaktadır.',
                          );
                      }
                      break;
                    default:
                      return const ProgressWidget();
                  }
                },
              )),
        ));
  }
}
