import 'package:bulb/Login/login.dart';
import 'package:bulb/Providers/filter_provider.dart';
import 'package:bulb/Services/authentication_service.dart';
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
      ],
      child: MaterialApp(
          title: 'BULB',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.amber[900],
            primaryColorDark: Colors.black,
            accentColor: Colors.amber,
            hintColor: Colors.grey.shade800,
          ),
          home: Login()),
    );
  }
}
