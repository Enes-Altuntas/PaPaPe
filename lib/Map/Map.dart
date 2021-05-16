import 'package:bulovva/Filter/filter.dart';
import 'package:bulovva/Models/markers_model.dart';
import 'package:bulovva/Models/stores_model.dart';
import 'package:bulovva/Providers/filter_provider.dart';
import 'package:bulovva/Services/firestore_service.dart';
import 'package:bulovva/Store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SharedPreferences preferences;
  Future getLocation;
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
    if (preferences.getBool('live') != null) {
      _filterProvider.changeLive(preferences.getBool('live'));
    } else {
      _filterProvider.changeLive(false);
    }

    if (preferences.getBool('dark') != null) {
      _filterProvider.changeMode(preferences.getBool('dark'));
    } else {
      _filterProvider.changeMode(false);
    }

    if (preferences.getString('category') != null) {
      _filterProvider.changeCat(preferences.getString('category'));
    } else {
      _filterProvider.changeCat('Yeme İçme');
    }

    if (preferences.getString('alt_category') != null) {
      _filterProvider.changeAltCat(preferences.getString('alt_category'));
    } else {
      _filterProvider.changeAltCat(null);
    }
  }

  changeLive(bool value) {
    preferences.setBool('live', value);
    _filterProvider.changeLive(value);
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

  @override
  Future<void> didChangeDependencies() async {
    if (firstTime) {
      _filterProvider = Provider.of<FilterProvider>(context);
      getLocation = _getLocation();
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
    setState(() {
      isLoading = true;
    });
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Filter()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )),
          title: Text('Bulovva',
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Bebas',
                  color: Theme.of(context).primaryColor)),
          centerTitle: true,
        ),
        body: StreamBuilder<List<FirestoreMarkers>>(
            stream: firestoreService.getMapData(_filterProvider.getLive,
                _filterProvider.getAltCat, _filterProvider.getCat),
            builder: (context, snapshot) {
              if (snapshot.hasData == true) {
                markers.clear();
                snapshot.data.forEach((element) {
                  markers.add(Marker(
                      markerId: MarkerId(element.markerTitle),
                      draggable: false,
                      infoWindow: InfoWindow(
                          title: element.markerTitle,
                          snippet:
                              'Kampanya detayları için dokunmanız yeterli !',
                          onTap: () {
                            firestoreService
                                .getStore(element.markerId)
                                .then((value) {
                              StoreModel _store =
                                  StoreModel.fromFirestore(value.data());
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Store(
                                        storeData: _store,
                                        docId: value.id,
                                      )));
                            });
                          }),
                      position: LatLng(
                          element.markerLatitude, element.markerLongtitude)));
                });
              }
              return (isLoading == false)
                  ? (snapshot.connectionState == ConnectionState.active)
                      ? (markers.length != 0)
                          ? FutureBuilder(
                              future: getLocation,
                              builder:
                                  (BuildContext context, snapshotPosition) {
                                return (snapshotPosition.connectionState ==
                                        ConnectionState.done)
                                    ? (snapshotPosition.data != null)
                                        ? Stack(
                                            children: [
                                              GoogleMap(
                                                onMapCreated:
                                                    (GoogleMapController
                                                        controller) {
                                                  changeMapMode();
                                                  _controller = controller;
                                                },
                                                initialCameraPosition:
                                                    CameraPosition(
                                                        target: LatLng(
                                                            snapshotPosition
                                                                .data.latitude,
                                                            snapshotPosition
                                                                .data
                                                                .longitude),
                                                        zoom: 17.0),
                                                zoomGesturesEnabled: true,
                                                myLocationEnabled: true,
                                                myLocationButtonEnabled: true,
                                                markers: Set.from(markers),
                                              ),
                                              Positioned(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12),
                                                        decoration: BoxDecoration(
                                                            color: (_filterProvider
                                                                        .getLive ==
                                                                    true)
                                                                ? Colors
                                                                    .green[800]
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Sadece Aktif Kampanyalar',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Switch(
                                                              value:
                                                                  _filterProvider
                                                                      .getLive,
                                                              activeColor:
                                                                  Colors.green,
                                                              inactiveThumbColor:
                                                                  Colors.red,
                                                              inactiveTrackColor:
                                                                  Colors
                                                                      .red[300],
                                                              onChanged:
                                                                  (bool value) {
                                                                changeLive(
                                                                    value);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          )
                                        : Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 30.0),
                                                    child: Icon(
                                                        Icons.cancel_outlined,
                                                        size: 100,
                                                        color: Colors.white),
                                                  ),
                                                  Text('Lütfen',
                                                      style: TextStyle(
                                                          fontSize: 50,
                                                          color: Colors.white,
                                                          fontFamily: 'Bebas')),
                                                  Center(
                                                    child: Text(
                                                        'Konum servisinizi açın !',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Bebas')),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                    : Center(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                child: Icon(Icons.location_on,
                                                    size: 60,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              Text('Konumunuz alınıyor !',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Bebas')),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child:
                                                    CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              },
                            )
                          : Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).primaryColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50.0),
                                      child: Icon(
                                          Icons.add_location_alt_outlined,
                                          size: 100,
                                          color: Colors.white),
                                    ),
                                    Text('Üzgünüz',
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.white,
                                            fontFamily: 'Bebas')),
                                    Center(
                                      child: Text(
                                          'Yakınlarınızda bir kampanya bulunamadı !',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontFamily: 'Bebas')),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      : Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Icon(Icons.alarm,
                                      size: 60,
                                      color: Theme.of(context).primaryColor),
                                ),
                                Text('Kampanyalarınız yolda !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Bebas')),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white));
            }));
  }
}
