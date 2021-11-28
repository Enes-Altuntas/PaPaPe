import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Login/login.dart';
import 'package:bulovva/Map/Map.dart';
import 'package:bulovva/Models/user_model.dart';
import 'package:bulovva/Providers/user_provider.dart';
import 'package:bulovva/services/firestore_service.dart';
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
    return (firebaseUser != null)
        ? (firebaseUser.email == null ||
                (firebaseUser.email != null && firebaseUser.emailVerified))
            ? StreamBuilder<UserModel>(
                stream: FirestoreService().userInformation(firebaseUser),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      switch (snapshot.hasData) {
                        case true:
                          _userProvider.loadUserInfo(snapshot.data);
                          return const Map();
                          break;
                        default:
                          return const Login();
                      }
                      break;
                    default:
                      return const ProgressWidget();
                  }
                })
            : const Login()
        : const Login();
  }
}
