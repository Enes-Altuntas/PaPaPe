import 'dart:ui';

import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/reservations_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReservationCard extends StatefulWidget {
  final ReservationsModel reservation;
  final Function onPressedCancel;

  const ReservationCard({Key key, this.reservation, this.onPressedCancel})
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
            'İsim-Soyisim: ${widget.reservation.reservationName}',
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
                    'Başvuru Durumu: ${(widget.reservation.reservationStatus == 'waiting') ? 'Beklemede' : (widget.reservation.reservationStatus == 'approved') ? 'Onaylanmış' : (widget.reservation.reservationStatus == 'canceled') ? 'İptal edilmiş' : 'Reddedilmiş'}',
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
                  'İşletme İsmi: ${widget.reservation.reservationStoreName}',
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
                  'Rezerve kişi sayısı: ${widget.reservation.reservationCount.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstants.instance.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Rezervasyon Açıklaması: ${(widget.reservation.reservationDesc)}',
                  style: TextStyle(
                    color: ColorConstants.instance.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Rez. Telefon: +90${widget.reservation.reservationPhone}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstants.instance.hintColor,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                    'Rezervasyon Tarihi: ${formatDate(widget.reservation.reservationTime)}',
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
                                      'Rezervasyonu İptal Et',
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
