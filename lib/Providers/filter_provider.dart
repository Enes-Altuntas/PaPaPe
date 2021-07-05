import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  bool live;
  bool mode;
  String category;
  String altCategory;
  double distance;

  bool get getLive => live;
  bool get getMode => mode;
  String get getCat => category;
  String get getAltCat => altCategory;
  double get getDist => distance;

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

  changeAltCat(String value) {
    altCategory = value;
    notifyListeners();
  }

  changeDistance(double value) {
    distance = value;
    notifyListeners();
  }
}
