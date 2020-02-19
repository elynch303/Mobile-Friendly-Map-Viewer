import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/location_model.dart';

import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final LocationModel _locationModel = LocationModel();
    return new ScopedModel<LocationModel>(
      model: _locationModel,
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foam Map',
        theme: ThemeData(
          primaryColor: Color(0xFF707070),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        ),
        home: MapSpace(androidFusedLocation: false, model: _locationModel),
      ),
    );
  }
}
