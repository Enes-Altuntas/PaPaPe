import 'package:geolocator/geolocator.dart';
import 'package:myrest/Permission/ask_permission.dart';
import 'package:myrest/Wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';

import '../Components/progress.dart';

class PermissionWrapper extends StatefulWidget {
  const PermissionWrapper({Key? key}) : super(key: key);

  @override
  State<PermissionWrapper> createState() => _PermissionWrapperState();
}

class _PermissionWrapperState extends State<PermissionWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationPermission>(
        future: Geolocator.checkPermission(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data == LocationPermission.always ||
                  snapshot.data == LocationPermission.whileInUse) {
                return const AuthWrapper();
              } else {
                return const AskPermission();
              }
            default:
              return const ProgressWidget();
          }
        });
  }
}
