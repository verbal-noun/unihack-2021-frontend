import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final List location;
  final List target;
  MapView({this.location, this.target});
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng location;
  LatLng target;

  LatLng _northeastCoordinates;
  LatLng _southwestCoordinates;

  CameraPosition camera;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    print(widget.location);
    location = LatLng(widget.location[0], widget.location[1]);
    target = LatLng(widget.target[0], widget.target[1]);
    camera = CameraPosition(
      target: location,
      zoom: 14.4746,
    );

    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      position: location,
      icon: BitmapDescriptor.defaultMarker,
    );
    Marker stopMarker = Marker(
        markerId: MarkerId('stop'),
        position: target,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    markers.add(startMarker);
    markers.add(stopMarker);

    if (location.latitude <= target.latitude) {
      _southwestCoordinates = location;
      _northeastCoordinates = target;
    } else {
      _southwestCoordinates = target;
      _northeastCoordinates = location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              mapType: MapType.terrain,
              initialCameraPosition: camera,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // controller.animateCamera(CameraUpdate.newLatLngBounds(
                //     LatLngBounds(
                //         northeast: _northeastCoordinates,
                //         southwest: _southwestCoordinates),
                //     100.0));
              },
            ),
          ],
        ),
      ),
    );
  }
}
