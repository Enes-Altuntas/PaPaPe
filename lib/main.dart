import 'package:myrest/Constants/localization_constants.dart';
import 'package:myrest/Constants/theme_data.dart';
import 'package:myrest/Providers/filter_provider.dart';
import 'package:myrest/Providers/locale_provider.dart';
import 'package:myrest/Providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myrest/Wrappers/service_wrapper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FilterProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ],
        child: Builder(builder: (context) {
          final provider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
              title: 'MyRest',
              debugShowCheckedModeBanner: false,
              localizationsDelegates:
                  LocalizationConstant.localizationDelegates,
              locale: provider.locale,
              supportedLocales: LocalizationConstant.supportedLocals,
              theme: myRestThemeData,
              home: const ServiceWrapper());
        }));
  }
}
