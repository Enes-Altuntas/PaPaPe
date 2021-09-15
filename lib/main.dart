import 'package:papape/Login/login.dart';
import 'package:papape/Map/Map.dart';
import 'package:papape/Providers/filter_provider.dart';
import 'package:papape/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await init();
  runApp(MyApp());
}

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  handleNotifications();
}

handleNotifications() async {
  await firebaseMessaging.requestPermission(sound: true);
  await firebaseMessaging.subscribeToTopic("users");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FilterProvider()),
          Provider<AuthService>(
              create: (context) => AuthService(FirebaseAuth.instance)),
          StreamProvider(
              create: (context) => context.read<AuthService>().authStateChanges)
        ],
        child: MaterialApp(
            title: 'PaPaPe',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.lightBlue[800],
              primaryColorDark: Colors.black,
              accentColor: Colors.lightBlue[200],
              hintColor: Colors.grey.shade800,
            ),
            home: AuthWrapper()));
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();
    switch (firebaseUser != null && firebaseUser.emailVerified) {
      case true:
        return Map();
        break;
      default:
        return Login();
    }
  }
}
