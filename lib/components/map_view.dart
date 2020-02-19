import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/gestures.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/location_model.dart';
import '../helper/ui_helper.dart' as uiHelper;


class MapView extends StatefulWidget {
  MapView({Key key, this.model,}) : super(key: key);
  final LocationModel model;
  MapboxMapController mapController;
  LatLngBounds boundingBox;
  @override
  State<StatefulWidget> createState() => MapViewState();
}

class MapViewState extends State<MapView>{
  LocationModel model;
  MapboxMapController mapController;
  //CameraPosition _cPosition;
  LatLngBounds boundingBox;
  String _styleString = MapboxStyles.DARK;
  List pois;
  int _circleCount = 0;

  onMapCreated(MapboxMapController controller) async{
    mapController = controller;
    widget.mapController = controller;
    controller.addListener(_onMapChanged);
  }

  // getPOIS(LatLngBounds bBox) async{
  //   pois = await api.getPOI(bBox.northeast.latitude, bBox.northeast.longitude, bBox.southwest.latitude, bBox.southwest.longitude);
  //   widget.model.updatePOIS(pois);
  //   return pois;
  // }

  _onMapChanged() async{
   if(widget.model.pois != null){
      _addPois(mapController, widget.model.pois);
    }
  }
    
  _addPois(MapboxMapController controller, pois){
    for (var poi in pois) {
      var statusColor = uiHelper.getPOIStatusColor(poi.type);
      controller.addCircle(
        CircleOptions(
            geometry: LatLng(
              poi.lat + sin(_circleCount * pi / 6.0) / 20.0,
              poi.lng+ cos(_circleCount * pi / 6.0) / 20.0,
            ),
            circleColor: statusColor),
      );
      setState(() {
        _circleCount += 1;
      });
    }
  }
    
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LocationModel>(
        builder: (BuildContext context, Widget child, LocationModel model) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: MapboxMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: model.viewLocation,
                zoom: 12.0,
              ),
              styleString: _styleString,
              myLocationEnabled: false,
              gestureRecognizers:
              <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
          );
        });
  }
}