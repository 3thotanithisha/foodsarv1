import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class LocationService {
  final Location _location = Location();

  Future<LocationData?> getLocation() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      // Handle location retrieval error
      return null;
    }
  }

  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;
}

// map_utils.dart

class MapUtils {
  static Future<List<LatLng>> getPolyline(
      String apiKey, LatLng startLocation, LatLng endLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      return polylineCoordinates;
    } else {
      throw Exception("No polyline points found");
    }
  }
}

class LiveLocationTrackingWidget extends StatefulWidget {
  const LiveLocationTrackingWidget({Key? key}) : super(key: key);

  @override
  State<LiveLocationTrackingWidget> createState() =>
      _LiveLocationTrackingWidgetState();
}

class _LiveLocationTrackingWidgetState
    extends State<LiveLocationTrackingWidget> {
  final LocationService _locationService = LocationService();
  List<LatLng> _polylineCoordinates = [];
  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  void _initLocation() {
    _locationService.getLocation().then((locationData) {
      if (locationData != null) {
        // Handle initial location data
        // ...
      }
    });

    _locationService.onLocationChanged.listen((locationData) {
      // Handle location changes
      // ...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location Tracking'),
      ),
      body: _buildMap(),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(28.6139, 77.2090), // Delhi
        zoom: 5,
      ),
      markers: {
        const Marker(
          markerId: MarkerId("Delhi"),
          position: LatLng(28.6139, 77.2090),
          infoWindow: InfoWindow(title: "Delhi"),
        ),
        const Marker(
          markerId: MarkerId("Kanyakumari"),
          position: LatLng(8.0883, 77.5385), // Kanyakumari
          infoWindow: InfoWindow(title: "Kanyakumari"),
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("track"),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      },
      onMapCreated: (mapController) {
        _getPolyline();
      },
    );
  }

  Future<void> _getPolyline() async {
    LatLng startLocation = const LatLng(28.6139, 77.2090); // Delhi
    LatLng endLocation = const LatLng(8.0883, 77.5385); // Kanyakumari

    try {
      _polylineCoordinates = await MapUtils.getPolyline(
        "AIzaSyDTqC0SJ5Y72H4SUf8MUF-YcGSfsnRLGa0",
        startLocation,
        endLocation,
      );
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching polyline: $e");
      }
      // Handle polyline fetching error
    }
  }
}
