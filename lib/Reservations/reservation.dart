import 'package:bulb/Models/reservations_model.dart';
import 'package:bulb/Services/authentication_service.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:bulb/Services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Reservation extends StatefulWidget {
  final String storeId;

  Reservation({Key key, this.storeId}) : super(key: key);

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  final TextEditingController _resDesc = TextEditingController();
  final TextEditingController _resName = TextEditingController();
  final TextEditingController _resPhone = TextEditingController();
  final TextEditingController _resCount = TextEditingController();
  final TextEditingController _resTime = TextEditingController();
  GlobalKey<FormState> formKeyRes = GlobalKey<FormState>();
  Timestamp resTime;
  bool _isLoading = false;

  String _validateCatRow(String value) {
    if (value.isEmpty) {
      return '* Dilek & Şikayet başlığı boş olmamalıdır !';
    }
    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ\d]')) != true) {
      return '* Harf veya rakam içermelidir !';
    }

    return null;
  }

  String _validateCatName(String value) {
    if (value.isEmpty) {
      return '* Dilek & Şikayet açıklaması boş olmamalıdır !';
    }

    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ\d]')) != true) {
      return '* Harf veya rakam içermelidir !';
    }

    return null;
  }

  saveReservation() {
    if (formKeyRes.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      ReservationModel newReservation = ReservationModel(
          reservationId: Uuid().v4(),
          reservationDesc: _resDesc.text,
          reservationCount: int.parse(_resCount.text),
          reservationName: _resName.text,
          reservationPhone: _resPhone.text,
          reservationStatus: 'waiting',
          reservationUser: AuthService(FirebaseAuth.instance).getUserId(),
          reservationTime: resTime);

      FirestoreService()
          .saveReservation(widget.storeId, newReservation)
          .then((value) => ToastService().showSuccess(value, context))
          .onError(
              (error, stackTrace) => ToastService().showError(error, context))
          .whenComplete(() => setState(() {
                _isLoading = false;
              }));
      setState(() {
        _resDesc.text = '';
        _resCount.text = '';
        _resName.text = '';
        _resPhone.text = '';
        _resTime.text = '';
        resTime = null;
      });
    }
  }

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text('bulb',
            style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold)),
      ),
      body: (_isLoading == false)
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor
              ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: formKeyRes,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    " * Rezervasyonunuz ile ilgili işletmenin bilmesi gereken spesifik bilgileri bu alana girmelisiniz.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    controller: _resDesc,
                                    maxLength: 255,
                                    maxLines: 3,
                                    validator: _validateCatRow,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        labelText: 'Rezervasyon Açıklaması',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    " * Rezerve kişi sayısı, işletmenin, rezervasyonun kaç kişi adına yapılacağını bilmesine olanak sağlar.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    validator: _validateCatName,
                                    controller: _resCount,
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Rezerve Kişi Sayısı',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    " * Rezerve isim soyisim alanı, rezervasyonun hangi isim ve soyisim üzerine yapılacağını iletmek içindir.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    validator: _validateCatName,
                                    controller: _resName,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        labelText: 'Rezerve İsim-Soyisim',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    " * Rezervasyon telefonu, işletmenin önemli bir durumda size hangi numaradan ulaşacağını bilmesini sağlamak içindir.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    validator: _validateCatName,
                                    controller: _resPhone,
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        prefix: Text('+90'),
                                        labelText: 'Rezervasyon Telefonu',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    " * Rezervasyon tarihi, rezervasyonunuz hangi tarih ve saat için olduğunu anlatır",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: TextFormField(
                                    controller: _resTime,
                                    validator: _validateCatName,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        labelText: 'Rezervasyon Tarihi',
                                        border: OutlineInputBorder()),
                                    onTap: () {
                                      DatePicker.showDateTimePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime.now()
                                              .add(new Duration(minutes: 60)),
                                          maxTime: DateTime(2030, 1, 1),
                                          onConfirm: (date) {
                                        setState(() {
                                          resTime = Timestamp.fromDate(date);
                                          _resTime.text = formatDate(resTime);
                                        });
                                      },
                                          currentTime: DateTime.now()
                                              .add(new Duration(minutes: 60)),
                                          locale: LocaleType.tr);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 60.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft)),
                                    child: TextButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                Icons.save,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text("Rezervasyon yaptır",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    fontFamily: 'Bebas')),
                                          ],
                                        ),
                                        onPressed: () {
                                          saveReservation();
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
