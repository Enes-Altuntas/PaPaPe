import 'package:bulovva/Models/store_alt_category.dart';
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
  List<StoreAltCategory> storeAltCats = [];
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

  Future selectCategory(String value) async {
    setState(() {
      storeAltCats = [];
    });

    List<StoreAltCategory> _storeAltCats = [];

    int index =
        storeCats.indexWhere((element) => element.storeCatName == value);

    QuerySnapshot snapshots =
        await FirestoreService().getStoreAltCat(storeCats[index].storeCatId);

    if (snapshots.docs.isNotEmpty) {
      snapshots.docs.forEach((element) {
        StoreAltCategory altCatElement =
            StoreAltCategory.fromFirestore(element.data());
        _storeAltCats.add(altCatElement);
      });
    }

    setState(() {
      storeAltCats = _storeAltCats;
    });
  }

  Future getCategories() async {
    QuerySnapshot snapshots = await FirestoreService().getStoreCat();
    snapshots.docs.forEach((element) {
      StoreCategory catElement = StoreCategory.fromFirestore(element.data());
      storeCats.add(catElement);
    });

    if (_filterProvider.getCat.isNotEmpty) {
      selectCategory(_filterProvider.getCat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Bulovva',
              style: TextStyle(
                  fontSize: 25.0, fontFamily: 'Bebas', color: Colors.white)),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _getCategories,
            builder: (BuildContext context, snapshotData) {
              return (snapshotData.connectionState == ConnectionState.done)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child: Text(
                            'Arama Seçenekleri',
                            style: TextStyle(
                                fontFamily: 'Bebas',
                                color: Theme.of(context).primaryColor,
                                fontSize: 25.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'Sadece Aktif Kampanyalar',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Switch(
                                  value: _filterProvider.getLive,
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
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                                value: _filterProvider.getCat,
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Text("Kategori"),
                                items: storeCats.map((StoreCategory storeCat) {
                                  return new DropdownMenuItem<String>(
                                    value: storeCat.storeCatName,
                                    onTap: () {
                                      _filterProvider
                                          .changeCat(storeCat.storeCatName);
                                    },
                                    child: new Text(
                                      storeCat.storeCatName,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  _filterProvider.changeAltCat(null);
                                  preferences.remove('alt_category');
                                  preferences.setString('category', value);
                                  selectCategory(value);
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                                value: _filterProvider.getAltCat,
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Text("Alt Kategori"),
                                items: storeAltCats
                                    .map((StoreAltCategory storeAltCat) {
                                  return new DropdownMenuItem<String>(
                                    value: storeAltCat.storeAltCatName,
                                    onTap: () {
                                      _filterProvider.changeAltCat(
                                          storeAltCat.storeAltCatName);
                                    },
                                    child: new Text(
                                      storeAltCat.storeAltCatName,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  _filterProvider.changeAltCat(value);
                                  preferences.setString('alt_category', value);
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child: Text(
                            'Görüntü Seçenekleri',
                            style: TextStyle(
                                fontFamily: 'Bebas',
                                color: Theme.of(context).primaryColor,
                                fontSize: 25.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'Gece Modu',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Switch(
                                  value: _filterProvider.getMode,
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
            }));
  }
}
