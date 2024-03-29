import 'package:myrest/Components/gradient_button.dart';
import 'package:myrest/Constants/colors_constants.dart';
import 'package:myrest/Models/campaign_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Constants/localization_constants.dart';
import '../Providers/locale_provider.dart';

class CampaignCard extends StatefulWidget {
  final CampaignModel campaign;
  final VoidCallback onPressed;

  const CampaignCard(
      {Key? key, required this.campaign, required this.onPressed})
      : super(key: key);

  @override
  _CampaignCardState createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      )),
      clipBehavior: Clip.antiAlias,
      color: ColorConstants.instance.whiteContainer,
      shadowColor: ColorConstants.instance.hintColor,
      elevation: 5.0,
      child: InkWell(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    ColorConstants.instance.secondaryColor,
                    ColorConstants.instance.primaryColor,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                  child: (widget.campaign.campaignPicRef != null)
                      ? Image.network(widget.campaign.campaignPicRef!,
                          loadingBuilder: (context, child, loadingProgress) {
                          return loadingProgress == null
                              ? child
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.instance.iconOnColor,
                                  ),
                                );
                        }, fit: BoxFit.fill)
                      : Center(
                          child: Text(
                              AppLocalizations.of(context)!.noCampaignPicture,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.instance.textOnColor,
                                  fontSize: 20.0)),
                        ),
                ),
                Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: (widget.campaign.campaignStatus == 'active')
                        ? Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                color: ColorConstants.instance.activeColor,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.checkCircle,
                                color: ColorConstants.instance.iconOnColor,
                              ),
                            ),
                          )
                        : (widget.campaign.campaignStatus == 'inactive')
                            ? Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                    color:
                                        ColorConstants.instance.inactiveColor,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.ban,
                                    color: ColorConstants.instance.iconOnColor,
                                  ),
                                ),
                              )
                            : Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                    color: ColorConstants.instance.waitingColor,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.hourglassHalf,
                                    color: ColorConstants.instance.iconOnColor,
                                  ),
                                ),
                              ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
              child: Text(
                  (context.read<LocaleProvider>().locale ==
                          LocalizationConstant.trLocale)
                      ? widget.campaign.campaignTitle.toUpperCase()
                      : (widget.campaign.campaignTitleEn != null)
                          ? widget.campaign.campaignTitleEn!.toUpperCase()
                          : widget.campaign.campaignTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      color: ColorConstants.instance.textGold,
                      fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 40.0, right: 40.0),
              child: Divider(
                thickness: 2.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  (context.read<LocaleProvider>().locale ==
                          LocalizationConstant.trLocale)
                      ? widget.campaign.campaignDesc
                      : (widget.campaign.campaignDescEn != null)
                          ? widget.campaign.campaignDescEn!
                          : widget.campaign.campaignDesc,
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                          AppLocalizations.of(context)!.campaignStart +
                              ': ${formatDate(widget.campaign.campaignStart)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorConstants.instance.hintColor,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 15.0,
                      ),
                      child: Text(
                          AppLocalizations.of(context)!.campaignFinish +
                              ': ${formatDate(widget.campaign.campaignFinish)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: ColorConstants.instance.hintColor,
                              fontWeight: FontWeight.bold)),
                    ),
                    Visibility(
                      visible: widget.campaign.campaignStatus != 'inactive',
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 5.0, bottom: 10.0),
                          child: GradientButton(
                            buttonText:
                                AppLocalizations.of(context)!.takeCampaignCode,
                            end: (widget.campaign.campaignStatus == 'active')
                                ? ColorConstants.instance.activeColor
                                : (widget.campaign.campaignStatus == 'inactive')
                                    ? ColorConstants.instance.inactiveColor
                                    : ColorConstants.instance.waitingColor,
                            start: (widget.campaign.campaignStatus == 'active')
                                ? ColorConstants.instance.activeColorDark
                                : (widget.campaign.campaignStatus == 'inactive')
                                    ? ColorConstants
                                        .instance.signBackButtonSecondary
                                    : ColorConstants.instance.waitingColorDark,
                            fontSize: 15,
                            icon: FontAwesomeIcons.getPocket,
                            onPressed: widget.onPressed,
                            widthMultiplier: 0.7,
                            fontFamily: '',
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
