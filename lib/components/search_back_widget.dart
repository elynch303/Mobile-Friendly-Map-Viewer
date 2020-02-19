import 'package:flutter/material.dart';
import 'package:foam_map/helper/ui_helper.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/location_model.dart';

class SearchBackWidget extends StatefulWidget {
  final double currentSearchPercent;

  final Function(bool) animateSearch;
  final bool isSearchOpen;

  SearchBackWidget({Key key, this.currentSearchPercent, this.animateSearch, this.isSearchOpen}) : super(key: key);

  @override
  _SearchBackWidgetState createState() => _SearchBackWidgetState();
}

class _SearchBackWidgetState extends State<SearchBackWidget> {
  var searchedPlace;
  var searchedLatLong;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LocationModel>(
      builder: (BuildContext context, Widget child, LocationModel model) {
        return Positioned(
          bottom: realH(53),
          right: realW(27),
          //height: MediaQuery.of(context).size.height,
          child: Opacity(
            opacity: widget.currentSearchPercent,
            child: Container(
              width: realW(340),
              height: !widget.isSearchOpen
                  ? realH(71)
                  : MediaQuery.of(context).size.height - realH(150),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: realW(17)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: realW(15.0), top: realH(10.0)),
                    child: InkWell(
                      onTap: () {
                        widget.animateSearch(false);
                      },
                      child: Transform.scale(
                        scale: widget.currentSearchPercent,
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.arrow_back,
                          size: realW(34),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: realH(15.0),
                        right: realW(15.0)
                      ),
                      child: MapBoxPlaceSearchWidget(
                          height: MediaQuery.of(context).size.height - realH(150),
                          popOnSelect: true,
                          apiKey: "pk.eyJ1IjoiZWwzMDMiLCJhIjoiY2s2NnM1ZTIyMGNjMjNrcWp0b3N4emcwaCJ9.QBg-ZYTqmkfGnV2c-qAc4Q",
                          limit: 10,
                          searchHint: 'Search',
                          onSelected: (place) { 
                            var lat = place.center[0];
                            var lng = place.center[1];
                            model.updateViewLocation(lat, lng);
                          },
                          context: context,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


// FlatButton(
//   onPressed: () {
//     animateSearch(false);
//   },
//   child: Transform.scale(
//     scale: currentSearchPercent,
//     alignment: Alignment.topLeft,
//     child: Icon(
//       Icons.arrow_back,
//       size: realW(34),
//     ),
//   ),
// ),