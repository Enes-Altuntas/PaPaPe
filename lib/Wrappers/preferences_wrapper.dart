import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Welcome/welcome.dart';
import 'package:bulovva/Wrappers/provider_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesWrapper extends StatefulWidget {
  const PreferencesWrapper({Key? key}) : super(key: key);

  @override
  State<PreferencesWrapper> createState() => _PreferencesWrapperState();
}

class _PreferencesWrapperState extends State<PreferencesWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data!.getBool("first_time") == null ||
                  snapshot.data!.getBool("first_time") == true) {
                if (snapshot.data!.getBool("first_time") == null) {
                  snapshot.data!.setBool("first_time", true);
                }
                return const Welcome();
              } else {
                return const ProviderWrapper();
              }
            default:
              return const ProgressWidget();
          }
        });
  }
}
