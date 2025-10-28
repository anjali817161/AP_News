import 'package:geolocator/geolocator.dart';

Future<Position?> requestAndGetLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Prompt user to enable location services (open settings)
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // permissions are denied
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are permanently denied; open app settings
    await Geolocator.openAppSettings();
    return null;
  }

  // OK: get position
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}
