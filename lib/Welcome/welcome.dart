import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Introduction/introduction_screen.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:bulovva/Services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Constants/colors_constants.dart';
import '../Constants/localization_constants.dart';
import '../Providers/locale_provider.dart';
import '../Providers/user_provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController _name = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  ValidationService validationService = ValidationService();
  int _localeSelector = 0;

  String? nameValidation(String? value) {
    validationService.notNull(value, context);

    validationService.onlyLetters(value, context);

    return null;
  }

  saveUser() async {
    if (_key.currentState != null && _key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await FirestoreService().saveUser(_name.text);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Introduction()));
      context.read<UserProvider>().setName(_name.text);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: ColorConstants.instance.whiteContainer,
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (_localeSelector ==
                            LocalizationConstant.locals.length - 1) {
                          _localeSelector = 0;
                        } else {
                          _localeSelector += 1;
                        }
                      });
                      context.read<LocaleProvider>().setLocale(
                          LocalizationConstant.locals[_localeSelector].locale);
                    },
                    child: Text(
                        LocalizationConstant
                            .locals[_localeSelector].localeShort,
                        style: TextStyle(
                            color: ColorConstants.instance.primaryColor,
                            fontWeight: FontWeight.bold)))
              ],
              elevation: 0,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: ColorConstants.instance.whiteContainer,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset('assets/lottie/introduction1.json',
                            width: MediaQuery.of(context).size.width / 1.4),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            AppLocalizations.of(context)!.nameQuestion,
                            style: const TextStyle(fontSize: 17.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, left: 40.0, right: 40.0, bottom: 20.0),
                          child: TextFormField(
                            controller: _name,
                            validator: nameValidation,
                            maxLength: 25,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.name,
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              saveUser();
                            },
                            child: Text(
                                AppLocalizations.of(context)!.continueWord))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const ProgressWidget();
  }
}
