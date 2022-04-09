import 'package:myrest/Components/progress.dart';
import 'package:myrest/Map/map_screen.dart';
import 'package:myrest/Models/user_model.dart';
import 'package:myrest/Providers/user_provider.dart';
import 'package:myrest/Services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
        stream: FirestoreService().userInformation(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              if (snapshot.data != null) {
                context.read<UserProvider>().loadUserInfo(snapshot.data!);
              }
              return const MapScreen();
            default:
              return const ProgressWidget();
          }
        });
  }
}
