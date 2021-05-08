import 'package:bulovva/Map/Map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bulovva',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red[700],
          primaryColorDark: Colors.black,
          accentColor: Colors.red,
        ),
        home: Map());
  }
}
