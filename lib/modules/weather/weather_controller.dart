// lib/controllers/weather_controller.dart
import 'package:ap_news/modules/weather/weather_model.dart';
import 'package:ap_news/modules/weather/weather_services.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class WeatherController extends GetxController {
  final WeatherService service;

  WeatherController({ required this.service });

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<WeatherModel> weather = Rxn<WeatherModel>();

  @override
  void onInit() {
    super.onInit();
    // Optionally load on init if you want
    // fetchByDeviceLocation();
  }

  Future<void> fetchByLatLon(double lat, double lon) async {
    try {
      isLoading.value = true;
      error.value = '';
      final json = await service.fetchCurrentByLatLon(lat: lat, lon: lon);
      weather.value = WeatherModel.fromJson(json);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchByDeviceLocation() async {
    try {
      isLoading.value = true;
      error.value = '';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
          error.value = 'Location permission denied';
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      await fetchByLatLon(pos.latitude, pos.longitude);
    } catch (e) {
      error.value = 'Could not get weather: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
