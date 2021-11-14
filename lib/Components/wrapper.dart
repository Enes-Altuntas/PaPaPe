import 'package:bulovva/Login/login.dart';
import 'package:bulovva/Map/Map.dart';
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

  @override
  void didChangeDependencies() {
    firebaseUser = context.watch<User>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser != null) {
      if ((firebaseUser.email != null && firebaseUser.emailVerified) ||
          firebaseUser.phoneNumber != null) {
        return const Map();
      } else {
        return const Login();
      }
    } else {
      return const Login();
    }
  }
}
