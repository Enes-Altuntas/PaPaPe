import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:flutter/material.dart';

class StoreInfo extends StatefulWidget {
  final StoreModel storeData;

  const StoreInfo({Key? key, required this.storeData}) : super(key: key);

  @override
  _StoreInfoState createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  final bool _isLoading = false;
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return (_isLoading == false)
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Image.network(widget.storeData.storePicRef,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (context, child, loadingProgress) {
                    return loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.instance.iconOnColor,
                            ),
                          );
                  }),
                  color: ColorConstants.instance.primaryColor,
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          widget.storeData.storeName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: ColorConstants.instance.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                              fontSize: 30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, right: 100.0),
                        child: Text(
                          widget.storeData.storeAddress,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: ColorConstants.instance.hintColor,
                              fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 100.0),
                        child: Text(
                          "Tel: +90${widget.storeData.storePhone}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: ColorConstants.instance.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Column(
                          children: [
                            for (var i in widget.storeData.storeCategory)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: ColorConstants.instance.primaryColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      i,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants
                                              .instance.hintColor),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : const ProgressWidget();
  }
}
