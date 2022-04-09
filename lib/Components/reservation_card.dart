import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/reservations_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationCard extends StatefulWidget {
  final ReservationsModel reservation;
  final VoidCallback onPressedCancel;

  const ReservationCard(
      {Key? key, required this.reservation, required this.onPressedCancel})
      : super(key: key);

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: ColorConstants.instance.primaryColor,
          width: 1.0,
        ),
      ),
      color: ColorConstants.instance.whiteContainer,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            AppLocalizations.of(context)!.name +
                ': ${widget.reservation.reservationName}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstants.instance.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: (widget.reservation.reservationStatus == 'waiting')
                      ? ColorConstants.instance.waitingColor
                      : (widget.reservation.reservationStatus == 'approved')
                          ? ColorConstants.instance.activeColor
                          : ColorConstants.instance.inactiveColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context)!.resStatus +
                        ': ${(widget.reservation.reservationStatus == 'waiting') ? AppLocalizations.of(context)!.waiting : (widget.reservation.reservationStatus == 'approved') ? AppLocalizations.of(context)!.approved : (widget.reservation.reservationStatus == 'canceled') ? AppLocalizations.of(context)!.canceled : AppLocalizations.of(context)!.rejected}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.instance.textOnColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  AppLocalizations.of(context)!.businessName +
                      ': ${widget.reservation.reservationStoreName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.resCount +
                      ': ${widget.reservation.reservationCount.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.resDesc +
                      ': ${(widget.reservation.reservationDesc)}',
                  style: TextStyle(
                    color: ColorConstants.instance.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.resPhone +
                        ': +90${widget.reservation.reservationPhone}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstants.instance.hintColor,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                    AppLocalizations.of(context)!.resDate +
                        ': ${formatDate(widget.reservation.reservationTime)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorConstants.instance.hintColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0)),
              ),
              Visibility(
                visible: widget.reservation.reservationStatus == 'canceled'
                    ? false
                    : true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstants.instance.inactiveColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0))),
                          child: TextButton(
                              onPressed: widget.onPressedCancel,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.thumbsDown,
                                      color:
                                          ColorConstants.instance.iconOnColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.cancelRes,
                                      style: TextStyle(
                                        color:
                                            ColorConstants.instance.textOnColor,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
