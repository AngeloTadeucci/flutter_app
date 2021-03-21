import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  @override
  GoogleMapsState createState() => GoogleMapsState();
}

class GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(-22.984382, -45.553360);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
      ),
    );
  }
}
