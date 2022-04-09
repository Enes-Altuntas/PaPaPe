import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/campaign_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../Constants/localization_constants.dart';
import '../Providers/locale_provider.dart';

class QrCard extends StatelessWidget {
  final CampaignModel campaignModel;
  final String qrData;
  final Function onPressed;

  const QrCard(
      {Key? key,
      required this.campaignModel,
      required this.qrData,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstants.instance.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListTile(
          onTap: () {
            onPressed(qrData);
          },
          title: Column(
            children: [
              Text(
                (context.read<LocaleProvider>().locale ==
                        LocalizationConstant.trLocale)
                    ? campaignModel.campaignTitle
                    : (campaignModel.campaignTitleEn != null)
                        ? campaignModel.campaignTitleEn!
                        : campaignModel.campaignTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorConstants.instance.textGold,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  (context.read<LocaleProvider>().locale ==
                          LocalizationConstant.trLocale)
                      ? campaignModel.campaignDesc
                      : (campaignModel.campaignDescEn != null)
                          ? campaignModel.campaignDescEn!
                          : campaignModel.campaignDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorConstants.instance.textOnColor,
                      fontSize: 12.0),
                ),
              ),
            ],
          ),
          leading: QrImage(
            data: qrData,
            version: QrVersions.auto,
            backgroundColor: ColorConstants.instance.whiteContainer,
          ),
        ),
      ),
    );
  }
}
