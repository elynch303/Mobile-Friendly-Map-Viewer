import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() => runApp(FoamMap());

class FoamMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapSpace(),
    );
  }
}

class MapSpace extends StatefulWidget {
  MapSpace({Key key}) : super(key: key);
  @override
  _MapSpaceState createState() => _MapSpaceState();
}

class _MapSpaceState extends State<MapSpace> {
  final LatLng center = const LatLng(32.080664, 34.9563837);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: MapboxMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 11.0,
                ),
                gestureRecognizers:
                <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                  ),
                ].toSet(),
              ),
            ),
          ]
        ),
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: "airport-15"));
    controller.addLine(
      LineOptions(
        geometry: [
          LatLng(-33.86711, 151.1947171),
          LatLng(-33.86711, 151.1947171),
          LatLng(-32.86711, 151.1947171),
          LatLng(-33.86711, 152.1947171),
        ],
        lineColor: "#ff0000",
        lineWidth: 7.0,
        lineOpacity: 0.5,
      ),
    );
  }
}
