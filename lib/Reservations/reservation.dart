import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/reservations_model.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:bulovva/services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Reservation extends StatefulWidget {
  final StoreModel store;

  const Reservation({Key key, this.store}) : super(key: key);

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

  String _resDescCh(String value) {
    if (value.isEmpty) {
      return '* Rezervasyon açıklaması boş olmamalıdır !';
    }
    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ]')) != true) {
      return '* Harf içermelidir !';
    }

    return null;
  }

  String _resPersCount(String value) {
    if (value.isEmpty) {
      return '* Rezervasyon kişi sayısı boş olmamalıdır !';
    }

    if (value.contains(RegExp(r'[^\d]')) == true) {
      return '* Sadece rakam içermelidir !';
    }

    return null;
  }

  String _resFullName(String value) {
    if (value.isEmpty) {
      return '* Rezervasyon isim-soyisim boş olmamalıdır !';
    }
    if (value.contains(RegExp(r'[^a-zA-ZğüşöçİĞÜŞÖÇ ]')) == true) {
      return '* Sadece harf içermelidir !';
    }

    return null;
  }

  String _resDate(String value) {
    if (value.isEmpty) {
      return '* Rezervasyon tarihi boş olmamalıdır !';
    }

    return null;
  }

  String _resPhoneCh(String value) {
    if (value.isEmpty) {
      return '* Rezervasyon telefonu boş olmamalıdır !';
    }

    if (value.contains(RegExp(r'[^\d]')) == true) {
      return '* Sadece rakam içermelidir !';
    }

    return null;
  }

  saveReservation() {
    if (formKeyRes.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      ReservationsModel newReservation = ReservationsModel(
          reservationId: const Uuid().v4(),
          reservationDesc: _resDesc.text,
          reservationCount: int.parse(_resCount.text),
          reservationName: _resName.text,
          reservationPhone: _resPhone.text,
          reservationStatus: 'waiting',
          reservationUser: AuthService(FirebaseAuth.instance).getUserId(),
          reservationStore: widget.store.storeId,
          reservationStoreName: widget.store.storeName,
          reservationTime: resTime);

      FirestoreService()
          .saveReservation(newReservation)
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

  Future<DateTime> pickDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: initialDate,
        currentDate: DateTime.now(),
        locale: const Locale("tr", "TR"),
        lastDate: DateTime(DateTime.now().year + 10));

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 0),
      hourLabelText: 'Saat',
      minuteLabelText: 'Dakika',
      helpText: 'Saat/Dakika Giriniz',
      cancelText: 'İptal Et',
      confirmText: 'Tamam',
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child,
        );
      },
    );

    if (newTime == null) return null;

    return newTime;
  }

  Future<Timestamp> pickDateTime() async {
    final date = await pickDate();
    if (date == null) return null;

    final time = await pickTime();
    if (time == null) return null;

    DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    return Timestamp.fromDate(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading != true)
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                flexibleSpace: Container(
                  color: ColorConstants.instance.primaryColor,
                ),
                elevation: 0,
                centerTitle: true,
                title: const TitleWidget()),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                ColorConstants.instance.primaryColor,
                ColorConstants.instance.primaryColor,
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorConstants.instance.whiteContainer,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            key: formKeyRes,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      " * Rezervasyonunuz ile ilgili işletmenin bilmesi gereken spesifik bilgileri bu alana girmelisiniz.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              ColorConstants.instance.hintColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: TextFormField(
                                      controller: _resDesc,
                                      maxLength: 255,
                                      maxLines: 3,
                                      validator: _resDescCh,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
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
                                          color:
                                              ColorConstants.instance.hintColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: TextFormField(
                                      validator: _resPersCount,
                                      controller: _resCount,
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
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
                                          color:
                                              ColorConstants.instance.hintColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: TextFormField(
                                      validator: _resFullName,
                                      controller: _resName,
                                      maxLength: 50,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
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
                                          color:
                                              ColorConstants.instance.hintColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: TextFormField(
                                      validator: _resPhoneCh,
                                      controller: _resPhone,
                                      maxLength: 10,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
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
                                          color:
                                              ColorConstants.instance.hintColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      controller: _resTime,
                                      validator: _resDate,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Rezervasyon Tarihi',
                                          border: OutlineInputBorder()),
                                      onTap: () async {
                                        Timestamp resDate =
                                            await pickDateTime();
                                        if (resDate != null) {
                                          setState(() {
                                            resTime = resDate;
                                            _resTime.text = formatDate(resTime);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 60.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          gradient: LinearGradient(
                                              colors: [
                                                ColorConstants
                                                    .instance.primaryColor,
                                                ColorConstants
                                                    .instance.secondaryColor,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter)),
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
                                                  color: ColorConstants
                                                      .instance.iconOnColor,
                                                ),
                                              ),
                                              Text("Rezervasyon yaptır",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: ColorConstants
                                                          .instance.textOnColor,
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
              ),
            ))
        : const ProgressWidget();
  }
}
