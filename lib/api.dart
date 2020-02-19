import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/POIModel.dart';

// Future<http.Response> getGlobalStats() {
//   return http.get('https://map-api-direct.foam.space/stats/global');
// }

Future<http.Response> getPOI(neLat, neLng, swLat, swLng) async {

  final response = await http.get(
      'https://map-api-direct.foam.space/poi/filtered?limit=101&neLat=43.66738934147246&neLng=-79.34959043550076&offset=0&sort=most_value&status=application&status=challenged&status=listing&swLat=43.63052100088476&swLng=-79.4195007644');
  var poiList;
  if (response.statusCode == 200) {
    var poisRaw = json.decode(response.body);
    poiList =
        (poisRaw as List).map((data) => new POIModel.fromJson(data)).toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load post');
  }
  return poiList;
}