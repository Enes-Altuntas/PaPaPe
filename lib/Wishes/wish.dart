import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/gradient_button.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Models/wishes_model.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:bulovva/Services/toast_service.dart';
import 'package:bulovva/Services/validation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Wish extends StatefulWidget {
  final StoreModel store;

  const Wish({Key? key, required this.store}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Wish> {
  final TextEditingController _reportTitle = TextEditingController();
  final TextEditingController _reportDesc = TextEditingController();
  final TextEditingController _reportPhone = TextEditingController();
  GlobalKey<FormState> formKeyComment = GlobalKey<FormState>();
  ValidationService validationService = ValidationService();
  bool _isLoading = false;

  String? _validateComTitle(String? value) {
    return validationService.notNull(value, context) ??
        validationService.containLetter(value, context);
  }

  String? _validateComDesc(String? value) {
    return validationService.notNull(value, context) ??
        validationService.containLetter(value, context);
  }

  String? _validatePhone(String? value) {
    return validationService.onlyNumbers(value, context);
  }

  saveComment() {
    if (formKeyComment.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      WishesModel newComment = WishesModel(
          wishId: const Uuid().v4(),
          wishTitle: _reportTitle.text,
          wishDesc: _reportDesc.text,
          wishStore: widget.store.storeId,
          wishStoreName: widget.store.storeName,
          wishUserPhone: _reportPhone.text,
          wishUser: FirebaseAuth.instance.currentUser!.uid,
          createdAt: Timestamp.now());

      FirestoreService()
          .saveWish(newComment, context)
          .then((value) => ToastService().showSuccess(value, context))
          .onError(
              (error, stackTrace) => ToastService().showError(error, context))
          .whenComplete(() => setState(() {
                _isLoading = false;
              }));
      setState(() {
        _reportTitle.text = '';
        _reportDesc.text = '';
        _reportPhone.text = '';
      });
    }
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
                      key: formKeyComment,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                AppLocalizations.of(context)!.wishTitle,
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
                                controller: _reportTitle,
                                maxLength: 50,
                                validator: _validateComTitle,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.wishTitle,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text(
                                AppLocalizations.of(context)!.wishDescHint,
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
                                validator: _validateComDesc,
                                controller: _reportDesc,
                                keyboardType: TextInputType.text,
                                maxLength: 255,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.wishDesc,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text(
                                AppLocalizations.of(context)!.wishPhoneHint,
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
                                validator: _validatePhone,
                                controller: _reportPhone,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    prefix: const Text('+90'),
                                    labelText: AppLocalizations.of(context)!
                                        .conatactNum,
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 60.0),
                              child: GradientButton(
                                buttonText:
                                    AppLocalizations.of(context)!.sendWishes,
                                start: ColorConstants.instance.buttonDarkGold,
                                end: ColorConstants.instance.buttonLightColor,
                                icon: Icons.save,
                                onPressed: saveComment,
                                fontSize: 15,
                                widthMultiplier: 0.9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
        : const ProgressWidget();
  }
}
