import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: GoogleMapsWidget(
                  apiKey: Platform.isAndroid
                      ? "AIzaSyDTqC0SJ5Y72H4SUf8MUF-YcGSfsnRLGa0"
                      : "",
                  key: mapsWidgetController,
                  sourceLatLng: const LatLng(
                    40.484000837597925,
                    -3.369978368282318,
                  ),
                  destinationLatLng: const LatLng(
                    40.48017307700204,
                    -3.3618026599287987,
                  ),
                  sourceMarkerIconInfo: const MarkerIconInfo(
                    infoWindowTitle: "This is source name",
                    assetPath: "assets/images/house-marker-icon.png",
                  ),
                  destinationMarkerIconInfo: const MarkerIconInfo(
                    assetPath: "assets/images/restaurant-marker-icon.png",
                  ),
                  driverMarkerIconInfo: MarkerIconInfo(
                    infoWindowTitle: "Alex",
                    assetPath: "assets/images/driver-marker-icon.png",
                    onTapMarker: (currentLocation) {
                      if (kDebugMode) {
                        print("Driver is currently at $currentLocation");
                      }
                    },
                    assetMarkerSize: const Size.square(125),
                    rotation: 90,
                  ),
                  updatePolylinesOnDriverLocUpdate: true,
                  onPolylineUpdate: (_) {
                    if (kDebugMode) {
                      print("Polyline updated");
                    }
                  },
                  driverCoordinatesStream: Stream.periodic(
                    const Duration(milliseconds: 500),
                    (i) => LatLng(
                      40.47747872288886 + i / 10000,
                      -3.368043154478073 - i / 10000,
                    ),
                  ),
                  totalTimeCallback: (time) {
                    if (kDebugMode) {
                      print(time);
                    }
                  },
                  totalDistanceCallback: (distance) {
                    if (kDebugMode) {
                      print(distance);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          mapsWidgetController.currentState!.setSourceLatLng(
                            LatLng(
                              40.484000837597925 * (Random().nextDouble()),
                              -3.369978368282318,
                            ),
                          );
                        },
                        child: const Text('Update source'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final googleMapsCon = await mapsWidgetController
                              .currentState!
                              .getGoogleMapsController();
                          googleMapsCon.showMarkerInfoWindow(
                            MarkerIconInfo.sourceMarkerId,
                          );
                        },
                        child: const Text('Show source info'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
