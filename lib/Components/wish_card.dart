import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/wishes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentCard extends StatefulWidget {
  final WishesModel wish;

  const CommentCard({Key? key, required this.wish}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: ColorConstants.instance.primaryColor,
          width: 1.0,
        ),
      ),
      color: ColorConstants.instance.whiteContainer,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            widget.wish.wishTitle,
            style: TextStyle(
                color: ColorConstants.instance.textGold,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                  AppLocalizations.of(context)!.businessName +
                      ': ${widget.wish.wishStoreName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorConstants.instance.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0)),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  widget.wish.wishDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstants.instance.hintColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                    AppLocalizations.of(context)!.createDate +
                        ': ${formatDate(widget.wish.createdAt)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorConstants.instance.hintColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0)),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                      (widget.wish.wishUserPhone != null &&
                              widget.wish.wishUserPhone!.isNotEmpty)
                          ? AppLocalizations.of(context)!.conatactNum +
                              ': ${widget.wish.wishUserPhone}'
                          : AppLocalizations.of(context)!.conatactNum +
                              ': ' +
                              AppLocalizations.of(context)!.unknown,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorConstants.instance.hintColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0))),
            ],
          ),
        ),
      ),
    );
  }
}
