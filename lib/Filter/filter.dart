import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Models/store_category.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<StoreCategory> storeCats = [];
  FilterProvider _filterProvider;
  SharedPreferences preferences;
  bool firstTime = true;
  Future _getCategories;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (firstTime) {
      _filterProvider = Provider.of<FilterProvider>(context);
      await getLocalData();
      _getCategories = getCategories();
      setState(() {
        firstTime = false;
      });
    }
    super.didChangeDependencies();
  }

  Future getLocalData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences = _preferences;
    });
  }

  Future getCategories() async {
    QuerySnapshot snapshots = await FirestoreService().getStoreCat();
    snapshots.docs.forEach((element) {
      StoreCategory catElement = StoreCategory.fromFirestore(element.data());
      storeCats.add(catElement);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          title: TitleApp(),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0))),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                child: FutureBuilder(
                    future: _getCategories,
                    builder: (BuildContext context, snapshotData) {
                      return (snapshotData.connectionState ==
                              ConnectionState.done)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10.0),
                                  child: Text(
                                    'Arama Seçenekleri',
                                    style: TextStyle(
                                        fontFamily: 'Bebas',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 25.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Sadece Aktif Kampanyalar',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      Switch(
                                          value: _filterProvider.getLive,
                                          activeTrackColor: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          activeColor: Colors.green,
                                          inactiveThumbColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          inactiveTrackColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onChanged: (value) {
                                            _filterProvider.changeLive(value);
                                          })
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10.0, right: 10.0),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DropdownButton(
                                        value: _filterProvider.getCat,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text("Kategori"),
                                        items: storeCats
                                            .map((StoreCategory storeCat) {
                                          return new DropdownMenuItem<String>(
                                            value: storeCat.storeCatName,
                                            onTap: () {
                                              _filterProvider.changeCat(
                                                  storeCat.storeCatName);
                                            },
                                            child: new Text(
                                              storeCat.storeCatName,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          _filterProvider.changeCat(value);
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0, left: 10.0, right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Arama Uzaklığı : ${_filterProvider.getDist} km',
                                      ),
                                      Slider(
                                          value: _filterProvider.getDist,
                                          min: 1,
                                          max: 16,
                                          divisions: 5,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          inactiveColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          label:
                                              '${_filterProvider.getDist} km',
                                          onChanged: (localValue) {
                                            _filterProvider
                                                .changeDistance(localValue);
                                            preferences.setDouble(
                                                'distance', localValue);
                                          }),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10.0),
                                  child: Text(
                                    'Görüntü Seçenekleri',
                                    style: TextStyle(
                                        fontFamily: 'Bebas',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 25.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Gece Modu',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      Switch(
                                          value: _filterProvider.getMode,
                                          activeColor: Colors.green,
                                          activeTrackColor: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          inactiveThumbColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          inactiveTrackColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onChanged: (value) {
                                            _filterProvider.changeMode(value);
                                            preferences.setBool('dark', value);
                                          })
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber[900],
                              ),
                            );
                    }),
              ),
            ),
          ),
        ));
  }
}
