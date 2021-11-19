// ignore_for_file: file_names

import 'package:bulovva/Components/app_title.dart';
import 'package:bulovva/Components/category_brand.dart';
import 'package:bulovva/Components/custom_drawer.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/markers_model.dart';
import 'package:bulovva/Models/store_category.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/Store/store.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  final TextEditingController searchController = TextEditingController();
  final firestoreService = FirestoreService();
  final List<Marker> markers = [];
  final List<Circle> circles = [];
  SharedPreferences preferences;
  Future getLocation;
  Future getStoreCategories;
  GoogleMapController _controller;
  FilterProvider _filterProvider;
  bool firstTime = true;
  bool isLoading = false;
  String search;

  @override
  void initState() {
    super.initState();
  }

  Future getLocalData() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences = _preferences;
    });
  }

  setLocalData() {
    _filterProvider.changeLive(false);

    if (preferences.getBool('dark') != null) {
      _filterProvider.changeMode(preferences.getBool('dark'));
    } else {
      _filterProvider.changeMode(false);
    }

    _filterProvider.changeCat('Restoran');

    if (preferences.getDouble('distance') != null) {
      _filterProvider.changeDistance(preferences.getDouble('distance'));
    } else {
      _filterProvider.changeDistance(1.0);
    }
  }

  changeLive(bool value) {
    preferences.setBool('live', value);
    _filterProvider.changeLive(value);
  }

  changeCat(String value) {
    _filterProvider.changeCat(value);
  }

  changeMapMode() {
    if (_filterProvider.getMode == true) {
      getJsonFile("assets/night.json").then((value) => setMapStyle(value));
    } else {
      getJsonFile("assets/standart.json").then((value) => setMapStyle(value));
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  getSearchCircle(Position position) {
    circles.clear();
    Circle circle = Circle(
        circleId: const CircleId('search'),
        center: LatLng(position.latitude, position.longitude),
        radius: _filterProvider.getDist * 1000,
        strokeWidth: 3,
        fillColor: (_filterProvider.getMode == true)
            ? ColorConstants.instance.waitingColor.withOpacity(0.1)
            : ColorConstants.instance.secondaryColor.withOpacity(0.2),
        strokeColor: ColorConstants.instance.secondaryColor.withOpacity(0.8));
    circles.add(circle);
  }

  @override
  Future<void> didChangeDependencies() async {
    if (firstTime) {
      _filterProvider = Provider.of<FilterProvider>(context);
      getLocation = _getLocation();
      getStoreCategories = _getStoreCategories();
      getLocalData().then((value) {
        setLocalData();
      });
      setState(() {
        firstTime = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<Position> _getLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<List<StoreCategory>> _getStoreCategories() async {
    return firestoreService.getStoreCategories();
  }

  double getZoomLevel() {
    if (_filterProvider.getDist == 1) {
      return 14;
    } else if (_filterProvider.getDist == 4) {
      return 12.2;
    } else if (_filterProvider.getDist == 7) {
      return 11.5;
    } else if (_filterProvider.getDist == 10) {
      return 11.0;
    } else if (_filterProvider.getDist == 13) {
      return 10.6;
    } else if (_filterProvider.getDist == 16) {
      return 10.3;
    } else {
      return 12.0;
    }
  }

  showStorePage(String storeId) async {
    StoreModel store = await firestoreService.getStore(storeId).then((value) {
      return StoreModel.fromFirestore(value.data());
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Store(
              storeData: store,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50.0,
          title: const AppTitleWidget(),
          centerTitle: true,
          flexibleSpace: Container(
            color: ColorConstants.instance.whiteContainer,
          ),
          iconTheme: IconThemeData(color: ColorConstants.instance.primaryColor),
        ),
        drawer: const CustomDrawer(),
        body: Container(
            decoration: BoxDecoration(
              color: ColorConstants.instance.whiteContainer,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: ColorConstants.instance.whiteContainer),
                    child: FutureBuilder<List<StoreCategory>>(
                        future: _getStoreCategories(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              itemCount: (snapshot.data != null)
                                  ? snapshot.data.length
                                  : 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return BrandWidget(
                                    storeCategory: snapshot.data[index]);
                              });
                        })),
                Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: ColorConstants.instance.whiteContainer),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 10.0, top: 15.0),
                      child: TextField(
                        controller: searchController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(fontSize: 12.0),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  search = searchController.text.trim();
                                });
                              },
                              child: const Icon(Icons.search),
                            ),
                            hintText: "İşletme İsmi",
                            hintStyle: const TextStyle(fontSize: 12.0)),
                      ),
                    )),
                Expanded(
                  child: Stack(
                    children: [
                      FutureBuilder(
                        future: getLocation,
                        builder: (BuildContext context, snapshotPosition) {
                          return (snapshotPosition.connectionState ==
                                  ConnectionState.done)
                              ? (snapshotPosition.hasData)
                                  ? StreamBuilder<List<MarkerModel>>(
                                      stream: firestoreService.getMapData(
                                          _filterProvider.getLive,
                                          _filterProvider.getCat,
                                          _filterProvider.getDist,
                                          snapshotPosition.data.latitude,
                                          snapshotPosition.data.longitude),
                                      builder: (context, snapshot) {
                                        markers.clear();
                                        if (snapshot.connectionState ==
                                                ConnectionState.active &&
                                            snapshot.hasData == true &&
                                            snapshot.data.isNotEmpty) {
                                          for (var element in snapshot.data) {
                                            if (search != null &&
                                                !element.storeName
                                                    .toLowerCase()
                                                    .contains(search)) {
                                              continue;
                                            }
                                            markers.add(Marker(
                                                markerId:
                                                    MarkerId(element.storeId),
                                                draggable: false,
                                                infoWindow: InfoWindow(
                                                    title: element.storeName,
                                                    snippet:
                                                        'kampanyaları gör...',
                                                    onTap: () {
                                                      showStorePage(
                                                          element.storeId);
                                                    }),
                                                icon: (element.campaignStatus ==
                                                        'active')
                                                    ? BitmapDescriptor
                                                        .defaultMarkerWithHue(
                                                            BitmapDescriptor
                                                                .hueGreen)
                                                    : (element.campaignStatus ==
                                                            'wait')
                                                        ? BitmapDescriptor
                                                            .defaultMarkerWithHue(
                                                                BitmapDescriptor
                                                                    .hueOrange)
                                                        : BitmapDescriptor
                                                            .defaultMarkerWithHue(
                                                                BitmapDescriptor
                                                                    .hueRed),
                                                position: LatLng(
                                                    element.position.geopoint
                                                        .latitude,
                                                    element.position.geopoint.longitude)));
                                          }
                                        }
                                        getSearchCircle(snapshotPosition.data);
                                        return (snapshot.connectionState ==
                                                ConnectionState.active)
                                            ? (markers.isNotEmpty)
                                                ? GoogleMap(
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) {
                                                      _controller = controller;
                                                      changeMapMode();
                                                    },
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                            target: LatLng(
                                                                snapshotPosition
                                                                    .data
                                                                    .latitude,
                                                                snapshotPosition
                                                                    .data
                                                                    .longitude),
                                                            zoom:
                                                                getZoomLevel()),
                                                    zoomGesturesEnabled: true,
                                                    myLocationEnabled: true,
                                                    myLocationButtonEnabled:
                                                        true,
                                                    markers: Set.from(markers),
                                                    circles: Set.from(circles),
                                                  )
                                                : const NotFound(
                                                    notFoundIcon:
                                                        FontAwesomeIcons
                                                            .exclamationTriangle,
                                                    notFoundText:
                                                        "Aradığınız kategoride işletme bulunmuyor !",
                                                  )
                                            : const ProgressWidget();
                                      })
                                  : Center(
                                      child: Text('Konumunuz bulunamadı !',
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .instance.primaryColor,
                                              fontSize: 30.0)),
                                    )
                              : const ProgressWidget();
                        },
                      ),
                      Positioned(
                          bottom: MediaQuery.of(context).size.height / 40,
                          left: MediaQuery.of(context).size.width / 30,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              color: ColorConstants.instance.whiteContainer,
                              border: Border.all(
                                  width: 2.0,
                                  color: ColorConstants.instance.primaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(right: 3.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Aktif',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 3.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: ColorConstants
                                            .instance.buttonDarkGold,
                                      ),
                                    ),
                                    Text(
                                      'Beklemede',
                                      style: TextStyle(
                                          color: ColorConstants
                                              .instance.buttonDarkGold,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 3.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: ColorConstants
                                            .instance.inactiveGray,
                                      ),
                                    ),
                                    Text(
                                      'İnaktif',
                                      style: TextStyle(
                                          color: ColorConstants
                                              .instance.inactiveGray,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
