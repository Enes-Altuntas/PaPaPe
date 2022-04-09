import 'package:bulovva/Constants/colors_constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToastService {
  showSuccess(msg, _context) {
    CoolAlert.show(
      context: _context,
      title: AppLocalizations.of(_context)!.congrats,
      backgroundColor: ColorConstants.instance.primaryColor,
      confirmBtnColor: ColorConstants.instance.primaryColor,
      barrierDismissible: false,
      type: CoolAlertType.success,
      confirmBtnText: AppLocalizations.of(_context)!.done,
      cancelBtnText: AppLocalizations.of(_context)!.back,
      text: msg,
    );
  }

  showWarning(msg, _context) {
    CoolAlert.show(
      context: _context,
      title: AppLocalizations.of(_context)!.warning,
      type: CoolAlertType.warning,
      backgroundColor: ColorConstants.instance.primaryColor,
      confirmBtnColor: ColorConstants.instance.primaryColor,
      barrierDismissible: false,
      confirmBtnText: AppLocalizations.of(_context)!.done,
      cancelBtnText: AppLocalizations.of(_context)!.back,
      text: msg,
    );
  }

  showError(msg, _context) {
    CoolAlert.show(
      context: _context,
      title: AppLocalizations.of(_context)!.error,
      type: CoolAlertType.error,
      backgroundColor: ColorConstants.instance.primaryColor,
      confirmBtnColor: ColorConstants.instance.primaryColor,
      barrierDismissible: false,
      confirmBtnText: AppLocalizations.of(_context)!.done,
      cancelBtnText: AppLocalizations.of(_context)!.back,
      text: msg,
    );
  }

  showInfo(msg, _context) {
    CoolAlert.show(
      context: _context,
      title: AppLocalizations.of(_context)!.info,
      type: CoolAlertType.info,
      backgroundColor: ColorConstants.instance.primaryColor,
      confirmBtnColor: ColorConstants.instance.primaryColor,
      barrierDismissible: false,
      confirmBtnText: AppLocalizations.of(_context)!.done,
      cancelBtnText: AppLocalizations.of(_context)!.back,
      text: msg,
    );
  }
}
