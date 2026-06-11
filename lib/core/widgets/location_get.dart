import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {

  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      // 1. Check if GPS is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return null;
      }

      // 2. Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // 3. Get current position (FAST + STABLE)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // 4. Extract coordinates
      final latitude = double.parse(
        position.latitude.toStringAsFixed(6),
      );

      final longitude = double.parse(
        position.longitude.toStringAsFixed(6),
      );

      // 5. Convert to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      final place = placemarks.first;

      // 6. Build clean address
      final fullAddress = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e.toString().trim().isNotEmpty).join(", ");
      print("Full Address: $fullAddress");

      // 7. Return data
      return {
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": position.accuracy,

        "address1": place.street ?? "",
        "landmark": place.name ?? "",
        "area": place.subLocality ?? "",
        "city": place.locality ?? "",
        "district": place.subAdministrativeArea ?? "",
        "state": place.administrativeArea ?? "",
        "pincode": place.postalCode ?? "",
        "country": place.country ?? "",

        "fullAddress": fullAddress,
      };

    } catch (e) {
      print("Location Error: $e");
      return null;
    }
  }
}