import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValidationService {
  String? notNull(String? value, BuildContext context) {
    if (value != null && value.isEmpty) {
      return AppLocalizations.of(context)!.cantBeNull;
    }

    return null;
  }

  String? onlyNumbers(String? value, BuildContext context) {
    if (value != null && value.contains(RegExp(r'[^\d]')) == true) {
      return AppLocalizations.of(context)!.onlyNumbers;
    }

    return null;
  }

  String? onlyLetters(String? value, BuildContext context) {
    if (value != null &&
        value.contains(RegExp(r'[^a-zA-ZğüşöçİĞÜŞÖÇ ]')) == true) {
      return AppLocalizations.of(context)!.onlyLetter;
    }

    return null;
  }

  String? containLetter(String? value, BuildContext context) {
    if (value != null &&
        value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ]')) != true) {
      return AppLocalizations.of(context)!.containLetter;
    }

    return null;
  }
}
