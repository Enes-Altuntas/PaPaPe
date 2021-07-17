import 'package:bulovva/Models/store_category.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/Services/firestore_service.dart';
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
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          ),
          elevation: 0,
          title: Text('bulb',
              style: TextStyle(
                fontSize: 45.0,
                color: Colors.white,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
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
                                        color: Theme.of(context).primaryColor,
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
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          inactiveThumbColor:
                                              Theme.of(context).accentColor,
                                          inactiveTrackColor: Colors.amber[200],
                                          onChanged: (value) {
                                            _filterProvider.changeLive(value);
                                            preferences.setBool('live', value);
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
                                          preferences.setString(
                                              'category', value);
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
                                          'Arama Uzaklığı : ${_filterProvider.getDist} km'),
                                      Slider(
                                          value: _filterProvider.getDist,
                                          min: 5,
                                          max: 50,
                                          divisions: 9,
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          inactiveColor:
                                              Theme.of(context).accentColor,
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
                                        color: Theme.of(context).primaryColor,
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
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          inactiveThumbColor:
                                              Theme.of(context).accentColor,
                                          inactiveTrackColor: Colors.amber[200],
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
                                  backgroundColor: Colors.white),
                            );
                    }),
              ),
            ),
          ),
        ));
  }
}
