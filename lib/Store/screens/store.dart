import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bulovva/Map/models/markers_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bulovva/Store/models/stores_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store extends StatefulWidget {
  final FirestoreMarkers firestoreMarker;
  Store({Key key, @required this.firestoreMarker}) : super(key: key);

  @override
  _StoreState createState() => _StoreState(firestoreMarker);
}

class _StoreState extends State<Store> {
  FirestoreMarkers firestoreMarker;
  FirestoreStores store;
  List<Marker> marker;
  _StoreState(this.firestoreMarker);

  setMarker() {
    List<Marker> allMarker = [];
    allMarker.add(Marker(
        markerId: MarkerId(firestoreMarker.markerTitle),
        draggable: false,
        infoWindow: InfoWindow(title: firestoreMarker.markerTitle),
        position: LatLng(double.parse(firestoreMarker.markerLatitude),
            double.parse(firestoreMarker.markerLongtitude))));
    // });
    setState(() {
      marker = allMarker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('stores')
            .where('storeId', isEqualTo: firestoreMarker.storeId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.amber[600],
                ),
                body: Container(
                  color: Colors.purple[800],
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber[600],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              width: MediaQuery.of(context).size.width,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  child: Text(
                                    firestoreMarker.markerTitle,
                                    style: GoogleFonts.bebasNeue(
                                        fontSize: 25,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.purple[800]),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3.0, color: Colors.amber[600])),
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    double.parse(
                                        firestoreMarker.markerLatitude),
                                    double.parse(
                                        firestoreMarker.markerLongtitude)),
                                zoom: 17.0),
                            zoomGesturesEnabled: true,
                            myLocationButtonEnabled: true,
                            onMapCreated: setMarker(),
                            markers: Set.from(marker),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          } else if (snapshot.hasError) {
            return Text("error");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
