import 'package:google_maps_webservice/geocoding.dart';
import 'package:readymadeGroceryApp/service/constants.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtils {
  final geoCoding = GoogleMapsGeocoding(apiKey: Constants.googleMapApiKey);

  final places = GoogleMapsPlaces(apiKey: Constants.googleMapApiKey);

  Future<List<Prediction>> getSuggestions(suggestion) async {
    final res = await places.autocomplete(suggestion);
    var result = res.predictions.map((r) => r).toList();
    return result;
  }

  Future<String?> getAddressFromPlaceId(String placeId) async {
    final res = await places.getDetailsByPlaceId(placeId);
    return res.result.formattedAddress;
  }

  Future<Location?> getLatLngFromPlaceId(String placeId) async {
    final res = await places.getDetailsByPlaceId(placeId);
    return res.result.geometry?.location;
  }

  Future<GeocodingResult> getAddressFromLatLng(LatLng? latlng) async {
    final res = await geoCoding.searchByLocation(
      Location(lat: latlng!.latitude, lng: latlng.longitude),
    );
    return res.results.first;
  }
}
