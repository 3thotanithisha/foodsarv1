import 'dart:async';
import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:foodsarv01/firebase_options.dart';
import 'package:foodsarv01/screen/auth/signup_screen.dart';
import 'package:foodsarv01/screen/redirect_screen.dart';
import 'package:foodsarv01/utils/transport_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late GoogleMapController mapController;
  final Completer<GoogleMapController> completer = Completer();
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDTqC0SJ5Y72H4SUf8MUF-YcGSfsnRLGa0";

  List<Marker> markers = []; //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = const LatLng(27.6683619, 85.3101895);
  LatLng endLocation = const LatLng(29.6688312, 88.3077329);

  @override
  void initState() {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      log(result.points.toString());
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log(result.errorMessage.toString());
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.light(),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (FirebaseAuth.instance.currentUser!.email
                  .toString()
                  .contains('@transport.com')) {
                return const TNavBar();
              } else {
                return Stack(
                  children: [
                    const RedirectScreen(),
                    // Positioned.fill(
                    //   child: GoogleMap(
                    //     //Map widget from google_maps_flutter package
                    //     zoomGesturesEnabled: true, //enable Zoom in, out on map
                    //     initialCameraPosition: CameraPosition(
                    //       //innital position in map
                    //       target: startLocation, //initial position
                    //       zoom: 10.0, //initial zoom level
                    //     ),
                    //     markers: markers.toSet(), //markers to show on map
                    //     polylines:
                    //         Set<Polyline>.of(polylines.values), //polylines
                    //     mapType: MapType.normal, //map type
                    //     onMapCreated: (controller) {
                    //       mapController = controller;
                    //       if (!completer.isCompleted) {
                    //         completer.complete(controller);
                    //       }
                    //     },
                    //   ),
                    // )
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return const SignUpScreen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const SignUpScreen();
        },
      ),
    );
  }
}
