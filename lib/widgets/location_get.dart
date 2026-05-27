import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class LocationHelper {
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      // Permission
      LocationPermission permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Position
      Position position =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      

      Placemark place = placemarks.first;

      return {
        "latitude": position.latitude,
        "longitude": position.longitude,

        // Address Parts
        "name": place.name,
        "street": place.street,
        "subLocality": place.subLocality,
        "locality": place.locality,
        "district": place.subAdministrativeArea,
        "state": place.administrativeArea,
        "pincode": place.postalCode,
        "country": place.country,

        // Full Address
        "fullAddress":
            "${place.name}, "
            "${place.street}, "
            "${place.subLocality}, "
            "${place.locality}, "
            "${place.administrativeArea}, "
            "${place.postalCode}, "
            "${place.country}",

        "position": position,
      };
    } catch (e) {
      print(e);
      return null;
    }
  }
}