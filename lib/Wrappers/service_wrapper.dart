import 'package:geolocator/geolocator.dart';
import 'package:myrest/Permission/ask_service_permission.dart';
import 'package:flutter/material.dart';
import 'package:myrest/Wrappers/permission_wrapper.dart';

import '../Components/progress.dart';

class ServiceWrapper extends StatefulWidget {
  const ServiceWrapper({Key? key}) : super(key: key);

  @override
  State<ServiceWrapper> createState() => _ServiceWrapperState();
}

class _ServiceWrapperState extends State<ServiceWrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Geolocator.isLocationServiceEnabled(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data == true) {
                return const PermissionWrapper();
              } else {
                return const AskServicePermission();
              }
            default:
              return const ProgressWidget();
          }
        });
  }
}
