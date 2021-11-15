import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Login/login.dart';
import 'package:bulovva/Map/Map.dart';
import 'package:bulovva/Models/user_model.dart';
import 'package:bulovva/Providers/user_provider.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User firebaseUser;
  UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    firebaseUser = context.watch<User>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser != null) {
      if ((firebaseUser.email != null && firebaseUser.emailVerified) ||
          firebaseUser.phoneNumber != null) {
        return FutureBuilder<UserModel>(
            future: context.read<AuthService>().userInformation,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  switch (snapshot.hasData) {
                    case true:
                      _userProvider.loadUserInfo(snapshot.data);
                      return const Map();
                      break;
                    default:
                      return const ProgressWidget();
                  }
                  break;
                default:
                  return const ProgressWidget();
              }
            });
      } else {
        return const Login();
      }
    } else {
      return const Login();
    }
  }
}
