import 'package:bulovva/Components/category_brand.dart';
import 'package:bulovva/Components/custom_drawer.dart';
import 'package:bulovva/Components/not_found.dart';
import 'package:bulovva/Components/title.dart';
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
  Map({Key key}) : super(key: key);

  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
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
        circleId: CircleId('search'),
        center: LatLng(position.latitude, position.longitude),
        radius: _filterProvider.getDist * 1000,
        strokeWidth: 3,
        fillColor: (_filterProvider.getMode == true)
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
            : Colors.lightBlue.withOpacity(0.2),
        strokeColor: Colors.lightBlue[200].withOpacity(0.8));
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
          elevation: 5,
          title: TitleApp(),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
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
                                            snapshot.data.length != 0) {
                                          snapshot.data.forEach((element) {
                                            markers.add(Marker(
                                                markerId:
                                                    MarkerId(element.storeId),
                                                draggable: false,
                                                infoWindow: InfoWindow(
                                                    title: element.storeName,
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
                                          });
                                        }
                                        getSearchCircle(snapshotPosition.data);
                                        return (snapshot.connectionState ==
                                                ConnectionState.active)
                                            ? (snapshot.hasData &&
                                                    snapshot.data != null &&
                                                    snapshot.data.length != 0)
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
                                                : NotFound(
                                                    notFoundIcon:
                                                        FontAwesomeIcons
                                                            .exclamationTriangle,
                                                    notFoundIconColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    notFoundIconSize: 60.0,
                                                    notFoundText:
                                                        "Aradığınız kategoride işletme bulunmuyor !",
                                                    notFoundTextColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    notFoundTextSize: 40.0,
                                                  )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              );
                                      })
                                  : Center(
                                      child: Text('Konumunuz bulunamadı !',
                                          style: TextStyle(
                                              fontFamily: 'Bebas',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 25.0)),
                                    )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                        },
                      ),
                      Positioned(
                          bottom: MediaQuery.of(context).size.height / 15,
                          left: MediaQuery.of(context).size.width / 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 12),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  children: [
                                    Text(
                                      'Aktif Kampanyalar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Switch(
                                      value: _filterProvider.getLive,
                                      activeColor: Colors.green,
                                      activeTrackColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      inactiveThumbColor:
                                          Theme.of(context).colorScheme.primary,
                                      inactiveTrackColor: Colors.red[700],
                                      onChanged: (bool value) {
                                        changeLive(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            )));
  }
}
