// lib/screen/map_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart'; // Import the Google Maps Widget

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Create a controller for the Google Maps Widget
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Screen'),
      ),
      body: GoogleMapsWidget(
        apiKey: "AIzaSyBwqmDMk1bAHjZCfoR8KRKwfCh09xoAx60",
        key: mapsWidgetController,
        sourceLatLng: const LatLng(40.484000837597925, -3.369978368282318),
        destinationLatLng: const LatLng(40.48017307700204, -3.3618026599287987),
        // Additional parameters as needed
      ),
    );
  }
}
