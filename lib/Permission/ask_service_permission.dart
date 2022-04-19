import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:myrest/Wrappers/permission_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AskServicePermission extends StatefulWidget {
  const AskServicePermission({Key? key}) : super(key: key);

  @override
  State<AskServicePermission> createState() => _AskServicePermissionState();
}

class _AskServicePermissionState extends State<AskServicePermission> {
  checkPermission(BuildContext context) async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (enabled != true) {
      await Geolocator.openLocationSettings();
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PermissionWrapper()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/location.json',
                width: MediaQuery.of(context).size.width / 1.4),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                AppLocalizations.of(context)!.noLocationService,
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
                        AppLocalizations.of(context)!.checkLocationService),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
