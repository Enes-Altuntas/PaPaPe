import 'package:myrest/Wrappers/preferences_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
                providerConfigs: const [
                  EmailProviderConfiguration(),
                  GoogleProviderConfiguration(
                      clientId:
                          "1:641494071867:android:c51372ac898bb8e3097a1e"),
                  PhoneProviderConfiguration(),
                ],
                headerBuilder: (context, constraints, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Image.asset('assets/images/login_logo.png',
                        height: MediaQuery.of(context).size.height / 5),
                  );
                });
          }
          return const PreferencesWrapper();
        });
  }
}
