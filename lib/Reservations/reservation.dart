import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/gradient_button.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/reservations_model.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:bulovva/Services/toast_service.dart';
import 'package:bulovva/Services/validation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Reservation extends StatefulWidget {
  final StoreModel store;

  const Reservation({Key? key, required this.store}) : super(key: key);

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
  ValidationService validationService = ValidationService();
  Timestamp? resTime;
  bool _isLoading = false;

  String? _resPersCount(String? value) {
    return validationService.notNull(value, context) ??
        validationService.onlyLetters(value, context);
  }

  String? _resFullName(String? value) {
    return validationService.notNull(value, context) ??
        validationService.onlyLetters(value, context);
  }

  String? _resDate(String? value) {
    return validationService.notNull(value, context);
  }

  String? _resPhoneCh(String? value) {
    return validationService.notNull(value, context) ??
        validationService.onlyLetters(value, context);
  }

  saveReservation() {
    if (formKeyRes.currentState!.validate()) {
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
          reservationUser: FirebaseAuth.instance.currentUser!.uid,
          reservationStore: widget.store.storeId,
          reservationStoreName: widget.store.storeName,
          reservationTime: resTime!);

      FirestoreService()
          .saveReservation(newReservation, context)
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
    return (_isLoading != true)
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                toolbarHeight: 50.0,
                flexibleSpace: Container(
                  color: ColorConstants.instance.whiteContainer,
                ),
                iconTheme: IconThemeData(
                  color: ColorConstants.instance.primaryColor,
                ),
                elevation: 0,
                centerTitle: true,
                title: const AppTitleWidget()),
            body: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ColorConstants.instance.whiteContainer,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKeyRes,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                AppLocalizations.of(context)!.resDescHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.instance.hintColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                controller: _resDesc,
                                maxLength: 255,
                                maxLines: 3,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.resDesc,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.resCountHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.instance.hintColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: _resPersCount,
                                controller: _resCount,
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.resCount,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.resNameHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.instance.hintColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: _resFullName,
                                controller: _resName,
                                maxLength: 50,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.name,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.resTelHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.instance.hintColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: _resPhoneCh,
                                controller: _resPhone,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    prefix: const Text('+90'),
                                    labelText: AppLocalizations.of(context)!
                                        .resPhoneBook,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.resDateHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.instance.hintColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TextFormField(
                                controller: _resTime,
                                validator: _resDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.resDate,
                                    border: const OutlineInputBorder()),
                                onTap: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .add(const Duration(minutes: 60)),
                                      maxTime: DateTime(2030, 1, 1),
                                      onConfirm: (date) {
                                    setState(() {
                                      resTime = Timestamp.fromDate(date);
                                      _resTime.text = formatDate(resTime!);
                                    });
                                  },
                                      currentTime: DateTime.now()
                                          .add(const Duration(minutes: 60)),
                                      locale: LocaleType.tr);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 60.0),
                              child: GradientButton(
                                buttonText: AppLocalizations.of(context)!
                                    .makeReservation,
                                start: ColorConstants.instance.buttonDarkGold,
                                end: ColorConstants.instance.buttonLightColor,
                                icon: Icons.save,
                                onPressed: saveReservation,
                                fontSize: 15,
                                widthMultiplier: 0.9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        : const ProgressWidget();
  }
}
