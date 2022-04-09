import 'package:bulovva/Models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _userId;
  String? _iToken;
  String? _storeId;
  String? _token;
  Locale? locale;
  List? _favorites = [];
  List? _campaignCodes = [];
  List _roles = [];

  String? get name => _name;
  String? get userId => _userId;
  String? get iToken => _iToken;
  String? get token => _token;
  String? get storeId => _storeId;
  List? get favorites => _favorites;
  List? get campaignCodes => _campaignCodes;
  List get roles => _roles;

  free() {
    _name = null;
    _userId = null;
    _iToken = null;
    _token = null;
    _storeId = null;
    _favorites = [];
    _campaignCodes = [];
    _roles = [];
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  UserModel getUserFromProvider() {
    UserModel _user = UserModel(
        campaignCodes: _campaignCodes,
        favorites: _favorites,
        iToken: _iToken,
        token: _token,
        name: _name!,
        roles: _roles,
        storeId: _storeId,
        userId: _userId!);
    return _user;
  }

  loadUserInfo(UserModel user) {
    _name = user.name;
    _userId = user.userId;
    _iToken = user.iToken;
    _token = user.token;
    _storeId = user.storeId;
    _favorites = user.favorites;
    _campaignCodes = user.campaignCodes;
    _roles = user.roles;
  }
}
