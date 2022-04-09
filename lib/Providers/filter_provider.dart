import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  bool? live = false;
  bool? mode = false;
  String? category;
  double? distance;

  bool get getLive => live!;
  bool get getMode => mode!;
  String? get getCat => category;
  double? get getDist => distance;

  changeLive(bool value) {
    live = value;
    notifyListeners();
  }

  changeMode(bool value) {
    mode = value;
    notifyListeners();
  }

  changeCat(String value) {
    category = value;
    notifyListeners();
  }

  changeDistance(double value) {
    distance = value;
    notifyListeners();
  }
}
