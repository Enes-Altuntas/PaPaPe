import 'package:bulb/Login/login.dart';
import 'package:bulb/Providers/filter_provider.dart';
import 'package:bulb/Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (context) => AuthService(FirebaseAuth.instance)),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
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
