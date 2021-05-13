import 'package:bulovva/Map/Map.dart';
import 'package:bulovva/Providers/filter_provider.dart';
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
        ChangeNotifierProvider(create: (context) => FilterProvider()),
      ],
      child: MaterialApp(
          title: 'Bulovva',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.red[700],
            primaryColorDark: Colors.black,
            accentColor: Colors.red,
          ),
          home: Map()),
    );
  }
}
