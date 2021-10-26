import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:flutter/material.dart';

class StoreCards extends StatelessWidget {
  final StoreModel store;
  final Function onTap;

  const StoreCards({Key key, this.store, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              ClipRRect(
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: ColorConstants.instance.primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0))),
                  child: (store.storePicRef != null &&
                          store.storePicRef.isNotEmpty)
                      ? Image.network(
                          store.storePicRef,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color:
                                            ColorConstants.instance.iconOnColor,
                                      ),
                                    ),
                                  );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Resim Yok',
                              style: TextStyle(
                                color: ColorConstants.instance.textOnColor,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      store.storeName,
                      style: TextStyle(
                          color: ColorConstants.instance.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        store.storeAddress,
                        style: const TextStyle(fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Tel No: +90${store.storePhone}',
                        style: TextStyle(
                            color: ColorConstants.instance.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
