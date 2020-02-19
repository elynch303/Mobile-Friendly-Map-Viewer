import 'dart:core';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// ui standard
final standardWidth = 375.0;
final standardHeight = 815.0;

/// late init
double screenWidth;
double screenHeight;

/// scale [height] by [standardHeight]
double realH(double height) {
  assert(screenHeight != 0.0);
  return height / standardHeight * screenHeight;
}

// scale [width] by [ standardWidth ]
double realW(double width) {
  assert(screenWidth != 0.0);
  return width / standardWidth * screenWidth;
}

getPOIStatusColor(String satus){
  var color;
  switch (satus) {
    case 'application':
      color = Colors.cyanAccent;
      break;
    case 'listing':
      color = Colors.greenAccent;
      break;
    case 'challenged':
      color = Colors.pinkAccent;
      break; 
    case 'removed':
      color = Colors.redAccent;
      break;   
  }
  return color;
}