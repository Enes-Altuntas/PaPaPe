import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/qr_card.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/campaign_model.dart';
import 'package:bulovva/Models/user_model.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyCampaigns extends StatelessWidget {
  const MyCampaigns({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50.0,
          flexibleSpace: Container(
            color: ColorConstants.instance.whiteContainer,
          ),
          iconTheme: IconThemeData(
            color:
                ColorConstants.instance.primaryColor, //change your color here
          ),
          elevation: 0,
          title: const AppTitleWidget(),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: ColorConstants.instance.whiteContainer,
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: StreamBuilder<UserModel>(
                  stream: FirestoreService().getUserDetail(),
                  builder: (context, snapshotQr) {
                    switch (snapshotQr.connectionState) {
                      case ConnectionState.active:
                        switch (snapshotQr.data != null &&
                            snapshotQr.data.campaignCodes != null &&
                            snapshotQr.data.campaignCodes.isNotEmpty) {
                          case true:
                            return ListView.builder(
                              itemCount: snapshotQr.data.campaignCodes.length,
                              itemBuilder: (context, indexQr) {
                                return FutureBuilder<CampaignModel>(
                                    future: FirestoreService().getCampaignData(
                                        snapshotQr.data.campaignCodes[indexQr]),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.done:
                                          switch (snapshot.data != null) {
                                            case true:
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: QrCard(
                                                    campaignModel:
                                                        snapshot.data,
                                                    qrData: snapshotQr.data
                                                        .campaignCodes[indexQr],
                                                    onPressed: (String qrData) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              child: SizedBox(
                                                                width: 300,
                                                                height: 300,
                                                                child: Center(
                                                                  child:
                                                                      QrImage(
                                                                    data: snapshotQr
                                                                            .data
                                                                            .campaignCodes[
                                                                        indexQr],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ));
                                              break;
                                            default:
                                              return const NotFound(
                                                notFoundIcon: FontAwesomeIcons
                                                    .exclamationCircle,
                                                notFoundText:
                                                    'Kampanya bilgileri bulunamadı !',
                                              );
                                          }
                                          break;
                                        default:
                                          return Center(
                                              child: CircularProgressIndicator(
                                            color: ColorConstants
                                                .instance.primaryColor,
                                          ));
                                      }
                                    });
                              },
                            );
                            break;
                          default:
                            return const NotFound(
                              notFoundIcon:
                                  FontAwesomeIcons.exclamationTriangle,
                              notFoundText:
                                  'Üzgünüz, almış olduğunuz hiçbir kampanya kodunuz bulunamamıştır !',
                            );
                        }
                        break;
                      default:
                        return Center(
                            child: CircularProgressIndicator(
                          color: ColorConstants.instance.primaryColor,
                        ));
                    }
                  })),
        ));
  }
}
