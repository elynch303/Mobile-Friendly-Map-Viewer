import 'package:geohash/geohash.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class POIModel {
  final String listingSince;
  final String type;
  final String createdAt;
  final String deposit;
  final String listingHash;
  final String owner;
  final String geohash;
  final String name;
  final List tags;
  final double lat;
  final double lng;

  POIModel(
      {this.listingSince,
      this.type,
      this.createdAt,
      this.deposit,
      this.listingHash,
      this.owner,
      this.geohash,
      this.lat,
      this.lng,
      this.name,
      this.tags,
      LatLng latlng});

  factory POIModel.fromJson(Map<String, dynamic> json) {
    var state = json['state'];
    var status = state["status"];
    var geoPoint = Geohash.decode(json['geohash']);
    return POIModel(
      listingSince: status['listingSince'],
      type: status['type'],
      createdAt: state['createdAt'],
      deposit: state['deposit'],
      listingHash: json['listingHash'],
      owner: json['owner'],
      geohash: json['geohash'],
      lat: geoPoint.x, 
      lng: geoPoint.y,
      name: json['name'],
      tags: json['tags'],
    );
    
  }
}
