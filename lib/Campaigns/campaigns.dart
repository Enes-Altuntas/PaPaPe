import 'package:bulovva/Components/campaign_card.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Models/campaign_model.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Providers/user_provider.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:bulovva/services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Campaigns extends StatefulWidget {
  final StoreModel storeData;

  const Campaigns({Key key, this.storeData}) : super(key: key);

  @override
  _CampaignsState createState() => _CampaignsState();
}

class _CampaignsState extends State<Campaigns> {
  final firestoreService = FirestoreService();
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  bool isLoading = false;
  UserProvider _userProvider;

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  getCampaignKey(CampaignModel campaign) async {
    await firestoreService
        .getCampaign(
            widget.storeData.storeId, campaign.campaignId, _userProvider.name)
        .then((value) => ToastService().showSuccess(value, context))
        .onError(
            (error, stackTrace) => ToastService().showError(error, context));
  }

  @override
  void didChangeDependencies() {
    _userProvider = Provider.of<UserProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading == false)
        ? Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: StreamBuilder<List<CampaignModel>>(
              stream: FirestoreService()
                  .getStoreCampaigns(widget.storeData.storeId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    switch (snapshot.hasData && snapshot.data.isNotEmpty) {
                      case true:
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: CampaignCard(
                                    campaign: snapshot.data[index],
                                    onPressed: () {
                                      getCampaignKey(snapshot.data[index]);
                                    },
                                  ),
                                );
                              }),
                        );
                        break;
                      default:
                        return const NotFound(
                          notFoundIcon: FontAwesomeIcons.exclamationTriangle,
                          notFoundText:
                              'Üzgünüz, şu anda işletmenin yayınlamış olduğu bir kampanya bulunmamaktadır.',
                        );
                    }
                    break;
                  default:
                    return const ProgressWidget();
                }
              },
            ),
          )
        : const ProgressWidget();
  }
}
