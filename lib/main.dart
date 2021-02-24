import 'package:bulovva/Map/providers/markers_provider.dart';
import 'package:bulovva/Dashboard/screens/Dashboard.dart';
import 'package:bulovva/services/geolocator_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
          title: 'Bulovva',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: Dashboard()),
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        ChangeNotifierProvider(create: (context) => StoreProvider()),
      ],
    );
  }
}
