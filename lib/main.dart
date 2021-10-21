import 'package:bulovva/Login/login.dart';
import 'package:bulovva/Map/Map.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/services/authentication_service.dart';
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
              initialData: null,
              create: (context) => context.read<AuthService>().authStateChanges)
        ],
        child: MaterialApp(
            title: 'PaPaPe',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              cardTheme: CardTheme(
                  clipBehavior: Clip.antiAlias,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Colors.red[700],
                      width: 2.0,
                    ),
                  ),
                  color: Colors.white),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: Colors.red,
                  secondary: Colors.red[700],
                  onPrimary: Colors.white,
                  onSecondary: Colors.green[700]),
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
