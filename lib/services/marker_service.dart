import 'package:bulovva/Map/models/markers_model.dart';
import 'package:bulovva/Store/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerService {
  List<Marker> getMarkers(List<FirestoreMarkers> firestoreMarkers, context) {
    List<Marker> markers = [];

    firestoreMarkers.forEach((firestoreMarker) {
      Marker marker = Marker(
          markerId: MarkerId(firestoreMarker.markerTitle),
          draggable: false,
          infoWindow: InfoWindow(
              title: firestoreMarker.markerTitle,
              snippet: 'Kampanya detayları için tıklayınız !',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Store(firestoreMarker: firestoreMarker)));
              }),
          position: LatLng(double.parse(firestoreMarker.markerLatitude),
              double.parse(firestoreMarker.markerLongtitude)));
      markers.add(marker);
    });

    return markers;
  }
}
