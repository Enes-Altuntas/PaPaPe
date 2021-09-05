import 'package:bulb/Models/store_model.dart';
import 'package:flutter/material.dart';

class StoreCards extends StatelessWidget {
  final StoreModel store;

  const StoreCards({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(color: Colors.amber[200]),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    this.store.storeName,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: MediaQuery.of(context).size.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: (this.store.storePicRef != null)
                  ? Image.network(
                      this.store.storePicRef,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                      },
                    )
                  : Center(
                      child: Text(
                        'Resim Yok',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.store.storeAddress,
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: 'Roboto')),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Telefon: +90${this.store.storePhone}',
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
