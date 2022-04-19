import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../Wrappers/auth_wrapper.dart';

class AskPermission extends StatefulWidget {
  const AskPermission({Key? key}) : super(key: key);

  @override
  State<AskPermission> createState() => _AskPermissionState();
}

checkPermission(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission != LocationPermission.always &&
      permission != LocationPermission.whileInUse) {
    await Geolocator.openAppSettings();
  } else {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AuthWrapper()));
  }
}

class _AskPermissionState extends State<AskPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/location_find.json',
                width: MediaQuery.of(context).size.width / 1.4),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                AppLocalizations.of(context)!.noLocationPermission,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () async {
                    checkPermission(context);
                  },
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        AppLocalizations.of(context)!.checkLocationPermission),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
