import 'package:bulb/Filter/filter.dart';
import 'package:bulb/Models/markers_model.dart';
import 'package:bulb/Models/store_category.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Providers/filter_provider.dart';
import 'package:bulb/Services/firestore_service.dart';
import 'package:bulb/Store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        strokeColor: Theme.of(context).accentColor.withOpacity(0.1));
    circles.add(circle);
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

  makePhoneCall(storePhone) async {
    await launch("tel:$storePhone");
  }

  double getZoomLevel() {
    if (_filterProvider.getDist == 1) {
      return 14;
    } else if (_filterProvider.getDist == 2) {
      return 13.4;
    } else if (_filterProvider.getDist == 3) {
      return 12.8;
    } else if (_filterProvider.getDist == 4) {
      return 12.4;
    } else if (_filterProvider.getDist == 5) {
      return 12.0;
    } else {
      return 12.0;
    }
  }

  findPlace(storeLat, storeLong) async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$storeLat,$storeLong";
    await launch(googleMapslocationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          ),
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
                      color: Colors.white,
                    ),
                  ],
                ),
              )),
          title: Text('bulb',
              style: TextStyle(
                fontSize: 45.0,
                fontFamily: 'Armatic',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          centerTitle: true,
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 110.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).accentColor,
                            Theme.of(context).primaryColor
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft),
                    ),
                    child: StreamBuilder<List<StoreCategory>>(
                        stream: firestoreService.getStoreCategories(),
                        builder: (context, snapshot) {
                          return (snapshot.connectionState ==
                                  ConnectionState.active)
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: () {
                                          changeCat(snapshot
                                              .data[index].storeCatName);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data[index]
                                                        .storeCatPicRef),
                                                backgroundColor:
                                                    (_filterProvider.getCat ==
                                                            snapshot.data[index]
                                                                .storeCatName)
                                                        ? Colors
                                                            .greenAccent[400]
                                                        : Colors.white,
                                                maxRadius: 30.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                snapshot.data[index].storeShort,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                        })),
                Expanded(
                  child: FutureBuilder(
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
                                            markerId: MarkerId(element.storeId),
                                            draggable: false,
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
                                            onTap: () async {
                                              StoreModel store;
                                              String id;
                                              await firestoreService
                                                  .getStore(element.storeId)
                                                  .then((value) {
                                                if (value.data() != null) {
                                                  store =
                                                      StoreModel.fromFirestore(
                                                          value.data());
                                                  id = value.id;
                                                }
                                              });
                                              showModalBottomSheet(
                                                  context: context,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    50.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    50.0)),
                                                  ),
                                                  builder: (context) {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                            Theme.of(context)
                                                                .accentColor,
                                                            Theme.of(context)
                                                                .primaryColor
                                                          ],
                                                              begin: Alignment
                                                                  .centerRight,
                                                              end: Alignment
                                                                  .centerLeft)),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Container(
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    3.6,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              color: Colors.white,
                                                                              spreadRadius: 3),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(50.0)),
                                                                child: Stack(
                                                                  children: [
                                                                    ColorFiltered(
                                                                      colorFilter: ColorFilter.mode(
                                                                          Colors
                                                                              .black
                                                                              .withOpacity(0.6),
                                                                          BlendMode.darken),
                                                                      child: (store != null &&
                                                                              store.storePicRef != null)
                                                                          ? Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: MediaQuery.of(context).size.height,
                                                                              child: Image.network(store.storePicRef, fit: BoxFit.fitWidth),
                                                                            )
                                                                          : Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              height: MediaQuery.of(context).size.height,
                                                                            ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            store.storeName,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(shadows: <Shadow>[
                                                                              Shadow(
                                                                                offset: Offset(1.0, 1.0),
                                                                                blurRadius: 15.0,
                                                                                color: Theme.of(context).primaryColor,
                                                                              ),
                                                                            ], color: Colors.white, fontSize: (store.storeName.length > 30) ? 30.0 : 40.0, fontFamily: 'Bebas'),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 20.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: Theme.of(context).primaryColor,
                                                                                  borderRadius: BorderRadius.circular(50.0),
                                                                                ),
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      findPlace(store.storeLocLat, store.storeLocLong);
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.location_on_outlined,
                                                                                      size: 30.0,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(50.0),
                                                                                  color: Theme.of(context).primaryColor,
                                                                                ),
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                                          builder: (context) => Store(
                                                                                                storeData: store,
                                                                                                docId: id,
                                                                                              )));
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.arrow_forward_ios,
                                                                                      size: 30.0,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(50.0),
                                                                                  color: Theme.of(context).primaryColor,
                                                                                ),
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      makePhoneCall(store.storePhone);
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.call,
                                                                                      size: 30.0,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            position: LatLng(
                                                element
                                                    .position.geopoint.latitude,
                                                element.position.geopoint
                                                    .longitude)));
                                      });
                                    }
                                    getSearchCircle(snapshotPosition.data);
                                    return (snapshot.connectionState ==
                                            ConnectionState.active)
                                        ? (snapshot.hasData &&
                                                snapshot.data != null &&
                                                snapshot.data.length != 0)
                                            ? Stack(
                                                children: [
                                                  GoogleMap(
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
                                                  ),
                                                  Positioned(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      left:
                                                          MediaQuery.of(context)
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
                                                                gradient: LinearGradient(
                                                                    colors: [
                                                                      Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                      Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerRight,
                                                                    end: Alignment
                                                                        .centerLeft),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Aktif Kampanyalar',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Switch(
                                                                  value: _filterProvider
                                                                      .getLive,
                                                                  activeColor: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  inactiveThumbColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                  inactiveTrackColor:
                                                                      Colors.amber[
                                                                          200],
                                                                  onChanged: (bool
                                                                      value) {
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
                                            : Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.sadTear,
                                                      color: Colors.white,
                                                      size: 100.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Text(
                                                        'Üzgünüz !',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'Bebas',
                                                            fontSize: 40.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Text(
                                                        '" ${_filterProvider.getCat} " kategorisinde , hiçbir kampanya bulunamadı !',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: 'Bebas',
                                                            color: Colors.white,
                                                            fontSize: 25.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          );
                                  })
                              : Center(
                                  child: Text('Konumunuz bulunamadı !'),
                                )
                          : Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                    },
                  ),
                ),
              ],
            )));
  }
}
