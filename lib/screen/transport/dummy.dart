import 'package:flutter/material.dart';
import 'package:foodsarv01/widgets/live_location_tracking_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class Navi extends StatefulWidget {
  const Navi({Key? key}) : super(key: key);

  @override
  State<Navi> createState() => _NaviState();
}

class _NaviState extends State<Navi> {
  @override
  void initState() {
    super.initState();
    Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: LiveLocationTrackingWidget(),
    ));
  }
}
