import 'package:bulovva/Components/wrapper.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  await init();
  runApp(const MyApp());
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
  const MyApp({Key key}) : super(key: key);

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
            title: 'MyRest',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate
            ],
            supportedLocales: const [Locale('en', 'EN'), Locale('tr', 'TR')],
            theme: ThemeData(
              fontFamily: 'Poppins',
              scaffoldBackgroundColor: ColorConstants.instance.whiteContainer,
              cardTheme: CardTheme(
                clipBehavior: Clip.antiAlias,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: ColorConstants.instance.primaryColor,
                    width: 2.0,
                  ),
                ),
                color: ColorConstants.instance.whiteContainer,
              ),
            ),
            home: const AuthWrapper()));
  }
}
