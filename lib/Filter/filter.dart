import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/store_category.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filter extends StatefulWidget {
  const Filter({Key key}) : super(key: key);

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
    for (var element in snapshots.docs) {
      StoreCategory catElement = StoreCategory.fromFirestore(element.data());
      storeCats.add(catElement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ColorConstants.instance.primaryColor,
          ),
          elevation: 0,
          toolbarHeight: 50.0,
          title: const AppTitleWidget(),
          centerTitle: true,
          flexibleSpace: Container(
            color: ColorConstants.instance.whiteContainer,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: ColorConstants.instance.whiteContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: FutureBuilder(
                future: _getCategories,
                builder: (BuildContext context, snapshotData) {
                  return (snapshotData.connectionState == ConnectionState.done)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 10.0),
                              child: Text(
                                'Arama Seçenekleri',
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.instance.primaryColor,
                                    fontSize: 20.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 10.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Sadece Aktif Kampanyalar',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  Switch(
                                      value: _filterProvider.getLive,
                                      activeColor:
                                          ColorConstants.instance.textGold,
                                      inactiveThumbColor:
                                          ColorConstants.instance.primaryColor,
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
                                    const EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorConstants.instance.hintColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: DropdownButton(
                                    value: _filterProvider.getCat,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    hint: const Text("Kategori"),
                                    items:
                                        storeCats.map((StoreCategory storeCat) {
                                      return DropdownMenuItem<String>(
                                        value: storeCat.storeCatName,
                                        onTap: () {
                                          _filterProvider
                                              .changeCat(storeCat.storeCatName);
                                        },
                                        child: Text(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Arama Uzaklığı : ${_filterProvider.getDist} km',
                                  ),
                                  Slider(
                                      value: _filterProvider.getDist,
                                      min: 1,
                                      max: 15,
                                      divisions: 14,
                                      activeColor:
                                          ColorConstants.instance.primaryColor,
                                      inactiveColor:
                                          ColorConstants.instance.waitingColor,
                                      label: '${_filterProvider.getDist} km',
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
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 10.0),
                              child: Text(
                                'Görüntü Seçenekleri',
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.instance.primaryColor,
                                    fontSize: 20.0),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 10.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Gece Modu',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  Switch(
                                      value: _filterProvider.getMode,
                                      activeColor:
                                          ColorConstants.instance.textGold,
                                      inactiveThumbColor:
                                          ColorConstants.instance.primaryColor,
                                      onChanged: (value) {
                                        _filterProvider.changeMode(value);
                                        preferences.setBool('dark', value);
                                      })
                                ],
                              ),
                            ),
                          ],
                        )
                      : const ProgressWidget();
                }),
          ),
        ));
  }
}
