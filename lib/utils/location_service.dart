import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static Future<String> getAddressFromGeoPoint(GeoPoint geoPoint) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        geoPoint.latitude,
        geoPoint.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
   
        String address = "${place.street}, ${place.locality}";
        print(address);

        return address;
      } else {
        return "Ubicación no disponible";
      }
    } catch (e) {
      print("Error al obtener la dirección: $e");
      return "Error al obtener la dirección";
    }
  }
}
