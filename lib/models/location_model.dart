import 'package:scoped_model/scoped_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationModel extends Model{
  var _viewLocation = LatLng(43.666667, -79.416667);
  var _pois;
  var _boundingBox;

  get viewLocation => _viewLocation;
  get boundingBox => _boundingBox;
  get pois => _pois;

  void updateViewLocation(double lat, double lng){
    _viewLocation = LatLng(lat, lng);
    notifyListeners();
  }

  void updateBoundingBox(LatLngBounds bBox){
    _boundingBox = bBox;
    notifyListeners();
  }

  void updatePOIS(pois){
    _pois = pois;
    notifyListeners();
  }

}