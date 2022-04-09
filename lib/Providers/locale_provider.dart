import 'package:bulovva/Constants/localization_constants.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = LocalizationConstant.trLocale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
