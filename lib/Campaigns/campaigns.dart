import 'package:bulb/Components/campaign_card.dart';
import 'package:bulb/Components/not_found.dart';
import 'package:bulb/Models/campaign_model.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/services/firestore_service.dart';
import 'package:bulb/services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Campaigns extends StatefulWidget {
  final StoreModel storeData;

  Campaigns({Key key, this.storeData}) : super(key: key);

  @override
  _CampaignsState createState() => _CampaignsState();
}

class _CampaignsState extends State<Campaigns> {
  final firestoreService = FirestoreService();
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  bool isLoading = false;

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  getCampaignKey(CampaignModel campaign) async {
    await firestoreService
        .updateCounter(widget.storeData.storeId, campaign.campaignId,
            campaign.campaignCounter, campaign.campaignKey)
        .then((value) => ToastService().showSuccess(value, context))
        .onError(
            (error, stackTrace) => ToastService().showError(error, context));
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading == false)
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Kampanyalar',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontFamily: 'Armatic',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: StreamBuilder<List<CampaignModel>>(
                  stream: FirestoreService()
                      .getStoreCampaigns(widget.storeData.storeId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        switch (snapshot.hasData && snapshot.data.length > 0) {
                          case true:
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
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
                            return NotFound(
                              notFoundIcon: FontAwesomeIcons.sadTear,
                              notFoundIconColor: Theme.of(context).primaryColor,
                              notFoundIconSize: 75,
                              notFoundText:
                                  'Şu an yayınlamış olduğunuz hiçbir kampanya bulunmamaktadır.',
                              notFoundTextColor: Theme.of(context).primaryColor,
                              notFoundTextSize: 30.0,
                            );
                        }
                        break;
                      default:
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber[900],
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.amber[900],
            ),
          );
  }
}
