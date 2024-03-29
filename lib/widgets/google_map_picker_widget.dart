import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// do not import this yourself

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({Key? key}) : super(key: key);
  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  PickResult? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      resizeToAvoidBottomInset: false,
      apiKey:
          Platform.isAndroid ? "AIzaSyDTqC0SJ5Y72H4SUf8MUF-YcGSfsnRLGa0" : "",
      hintText: "Find a place ...",
      searchingText: "Please wait ...",
      selectText: "Select place",
      outsideOfPickAreaText: "Place not in area",
      initialPosition: const LatLng(-33.8567844, 151.213108),
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePinPointingSearch: true,
      usePlaceDetailSearch: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      onPlacePicked: (PickResult result) {
        setState(() {
          selectedPlace = result;
          Map<String, String?> placePicked = {
            'destinationName': selectedPlace!.name.toString(),
            'coordinates':
                '${selectedPlace?.geometry!.location.lat},${selectedPlace?.geometry!.location.lng}'
          };
          Navigator.of(context).pop(placePicked);
        });
      },
    );
  }
}
