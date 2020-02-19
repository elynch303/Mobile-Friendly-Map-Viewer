import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foam_map/models/location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'components/components.dart';
import 'components/map_view.dart';
import 'helper/ui_helper.dart';
import 'api.dart' as api;

class MapSpace extends StatefulWidget {
  MapSpace({Key key, @required this.androidFusedLocation, this.model,}) : super(key: key);
  final bool androidFusedLocation;
  LocationModel model;
  @override
  _MapSpaceState createState() => _MapSpaceState();
}

class _MapSpaceState extends State<MapSpace> with TickerProviderStateMixin {

  AnimationController animationControllerExplore;
  AnimationController animationControllerSearch;
  AnimationController animationControllerMenu;
  CurvedAnimation curve;
  Animation<double> animation;
  Animation<double> animationW;
  Animation<double> animationR;

  /// get currentOffset percent
  get currentExplorePercent => max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  get currentSearchPercent => max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

  var offsetExplore = 0.0;
  var offsetSearch = 0.0;
  var offsetMenu = 0.0;

  bool isExploreOpen = false;
  bool isSearchOpen = false;
  bool isMenuOpen = false;

  /// search drag callback
  void onSearchHorizontalDragUpdate(details) {
    offsetSearch -= details.delta.dx;
    if (offsetSearch < 0) {
      offsetSearch = 0;
    } else if (offsetSearch > (347 - 68.0)) {
      offsetSearch = 347 - 68.0;
    }
    setState(() {});
  }

  /// explore drag callback
  void onExploreVerticalUpdate(details) {
    offsetExplore -= details.delta.dy;
    if (offsetExplore > 644) {
      offsetExplore = 644;
    } else if (offsetExplore < 0) {
      offsetExplore = 0;
    }
    setState(() {});
  }

  /// animate Explore
  ///
  /// if [open] is true , make Explore open
  /// else make Explore close
  void animateExplore(bool open) {
    animationControllerExplore = AnimationController(
        duration: Duration(
            milliseconds: 1 + (800 * (isExploreOpen ? currentExplorePercent : (1 - currentExplorePercent))).toInt()),
        vsync: this);
    curve = CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
    animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetExplore = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isExploreOpen = open;
        }
      });
    animationControllerExplore.forward();
  }

  void animateSearch(bool open) {
    animationControllerSearch = AnimationController(
        duration: Duration(
            milliseconds: 1 + (800 * (isSearchOpen ? currentSearchPercent : (1 - currentSearchPercent))).toInt()),
        vsync: this);
    curve = CurvedAnimation(parent: animationControllerSearch, curve: Curves.ease);
    animation = Tween(begin: offsetSearch, end: open ? 347.0 - 68.0 : 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetSearch = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isSearchOpen = open;
        }
      });
    animationControllerSearch.forward();
  }

  void animateMenu(bool open) {
    animationControllerMenu = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve = CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
    animation = Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetMenu = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isMenuOpen = open;
        }
      });
    animationControllerMenu.forward();
  }

  getCurrentLocation() async{
    var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var bBox = LatLngBounds(southwest: LatLng(position.latitude - 15, position.longitude - 15), northeast: LatLng(position.latitude + 15, position.longitude + 15));
    var pois = api.getPOI(bBox.northeast.latitude, bBox.northeast.longitude, bBox.southwest.latitude, bBox.southwest.longitude);
    widget.model.updateViewLocation(position.latitude, position.longitude);
    widget.model.updateBoundingBox(bBox);
    widget.model.updatePOIS(pois);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerExplore?.dispose();
    animationControllerSearch?.dispose();
    animationControllerMenu?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              //map
              MapView( model: widget.model),
              //explore
              ExploreWidget(
                currentExplorePercent: currentExplorePercent,
                currentSearchPercent: currentSearchPercent,
                animateExplore: animateExplore,
                isExploreOpen: isExploreOpen,
                onVerticalDragUpdate: onExploreVerticalUpdate,
                onPanDown: () => animationControllerExplore?.stop(),
              ),
              // //explore content
              ExploreContentWidget(
                currentExplorePercent: currentExplorePercent,
              ),
              //recent search
              RecentSearchWidget(
                currentSearchPercent: currentSearchPercent,
              ),
              //search
              SearchWidget(
                currentSearchPercent: currentSearchPercent,
                currentExplorePercent: currentExplorePercent,
                isSearchOpen: isSearchOpen,
                animateSearch: animateSearch,
                onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
                onPanDown: () => animationControllerSearch?.stop(),
              ),
              //search back
              SearchBackWidget(
                currentSearchPercent: currentSearchPercent,
                animateSearch: animateSearch,
                isSearchOpen: isSearchOpen,
              ),
              //layer button
              MapButton(
                currentExplorePercent: currentExplorePercent,
                currentSearchPercent: currentSearchPercent,
                bottom: 148,
                offsetX: -71,
                width: 71,
                height: 71,
                isRight: false,
                icon: Icons.layers,
              ),
              //directions button
              MapButton(
                currentSearchPercent: currentSearchPercent,
                currentExplorePercent: currentExplorePercent,
                bottom: 243,
                offsetX: -68,
                width: 68,
                height: 71,
                icon: Icons.directions,
                iconColor: Colors.white,
                gradient: const LinearGradient(colors: [
                  Color(0xFF59C2FF),
                  Color(0xFF1270E3),
                ]),
              ),
              //my_location button
              MapButton(
                currentSearchPercent: currentSearchPercent,
                currentExplorePercent: currentExplorePercent,
                bottom: 148,
                offsetX: -68,
                width: 68,
                height: 71,
                icon: Icons.my_location,
                iconColor: Colors.blue,
              ),
              //menu button
              Positioned(
                bottom: realH(53),
                left: realW(-71 * (currentExplorePercent + currentSearchPercent)),
                child: GestureDetector(
                  onTap: () {
                    animateMenu(true);
                  },
                  child: Opacity(
                    opacity: 1 - (currentSearchPercent + currentExplorePercent),
                    child: Container(
                      width: realW(71),
                      height: realH(71),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: realW(17)),
                      child: Icon(
                        Icons.menu,
                        size: realW(34),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(realW(36)), topRight: Radius.circular(realW(36))),
                          boxShadow: [
                            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: realW(36)),
                          ]),
                    ),
                  ),
                ),
              ),
              //menu
              MenuWidget(currentMenuPercent: currentMenuPercent, animateMenu: animateMenu),
            ],
          ),
        ),
      ),
    );
  }
}
