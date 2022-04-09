import 'package:flutter/cupertino.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutterfire_ui/i10n.dart';

class LocalizationConstant {
  static const trLocale = Locale("tr", "TR");

  static const trName = "Türkçe";

  static const trShort = "TR";

  static const enLocale = Locale("en", "US");

  static const enName = "English";

  static const enShort = "EN";

  static const supportedLocals = [trLocale, enLocale];

  static const localePath = "assets/lang";

  static List<LocalizationsDelegate<Object>> localizationDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    AppLocalizations.delegate,
    FlutterFireUILocalizations.delegate,
  ];

  static final locals = [
    LocalsObjectModel(
        localeName: trName, locale: trLocale, localeShort: trShort),
    LocalsObjectModel(
        localeName: enName, locale: enLocale, localeShort: enShort),
  ];
}

class LocalsObjectModel {
  final String localeName;
  final Locale locale;
  final String localeShort;

  LocalsObjectModel(
      {required this.localeName,
      required this.locale,
      required this.localeShort});

  Map<String, dynamic> toMap() {
    return {
      'localeName': localeName,
      'locale': locale,
      'localeShort': localeShort
    };
  }
}
