import 'package:bulovva/Map/models/markers_model.dart';
import 'package:bulovva/Map/providers/markers_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bulovva/services/marker_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Map extends StatefulWidget {
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final storeProvider = Provider.of<StoreProvider>(context);
    final markerService = MarkerService();
    final List<Marker> freeMarkers = [];

    return Scaffold(
      body: (currentPosition != null)
          ? StreamBuilder<List<FirestoreMarkers>>(
              stream: storeProvider.stores,
              builder: (context, snapshot) {
                List<Marker> markers = (snapshot.data != null)
                    ? markerService.getMarkers(snapshot.data, context)
                    : freeMarkers;
                return (snapshot.data != null)
                    ? (snapshot.data.length != 0)
                        ? Column(
                            children: [
                              Expanded(
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(currentPosition.latitude,
                                          currentPosition.longitude),
                                      zoom: 17.0),
                                  zoomGesturesEnabled: true,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  markers: Set.from(markers),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.purple[800],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 50.0),
                                    child: Icon(
                                      Icons.add_location_alt_outlined,
                                      size: 100,
                                      color: Colors.amber[600],
                                    ),
                                  ),
                                  Text('Üzgünüz',
                                      style: GoogleFonts.bebasNeue(
                                          fontSize: 40,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.amber[600])),
                                  Text(
                                      'Yakınlarınızda bir kampanya bulunamadı !',
                                      style: GoogleFonts.bebasNeue(
                                          fontSize: 25,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.amber[600])),
                                ],
                              ),
                            ),
                          )
                    : Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.purple[800],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: Icon(
                                  Icons.add_location_alt_outlined,
                                  size: 100,
                                  color: Colors.amber[600],
                                ),
                              ),
                              Text(
                                'Üzgünüz',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.amber[600],
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'Yakınlarınızda bir kampanya bulunamadı !',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.amber[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
